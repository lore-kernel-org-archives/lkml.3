Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaJMNM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:12:59 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60532 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbaJMNM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:12:56 -0400
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
Subject: [PATCH v8 16/18] vfio: pass an opaque pointer on virqfd initialization
Date: Mon, 13 Oct 2014 15:10:23 +0200
Message-Id: <1413205825-6370-17-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO_PCI passes the VFIO device structure *vdev via eventfd to the handler
that implements masking/unmasking of IRQs via an eventfd. We can replace
it in the virqfd infrastructure with an opaque type so we can make use
of the mechanism from other VFIO bus drivers.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 11 +++++++----
 drivers/vfio/virqfd.c             | 17 ++++++++---------
 include/linux/vfio.h              | 12 ++++++------
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index e56c814..6ca22a8 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -27,8 +27,10 @@
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
@@ -71,9 +73,9 @@ void vfio_pci_intx_mask(struct vfio_pci_device *vdev)
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
@@ -411,7 +413,8 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		int32_t fd = *(int32_t *)data;
 		if (fd >= 0)
-			return virqfd_enable(vdev, vfio_pci_intx_unmask_handler,
+			return virqfd_enable((void *) vdev,
+					     vfio_pci_intx_unmask_handler,
 					     vfio_send_intx_eventfd, NULL,
 					     &vdev->ctx[0].unmask, fd);
 
diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
index 27fa2f0..ac63ec0 100644
--- a/drivers/vfio/virqfd.c
+++ b/drivers/vfio/virqfd.c
@@ -14,7 +14,6 @@
 #include <linux/eventfd.h>
 #include <linux/file.h>
 #include <linux/slab.h>
-#include "pci/vfio_pci_private.h"
 
 static struct workqueue_struct *vfio_irqfd_cleanup_wq;
 static spinlock_t lock;
@@ -49,7 +48,7 @@ static int virqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 	if (flags & POLLIN) {
 		/* An event has been signaled, call function */
 		if ((!virqfd->handler ||
-		     virqfd->handler(virqfd->vdev, virqfd->data)) &&
+		     virqfd->handler(virqfd->opaque, virqfd->data)) &&
 		    virqfd->thread)
 			schedule_work(&virqfd->inject);
 	}
@@ -99,13 +98,13 @@ static void virqfd_inject(struct work_struct *work)
 {
 	struct virqfd *virqfd = container_of(work, struct virqfd, inject);
 	if (virqfd->thread)
-		virqfd->thread(virqfd->vdev, virqfd->data);
+		virqfd->thread(virqfd->opaque, virqfd->data);
 }
 
-int virqfd_enable(struct vfio_pci_device *vdev,
-			 int (*handler)(struct vfio_pci_device *, void *),
-			 void (*thread)(struct vfio_pci_device *, void *),
-			 void *data, struct virqfd **pvirqfd, int fd)
+int virqfd_enable(void *opaque,
+		  int (*handler)(void *, void *),
+		  void (*thread)(void *, void *),
+		  void *data, struct virqfd **pvirqfd, int fd)
 {
 	struct fd irqfd;
 	struct eventfd_ctx *ctx;
@@ -118,7 +117,7 @@ int virqfd_enable(struct vfio_pci_device *vdev,
 		return -ENOMEM;
 
 	virqfd->pvirqfd = pvirqfd;
-	virqfd->vdev = vdev;
+	virqfd->opaque = opaque;
 	virqfd->handler = handler;
 	virqfd->thread = thread;
 	virqfd->data = data;
@@ -171,7 +170,7 @@ int virqfd_enable(struct vfio_pci_device *vdev,
 	 * before we registered and trigger it as if we didn't miss it.
 	 */
 	if (events & POLLIN) {
-		if ((!handler || handler(vdev, data)) && thread)
+		if ((!handler || handler(opaque, data)) && thread)
 			schedule_work(&virqfd->inject);
 	}
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index fb6037b..ce23a42 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -128,10 +128,10 @@ static inline long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
  * IRQFD support
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
@@ -142,9 +142,9 @@ struct virqfd {
 
 extern int vfio_pci_virqfd_init(void);
 extern void vfio_pci_virqfd_exit(void);
-extern int virqfd_enable(struct vfio_pci_device *vdev,
-			 int (*handler)(struct vfio_pci_device *, void *),
-			 void (*thread)(struct vfio_pci_device *, void *),
+extern int virqfd_enable(void *opaque,
+			 int (*handler)(void *, void *),
+			 void (*thread)(void *, void *),
 			 void *data, struct virqfd **pvirqfd, int fd);
 extern void virqfd_disable(struct virqfd **pvirqfd);
 
-- 
2.1.1

