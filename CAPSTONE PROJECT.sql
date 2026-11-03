/*
=============================================================
Project: Assessing Household Food Security and Dietary Diversity in Nigeria
Dataset: FAO DIEM Monitoring System - Household Survey, Round 3 (2022)
Author: Akinwonjowo Olayinka
Database: Nigeria_Food_Security
Table: dbo.Analysis_Data
=============================================================
*/

-- =========================================================
-- Query 1: Overall Food Insecurity Rate
-- =========================================================
SELECT 
    Food_Insecure,
    COUNT(*) AS Number_of_Households,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dbo.Analysis_Data) AS DECIMAL(5,2)) AS Percentage
FROM 
dbo.Analysis_Data
GROUP BY 
    Food_Insecure
ORDER BY 
    Food_Insecure;

-- =========================================================
-- Query 2: Food Insecurity Rate by State
-- =========================================================
SELECT 
    State,
    COUNT(*) AS Total_Households,
    SUM(CASE WHEN Food_Insecure = 1 THEN 1 ELSE 0 END) AS Food_Insecure_Count,
    CAST(SUM(CASE WHEN Food_Insecure = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Food_Insecure_Percentage
FROM 
    dbo.Analysis_Data
GROUP BY 
    State
ORDER BY 
    Food_Insecure_Percentage DESC;

-- =========================================================
-- Query 3: Food Insecurity by Household Head Gender
-- =========================================================
SELECT 
    HH_Gender
,
    COUNT(*) AS Total_Households,
    SUM(CASE WHEN Food_Insecure = 1 THEN 1 ELSE 0 END) AS Food_Insecure_Count,
    CAST(SUM(CASE WHEN Food_Insecure = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Food_Insecure_Percentage
FROM 
    dbo.Analysis_Data
GROUP BY 
   HH_Gender

ORDER BY 
    Food_Insecure_Percentage DESC;

-- =========================================================
-- Query 4: Average HDDS Score by Food Insecurity Status
-- =========================================================
SELECT 
    Food_Insecure,
    COUNT(*) AS Number_of_Households,
    CAST(AVG(CAST(HDDS_Score AS FLOAT)) AS DECIMAL(5,2)) AS Average_HDDS
FROM 
    dbo.Analysis_Data
WHERE 
    HDDS_Score IS NOT NULL
GROUP BY 
    Food_Insecure
ORDER BY 
    Food_Insecure;

-- =========================================================
-- Query 5: LCSI Distribution by Food Insecurity Status
-- =========================================================
SELECT 
    LCSI,
    CASE 
        WHEN LCSI = 0 THEN 'No Coping'
        WHEN LCSI = 1 THEN 'Stress'
        WHEN LCSI = 2 THEN 'Crisis'
        WHEN LCSI = 3 THEN 'Emergency'
        ELSE 'Unknown'
    END AS LCSI_Category,
    Food_Insecure,
    COUNT(*) AS Number_of_Households,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY Food_Insecure) AS DECIMAL(5,2)) AS Percentage_Within_Group
FROM 
    dbo.Analysis_Data
GROUP BY 
    LCSI, Food_Insecure
ORDER BY 
    Food_Insecure, LCSI;

-- =========================================================
-- Query 6: Average HDDS by State
-- =========================================================
SELECT 
    State,
    COUNT(*) AS Total_Households,
    CAST(AVG(CAST(HDDS_Score AS FLOAT)) AS DECIMAL(5,2)) AS Average_HDDS
FROM 
    dbo.Analysis_Data
WHERE 
    HDDS_Score IS NOT NULL
GROUP BY 
    State
ORDER BY 
    Average_HDDS DESC;

-- =========================================================
-- Query 7: Food Insecurity among Households with Key Shocks
-- =========================================================
SELECT 
    'Violence/Insecurity' AS Shock_Type,
    COUNT(*) AS Households_with_Shock,
    SUM(CASE WHEN Food_Insecure = 1 THEN 1 ELSE 0 END) AS Food_Insecure_Count,
    CAST(SUM(CASE WHEN Food_Insecure = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Food_Insecure_Percentage
FROM 
    dbo.Analysis_Data
WHERE 
    shock_violenceinsecconf = 1

UNION ALL

SELECT 
    'Flood' AS Shock_Type,
    COUNT(*) AS Households_with_Shock,
    SUM(CASE WHEN Food_Insecure = 1 THEN 1 ELSE 0 END) AS Food_Insecure_Count,
    CAST(SUM(CASE WHEN Food_Insecure = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Food_Insecure_Percentage
FROM 
    dbo.Analysis_Data
WHERE 
    shock_flood = 1;