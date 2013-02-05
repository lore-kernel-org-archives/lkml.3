Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab3BEKx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:53:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:12496 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab3BEKwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:52:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="252768362"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCH 4/8] Thermal: Add trip point sysfs nodes for sensor
Date: Tue,  5 Feb 2013 16:16:19 +0530
Message-Id: <1360061183-14137-5-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a trip point related sysfs nodes
for each sensor under a zone in /sys/class/thermal/zoneX/.
The nodes will be named, sensorX_trip_active,
sensorX_trip_passive, sensorX_trip_hot, sensorX_trip_critical
for active, passive, hot and critical trip points
respectively for sensorX.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_sys.c |  225 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/thermal.h       |   38 ++++++-
 2 files changed, 260 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index bf703b1..69a60a4 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -452,6 +452,37 @@ static void thermal_zone_device_check(struct work_struct *work)
 	thermal_zone_device_update(tz);
 }
 
+static int get_sensor_indx_by_kobj(struct thermal_zone *tz, const char *name)
+{
+	int i, indx = -EINVAL;
+
+	mutex_lock(&sensor_list_lock);
+	for (i = 0; i < tz->sensor_indx; i++) {
+		if (!strnicmp(name, kobject_name(&tz->sensors[i]->device.kobj),
+					THERMAL_NAME_LENGTH)) {
+			indx = i;
+			break;
+		}
+	}
+	mutex_unlock(&sensor_list_lock);
+	return indx;
+}
+
+static void inline __remove_trip_attr(struct thermal_zone *tz, int indx)
+{
+	int i;
+	struct thermal_trip_attr *attr = tz->trip_attr[indx];
+
+	if (!attr)
+		return;
+
+	for (i = 0; i < NUM_TRIP_TYPES; i++)
+		device_remove_file(&tz->device, &attr->attrs[i].attr);
+
+	kfree(tz->trip_attr[indx]);
+	tz->trip_attr[indx] = NULL;
+}
+
 static void remove_sensor_from_zone(struct thermal_zone *tz,
 				struct thermal_sensor *ts)
 {
@@ -463,9 +494,15 @@ static void remove_sensor_from_zone(struct thermal_zone *tz,
 
 	sysfs_remove_link(&tz->device.kobj, kobject_name(&ts->device.kobj));
 
+	/* Remove trip point attributes associated with this sensor */
+	__remove_trip_attr(tz, indx);
+
 	/* Shift the entries in the tz->sensors array */
-	for (j = indx; j < MAX_SENSORS_PER_ZONE - 1; j++)
+	for (j = indx; j < MAX_SENSORS_PER_ZONE - 1; j++) {
 		tz->sensors[j] = tz->sensors[j + 1];
+		tz->sensor_trip[j] = tz->sensor_trip[j + 1];
+		tz->trip_attr[j] = tz->trip_attr[j + 1];
+	}
 
 	tz->sensor_indx--;
 }
@@ -879,6 +916,99 @@ policy_show(struct device *dev, struct device_attribute *devattr, char *buf)
 	return sprintf(buf, "%s\n", tz->governor->name);
 }
 
