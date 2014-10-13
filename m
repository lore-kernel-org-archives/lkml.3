Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaJMNMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:12:40 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53712 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbaJMNMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:12:33 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v8 12/18] vfio/platform: trigger an interrupt via eventfd
Date: Mon, 13 Oct 2014 15:10:19 +0200
Message-Id: <1413205825-6370-13-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to set an eventfd for a patform device's interrupt,
and also to trigger the interrupt eventfd from userspace for testing.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_irq.c     | 83 ++++++++++++++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |  2 +
 2 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 007b386..4359b9c 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -45,11 +45,85 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
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
+static int vfio_set_trigger(struct vfio_platform_device *vdev,
+			    int index, int fd)
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
+	ret = request_irq(irq->hwirq, vfio_irq_handler, 0, irq->name, irq);
+	if (ret) {
+		kfree(irq->name);
+		eventfd_ctx_put(trigger);
+		irq->trigger = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
 static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 				     unsigned index, unsigned start,
 				     unsigned count, uint32_t flags, void *data)
 {
-	return -EINVAL;
+	struct vfio_platform_irq *irq = &vdev->irqs[index];
+
+	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE))
+		return vfio_set_trigger(vdev, index, -1);
+
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		int32_t fd = *(int32_t *)data;
+
+		return vfio_set_trigger(vdev, index, fd);
+	}
+
+	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+		vfio_irq_handler(irq->hwirq, irq);
+
+	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+		uint8_t trigger = *(uint8_t *)data;
+
+		if (trigger)
+			vfio_irq_handler(irq->hwirq, irq);
+	}
+
+	return 0;
 }
 
 int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
@@ -95,7 +169,7 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 		if (hwirq < 0)
 			goto err;
 
-		vdev->irqs[i].flags = 0;
+		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
 		vdev->irqs[i].count = 1;
 		vdev->irqs[i].hwirq = hwirq;
 	}
@@ -110,6 +184,11 @@ err:
 
 void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
 {
+	int i;
+
+	for (i = 0; i < vdev->num_irqs; i++)
+		vfio_set_trigger(vdev, i, -1);
+
 	vdev->num_irqs = 0;
 	kfree(vdev->irqs);
 }
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 11ad1bb..47af6e0 100644
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
2.1.1

