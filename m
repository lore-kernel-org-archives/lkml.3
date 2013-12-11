Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3LKVA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:00:59 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:47188 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab3LKVAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:00:54 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 9/9] VFIO_PLATFORM: Support for maskable and automasked interrupts
Date: Wed, 11 Dec 2013 21:58:33 +0100
Message-Id: <1386795513-32426-10-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support to mask interrupts, and also for automasked interrupts.
Level sensitive interrupts are exposed as automasked interrupts and
are masked and disabled automatically when they fire.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Tested-by: Alvise Rigo <a.rigo@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_irq.c     | 117 ++++++++++++++++++++++++--
 drivers/vfio/platform/vfio_platform_private.h |   2 +
 2 files changed, 113 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 433edc1..e38982f 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -52,9 +52,16 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 		struct vfio_platform_irq irq;
 		int hwirq = platform_get_irq(vdev->pdev, i);
 
-		irq.flags = VFIO_IRQ_INFO_EVENTFD;
+		spin_lock_init(&irq.lock);
+
+		irq.flags = VFIO_IRQ_INFO_EVENTFD | VFIO_IRQ_INFO_MASKABLE;
+
+		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
+			irq.flags |= VFIO_IRQ_INFO_AUTOMASKED;
+
 		irq.count = 1;
 		irq.hwirq = hwirq;
+		irq.masked = false;
 
 		vdev->irq[i] = irq;
 	}
@@ -66,19 +73,39 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
 {
 	int i;
 
-	for (i = 0; i < vdev->num_irqs; i++)
+	for (i = 0; i < vdev->num_irqs; i++) {
 		vfio_set_trigger(vdev, i, -1);
 
+		if (vdev->irq[i].masked)
+			enable_irq(vdev->irq[i].hwirq);
+	}
+
 	kfree(vdev->irq);
 }
 
 static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
 {
-	struct eventfd_ctx *trigger = dev_id;
+	struct vfio_platform_irq *irq_ctx = dev_id;
+	unsigned long flags;
+	int ret = IRQ_NONE;
+
+	spin_lock_irqsave(&irq_ctx->lock, flags);
+
+	if (!irq_ctx->masked) {
+		ret = IRQ_HANDLED;
+
+		if (irq_ctx->flags & VFIO_IRQ_INFO_AUTOMASKED) {
+			disable_irq_nosync(irq_ctx->hwirq);
+			irq_ctx->masked = true;
+		}
+	}
 
-	eventfd_signal(trigger, 1);
+	spin_unlock_irqrestore(&irq_ctx->lock, flags);
 
-	return IRQ_HANDLED;
+	if (ret == IRQ_HANDLED)
+		eventfd_signal(irq_ctx->trigger, 1);
+
+	return ret;
 }
 
 static int vfio_set_trigger(struct vfio_platform_device *vdev,
@@ -159,6 +186,82 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 	return -EFAULT;
 }
 
+static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
+				    unsigned index, unsigned start,
+				    unsigned count, uint32_t flags, void *data)
+{
+	uint8_t arr;
+
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
+	case VFIO_IRQ_SET_DATA_BOOL:
+		if (copy_from_user(&arr, data, sizeof(uint8_t)))
+			return -EFAULT;
+
+		if (arr != 0x1)
+			return -EINVAL;
+
+	case VFIO_IRQ_SET_DATA_NONE:
+
+		spin_lock_irq(&vdev->irq[index].lock);
+
+		if (vdev->irq[index].masked) {
+			enable_irq(vdev->irq[index].hwirq);
+			vdev->irq[index].masked = false;
+		}
+
+		spin_unlock_irq(&vdev->irq[index].lock);
+
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
+static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
+				    unsigned index, unsigned start,
+				    unsigned count, uint32_t flags, void *data)
+{
+	uint8_t arr;
+
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
+	case VFIO_IRQ_SET_DATA_BOOL:
+		if (copy_from_user(&arr, data, sizeof(uint8_t)))
+			return -EFAULT;
+
+		if (arr != 0x1)
+			return -EINVAL;
+
+	case VFIO_IRQ_SET_DATA_NONE:
+
+		spin_lock_irq(&vdev->irq[index].lock);
+
+		if (!vdev->irq[index].masked) {
+			disable_irq(vdev->irq[index].hwirq);
+			vdev->irq[index].masked = true;
+		}
+
+		spin_unlock_irq(&vdev->irq[index].lock);
+
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
 int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 				 uint32_t flags, unsigned index, unsigned start,
 				 unsigned count, void *data)
@@ -169,8 +272,10 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 
 	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 	case VFIO_IRQ_SET_ACTION_MASK:
+		func = vfio_platform_set_irq_mask;
+		break;
 	case VFIO_IRQ_SET_ACTION_UNMASK:
-		/* XXX not implemented */
+		func = vfio_platform_set_irq_unmask;
 		break;
 	case VFIO_IRQ_SET_ACTION_TRIGGER:
 		func = vfio_platform_set_irq_trigger;
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index befef01..5721313 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -21,6 +21,8 @@ struct vfio_platform_irq {
 	u32			count;
 	int			hwirq;
 	char			*name;
+	bool			masked;
+	spinlock_t		lock;
 };
 
 struct vfio_platform_region {
-- 
1.8.3.2

