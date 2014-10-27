Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaJ0SKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:10:53 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54719 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaJ0SKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:10:46 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v9 19/19] vfio/platform: implement IRQ masking/unmasking via an eventfd
Date: Mon, 27 Oct 2014 19:08:04 +0100
Message-Id: <1414433284-31719-20-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch the VFIO user will be able to set an eventfd that can be
used in order to mask and unmask IRQs of platform devices.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_irq.c     | 47 ++++++++++++++++++++++++---
 drivers/vfio/platform/vfio_platform_private.h |  2 ++
 2 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 563abf6..08d400e 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -45,6 +45,15 @@ static void vfio_platform_mask(struct vfio_platform_irq *irq_ctx)
 	spin_unlock_irqrestore(&irq_ctx->lock, flags);
 }
 
+static int vfio_platform_mask_handler(void *opaque, void *unused)
+{
+	struct vfio_platform_irq *irq_ctx = opaque;
+
+	vfio_platform_mask(irq_ctx);
+
+	return 0;
+}
+
 static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
@@ -55,8 +64,18 @@ static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
 	if (!(vdev->irqs[index].flags & VFIO_IRQ_INFO_MASKABLE))
 		return -EINVAL;
 
-	if (flags & VFIO_IRQ_SET_DATA_EVENTFD)
-		return -EINVAL; /* not implemented yet */
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		int32_t fd = *(int32_t *)data;
+
+		if (fd >= 0)
+			return vfio_virqfd_enable((void *) &vdev->irqs[index],
+						  vfio_platform_mask_handler,
+						  NULL, NULL,
+						  &vdev->irqs[index].mask, fd);
+
+		vfio_virqfd_disable(&vdev->irqs[index].mask);
+		return 0;
+	}
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
 		vfio_platform_mask(&vdev->irqs[index]);
@@ -85,6 +104,15 @@ static void vfio_platform_unmask(struct vfio_platform_irq *irq_ctx)
 	spin_unlock_irqrestore(&irq_ctx->lock, flags);
 }
 
+static int vfio_platform_unmask_handler(void *opaque, void *unused)
+{
+	struct vfio_platform_irq *irq_ctx = opaque;
+
+	vfio_platform_unmask(irq_ctx);
+
+	return 0;
+}
+
 static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
@@ -95,8 +123,19 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
 	if (!(vdev->irqs[index].flags & VFIO_IRQ_INFO_MASKABLE))
 		return -EINVAL;
 
-	if (flags & VFIO_IRQ_SET_DATA_EVENTFD)
-		return -EINVAL; /* not implemented yet */
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		int32_t fd = *(int32_t *)data;
+
+		if (fd >= 0)
+			return vfio_virqfd_enable((void *) &vdev->irqs[index],
+						  vfio_platform_unmask_handler,
+						  NULL, NULL,
+						  &vdev->irqs[index].unmask,
+						  fd);
+
+		vfio_virqfd_disable(&vdev->irqs[index].unmask);
+		return 0;
+	}
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
 		vfio_platform_unmask(&vdev->irqs[index]);
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index d25c4cd..70c7527 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -32,6 +32,8 @@ struct vfio_platform_irq {
 	struct eventfd_ctx	*trigger;
 	bool			masked;
 	spinlock_t		lock;
+	struct virqfd		*unmask;
+	struct virqfd		*mask;
 };
 
 struct vfio_platform_region {
-- 
2.1.1

