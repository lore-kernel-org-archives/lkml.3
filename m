Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaK0BRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 20:17:06 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18047 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaK0BRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 20:17:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 26 Nov 2014 17:15:16 -0800
From: Navneet Kumar <navneetk@nvidia.com>
To: <rui.zhang@intel.com>, <edubezval@gmail.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        navneet kumar <navneetk@nvidia.com>
Subject: [PATCH 2/3] thermal: of: consolidate sensor callbacks as ops
Date: Wed, 26 Nov 2014 17:16:28 -0800
Message-ID: <1417050989-25405-2-git-send-email-navneetk@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1417050989-25405-1-git-send-email-navneetk@nvidia.com>
References: <1417050989-25405-1-git-send-email-navneetk@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: navneet kumar <navneetk@nvidia.com>

Consolidate all the sensor callbacks (get_temp/get_trend)
into a 'thermal_of_sensor_ops' struct.

As a part of this, introduce a 'thermal_zone_of_sensor_register2'
sensor API that accepts sensor_ops instead of the two callbacks
as separate arguments to the register function.

Modify the older version of register function to call register2.

Adjust all the references to get_temp/get_trend callbacks.

Signed-off-by: navneet kumar <navneetk@nvidia.com>
---
 drivers/thermal/of-thermal.c | 78 ++++++++++++++++++++++++++++----------------
 include/linux/thermal.h      | 14 ++++++++
 2 files changed, 64 insertions(+), 28 deletions(-)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index cf9ee3e82fee..3d47a0cf3825 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -96,8 +96,7 @@ struct __thermal_zone {
 
 	/* sensor interface */
 	void *sensor_data;
-	int (*get_temp)(void *, long *);
-	int (*get_trend)(void *, long *);
+	struct thermal_of_sensor_ops sops;
 };
 
 /***   DT thermal zone device callbacks   ***/
