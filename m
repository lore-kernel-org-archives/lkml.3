Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbaICLPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:15:52 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:60638 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681AbaICLPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:15:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>, luca@coelho.fi,
        kvalo@adurom.com
Subject: [RFC] firmware coredump: add new firmware coredump class
Date: Wed,  3 Sep 2014 13:15:45 +0200
Message-Id: <1409742945-3933-1-git-send-email-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Many devices run firmware, and as other software such firmware has
bugs. When it misbehaves, however, it is often much harder to debug
than software running on the host.

Introduce a "firmware coredump" mechanism to allow dumping internal
firmware state through a generalized mechanism. As all devices are
different and information needed can vary accordingly, this doesn't
prescribe a file format - it just provides mechanism to get data to
be able to capture it in a generalized way (e.g. in distributions.)

Note that generalized capturing of such data may result in privacy
issues, so users generally need to be involved. In order to allow
certain users/system integrators/... to disable the feature at all,
introduce a Kconfig option to override the drivers that would like
to have the feature.

For now, this provides two ways of dumping data:
 1) with a vmalloc'ed area, that is then given to the fwcoredump
    subsystem and freed after retrieval or timeout
 2) with a generalized reader/free function method

We could/should add more options, e.g. a list of pages, since the
vmalloc area is very limited on some architectures.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 MAINTAINERS                |   7 ++
 drivers/base/Kconfig       |  21 +++++
 drivers/base/Makefile      |   1 +
 drivers/base/fwcoredump.c  | 222 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fwcoredump.h |  35 +++++++
 5 files changed, 286 insertions(+)
 create mode 100644 drivers/base/fwcoredump.c
 create mode 100644 include/linux/fwcoredump.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 2f85f55c8fb8..394bda1cde52 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3729,6 +3729,13 @@ F:	Documentation/firmware_class/
 F:	drivers/base/firmware*.c
 F:	include/linux/firmware.h
 
+FIRMWARE COREDUMP (fwcoredump)
+M:	Johannes Berg <johannes@sipsolutions.net>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	drivers/base/fwcoredump.c
+F:	include/linux/fwcoredump.h
+
 FLASH ADAPTER DRIVER (IBM Flash Adapter 900GB Full Height PCI Flash Card)
 M:	Joshua Morris <josh.h.morris@us.ibm.com>
 M:	Philip Kelleher <pjk1939@linux.vnet.ibm.com>
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 4e7f0ff83ae7..31eabab20c8a 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -165,6 +165,27 @@ config FW_LOADER_USER_HELPER_FALLBACK
 
 	  If you are unsure about this, say N here.
 
+config WANT_FW_COREDUMP
+	bool
+	help
+	  Drivers should "select" this option if they desire to use the
+	  firmware coredump mechanism.
+
+config DISABLE_FW_COREDUMP
+	bool "Disable firmware coredump" if EXPERT
+	help
+	  Disable the firmware coredump mechanism despite drivers wanting to
+	  use it; this allows for more sensitive systems or systems that
+	  don't want to ever access the information to not have the code,
+	  nor keep any data.
+
+	  If unsure, say N.
+
+config FW_COREDUMP
+	bool
+	default y if WANT_FW_COREDUMP
+	depends on !DISABLE_FW_COREDUMP
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 4aab26ec0292..2af1be519653 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 obj-$(CONFIG_REGMAP)	+= regmap/
 obj-$(CONFIG_SOC_BUS) += soc.o
 obj-$(CONFIG_PINCTRL) += pinctrl.o
