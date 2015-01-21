Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbbAUMxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:53:11 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52579 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbbAUMw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:52:59 -0500
From: Baptiste Reynal <b.reynal@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-fundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Baptiste Reynal <b.reynal@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v12 11/18] vfio/platform: support for level sensitive interrupts
Date: Wed, 21 Jan 2015 13:49:59 +0100
Message-Id: <1421844606-24751-12-git-send-email-b.reynal@virtualopensystems.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
References: <1421844606-24751-1-git-send-email-b.reynal@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonios Motakis <a.motakis@virtualopensystems.com>

Level sensitive interrupts are exposed as maskable and automasked
interrupts and are masked and disabled automatically when they fire.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_irq.c     | 99 ++++++++++++++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |  2 +
 2 files changed, 98 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 4b1ee22..e0e6388 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -23,12 +23,59 @@
 
 #include "vfio_platform_private.h"
 
+static void vfio_platform_mask(struct vfio_platform_irq *irq_ctx)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&irq_ctx->lock, flags);
+
+	if (!irq_ctx->masked) {
+		disable_irq_nosync(irq_ctx->hwirq);
+		irq_ctx->masked = true;
+	}
+
+	spin_unlock_irqrestore(&irq_ctx->lock, flags);
+}
+
 static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
 				      unsigned index, unsigned start,
 				      unsigned count, uint32_t flags,
 				      void *data)
 {
-	return -EINVAL;
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	if (!(vdev->irqs[index].flags & VFIO_IRQ_INFO_MASKABLE))
+		return -EINVAL;
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD)
+		return -EINVAL; /* not implemented yet */
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+		vfio_platform_mask(&vdev->irqs[index]);
+
+	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+		uint8_t mask = *(uint8_t *)data;
+
+		if (mask)
+			vfio_platform_mask(&vdev->irqs[index]);
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
@@ -36,7 +83,50 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
 					unsigned count, uint32_t flags,
 					void *data)
 {
-	return -EINVAL;
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	if (!(vdev->irqs[index].flags & VFIO_IRQ_INFO_MASKABLE))
+		return -EINVAL;
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD)
+		return -EINVAL; /* not implemented yet */
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+		vfio_platform_unmask(&vdev->irqs[index]);
+
+	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+		uint8_t unmask = *(uint8_t *)data;
+
+		if (unmask)
+			vfio_platform_unmask(&vdev->irqs[index]);
+	}
+
+	return 0;
+}
+
+static irqreturn_t vfio_automasked_irq_handler(int irq, void *dev_id)
+{
+	struct vfio_platform_irq *irq_ctx = dev_id;
+	unsigned long flags;
+	int ret = IRQ_NONE;
+
+	spin_lock_irqsave(&irq_ctx->lock, flags);
+
+	if (!irq_ctx->masked) {
+		ret = IRQ_HANDLED;
+
+		/* automask maskable interrupts */
+		disable_irq_nosync(irq_ctx->hwirq);
+		irq_ctx->masked = true;
+	}
+
+	spin_unlock_irqrestore(&irq_ctx->lock, flags);
+
+	if (ret == IRQ_HANDLED)
+		eventfd_signal(irq_ctx->trigger, 1);
+
+	return ret;
 }
 
 static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
@@ -102,7 +192,7 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 	irq_handler_t handler;
 
 	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_AUTOMASKED)
-		return -EINVAL; /* not implemented */
+		handler = vfio_automasked_irq_handler;
 	else
 		handler = vfio_irq_handler;
 
@@ -174,6 +264,8 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 		if (hwirq < 0)
 			goto err;
 
+		spin_lock_init(&vdev->irqs[i].lock);
+
 		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
 
 		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
@@ -182,6 +274,7 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 
 		vdev->irqs[i].count = 1;
 		vdev->irqs[i].hwirq = hwirq;
+		vdev->irqs[i].masked = false;
 	}
 
 	vdev->num_irqs = cnt;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index aa01cc3..ff2db1d 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -33,6 +33,8 @@ struct vfio_platform_irq {
 	int			hwirq;
 	char			*name;
 	struct eventfd_ctx	*trigger;
+	bool			masked;
+	spinlock_t		lock;
 };
 
 struct vfio_platform_region {
-- 
2.2.2

