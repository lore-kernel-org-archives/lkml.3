Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaAPS2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:28:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:1111 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbaAPS2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:28:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,668,1384329600"; 
   d="scan'208";a="404034930"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCHv5 03/10] Thermal: Add cooling device APIs
Date: Fri, 17 Jan 2014 05:26:20 +0530
Message-Id: <1389916587-2541-4-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
References: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the cooling device APIs to the
new thermal framework. The register/unregister
APIs stay the same. Below are some minimal
changes:
 * Use DEVICE_ATTR_RO/RW macros
 * Add 'struct idr idr' to struct thermal_cooling_device
 * Tidy up the error handling paths in register API
 * Use thermal_cdev_register as API name, to keep
   THERMAL_V2 APIs along with the existing ones.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_core_new.c |  184 ++++++++++++++++++++++++++++++++++++
 include/linux/thermal.h            |   12 +++
 2 files changed, 196 insertions(+)

diff --git a/drivers/thermal/thermal_core_new.c b/drivers/thermal/thermal_core_new.c
index b369a6f..ba38438 100644
--- a/drivers/thermal/thermal_core_new.c
+++ b/drivers/thermal/thermal_core_new.c
@@ -39,15 +39,21 @@ MODULE_DESCRIPTION("Generic thermal management sysfs support v2");
 MODULE_LICENSE("GPL v2");
 
 static DEFINE_IDR(thermal_sensor_idr);
+static DEFINE_IDR(thermal_cdev_idr);
 
 static LIST_HEAD(thermal_sensor_list);
+static LIST_HEAD(thermal_cdev_list);
 
 static DEFINE_MUTEX(thermal_idr_lock);
 static DEFINE_MUTEX(sensor_list_lock);
+static DEFINE_MUTEX(cdev_list_lock);
 
 #define to_thermal_sensor(_dev) \
 	container_of(_dev, struct thermal_sensor, device)
 
+#define to_cooling_device(_dev)	\
+	container_of(_dev, struct thermal_cooling_device, device)
+
 static int get_idr(struct idr *idr, int *id)
 {
 	int ret;
@@ -168,10 +174,69 @@ threshold_store(struct device *dev, struct device_attribute *attr,
 	return ret ? ret : count;
 }
 
+static ssize_t
+type_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct thermal_cooling_device *cdev = to_cooling_device(dev);
+
+	return sprintf(buf, "%s\n", cdev->type);
+}
+
+static ssize_t
+max_state_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct thermal_cooling_device *cdev = to_cooling_device(dev);
+	unsigned long state;
+	int ret;
+
+	ret = cdev->ops->get_max_state(cdev, &state);
+	if (ret)
+		return ret;
+	return sprintf(buf, "%ld\n", state);
+}
+
+static ssize_t
+cur_state_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct thermal_cooling_device *cdev = to_cooling_device(dev);
+	unsigned long state;
+	int ret;
+
+	ret = cdev->ops->get_cur_state(cdev, &state);
+	if (ret)
+		return ret;
+	return sprintf(buf, "%ld\n", state);
+}
+
+static ssize_t
+cur_state_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct thermal_cooling_device *cdev = to_cooling_device(dev);
+	unsigned long state;
+	int ret;
+
+	ret = sscanf(buf, "%ld\n", &state);
+	if (!ret)
+		return -EINVAL;
+
+	if ((long)state < 0)
+		return -EINVAL;
+
+	ret = cdev->ops->set_cur_state(cdev, state);
+
+	return ret ? ret : count;
+}
+
 /* Thermal sensor attributes */
 static DEVICE_ATTR_RO(name);
 static DEVICE_ATTR_RO(temp);
 
