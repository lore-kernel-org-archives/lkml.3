Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3IACts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 22:49:48 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38042 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab3IACt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 22:49:27 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 7/9] hwmon: Provide managed hwmon registration
Date: Sat, 31 Aug 2013 19:49:00 -0700
Message-Id: <1378003742-18685-8-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
References: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers using the new hwmon_device_register_with_groups API often have a
remove function which consists solely of a call hwmon_device_unregister().

Provide support for devm_hwmon_device_register_with_groups and
devm_hwmon_device_unregister to allow this repeated code to be removed
and help eliminate error handling code.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/hwmon.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hwmon.h |    5 ++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 69323d3..90e539e 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -162,6 +162,69 @@ void hwmon_device_unregister(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(hwmon_device_unregister);
 
+static void devm_hwmon_release(struct device *dev, void *res)
+{
+	struct device *hwdev = *(struct device **)res;
+
+	hwmon_device_unregister(hwdev);
+}
+
+/**
+ * devm_hwmon_device_register_with_groups - register w/ hwmon
+ * @dev: the parent device
+ * @name: hwmon name attribute
+ * @drvdata: driver data to attach to created device
+ * @groups: List of attribute groups to create
+ *
+ * Returns the pointer to the new device. The new device is automatically
+ * unregistered with the parent device.
+ */
+struct device *
+devm_hwmon_device_register_with_groups(struct device *dev, const char *name,
+				       void *drvdata,
+				       const struct attribute_group **groups)
+{
+	struct device **ptr, *hwdev;
+
+	if (!dev)
+		return ERR_PTR(-EINVAL);
+
+	ptr = devres_alloc(devm_hwmon_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	hwdev = hwmon_device_register_with_groups(dev, name, drvdata, groups);
+	if (IS_ERR(hwdev))
+		goto error;
+
+	*ptr = hwdev;
+	devres_add(dev, ptr);
+	return hwdev;
+
+error:
+	devres_free(ptr);
+	return hwdev;
+}
+EXPORT_SYMBOL_GPL(devm_hwmon_device_register_with_groups);
+
+static int devm_hwmon_match(struct device *dev, void *res, void *data)
+{
+	struct device **hwdev = res;
+
+	return *hwdev == data;
+}
+
+/**
+ * devm_hwmon_device_unregister - removes a previously registered hwmon device
+ *
+ * @dev: the parent device of the device to unregister
+ */
+void devm_hwmon_device_unregister(struct device *dev)
+{
+	WARN_ON(devres_release(dev, devm_hwmon_release, devm_hwmon_match, dev));
+}
+EXPORT_SYMBOL_GPL(devm_hwmon_device_unregister);
+
 static void __init hwmon_pci_quirks(void)
 {
 #if defined CONFIG_X86 && defined CONFIG_PCI
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index 6d02ff7..09354f6 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -22,7 +22,12 @@ struct device *
 hwmon_device_register_with_groups(struct device *dev, const char *name,
 				  void *drvdata,
 				  const struct attribute_group **groups);
+struct device *
+devm_hwmon_device_register_with_groups(struct device *dev, const char *name,
+				       void *drvdata,
+				       const struct attribute_group **groups);
 
 void hwmon_device_unregister(struct device *dev);
+void devm_hwmon_device_unregister(struct device *dev);
 
 #endif
-- 
1.7.9.7

