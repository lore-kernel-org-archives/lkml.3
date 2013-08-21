Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3HUOza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:55:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab3HUOz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:55:28 -0400
Subject: [PATCH v2] vfio-pci: Use fdget() rather than eventfd_fget()
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, viro@ZenIV.linux.org.uk
Date: Wed, 21 Aug 2013 08:55:26 -0600
Message-ID: <20130821145424.32748.17519.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eventfd_fget() tests to see whether the file is an eventfd file, which
we then immediately pass to eventfd_ctx_fileget(), which again tests
whether the file is an eventfd file.  Simplify slightly by using
fdget() so that we only test that we're looking at an eventfd once.
fget() could also be used, but fdget() makes use of fget_light() for
another slight optimization.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

v2: Use direct gotos in error path per Al Viro's comment

 drivers/vfio/pci/vfio_pci_intrs.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 4bc704e..641bc87 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -130,8 +130,8 @@ static int virqfd_enable(struct vfio_pci_device *vdev,
 			 void (*thread)(struct vfio_pci_device *, void *),
 			 void *data, struct virqfd **pvirqfd, int fd)
 {
-	struct file *file = NULL;
-	struct eventfd_ctx *ctx = NULL;
+	struct fd irqfd;
+	struct eventfd_ctx *ctx;
 	struct virqfd *virqfd;
 	int ret = 0;
 	unsigned int events;
@@ -149,16 +149,16 @@ static int virqfd_enable(struct vfio_pci_device *vdev,
 	INIT_WORK(&virqfd->shutdown, virqfd_shutdown);
 	INIT_WORK(&virqfd->inject, virqfd_inject);
 
-	file = eventfd_fget(fd);
-	if (IS_ERR(file)) {
-		ret = PTR_ERR(file);
-		goto fail;
+	irqfd = fdget(fd);
+	if (!irqfd.file) {
+		ret = -EBADF;
+		goto err_fd;
 	}
 
-	ctx = eventfd_ctx_fileget(file);
+	ctx = eventfd_ctx_fileget(irqfd.file);
 	if (IS_ERR(ctx)) {
 		ret = PTR_ERR(ctx);
-		goto fail;
+		goto err_ctx;
 	}
 
 	virqfd->eventfd = ctx;
@@ -174,7 +174,7 @@ static int virqfd_enable(struct vfio_pci_device *vdev,
 	if (*pvirqfd) {
 		spin_unlock_irq(&vdev->irqlock);
 		ret = -EBUSY;
-		goto fail;
+		goto err_busy;
 	}
 	*pvirqfd = virqfd;
 
@@ -187,7 +187,7 @@ static int virqfd_enable(struct vfio_pci_device *vdev,
 	init_waitqueue_func_entry(&virqfd->wait, virqfd_wakeup);
 	init_poll_funcptr(&virqfd->pt, virqfd_ptable_queue_proc);
 
-	events = file->f_op->poll(file, &virqfd->pt);
+	events = irqfd.file->f_op->poll(irqfd.file, &virqfd->pt);
 
 	/*
 	 * Check if there was an event already pending on the eventfd
@@ -202,17 +202,14 @@ static int virqfd_enable(struct vfio_pci_device *vdev,
 	 * Do not drop the file until the irqfd is fully initialized,
 	 * otherwise we might race against the POLLHUP.
 	 */
-	fput(file);
+	fdput(irqfd);
 
 	return 0;
-
-fail:
-	if (ctx && !IS_ERR(ctx))
-		eventfd_ctx_put(ctx);
-
-	if (file && !IS_ERR(file))
-		fput(file);
-
+err_busy:
+	eventfd_ctx_put(ctx);
+err_ctx:
+	fdput(irqfd);
+err_fd:
 	kfree(virqfd);
 
 	return ret;

