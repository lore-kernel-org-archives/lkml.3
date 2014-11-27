Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaK0Rff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:35:35 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65426 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaK0Rfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:35:30 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v10 14/20] vfio: add a vfio_ prefix to virqfd_enable and virqfd_disable and export
Date: Thu, 27 Nov 2014 18:32:54 +0100
Message-Id: <1417109580-10505-15-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to reuse virqfd functionality in multiple VFIO drivers; before
moving these functions to core VFIO, add the vfio_ prefix to the
virqfd_enable and virqfd_disable functions, and export them so they can
be used from other modules.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c   | 30 ++++++++++++++++--------------
 drivers/vfio/pci/vfio_pci_private.h |  4 ++--
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 553212f..3aaac47 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -126,10 +126,10 @@ static void virqfd_inject(struct work_struct *work)
 		virqfd->thread(virqfd->vdev, virqfd->data);
 }
 
-static int virqfd_enable(struct vfio_pci_device *vdev,
-			 int (*handler)(struct vfio_pci_device *, void *),
-			 void (*thread)(struct vfio_pci_device *, void *),
-			 void *data, struct virqfd **pvirqfd, int fd)
+int vfio_virqfd_enable(struct vfio_pci_device *vdev,
+		       int (*handler)(struct vfio_pci_device *, void *),
+		       void (*thread)(struct vfio_pci_device *, void *),
+		       void *data, struct virqfd **pvirqfd, int fd)
 {
 	struct fd irqfd;
 	struct eventfd_ctx *ctx;
@@ -215,9 +215,9 @@ err_fd:
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_virqfd_enable);
 
-static void virqfd_disable(struct vfio_pci_device *vdev,
-			   struct virqfd **pvirqfd)
+void vfio_virqfd_disable(struct vfio_pci_device *vdev, struct virqfd **pvirqfd)
 {
 	unsigned long flags;
 
@@ -237,6 +237,7 @@ static void virqfd_disable(struct vfio_pci_device *vdev,
 	 */
 	flush_workqueue(vfio_irqfd_cleanup_wq);
 }
+EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
 
 /*
  * INTx
@@ -440,8 +441,8 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 static void vfio_intx_disable(struct vfio_pci_device *vdev)
 {
 	vfio_intx_set_signal(vdev, -1);
-	virqfd_disable(vdev, &vdev->ctx[0].unmask);
-	virqfd_disable(vdev, &vdev->ctx[0].mask);
+	vfio_virqfd_disable(vdev, &vdev->ctx[0].unmask);
+	vfio_virqfd_disable(vdev, &vdev->ctx[0].mask);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vdev->num_ctx = 0;
 	kfree(vdev->ctx);
@@ -605,8 +606,8 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 	vfio_msi_set_block(vdev, 0, vdev->num_ctx, NULL, msix);
 
 	for (i = 0; i < vdev->num_ctx; i++) {
-		virqfd_disable(vdev, &vdev->ctx[i].unmask);
-		virqfd_disable(vdev, &vdev->ctx[i].mask);
+		vfio_virqfd_disable(vdev, &vdev->ctx[i].unmask);
+		vfio_virqfd_disable(vdev, &vdev->ctx[i].mask);
 	}
 
 	if (msix) {
@@ -639,11 +640,12 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		int32_t fd = *(int32_t *)data;
 		if (fd >= 0)
-			return virqfd_enable(vdev, vfio_pci_intx_unmask_handler,
-					     vfio_send_intx_eventfd, NULL,
-					     &vdev->ctx[0].unmask, fd);
+			return vfio_virqfd_enable(vdev,
+						  vfio_pci_intx_unmask_handler,
+						  vfio_send_intx_eventfd, NULL,
+						  &vdev->ctx[0].unmask, fd);
 
-		virqfd_disable(vdev, &vdev->ctx[0].unmask);
+		vfio_virqfd_disable(vdev, &vdev->ctx[0].unmask);
 	}
 
 	return 0;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 671c17a..2e2f0ea 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -86,8 +86,8 @@ extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
 
-extern int vfio_pci_virqfd_init(void);
-extern void vfio_pci_virqfd_exit(void);
+extern int vfio_virqfd_init(void);
+extern void vfio_virqfd_exit(void);
 
 extern int vfio_config_init(struct vfio_pci_device *vdev);
 extern void vfio_config_free(struct vfio_pci_device *vdev);
-- 
2.1.3

