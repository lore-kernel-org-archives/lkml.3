Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbbAUMvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:51:19 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53317 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbbAUMvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:51:09 -0500
From: Baptiste Reynal <b.reynal@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-fundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Baptiste Reynal <b.reynal@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:VFIO DRIVER)
Subject: [PATCH v12 01/18] vfio/platform: initial skeleton of VFIO support for platform devices
Date: Wed, 21 Jan 2015 13:49:49 +0100
Message-Id: <1421844606-24751-2-git-send-email-b.reynal@virtualopensystems.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
References: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonios Motakis <a.motakis@virtualopensystems.com>

This patch forms the common skeleton code for platform devices support
with VFIO. This will include the core functionality of VFIO_PLATFORM,
however binding to the device and discovering the device resources will
be done with the help of a separate file where any Linux platform bus
specific code will reside.

This will allow us to implement support for also discovering AMBA devices
and their resources, but still reuse a large part of the VFIO_PLATFORM
implementation.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
[Baptiste Reynal: added includes in vfio_platform_private.h]
Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_common.c  | 121 ++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  39 +++++++++
 2 files changed, 160 insertions(+)
 create mode 100644 drivers/vfio/platform/vfio_platform_common.c
 create mode 100644 drivers/vfio/platform/vfio_platform_private.h

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
new file mode 100644
index 0000000..34d023b
--- /dev/null
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -0,0 +1,121 @@
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
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/vfio.h>
+
+#include "vfio_platform_private.h"
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
+				unsigned int cmd, unsigned long arg)
+{
+	if (cmd == VFIO_DEVICE_GET_INFO)
+		return -EINVAL;
+
+	else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
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
+				  size_t count, loff_t *ppos)
+{
+	return -EINVAL;
+}
+
+static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	return -EINVAL;
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
+int vfio_platform_probe_common(struct vfio_platform_device *vdev,
+			       struct device *dev)
+{
+	struct iommu_group *group;
+	int ret;
+
+	if (!vdev)
+		return -EINVAL;
+
+	group = iommu_group_get(dev);
+	if (!group) {
+		pr_err("VFIO: No IOMMU group for device %s\n", vdev->name);
+		return -EINVAL;
+	}
+
+	ret = vfio_add_group_dev(dev, &vfio_platform_ops, vdev);
+	if (ret) {
+		iommu_group_put(group);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_platform_probe_common);
+
+struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
+{
+	struct vfio_platform_device *vdev;
+
+	vdev = vfio_del_group_dev(dev);
+	if (vdev)
+		iommu_group_put(dev->iommu_group);
+
+	return vdev;
+}
+EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
new file mode 100644
index 0000000..c046988
--- /dev/null
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -0,0 +1,39 @@
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
+#include <linux/types.h>
+#include <linux/interrupt.h>
+
+struct vfio_platform_device {
+	/*
+	 * These fields should be filled by the bus specific binder
+	 */
+	void		*opaque;
+	const char	*name;
+	uint32_t	flags;
+	/* callbacks to discover device resources */
+	struct resource*
+		(*get_resource)(struct vfio_platform_device *vdev, int i);
+	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
+};
+
+extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
+				      struct device *dev);
+extern struct vfio_platform_device *vfio_platform_remove_common
+				     (struct device *dev);
+
+#endif /* VFIO_PLATFORM_PRIVATE_H */
-- 
2.2.2

