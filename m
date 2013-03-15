Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3COJaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:30:52 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:43672 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108Ab3COJah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:30:37 -0400
From: Erwan Yvin <erwan.yvin@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Rusty Russel <rusty@ruscorp.com.au>,
        Ido Yariv <ido@wizery.com>
Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>
Subject: [PATCH 2/2] remoteproc: Add support for host virtio rings (vringh)
Date: Fri, 15 Mar 2013 10:29:56 +0100
Message-ID: <1363339796-14591-3-git-send-email-erwan.yvin@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1363339796-14591-1-git-send-email-erwan.yvin@stericsson.com>
References: <1363339796-14591-1-git-send-email-erwan.yvin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erwan Yvin <erwan.yvin@stericsson.com>

Implement the vringh callback functions in order
to manage host virtio rings and handle kicks.
This allows virtio device to request host-virtio-rings.

Signed-off-by: Erwan Yvin <erwan.yvin@stericsson.com>
---
 drivers/remoteproc/remoteproc_virtio.c |  115 +++++++++++++++++++++++++++++++-
 include/linux/remoteproc.h             |   22 ++++++
 2 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index ef5ec8a..4ad87c5 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -23,12 +23,15 @@
 #include <linux/virtio_config.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_ring.h>
+#include <linux/vringh.h>
 #include <linux/err.h>
 #include <linux/kref.h>
 #include <linux/slab.h>
 
 #include "remoteproc_internal.h"
 
+static u32 rproc_virtio_get_features(struct virtio_device *vdev);
+
 /* kick the remote processor, and let it know which virtqueue to poke at */
 static void rproc_virtio_notify(struct virtqueue *vq)
 {
@@ -41,6 +44,18 @@ static void rproc_virtio_notify(struct virtqueue *vq)
 	rproc->ops->kick(rproc, notifyid);
 }
 
+/* kick the remote processor, and let it know which vring to poke at */
+static void rproc_virtio_vringh_notify(struct vringh *vrh)
+{
+	struct rproc_vring *rvring = vringh_to_rvring(vrh);
+	struct rproc *rproc = rvring->rvdev->rproc;
+	int notifyid = rvring->notifyid;
+
+	dev_dbg(&rproc->dev, "kicking vq index: %d\n", notifyid);
+
+	rproc->ops->kick(rproc, notifyid);
+}
+
 /**
  * rproc_vq_interrupt() - tell remoteproc that a virtqueue is interrupted
  * @rproc: handle to the remote processor
@@ -60,10 +75,18 @@ irqreturn_t rproc_vq_interrupt(struct rproc *rproc, int notifyid)
 	dev_dbg(&rproc->dev, "vq index %d is interrupted\n", notifyid);
 
 	rvring = idr_find(&rproc->notifyids, notifyid);
-	if (!rvring || !rvring->vq)
+	if (!rvring)
 		return IRQ_NONE;
 
-	return vring_interrupt(0, rvring->vq);
+	if (rvring->rvringh && rvring->rvringh->vringh_cb) {
+		rvring->rvringh->vringh_cb(&rvring->rvdev->vdev,
+						&rvring->rvringh->vrh);
+		return IRQ_HANDLED;
+	} else if (rvring->vq) {
+		return vring_interrupt(0, rvring->vq);
+	} else {
+		return IRQ_NONE;
+	}
 }
 EXPORT_SYMBOL(rproc_vq_interrupt);
 
@@ -103,7 +126,7 @@ static int __rproc_virtio_find_rings(struct virtio_device *vdev,
 	 */
 	for (id = rng = 0; id < nrings && rng < max; ++rng) {
 		rvring = &rvdev->vring[rng];
-		if (rvring->vq)
+		if (rvring->vq || rvring->rvringh)
 			continue;
 
 		/* Allocate and initialize the virtio ring */
@@ -199,6 +222,86 @@ static void rproc_virtio_del_vqs(struct virtio_device *vdev)
 	__rproc_virtio_del_vqs(vdev);
 }
 
