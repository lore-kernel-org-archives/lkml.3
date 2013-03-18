Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab3CRBqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 21:46:10 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64066 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3CRBqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 21:46:08 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Sun, 17 Mar 2013 20:46:03 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 1/8] hwmon: Add devres support
Date: Sun, 17 Mar 2013 18:45:50 -0700
Message-Id: <1363571157-16273-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
References: <1363571157-16273-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provices new API functions devm_hwmon_device_register() and
devm_hwmon_device_unregister().

devm_hwmon_device_register() has a new parameter, a pointer to an array of type
attribute_group. When using this API, callers to not have to create or remove
sysfs attribute groups. Instead, attributes are created by the infrastructure.

devm_hwmon_device_unregister() does not have to be called except for error
handling.

The new API attaches the provided attributes to the hwmon device.
It automatically creates a 'name' attribute as required by the hwmon sysfs ABI.
The name is set to either the name provided with devm_hwmon_device_register
or the name of the hardware device driver.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/hwmon.c |  123 +++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/hwmon.h |    5 ++
 2 files changed, 119 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 646314f..4681b98 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -29,6 +29,51 @@ static struct class *hwmon_class;
 
 static DEFINE_IDA(hwmon_ida);
 
+static void hwmon_device_register_release(struct device *dev)
+{
+	kfree(dev);
+}
+
+static struct device *_hwmon_device_register(struct device *dev,
+					const struct attribute_group **groups,
+					const char *name)
+{
+	struct device *hwdev;
+	int id, err;
+
+	hwdev = kzalloc(sizeof(*hwdev), GFP_KERNEL);
+	if (!hwdev)
+		return ERR_PTR(-ENOMEM);
+
+	id = ida_simple_get(&hwmon_ida, 0, 0, GFP_KERNEL);
+	if (id < 0) {
+		err = id;
+		goto err_free;
+	}
+
+	hwdev->groups = groups;
+	hwdev->class = hwmon_class;
+	hwdev->parent = dev;
+	hwdev->release = hwmon_device_register_release;
+	dev_set_drvdata(hwdev, (void *)name);
+
+	err = kobject_set_name(&hwdev->kobj, HWMON_ID_FORMAT, id);
+	if (err)
+		goto err_remove;
+
+	err = device_register(hwdev);
+	if (err)
+		goto err_remove;
+
+	return hwdev;
+
+err_remove:
+	ida_simple_remove(&hwmon_ida, id);
+err_free:
+	kfree(hwdev);
+	return ERR_PTR(err);
+}
+
 /**
  * hwmon_device_register - register w/ hwmon
  * @dev: the device to register
@@ -40,22 +85,52 @@ static DEFINE_IDA(hwmon_ida);
  */
 struct device *hwmon_device_register(struct device *dev)
 {
+	return _hwmon_device_register(dev, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(hwmon_device_register);
+
+struct hwmon_devres {
+	struct list_head node;
 	struct device *hwdev;
-	int id;
+};
 
-	id = ida_simple_get(&hwmon_ida, 0, 0, GFP_KERNEL);
-	if (id < 0)
-		return ERR_PTR(id);
+static void devm_hwmon_release(struct device *dev, void *res)
+{
+	struct hwmon_devres *devres = res;
 
-	hwdev = device_create(hwmon_class, dev, MKDEV(0, 0), NULL,
-			      HWMON_ID_FORMAT, id);
+	hwmon_device_unregister(devres->hwdev);
+}
 
-	if (IS_ERR(hwdev))
-		ida_simple_remove(&hwmon_ida, id);
+struct device *devm_hwmon_device_register(struct device *dev,
+					  const struct attribute_group **groups,
+					  const char *name)
+{
+	struct hwmon_devres *devres;
+	struct device *hwdev;
+	int err;
+
+	if (!dev)
+		return ERR_PTR(-EINVAL);
+
+	devres = devres_alloc(devm_hwmon_release, sizeof(*devres),
+			      GFP_KERNEL);
+	if (!devres)
+		return ERR_PTR(-ENOMEM);
 
+	hwdev = _hwmon_device_register(dev, groups, name);
+	if (IS_ERR(hwdev)) {
+		err = PTR_ERR(hwdev);
+		goto err_free;
+	}
+	devres->hwdev = hwdev;
+	devres_add(dev, devres);
 	return hwdev;
+
+err_free:
+	devres_free(devres);
+	return ERR_PTR(err);
 }
-EXPORT_SYMBOL_GPL(hwmon_device_register);
+EXPORT_SYMBOL_GPL(devm_hwmon_device_register);
 
 /**
  * hwmon_device_unregister - removes the previously registered class device
@@ -75,6 +150,22 @@ void hwmon_device_unregister(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(hwmon_device_unregister);
 
+static int devm_hwmon_match(struct device *dev, void *res, void *data)
+{
+	struct hwmon_devres *devres = res;
+
+	return devres->hwdev == data;
+}
+
+void devm_hwmon_device_unregister(struct device *hwdev)
+{
+	WARN_ON(devres_destroy(hwdev->parent, devm_hwmon_release,
+			       devm_hwmon_match, hwdev));
+
+	hwmon_device_unregister(hwdev);
+}
+EXPORT_SYMBOL_GPL(devm_hwmon_device_unregister);
+
 static void __init hwmon_pci_quirks(void)
 {
 #if defined CONFIG_X86 && defined CONFIG_PCI
@@ -103,6 +194,19 @@ static void __init hwmon_pci_quirks(void)
 #endif
 }
 
+static ssize_t hwmon_name_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	const char *name = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", name ? : dev->parent->driver->name);
+}
+
+struct device_attribute hwmon_dev_attrs[] = {
+	__ATTR(name, S_IRUGO, hwmon_name_show, NULL),
+	__ATTR_NULL,
+};
+
 static int __init hwmon_init(void)
 {
 	hwmon_pci_quirks();
@@ -112,6 +216,7 @@ static int __init hwmon_init(void)
 		pr_err("couldn't create sysfs class\n");
 		return PTR_ERR(hwmon_class);
 	}
+	hwmon_class->dev_attrs = hwmon_dev_attrs;
 	return 0;
 }
 
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index b2514f7..67c9c08 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -15,9 +15,14 @@
 #define _HWMON_H_
 
 struct device;
+struct attribute_group;
 
 struct device *hwmon_device_register(struct device *dev);
+struct device *devm_hwmon_device_register(struct device *dev,
+					const struct attribute_group **groups,
+					const char *name);
 
 void hwmon_device_unregister(struct device *dev);
+void devm_hwmon_device_unregister(struct device *dev);
 
 #endif
-- 
1.7.9.7

