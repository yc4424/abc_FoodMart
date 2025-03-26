-- stores table
CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    city VARCHAR(100),
    store_type VARCHAR(100),
    rating DECIMAL(3, 2) CHECK (rating >= 0 AND rating <= 5)
);

-- vendors table
CREATE TABLE vendors (
    vendor_id INT PRIMARY KEY,
    vendor_name VARCHAR(100)
);

-- aisles table
CREATE TABLE aisles (
    aisle_num INT PRIMARY KEY,
    aisle_name VARCHAR(100),
    store_id INT ,
    FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE CASCADE
);

-- products table with vendor_id as foreign key
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    vendor_id INT,
    aisle_num INT REFERENCES aisles(aisle_num) ON DELETE SET NULL,
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id) ON DELETE SET NULL
);


-- customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_category VARCHAR(50)
);

-- promotions table
CREATE TABLE promotions (
    promo_id INT PRIMARY KEY,











SELECT *
from employees;



--  1. Inventory Overview by Store
-- This query can help management quickly see the inventory levels at each store, crucial for ensuring that stock levels are maintained and for planning re-orders.
SELECT 
    s.store_id, 
    s.city,
    p.product_name, 
    i.quantity_in_stock
FROM 
    inventory i
    JOIN stores s ON i.store_id = s.store_id
    JOIN products p ON i.product_id = p.product_id
ORDER BY 
    s.store_id, 
    i.quantity_in_stock DESC;

	
-- 2. Sales Performance by Product and Store
-- This query is useful for identifying top-performing products and stores, which can assist in marketing and sales strategies.
SELECT 
    s.store_id, 
    s.city,
    p.product_name, 
    COUNT(sale_id) AS total_sales,
    SUM(t.total_cost) AS total_revenue
FROM 
    sales sa
    JOIN transactions t ON sa.transaction_id = t.transaction_id
    JOIN stores s ON t.store_id = s.store_id
    JOIN products p ON sa.product_id = p.product_id
GROUP BY 
    s.store_id, 
    p.product_id
ORDER BY 
    total_revenue DESC;


-- 3. Detailed Customer Purchases with Promotions
-- This query provides insights into customer behavior, including how promotions affect purchasing patterns. This is vital for understanding the effectiveness of marketing campaigns.
SELECT 
    c.customer_id, 
    c.customer_name,
    t.transaction_date,
    p.product_name,
    t.total_cost,
    pr.promotion_type
FROM 
    transactions t
    JOIN customers c ON t.customer_id = c.customer_id
    JOIN sales sa ON t.transaction_id = sa.transaction_id
    JOIN products p ON sa.product_id = p.product_id
    LEFT JOIN promotions pr ON t.promo_id = pr.promo_id
WHERE 
    t.discount_applied = TRUE
ORDER BY 
    t.transaction_date DESC;

-- 4. Employee Shifts and Store Allocation
-- This query helps in managing workforce distribution across different locations, crucial for optimizing operational efficiency.


SELECT 
    e.employee_id,
    e.employee_name,
    e.shift,
    s.city,
    s.store_type
FROM 
    employees e
    JOIN stores s ON e.store_id = s.store_id
ORDER BY 
    s.city, 
    e.shift;

--5.Orders and Vendor Management
-- Understanding supplier relationships and order history can optimize purchasing strategies and ensure timely replenishment of inventory.
SELECT 
    v.vendor_name,
    o.order_date,
    p.product_name,
    o.quantity_ordered
FROM 
    orders o
    JOIN vendors v ON o.vendor_id = v.vendor_id
    JOIN inventory i ON o.inventory_id = i.inventory_id
    JOIN products p ON i.product_id = p.product_id
ORDER BY 
    o.order_date DESC;