+static void __rproc_virtio_del_vrhs(struct virtio_device *vdev)
+{
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	int i, num_of_vrings = ARRAY_SIZE(rvdev->vring);
+
+	for (i = 0; i < num_of_vrings; i++) {
+		struct rproc_vring *rvring = &rvdev->vring[i];
+		if (!rvring->rvringh)
+			continue;
+		kfree(rvring->rvringh);
+		rvring->rvringh = NULL;
+		rproc_free_vring(rvring);
+	}
+}
+
+/* Helper function that creates and initializes the host virtio ring */
+static void *__create_new_vringh(struct rproc_vring *rvring,
+				 unsigned int index,
+				 void *callback,
+				 const char *name)
+{
+	struct rproc_vringh *rvrh = NULL;
+	struct rproc_vdev *rvdev = rvring->rvdev;
+	int err;
+
+	rvrh = kzalloc(sizeof(*rvrh), GFP_KERNEL);
+	err = -ENOMEM;
+	if (!rvrh)
+		goto err;
+
+	/* initialize the host virtio ring */
+	rvrh->rvring = rvring;
+	rvrh->vringh_cb = callback;
+	rvrh->vrh.notify = rproc_virtio_vringh_notify;
+	memset(rvring->va, 0, vring_size(rvring->len, rvring->align));
+	vring_init(&rvrh->vrh.vring, rvring->len, rvring->va, rvring->align);
+
+	/*
+	 * Create the new vring host, and tell we're not interested in
+	 * the 'weak' smp barriers, since we're talking with a real device.
+	 */
+	err = vringh_init_kern(&rvrh->vrh,
+				rproc_virtio_get_features(&rvdev->vdev),
+				rvring->len,
+				false,
+				rvrh->vrh.vring.desc,
+				rvrh->vrh.vring.avail,
+				rvrh->vrh.vring.used);
+	if (err)
+		goto err;
+
+	rvring->rvringh = rvrh;
+	return &rvrh->vrh;
+err:
+	kfree(rvrh);
+	return ERR_PTR(err);
+}
+
+static int rproc_virtio_find_vrhs(struct virtio_device *vdev, unsigned nhvrs,
+			 struct vringh *vrhs[],
+			 vrh_callback_t *callbacks[])
+{
+	void *cbs = callbacks, *rings = vrhs;
+	int err = __rproc_virtio_find_rings(vdev, nhvrs, rings, cbs,
+						NULL, __create_new_vringh);
+	if (err)
+		__rproc_virtio_del_vrhs(vdev);
+	return err;
+}
+
+static void rproc_virtio_del_vrhs(struct virtio_device *vdev)
+{
+	struct rproc *rproc = vdev_to_rproc(vdev);
+
+	/* power down the remote processor before deleting vqs */
+	rproc_shutdown(rproc);
+
+	__rproc_virtio_del_vrhs(vdev);
+}
+
 /*
  * We don't support yet real virtio status semantics.
  *
@@ -258,6 +361,11 @@ static struct virtio_config_ops rproc_virtio_config_ops = {
 	.get_status	= rproc_virtio_get_status,
 };
 
+static struct vringh_config_ops rproc_virtio_vringh_ops = {
+	.find_vrhs	= rproc_virtio_find_vrhs,
+	.del_vrhs	= rproc_virtio_del_vrhs,
+};
+
 /*
  * This function is called whenever vdev is released, and is responsible
  * to decrement the remote processor's refcount which was taken when vdev was
@@ -296,6 +404,7 @@ int rproc_add_virtio_dev(struct rproc_vdev *rvdev, int id)
 
 	vdev->id.device	= id,
 	vdev->config = &rproc_virtio_config_ops,
+	vdev->vringh_config = &rproc_virtio_vringh_ops;
 	vdev->dev.parent = dev;
 	vdev->dev.release = rproc_vdev_release;
 
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index faf3332..9796562 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -39,6 +39,7 @@
 #include <linux/klist.h>
 #include <linux/mutex.h>
 #include <linux/virtio.h>
+#include <linux/vringh.h>
 #include <linux/completion.h>
 #include <linux/idr.h>
 
@@ -435,6 +436,19 @@ struct rproc {
 #define RVDEV_NUM_VRINGS 2
 
 /**
+ * struct rproc_vringh - remoteproc host vring
+ * @vrh: Host side virtio ring
+ * @rvring: Virtio ring associated with the device
+ * @vringh_cb: Callback notifying virtio driver about new buffers
+ */
+struct rproc_vring;
+struct rproc_vringh {
+	struct vringh vrh;
+	struct rproc_vring *rvring;
+	vrh_callback_t *vringh_cb;
+};
+
+/**
  * struct rproc_vring - remoteproc vring state
  * @va:	virtual address
  * @dma: dma address
@@ -444,6 +458,7 @@ struct rproc {
  * @notifyid: rproc-specific unique vring index
  * @rvdev: remote vdev
  * @vq: the virtqueue of this vring
+ * @rvringh: the reversed host-side vring
  */
 struct rproc_vring {
 	void *va;
@@ -454,6 +469,7 @@ struct rproc_vring {
 	int notifyid;
 	struct rproc_vdev *rvdev;
 	struct virtqueue *vq;
+	struct rproc_vringh *rvringh;
 };
 
 /**
@@ -497,4 +513,10 @@ static inline struct rproc *vdev_to_rproc(struct virtio_device *vdev)
 	return rvdev->rproc;
 }
 
+static inline struct rproc_vring *vringh_to_rvring(struct vringh *vrh)
+{
+       struct rproc_vringh *rvrh = container_of(vrh, struct rproc_vringh, vrh);
+       return rvrh->rvring;
+}
+
 #endif /* REMOTEPROC_H */
-- 
1.7.9.2