+obj-$(CONFIG_FW_COREDUMP) += fwcoredump.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
diff --git a/drivers/base/fwcoredump.c b/drivers/base/fwcoredump.c
new file mode 100644
index 000000000000..f70bef0727a9
--- /dev/null
+++ b/drivers/base/fwcoredump.c
@@ -0,0 +1,222 @@
+/******************************************************************************
+ *
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
+ */
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/fwcoredump.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/workqueue.h>
+
+MODULE_AUTHOR("Johannes Berg <johannes@sipsolutions.net>");
+MODULE_DESCRIPTION("Firmware Coredump support");
+MODULE_LICENSE("GPL");
+
+/* if data isn't read by userspace after 5 minutes delete it */
+#define FWC_TIMEOUT	(HZ * 60 * 5)
+
+struct fwc_entry {
+	struct device fwc_dev;
+	const void *data;
+	size_t datalen;
+	struct module *owner;
+	ssize_t (*read)(char *buffer, loff_t offset, size_t count,
+			const void *data, size_t datalen);
+	void (*free)(const void *data);
+	struct delayed_work del_wk;
+};
+
+static struct fwc_entry *dev_to_fwc(struct device *dev)
+{
+	return container_of(dev, struct fwc_entry, fwc_dev);
+}
+
+static void fwc_dev_release(struct device *dev)
+{
+	struct fwc_entry *fwc = dev_to_fwc(dev);
+
+	fwc->free(fwc->data);
+	kfree(fwc);
+}
+
+static void fwc_del(struct work_struct *wk)
+{
+	struct fwc_entry *fwc;
+
+	fwc = container_of(wk, struct fwc_entry, del_wk.work);
+
+	device_del(&fwc->fwc_dev);
+	put_device(&fwc->fwc_dev);
+}
+
+static ssize_t fwc_data_read(struct file *filp, struct kobject *kobj,
+			     struct bin_attribute *bin_attr,
+			     char *buffer, loff_t offset, size_t count)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct fwc_entry *fwc = dev_to_fwc(dev);
+
+	return fwc->read(buffer, offset, count, fwc->data, fwc->datalen);
+}
+
+static ssize_t fwc_data_write(struct file *filp, struct kobject *kobj,
+			      struct bin_attribute *bin_attr,
+			      char *buffer, loff_t offset, size_t count)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct fwc_entry *fwc = dev_to_fwc(dev);
+
+	schedule_delayed_work(&fwc->del_wk, 0);
+
+	return count;
+}
+
+static struct bin_attribute fwc_attr_data = {
+	.attr = { .name = "data", .mode = S_IRUSR | S_IWUSR, },
+	.size = 0,
+	.read = fwc_data_read,
+	.write = fwc_data_write,
+};
+
+static struct bin_attribute *fwc_dev_bin_attrs[] = {
+	&fwc_attr_data, NULL,
+};
+
+static const struct attribute_group fwc_dev_group = {
+	.bin_attrs = fwc_dev_bin_attrs,
+};
+
+static const struct attribute_group *fwc_dev_groups[] = {
+	&fwc_dev_group, NULL,
+};
+
+static struct class fwc_class = {
+	.name		= "fwcoredump",
+	.dev_release	= fwc_dev_release,
+	.dev_groups	= fwc_dev_groups,
+};
+
+static ssize_t fwc_readv(char *buffer, loff_t offset, size_t count,
+			 const void *data, size_t datalen)
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
+ * fw_coredumpv - create firmware coredump with vmalloc data
+ * @dev: the struct device for the crashed device
+ * @data: vmalloc data containing the firmware coredump
+ * @datalen: length of the data
+ * @gfp: allocation flags
+ */
+void fw_coredumpv(struct device *dev, const void *data, size_t datalen,
+		  gfp_t gfp)
+{
+	fw_coredumpm(dev, NULL, data, datalen, gfp, fwc_readv, vfree);
+}
+EXPORT_SYMBOL(fw_coredumpv);
+
+/**
+ * fw_coredumpm - create firmware coredump with read/free methods
+ * @dev: the struct device for the crashed device
+ * @data: data cookie for the @read/@free functions
+ * @datalen: length of the data
+ * @gfp: allocation flags
+ * @read: function to read from the given buffer
+ * @free: function to free the given buffer
+ */
+void fw_coredumpm(struct device *dev, struct module *owner,
+		  const void *data, size_t datalen, gfp_t gfp,
+		  ssize_t (*read)(char *buffer, loff_t offset, size_t count,
+				  const void *data, size_t datalen),
+		  void (*free)(const void *data))
+{
+	static atomic_t fwc_count = ATOMIC_INIT(0);
+	struct fwc_entry *fwc;
+
+	if (!try_module_get(owner))
+		return;
+
+	fwc = kzalloc(sizeof(*fwc), gfp);
+	if (!fwc)
+		goto put_module;
+
+	fwc->owner = owner;
+	fwc->data = data;
+	fwc->datalen = datalen;
+	fwc->read = read;
+	fwc->free = free;
+
+	device_initialize(&fwc->fwc_dev);
+
+	dev_set_name(&fwc->fwc_dev, "fwc%d", atomic_inc_return(&fwc_count));
+	fwc->fwc_dev.class = &fwc_class;
+
+	if (device_add(&fwc->fwc_dev))
+		goto put_device;
+
+	if (sysfs_create_link(&fwc->fwc_dev.kobj, &dev->kobj, "failing_device"))
+		/* nothing - symlink will be missing but that's ok */;
+
+	INIT_DELAYED_WORK(&fwc->del_wk, fwc_del);
+	schedule_delayed_work(&fwc->del_wk, FWC_TIMEOUT);
+
+	return;
+ put_device:
+	put_device(&fwc->fwc_dev);
+ put_module:
+	module_put(owner);
+}
+EXPORT_SYMBOL(fw_coredumpm);
+
+static int __init fwcoredump_init(void)
+{
+	return class_register(&fwc_class);
+}
+module_init(fwcoredump_init);
+
+static int fwc_free(struct device *dev, void *data)
+{
+	struct fwc_entry *fwc = dev_to_fwc(dev);
+
+	flush_delayed_work(&fwc->del_wk);
+	return 0;
+}
+
+static void __exit fwcoredump_exit(void)
+{
+	class_for_each_device(&fwc_class, NULL, NULL, fwc_free);
+	class_unregister(&fwc_class);
+}
+module_exit(fwcoredump_exit);
diff --git a/include/linux/fwcoredump.h b/include/linux/fwcoredump.h
new file mode 100644
index 000000000000..168f2d6abfc0
--- /dev/null
+++ b/include/linux/fwcoredump.h
@@ -0,0 +1,35 @@
+#ifndef __FWCOREDUMP_H
+#define __FWCOREDUMP_H
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+
+#ifdef CONFIG_FW_COREDUMP
+void fw_coredumpv(struct device *dev, const void *data, size_t datalen,
+		  gfp_t gfp);
+
+void fw_coredumpm(struct device *dev, struct module *owner,
+		  const void *data, size_t datalen, gfp_t gfp,
+		  ssize_t (*read)(char *buffer, loff_t offset, size_t count,
+				  const void *data, size_t datalen),
+		  void (*free)(const void *data));
+#else
+static inline void fw_coredumpv(struct device *dev, const void *data,
+				size_t datalen, gfp_t gfp)
+{
+	vfree(data);
+}
+
+static inline void
+fw_coredumpm(struct device *dev, struct module *owner,
+	     const void *data, size_t datalen, gfp_t gfp,
+	     ssize_t (*read)(char *buffer, loff_t offset, size_t count,
+			     const void *data, size_t datalen),
+	     void (*free)(const void *data))
+{
+	free(data);
+}
+#endif /* CONFIG_FW_COREDUMP */
+
+#endif /* __FWCOREDUMP_H */
-- 
2.1.0

