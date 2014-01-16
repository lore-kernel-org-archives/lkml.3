Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaAPSaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:30:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:6313 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbaAPS2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:28:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,668,1384329600"; 
   d="scan'208";a="404034955"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCHv5 05/10] Thermal: Add APIs to bind cdev to new zone structure
Date: Fri, 17 Jan 2014 05:26:22 +0530
Message-Id: <1389916587-2541-6-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
References: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates new APIs to add/remove a
cdev to/from a zone. This patch does not change
the existing cooling device implementation.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_core_new.c |  135 ++++++++++++++++++++++++++++++++++++
 include/linux/thermal.h            |    8 +++
 2 files changed, 143 insertions(+)

diff --git a/drivers/thermal/thermal_core_new.c b/drivers/thermal/thermal_core_new.c
index 4f84cb5..3134b1a 100644
--- a/drivers/thermal/thermal_core_new.c
+++ b/drivers/thermal/thermal_core_new.c
@@ -66,6 +66,9 @@ static DEFINE_MUTEX(zone_list_lock);
 #define for_each_thermal_zone(pos) \
 	list_for_each_entry(pos, &thermal_zone_list, node)
 
+#define for_each_cdev(pos) \
+	list_for_each_entry(pos, &thermal_cdev_list, node)
+
 #define GET_INDEX(tz, ptr, type)			\
 ({							\
 	int i, ret = -EINVAL;				\
@@ -301,6 +304,27 @@ static void remove_sensor_from_zone(struct thermal_zone *tz,
 	mutex_unlock(&tz->lock);
 }
 
+static void remove_cdev_from_zone(struct thermal_zone *tz,
+				struct thermal_cooling_device *cdev)
+{
+	int j, indx;
+
+	indx = GET_INDEX(tz, cdev, cdev);
+	if (indx < 0)
+		return;
+
+	sysfs_remove_link(&tz->device.kobj, kobject_name(&cdev->device.kobj));
+
+	mutex_lock(&tz->lock);
+
+	/* Shift the entries in the tz->cdevs array */
+	for (j = indx; j < MAX_CDEVS_PER_ZONE - 1; j++)
+		tz->cdevs[j] = tz->cdevs[j + 1];
+
+	tz->cdev_indx--;
+	mutex_unlock(&tz->lock);
+}
+
 /**
  * thermal_create_sensor_sysfs - create sysfs nodes for sensorX
  * @ts:		the thermal sensor
@@ -593,6 +617,7 @@ EXPORT_SYMBOL_GPL(thermal_cdev_register);
 void thermal_cdev_unregister(struct thermal_cooling_device *cdev)
 {
 	struct thermal_cooling_device *pos, *next;
+	struct thermal_zone *tz;
 	bool found = false;
 
 	if (!cdev)
@@ -610,6 +635,13 @@ void thermal_cdev_unregister(struct thermal_cooling_device *cdev)
 	if (!found)
 		return;
 
+	mutex_lock(&zone_list_lock);
+
+	for_each_thermal_zone(tz)
+		remove_cdev_from_zone(tz, cdev);
+
+	mutex_unlock(&zone_list_lock);
+
 	device_remove_file(&cdev->device, &dev_attr_type);
 	device_remove_file(&cdev->device, &dev_attr_max_state);
 	device_remove_file(&cdev->device, &dev_attr_cur_state);
@@ -688,6 +720,7 @@ void thermal_remove_thermal_zone(struct thermal_zone *tz)
 {
 	struct thermal_zone *pos, *next;
 	struct thermal_sensor *ts;
+	struct thermal_cooling_device *cdev;
 	bool found = false;
 
 	if (!tz)
@@ -709,6 +742,9 @@ void thermal_remove_thermal_zone(struct thermal_zone *tz)
 	for_each_thermal_sensor(ts)
 		remove_sensor_from_zone(tz, ts);
 
+	for_each_cdev(cdev)
+		remove_cdev_from_zone(tz, cdev);
+
 	device_remove_file(&tz->device, &dev_attr_zone_name);
 
 	mutex_destroy(&tz->lock);
@@ -817,3 +853,102 @@ exit_zone:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(thermal_add_sensor_to_zone);
+
+/**
+ * thermal_get_cdev_by_name() - search for a cdev and returns its reference
+ * @name: cooling device name to fetch the reference
+ *
+ * On success returns a reference to an unique cdev with
+ * the name matching that of @name, an ERR_PTR otherwise:
+ * -EINVAL for invalid paramenters
+ * -ENODEV for cdev not found
+ * -EEXIST for multiple matches
+ */
+struct thermal_cooling_device *thermal_get_cdev_by_name(const char *name)
+{
+	int found = 0;
+	struct thermal_cooling_device *pos;
+	struct thermal_cooling_device *cdev = ERR_PTR(-EINVAL);
+
+	if (!name)
+		return cdev;
+
+	mutex_lock(&cdev_list_lock);
+	for_each_cdev(pos) {
+		if (!strnicmp(pos->type, name, THERMAL_NAME_LENGTH)) {
+			found++;
+			cdev = pos;
+		}
+	}
+	mutex_unlock(&cdev_list_lock);
+
+	/*
+	 * Nothing has been found; return an error code for it.
+	 * Return success only when an unique cdev is found.
+	 */
+	if (found == 0)
+		cdev = ERR_PTR(-ENODEV);
+	else if (found > 1)
+		cdev = ERR_PTR(-EEXIST);
+
+	return cdev;
+}
+EXPORT_SYMBOL_GPL(thermal_get_cdev_by_name);
+
+/**
+ * thermal_add_cdev_to_zone - Add @cdev to thermal zone @tz
+ * @tz:		Thermal zone reference
+ * @cdev:	Cooling device reference
+ *
+ * Returns 0 on success, otherwise
+ * -EINVAL for invalid paramenters
+ * -EINVAL when trying to add more cdevs than MAX_CDEVS_PER_ZONE
+ * -EEXIST when trying add existing cdev again
+ */
+int thermal_add_cdev_to_zone(struct thermal_zone *tz,
+			struct thermal_cooling_device *cdev)
+{
+	int ret;
+
+	if (!tz || !cdev)
+		return -EINVAL;
+
+	mutex_lock(&zone_list_lock);
+
+	/* Ensure we are not adding the same cdev again!! */
+	ret = GET_INDEX(tz, cdev, cdev);
+	if (ret >= 0) {
+		ret = -EEXIST;
+		goto exit_zone;
+	}
+
+	/* Protect against 'cdev' being unregistered */
+	mutex_lock(&cdev_list_lock);
+
+	ret = sysfs_create_link(&tz->device.kobj, &cdev->device.kobj,
+				kobject_name(&cdev->device.kobj));
+	if (ret)
+		goto exit_cdev;
+
+	mutex_lock(&tz->lock);
+
+	if (tz->cdev_indx >= MAX_CDEVS_PER_ZONE - 1) {
+		dev_err(&tz->device, "Only %d cdevs allowed per zone\n",
+					MAX_CDEVS_PER_ZONE);
+		sysfs_remove_link(&tz->device.kobj,
+				kobject_name(&cdev->device.kobj));
+		ret = -EINVAL;
+		goto exit_indx_check;
+	}
+
+	tz->cdevs[tz->cdev_indx++] = cdev;
+
+exit_indx_check:
+	mutex_unlock(&tz->lock);
+exit_cdev:
+	mutex_unlock(&cdev_list_lock);
+exit_zone:
+	mutex_unlock(&zone_list_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(thermal_add_cdev_to_zone);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 2afc483..9b080f2 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -60,6 +60,7 @@
 #endif
 
 #define MAX_SENSORS_PER_ZONE		5
+#define MAX_CDEVS_PER_ZONE		5
 
 struct thermal_sensor;
 struct thermal_zone_device;
@@ -226,6 +227,10 @@ struct thermal_zone {
 	/* Sensor level information */
 	int sensor_indx; /* index into 'sensors' array */
 	struct thermal_sensor *sensors[MAX_SENSORS_PER_ZONE];
+
+	/* cdev level information */
+	int cdev_indx; /* index into 'cdevs' array */
+	struct thermal_cooling_device *cdevs[MAX_CDEVS_PER_ZONE];
 };
 
 /* Structure that holds thermal governor information */
@@ -342,6 +347,9 @@ struct thermal_zone *thermal_create_thermal_zone(const char *, void *);
 void thermal_remove_thermal_zone(struct thermal_zone *);
 int thermal_add_sensor_to_zone(struct thermal_zone *, struct thermal_sensor *);
 struct thermal_sensor *thermal_get_sensor_by_name(const char *);
+int thermal_add_cdev_to_zone(struct thermal_zone *,
+				struct thermal_cooling_device *);
+struct thermal_cooling_device *thermal_get_cdev_by_name(const char *);
 
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
-- 
1.7.9.5

