Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbaIWOtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:49:52 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37166 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbaIWOtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:49:47 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, kvm@vger.kernel.org,
        christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, eric.auger@linaro.org,
        marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv7 26/26] vfio/platform: implement IRQ masking/unmasking via an eventfd
Date: Tue, 23 Sep 2014 16:46:25 +0200
Message-Id: <1411483586-29304-27-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch the VFIO user will be able to set an eventfd that can be
used in order to mask and unmask IRQs of platform devices.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform_irq.c     | 48 +++++++++++++++++++++++++--
 drivers/vfio/platform/vfio_platform_private.h |  2 ++
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 90fa25a..4ea3d5a 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -45,11 +45,21 @@ static void vfio_platform_mask(struct vfio_platform_irq *irq_ctx)
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
 {
 	uint8_t irq_bitmap;
+	int32_t fd;
 
 	if (start != 0 || count != 1)
 		return -EINVAL;
@@ -75,7 +85,19 @@ static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
 		vfio_platform_mask(&vdev->irqs[index]);
 		return 0;
 
-	case VFIO_IRQ_SET_DATA_EVENTFD: /* XXX not implemented yet */
+	case VFIO_IRQ_SET_DATA_EVENTFD:
+		if (copy_from_user(&fd, data, sizeof(int32_t)))
+			return -EFAULT;
+
+		if (fd >= 0)
+			return virqfd_enable((void *) &vdev->irqs[index],
+					     vfio_platform_mask_handler,
+					     NULL, NULL,
+					     &vdev->irqs[index].mask, fd);
+
+		virqfd_disable(&vdev->irqs[index].mask);
+		return 0;
+
 	default:
 		return -ENOTTY;
 	}
@@ -97,11 +119,21 @@ static void vfio_platform_unmask(struct vfio_platform_irq *irq_ctx)
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
 {
 	uint8_t irq_bitmap;
+	int32_t fd;
 
 	if (start != 0 || count != 1)
 		return -EINVAL;
@@ -123,7 +155,19 @@ static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
 		vfio_platform_unmask(&vdev->irqs[index]);
 		return 0;
 
-	case VFIO_IRQ_SET_DATA_EVENTFD: /* XXX not implemented yet */
+	case VFIO_IRQ_SET_DATA_EVENTFD:
+		if (copy_from_user(&fd, data, sizeof(int32_t)))
+			return -EFAULT;
+
+		if (fd >= 0)
+			return virqfd_enable((void *) &vdev->irqs[index],
+					     vfio_platform_unmask_handler,
+					     NULL, NULL,
+					     &vdev->irqs[index].unmask, fd);
+
+		virqfd_disable(&vdev->irqs[index].unmask);
+		return 0;
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 500e299..dd1beda 100644
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
1.8.3.2

