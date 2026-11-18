USE Ventas_Tech_DB;

--Consulta 1 - Resumen ejecutivo mensual
SELECT 
MONTH(fecha_venta) AS mes,
SUM(precio_unitario*cantidad) AS total_facturado,
COUNT(id_venta) AS total_pedidos,
AVG(precio_unitario*cantidad) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

--Consulta 2 - Ranking de productos
SELECT TOP 5
id_producto,
SUM(precio_unitario*cantidad) AS total_facturado,
SUM(cantidad) AS unidades_vendidas
FROM ventas
GROUP BY id_producto
ORDER BY(total_facturado) DESC;

--Consulta 3 - Clientes recurrentes
SELECT
id_cliente,
COUNT(id_venta) AS total_pedidos,
SUM(precio_unitario*cantidad) AS total_gastado
FROM ventas
GROUP BY id_cliente 
HAVING COUNT(id_venta) > 1;

--Consulta 4 - Productos por encima/por debajo del promedio
WITH facturacion_por_producto AS (
SELECT
id_producto,
SUM(precio_unitario*cantidad) AS total_facturado
FROM ventas
GROUP BY id_producto
)
SELECT
id_producto,
total_facturado,
CASE 
WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_por_producto)
THEN 'Por encima'
ELSE 'Por debajo'
END AS facturacion_promedio
FROM facturacion_por_producto;

--Hallazgos
--Los productos 1 y 3 concentran la mayor parte de la facturación total (4950 de 6444).
--El producto 2 es el quinto en facturación (364), aunque vendió 13 unidades, más del triple que cualquier otro producto que tuvo mayor facturación, demostrando que su precio unitario es bajo. 
--Los 5 clientes hicieron exactamente 2 pedidos, pero su total gastado es muy disimil (entre 510 del cliente 4 y 2640 del cliente 1).
--Solo 2 de los 6 productos comercializados (1 y 3) superan el promedio de facturación por producto (1074). Los otros cuatro facturan entre 360 y 390, lo que demuestra que el promedio está muy influenciado por el producto 1.
