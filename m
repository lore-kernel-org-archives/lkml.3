Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbaK0Rfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:35:51 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:60627 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaK0Rfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:35:47 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v10 17/20] vfio: pass an opaque pointer on virqfd initialization
Date: Thu, 27 Nov 2014 18:32:57 +0100
Message-Id: <1417109580-10505-18-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417109580-10505-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO_PCI passes the VFIO device structure *vdev via eventfd to the handler
that implements masking/unmasking of IRQs via an eventfd. We can replace
it in the virqfd infrastructure with an opaque type so we can make use
of the mechanism from other VFIO bus drivers.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 61505c1c..86bdcd6 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -31,10 +31,10 @@
  * IRQfd - generic
  */
 struct virqfd {
-	struct vfio_pci_device	*vdev;
+	void			*opaque;
 	struct eventfd_ctx	*eventfd;
-	int			(*handler)(struct vfio_pci_device *, void *);
-	void			(*thread)(struct vfio_pci_device *, void *);
+	int			(*handler)(void *, void *);
+	void			(*thread)(void *, void *);
 	void			*data;
 	struct work_struct	inject;
 	wait_queue_t		wait;
@@ -74,7 +74,7 @@ static int virqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 	if (flags & POLLIN) {
 		/* An event has been signaled, call function */
 		if ((!virqfd->handler ||
-		     virqfd->handler(virqfd->vdev, virqfd->data)) &&
+		     virqfd->handler(virqfd->opaque, virqfd->data)) &&
 		    virqfd->thread)
 			schedule_work(&virqfd->inject);
 	}
@@ -124,12 +124,12 @@ static void virqfd_inject(struct work_struct *work)
 {
 	struct virqfd *virqfd = container_of(work, struct virqfd, inject);
 	if (virqfd->thread)
-		virqfd->thread(virqfd->vdev, virqfd->data);
+		virqfd->thread(virqfd->opaque, virqfd->data);
 }
 
-int vfio_virqfd_enable(struct vfio_pci_device *vdev,
-		       int (*handler)(struct vfio_pci_device *, void *),
-		       void (*thread)(struct vfio_pci_device *, void *),
+int vfio_virqfd_enable(void *opaque,
+		       int (*handler)(void *, void *),
+		       void (*thread)(void *, void *),
 		       void *data, struct virqfd **pvirqfd, int fd)
 {
 	struct fd irqfd;
@@ -143,7 +143,7 @@ int vfio_virqfd_enable(struct vfio_pci_device *vdev,
 		return -ENOMEM;
 
 	virqfd->pvirqfd = pvirqfd;
-	virqfd->vdev = vdev;
+	virqfd->opaque = opaque;
 	virqfd->handler = handler;
 	virqfd->thread = thread;
 	virqfd->data = data;
@@ -196,7 +196,7 @@ int vfio_virqfd_enable(struct vfio_pci_device *vdev,
 	 * before we registered and trigger it as if we didn't miss it.
 	 */
 	if (events & POLLIN) {
-		if ((!handler || handler(vdev, data)) && thread)
+		if ((!handler || handler(opaque, data)) && thread)
 			schedule_work(&virqfd->inject);
 	}
 
@@ -243,8 +243,10 @@ EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
 /*
  * INTx
  */
-static void vfio_send_intx_eventfd(struct vfio_pci_device *vdev, void *unused)
+static void vfio_send_intx_eventfd(void *opaque, void *unused)
 {
+	struct vfio_pci_device *vdev = opaque;
+
 	if (likely(is_intx(vdev) && !vdev->virq_disabled))
 		eventfd_signal(vdev->ctx[0].trigger, 1);
 }
@@ -287,9 +289,9 @@ void vfio_pci_intx_mask(struct vfio_pci_device *vdev)
  * a signal is necessary, which can then be handled via a work queue
  * or directly depending on the caller.
  */
-static int vfio_pci_intx_unmask_handler(struct vfio_pci_device *vdev,
-					void *unused)
+static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 {
+	struct vfio_pci_device *vdev = opaque;
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long flags;
 	int ret = 0;
@@ -641,7 +643,7 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		int32_t fd = *(int32_t *)data;
 		if (fd >= 0)
-			return vfio_virqfd_enable(vdev,
+			return vfio_virqfd_enable((void *) vdev,
 						  vfio_pci_intx_unmask_handler,
 						  vfio_send_intx_eventfd, NULL,
 						  &vdev->ctx[0].unmask, fd);
-- 
2.1.3

