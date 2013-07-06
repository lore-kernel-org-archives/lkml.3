Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3GFRZT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 13:25:19 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59394 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3GFRZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 13:25:17 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 1/5] driver core: Introduce device_create_groups
Date: Sat,  6 Jul 2013 10:24:51 -0700
Message-Id: <1373131495-13465-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1373131495-13465-1-git-send-email-linux@roeck-us.net>
References: <1373131495-13465-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create_groups lets callers create devices as well as associated
sysfs attributes with a single call. This avoids race conditions seen
if sysfs attributes on new devices are created later.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/base/core.c    |   60 +++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/device.h |    4 ++++
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index dc3ea23..dd82645 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1692,9 +1692,11 @@ static void device_create_release(struct device *dev)
  * Note: the struct class passed to this function must have previously
  * been created with a call to class_create().
  */
-struct device *device_create_vargs(struct class *class, struct device *parent,
-				   dev_t devt, void *drvdata, const char *fmt,
-				   va_list args)
+static struct device *
+device_create_groups_vargs(struct class *class, struct device *parent,
+			   dev_t devt, void *drvdata,
+			   const struct attribute_group **groups,
+			   const char *fmt, va_list args)
 {
 	struct device *dev = NULL;
 	int retval = -ENODEV;
@@ -1711,6 +1713,7 @@ struct device *device_create_vargs(struct class *class, struct device *parent,
 	dev->devt = devt;
 	dev->class = class;
 	dev->parent = parent;
+	dev->groups = groups;
 	dev->release = device_create_release;
 	dev_set_drvdata(dev, drvdata);
 
@@ -1728,6 +1731,14 @@ error:
 	put_device(dev);
 	return ERR_PTR(retval);
 }
+
+struct device *device_create_vargs(struct class *class, struct device *parent,
+				   dev_t devt, void *drvdata, const char *fmt,
+				   va_list args)
+{
+	return device_create_groups_vargs(class, parent, devt, drvdata, NULL,
+					  fmt, args);
+}
 EXPORT_SYMBOL_GPL(device_create_vargs);
 
 /**
@@ -1767,6 +1778,49 @@ struct device *device_create(struct class *class, struct device *parent,
 }
 EXPORT_SYMBOL_GPL(device_create);
 
+/**
+ * device_create_groups - creates a device and registers it with sysfs
+ * @class: pointer to the struct class that this device should be registered to
+ * @parent: pointer to the parent struct device of this new device, if any
+ * @devt: the dev_t for the char device to be added
+ * @drvdata: the data to be added to the device for callbacks
+ * @groups: NULL-terminated list of attribute groups to be created
+ * @fmt: string for the device's name
+ *
+ * This function can be used by char device classes.  A struct device
+ * will be created in sysfs, registered to the specified class.
+ * Additional attributes specified in the groups parameter will also
+ * be created automatically.
+ *
+ * A "dev" file will be created, showing the dev_t for the device, if
+ * the dev_t is not 0,0.
+ * If a pointer to a parent struct device is passed in, the newly created
+ * struct device will be a child of that device in sysfs.
+ * The pointer to the struct device will be returned from the call.
+ * Any further sysfs files that might be required can be created using this
+ * pointer.
+ *
+ * Returns &struct device pointer on success, or ERR_PTR() on error.
+ *
+ * Note: the struct class passed to this function must have previously
+ * been created with a call to class_create().
+ */
+struct device *device_create_groups(struct class *class, struct device *parent,
+				    dev_t devt, void *drvdata,
+				    const struct attribute_group **groups,
+				    const char *fmt, ...)
+{
+	va_list vargs;
+	struct device *dev;
+
+	va_start(vargs, fmt);
+	dev = device_create_groups_vargs(class, parent, devt, drvdata, groups,
+					 fmt, vargs);
+	va_end(vargs);
+	return dev;
+}
+EXPORT_SYMBOL_GPL(device_create_groups);
+
 static int __match_devt(struct device *dev, const void *data)
 {
 	const dev_t *devt = data;
diff --git a/include/linux/device.h b/include/linux/device.h
index bcf8c0d..573ddb6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -924,6 +924,10 @@ extern __printf(5, 6)
 struct device *device_create(struct class *cls, struct device *parent,
 			     dev_t devt, void *drvdata,
 			     const char *fmt, ...);
+struct device *device_create_groups(struct class *cls, struct device *parent,
+			     dev_t devt, void *drvdata,
+			     const struct attribute_group **groups,
+			     const char *fmt, ...);
 extern void device_destroy(struct class *cls, dev_t devt);
 
 /*
-- 
1.7.9.7

