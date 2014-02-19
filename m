Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaBSQGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:06:10 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50753 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753684AbaBSQGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:06:08 -0500
From: Sudeep Holla <sudeep.holla@arm.com>
To: linux-kernel@vger.kernel.org
Cc: sudeep.holla@arm.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH RFC/RFT v3 1/9] drivers: base: add new class "cpu" to group cpu devices
Date: Wed, 19 Feb 2014 16:06:08 +0000
Message-Id: <1392825976-17633-2-git-send-email-sudeep.holla@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

This patch creates a new class called "cpu" and assigns it to all the
cpu devices. This helps in grouping all the cpu devices and associated
child devices under the same class.

This patch also:
1. modifies the get_parent_device to return the legacy path
   (/sys/devices/system/cpu/..) for the cpu class devices to support
   existing sysfs ABI
2. avoids creating link in the class directory pointing to the device as
   there would be per-cpu instance of these devices with the same name
3. makes sure subsystem symlink continues pointing to cpu bus instead of
   cpu class for cpu devices

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c | 35 +++++++++++++++++++++++++++++++----
 drivers/base/cpu.c  |  7 +++++++
 include/linux/cpu.h |  2 ++
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2b56717..80225ff 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <linux/cpu.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -759,6 +760,12 @@ static struct kobject *get_device_parent(struct device *dev,
 			return &block_class.p->subsys.kobj;
 		}
 #endif
+		/*
+		 * if the device is in cpu class, then use the default/legacy
+		 * /sys/devices/system/cpu/.. path
+		 */
+		if (dev->class == cpu_class)
+			return &parent->kobj;
 
 		/*
 		 * If we have no parent, we live in "virtual".
@@ -825,11 +832,17 @@ static int device_add_class_symlinks(struct device *dev)
 	if (!dev->class)
 		return 0;
 
-	error = sysfs_create_link(&dev->kobj,
+	/*
+	 * the subsystem symlink in each cpu device needs to continue
+	 * pointing to cpu bus
+	 */
+	if (dev->bus != &cpu_subsys) {
+		error = sysfs_create_link(&dev->kobj,
 				  &dev->class->p->subsys.kobj,
 				  "subsystem");
-	if (error)
-		goto out;
+		if (error)
+			goto out;
+	}
 
 	if (dev->parent && device_is_not_partition(dev)) {
 		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
@@ -843,6 +856,13 @@ static int device_add_class_symlinks(struct device *dev)
 	if (sysfs_deprecated && dev->class == &block_class)
 		return 0;
 #endif
+	/*
+	 * don't create a link in the cpu class directory pointing to the
+	 * device as there would be per-cpu instance of these devices with
+	 * the same name
+	 */
+	if (dev->class == cpu_class)
+		return 0;
 
 	/* link in the class directory pointing to the device */
 	error = sysfs_create_link(&dev->class->p->subsys.kobj,
@@ -868,11 +888,18 @@ static void device_remove_class_symlinks(struct device *dev)
 
 	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
-	sysfs_remove_link(&dev->kobj, "subsystem");
+
+	/* if subsystem points to cpu bus, bus_remove_device will remove it */
+	if (dev->bus != &cpu_subsys)
+		sysfs_remove_link(&dev->kobj, "subsystem");
 #ifdef CONFIG_BLOCK
 	if (sysfs_deprecated && dev->class == &block_class)
 		return;
 #endif
+	/* symlinks are not created for cpu class devices, nothing to remove */
+	if (dev->class == cpu_class)
+		return;
+
 	sysfs_delete_link(&dev->class->p->subsys.kobj, &dev->kobj, dev_name(dev));
 }
 
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index f48370d..28386de 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -286,6 +286,7 @@ static void cpu_device_release(struct device *dev)
 	 */
 }
 
+struct class *cpu_class;
 /*
  * register_cpu - Setup a sysfs device for a CPU.
  * @cpu - cpu->hotpluggable field set to 1 will generate a control file in
@@ -302,6 +303,8 @@ int register_cpu(struct cpu *cpu, int num)
 	memset(&cpu->dev, 0x00, sizeof(struct device));
 	cpu->dev.id = num;
 	cpu->dev.bus = &cpu_subsys;
+	cpu->dev.parent = cpu_subsys.dev_root;
+	cpu->dev.class = cpu_class;
 	cpu->dev.release = cpu_device_release;
 	cpu->dev.offline_disabled = !cpu->hotpluggable;
 	cpu->dev.offline = !cpu_online(num);
@@ -387,5 +390,9 @@ void __init cpu_dev_init(void)
 	if (subsys_system_register(&cpu_subsys, cpu_root_attr_groups))
 		panic("Failed to register CPU subsystem");
 
+	cpu_class = class_create(THIS_MODULE, "cpu");
+	if (IS_ERR(cpu_class))
+		panic("Failed to register CPU class");
+
 	cpu_dev_register_generic();
 }
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 03e235ad..d1279a5 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -39,6 +39,8 @@ extern void cpu_remove_dev_attr(struct device_attribute *attr);
 extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
 extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
 
+extern struct class *cpu_class;
+
 #ifdef CONFIG_HOTPLUG_CPU
 extern void unregister_cpu(struct cpu *cpu);
 extern ssize_t arch_cpu_probe(const char *, size_t);
-- 
1.8.3.2

