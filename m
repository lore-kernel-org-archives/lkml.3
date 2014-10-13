Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaJMNMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:12:33 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63613 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542AbaJMNM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:12:26 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v8 11/18] vfio/platform: initial interrupts support code
Date: Mon, 13 Oct 2014 15:10:18 +0200
Message-Id: <1413205825-6370-12-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a skeleton for the VFIO_DEVICE_SET_IRQS IOCTL, around which
most IRQ functionality is implemented in VFIO.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_common.c  | 52 +++++++++++++++++++++++--
 drivers/vfio/platform/vfio_platform_irq.c     | 56 +++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h |  6 +++
 3 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index c26a545..2a6c665 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -197,10 +197,54 @@ static long vfio_platform_ioctl(void *device_data,
 
 		return copy_to_user((void __user *)arg, &info, minsz);
 
-	} else if (cmd == VFIO_DEVICE_SET_IRQS)
-		return -EINVAL;
+	} else if (cmd == VFIO_DEVICE_SET_IRQS) {
+		struct vfio_irq_set hdr;
+		u8 *data = NULL;
+		int ret = 0;
+
+		minsz = offsetofend(struct vfio_irq_set, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (hdr.argsz < minsz)
+			return -EINVAL;
+
+		if (hdr.index >= vdev->num_irqs)
+			return -EINVAL;
+
+		if (hdr.flags & ~(VFIO_IRQ_SET_DATA_TYPE_MASK |
+				  VFIO_IRQ_SET_ACTION_TYPE_MASK))
+			return -EINVAL;
 
-	else if (cmd == VFIO_DEVICE_RESET)
+		if (!(hdr.flags & VFIO_IRQ_SET_DATA_NONE)) {
+			size_t size;
+
+			if (hdr.flags & VFIO_IRQ_SET_DATA_BOOL)
+				size = sizeof(uint8_t);
+			else if (hdr.flags & VFIO_IRQ_SET_DATA_EVENTFD)
+				size = sizeof(int32_t);
+			else
+				return -EINVAL;
+
+			if (hdr.argsz - minsz < size)
+				return -EINVAL;
+
+			data = memdup_user((void __user *)(arg + minsz), size);
+			if (IS_ERR(data))
+				return PTR_ERR(data);
+		}
+
+		mutex_lock(&vdev->igate);
+
+		ret = vfio_platform_set_irqs_ioctl(vdev, hdr.flags, hdr.index,
+						   hdr.start, hdr.count, data);
+		mutex_unlock(&vdev->igate);
+		kfree(data);
+
+		return ret;
+
+	} else if (cmd == VFIO_DEVICE_RESET)
 		return -EINVAL;
 
 	return -ENOTTY;
@@ -442,6 +486,8 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 		return ret;
 	}
 
+	mutex_init(&vdev->igate);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_platform_probe_common);
diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index d99c71c..007b386 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -31,6 +31,53 @@
 
 #include "vfio_platform_private.h"
 
+static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
+				    unsigned index, unsigned start,
+				    unsigned count, uint32_t flags, void *data)
+{
+	return -EINVAL;
+}
+
+static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
+				    unsigned index, unsigned start,
+				    unsigned count, uint32_t flags, void *data)
+{
+	return -EINVAL;
+}
+
+static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
+				     unsigned index, unsigned start,
+				     unsigned count, uint32_t flags, void *data)
+{
+	return -EINVAL;
+}
+
+int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
+				 uint32_t flags, unsigned index, unsigned start,
+				 unsigned count, void *data)
+{
+	int (*func)(struct vfio_platform_device *vdev, unsigned index,
+		    unsigned start, unsigned count, uint32_t flags,
+		    void *data) = NULL;
+
+	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+	case VFIO_IRQ_SET_ACTION_MASK:
+		func = vfio_platform_set_irq_mask;
+		break;
+	case VFIO_IRQ_SET_ACTION_UNMASK:
+		func = vfio_platform_set_irq_unmask;
+		break;
+	case VFIO_IRQ_SET_ACTION_TRIGGER:
+		func = vfio_platform_set_irq_trigger;
+		break;
+	}
+
+	if (!func)
+		return -ENOTTY;
+
+	return func(vdev, index, start, count, flags, data);
+}
+
 int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 {
 	int cnt = 0, i;
@@ -43,13 +90,22 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 		return -ENOMEM;
 
 	for (i = 0; i < cnt; i++) {
+		int hwirq = vdev->get_irq(vdev, i);
+
+		if (hwirq < 0)
+			goto err;
+
 		vdev->irqs[i].flags = 0;
 		vdev->irqs[i].count = 1;
+		vdev->irqs[i].hwirq = hwirq;
 	}
 
 	vdev->num_irqs = cnt;
 
 	return 0;
+err:
+	kfree(vdev->irqs);
+	return -EINVAL;
 }
 
 void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 196c530..11ad1bb 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -27,6 +27,7 @@
 struct vfio_platform_irq {
 	u32			flags;
 	u32			count;
+	int			hwirq;
 };
 
 struct vfio_platform_region {
@@ -45,6 +46,7 @@ struct vfio_platform_device {
 	struct vfio_platform_irq	*irqs;
 	u32				num_irqs;
 	atomic_t			refcnt;
+	struct mutex			igate;
 
 	/*
 	 * These fields should be filled by the bus driver at binding time
@@ -65,4 +67,8 @@ extern int vfio_platform_remove_common(struct device *dev);
 extern int vfio_platform_irq_init(struct vfio_platform_device *vdev);
 extern void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev);
 
+extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
+			uint32_t flags, unsigned index, unsigned start,
+			unsigned count, void *data);
+
 #endif /* VFIO_PLATFORM_PRIVATE_H */
-- 
2.1.1

