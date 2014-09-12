Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaILHCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 03:02:10 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:35516 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbaILHCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:02:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luciano Coelho <luca@coelho.fi>, Kalle Valo <kvalo@adurom.com>,
        dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org
Subject: [PATCH] device coredump: add new device coredump class
Date: Fri, 12 Sep 2014 09:01:56 +0200
Message-Id: <1410505316-4807-1-git-send-email-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Many devices run firmware and/or complex hardware, and most of that
can have bugs. When it misbehaves, however, it is often much harder
to debug than software running on the host.

Introduce a "device coredump" mechanism to allow dumping internal
device/firmware state through a generalized mechanism. As devices
are different and information needed can vary accordingly, this
doesn't prescribe a file format - it just provides mechanism to
get data to be able to capture it in a generalized way (e.g. in
distributions.)

The dumped data will be readable in sysfs in the virtual device's
data file under /sys/class/devcoredump/devcd*/. Writing to it will
free the data and remove the device, as does a 5-minute timeout.

Note that generalized capturing of such data may result in privacy
issues, so users generally need to be involved. In order to allow
certain users/system integrators/... to disable the feature at all,
introduce a Kconfig option to override the drivers that would like
to have the feature.

For now, this provides two ways of dumping data:
 1) with a vmalloc'ed area, that is then given to the subsystem
    and freed after retrieval or timeout
 2) with a generalized reader/free function method

We could/should add more options, e.g. a list of pages, since the
vmalloc area is very limited on some architectures.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 MAINTAINERS                 |   7 ++
 drivers/base/Kconfig        |  21 ++++
 drivers/base/Makefile       |   1 +
 drivers/base/devcoredump.c  | 265 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/devcoredump.h |  35 ++++++
 5 files changed, 329 insertions(+)
 create mode 100644 drivers/base/devcoredump.c
 create mode 100644 include/linux/devcoredump.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 2f85f55c8fb8..8e31d053fb14 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2847,6 +2847,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
 S:	Maintained
 F:	drivers/usb/dwc3/
 
+DEVICE COREDUMP (DEV_COREDUMP)
+M:	Johannes Berg <johannes@sipsolutions.net>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/base/devcoredump.c
+F:	include/linux/devcoredump.h
+
 DEVICE FREQUENCY (DEVFREQ)
 M:	MyungJoo Ham <myungjoo.ham@samsung.com>
 M:	Kyungmin Park <kyungmin.park@samsung.com>
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 4e7f0ff83ae7..134f763d90fd 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -165,6 +165,27 @@ config FW_LOADER_USER_HELPER_FALLBACK
 
 	  If you are unsure about this, say N here.
 
+config WANT_DEV_COREDUMP
+	bool
+	help
+	  Drivers should "select" this option if they desire to use the
+	  device coredump mechanism.
+
+config DISABLE_DEV_COREDUMP
+	bool "Disable device coredump" if EXPERT
+	help
+	  Disable the device coredump mechanism despite drivers wanting to
+	  use it; this allows for more sensitive systems or systems that
+	  don't want to ever access the information to not have the code,
+	  nor keep any data.
+
+	  If unsure, say N.
+
+config DEV_COREDUMP
+	bool
+	default y if WANT_DEV_COREDUMP
+	depends on !DISABLE_DEV_COREDUMP
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 4aab26ec0292..6922cd6850a2 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 obj-$(CONFIG_REGMAP)	+= regmap/
 obj-$(CONFIG_SOC_BUS) += soc.o
 obj-$(CONFIG_PINCTRL) += pinctrl.o
