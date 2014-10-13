Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaJMNMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:12:55 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57407 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbaJMNMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:12:52 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v8 15/18] vfio: add local lock in virqfd instead of depending on VFIO PCI
Date: Mon, 13 Oct 2014 15:10:22 +0200
Message-Id: <1413205825-6370-16-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virqfd just needs to keep accesses to any struct *virqfd safe, but this
comes into play only when creating or destroying eventfds, so sharing
the same spinlock with the VFIO bus driver is not necessary.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 10 +++++-----
 drivers/vfio/virqfd.c             | 24 +++++++++++++-----------
 include/linux/vfio.h              |  3 +--
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 3f909bb..e56c814 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -226,8 +226,8 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 static void vfio_intx_disable(struct vfio_pci_device *vdev)
 {
 	vfio_intx_set_signal(vdev, -1);
-	virqfd_disable(vdev, &vdev->ctx[0].unmask);
-	virqfd_disable(vdev, &vdev->ctx[0].mask);
+	virqfd_disable(&vdev->ctx[0].unmask);
+	virqfd_disable(&vdev->ctx[0].mask);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vdev->num_ctx = 0;
 	kfree(vdev->ctx);
@@ -377,8 +377,8 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 	vfio_msi_set_block(vdev, 0, vdev->num_ctx, NULL, msix);
 
 	for (i = 0; i < vdev->num_ctx; i++) {
-		virqfd_disable(vdev, &vdev->ctx[i].unmask);
-		virqfd_disable(vdev, &vdev->ctx[i].mask);
+		virqfd_disable(&vdev->ctx[i].unmask);
+		virqfd_disable(&vdev->ctx[i].mask);
 	}
 
 	if (msix) {
@@ -415,7 +415,7 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 					     vfio_send_intx_eventfd, NULL,
 					     &vdev->ctx[0].unmask, fd);
 
-		virqfd_disable(vdev, &vdev->ctx[0].unmask);
+		virqfd_disable(&vdev->ctx[0].unmask);
 	}
 
 	return 0;
diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
index 243eb61..27fa2f0 100644
--- a/drivers/vfio/virqfd.c
+++ b/drivers/vfio/virqfd.c
@@ -17,6 +17,7 @@
 #include "pci/vfio_pci_private.h"
 
 static struct workqueue_struct *vfio_irqfd_cleanup_wq;
+static spinlock_t lock;
 
 int __init vfio_pci_virqfd_init(void)
 {
@@ -25,6 +26,8 @@ int __init vfio_pci_virqfd_init(void)
 	if (!vfio_irqfd_cleanup_wq)
 		return -ENOMEM;
 
+	spin_lock_init(&lock);
+
 	return 0;
 }
 
@@ -53,21 +56,21 @@ static int virqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 
 	if (flags & POLLHUP) {
 		unsigned long flags;
-		spin_lock_irqsave(&virqfd->vdev->irqlock, flags);
+		spin_lock_irqsave(&lock, flags);
 
 		/*
 		 * The eventfd is closing, if the virqfd has not yet been
 		 * queued for release, as determined by testing whether the
-		 * vdev pointer to it is still valid, queue it now.  As
+		 * virqfd pointer to it is still valid, queue it now.  As
 		 * with kvm irqfds, we know we won't race against the virqfd
-		 * going away because we hold wqh->lock to get here.
+		 * going away because we hold the lock to get here.
 		 */
 		if (*(virqfd->pvirqfd) == virqfd) {
 			*(virqfd->pvirqfd) = NULL;
 			virqfd_deactivate(virqfd);
 		}
 
-		spin_unlock_irqrestore(&virqfd->vdev->irqlock, flags);
+		spin_unlock_irqrestore(&lock, flags);
 	}
 
 	return 0;
@@ -143,16 +146,16 @@ int virqfd_enable(struct vfio_pci_device *vdev,
 	 * we update the pointer to the virqfd under lock to avoid
 	 * pushing multiple jobs to release the same virqfd.
 	 */
-	spin_lock_irq(&vdev->irqlock);
+	spin_lock_irq(&lock);
 
 	if (*pvirqfd) {
-		spin_unlock_irq(&vdev->irqlock);
+		spin_unlock_irq(&lock);
 		ret = -EBUSY;
 		goto err_busy;
 	}
 	*pvirqfd = virqfd;
 
-	spin_unlock_irq(&vdev->irqlock);
+	spin_unlock_irq(&lock);
 
 	/*
 	 * Install our own custom wake-up handling so we are notified via
@@ -190,19 +193,18 @@ err_fd:
 }
 EXPORT_SYMBOL_GPL(virqfd_enable);
 
-void virqfd_disable(struct vfio_pci_device *vdev,
-			   struct virqfd **pvirqfd)
+void virqfd_disable(struct virqfd **pvirqfd)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&vdev->irqlock, flags);
+	spin_lock_irqsave(&lock, flags);
 
 	if (*pvirqfd) {
 		virqfd_deactivate(*pvirqfd);
 		*pvirqfd = NULL;
 	}
 
-	spin_unlock_irqrestore(&vdev->irqlock, flags);
+	spin_unlock_irqrestore(&lock, flags);
 
 	/*
 	 * Block until we know all outstanding shutdown jobs have completed.
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index a077c48..fb6037b 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -146,7 +146,6 @@ extern int virqfd_enable(struct vfio_pci_device *vdev,
 			 int (*handler)(struct vfio_pci_device *, void *),
 			 void (*thread)(struct vfio_pci_device *, void *),
 			 void *data, struct virqfd **pvirqfd, int fd);
-extern void virqfd_disable(struct vfio_pci_device *vdev,
-			   struct virqfd **pvirqfd);
+extern void virqfd_disable(struct virqfd **pvirqfd);
 
 #endif /* VFIO_H */
-- 
2.1.1

