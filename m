Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaAPS2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:28:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:6313 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbaAPS2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:28:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,668,1384329600"; 
   d="scan'208";a="404034998"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCHv5 07/10] Thermal: Create Thermal map sysfs attributes for a zone
Date: Fri, 17 Jan 2014 05:26:24 +0530
Message-Id: <1389916587-2541-8-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
References: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a thermal map sysfs node under
/sys/class/thermal/zoneX/. The thermal map
shows the binding relationship between a sensor
and a cooling device within a particular zone.
This contains entries named mapY_trip_type,
mapY_sensor_name, mapY_cdev_name, mapY_trip_mask,
mapY_weightX.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_core_new.c |  275 ++++++++++++++++++++++++++++++++++++
 include/linux/thermal.h            |   25 ++++
 2 files changed, 300 insertions(+)

diff --git a/drivers/thermal/thermal_core_new.c b/drivers/thermal/thermal_core_new.c
index e6a35f0..62f95c2 100644
--- a/drivers/thermal/thermal_core_new.c
+++ b/drivers/thermal/thermal_core_new.c
@@ -399,6 +399,131 @@ critical_trip_show(struct device *dev,
 	return sprintf(buf, "%d\n", val);
 }
 
+static ssize_t
+map_ttype_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int indx, ret;
+	struct thermal_zone *tz = to_thermal_zone(dev);
+
+	ret = sscanf(attr->attr.name, "map%d_trip_type", &indx);
+	if (!ret)
+		return -EINVAL;
+
+	if (indx < 0 || indx >= MAX_MAPS_PER_ZONE)
+		return -EINVAL;
+
+	mutex_lock(&tz->lock);
+
+	if (!tz->map[indx])
+		goto exit;
+
+	ret = sprintf(buf, "%s\n",
+			tz->map[indx]->trip_type == THERMAL_TRIP_ACTIVE ?
+			"active" : "passive");
+exit:
+	mutex_unlock(&tz->lock);
+	return ret;
+}
+
+static ssize_t map_ts_name_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int indx, ret;
+	struct thermal_zone *tz = to_thermal_zone(dev);
+
+	ret = sscanf(attr->attr.name, "map%d_sensor_name", &indx);
+	if (!ret)
+		return -EINVAL;
+
+	if (indx < 0 || indx >= MAX_MAPS_PER_ZONE)
+		return -EINVAL;
+
+	mutex_lock(&tz->lock);
+
+	if (!tz->map[indx])
+		goto exit;
+
+	ret = sprintf(buf, "%s\n", tz->map[indx]->sensor_name);
+exit:
+	mutex_unlock(&tz->lock);
+	return ret;
+}
+
+static ssize_t map_cdev_name_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int indx, ret;
+	struct thermal_zone *tz = to_thermal_zone(dev);
+
+	ret = sscanf(attr->attr.name, "map%d_cdev_name", &indx);
+	if (!ret)
+		return -EINVAL;
+
+	if (indx < 0 || indx >= MAX_MAPS_PER_ZONE)
+		return -EINVAL;
+
+	mutex_lock(&tz->lock);
+
+	if (!tz->map[indx])
+		goto exit;
+
+	ret = sprintf(buf, "%s\n", tz->map[indx]->cdev_name);
+exit:
+	mutex_unlock(&tz->lock);
+	return ret;
+}
+
+static ssize_t map_trip_mask_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int indx, ret;
+	struct thermal_zone *tz = to_thermal_zone(dev);
+
+	ret = sscanf(attr->attr.name, "map%d_trip_mask", &indx);
+	if (!ret)
+		return -EINVAL;
+
+	if (indx < 0 || indx >= MAX_MAPS_PER_ZONE)
+		return -EINVAL;
+
+	mutex_lock(&tz->lock);
+
+	if (!tz->map[indx])
+		goto exit;
+
+	ret = sprintf(buf, "0x%x\n", tz->map[indx]->trip_mask);
+exit:
+	mutex_unlock(&tz->lock);
+	return ret;
+}
+
+static ssize_t map_weights_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int i, j, ret;
+	struct thermal_zone *tz = to_thermal_zone(dev);
+
+	ret = sscanf(attr->attr.name, "map%d_weight%d", &i, &j);
+	if (!ret)
+		return -EINVAL;
+
+	if (i < 0 || i >= MAX_MAPS_PER_ZONE)
+		return -EINVAL;
+
+	mutex_lock(&tz->lock);
+
+	if (!tz->map[i])
+		goto exit;
+
+	if (j < 0 || j >= tz->map[i]->num_weights)
+		goto exit;
+
+	ret = sprintf(buf, "%d\n", tz->map[i]->weights[j]);
+exit:
+	mutex_unlock(&tz->lock);
+	return ret;
+}
+
 /* Thermal sensor attributes */
 static DEVICE_ATTR_RO(name);
 static DEVICE_ATTR_RO(temp);
