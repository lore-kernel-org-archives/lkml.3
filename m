Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3IACtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 22:49:23 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56491 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3IACtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 22:49:14 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 1/9] hwmon: Introduce hwmon_device_register_with_groups
Date: Sat, 31 Aug 2013 19:48:54 -0700
Message-Id: <1378003742-18685-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
References: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwmon_device_register_with_groups() lets callers register a hwmon device
together with all sysfs attributes in a single call.

When using hwmon_device_register_with_groups(), hwmon attributes are attached
to the hwmon device directly and no longer with its parent device.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/hwmon.c |  121 ++++++++++++++++++++++++++++++++++++++++++-------
 include/linux/hwmon.h |    5 ++
 2 files changed, 110 insertions(+), 16 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 646314f..69323d3 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -25,35 +25,122 @@
 #define HWMON_ID_PREFIX "hwmon"
 #define HWMON_ID_FORMAT HWMON_ID_PREFIX "%d"
 
-static struct class *hwmon_class;
+struct hwmon_device {
+	const char *name;
+	struct device dev;
+};
+#define to_hwmon_device(d) container_of(d, struct hwmon_device, dev)
+
+static ssize_t
+show_name(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", to_hwmon_device(dev)->name);
+}
+static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
+
+static struct attribute *hwmon_dev_attrs[] = {
+	&dev_attr_name.attr,
+	NULL
+};
+
+static umode_t hwmon_dev_name_is_visible(struct kobject *kobj,
+					 struct attribute *attr, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+
+	if (to_hwmon_device(dev)->name == NULL)
+		return 0;
+
+	return attr->mode;
+}
+
+static struct attribute_group hwmon_dev_attr_group = {
+	.attrs		= hwmon_dev_attrs,
+	.is_visible	= hwmon_dev_name_is_visible,
+};
+
+static const struct attribute_group *hwmon_dev_attr_groups[] = {
+	&hwmon_dev_attr_group,
+	NULL
+};
+
+static void hwmon_dev_release(struct device *dev)
+{
+	kfree(to_hwmon_device(dev));
+}
+
+static struct class hwmon_class = {
+	.name = "hwmon",
+	.owner = THIS_MODULE,
+	.dev_groups = hwmon_dev_attr_groups,
+	.dev_release = hwmon_dev_release,
+};
 
 static DEFINE_IDA(hwmon_ida);
 
 /**
- * hwmon_device_register - register w/ hwmon
- * @dev: the device to register
+ * hwmon_device_register_with_groups - register w/ hwmon
+ * @dev: the parent device
+ * @name: hwmon name attribute
+ * @drvdata: driver data to attach to created device
+ * @groups: List of attribute groups to create
  *
  * hwmon_device_unregister() must be called when the device is no
  * longer needed.
  *
  * Returns the pointer to the new device.
  */
-struct device *hwmon_device_register(struct device *dev)
+struct device *
+hwmon_device_register_with_groups(struct device *dev, const char *name,
+				  void *drvdata,
+				  const struct attribute_group **groups)
 {
-	struct device *hwdev;
-	int id;
+	struct hwmon_device *hwdev;
+	int err, id;
 
 	id = ida_simple_get(&hwmon_ida, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		return ERR_PTR(id);
 
-	hwdev = device_create(hwmon_class, dev, MKDEV(0, 0), NULL,
-			      HWMON_ID_FORMAT, id);
+	hwdev = kzalloc(sizeof(*hwdev), GFP_KERNEL);
+	if (hwdev == NULL) {
+		err = -ENOMEM;
+		goto ida_remove;
+	}
 
-	if (IS_ERR(hwdev))
-		ida_simple_remove(&hwmon_ida, id);
+	hwdev->name = name;
+	hwdev->dev.class = &hwmon_class;
+	hwdev->dev.parent = dev;
+	hwdev->dev.groups = groups;
+	hwdev->dev.of_node = dev ? dev->of_node : NULL;
+	dev_set_drvdata(&hwdev->dev, drvdata);
+	dev_set_name(&hwdev->dev, HWMON_ID_FORMAT, id);
+	err = device_register(&hwdev->dev);
+	if (err)
+		goto free;
+
+	return &hwdev->dev;
+
+free:
+	kfree(hwdev);
+ida_remove:
+	ida_simple_remove(&hwmon_ida, id);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(hwmon_device_register_with_groups);
 
-	return hwdev;
+/**
+ * hwmon_device_register - register w/ hwmon
+ * @dev: the device to register
+ *
+ * hwmon_device_unregister() must be called when the device is no
+ * longer needed.
+ *
+ * Returns the pointer to the new device.
+ */
+struct device *hwmon_device_register(struct device *dev)
+{
+	return hwmon_device_register_with_groups(dev, NULL, NULL, NULL);
 }
 EXPORT_SYMBOL_GPL(hwmon_device_register);
 
@@ -105,19 +192,21 @@ static void __init hwmon_pci_quirks(void)
 
 static int __init hwmon_init(void)
 {
+	int err;
+
 	hwmon_pci_quirks();
 
-	hwmon_class = class_create(THIS_MODULE, "hwmon");
-	if (IS_ERR(hwmon_class)) {
-		pr_err("couldn't create sysfs class\n");
-		return PTR_ERR(hwmon_class);
+	err = class_register(&hwmon_class);
+	if (err) {
+		pr_err("couldn't register hwmon sysfs class\n");
+		return err;
 	}
 	return 0;
 }
 
 static void __exit hwmon_exit(void)
 {
-	class_destroy(hwmon_class);
+	class_unregister(&hwmon_class);
 }
 
 subsys_initcall(hwmon_init);
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index b2514f7..6d02ff7 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -15,8 +15,13 @@
 #define _HWMON_H_
 
 struct device;
+struct attribute_group;
 
 struct device *hwmon_device_register(struct device *dev);
+struct device *
+hwmon_device_register_with_groups(struct device *dev, const char *name,
+				  void *drvdata,
+				  const struct attribute_group **groups);
 
 void hwmon_device_unregister(struct device *dev);
 
-- 
1.7.9.7

