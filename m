Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaK0RfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:35:20 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54059 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaK0RfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:35:16 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v10 12/20] vfio/platform: trigger an interrupt via eventfd
Date: Thu, 27 Nov 2014 18:32:52 +0100
Message-Id: <1417109580-10505-13-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to set an eventfd for a platform device's interrupt,
and also to trigger the interrupt eventfd from userspace for testing.
Level sensitive interrupts are marked as maskable and are handled in
a later patch. Edge triggered interrupts are not advertised as maskable
and are implemented here using a simple and efficient IRQ handler.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_irq.c     | 93 ++++++++++++++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |  2 +
 2 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index df5c919..414b4c5 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -39,12 +39,91 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
 	return -EINVAL;
 }
 
+static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
+{
+	struct vfio_platform_irq *irq_ctx = dev_id;
+
+	eventfd_signal(irq_ctx->trigger, 1);
+
+	return IRQ_HANDLED;
+}
+
+static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
+			    int fd, irq_handler_t handler)
+{
+	struct vfio_platform_irq *irq = &vdev->irqs[index];
+	struct eventfd_ctx *trigger;
+	int ret;
+
+	if (irq->trigger) {
+		free_irq(irq->hwirq, irq);
+		kfree(irq->name);
+		eventfd_ctx_put(irq->trigger);
+		irq->trigger = NULL;
+	}
+
+	if (fd < 0) /* Disable only */
+		return 0;
+
+	irq->name = kasprintf(GFP_KERNEL, "vfio-irq[%d](%s)",
+						irq->hwirq, vdev->name);
+	if (!irq->name)
+		return -ENOMEM;
+
+	trigger = eventfd_ctx_fdget(fd);
+	if (IS_ERR(trigger)) {
+		kfree(irq->name);
+		return PTR_ERR(trigger);
+	}
+
+	irq->trigger = trigger;
+
+	ret = request_irq(irq->hwirq, handler, 0, irq->name, irq);
+	if (ret) {
+		kfree(irq->name);
+		eventfd_ctx_put(trigger);
+		irq->trigger = NULL;
+	}
+
+	return ret;
+}
+
 static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 					 unsigned index, unsigned start,
 					 unsigned count, uint32_t flags,
 					 void *data)
 {
-	return -EINVAL;
+	struct vfio_platform_irq *irq = &vdev->irqs[index];
+	irq_handler_t handler;
+
+	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_AUTOMASKED)
+		return -EINVAL; /* not implemented */
+	else
+		handler = vfio_irq_handler;
+
+	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
+		return vfio_set_trigger(vdev, index, -1, handler);
+
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		int32_t fd = *(int32_t *)data;
+
+		return vfio_set_trigger(vdev, index, fd, handler);
+	}
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+		handler(irq->hwirq, irq);
+
+	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+		uint8_t trigger = *(uint8_t *)data;
+
+		if (trigger)
+			handler(irq->hwirq, irq);
+	}
+
+	return 0;
 }
 
 int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
@@ -90,7 +169,12 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 		if (hwirq < 0)
 			goto err;
 
-		vdev->irqs[i].flags = 0;
+		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
+
+		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
+			vdev->irqs[i].flags |= VFIO_IRQ_INFO_MASKABLE
+						| VFIO_IRQ_INFO_AUTOMASKED;
+
 		vdev->irqs[i].count = 1;
 		vdev->irqs[i].hwirq = hwirq;
 	}
@@ -105,6 +189,11 @@ err:
 
 void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
 {
+	int i;
+
+	for (i = 0; i < vdev->num_irqs; i++)
+		vfio_set_trigger(vdev, i, -1, NULL);
+
 	vdev->num_irqs = 0;
 	kfree(vdev->irqs);
 }
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 61f3ed4..b705f17 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -28,6 +28,8 @@ struct vfio_platform_irq {
 	u32			flags;
 	u32			count;
 	int			hwirq;
+	char			*name;
+	struct eventfd_ctx	*trigger;
 };
 
 struct vfio_platform_region {
-- 
2.1.3