+/* Thermal cooling device attributes */
+static DEVICE_ATTR_RO(type);
+static DEVICE_ATTR_RO(max_state);
+static DEVICE_ATTR_RW(cur_state);
+
 /**
  * thermal_create_sensor_sysfs - create sysfs nodes for sensorX
  * @ts:		the thermal sensor
@@ -365,3 +430,122 @@ void thermal_sensor_unregister(struct thermal_sensor *ts)
 	return;
 }
 EXPORT_SYMBOL_GPL(thermal_sensor_unregister);
+
+/**
+ * thermal_cdev_register() - register a new thermal cooling device
+ * @type:      the thermal cooling device type.
+ * @devdata:   device private data.
+ * @ops:       standard thermal cooling devices callbacks.
+ *
+ * This interface function adds a new thermal cooling device to
+ * /sys/class/thermal/ folder as cooling_device[0-*].
+ *
+ * Return: a pointer to the created struct thermal_cooling_device or an
+ * ERR_PTR. Caller must check return value with IS_ERR*() helpers.
+ */
+struct thermal_cooling_device *thermal_cdev_register(char *type, void *devdata,
+				const struct thermal_cooling_device_ops *ops)
+{
+	struct thermal_cooling_device *cdev;
+	int result;
+
+	if (!type || (type && strlen(type) >= THERMAL_NAME_LENGTH))
+		return ERR_PTR(-EINVAL);
+
+	if (!ops || !ops->get_max_state || !ops->get_cur_state ||
+	    !ops->set_cur_state)
+		return ERR_PTR(-EINVAL);
+
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
+	if (!cdev)
+		return ERR_PTR(-ENOMEM);
+
+	idr_init(&cdev->idr);
+	result = get_idr(&thermal_cdev_idr, &cdev->id);
+	if (result)
+		goto exit_free;
+
+	strlcpy(cdev->type, type ? : "", sizeof(cdev->type));
+	mutex_init(&cdev->lock);
+	cdev->ops = ops;
+	cdev->updated = true;
+	cdev->device.class = &thermal_class;
+	cdev->devdata = devdata;
+
+	dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
+	result = device_register(&cdev->device);
+	if (result)
+		goto exit_idr;
+
+	result = device_create_file(&cdev->device, &dev_attr_type);
+	if (result)
+		goto exit_unregister;
+
+	result = device_create_file(&cdev->device, &dev_attr_max_state);
+	if (result)
+		goto exit_type;
+
+	result = device_create_file(&cdev->device, &dev_attr_cur_state);
+	if (result) {
+		device_remove_file(&cdev->device, &dev_attr_max_state);
+		goto exit_type;
+	}
+
+	/* Add 'this' new cdev to the global cdev list */
+	mutex_lock(&cdev_list_lock);
+	list_add(&cdev->node, &thermal_cdev_list);
+	mutex_unlock(&cdev_list_lock);
+
+	return cdev;
+
+exit_type:
+	device_remove_file(&cdev->device, &dev_attr_type);
+exit_unregister:
+	device_unregister(&cdev->device);
+exit_idr:
+	release_idr(&thermal_cdev_idr, cdev->id);
+	idr_destroy(&cdev->idr);
+exit_free:
+	kfree(cdev);
+	return ERR_PTR(result);
+}
+EXPORT_SYMBOL_GPL(thermal_cdev_register);
+
+/**
+ * thermal_cdev_unregister - removes the registered thermal cooling device
+ * @cdev:      the thermal cooling device to remove.
+ *
+ * thermal_cdev_unregister() must be called when the device is no
+ * longer needed.
+ */
+void thermal_cdev_unregister(struct thermal_cooling_device *cdev)
+{
+	struct thermal_cooling_device *pos, *next;
+	bool found = false;
+
+	if (!cdev)
+		return;
+
+	mutex_lock(&cdev_list_lock);
+	list_for_each_entry_safe(pos, next, &thermal_cdev_list, node) {
+		if (pos == cdev) {
+			list_del(&cdev->node);
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&cdev_list_lock);
+	if (!found)
+		return;
+
+	device_remove_file(&cdev->device, &dev_attr_type);
+	device_remove_file(&cdev->device, &dev_attr_max_state);
+	device_remove_file(&cdev->device, &dev_attr_cur_state);
+
+	release_idr(&thermal_cdev_idr, cdev->id);
+	idr_destroy(&cdev->idr);
+	device_unregister(&cdev->device);
+	kfree(cdev);
+	return;
+}
+EXPORT_SYMBOL_GPL(thermal_cdev_unregister);
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index bb6b183..46d7dc3 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -158,6 +158,7 @@ struct thermal_cooling_device {
 	void *devdata;
 	const struct thermal_cooling_device_ops *ops;
 	bool updated; /* true if the cooling device does not need update */
+	struct idr idr;
 	struct mutex lock; /* protect thermal_instances list */
 	struct list_head thermal_instances;
 	struct list_head node;
@@ -334,6 +335,9 @@ static inline int thermal_generate_netlink_event(struct thermal_zone_device *tz,
 struct thermal_sensor *thermal_sensor_register(const char *, int,
 				struct thermal_sensor_ops *, void *);
 void thermal_sensor_unregister(struct thermal_sensor *);
+struct thermal_cooling_device *thermal_cdev_register(char *, void *,
+				const struct thermal_cooling_device_ops *);
+void thermal_cdev_unregister(struct thermal_cooling_device *);
 #else
 static inline struct thermal_sensor *thermal_sensor_register(const char *name,
 		int count, struct thermal_sensor_ops *ops, void *devdata)
@@ -341,5 +345,13 @@ static inline struct thermal_sensor *thermal_sensor_register(const char *name,
 	return ERR_PTR(-ENODEV);
 }
 static inline void thermal_sensor_unregister(struct thermal_sensor *ts) {}
+static inline struct thermal_cooling_device *thermal_cdev_register(
+				char *type, void *devdata,
+				const struct thermal_cooling_device_ops *ops)
+{
+	return ERR_PTR(-ENODEV);
+}
+static
+inline void thermal_cdev_unregister(struct thermal_cooling_device *cdev) {}
 #endif
 #endif /* __THERMAL_H__ */
-- 
1.7.9.5

