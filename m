Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3JANKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:10:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:36060 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab3JANKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:10:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1013,1371106800"; 
   d="scan'208";a="368223039"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCHv4 3/9] Thermal: Create zone level APIs
Date: Wed,  2 Oct 2013 00:08:02 +0530
Message-Id: <1380652688-5787-4-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380652688-5787-1-git-send-email-durgadoss.r@intel.com>
References: <1380652688-5787-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new thermal_zone structure to
thermal.h. Also, adds zone level APIs to the thermal
framework.

A thermal zone is a hot spot on the platform, which
can have one or more sensors and cooling devices attached
to it. These sensors can be mapped to a set of cooling
devices, which when throttled, can help to bring down
the temperature of the hot spot.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_core.c |  267 +++++++++++++++++++++++++++++++++++++++-
 include/linux/thermal.h        |   23 ++++
 2 files changed, 289 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 8c46567..a053b60 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -44,19 +44,48 @@ MODULE_DESCRIPTION("Generic thermal management sysfs support");
 MODULE_LICENSE("GPL v2");
 
 static DEFINE_IDR(thermal_tz_idr);
+static DEFINE_IDR(thermal_zone_idr);
 static DEFINE_IDR(thermal_cdev_idr);
 static DEFINE_IDR(thermal_sensor_idr);
 static DEFINE_MUTEX(thermal_idr_lock);
 
 static LIST_HEAD(thermal_tz_list);
 static LIST_HEAD(thermal_sensor_list);
+static LIST_HEAD(thermal_zone_list);
 static LIST_HEAD(thermal_cdev_list);
 static LIST_HEAD(thermal_governor_list);
 
 static DEFINE_MUTEX(thermal_list_lock);
 static DEFINE_MUTEX(sensor_list_lock);
+static DEFINE_MUTEX(zone_list_lock);
 static DEFINE_MUTEX(thermal_governor_lock);
 
+#define for_each_thermal_sensor(pos) \
+	list_for_each_entry(pos, &thermal_sensor_list, node)
+
+#define for_each_thermal_zone(pos) \
+	list_for_each_entry(pos, &thermal_zone_list, node)
+
+#define GET_INDEX(tz, ptr, type)			\
+({							\
+	int i, ret = -EINVAL;				\
+	do {						\
+		if (!tz || !ptr)			\
+			break;				\
+		mutex_lock(&tz->lock);			\
+		mutex_lock(&type##_list_lock);		\
+		for (i = 0; i < tz->type##_indx; i++) {	\
+			if (tz->type##s[i] == ptr) {	\
+				ret = i;		\
+				break;			\
+			}				\
+		}					\
+		mutex_unlock(&type##_list_lock);	\
+		mutex_unlock(&tz->lock);		\
+	} while (0);					\
+	ret;						\
+})
+
 static struct thermal_governor *__find_governor(const char *name)
 {
 	struct thermal_governor *pos;
@@ -461,15 +490,47 @@ static void thermal_zone_device_check(struct work_struct *work)
 	thermal_zone_device_update(tz);
 }
 
+static void remove_sensor_from_zone(struct thermal_zone *tz,
+				struct thermal_sensor *ts)
+{
+	int j, indx;
+
+	indx = GET_INDEX(tz, ts, sensor);
+	if (indx < 0)
+		return;
+
+	sysfs_remove_link(&tz->device.kobj, kobject_name(&ts->device.kobj));
+
+	mutex_lock(&tz->lock);
+
+	/* Shift the entries in the tz->sensors array */
+	for (j = indx; j < MAX_SENSORS_PER_ZONE - 1; j++)
+		tz->sensors[j] = tz->sensors[j + 1];
+
+	tz->sensor_indx--;
+	mutex_unlock(&tz->lock);
+}
+
 /* sys I/F for thermal zone */
 
 #define to_thermal_zone(_dev) \
 	container_of(_dev, struct thermal_zone_device, device)
 
+#define to_zone(_dev) \
+	container_of(_dev, struct thermal_zone, device)
+
 #define to_thermal_sensor(_dev) \
 	container_of(_dev, struct thermal_sensor, device)
 
 static ssize_t
+zone_name_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct thermal_zone *tz = to_zone(dev);
+
+	return sprintf(buf, "%s\n", tz->name);
+}
+
+static ssize_t
 sensor_name_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct thermal_sensor *ts = to_thermal_sensor(dev);
@@ -876,6 +937,8 @@ static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show, policy_store);
 static DEVICE_ATTR(sensor_name, 0444, sensor_name_show, NULL);
 static DEVICE_ATTR(temp_input, 0444, sensor_temp_show, NULL);
 
+static DEVICE_ATTR(zone_name, 0444, zone_name_show, NULL);
+
 /* sys I/F for cooling device */
 #define to_cooling_device(_dev)	\
 	container_of(_dev, struct thermal_cooling_device, device)