@@ -446,6 +571,24 @@ static void __remove_trip_attr(struct thermal_zone *tz, int indx)
 	tz->trip_attr[indx] = NULL;
 }
 
+static void __remove_map_entry(struct thermal_zone *tz, int indx)
+{
+	int i;
+	struct thermal_map_attr *attr;
+
+	attr = tz->map_attr[indx];
+
+	for (i = 0; i < NUM_MAP_ATTRS; i++)
+		device_remove_file(&tz->device, &attr->attrs[i].attr);
+
+	for (i = 0; i < tz->map[indx]->num_weights; i++)
+		device_remove_file(&tz->device, &attr->weights_attr[i].attr);
+
+	kfree(tz->map_attr[indx]);
+	tz->map_attr[indx] = NULL;
+	tz->map[indx] = NULL;
+}
+
 static void remove_sensor_from_zone(struct thermal_zone *tz,
 				struct thermal_sensor *ts)
 {
@@ -470,6 +613,14 @@ static void remove_sensor_from_zone(struct thermal_zone *tz,
 	}
 
 	tz->sensor_indx--;
+
+	/* Remove all mappings associated with this sensor */
+	for (j = 0; j < MAX_MAPS_PER_ZONE; j++) {
+		if (tz->map[j] && !strnicmp(ts->name, tz->map[j]->sensor_name,
+						THERMAL_NAME_LENGTH)) {
+			__remove_map_entry(tz, j);
+		}
+	}
 	mutex_unlock(&tz->lock);
 }
 
@@ -491,6 +642,14 @@ static void remove_cdev_from_zone(struct thermal_zone *tz,
 		tz->cdevs[j] = tz->cdevs[j + 1];
 
 	tz->cdev_indx--;
+
+	/* Remove all mappings associated with this sensor */
+	for (j = 0; j < MAX_MAPS_PER_ZONE; j++) {
+		if (tz->map[j] && !strnicmp(cdev->type, tz->map[j]->cdev_name,
+						THERMAL_NAME_LENGTH)) {
+			__remove_map_entry(tz, j);
+		}
+	}
 	mutex_unlock(&tz->lock);
 }
 
@@ -652,6 +811,71 @@ exit:
 	return ret;
 }
 
