Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaAPS2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:28:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:23616 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbaAPS2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:28:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,668,1384329600"; 
   d="scan'208";a="404034891"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCHv5 02/10] Thermal: Create sensor level APIs
Date: Fri, 17 Jan 2014 05:26:19 +0530
Message-Id: <1389916587-2541-3-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
References: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates sensor level APIs, in the
generic thermal framework, in a new file named
thermal_core_new.c. The thermal_class variable
is moved as extern to thermal_core.h to
facilitate co-existence of both the APIs.

A Thermal sensor is a piece of hardware that can report
temperature of the spot in which it is placed. A thermal
sensor driver reads the temperature from this sensor
and reports it out. This kind of driver can be in
any subsystem. If the sensor needs to participate
in platform thermal management, the corresponding
driver can use the APIs introduced in this patch, to
register(or unregister) with the thermal framework.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/Kconfig            |    3 +
 drivers/thermal/Makefile           |    1 +
 drivers/thermal/thermal_core.c     |    2 +-
 drivers/thermal/thermal_core.h     |    1 +
 drivers/thermal/thermal_core_new.c |  367 ++++++++++++++++++++++++++++++++++++
 include/linux/thermal.h            |   37 ++++
 6 files changed, 410 insertions(+), 1 deletion(-)
 create mode 100644 drivers/thermal/thermal_core_new.c

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 35c0664..f6a8057 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -15,6 +15,9 @@ menuconfig THERMAL
 
 if THERMAL
 
+config THERMAL_V2
+	bool
+
 config THERMAL_HWMON
 	bool
 	prompt "Expose thermal sensors as hwmon device"
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 54e4ec9..d9ae9ac 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_THERMAL)		+= thermal_sys.o
 thermal_sys-y			+= thermal_core.o
+thermal_sys-$(CONFIG_THERMAL_V2) += thermal_core_new.o
 
 # interface to/from other layers providing sensors
 thermal_sys-$(CONFIG_THERMAL_HWMON)		+= thermal_hwmon.o
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 165afc6..a17702f 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1045,7 +1045,7 @@ static void thermal_release(struct device *dev)
 	/* No-op since kfree(dev) is done in _unregister functions */
 }
 