@@ -1689,7 +1752,7 @@ static void remove_trip_attrs(struct thermal_zone_device *tz)
 	kfree(tz->trip_hyst_attrs);
 }
 
- /**
+/**
  * enable_sensor_thresholds - create sysfs nodes for thresholdX
  * @ts:		the thermal sensor
  * @count:	Number of thresholds supported by sensor hardware
@@ -1746,6 +1809,200 @@ static int enable_sensor_thresholds(struct thermal_sensor *ts, int count)
 }
 
 /**
+ * create_thermal_zone - create sysfs nodes for thermal zone
+ * @name:	Name of the thermla zone
+ * @devdata:	Data supplied by the caller
+ *
+ * On Success returns a thermal zone reference, otherwise:
+ * -EINVAL for invalid parameters,
+ * -ENOMEM for insufficient memory cases,
+ */
+struct thermal_zone *create_thermal_zone(const char *name, void *devdata)
+{
+	struct thermal_zone *tz;
+	int ret;
+
+	if (!name || (name && strlen(name) >= THERMAL_NAME_LENGTH))
+		return ERR_PTR(-EINVAL);
+
+	tz = kzalloc(sizeof(*tz), GFP_KERNEL);
+	if (!tz)
+		return ERR_PTR(-ENOMEM);
+
+	idr_init(&tz->idr);
+	ret = get_idr(&thermal_zone_idr, &thermal_idr_lock, &tz->id);
+	if (ret)
+		goto exit_free;
+
+	mutex_init(&tz->lock);
+	strlcpy(tz->name, name, sizeof(tz->name));
+	tz->devdata = devdata;
+	tz->device.class = &thermal_class;
+
+	dev_set_name(&tz->device, "zone%d", tz->id);
+	ret = device_register(&tz->device);
+	if (ret)
+		goto exit_idr;
+
+	ret = device_create_file(&tz->device, &dev_attr_zone_name);
+	if (ret)
+		goto exit_unregister;
+
+	/* Add this zone to the global list of thermal zones */
+	mutex_lock(&zone_list_lock);
+	list_add_tail(&tz->node, &thermal_zone_list);
+	mutex_unlock(&zone_list_lock);
+	return tz;
+
+exit_unregister:
+	device_unregister(&tz->device);
+exit_idr:
+	mutex_destroy(&tz->lock);
+	release_idr(&thermal_zone_idr, &thermal_idr_lock, tz->id);
+exit_free:
+	kfree(tz);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL(create_thermal_zone);
+
+/**
+ * remove_thermal_zone - removes the sysfs nodes for given tz
+ * @tz:	Thermal zone to be removed.
+ */
+void remove_thermal_zone(struct thermal_zone *tz)
+{
+	struct thermal_zone *pos, *next;
+	struct thermal_sensor *ts;
+	bool found = false;
+
+	if (!tz)
+		return;
+
+	mutex_lock(&zone_list_lock);
+
+	list_for_each_entry_safe(pos, next, &thermal_zone_list, node) {
+		if (pos == tz) {
+			list_del(&tz->node);
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		goto exit;
+
+	for_each_thermal_sensor(ts)
+		remove_sensor_from_zone(tz, ts);
+
+	device_remove_file(&tz->device, &dev_attr_zone_name);
+
+	mutex_destroy(&tz->lock);
+	release_idr(&thermal_zone_idr, &thermal_idr_lock, tz->id);
+	idr_destroy(&tz->idr);
+
+	device_unregister(&tz->device);
+	kfree(tz);
+exit:
+	mutex_unlock(&zone_list_lock);
+	return;
+}
+EXPORT_SYMBOL(remove_thermal_zone);
+
+/**
+ * get_sensor_by_name() - search for a sensor and returns its reference
+ * @name: thermal sensor name to fetch the reference
+ *
+ * On success returns a reference to a unique sensor with
+ * name matching that of @name, an ERR_PTR otherwise:
+ * -EINVAL for invalid paramenters
+ * -ENODEV for sensor not found
+ * -EEXIST for multiple matches
+ */
+struct thermal_sensor *get_sensor_by_name(const char *name)
+{
+	int found = 0;
+	struct thermal_sensor *pos;
+	struct thermal_sensor *ts = ERR_PTR(-EINVAL);
+
+	if (!name)
+		return ts;
+
+	mutex_lock(&sensor_list_lock);
+	for_each_thermal_sensor(pos) {
+		if (!strnicmp(pos->name, name, THERMAL_NAME_LENGTH)) {
+			found++;
+			ts = pos;
+		}
+	}
+	mutex_unlock(&sensor_list_lock);
+
+	if (found == 0)
+		ts = ERR_PTR(-ENODEV);
+	else if (found > 1)
+		ts = ERR_PTR(-EEXIST);
+
+	return ts;
+}
+EXPORT_SYMBOL(get_sensor_by_name);
+
+/**
+ * add_sensor_to_zone - Add @ts to thermal zone @tz
+ * @tz:		Thermal zone reference
+ * @ts:		Thermal sensor reference
+ *
+ * Returns 0 on success, otherwise
+ * -EINVAL for invalid paramenters
+ * -EINVAL when trying to add more zones than MAX_SENSORS_PER_ZONE
+ * -EEXIST when trying add existing thermal sensor again
+ */
+int add_sensor_to_zone(struct thermal_zone *tz, struct thermal_sensor *ts)
+{
+	int ret;
+
+	if (!tz || !ts)
+		return -EINVAL;
+
+	mutex_lock(&zone_list_lock);
+
+	/* Ensure we are not adding the same sensor again!! */
+	ret = GET_INDEX(tz, ts, sensor);
+	if (ret >= 0) {
+		ret = -EEXIST;
+		goto exit_zone;
+	}
+
+	/* Protect against 'ts' being unregistered */
+	mutex_lock(&sensor_list_lock);
+
+	ret = sysfs_create_link(&tz->device.kobj, &ts->device.kobj,
+				kobject_name(&ts->device.kobj));
+	if (ret)
+		goto exit_sensor;
+
+	mutex_lock(&tz->lock);
+
+	if (tz->sensor_indx >= MAX_SENSORS_PER_ZONE - 1) {
+		dev_err(&tz->device, "Only %d sensors allowed per zone\n",
+					MAX_SENSORS_PER_ZONE);
+		sysfs_remove_link(&tz->device.kobj,
+					kobject_name(&ts->device.kobj));
+		ret = -EINVAL;
+		goto exit_indx_check;
+	}
+
+	tz->sensors[tz->sensor_indx++] = ts;
+
+exit_indx_check:
+	mutex_unlock(&tz->lock);
+exit_sensor:
+	mutex_unlock(&sensor_list_lock);
+exit_zone:
+	mutex_unlock(&zone_list_lock);
+	return ret;
+}
+EXPORT_SYMBOL(add_sensor_to_zone);
+
+/**
  * thermal_sensor_register - register a new thermal sensor
  * @name:	name of the thermal sensor
  * @count:	Number of thresholds supported by hardware
@@ -1829,6 +2086,7 @@ EXPORT_SYMBOL(thermal_sensor_register);
 void thermal_sensor_unregister(struct thermal_sensor *ts)
 {
 	int i;
+	struct thermal_zone *tz;
 	struct thermal_sensor *pos, *next;
 	bool found = false;
 
@@ -1848,6 +2106,13 @@ void thermal_sensor_unregister(struct thermal_sensor *ts)
 	if (!found)
 		return;
 
+	mutex_lock(&zone_list_lock);
+
+	for_each_thermal_zone(tz)
+		remove_sensor_from_zone(tz, ts);
+
+	mutex_unlock(&zone_list_lock);
+
 	for (i = 0; i < ts->thresholds; i++) {
 		device_remove_file(&ts->device, &ts->thresh_attrs[i].attr);
 		if (ts->ops->get_hyst) {
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 25fc562..2e12321 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -58,6 +58,8 @@
 #define DEFAULT_THERMAL_GOVERNOR       "user_space"
 #endif
 
+#define MAX_SENSORS_PER_ZONE		5
+
 struct thermal_sensor;
 struct thermal_zone_device;
 struct thermal_cooling_device;
@@ -207,6 +209,22 @@ struct thermal_zone_device {
 	struct delayed_work poll_queue;
 };
 
+struct thermal_zone {
+	char name[THERMAL_NAME_LENGTH];
+	int id;
+	void *devdata;
+	struct thermal_zone *ops;
+	struct thermal_governor *governor;
+	struct idr idr;
+	struct mutex lock; /* protect elements of this structure */
+	struct device device;
+	struct list_head node;
+
+	/* Sensor level information */
+	int sensor_indx; /* index into 'sensors' array */
+	struct thermal_sensor *sensors[MAX_SENSORS_PER_ZONE];
+};
+
 /* Structure that holds thermal governor information */
 struct thermal_governor {
 	char name[THERMAL_NAME_LENGTH];
@@ -277,6 +295,11 @@ struct thermal_sensor *thermal_sensor_register(const char *, int,
 				struct thermal_sensor_ops *, void *);
 void thermal_sensor_unregister(struct thermal_sensor *);
 
+struct thermal_zone *create_thermal_zone(const char *, void *);
+void remove_thermal_zone(struct thermal_zone *);
+int add_sensor_to_zone(struct thermal_zone *, struct thermal_sensor *);
+struct thermal_sensor *get_sensor_by_name(const char *);
+
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
 						enum events event);
-- 
1.7.9.5

