Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaJMNMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:12:51 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35114 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbaJMNMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:12:48 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:VFIO DRIVER)
Subject: [PATCH v8 14/18] vfio: move eventfd support code for VFIO_PCI to a separate file
Date: Mon, 13 Oct 2014 15:10:21 +0200
Message-Id: <1413205825-6370-15-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virqfd functionality that is used by VFIO_PCI to implement interrupt
masking and unmasking via an eventfd, is generic enough and can be reused
by another driver. Move it to a separate file in order to allow the code
to be shared.

Also properly export virqfd_enable and virqfd_disable in the process.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/Makefile               |   4 +-
 drivers/vfio/pci/vfio_pci_intrs.c   | 213 -----------------------------------
 drivers/vfio/pci/vfio_pci_private.h |   3 -
 drivers/vfio/virqfd.c               | 214 ++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h                |  28 +++++
 5 files changed, 245 insertions(+), 217 deletions(-)
 create mode 100644 drivers/vfio/virqfd.c

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index dadf0ca..d798b09 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,4 +1,6 @@
-obj-$(CONFIG_VFIO) += vfio.o
+vfio_core-y := vfio.o virqfd.o
+
+obj-$(CONFIG_VFIO) += vfio_core.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
 obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 9dd49c9..3f909bb 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -18,226 +18,13 @@
 #include <linux/eventfd.h>
 #include <linux/pci.h>
 #include <linux/file.h>
-#include <linux/poll.h>
 #include <linux/vfio.h>
 #include <linux/wait.h>
