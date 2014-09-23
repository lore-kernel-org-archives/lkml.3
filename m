Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaIWOtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:49:20 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:60545 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337AbaIWOtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:49:14 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, kvm@vger.kernel.org,
        christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, eric.auger@linaro.org,
        marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv7 21/26] vfio/platform: support for maskable and automasked interrupts
Date: Tue, 23 Sep 2014 16:46:20 +0200
Message-Id: <1411483586-29304-22-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support to mask interrupts, and also for automasked interrupts.
Level sensitive interrupts are exposed as automasked interrupts and
are masked and disabled automatically when they fire.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_irq.c     | 120 ++++++++++++++++++++++++--
 drivers/vfio/platform/vfio_platform_private.h |   2 +
 2 files changed, 117 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 25a7825..90fa25a 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -31,27 +31,129 @@
 
 #include "vfio_platform_private.h"
 
+static void vfio_platform_mask(struct vfio_platform_irq *irq_ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq_ctx->lock, flags);
+
+	if (!irq_ctx->masked) {
+		disable_irq(irq_ctx->hwirq);
+		irq_ctx->masked = true;
+	}
+
+	spin_unlock_irqrestore(&irq_ctx->lock, flags);
+}
+
 static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
-	return -EINVAL;
+	uint8_t irq_bitmap;
+
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
+	case VFIO_IRQ_SET_DATA_BOOL:
+		if (copy_from_user(&irq_bitmap, data, sizeof(uint8_t)))
+			return -EFAULT;
+
+		if (irq_bitmap != 0x1)
+			return -EINVAL;
+
+		/*
+		 * The following fall through is both intentional and safe.
+		 * VFIO_IRQ_SET_DATA_BOOL allows to handle an array of IRQs
+		 * on the same index. For VFIO platform devices we always have
+		 * one IRQ per index, so as soon as we check that the user
+		 * provided bitmap only refers to one single IRQ, we can safely
+		 * share the rest of the logic with VFIO_IRQ_SET_DATA_NONE.
+		 */
+
+	case VFIO_IRQ_SET_DATA_NONE:
+		vfio_platform_mask(&vdev->irqs[index]);
+		return 0;
+
+	case VFIO_IRQ_SET_DATA_EVENTFD: /* XXX not implemented yet */
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static void vfio_platform_unmask(struct vfio_platform_irq *irq_ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq_ctx->lock, flags);
+
+	if (irq_ctx->masked) {
+		enable_irq(irq_ctx->hwirq);
+		irq_ctx->masked = false;
+	}
+
+	spin_unlock_irqrestore(&irq_ctx->lock, flags);
 }
 
 static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
-	return -EINVAL;
+	uint8_t irq_bitmap;
+
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
+	case VFIO_IRQ_SET_DATA_BOOL:
+		if (copy_from_user(&irq_bitmap, data, sizeof(uint8_t)))
+			return -EFAULT;
+
+		if (irq_bitmap != 0x1)
+			return -EINVAL;
+
+		/*
+		 * The following fall through is both intentional and safe,
+		 * as in vfio_platform_set_irq_mask().
+		 */
+
+	case VFIO_IRQ_SET_DATA_NONE:
+		vfio_platform_unmask(&vdev->irqs[index]);
+		return 0;
+
+	case VFIO_IRQ_SET_DATA_EVENTFD: /* XXX not implemented yet */
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
 }
 
 static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
 {
 	struct vfio_platform_irq *irq_ctx = dev_id;
+	unsigned long flags;
+	int ret = IRQ_NONE;
 
-	eventfd_signal(irq_ctx->trigger, 1);
+	spin_lock_irqsave(&irq_ctx->lock, flags);
 
-	return IRQ_HANDLED;
+	if (!irq_ctx->masked) {
+		ret = IRQ_HANDLED;
+
+		if (irq_ctx->flags & VFIO_IRQ_INFO_AUTOMASKED) {
+			disable_irq_nosync(irq_ctx->hwirq);
+			irq_ctx->masked = true;
+		}
+	}
+
+	spin_unlock_irqrestore(&irq_ctx->lock, flags);
+
+	if (ret == IRQ_HANDLED)
+		eventfd_signal(irq_ctx->trigger, 1);
+
+	return ret;
 }
 
 static int vfio_set_trigger(struct vfio_platform_device *vdev,
@@ -175,9 +277,17 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 		if (hwirq < 0)
 			goto err;
 
-		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
+		spin_lock_init(&vdev->irqs[i].lock);
+
+		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD
+					| VFIO_IRQ_INFO_MASKABLE;
+
+		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
+			vdev->irqs[i].flags |= VFIO_IRQ_INFO_AUTOMASKED;
+
 		vdev->irqs[i].count = 1;
 		vdev->irqs[i].hwirq = hwirq;
+		vdev->irqs[i].masked = false;
 	}
 
 	vdev->num_irqs = cnt;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 765b371..500e299 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -30,6 +30,8 @@ struct vfio_platform_irq {
 	int			hwirq;
 	char			*name;
 	struct eventfd_ctx	*trigger;
+	bool			masked;
+	spinlock_t		lock;
 };
 
 struct vfio_platform_region {
-- 
1.8.3.2

