Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaJ0SLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:11:35 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:57109 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaJ0SKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:10:34 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v9 17/19] vfio: virqfd: add vfio_ prefix to virqfd_enable and virqfd_disable
Date: Mon, 27 Oct 2014 19:08:02 +0100
Message-Id: <1414433284-31719-18-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virqfd_enable and virqfd_disable functions are now global. Add the
vfio_ prefix to those functions.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 18 +++++++++---------
 drivers/vfio/virqfd.c             | 14 +++++++-------
 include/linux/vfio.h              | 10 +++++-----
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6ca22a8..2aedff1 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -228,8 +228,8 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 static void vfio_intx_disable(struct vfio_pci_device *vdev)
 {
 	vfio_intx_set_signal(vdev, -1);
-	virqfd_disable(&vdev->ctx[0].unmask);
-	virqfd_disable(&vdev->ctx[0].mask);
+	vfio_virqfd_disable(&vdev->ctx[0].unmask);
+	vfio_virqfd_disable(&vdev->ctx[0].mask);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vdev->num_ctx = 0;
 	kfree(vdev->ctx);
@@ -379,8 +379,8 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 	vfio_msi_set_block(vdev, 0, vdev->num_ctx, NULL, msix);
 
 	for (i = 0; i < vdev->num_ctx; i++) {
-		virqfd_disable(&vdev->ctx[i].unmask);
-		virqfd_disable(&vdev->ctx[i].mask);
+		vfio_virqfd_disable(&vdev->ctx[i].unmask);
+		vfio_virqfd_disable(&vdev->ctx[i].mask);
 	}
 
 	if (msix) {
@@ -413,12 +413,12 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		int32_t fd = *(int32_t *)data;
 		if (fd >= 0)
-			return virqfd_enable((void *) vdev,
-					     vfio_pci_intx_unmask_handler,
-					     vfio_send_intx_eventfd, NULL,
-					     &vdev->ctx[0].unmask, fd);
+			return vfio_virqfd_enable((void *) vdev,
+						  vfio_pci_intx_unmask_handler,
+						  vfio_send_intx_eventfd, NULL,
+						  &vdev->ctx[0].unmask, fd);
 
-		virqfd_disable(&vdev->ctx[0].unmask);
+		vfio_virqfd_disable(&vdev->ctx[0].unmask);
 	}
 
 	return 0;
diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
index ac63ec0..1794f07 100644
--- a/drivers/vfio/virqfd.c
+++ b/drivers/vfio/virqfd.c
@@ -101,10 +101,10 @@ static void virqfd_inject(struct work_struct *work)
 		virqfd->thread(virqfd->opaque, virqfd->data);
 }
 
-int virqfd_enable(void *opaque,
-		  int (*handler)(void *, void *),
-		  void (*thread)(void *, void *),
-		  void *data, struct virqfd **pvirqfd, int fd)
+int vfio_virqfd_enable(void *opaque,
+		       int (*handler)(void *, void *),
+		       void (*thread)(void *, void *),
+		       void *data, struct virqfd **pvirqfd, int fd)
 {
 	struct fd irqfd;
 	struct eventfd_ctx *ctx;
@@ -190,9 +190,9 @@ err_fd:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(virqfd_enable);
+EXPORT_SYMBOL_GPL(vfio_virqfd_enable);
 
-void virqfd_disable(struct virqfd **pvirqfd)
+void vfio_virqfd_disable(struct virqfd **pvirqfd)
 {
 	unsigned long flags;
 
@@ -212,4 +212,4 @@ void virqfd_disable(struct virqfd **pvirqfd)
 	 */
 	flush_workqueue(vfio_irqfd_cleanup_wq);
 }
-EXPORT_SYMBOL_GPL(virqfd_disable);
+EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ce23a42..378f320 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -142,10 +142,10 @@ struct virqfd {
 
 extern int vfio_pci_virqfd_init(void);
 extern void vfio_pci_virqfd_exit(void);
-extern int virqfd_enable(void *opaque,
-			 int (*handler)(void *, void *),
-			 void (*thread)(void *, void *),
-			 void *data, struct virqfd **pvirqfd, int fd);
-extern void virqfd_disable(struct virqfd **pvirqfd);
+extern int vfio_virqfd_enable(void *opaque,
+			      int (*handler)(void *, void *),
+			      void (*thread)(void *, void *),
+			      void *data, struct virqfd **pvirqfd, int fd);
+extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
 #endif /* VFIO_H */
-- 
2.1.1

