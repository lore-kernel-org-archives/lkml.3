Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3CBDZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:25:57 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:59802 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3CBDZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:25:19 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 30/31] driver/base: implement subsys_virtual_register()
Date: Fri,  1 Mar 2013 19:24:21 -0800
Message-Id: <1362194662-2344-31-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay tells me the most appropriate place to expose workqueues to
userland would be /sys/devices/virtual/workqueues/WQ_NAME which is
symlinked to /sys/bus/workqueue/devices/WQ_NAME and that we're lacking
a way to do that outside of driver core as virtual_device_parent()
isn't exported and there's no inteface to conveniently create a
virtual subsystem.

This patch implements subsys_virtual_register() by factoring out
subsys_register() from subsys_system_register() and using it with
virtual_device_parent() as the origin directory.  It's identical to
subsys_system_register() other than the origin directory but we aren't
gonna restrict the device names which should be used under it.

This will be used to expose workqueue attributes to userland.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Kay, does this look okay?  If so, how should this be routed?

Thanks.

 drivers/base/base.h    |  2 ++
 drivers/base/bus.c     | 73 +++++++++++++++++++++++++++++++++++---------------
 drivers/base/core.c    |  2 +-
 include/linux/device.h |  2 ++
 4 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 6ee17bb..b8bdfe6 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -101,6 +101,8 @@ static inline int hypervisor_init(void) { return 0; }
 extern int platform_bus_init(void);
 extern void cpu_dev_init(void);
 
+struct kobject *virtual_device_parent(struct device *dev);
+
 extern int bus_add_device(struct device *dev);
 extern void bus_probe_device(struct device *dev);
 extern void bus_remove_device(struct device *dev);
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 24eb078..d229858 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -1205,26 +1205,10 @@ static void system_root_device_release(struct device *dev)
 {
 	kfree(dev);
 }
-/**
- * subsys_system_register - register a subsystem at /sys/devices/system/
- * @subsys: system subsystem
- * @groups: default attributes for the root device
- *
- * All 'system' subsystems have a /sys/devices/system/<name> root device
- * with the name of the subsystem. The root device can carry subsystem-
- * wide attributes. All registered devices are below this single root
- * device and are named after the subsystem with a simple enumeration
- * number appended. The registered devices are not explicitely named;
- * only 'id' in the device needs to be set.
- *
- * Do not use this interface for anything new, it exists for compatibility
- * with bad ideas only. New subsystems should use plain subsystems; and
- * add the subsystem-wide attributes should be added to the subsystem
- * directory itself and not some create fake root-device placed in
- * /sys/devices/system/<name>.
- */
-int subsys_system_register(struct bus_type *subsys,
-			   const struct attribute_group **groups)
+
+static int subsys_register(struct bus_type *subsys,
+			   const struct attribute_group **groups,
+			   struct kobject *parent_of_root)
 {
 	struct device *dev;
 	int err;
@@ -1243,7 +1227,7 @@ int subsys_system_register(struct bus_type *subsys,
 	if (err < 0)
 		goto err_name;
 
-	dev->kobj.parent = &system_kset->kobj;
+	dev->kobj.parent = parent_of_root;
 	dev->groups = groups;
 	dev->release = system_root_device_release;
 
@@ -1263,8 +1247,55 @@ err_dev:
 	bus_unregister(subsys);
 	return err;
 }
+
+/**
+ * subsys_system_register - register a subsystem at /sys/devices/system/
+ * @subsys: system subsystem
+ * @groups: default attributes for the root device
+ *
+ * All 'system' subsystems have a /sys/devices/system/<name> root device
+ * with the name of the subsystem. The root device can carry subsystem-
+ * wide attributes. All registered devices are below this single root
+ * device and are named after the subsystem with a simple enumeration
+ * number appended. The registered devices are not explicitely named;
+ * only 'id' in the device needs to be set.
+ *
+ * Do not use this interface for anything new, it exists for compatibility
+ * with bad ideas only. New subsystems should use plain subsystems; and
+ * add the subsystem-wide attributes should be added to the subsystem
+ * directory itself and not some create fake root-device placed in
+ * /sys/devices/system/<name>.
+ */
+int subsys_system_register(struct bus_type *subsys,
+			   const struct attribute_group **groups)
+{
+	return subsys_register(subsys, groups, &system_kset->kobj);
+}
 EXPORT_SYMBOL_GPL(subsys_system_register);
 
+/**
+ * subsys_virtual_register - register a subsystem at /sys/devices/virtual/
+ * @subsys: virtual subsystem
+ * @groups: default attributes for the root device
+ *
+ * All 'virtual' subsystems have a /sys/devices/system/<name> root device
+ * with the name of the subystem.  The root device can carry subsystem-wide
+ * attributes.  All registered devices are below this single root device.
+ * There's no restriction on device naming.  This is for kernel software
+ * constructs which need sysfs interface.
+ */
+int subsys_virtual_register(struct bus_type *subsys,
+			    const struct attribute_group **groups)
+{
+	struct kobject *virtual_dir;
+
+	virtual_dir = virtual_device_parent(NULL);
+	if (!virtual_dir)
+		return -ENOMEM;
+
+	return subsys_register(subsys, groups, virtual_dir);
+}
+
 int __init buses_init(void)
 {
 	bus_kset = kset_create_and_add("bus", &bus_uevent_ops, NULL);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index a235085..90868e2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -690,7 +690,7 @@ void device_initialize(struct device *dev)
 	set_dev_node(dev, -1);
 }
 
-static struct kobject *virtual_device_parent(struct device *dev)
+struct kobject *virtual_device_parent(struct device *dev)
 {
 	static struct kobject *virtual_dir = NULL;
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 43dcda9..9765b38 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -301,6 +301,8 @@ void subsys_interface_unregister(struct subsys_interface *sif);
 
 int subsys_system_register(struct bus_type *subsys,
 			   const struct attribute_group **groups);
+int subsys_virtual_register(struct bus_type *subsys,
+			    const struct attribute_group **groups);
 
 /**
  * struct class - device classes
-- 
1.8.1.2