-#include <linux/workqueue.h>
 #include <linux/slab.h>
 
 #include "vfio_pci_private.h"
 
 /*
- * IRQfd - generic
- */
-struct virqfd {
-	struct vfio_pci_device	*vdev;
-	struct eventfd_ctx	*eventfd;
-	int			(*handler)(struct vfio_pci_device *, void *);
-	void			(*thread)(struct vfio_pci_device *, void *);
-	void			*data;
-	struct work_struct	inject;
-	wait_queue_t		wait;
-	poll_table		pt;
-	struct work_struct	shutdown;
-	struct virqfd		**pvirqfd;
-};
-
-static struct workqueue_struct *vfio_irqfd_cleanup_wq;
-
-int __init vfio_pci_virqfd_init(void)
-{
-	vfio_irqfd_cleanup_wq =
-		create_singlethread_workqueue("vfio-irqfd-cleanup");
-	if (!vfio_irqfd_cleanup_wq)
-		return -ENOMEM;
-
-	return 0;
-}
-
-void vfio_pci_virqfd_exit(void)
-{
-	destroy_workqueue(vfio_irqfd_cleanup_wq);
-}
-
-static void virqfd_deactivate(struct virqfd *virqfd)
-{
-	queue_work(vfio_irqfd_cleanup_wq, &virqfd->shutdown);
-}
-
-static int virqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
-{
-	struct virqfd *virqfd = container_of(wait, struct virqfd, wait);
-	unsigned long flags = (unsigned long)key;
-
-	if (flags & POLLIN) {
-		/* An event has been signaled, call function */
-		if ((!virqfd->handler ||
-		     virqfd->handler(virqfd->vdev, virqfd->data)) &&
-		    virqfd->thread)
-			schedule_work(&virqfd->inject);
-	}
-
-	if (flags & POLLHUP) {
-		unsigned long flags;
-		spin_lock_irqsave(&virqfd->vdev->irqlock, flags);
-
-		/*
-		 * The eventfd is closing, if the virqfd has not yet been
-		 * queued for release, as determined by testing whether the
-		 * vdev pointer to it is still valid, queue it now.  As
-		 * with kvm irqfds, we know we won't race against the virqfd
-		 * going away because we hold wqh->lock to get here.
-		 */
-		if (*(virqfd->pvirqfd) == virqfd) {
-			*(virqfd->pvirqfd) = NULL;
-			virqfd_deactivate(virqfd);
-		}
-
-		spin_unlock_irqrestore(&virqfd->vdev->irqlock, flags);
-	}
-
-	return 0;
-}
-
-static void virqfd_ptable_queue_proc(struct file *file,
-				     wait_queue_head_t *wqh, poll_table *pt)
-{
-	struct virqfd *virqfd = container_of(pt, struct virqfd, pt);
-	add_wait_queue(wqh, &virqfd->wait);
-}
-
-static void virqfd_shutdown(struct work_struct *work)
-{
-	struct virqfd *virqfd = container_of(work, struct virqfd, shutdown);
-	u64 cnt;
-
-	eventfd_ctx_remove_wait_queue(virqfd->eventfd, &virqfd->wait, &cnt);
-	flush_work(&virqfd->inject);
-	eventfd_ctx_put(virqfd->eventfd);
-
-	kfree(virqfd);
-}
-
-static void virqfd_inject(struct work_struct *work)
-{
-	struct virqfd *virqfd = container_of(work, struct virqfd, inject);
-	if (virqfd->thread)
-		virqfd->thread(virqfd->vdev, virqfd->data);
-}
-
-static int virqfd_enable(struct vfio_pci_device *vdev,
-			 int (*handler)(struct vfio_pci_device *, void *),
-			 void (*thread)(struct vfio_pci_device *, void *),
-			 void *data, struct virqfd **pvirqfd, int fd)
-{
-	struct fd irqfd;
-	struct eventfd_ctx *ctx;
-	struct virqfd *virqfd;
-	int ret = 0;
-	unsigned int events;
-
-	virqfd = kzalloc(sizeof(*virqfd), GFP_KERNEL);
-	if (!virqfd)
-		return -ENOMEM;
-
-	virqfd->pvirqfd = pvirqfd;
-	virqfd->vdev = vdev;
-	virqfd->handler = handler;
-	virqfd->thread = thread;
-	virqfd->data = data;
-
-	INIT_WORK(&virqfd->shutdown, virqfd_shutdown);
-	INIT_WORK(&virqfd->inject, virqfd_inject);
-
-	irqfd = fdget(fd);
-	if (!irqfd.file) {
-		ret = -EBADF;
-		goto err_fd;
-	}
-
-	ctx = eventfd_ctx_fileget(irqfd.file);
-	if (IS_ERR(ctx)) {
-		ret = PTR_ERR(ctx);
-		goto err_ctx;
-	}
-
-	virqfd->eventfd = ctx;
-
-	/*
-	 * virqfds can be released by closing the eventfd or directly
-	 * through ioctl.  These are both done through a workqueue, so
-	 * we update the pointer to the virqfd under lock to avoid
-	 * pushing multiple jobs to release the same virqfd.
-	 */
-	spin_lock_irq(&vdev->irqlock);
-
-	if (*pvirqfd) {
-		spin_unlock_irq(&vdev->irqlock);
-		ret = -EBUSY;
-		goto err_busy;
-	}
-	*pvirqfd = virqfd;
-
-	spin_unlock_irq(&vdev->irqlock);
-
-	/*
-	 * Install our own custom wake-up handling so we are notified via
-	 * a callback whenever someone signals the underlying eventfd.
-	 */
-	init_waitqueue_func_entry(&virqfd->wait, virqfd_wakeup);
-	init_poll_funcptr(&virqfd->pt, virqfd_ptable_queue_proc);
-
-	events = irqfd.file->f_op->poll(irqfd.file, &virqfd->pt);
-
-	/*
-	 * Check if there was an event already pending on the eventfd
-	 * before we registered and trigger it as if we didn't miss it.
-	 */
-	if (events & POLLIN) {
-		if ((!handler || handler(vdev, data)) && thread)
-			schedule_work(&virqfd->inject);
-	}
-
-	/*
-	 * Do not drop the file until the irqfd is fully initialized,
-	 * otherwise we might race against the POLLHUP.
-	 */
-	fdput(irqfd);
-
-	return 0;
-err_busy:
-	eventfd_ctx_put(ctx);
-err_ctx:
-	fdput(irqfd);
-err_fd:
-	kfree(virqfd);
-
-	return ret;
-}
-
-static void virqfd_disable(struct vfio_pci_device *vdev,
-			   struct virqfd **pvirqfd)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&vdev->irqlock, flags);
-
-	if (*pvirqfd) {
-		virqfd_deactivate(*pvirqfd);
-		*pvirqfd = NULL;
-	}
-
-	spin_unlock_irqrestore(&vdev->irqlock, flags);
-
-	/*
-	 * Block until we know all outstanding shutdown jobs have completed.
-	 * Even if we don't queue the job, flush the wq to be sure it's
-	 * been released.
-	 */
-	flush_workqueue(vfio_irqfd_cleanup_wq);
-}
-
-/*
  * INTx
  */
 static void vfio_send_intx_eventfd(struct vfio_pci_device *vdev, void *unused)
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 671c17a..4c89e0e 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -86,9 +86,6 @@ extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
 
