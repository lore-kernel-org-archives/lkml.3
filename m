Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaAPS3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:29:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:6313 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbaAPS2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:28:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,668,1384329600"; 
   d="scan'208";a="404034976"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCHv5 06/10] Thermal: Add trip point sysfs nodes for sensor
Date: Fri, 17 Jan 2014 05:26:23 +0530
Message-Id: <1389916587-2541-7-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
References: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a trip point related sysfs nodes
for each sensor under a zone in /sys/class/thermal/zoneX/.
The nodes will be named, sensorX_trip_activeY,
sensorX_trip_passiveY, sensorX_trip_hot, sensorX_trip_critical
for active, passive, hot and critical trip points
respectively for sensorX.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_core_new.c |  358 +++++++++++++++++++++++++++++++++++-
 include/linux/thermal.h            |   39 +++-
 2 files changed, 395 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core_new.c b/drivers/thermal/thermal_core_new.c
index 3134b1a..e6a35f0 100644
--- a/drivers/thermal/thermal_core_new.c
+++ b/drivers/thermal/thermal_core_new.c
@@ -111,6 +111,25 @@ static void release_idr(struct idr *idr, int id)
 	mutex_unlock(&thermal_idr_lock);
 }
 
+static int get_sensor_indx_by_kobj(struct thermal_zone *tz, const char *name)
+{
+	int i, indx = -EINVAL;
+
+	/* Protect against tz->sensors[i] being unregistered */
+	mutex_lock(&sensor_list_lock);
+
+	for (i = 0; i < tz->sensor_indx; i++) {
+		if (!strnicmp(name, kobject_name(&tz->sensors[i]->device.kobj),
+					THERMAL_NAME_LENGTH)) {
+			indx = i;
+			break;
+		}
+	}
+
+	mutex_unlock(&sensor_list_lock);
+	return indx;
+}
+
 static ssize_t
 name_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -271,6 +290,115 @@ zone_name_show(struct device *dev, struct device_attribute *attr, char *buf)
 	return sprintf(buf, "%s\n", tz->name);
 }
 
+static ssize_t
+active_trip_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int i, j, val;
+	char kobj_name[THERMAL_NAME_LENGTH];
+	struct thermal_zone *tz = to_thermal_zone(dev);
+
+	val = sscanf(attr->attr.name, "sensor%d_trip_active%d", &i, &j);
+	if (!val)
+		return -EINVAL;
+
+	snprintf(kobj_name, THERMAL_NAME_LENGTH, "sensor%d", i);
+
+	mutex_lock(&tz->lock);
+
+	i = get_sensor_indx_by_kobj(tz, kobj_name);
+	if (i < 0) {
+		mutex_unlock(&tz->lock);
+		return i;
+	}
+
+	val = tz->sensor_trip[i]->active_trips[j];
+	mutex_unlock(&tz->lock);
+
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t
+passive_trip_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int i, j, val;
+	char kobj_name[THERMAL_NAME_LENGTH];
+	struct thermal_zone *tz = to_thermal_zone(dev);
+
+	val = sscanf(attr->attr.name, "sensor%d_trip_passive%d", &i, &j);
+	if (!val)
+		return -EINVAL;
+
+	snprintf(kobj_name, THERMAL_NAME_LENGTH, "sensor%d", i);
+
+	mutex_lock(&tz->lock);
+
+	i = get_sensor_indx_by_kobj(tz, kobj_name);
+	if (i < 0) {
+		mutex_unlock(&tz->lock);
+		return i;
+	}
+
+	val = tz->sensor_trip[i]->passive_trips[j];
+	mutex_unlock(&tz->lock);
+
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t
+hot_trip_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int indx, val;
+	char kobj_name[THERMAL_NAME_LENGTH];
+	struct thermal_zone *tz = to_thermal_zone(dev);
+
+	val = sscanf(attr->attr.name, "sensor%d_trip_hot", &indx);
+	if (!val)
+		return -EINVAL;
+
+	snprintf(kobj_name, THERMAL_NAME_LENGTH, "sensor%d", indx);
+
+	mutex_lock(&tz->lock);
+
+	indx = get_sensor_indx_by_kobj(tz, kobj_name);
+	if (indx < 0) {
+		mutex_unlock(&tz->lock);
+		return indx;
+	}
+
+	val = tz->sensor_trip[indx]->hot;
+	mutex_unlock(&tz->lock);
+
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t
+critical_trip_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	int indx, val;
+	char kobj_name[THERMAL_NAME_LENGTH];
+	struct thermal_zone *tz = to_thermal_zone(dev);
+
+	val = sscanf(attr->attr.name, "sensor%d_trip_critical", &indx);
+	if (!val)
+		return -EINVAL;
+
+	snprintf(kobj_name, THERMAL_NAME_LENGTH, "sensor%d", indx);
+
+	mutex_lock(&tz->lock);
+
+	indx = get_sensor_indx_by_kobj(tz, kobj_name);
+	if (indx < 0) {
+		mutex_unlock(&tz->lock);
+		return indx;
+	}
+
+	val = tz->sensor_trip[indx]->crit;
+	mutex_unlock(&tz->lock);
+
+	return sprintf(buf, "%d\n", val);
+}
+
 /* Thermal sensor attributes */
 static DEVICE_ATTR_RO(name);
 static DEVICE_ATTR_RO(temp);