+static int create_map_weight_attrs(struct thermal_zone *tz, int num_wts,
+				int indx, struct thermal_map_attr *attr)
+{
+	int i, ret, size;
+	char name[THERMAL_NAME_LENGTH];
+
+	if (!attr || num_wts <= 0)
+		return 0;
+
+	size = sizeof(struct thermal_attr) * num_wts;
+	attr->weights_attr = kzalloc(size, GFP_KERNEL);
+	if (!attr->weights_attr)
+		return -ENOMEM;
+
+	for (i = 0; i < num_wts; i++) {
+		snprintf(name, THERMAL_NAME_LENGTH,
+				"map%d_weight%d", indx, i);
+		ret = create_single_trip_attr(tz, &attr->weights_attr[i],
+				name, map_weights_show);
+		if (ret)
+			goto exit;
+	}
+	return 0;
+
+exit:
+	while (--i >= 0)
+		device_remove_file(&tz->device, &attr->weights_attr[i].attr);
+	kfree(attr->weights_attr);
+	return ret;
+}
+
+static int create_map_attrs(struct thermal_zone *tz, int indx, int num_wts)
+{
+	int i, ret;
+	char name[THERMAL_NAME_LENGTH];
+	struct thermal_map_attr *attr = tz->map_attr[indx];
+
+	static const char *const attr_names[NUM_MAP_ATTRS] = {
+				"map%d_trip_type", "map%d_sensor_name",
+				"map%d_cdev_name", "map%d_trip_mask"};
+
+	static ssize_t (*const rd_ptr[NUM_MAP_ATTRS]) (struct device *dev,
+			struct device_attribute *devattr, char *buf) = {
+				map_ttype_show, map_ts_name_show,
+				map_cdev_name_show, map_trip_mask_show};
+
+	for (i = 0; i < NUM_MAP_ATTRS; i++) {
+		snprintf(name, THERMAL_NAME_LENGTH, attr_names[i], indx);
+		ret = create_single_trip_attr(tz, &attr->attrs[i],
+						name, rd_ptr[i]);
+		if (ret)
+			goto exit_free;
+	}
+
+	ret = create_map_weight_attrs(tz, num_wts, indx, attr);
+	if (ret)
+		goto exit_free;
+
+	return 0;
+exit_free:
+	while (--i >= 0)
+		device_remove_file(&tz->device, &attr->attrs[i].attr);
+	return ret;
+}
+
 /**
  * thermal_sensor_register - register a new thermal sensor
  * @name:	name of the thermal sensor
@@ -1308,3 +1532,54 @@ exit:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(thermal_add_sensor_trip_info);
+
+/**
+ * thermal_add_map_entry - Add Thermal Map information for @tz
+ * @tz:		Thermal zone reference
+ * @map:	Thermal map reference
+ *
+ * Returns 0 on success, otherwise
+ * -EINVAL for invalid paramenters
+ * -EINVAL for array out of bounds
+ * -ENOMEM on kzalloc failures
+ */
+int thermal_add_map_entry(struct thermal_zone *tz, struct thermal_map *map)
+{
+	int ret, indx;
+
+	if (!tz || !map)
+		return -EINVAL;
+
+	mutex_lock(&zone_list_lock);
+
+	/* Find the first unused index which is NULL */
+	for (indx = 0; indx < MAX_MAPS_PER_ZONE; indx++) {
+		if (tz->map[indx] == NULL)
+			break;
+	}
+
+	if (indx >= MAX_MAPS_PER_ZONE) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	tz->map_attr[indx] = kzalloc(sizeof(struct thermal_map_attr),
+						GFP_KERNEL);
+	if (!tz->map_attr[indx]) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	ret = create_map_attrs(tz, indx, map->num_weights);
+	if (ret) {
+		kfree(tz->map_attr[indx]);
+		tz->map_attr[indx] = NULL;
+		goto exit;
+	}
+
+	tz->map[indx] = map;
+exit:
+	mutex_unlock(&zone_list_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(thermal_add_map_entry);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index fe7abc9..24231b7 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -62,6 +62,11 @@
 #define MAX_SENSORS_PER_ZONE		5
 #define MAX_CDEVS_PER_ZONE		5
 
+#define NUM_MAP_ATTRS			4
+
+/* If we map each sensor with every possible cdev for a zone */
+#define MAX_MAPS_PER_ZONE	(MAX_SENSORS_PER_ZONE * MAX_CDEVS_PER_ZONE)
+
 struct thermal_sensor;
 struct thermal_zone_device;
 struct thermal_cooling_device;
@@ -172,6 +177,21 @@ struct thermal_attr {
 	char name[THERMAL_NAME_LENGTH];
 };
 
+struct thermal_map {
+	enum thermal_trip_type trip_type;
+	char cdev_name[THERMAL_NAME_LENGTH];
+	char sensor_name[THERMAL_NAME_LENGTH];
+
+	int trip_mask;
+	int num_weights;
+	int *weights;
+};
+
+struct thermal_map_attr {
+	struct thermal_attr attrs[NUM_MAP_ATTRS];
+	struct thermal_attr *weights_attr;
+};
+
 /*
  * This structure defines the trip points for a sensor.
  * The actual values for these trip points come from
@@ -266,6 +286,10 @@ struct thermal_zone {
 	/* Thermal sensors trip information */
 	struct thermal_trip_point *sensor_trip[MAX_SENSORS_PER_ZONE];
 	struct thermal_trip_attr *trip_attr[MAX_SENSORS_PER_ZONE];
+
+	/* Thermal map information */
+	struct thermal_map *map[MAX_MAPS_PER_ZONE];
+	struct thermal_map_attr *map_attr[MAX_MAPS_PER_ZONE];
 };
 
 /* Structure that holds thermal governor information */
@@ -387,6 +411,7 @@ int thermal_add_cdev_to_zone(struct thermal_zone *,
 struct thermal_cooling_device *thermal_get_cdev_by_name(const char *);
 int thermal_add_sensor_trip_info(struct thermal_zone *,
 			struct thermal_sensor *, struct thermal_trip_point *);
+int thermal_add_map_entry(struct thermal_zone *, struct thermal_map *);
 
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
-- 
1.7.9.5