+static ssize_t
+active_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int i, indx, ret = 0;
+	char kobj_name[THERMAL_NAME_LENGTH];
+	struct thermal_zone *tz = to_zone(dev);
+
+	if (!sscanf(attr->attr.name, "sensor%d_trip_active", &i))
+		return -EINVAL;
+
+	snprintf(kobj_name, THERMAL_NAME_LENGTH, "sensor%d", i);
+	indx = get_sensor_indx_by_kobj(tz, kobj_name);
+	if (indx < 0)
+		return indx;
+
+	if (tz->sensor_trip[indx]->num_active_trips <= 0)
+		return sprintf(buf, "<Not available>\n");
+
+	ret += sprintf(buf, "0x%x", tz->sensor_trip[indx]->active_trip_mask);
+	for (i = 0; i < tz->sensor_trip[indx]->num_active_trips; i++) {
+		ret += sprintf(buf + ret, " %d",
+			tz->sensor_trip[indx]->active_trips[i]);
+	}
+
+	ret += sprintf(buf + ret, "\n");
+	return ret;
+}
+
+static ssize_t
+ptrip_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int i, indx, ret = 0;
+	char kobj_name[THERMAL_NAME_LENGTH];
+	struct thermal_zone *tz = to_zone(dev);
+
+	if (!sscanf(attr->attr.name, "sensor%d_trip_passive", &i))
+		return -EINVAL;
+
+	snprintf(kobj_name, THERMAL_NAME_LENGTH, "sensor%d", i);
+	indx = get_sensor_indx_by_kobj(tz, kobj_name);
+	if (indx < 0)
+		return indx;
+
+	if (tz->sensor_trip[indx]->num_passive_trips <= 0)
+		return sprintf(buf, "<Not available>\n");
+
+	for (i = 0; i < tz->sensor_trip[indx]->num_passive_trips; i++) {
+		ret += sprintf(buf + ret, "%d ",
+			tz->sensor_trip[indx]->passive_trips[i]);
+	}
+
+	ret += sprintf(buf + ret, "\n");
+	return ret;
+}
+
+static ssize_t
+hot_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int indx;
+	char kobj_name[THERMAL_NAME_LENGTH];
+	struct thermal_zone *tz = to_zone(dev);
+
+	if (!sscanf(attr->attr.name, "sensor%d_trip_hot", &indx))
+		return -EINVAL;
+
+	snprintf(kobj_name, THERMAL_NAME_LENGTH, "sensor%d", indx);
+
+	indx = get_sensor_indx_by_kobj(tz, kobj_name);
+	if (indx < 0)
+		return indx;
+
+	return sprintf(buf, "%d\n", tz->sensor_trip[indx]->hot);
+}
+
+static ssize_t
+critical_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int indx;
+	char kobj_name[THERMAL_NAME_LENGTH];
+	struct thermal_zone *tz = to_zone(dev);
+
+	if (!sscanf(attr->attr.name, "sensor%d_trip_critical", &indx))
+		return -EINVAL;
+
+	snprintf(kobj_name, THERMAL_NAME_LENGTH, "sensor%d", indx);
+
+	indx = get_sensor_indx_by_kobj(tz, kobj_name);
+	if (indx < 0)
+		return indx;
+
+	return sprintf(buf, "%d\n", tz->sensor_trip[indx]->crit);
+}
+
 static DEVICE_ATTR(type, 0444, type_show, NULL);
 static DEVICE_ATTR(temp, 0444, temp_show, NULL);
 static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
@@ -889,7 +1019,8 @@ static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show, policy_store);
 static DEVICE_ATTR(sensor_name, 0444, sensor_name_show, NULL);
 static DEVICE_ATTR(temp_input, 0444, sensor_temp_show, NULL);
 
-static DEVICE_ATTR(zone_name, 0444, zone_name_show, NULL);
+/* Thermal zone attributes */
+static DEVICE_ATTR(zone_name, S_IRUGO, zone_name_show, NULL);
 
 /* sys I/F for cooling device */
 #define to_cooling_device(_dev)	\
@@ -1744,6 +1875,38 @@ static int enable_sensor_thresholds(struct thermal_sensor *ts, int count)
 	return 0;
 }
 