-extern int vfio_pci_virqfd_init(void);
-extern void vfio_pci_virqfd_exit(void);
-
 extern int vfio_config_init(struct vfio_pci_device *vdev);
 extern void vfio_config_free(struct vfio_pci_device *vdev);
 #endif /* VFIO_PCI_PRIVATE_H */
diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
new file mode 100644
index 0000000..243eb61
--- /dev/null
+++ b/drivers/vfio/virqfd.c
@@ -0,0 +1,214 @@
+/*
+ * VFIO generic eventfd code for IRQFD support.
+ * Derived from drivers/vfio/pci/vfio_pci_intrs.c
+ *
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/vfio.h>
+#include <linux/eventfd.h>
+#include <linux/file.h>
+#include <linux/slab.h>
+#include "pci/vfio_pci_private.h"
+
+static struct workqueue_struct *vfio_irqfd_cleanup_wq;
+
+int __init vfio_pci_virqfd_init(void)
+{
+	vfio_irqfd_cleanup_wq =
+		create_singlethread_workqueue("vfio-irqfd-cleanup");
+	if (!vfio_irqfd_cleanup_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void vfio_pci_virqfd_exit(void)
+{
+	destroy_workqueue(vfio_irqfd_cleanup_wq);
+}
+
+static void virqfd_deactivate(struct virqfd *virqfd)
+{
+	queue_work(vfio_irqfd_cleanup_wq, &virqfd->shutdown);
+}
+
+static int virqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	struct virqfd *virqfd = container_of(wait, struct virqfd, wait);
+	unsigned long flags = (unsigned long)key;
+
+	if (flags & POLLIN) {
+		/* An event has been signaled, call function */
+		if ((!virqfd->handler ||
+		     virqfd->handler(virqfd->vdev, virqfd->data)) &&
+		    virqfd->thread)
+			schedule_work(&virqfd->inject);
+	}
+
+	if (flags & POLLHUP) {
+		unsigned long flags;
+		spin_lock_irqsave(&virqfd->vdev->irqlock, flags);
+
+		/*
+		 * The eventfd is closing, if the virqfd has not yet been
+		 * queued for release, as determined by testing whether the
+		 * vdev pointer to it is still valid, queue it now.  As
+		 * with kvm irqfds, we know we won't race against the virqfd
+		 * going away because we hold wqh->lock to get here.
+		 */
+		if (*(virqfd->pvirqfd) == virqfd) {
+			*(virqfd->pvirqfd) = NULL;
+			virqfd_deactivate(virqfd);
+		}
+
+		spin_unlock_irqrestore(&virqfd->vdev->irqlock, flags);
+	}
+
+	return 0;
+}
+
+static void virqfd_ptable_queue_proc(struct file *file,
+				     wait_queue_head_t *wqh, poll_table *pt)
+{
+	struct virqfd *virqfd = container_of(pt, struct virqfd, pt);
+	add_wait_queue(wqh, &virqfd->wait);
+}
+
+static void virqfd_shutdown(struct work_struct *work)
+{
+	struct virqfd *virqfd = container_of(work, struct virqfd, shutdown);
+	u64 cnt;
+
+	eventfd_ctx_remove_wait_queue(virqfd->eventfd, &virqfd->wait, &cnt);
+	flush_work(&virqfd->inject);
+	eventfd_ctx_put(virqfd->eventfd);
+
+	kfree(virqfd);
+}
+
+static void virqfd_inject(struct work_struct *work)
+{
+	struct virqfd *virqfd = container_of(work, struct virqfd, inject);
+	if (virqfd->thread)
+		virqfd->thread(virqfd->vdev, virqfd->data);
+}
+
+int virqfd_enable(struct vfio_pci_device *vdev,
+			 int (*handler)(struct vfio_pci_device *, void *),
+			 void (*thread)(struct vfio_pci_device *, void *),
+			 void *data, struct virqfd **pvirqfd, int fd)
+{
+	struct fd irqfd;
+	struct eventfd_ctx *ctx;
+	struct virqfd *virqfd;
+	int ret = 0;
+	unsigned int events;
+
+	virqfd = kzalloc(sizeof(*virqfd), GFP_KERNEL);
+	if (!virqfd)
+		return -ENOMEM;
+
+	virqfd->pvirqfd = pvirqfd;
+	virqfd->vdev = vdev;
+	virqfd->handler = handler;
+	virqfd->thread = thread;
+	virqfd->data = data;
+
+	INIT_WORK(&virqfd->shutdown, virqfd_shutdown);
+	INIT_WORK(&virqfd->inject, virqfd_inject);
+
+	irqfd = fdget(fd);
+	if (!irqfd.file) {
+		ret = -EBADF;
+		goto err_fd;
+	}
+
+	ctx = eventfd_ctx_fileget(irqfd.file);
+	if (IS_ERR(ctx)) {
+		ret = PTR_ERR(ctx);
+		goto err_ctx;
+	}
+
+	virqfd->eventfd = ctx;
+
+	/*
+	 * virqfds can be released by closing the eventfd or directly
+	 * through ioctl.  These are both done through a workqueue, so
+	 * we update the pointer to the virqfd under lock to avoid
+	 * pushing multiple jobs to release the same virqfd.
+	 */
+	spin_lock_irq(&vdev->irqlock);
+
+	if (*pvirqfd) {
+		spin_unlock_irq(&vdev->irqlock);
+		ret = -EBUSY;
+		goto err_busy;
+	}
+	*pvirqfd = virqfd;
+
+	spin_unlock_irq(&vdev->irqlock);
+
+	/*
+	 * Install our own custom wake-up handling so we are notified via
+	 * a callback whenever someone signals the underlying eventfd.
+	 */
+	init_waitqueue_func_entry(&virqfd->wait, virqfd_wakeup);
+	init_poll_funcptr(&virqfd->pt, virqfd_ptable_queue_proc);
+
+	events = irqfd.file->f_op->poll(irqfd.file, &virqfd->pt);
+
+	/*
+	 * Check if there was an event already pending on the eventfd
+	 * before we registered and trigger it as if we didn't miss it.
+	 */
+	if (events & POLLIN) {
+		if ((!handler || handler(vdev, data)) && thread)
+			schedule_work(&virqfd->inject);
+	}
+
+	/*
+	 * Do not drop the file until the irqfd is fully initialized,
+	 * otherwise we might race against the POLLHUP.
+	 */
+	fdput(irqfd);
+
+	return 0;
+err_busy:
+	eventfd_ctx_put(ctx);
+err_ctx:
+	fdput(irqfd);
+err_fd:
+	kfree(virqfd);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virqfd_enable);
+
+void virqfd_disable(struct vfio_pci_device *vdev,
+			   struct virqfd **pvirqfd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&vdev->irqlock, flags);
+
+	if (*pvirqfd) {
+		virqfd_deactivate(*pvirqfd);
+		*pvirqfd = NULL;
+	}
+
+	spin_unlock_irqrestore(&vdev->irqlock, flags);
+
+	/*
+	 * Block until we know all outstanding shutdown jobs have completed.
+	 * Even if we don't queue the job, flush the wq to be sure it's
+	 * been released.
+	 */
+	flush_workqueue(vfio_irqfd_cleanup_wq);
+}
+EXPORT_SYMBOL_GPL(virqfd_disable);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index d320411..a077c48 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -14,6 +14,8 @@
 
 #include <linux/iommu.h>
 #include <linux/mm.h>
