Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab3LKVAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:00:36 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:34602 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3LKVAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:00:32 -0500
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
Subject: [PATCH 7/9] VFIO_PLATFORM: Return IRQ info
Date: Wed, 11 Dec 2013 21:58:31 +0100
Message-Id: <1386795513-32426-8-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return information for the interrupts exposed by the device.
This patch extends VFIO_DEVICE_GET_INFO with the number of IRQs
and enables VFIO_DEVICE_GET_IRQ_INFO

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/Makefile                |  2 +-
 drivers/vfio/platform/vfio_platform.c         | 35 +++++++++++++--
 drivers/vfio/platform/vfio_platform_irq.c     | 63 +++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h | 11 +++++
 4 files changed, 106 insertions(+), 5 deletions(-)
 create mode 100644 drivers/vfio/platform/vfio_platform_irq.c

diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
index df3a014..2c53327 100644
--- a/drivers/vfio/platform/Makefile
+++ b/drivers/vfio/platform/Makefile
@@ -1,4 +1,4 @@
 
-vfio-platform-y := vfio_platform.o
+vfio-platform-y := vfio_platform.o vfio_platform_irq.o
 
 obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 9786660..ef8754c 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -79,6 +79,7 @@ static void vfio_platform_release(void *device_data)
 	struct vfio_platform_device *vdev = device_data;
 
 	vfio_platform_regions_cleanup(vdev);
+	vfio_platform_irq_cleanup(vdev);
 
 	module_put(THIS_MODULE);
 }
@@ -92,12 +93,22 @@ static int vfio_platform_open(void *device_data)
 	if (ret)
 		return ret;
 
+	ret = vfio_platform_irq_init(vdev);
+	if (ret)
+		goto err_irq;
+
 	if (!try_module_get(THIS_MODULE)) {
-		vfio_platform_regions_cleanup(vdev);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_mod;
 	}
 
 	return 0;
+
+err_mod:
+	vfio_platform_irq_cleanup(vdev);
+err_irq:
+	vfio_platform_regions_cleanup(vdev);
+	return ret;
 }
 
 static long vfio_platform_ioctl(void *device_data,
@@ -119,7 +130,7 @@ static long vfio_platform_ioctl(void *device_data,
 
 		info.flags = VFIO_DEVICE_FLAGS_PLATFORM;
 		info.num_regions = vdev->num_regions;
-		info.num_irqs = 0;
+		info.num_irqs = vdev->num_irqs;
 
 		return copy_to_user((void __user *)arg, &info, minsz);
 
@@ -142,7 +153,23 @@ static long vfio_platform_ioctl(void *device_data,
 		return copy_to_user((void __user *)arg, &info, minsz);
 
 	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
-		return -EINVAL;
+		struct vfio_irq_info info;
+
+		minsz = offsetofend(struct vfio_irq_info, count);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		if (info.index >= vdev->num_irqs)
+			return -EINVAL;
+
+		info.flags = vdev->irq[info.index].flags;
+		info.count = vdev->irq[info.index].count;
+
+		return copy_to_user((void __user *)arg, &info, minsz);
 
 	} else if (cmd == VFIO_DEVICE_SET_IRQS)
 		return -EINVAL;
diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
new file mode 100644
index 0000000..075c401
--- /dev/null
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -0,0 +1,63 @@
+/*
+ * VFIO platform devices interrupt handling
+ *
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
+#include <linux/platform_device.h>
+#include <linux/irq.h>
+
+#include "vfio_platform_private.h"
+
+int vfio_platform_irq_init(struct vfio_platform_device *vdev)
+{
+	int cnt = 0, i;
+
+	while (platform_get_irq(vdev->pdev, cnt) > 0)
+		cnt++;
+
+	vdev->num_irqs = cnt;
+
+	vdev->irq = kzalloc(sizeof(struct vfio_platform_irq) * vdev->num_irqs,
+				GFP_KERNEL);
+	if (!vdev->irq)
+		return -ENOMEM;
+
+	for (i = 0; i < cnt; i++) {
+		struct vfio_platform_irq irq;
+
+		irq.flags = 0;
+		irq.count = 1;
+
+		vdev->irq[i] = irq;
+	}
+
+	return 0;
+}
+
+void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
+{
+	kfree(vdev->irq);
+}
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 4705aa5..726f5d1 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -15,6 +15,11 @@
 #ifndef VFIO_PLATFORM_PRIVATE_H
 #define VFIO_PLATFORM_PRIVATE_H
 
+struct vfio_platform_irq {
+	u32			flags;
+	u32			count;
+};
+
 struct vfio_platform_region {
 	u64			addr;
 	resource_size_t		size;
@@ -25,6 +30,12 @@ struct vfio_platform_device {
 	struct platform_device		*pdev;
 	struct vfio_platform_region	*region;
 	u32				num_regions;
+	struct vfio_platform_irq	*irq;
+	u32				num_irqs;
 };
 
+extern int vfio_platform_irq_init(struct vfio_platform_device *vdev);
+
+extern void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev);
+
 #endif /* VFIO_PCI_PRIVATE_H */
-- 
1.8.3.2