-static struct class thermal_class = {
+struct class thermal_class = {
 	.name = "thermal",
 	.dev_release = thermal_release,
 };
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index 3db339f..adf817c 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -27,6 +27,7 @@
 #include <linux/device.h>
 #include <linux/thermal.h>
 
+extern struct class thermal_class;
 /* Initial state of a cooling device during binding */
 #define THERMAL_NO_TARGET -1UL
 
diff --git a/drivers/thermal/thermal_core_new.c b/drivers/thermal/thermal_core_new.c
new file mode 100644
index 0000000..b369a6f
--- /dev/null
+++ b/drivers/thermal/thermal_core_new.c
@@ -0,0 +1,367 @@
+/*
+ *  thermal_core_new.c - Generic Thermal Management Sysfs support.
+ *  Derived from the previous thermal_core.c
+ *  This adds multiple sensor per zone support along with various
+ *  options to provide platform data for Thermal management.
+ *
+ *  Copyright (C) 2014 Intel Corporation
+ *
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/kdev_t.h>
+#include <linux/idr.h>
+#include <linux/thermal.h>
+#include <linux/reboot.h>
+#include <linux/string.h>
+
+#include "thermal_core.h"
+
+MODULE_AUTHOR("Durgadoss R");
+MODULE_DESCRIPTION("Generic thermal management sysfs support v2");
+MODULE_LICENSE("GPL v2");
+
+static DEFINE_IDR(thermal_sensor_idr);
+
+static LIST_HEAD(thermal_sensor_list);
+
+static DEFINE_MUTEX(thermal_idr_lock);
+static DEFINE_MUTEX(sensor_list_lock);
+
+#define to_thermal_sensor(_dev) \
+	container_of(_dev, struct thermal_sensor, device)
+
+static int get_idr(struct idr *idr, int *id)
+{
+	int ret;
+
+	mutex_lock(&thermal_idr_lock);
+	ret = idr_alloc(idr, NULL, 0, 0, GFP_KERNEL);
+	mutex_unlock(&thermal_idr_lock);
+
+	if (unlikely(ret < 0))
+		return ret;
+
+	*id = ret;
+	return 0;
+}
+
+static void release_idr(struct idr *idr, int id)
+{
+	mutex_lock(&thermal_idr_lock);
+	idr_remove(idr, id);
+	mutex_unlock(&thermal_idr_lock);
+}
+
+static ssize_t
+name_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct thermal_sensor *ts = to_thermal_sensor(dev);
+
+	return sprintf(buf, "%s\n", ts->name);
+}
+
+static ssize_t
+temp_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int ret;
+	long val;
+	struct thermal_sensor *ts = to_thermal_sensor(dev);
+
+	ret = ts->ops->get_temp(ts, &val);
+
+	return ret ? ret : sprintf(buf, "%ld\n", val);
+}
+
+static ssize_t
+hyst_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int indx, ret;
+	long val;
+	struct thermal_sensor *ts = to_thermal_sensor(dev);
+
+	ret = sscanf(attr->attr.name, "threshold%d_hyst", &indx);
+	if (!ret)
+		return -EINVAL;
+
+	ret = ts->ops->get_hyst(ts, indx, &val);
+
+	return ret ? ret : sprintf(buf, "%ld\n", val);
+}
+
+static ssize_t
+hyst_store(struct device *dev, struct device_attribute *attr,
+	   const char *buf, size_t count)
+{
+	int indx, ret;
+	long val;
+	struct thermal_sensor *ts = to_thermal_sensor(dev);
+
+	if (!ts->ops->set_hyst)
+		return -EPERM;
+
+	ret = sscanf(attr->attr.name, "threshold%d_hyst", &indx);
+	if (!ret)
+		return -EINVAL;
+
+	if (kstrtol(buf, 10, &val))
+		return -EINVAL;
+
+	ret = ts->ops->set_hyst(ts, indx, val);
+
+	return ret ? ret : count;
+}
+
+static ssize_t
+threshold_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	int indx, ret;
+	long val;
+	struct thermal_sensor *ts = to_thermal_sensor(dev);
+
+	ret = sscanf(attr->attr.name, "threshold%d", &indx);
+	if (!ret)
+		return -EINVAL;
+
+	ret = ts->ops->get_threshold(ts, indx, &val);
+
+	return ret ? ret : sprintf(buf, "%ld\n", val);
+}
+
+static ssize_t
+threshold_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	int indx, ret;
+	long val;
+	struct thermal_sensor *ts = to_thermal_sensor(dev);
+
+	if (!ts->ops->set_threshold)
+		return -EPERM;
+
+	ret = sscanf(attr->attr.name, "threshold%d", &indx);
+	if (!ret)
+		return -EINVAL;
+
+	if (kstrtol(buf, 10, &val))
+		return -EINVAL;
+
+	ret = ts->ops->set_threshold(ts, indx, val);
+
+	return ret ? ret : count;
+}
+
+/* Thermal sensor attributes */
+static DEVICE_ATTR_RO(name);
+static DEVICE_ATTR_RO(temp);
+
+/**
+ * thermal_create_sensor_sysfs - create sysfs nodes for sensorX
+ * @ts:		the thermal sensor
+ * @count:	Number of thresholds supported by sensor hardware
+ *
+ * 'Thresholds' are temperatures programmed into the sensor hardware,
+ * on crossing which the sensor may generate an interrupt.
+ */
+static int thermal_create_sensor_sysfs(struct thermal_sensor *ts, int count)
+{
+	int i, ret;
+	int size = sizeof(struct thermal_attr) * count;
+
+	ret = device_create_file(&ts->device, &dev_attr_name);
+	if (ret)
+		return ret;
+
+	ret = device_create_file(&ts->device, &dev_attr_temp);
+	if (ret)
+		goto exit_name;
+
+	/*
+	 * If the sensor does not support any thresholds
+	 * or, we cannot read the thresholds then do not
+	 * create these sysfs nodes. This is not an error.
+	 */
+	if (count < 1 || !ts->ops->get_threshold)
+		return 0;
+
+	ts->thresh_attrs = devm_kzalloc(&ts->device, size, GFP_KERNEL);
+	if (!ts->thresh_attrs) {
+		ret = -ENOMEM;
+		goto exit_temp;
+	}
+
+	if (ts->ops->get_hyst) {
+		ts->hyst_attrs = devm_kzalloc(&ts->device, size, GFP_KERNEL);
+		if (!ts->hyst_attrs) {
+			ret = -ENOMEM;
+			goto exit_temp;
+		}
+	}
+
+	ts->thresholds = count;
+
+	/* Create threshold attributes */
+	for (i = 0; i < count; i++) {
+		snprintf(ts->thresh_attrs[i].name, THERMAL_NAME_LENGTH,
+			 "threshold%d", i);
+
+		sysfs_attr_init(&ts->thresh_attrs[i].attr.attr);
+		ts->thresh_attrs[i].attr.attr.name = ts->thresh_attrs[i].name;
+		ts->thresh_attrs[i].attr.attr.mode = S_IRUGO | S_IWUSR;
+		ts->thresh_attrs[i].attr.show = threshold_show;
+		ts->thresh_attrs[i].attr.store = threshold_store;
+
+		device_create_file(&ts->device, &ts->thresh_attrs[i].attr);
+
+		/* Create threshold_hyst attributes */
+		if (!ts->ops->get_hyst)
+			continue;
+
+		snprintf(ts->hyst_attrs[i].name, THERMAL_NAME_LENGTH,
+			 "threshold%d_hyst", i);
+
+		sysfs_attr_init(&ts->hyst_attrs[i].attr.attr);
+		ts->hyst_attrs[i].attr.attr.name = ts->hyst_attrs[i].name;
+		ts->hyst_attrs[i].attr.attr.mode = S_IRUGO | S_IWUSR;
+		ts->hyst_attrs[i].attr.show = hyst_show;
+		ts->hyst_attrs[i].attr.store = hyst_store;
+
+		device_create_file(&ts->device, &ts->hyst_attrs[i].attr);
+	}
+	return 0;
+
+exit_temp:
+	device_remove_file(&ts->device, &dev_attr_temp);
+exit_name:
+	device_remove_file(&ts->device, &dev_attr_name);
+	return ret;
+}
+
+/**
+ * thermal_sensor_register - register a new thermal sensor
+ * @name:	name of the thermal sensor
+ * @count:	Number of thresholds supported by hardware
+ * @ops:	standard thermal sensor callbacks
+ * @devdata:	private device data
+ *
+ * On Success returns a thermal sensor reference, otherwise:
+ * -EINVAL for invalid parameters,
+ * -ENOMEM for insufficient memory cases,
+ */
+struct thermal_sensor *thermal_sensor_register(const char *name, int count,
+					       struct thermal_sensor_ops *ops,
+					       void *devdata)
+{
+	struct thermal_sensor *ts;
+	int ret;
+
+	if (!name || (name && strlen(name) >= THERMAL_NAME_LENGTH))
+		return ERR_PTR(-EINVAL);
+
+	if (!ops || !ops->get_temp)
+		return ERR_PTR(-EINVAL);
+
+	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
+	if (!ts)
+		return ERR_PTR(-ENOMEM);
+
+	idr_init(&ts->idr);
+	ret = get_idr(&thermal_sensor_idr, &ts->id);
+	if (ret)
+		goto exit_free;
+
+	strlcpy(ts->name, name, sizeof(ts->name));
+	ts->ops = ops;
+	ts->devdata = devdata;
+	ts->device.class = &thermal_class;
+
+	dev_set_name(&ts->device, "sensor%d", ts->id);
+	ret = device_register(&ts->device);
+	if (ret)
+		goto exit_idr;
+
+	ret = thermal_create_sensor_sysfs(ts, count);
+	if (ret)
+		goto exit_unregister;
+
+	/* Add this sensor to the global list of sensors */
+	mutex_lock(&sensor_list_lock);
+	list_add_tail(&ts->node, &thermal_sensor_list);
+	mutex_unlock(&sensor_list_lock);
+
+	return ts;
+
+exit_unregister:
+	device_unregister(&ts->device);
+exit_idr:
+	release_idr(&thermal_sensor_idr, ts->id);
+	idr_destroy(&ts->idr);
+exit_free:
+	kfree(ts);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(thermal_sensor_register);
+
+/**
+ * remove_thermal_zone - removes the sysfs nodes for given sensor
+ * @ts:	Thermal sensor to be removed.
+ */
+void thermal_sensor_unregister(struct thermal_sensor *ts)
+{
+	int i;
+	struct thermal_sensor *pos, *next;
+	bool found = false;
+
+	if (!ts)
+		return;
+
+	mutex_lock(&sensor_list_lock);
+	list_for_each_entry_safe(pos, next, &thermal_sensor_list, node) {
+		if (pos == ts) {
+			list_del(&ts->node);
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&sensor_list_lock);
+
+	if (!found)
+		return;
+
+	for (i = 0; i < ts->thresholds; i++) {
+		device_remove_file(&ts->device, &ts->thresh_attrs[i].attr);
+		if (ts->ops->get_hyst) {
+			device_remove_file(&ts->device,
+					   &ts->hyst_attrs[i].attr);
+		}
+	}
+
+	device_remove_file(&ts->device, &dev_attr_name);
+	device_remove_file(&ts->device, &dev_attr_temp);
+
+	release_idr(&thermal_sensor_idr, ts->id);
+	idr_destroy(&ts->idr);
+
+	device_unregister(&ts->device);
+
+	kfree(ts);
+	return;
+}
+EXPORT_SYMBOL_GPL(thermal_sensor_unregister);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index f7e11c7..bb6b183 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -59,6 +59,7 @@
 #define DEFAULT_THERMAL_GOVERNOR       "user_space"
 #endif
 
+struct thermal_sensor;
 struct thermal_zone_device;
 struct thermal_cooling_device;
 
@@ -140,6 +141,15 @@ struct thermal_cooling_device_ops {
 	int (*set_cur_state) (struct thermal_cooling_device *, unsigned long);
 };
 
+struct thermal_sensor_ops {
+	int (*get_temp) (struct thermal_sensor *, long *);
+	int (*get_trend) (struct thermal_sensor *, int, enum thermal_trend *);
+	int (*set_threshold) (struct thermal_sensor *, int, long);
+	int (*get_threshold) (struct thermal_sensor *, int, long *);
+	int (*set_hyst) (struct thermal_sensor *, int, long);
+	int (*get_hyst) (struct thermal_sensor *, int, long *);
+};
+
 struct thermal_cooling_device {
 	int id;
 	char type[THERMAL_NAME_LENGTH];
@@ -158,6 +168,21 @@ struct thermal_attr {
 	char name[THERMAL_NAME_LENGTH];
 };
 
+struct thermal_sensor {
+	char name[THERMAL_NAME_LENGTH];
+	int id;
+	int temp;
+	int prev_temp;
+	int thresholds;
+	void *devdata;
+	struct idr idr;
+	struct device device;
+	struct list_head node;
+	struct thermal_sensor_ops *ops;
+	struct thermal_attr *thresh_attrs;
+	struct thermal_attr *hyst_attrs;
+};
+
 struct thermal_zone_device {
 	int id;
 	char type[THERMAL_NAME_LENGTH];
@@ -305,4 +330,16 @@ static inline int thermal_generate_netlink_event(struct thermal_zone_device *tz,
 }
 #endif
 
+#ifdef CONFIG_THERMAL_V2
+struct thermal_sensor *thermal_sensor_register(const char *, int,
+				struct thermal_sensor_ops *, void *);
+void thermal_sensor_unregister(struct thermal_sensor *);
+#else
+static inline struct thermal_sensor *thermal_sensor_register(const char *name,
+		int count, struct thermal_sensor_ops *ops, void *devdata)
+{
+	return ERR_PTR(-ENODEV);
+}
+static inline void thermal_sensor_unregister(struct thermal_sensor *ts) {}
+#endif
 #endif /* __THERMAL_H__ */
-- 
1.7.9.5