+static int create_sensor_trip_attrs(struct thermal_zone *tz,
+				struct thermal_trip_attr *attr, int indx)
+{
+	int i, ret;
+	static const char *const names[NUM_TRIP_TYPES] = {
+				"sensor%d_trip_active",
+				"sensor%d_trip_passive",
+				"sensor%d_trip_hot",
+				"sensor%d_trip_critical",
+				};
+	static ssize_t (*const rd_ptr[NUM_TRIP_TYPES]) (struct device *dev,
+			struct device_attribute *devattr, char *buf) = {
+			active_show, ptrip_show, hot_show, critical_show};
+
+	for (i = 0; i < NUM_TRIP_TYPES; i++) {
+		snprintf(attr->attrs[i].name, THERMAL_NAME_LENGTH, names[i],
+			indx);
+		sysfs_attr_init(&attr->attrs[i].attr.attr);
+		attr->attrs[i].attr.attr.name = attr->attrs[i].name;
+		attr->attrs[i].attr.attr.mode = S_IRUGO;
+		attr->attrs[i].attr.show = rd_ptr[i];
+		ret = device_create_file(&tz->device, &attr->attrs[i].attr);
+		if (ret)
+			goto exit;
+	}
+	return 0;
+exit:
+	while (--i >= 0)
+		device_remove_file(&tz->device, &attr->attrs[i].attr);
+	return ret;
+}
+
 struct thermal_zone *create_thermal_zone(const char *name, void *devdata)
 {
 	struct thermal_zone *tz;
@@ -1793,6 +1956,7 @@ EXPORT_SYMBOL(create_thermal_zone);
 void remove_thermal_zone(struct thermal_zone *tz)
 {
 	struct thermal_zone *pos, *next;
+	int i;
 	bool found = false;
 
 	if (!tz)
@@ -1813,6 +1977,23 @@ void remove_thermal_zone(struct thermal_zone *tz)
 
 	device_remove_file(&tz->device, &dev_attr_zone_name);
 
+	/* Just for ease of usage */
+	i = tz->sensor_indx;
+	while (--i >= 0) {
+		/* Remove /sys/class/thermal/zoneX/sensorY */
+		sysfs_remove_link(&tz->device.kobj,
+				kobject_name(&tz->sensors[i]->device.kobj));
+		__remove_trip_attr(tz, i);
+	}
+
+	/* Release the cdevs attached to this zone */
+	i = tz->cdev_indx;
+	while (--i >= 0) {
+		/* Remove /sys/class/thermal/zoneX/cooling_deviceY */
+		sysfs_remove_link(&tz->device.kobj,
+				kobject_name(&tz->cdevs[i]->device.kobj));
+	}
+
 	release_idr(&thermal_zone_idr, &thermal_idr_lock, tz->id);
 	idr_destroy(&tz->idr);
 
@@ -1924,6 +2105,46 @@ exit_zone:
 }
 EXPORT_SYMBOL(add_cdev_to_zone);
 
+int add_sensor_trip_info(struct thermal_zone *tz, struct thermal_sensor *ts,
+			struct thermal_trip_point *trip)
+{
+	int ret, indx, kobj_indx;
+
+	if (!tz || !ts || !trip)
+		return -EINVAL;
+
+	if (!sscanf(kobject_name(&ts->device.kobj), "sensor%d", &kobj_indx))
+		return -EINVAL;
+
+	mutex_lock(&zone_list_lock);
+
+	indx = GET_INDEX(tz, ts, sensor);
+	if (indx < 0) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	tz->trip_attr[indx] = kzalloc(sizeof(struct thermal_trip_attr),
+					GFP_KERNEL);
+	if (!tz->trip_attr[indx]) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	ret = create_sensor_trip_attrs(tz, tz->trip_attr[indx], kobj_indx);
+	if (ret) {
+		kfree(tz->trip_attr[indx]);
+		goto exit;
+	}
+
+	tz->sensor_trip[indx] = trip;
+
+exit:
+	mutex_unlock(&zone_list_lock);
+	return ret;
+}
+EXPORT_SYMBOL(add_sensor_trip_info);
+
 /**
  * thermal_sensor_register - register a new thermal sensor
  * @name:	name of the thermal sensor
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index c841414..2f68018 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -31,7 +31,8 @@
 
 #define THERMAL_TRIPS_NONE	-1
 #define THERMAL_MAX_TRIPS	12
-#define THERMAL_NAME_LENGTH	20
+#define THERMAL_NAME_LENGTH	22
+#define NUM_TRIP_TYPES		4
 
 /* No upper/lower limit requirement */
 #define THERMAL_NO_LIMIT	-1UL
@@ -166,6 +167,34 @@ struct thermal_attr {
 	char name[THERMAL_NAME_LENGTH];
 };
 
+/*
+ * This structure defines the trip points for a sensor.
+ * The actual values for these trip points come from
+ * platform characterization. The thermal governors
+ * (either kernel or user space) may take appropriate
+ * actions when the sensors reach these trip points.
+ * See Documentation/thermal/sysfs-api2.txt for more details.
+ *
+ * As of now, For a particular sensor, we support:
+ * a) 1 hot trip point
+ * b) 1 critical trip point
+ * c) 'n' passive trip points
+ * d) 'm' active trip points
+ */
+struct thermal_trip_point {
+	int hot;
+	int crit;
+	int num_passive_trips;
+	int *passive_trips;
+	int num_active_trips;
+	int *active_trips;
+	int active_trip_mask;
+};
+
+struct thermal_trip_attr {
+	struct thermal_attr attrs[NUM_TRIP_TYPES];
+};
+
 struct thermal_sensor {
 	char name[THERMAL_NAME_LENGTH];
 	int id;
@@ -223,6 +252,10 @@ struct thermal_zone {
 	/* cdev level information */
 	int cdev_indx; /* index into 'cdevs' array */
 	struct thermal_cooling_device *cdevs[MAX_CDEVS_PER_ZONE];
+
+	/* Thermal sensors trip information */
+	struct thermal_trip_point *sensor_trip[MAX_SENSORS_PER_ZONE];
+	struct thermal_trip_attr *trip_attr[MAX_SENSORS_PER_ZONE];
 };
 
 /* Structure that holds thermal governor information */
@@ -305,6 +338,9 @@ struct thermal_sensor *get_sensor_by_name(const char *);
 int add_cdev_to_zone(struct thermal_zone *, struct thermal_cooling_device *);
 struct thermal_cooling_device *get_cdev_by_name(const char *);
 
+int add_sensor_trip_info(struct thermal_zone *, struct thermal_sensor *,
+			struct thermal_trip_point *);
+
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
 						enum events event);
-- 
1.7.9.5