@@ -283,6 +411,41 @@ static DEVICE_ATTR_RW(cur_state);
 /* Thermal zone attributes */
 static DEVICE_ATTR_RO(zone_name);
 
+static void __remove_trip_attr(struct thermal_zone *tz, int indx)
+{
+	int i;
+	struct thermal_trip_attr *attr = tz->trip_attr[indx];
+	struct thermal_trip_point *trip = tz->sensor_trip[indx];
+
+	if (!attr || !trip)
+		return;
+
+	if (trip->crit != THERMAL_TRIPS_NONE)
+		device_remove_file(&tz->device, &attr->crit_attr.attr);
+
+	if (trip->hot != THERMAL_TRIPS_NONE)
+		device_remove_file(&tz->device, &attr->hot_attr.attr);
+
+	if (trip->num_passive_trips > 0) {
+		for (i = 0; i < trip->num_passive_trips; i++) {
+			device_remove_file(&tz->device,
+						&attr->passive_attrs[i].attr);
+		}
+		kfree(attr->passive_attrs);
+	}
+
+	if (trip->num_active_trips > 0) {
+		for (i = 0; i < trip->num_active_trips; i++) {
+			device_remove_file(&tz->device,
+						&attr->active_attrs[i].attr);
+		}
+		kfree(attr->active_attrs);
+	}
+
+	kfree(tz->trip_attr[indx]);
+	tz->trip_attr[indx] = NULL;
+}
+
 static void remove_sensor_from_zone(struct thermal_zone *tz,
 				struct thermal_sensor *ts)
 {
@@ -296,9 +459,15 @@ static void remove_sensor_from_zone(struct thermal_zone *tz,
 
 	mutex_lock(&tz->lock);
 
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
 	mutex_unlock(&tz->lock);
@@ -407,6 +576,82 @@ exit_name:
 	return ret;
 }
 
+static int create_single_trip_attr(struct thermal_zone *tz,
+			struct thermal_attr *attr,
+			const char *attr_name,
+			ssize_t (*rd_ptr)(struct device *dev,
+			struct device_attribute *devattr, char *buf))
+{
+	snprintf(attr->name, THERMAL_NAME_LENGTH, attr_name);
+	sysfs_attr_init(&attr->attr.attr);
+	attr->attr.attr.name = attr->name;
+	attr->attr.attr.mode = S_IRUGO;
+	attr->attr.show = rd_ptr;
+	return device_create_file(&tz->device, &attr->attr);
+}
+
+static int create_passive_trip_attrs(struct thermal_zone *tz, int num_trips,
+			int indx, struct thermal_trip_attr *attrs)
+{
+	char name[THERMAL_NAME_LENGTH];
+	int size, i, ret;
+
+	if (num_trips <= 0)
+		return 0;
+
+	size = sizeof(struct thermal_attr) * num_trips;
+	attrs->passive_attrs = kzalloc(size, GFP_KERNEL);
+	if (!attrs->passive_attrs)
+		return -ENOMEM;
+
+	for (i = 0; i < num_trips; i++) {
+		snprintf(name, THERMAL_NAME_LENGTH,
+					"sensor%d_trip_passive%d", indx, i);
+		ret = create_single_trip_attr(tz, &attrs->passive_attrs[i],
+					name, passive_trip_show);
+		if (ret)
+			goto exit;
+	}
+	return 0;
+
+exit:
+	while (--i >= 0)
+		device_remove_file(&tz->device, &attrs->passive_attrs[i].attr);
+	kfree(attrs->passive_attrs);
+	return ret;
+}
+
+static int create_active_trip_attrs(struct thermal_zone *tz, int num_trips,
+			int indx, struct thermal_trip_attr *attrs)
+{
+	char name[THERMAL_NAME_LENGTH];
+	int size, i, ret;
+
+	if (num_trips <= 0)
+		return 0;
+
+	size = sizeof(struct thermal_attr) * num_trips;
+	attrs->active_attrs = kzalloc(size, GFP_KERNEL);
+	if (!attrs->active_attrs)
+		return -ENOMEM;
+
+	for (i = 0; i < num_trips; i++) {
+		snprintf(name, THERMAL_NAME_LENGTH,
+				"sensor%d_trip_active%d", indx, i);
+		ret = create_single_trip_attr(tz, &attrs->active_attrs[i],
+				name, active_trip_show);
+		if (ret)
+			goto exit;
+	}
+	return 0;
+
+exit:
+	while (--i >= 0)
+		device_remove_file(&tz->device, &attrs->active_attrs[i].attr);
+	kfree(attrs->active_attrs);
+	return ret;
+}
+
 /**
  * thermal_sensor_register - register a new thermal sensor
  * @name:	name of the thermal sensor
@@ -952,3 +1197,114 @@ exit_zone:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(thermal_add_cdev_to_zone);
+
+/**
+ * thermal_add_sensor_trip_info - Add trip point information for @ts in @tz
+ * @tz:		Thermal zone reference
+ * @ts:		Thermal sensor reference
+ * @trip:	Trip point structure reference
+ *
+ * Returns 0 on success, otherwise
+ * -EINVAL for invalid paramenters
+ * -EINVAL if @ts is not part of 'this' thermal zone @tz
+ * -ENOMEM on kzalloc failures
+ */
+int thermal_add_sensor_trip_info(struct thermal_zone *tz,
+		struct thermal_sensor *ts, struct thermal_trip_point *trip)
+{
+	char name[THERMAL_NAME_LENGTH];
+	int i, indx, kobj_indx, ret;
+	struct thermal_trip_attr *attrs;
+
+	if (!tz || !ts || !trip)
+		return -EINVAL;
+
+	ret = sscanf(kobject_name(&ts->device.kobj), "sensor%d", &kobj_indx);
+	if (!ret)
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
+	/* Protect against 'ts' being unregistered */
+	mutex_lock(&sensor_list_lock);
+
+	/* Protect tz->trip_attr[] and tz->sensor_trip[] */
+	mutex_lock(&tz->lock);
+
+	tz->trip_attr[indx] = kzalloc(sizeof(struct thermal_trip_attr),
+					GFP_KERNEL);
+	if (!tz->trip_attr[indx]) {
+		ret = -ENOMEM;
+		goto exit_lock;
+	}
+
+	attrs = tz->trip_attr[indx];
+
+	/* Create Critical trip point attribute */
+	if (trip->crit != THERMAL_TRIPS_NONE) {
+		snprintf(name, THERMAL_NAME_LENGTH,
+					"sensor%d_trip_critical", kobj_indx);
+		ret = create_single_trip_attr(tz, &attrs->crit_attr,
+					name, critical_trip_show);
+		if (ret)
+			goto exit_trip;
+	}
+
+	/* Create Hot trip point attribute */
+	if (trip->hot != THERMAL_TRIPS_NONE) {
+		snprintf(name, THERMAL_NAME_LENGTH,
+					"sensor%d_trip_hot", kobj_indx);
+		ret = create_single_trip_attr(tz, &attrs->hot_attr,
+					name, hot_trip_show);
+		if (ret)
+			goto exit_crit_trip;
+	}
+
+	/* Create Passive trip point attributes */
+	ret = create_passive_trip_attrs(tz, trip->num_passive_trips,
+				kobj_indx, attrs);
+	if (ret)
+		goto exit_hot_trip;
+
+	/* Create Active trip point attributes */
+	ret = create_active_trip_attrs(tz, trip->num_active_trips,
+				kobj_indx, attrs);
+	if (ret)
+		goto exit_passive_trips;
+
+	tz->sensor_trip[indx] = trip;
+
+	mutex_unlock(&tz->lock);
+	mutex_unlock(&sensor_list_lock);
+	mutex_unlock(&zone_list_lock);
+
+	return 0;
+
+exit_passive_trips:
+	i = trip->num_passive_trips;
+	while (--i >= 0)
+		device_remove_file(&tz->device, &attrs->passive_attrs[i].attr);
+	kfree(attrs->passive_attrs);
+exit_hot_trip:
+	if (trip->hot != THERMAL_TRIPS_NONE)
+		device_remove_file(&tz->device, &attrs->hot_attr.attr);
+exit_crit_trip:
+	if (trip->crit != THERMAL_TRIPS_NONE)
+		device_remove_file(&tz->device, &attrs->crit_attr.attr);
+exit_trip:
+	kfree(tz->trip_attr[indx]);
+	tz->trip_attr[indx] = NULL;
+exit_lock:
+	mutex_unlock(&tz->lock);
+	mutex_unlock(&sensor_list_lock);
+exit:
+	mutex_unlock(&zone_list_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(thermal_add_sensor_trip_info);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 9b080f2..fe7abc9 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -32,7 +32,7 @@
 
 #define THERMAL_TRIPS_NONE	-1
 #define THERMAL_MAX_TRIPS	12
-#define THERMAL_NAME_LENGTH	20
+#define THERMAL_NAME_LENGTH	25
 
 /* invalid cooling state */
 #define THERMAL_CSTATE_INVALID -1UL
@@ -172,6 +172,37 @@ struct thermal_attr {
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
+	struct thermal_attr hot_attr;
+	struct thermal_attr crit_attr;
+	struct thermal_attr *active_attrs;
+	struct thermal_attr *passive_attrs;
+};
+
 struct thermal_sensor {
 	char name[THERMAL_NAME_LENGTH];
 	int id;
@@ -231,6 +262,10 @@ struct thermal_zone {
 	/* cdev level information */
 	int cdev_indx; /* index into 'cdevs' array */
 	struct thermal_cooling_device *cdevs[MAX_CDEVS_PER_ZONE];
+
+	/* Thermal sensors trip information */
+	struct thermal_trip_point *sensor_trip[MAX_SENSORS_PER_ZONE];
+	struct thermal_trip_attr *trip_attr[MAX_SENSORS_PER_ZONE];
 };
 
 /* Structure that holds thermal governor information */
@@ -350,6 +385,8 @@ struct thermal_sensor *thermal_get_sensor_by_name(const char *);
 int thermal_add_cdev_to_zone(struct thermal_zone *,
 				struct thermal_cooling_device *);
 struct thermal_cooling_device *thermal_get_cdev_by_name(const char *);
+int thermal_add_sensor_trip_info(struct thermal_zone *,
+			struct thermal_sensor *, struct thermal_trip_point *);
 
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
-- 
1.7.9.5

