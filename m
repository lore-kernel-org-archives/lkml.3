Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966819Ab3HHWXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 18:23:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966798Ab3HHWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 18:23:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/3] driver core: bus_type: add drv_groups
Date: Thu,  8 Aug 2013 15:22:56 -0700
Message-Id: <1376000577-29866-2-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1376000577-29866-1-git-send-email-gregkh@linuxfoundation.org>
References: <1376000577-29866-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

attribute groups are much more flexible than just a list of attributes,
due to their support for visibility of the attributes, and binary
attributes. Add drv_groups to struct bus_type which should be used
instead of drv_attrs.

drv_attrs will be removed from the structure soon.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/base.h    | 5 +++++
 drivers/base/bus.c     | 5 +++++
 drivers/base/driver.c  | 8 ++++----
 include/linux/device.h | 4 +++-
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index fccf954f..2cbc6774 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -119,6 +119,11 @@ static inline int driver_match_device(struct device_driver *drv,
 	return drv->bus->match ? drv->bus->match(dev, drv) : 1;
 }
 
+extern int driver_add_groups(struct device_driver *drv,
+			     const struct attribute_group **groups);
+extern void driver_remove_groups(struct device_driver *drv,
+				 const struct attribute_group **groups);
+
 extern int device_add_groups(struct device *dev,
 			     const struct attribute_group **groups);
 extern void device_remove_groups(struct device *dev,
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 7b2dc5ba..de5ce22d 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -725,6 +725,10 @@ int bus_add_driver(struct device_driver *drv)
 		printk(KERN_ERR "%s: driver_add_attrs(%s) failed\n",
 			__func__, drv->name);
 	}
+	error = driver_add_groups(drv, bus->drv_groups);
+	if (error)
+		printk(KERN_ERR "%s: driver_create_groups(%s) failed\n",
+			__func__, drv->name);
 
 	if (!drv->suppress_bind_attrs) {
 		error = add_bind_files(drv);
@@ -762,6 +766,7 @@ void bus_remove_driver(struct device_driver *drv)
 	if (!drv->suppress_bind_attrs)
 		remove_bind_files(drv);
 	driver_remove_attrs(drv->bus, drv);
+	driver_remove_groups(drv, drv->bus->drv_groups);
 	driver_remove_file(drv, &driver_attr_uevent);
 	klist_remove(&drv->p->knode_bus);
 	pr_debug("bus: '%s': remove driver %s\n", drv->bus->name, drv->name);
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 974e301a..89db726e 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -123,8 +123,8 @@ void driver_remove_file(struct device_driver *drv,
 }
 EXPORT_SYMBOL_GPL(driver_remove_file);
 
-static int driver_add_groups(struct device_driver *drv,
-			     const struct attribute_group **groups)
+int driver_add_groups(struct device_driver *drv,
+		      const struct attribute_group **groups)
 {
 	int error = 0;
 	int i;
@@ -143,8 +143,8 @@ static int driver_add_groups(struct device_driver *drv,
 	return error;
 }
 
-static void driver_remove_groups(struct device_driver *drv,
-				 const struct attribute_group **groups)
+void driver_remove_groups(struct device_driver *drv,
+			  const struct attribute_group **groups)
 {
 	int i;
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 3aec4a68..94d987f1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -67,6 +67,7 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
  * @dev_attrs:	Default attributes of the devices on the bus.
  * @drv_attrs:	Default attributes of the device drivers on the bus.
  * @dev_groups:	Default attributes of the devices on the bus.
+ * @drv_groups: Default attributes of the device drivers on the bus.
  * @match:	Called, perhaps multiple times, whenever a new device or driver
  *		is added for this bus. It should return a nonzero value if the
  *		given device can be handled by the given driver.
@@ -106,8 +107,9 @@ struct bus_type {
 	struct device		*dev_root;
 	struct bus_attribute	*bus_attrs;
 	struct device_attribute	*dev_attrs;	/* use dev_groups instead */
-	struct driver_attribute	*drv_attrs;
+	struct driver_attribute	*drv_attrs;	/* use drv_groups instead */
 	const struct attribute_group **dev_groups;
+	const struct attribute_group **drv_groups;
 
 	int (*match)(struct device *dev, struct device_driver *drv);
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
-- 
1.8.3.rc0.20.gb99dd2e