@@ -107,10 +106,10 @@ static int of_thermal_get_temp(struct thermal_zone_device *tz,
 {
 	struct __thermal_zone *data = tz->devdata;
 
-	if (!data->get_temp)
+	if (!data->sops.get_temp)
 		return -EINVAL;
 
-	return data->get_temp(data->sensor_data, temp);
+	return data->sops.get_temp(data->sensor_data, temp);
 }
 
 static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
@@ -120,10 +119,10 @@ static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
 	long dev_trend;
 	int r;
 
-	if (!data->get_trend)
+	if (!data->sops.get_trend)
 		return -EINVAL;
 
-	r = data->get_trend(data->sensor_data, &dev_trend);
+	r = data->sops.get_trend(data->sensor_data, &dev_trend);
 	if (r)
 		return r;
 
@@ -324,8 +323,7 @@ static struct thermal_zone_device_ops of_thermal_ops = {
 static struct thermal_zone_device *
 thermal_zone_of_add_sensor(struct device_node *zone,
 			   struct device_node *sensor, void *data,
-			   int (*get_temp)(void *, long *),
-			   int (*get_trend)(void *, long *))
+			   struct thermal_of_sensor_ops *sops)
 {
 	struct thermal_zone_device *tzd;
 	struct __thermal_zone *tz;
@@ -337,8 +335,9 @@ thermal_zone_of_add_sensor(struct device_node *zone,
 	tz = tzd->devdata;
 
 	mutex_lock(&tzd->lock);
-	tz->get_temp = get_temp;
-	tz->get_trend = get_trend;
+	if (sops)
+		memcpy(&(tz->sops), sops, sizeof(*sops));
+
 	tz->sensor_data = data;
 
 	tzd->ops->get_temp = of_thermal_get_temp;
@@ -349,15 +348,15 @@ thermal_zone_of_add_sensor(struct device_node *zone,
 }
 
 /**
- * thermal_zone_of_sensor_register - registers a sensor to a DT thermal zone
+ * thermal_zone_of_sensor_register2 - registers a sensor to a DT thermal zone
  * @dev: a valid struct device pointer of a sensor device. Must contain
  *       a valid .of_node, for the sensor node.
  * @sensor_id: a sensor identifier, in case the sensor IP has more
  *             than one sensors
  * @data: a private pointer (owned by the caller) that will be passed
  *        back, when a temperature reading is needed.
- * @get_temp: a pointer to a function that reads the sensor temperature.
- * @get_trend: a pointer to a function that reads the sensor temperature trend.
+ * @sops: handle to the sensor ops (get_temp/get_trend etc.) provided by the
+ *		sensor to OF.
  *
  * This function will search the list of thermal zones described in device
  * tree and look for the zone that refer to the sensor device pointed by
@@ -370,21 +369,13 @@ thermal_zone_of_add_sensor(struct device_node *zone,
  * The thermal zone temperature trend is provided by the @get_trend function
  * pointer. When called, it will have the private pointer @data back.
  *
- * TODO:
- * 01 - This function must enqueue the new sensor instead of using
- * it as the only source of temperature values.
- *
- * 02 - There must be a way to match the sensor with all thermal zones
- * that refer to it.
- *
  * Return: On success returns a valid struct thermal_zone_device,
  * otherwise, it returns a corresponding ERR_PTR(). Caller must
  * check the return value with help of IS_ERR() helper.
  */
 struct thermal_zone_device *
-thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
-				void *data, int (*get_temp)(void *, long *),
-				int (*get_trend)(void *, long *))
+thermal_zone_of_sensor_register2(struct device *dev, int sensor_id,
+				void *data, struct thermal_of_sensor_ops *sops)
 {
 	struct device_node *np, *child, *sensor_np;
 	struct thermal_zone_device *tzd = ERR_PTR(-ENODEV);
@@ -426,9 +417,8 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
 
 		if (sensor_specs.np == sensor_np && id == sensor_id) {
 			tzd = thermal_zone_of_add_sensor(child, sensor_np,
-							 data,
-							 get_temp,
-							 get_trend);
+							  data,
+							  sops);
 			of_node_put(sensor_specs.np);
 			of_node_put(child);
 			goto exit;
@@ -441,6 +431,38 @@ exit:
 
 	return tzd;
 }
+EXPORT_SYMBOL_GPL(thermal_zone_of_sensor_register2);
+
+/**
+ * thermal_zone_of_sensor_register - registers a sensor to a DT thermal zone
+ * @dev: a valid struct device pointer of a sensor device. Must contain
+ *       a valid .of_node, for the sensor node.
+ * @sensor_id: a sensor identifier, in case the sensor IP has more
+ *             than one sensors
+ * @data: a private pointer (owned by the caller) that will be passed
+ *        back, when a temperature reading is needed.
+ * @get_temp: a pointer to a function that reads the sensor temperature.
+ * @get_trend: a pointer to a function that reads the sensor temperature trend.
+ *
+ * This function calls thermal_zone_of_sensor_register2 after translating
+ * the sensor callbacks into a single structi (sops).
+ *
+ * Return: Bubbles up the return status from thermal_zone_of_register2
+ *
+ */
+struct thermal_zone_device *
+thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
+				void *data, int (*get_temp)(void *, long *),
+				int (*get_trend)(void *, long *))
+{
+	struct thermal_of_sensor_ops sops = {
+		.get_temp = get_temp,
+		.get_trend = get_trend,
+	};
+
+	return thermal_zone_of_sensor_register2(dev, sensor_id, data, &sops);
+
+}
 EXPORT_SYMBOL_GPL(thermal_zone_of_sensor_register);
 
 /**
@@ -476,8 +498,8 @@ void thermal_zone_of_sensor_unregister(struct device *dev,
 	tzd->ops->get_temp = NULL;
 	tzd->ops->get_trend = NULL;
 
-	tz->get_temp = NULL;
-	tz->get_trend = NULL;
+	tz->sops.get_temp = NULL;
+	tz->sops.get_trend = NULL;
 	tz->sensor_data = NULL;
 	mutex_unlock(&tzd->lock);
 }
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index ef90838b36a0..58341c56a01f 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -289,6 +289,11 @@ struct thermal_genl_event {
 	enum events event;
 };
 
+struct thermal_of_sensor_ops {
+	int (*get_temp)(void *, long *);
+	int (*get_trend)(void *, long *);
+};
+
 /* Function declarations */
 #ifdef CONFIG_THERMAL_OF
 struct thermal_zone_device *
@@ -297,6 +302,9 @@ thermal_zone_of_sensor_register(struct device *dev, int id,
 				int (*get_trend)(void *, long *));
 void thermal_zone_of_sensor_unregister(struct device *dev,
 				       struct thermal_zone_device *tz);
+struct thermal_zone_device *
+thermal_zone_of_sensor_register2(struct device *dev, int sensor_id,
+				void *data, struct thermal_of_sensor_ops *sops);
 #else
 static inline struct thermal_zone_device *
 thermal_zone_of_sensor_register(struct device *dev, int id,
@@ -312,6 +320,12 @@ void thermal_zone_of_sensor_unregister(struct device *dev,
 {
 }
 
+static inline struct thermal_zone_device *
+thermal_zone_of_sensor_register2(struct device *dev, int sensor_id,
+				void *data, struct thermal_of_sensor_ops *sops)
+{
+	return NULL;
+}
 #endif
 struct thermal_zone_device *thermal_zone_device_register(const char *, int, int,
 		void *, struct thermal_zone_device_ops *,
-- 
1.8.1.5