+obj-$(CONFIG_DEV_COREDUMP) += devcoredump.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
diff --git a/drivers/base/devcoredump.c b/drivers/base/devcoredump.c
new file mode 100644
index 000000000000..96614b04544c
--- /dev/null
+++ b/drivers/base/devcoredump.c
@@ -0,0 +1,265 @@
+/*
+ * This file is provided under the GPLv2 license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Mobile Communications GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * Author: Johannes Berg <johannes@sipsolutions.net>
+ */
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/devcoredump.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/workqueue.h>
+
+/* if data isn't read by userspace after 5 minutes then delete it */
+#define DEVCD_TIMEOUT	(HZ * 60 * 5)
+
+struct devcd_entry {
+	struct device devcd_dev;
+	const void *data;
+	size_t datalen;
+	struct module *owner;
+	ssize_t (*read)(char *buffer, loff_t offset, size_t count,
+			const void *data, size_t datalen);
+	void (*free)(const void *data);
+	struct delayed_work del_wk;
+	struct device *failing_dev;
+};
+
+static struct devcd_entry *dev_to_devcd(struct device *dev)
+{
+	return container_of(dev, struct devcd_entry, devcd_dev);
+}
+
+static void devcd_dev_release(struct device *dev)
+{
+	struct devcd_entry *devcd = dev_to_devcd(dev);
+
+	devcd->free(devcd->data);
+	module_put(devcd->owner);
+
+	/*
+	 * this seems racy, but I don't see a notifier or such on
+	 * a struct device to know when it goes away?
+	 */
+	if (devcd->failing_dev->kobj.sd)
+		sysfs_delete_link(&devcd->failing_dev->kobj, &dev->kobj,
+				  "devcoredump");
+
+	put_device(devcd->failing_dev);
+	kfree(devcd);
+}
+
+static void devcd_del(struct work_struct *wk)
+{
+	struct devcd_entry *devcd;
+
+	devcd = container_of(wk, struct devcd_entry, del_wk.work);
+
+	device_del(&devcd->devcd_dev);
+	put_device(&devcd->devcd_dev);
+}
+
+static ssize_t devcd_data_read(struct file *filp, struct kobject *kobj,
+			       struct bin_attribute *bin_attr,
+			       char *buffer, loff_t offset, size_t count)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct devcd_entry *devcd = dev_to_devcd(dev);
+
+	return devcd->read(buffer, offset, count, devcd->data, devcd->datalen);
+}
+
+static ssize_t devcd_data_write(struct file *filp, struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buffer, loff_t offset, size_t count)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct devcd_entry *devcd = dev_to_devcd(dev);
+
+	mod_delayed_work(system_wq, &devcd->del_wk, 0);
+
+	return count;
+}
+
+static struct bin_attribute devcd_attr_data = {
+	.attr = { .name = "data", .mode = S_IRUSR | S_IWUSR, },
+	.size = 0,
+	.read = devcd_data_read,
+	.write = devcd_data_write,
+};
+
+static struct bin_attribute *devcd_dev_bin_attrs[] = {
+	&devcd_attr_data, NULL,
+};
+
+static const struct attribute_group devcd_dev_group = {
+	.bin_attrs = devcd_dev_bin_attrs,
+};
+
+static const struct attribute_group *devcd_dev_groups[] = {
+	&devcd_dev_group, NULL,
+};
+
+static struct class devcd_class = {
+	.name		= "devcoredump",
+	.owner		= THIS_MODULE,
+	.dev_release	= devcd_dev_release,
+	.dev_groups	= devcd_dev_groups,
+};
+
+static ssize_t devcd_readv(char *buffer, loff_t offset, size_t count,
+			   const void *data, size_t datalen)
+{
+	if (offset > datalen)
+		return -EINVAL;
+
+	if (offset + count > datalen)
+		count = datalen - offset;
+
+	if (count)
+		memcpy(buffer, ((u8 *)data) + offset, count);
+
+	return count;
+}
+
+/**
+ * dev_coredumpv - create device coredump with vmalloc data
+ * @dev: the struct device for the crashed device
+ * @data: vmalloc data containing the device coredump
+ * @datalen: length of the data
+ * @gfp: allocation flags
+ *
+ * This function takes ownership of the vmalloc'ed data and will free
+ * it when it is no longer used. See dev_coredumpm() for more information.
+ */
+void dev_coredumpv(struct device *dev, const void *data, size_t datalen,
+		   gfp_t gfp)
+{
+	dev_coredumpm(dev, NULL, data, datalen, gfp, devcd_readv, vfree);
+}
+EXPORT_SYMBOL_GPL(dev_coredumpv);
+
+static int devcd_match_failing(struct device *dev, const void *failing)
+{
+	struct devcd_entry *devcd = dev_to_devcd(dev);
+
+	return devcd->failing_dev == failing;
+}
+
+/**
+ * dev_coredumpm - create device coredump with read/free methods
+ * @dev: the struct device for the crashed device
+ * @owner: the module that contains the read/free functions, use %THIS_MODULE
+ * @data: data cookie for the @read/@free functions
+ * @datalen: length of the data
+ * @gfp: allocation flags
+ * @read: function to read from the given buffer
+ * @free: function to free the given buffer
+ *
+ * Creates a new device coredump for the given device. If a previous one hasn't
+ * been read yet, the new coredump is discarded. The data lifetime is determined
+ * by the device coredump framework and when it is no longer needed the @free
+ * function will be called to free the data.
+ */
+void dev_coredumpm(struct device *dev, struct module *owner,
+		   const void *data, size_t datalen, gfp_t gfp,
+		   ssize_t (*read)(char *buffer, loff_t offset, size_t count,
+				   const void *data, size_t datalen),
+		   void (*free)(const void *data))
+{
+	static atomic_t devcd_count = ATOMIC_INIT(0);
+	struct devcd_entry *devcd;
+	struct device *existing;
+
+	existing = class_find_device(&devcd_class, NULL, dev,
+				     devcd_match_failing);
+	if (existing) {
+		put_device(existing);
+		goto free;
+	}
+
+	if (!try_module_get(owner))
+		goto free;
+
+	devcd = kzalloc(sizeof(*devcd), gfp);
+	if (!devcd)
+		goto put_module;
+
+	devcd->owner = owner;
+	devcd->data = data;
+	devcd->datalen = datalen;
+	devcd->read = read;
+	devcd->free = free;
+	devcd->failing_dev = get_device(dev);
+
+	device_initialize(&devcd->devcd_dev);
+
+	dev_set_name(&devcd->devcd_dev, "devcd%d",
+		     atomic_inc_return(&devcd_count));
+	devcd->devcd_dev.class = &devcd_class;
+
+	if (device_add(&devcd->devcd_dev))
+		goto put_device;
+
+	if (sysfs_create_link(&devcd->devcd_dev.kobj, &dev->kobj,
+			      "failing_device"))
+		/* nothing - symlink will be missing */;
+
+	if (sysfs_create_link(&dev->kobj, &devcd->devcd_dev.kobj,
+			      "devcoredump"))
+		/* nothing - symlink will be missing */;
+
+	INIT_DELAYED_WORK(&devcd->del_wk, devcd_del);
+	schedule_delayed_work(&devcd->del_wk, DEVCD_TIMEOUT);
+
+	return;
+ put_device:
+	put_device(&devcd->devcd_dev);
+ put_module:
+	module_put(owner);
+ free:
+	free(data);
+}
+EXPORT_SYMBOL_GPL(dev_coredumpm);
+
+static int __init devcoredump_init(void)
+{
+	return class_register(&devcd_class);
+}
+__initcall(devcoredump_init);
+
+static int devcd_free(struct device *dev, void *data)
+{
+	struct devcd_entry *devcd = dev_to_devcd(dev);
+
+	flush_delayed_work(&devcd->del_wk);
+	return 0;
+}
+
+static void __exit devcoredump_exit(void)
+{
+	class_for_each_device(&devcd_class, NULL, NULL, devcd_free);
+	class_unregister(&devcd_class);
+}
+__exitcall(devcoredump_exit);
diff --git a/include/linux/devcoredump.h b/include/linux/devcoredump.h
new file mode 100644
index 000000000000..c0a360e99f64
--- /dev/null
+++ b/include/linux/devcoredump.h
@@ -0,0 +1,35 @@
+#ifndef __DEVCOREDUMP_H
+#define __DEVCOREDUMP_H
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+
+#ifdef CONFIG_DEV_COREDUMP
+void dev_coredumpv(struct device *dev, const void *data, size_t datalen,
+		   gfp_t gfp);
+
+void dev_coredumpm(struct device *dev, struct module *owner,
+		   const void *data, size_t datalen, gfp_t gfp,
+		   ssize_t (*read)(char *buffer, loff_t offset, size_t count,
+				   const void *data, size_t datalen),
+		   void (*free)(const void *data));
+#else
+static inline void dev_coredumpv(struct device *dev, const void *data,
+				 size_t datalen, gfp_t gfp)
+{
+	vfree(data);
+}
+
+static inline void
+dev_coredumpm(struct device *dev, struct module *owner,
+	      const void *data, size_t datalen, gfp_t gfp,
+	      ssize_t (*read)(char *buffer, loff_t offset, size_t count,
+			      const void *data, size_t datalen),
+	      void (*free)(const void *data))
+{
+	free(data);
+}
+#endif /* CONFIG_DEV_COREDUMP */
+
+#endif /* __DEVCOREDUMP_H */
-- 
2.1.0

