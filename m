Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3LKU75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:59:57 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40912 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3LKU7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:59:53 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:VFIO DRIVER)
Subject: [PATCH 3/9] VFIO_PLATFORM: Initial skeleton of VFIO support for platform devices
Date: Wed, 11 Dec 2013 21:58:27 +0100
Message-Id: <1386795513-32426-4-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch forms the skeleton for platform devices support with VFIO.
To bind this driver with a platform device, the match_any_dev property
is used as introduced by Kim Phillips' patch to allow platform drivers to
bind to any device [1].

[1] https://lkml.org/lkml/2013/12/3/223

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/Kconfig                          |   1 +
 drivers/vfio/Makefile                         |   1 +
 drivers/vfio/platform/Kconfig                 |   9 ++
 drivers/vfio/platform/Makefile                |   4 +
 drivers/vfio/platform/vfio_platform.c         | 174 ++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  22 ++++
 include/uapi/linux/vfio.h                     |   1 +
 7 files changed, 212 insertions(+)
 create mode 100644 drivers/vfio/platform/Kconfig
 create mode 100644 drivers/vfio/platform/Makefile
 create mode 100644 drivers/vfio/platform/vfio_platform.c
 create mode 100644 drivers/vfio/platform/vfio_platform_private.h

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index bd50721..8156fcf 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -20,3 +20,4 @@ menuconfig VFIO
 	  If you don't know what to do here, say N.
 
 source "drivers/vfio/pci/Kconfig"
+source "drivers/vfio/platform/Kconfig"
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 72bfabc..b5e4a33 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_VFIO) += vfio.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
 obj-$(CONFIG_VFIO_PCI) += pci/
+obj-$(CONFIG_VFIO_PLATFORM) += platform/
diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
new file mode 100644
index 0000000..42b0022
--- /dev/null
+++ b/drivers/vfio/platform/Kconfig
@@ -0,0 +1,9 @@
+config VFIO_PLATFORM
+	tristate "VFIO support for platform devices"
+	depends on VFIO && EVENTFD
+	help
+	  Support for platform devices with VFIO. This is required to make
+	  use of platform devices present on the system using the VFIO
+	  framework.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
new file mode 100644
index 0000000..df3a014
--- /dev/null
+++ b/drivers/vfio/platform/Makefile
@@ -0,0 +1,4 @@
+
+vfio-platform-y := vfio_platform.o
+
+obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
new file mode 100644
index 0000000..95dceac
--- /dev/null
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -0,0 +1,174 @@
+/*
+ * Copyright (C) 2013 - Virtual Open Systems
+ * Author: Antonios Motakis <a.motakis@virtualopensystems.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/eventfd.h>
+#include <linux/interrupt.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/irq.h>
+
+#include "vfio_platform_private.h"
+
+#define DRIVER_VERSION  "0.2"
+#define DRIVER_AUTHOR   "Antonios Motakis <a.motakis@virtualopensystems.com>"
+#define DRIVER_DESC     "VFIO for platform devices - User Level meta-driver"
+
+static void vfio_platform_release(void *device_data)
+{
+	module_put(THIS_MODULE);
+}
+
+static int vfio_platform_open(void *device_data)
+{
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	return 0;
+}
+
+static long vfio_platform_ioctl(void *device_data,
+			   unsigned int cmd, unsigned long arg)
+{
+	struct vfio_platform_device *vdev = device_data;
+	unsigned long minsz;
+
+	if (cmd == VFIO_DEVICE_GET_INFO) {
+		struct vfio_device_info info;
+
+		minsz = offsetofend(struct vfio_device_info, num_irqs);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		info.flags = VFIO_DEVICE_FLAGS_PLATFORM;
+		info.num_regions = 0;
+		info.num_irqs = 0;
+
+		return copy_to_user((void __user *)arg, &info, minsz);
+
+	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
+		return -EINVAL;
+
+	else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
+		return -EINVAL;
+
+	else if (cmd == VFIO_DEVICE_SET_IRQS)
+		return -EINVAL;
+
+	else if (cmd == VFIO_DEVICE_RESET)
+		return -EINVAL;
+
+	return -ENOTTY;
+}
+
+static ssize_t vfio_platform_read(void *device_data, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
+{
+	return -EINVAL;
+}
+
+static const struct vfio_device_ops vfio_platform_ops = {
+	.name		= "vfio-platform",
+	.open		= vfio_platform_open,
+	.release	= vfio_platform_release,
+	.ioctl		= vfio_platform_ioctl,
+	.read		= vfio_platform_read,
+	.write		= vfio_platform_write,
+	.mmap		= vfio_platform_mmap,
+};
+
+static int vfio_platform_probe(struct platform_device *pdev)
+{
+	struct vfio_platform_device *vdev;
+	struct iommu_group *group;
+	int ret;
+
+	group = iommu_group_get(&pdev->dev);
+	if (!group) {
+		pr_err("VFIO: No IOMMU group for device %s\n", pdev->name);
+		return -EINVAL;
+	}
+
+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
+	if (!vdev) {
+		iommu_group_put(group);
+		return -ENOMEM;
+	}
+
+	vdev->pdev = pdev;
+
+	ret = vfio_add_group_dev(&pdev->dev, &vfio_platform_ops, vdev);
+	if (ret) {
+		iommu_group_put(group);
+		kfree(vdev);
+	}
+
+	return ret;
+}
+
+static int vfio_platform_remove(struct platform_device *pdev)
+{
+	struct vfio_platform_device *vdev;
+
+	vdev = vfio_del_group_dev(&pdev->dev);
+	if (!vdev)
+		return -EINVAL;
+
+	iommu_group_put(pdev->dev.iommu_group);
+	kfree(vdev);
+
+	return 0;
+}
+
+static struct platform_driver vfio_platform_driver = {
+	.probe		= vfio_platform_probe,
+	.remove		= vfio_platform_remove,
+	.match_any_dev = true,
+	.driver	= {
+		.name	= "vfio-platform",
+		.owner	= THIS_MODULE,
+		.sysfs_bind_only = true,
+	},
+};
+
+module_platform_driver(vfio_platform_driver);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
new file mode 100644
index 0000000..6df8084
--- /dev/null
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2013 - Virtual Open Systems
+ * Author: Antonios Motakis <a.motakis@virtualopensystems.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef VFIO_PLATFORM_PRIVATE_H
+#define VFIO_PLATFORM_PRIVATE_H
+
+struct vfio_platform_device {
+	struct platform_device		*pdev;
+};
+
+#endif /* VFIO_PCI_PRIVATE_H */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d8e9e99..51ebf65 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -148,6 +148,7 @@ struct vfio_device_info {
 	__u32	flags;
 #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
+#define VFIO_DEVICE_FLAGS_PLATFORM (1 << 2)	/* vfio-platform device */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
-- 
1.8.3.2

