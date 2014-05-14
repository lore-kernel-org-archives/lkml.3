Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaENViF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:38:05 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:57826 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaENVfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:35:13 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 02/11] driver core: Add device_create_global()
Date: Wed, 14 May 2014 16:34:50 -0500
Message-Id: <1400103299-144589-3-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This does the same thing as device_create() but also sets the
ns_global flags for the device.

It's likely better to do this as a flag to device_create() or
something like that, but making it a separate interface for now
avoids needing to change the 100+ callers of device_create().

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/base/core.c    | 51 +++++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/device.h |  4 ++++
 2 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 1da05f1319fa..b2b62743e757 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1575,7 +1575,7 @@ static void device_create_release(struct device *dev)
 
 static struct device *
 device_create_groups_vargs(struct class *class, struct device *parent,
-			   dev_t devt, void *drvdata,
+			   dev_t devt, bool ns_global, void *drvdata,
 			   const struct attribute_group **groups,
 			   const char *fmt, va_list args)
 {
@@ -1597,6 +1597,7 @@ device_create_groups_vargs(struct class *class, struct device *parent,
 	dev->parent = parent;
 	dev->groups = groups;
 	dev->release = device_create_release;
+	dev->ns_global = ns_global;
 	dev_set_drvdata(dev, drvdata);
 
 	retval = kobject_set_name_vargs(&dev->kobj, fmt, args);
@@ -1643,8 +1644,8 @@ struct device *device_create_vargs(struct class *class, struct device *parent,
 				   dev_t devt, void *drvdata, const char *fmt,
 				   va_list args)
 {
-	return device_create_groups_vargs(class, parent, devt, drvdata, NULL,
-					  fmt, args);
+	return device_create_groups_vargs(class, parent, devt, false, drvdata,
+					  NULL, fmt, args);
 }
 EXPORT_SYMBOL_GPL(device_create_vargs);
 
@@ -1686,6 +1687,46 @@ struct device *device_create(struct class *class, struct device *parent,
 EXPORT_SYMBOL_GPL(device_create);
 
 /**
+ * device_create_global - creates a global device and registers it with sysfs
+ * @class: pointer to the struct class that this device should be registered to
+ * @parent: pointer to the parent struct device of this new device, if any
+ * @devt: the dev_t for the char device to be added
+ * @drvdata: the data to be added to the device for callbacks
+ * @fmt: string for the device's name
+ *
+ * This function can be used by char device classes.  A struct device
+ * will be created in sysfs, registered to the specified class, and
+ * accessible to all user namespaces.
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
+struct device *device_create_global(struct class *class, struct device *parent,
+				    dev_t devt, void *drvdata,
+				    const char *fmt, ...)
+{
+	va_list vargs;
+	struct device *dev;
+
+	va_start(vargs, fmt);
+	dev = device_create_groups_vargs(class, parent, devt, true, drvdata,
+					 NULL, fmt, vargs);
+	va_end(vargs);
+	return dev;
+}
+EXPORT_SYMBOL(device_create_global);
+
+/**
  * device_create_with_groups - creates a device and registers it with sysfs
  * @class: pointer to the struct class that this device should be registered to
  * @parent: pointer to the parent struct device of this new device, if any
@@ -1722,8 +1763,8 @@ struct device *device_create_with_groups(struct class *class,
 	struct device *dev;
 
 	va_start(vargs, fmt);
-	dev = device_create_groups_vargs(class, parent, devt, drvdata, groups,
-					 fmt, vargs);
+	dev = device_create_groups_vargs(class, parent, devt, false, drvdata,
+					 groups, fmt, vargs);
 	va_end(vargs);
 	return dev;
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index 41a4ba33b13b..e2dbe19b5f46 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -973,6 +973,10 @@ extern __printf(5, 6)
 struct device *device_create(struct class *cls, struct device *parent,
 			     dev_t devt, void *drvdata,
 			     const char *fmt, ...);
+extern __printf(5, 6)
+struct device *device_create_global(struct class *cls, struct device *parent,
+				    dev_t devt, void *drvdata,
+				    const char *fmt, ...);
 extern __printf(6, 7)
 struct device *device_create_with_groups(struct class *cls,
 			     struct device *parent, dev_t devt, void *drvdata,
-- 
1.9.1