+#include <linux/workqueue.h>
+#include <linux/poll.h>
 #include <uapi/linux/vfio.h>
 
 /**
@@ -121,4 +123,30 @@ static inline long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 	return -ENOTTY;
 }
 #endif /* CONFIG_EEH */
+
+/*
+ * IRQFD support
+ */
+struct virqfd {
+	struct vfio_pci_device	*vdev;
+	struct eventfd_ctx	*eventfd;
+	int			(*handler)(struct vfio_pci_device *, void *);
+	void			(*thread)(struct vfio_pci_device *, void *);
+	void			*data;
+	struct work_struct	inject;
+	wait_queue_t		wait;
+	poll_table		pt;
+	struct work_struct	shutdown;
+	struct virqfd		**pvirqfd;
+};
+
+extern int vfio_pci_virqfd_init(void);
+extern void vfio_pci_virqfd_exit(void);
+extern int virqfd_enable(struct vfio_pci_device *vdev,
+			 int (*handler)(struct vfio_pci_device *, void *),
+			 void (*thread)(struct vfio_pci_device *, void *),
+			 void *data, struct virqfd **pvirqfd, int fd);
+extern void virqfd_disable(struct vfio_pci_device *vdev,
+			   struct virqfd **pvirqfd);
+
 #endif /* VFIO_H */
-- 
2.1.1

