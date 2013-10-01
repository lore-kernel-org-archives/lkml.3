Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3JANLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:11:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:33026 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab3JANK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:10:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1013,1371106800"; 
   d="scan'208";a="368223319"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCHv4 6/9] Thermal: Create Thermal map sysfs attributes for a zone
Date: Wed,  2 Oct 2013 00:08:05 +0530
Message-Id: <1380652688-5787-7-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380652688-5787-1-git-send-email-durgadoss.r@intel.com>
References: <1380652688-5787-1-git-send-email-durgadoss.r@intel.com>
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
 drivers/thermal/thermal_core.c |  252 +++++++++++++++++++++++++++++++++++++++-
 include/linux/thermal.h        |   26 +++++
 2 files changed, 277 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index d6e29f6..e1289a4 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -548,6 +548,24 @@ static void __remove_trip_attr(struct thermal_zone *tz, int indx)
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
@@ -572,6 +590,14 @@ static void remove_sensor_from_zone(struct thermal_zone *tz,
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
 
@@ -593,6 +619,14 @@ static void remove_cdev_from_zone(struct thermal_zone *tz,
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
 
@@ -1117,6 +1151,126 @@ critical_trip_show(struct device *dev,
 	return sprintf(buf, "%d\n", val);
 }
 
+static ssize_t
+map_ttype_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int indx, ret = -EINVAL;
+	struct thermal_zone *tz = to_zone(dev);
+
+	if (!sscanf(attr->attr.name, "map%d_trip_type", &indx))
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
+	int indx, ret = -EINVAL;
+	struct thermal_zone *tz = to_zone(dev);
+
+	if (!sscanf(attr->attr.name, "map%d_sensor_name", &indx))
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
+	int indx, ret = -EINVAL;
+	struct thermal_zone *tz = to_zone(dev);
+
+	if (!sscanf(attr->attr.name, "map%d_cdev_name", &indx))
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
+	int indx, ret = -EINVAL;
+	struct thermal_zone *tz = to_zone(dev);
+
+	if (!sscanf(attr->attr.name, "map%d_trip_mask", &indx))
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
+	int i, j, ret = -EINVAL;
+	struct thermal_zone *tz = to_zone(dev);
+
+	if (!sscanf(attr->attr.name, "map%d_weight%d", &i, &j))
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
 static DEVICE_ATTR(type, 0444, type_show, NULL);
 static DEVICE_ATTR(temp, 0444, temp_show, NULL);
 static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
@@ -2044,6 +2198,52 @@ exit:
 	return ret;
 }
 
+static int create_map_attrs(struct thermal_zone *tz, int indx, int num_weights)
+{
+	int i, ret, size;
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
+	size = sizeof(struct thermal_attr) * num_weights;
+	attr->weights_attr = kzalloc(size, GFP_KERNEL);
+	if (!attr->weights_attr) {
+		ret = -ENOMEM;
+		goto exit_free;
+	}
+
+	ret = create_multi_trip_attrs(tz, num_weights, indx,
+					attr->weights_attr,
+					"map%d_weight%d",
+					map_weights_show);
+	if (ret) {
+		kfree(attr->weights_attr);
+		goto exit_free;
+	}
+
+	return 0;
+exit_free:
+	while (--i >= 0)
+		device_remove_file(&tz->device, &attr->attrs[i].attr);
+	return ret;
+}
+
 /**
  * create_thermal_zone - create sysfs nodes for thermal zone
  * @name:	Name of the thermla zone
@@ -2135,7 +2335,6 @@ void remove_thermal_zone(struct thermal_zone *tz)
 		remove_cdev_from_zone(tz, cdev);
 
 	device_remove_file(&tz->device, &dev_attr_zone_name);
-
 	mutex_destroy(&tz->lock);
 	release_idr(&thermal_zone_idr, &thermal_idr_lock, tz->id);
 	idr_destroy(&tz->idr);
@@ -2475,6 +2674,57 @@ exit:
 EXPORT_SYMBOL(add_sensor_trip_info);
 
 /**
+ * add_map_entry - Add Thermal Map information for @tz
+ * @tz:		Thermal zone reference
+ * @map:	Thermal map reference
+ *
+ * Returns 0 on success, otherwise
+ * -EINVAL for invalid paramenters
+ * -EINVAL for array out of bounds
+ * -ENOMEM on kzalloc failures
+ */
+int add_map_entry(struct thermal_zone *tz, struct thermal_map *map)
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
+EXPORT_SYMBOL(add_map_entry);
+
+/**
  * thermal_sensor_register - register a new thermal sensor
  * @name:	name of the thermal sensor
  * @count:	Number of thresholds supported by hardware
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index f8de86d..724c68b 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -62,6 +62,11 @@
 
 #define MAX_CDEVS_PER_ZONE		5
 
+#define NUM_MAP_ATTRS			4
+
+/* If we map each sensor with every possible cdev for a zone */
+#define MAX_MAPS_PER_ZONE	(MAX_SENSORS_PER_ZONE * MAX_CDEVS_PER_ZONE)
+
 struct thermal_sensor;
 struct thermal_zone_device;
 struct thermal_cooling_device;
@@ -170,6 +175,21 @@ struct thermal_attr {
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
@@ -264,6 +284,10 @@ struct thermal_zone {
 	/* Thermal sensors trip information */
 	struct thermal_trip_point *sensor_trip[MAX_SENSORS_PER_ZONE];
 	struct thermal_trip_attr *trip_attr[MAX_SENSORS_PER_ZONE];
+
+	/* Thermal map information */
+	struct thermal_map *map[MAX_MAPS_PER_ZONE];
+	struct thermal_map_attr *map_attr[MAX_MAPS_PER_ZONE];
 };
 
 /* Structure that holds thermal governor information */
@@ -347,6 +371,8 @@ struct thermal_cooling_device *get_cdev_by_name(const char *);
 int add_sensor_trip_info(struct thermal_zone *, struct thermal_sensor *,
 			struct thermal_trip_point *);
 
+int add_map_entry(struct thermal_zone *, struct thermal_map *);
+
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
 						enum events event);
-- 
1.7.9.5

