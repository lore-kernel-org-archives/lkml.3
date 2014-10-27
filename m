Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaJ0SKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:10:16 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50351 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaJ0SKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:10:13 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v9 13/19] vfio/platform: support for level sensitive interrupts
Date: Mon, 27 Oct 2014 19:07:58 +0100
Message-Id: <1414433284-31719-14-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Level sensitive interrupts are exposed as maskable and automasked
interrupts and are masked and disabled automatically when they fire.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_irq.c     | 102 +++++++++++++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |   2 +
 2 files changed, 100 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 2ac8ed7..563abf6 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -31,18 +31,108 @@
 
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
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
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
+static irqreturn_t vfio_maskable_irq_handler(int irq, void *dev_id)
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
@@ -103,7 +193,7 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 	irq_handler_t handler;
 
 	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_MASKABLE)
-		return -EINVAL; /* not implemented */
+		handler = vfio_maskable_irq_handler;
 	else
 		handler = vfio_irq_handler;
 
@@ -175,13 +265,17 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 		if (hwirq < 0)
 			goto err;
 
+		spin_lock_init(&vdev->irqs[i].lock);
+
 		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
 
 		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
-			vdev->irqs[i].flags |= VFIO_IRQ_INFO_MASKABLE;
+			vdev->irqs[i].flags |= VFIO_IRQ_INFO_MASKABLE
+						| VFIO_IRQ_INFO_AUTOMASKED;
 
 		vdev->irqs[i].count = 1;
 		vdev->irqs[i].hwirq = hwirq;
+		vdev->irqs[i].masked = false;
 	}
 
 	vdev->num_irqs = cnt;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index a3f2411..d25c4cd 100644
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
2.1.1

