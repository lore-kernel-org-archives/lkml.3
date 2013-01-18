Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3AROUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:20:30 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:46607 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3AROU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:20:29 -0500
From: sjur.brandeland@stericsson.com
To: Rusty Russell <rusty@rustcorp.com.au>, Ido Yariv <ido@wizery.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Linus Walleij <linus.walleij@linaro.org>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: =?UTF8?q?=5BRFC=5D=20remoteproc=3A=20Add=20support=20for=20host-side=20=28reversed=29=20vrings?=
Date: Fri, 18 Jan 2013 15:20:09 +0100
Message-Id: <1358518809-12682-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Hi Ohad, Ido and Rusty.

Rusty has implemented host-side virtio ring. I will be using vringh
for the caif_virtio driver. But we need to figure out how to
integrate the vringh into remoteproc. Below is my initial stab on this.

This code is completely untested, but I'd love to get some initial
feedback on this.

Ohad/Ido are you happy with this approach?

More code will follow after some test and debugging...

Regards,
Sjur

--
remoteproc: Add support for host-side (reversed) vrings

Add functions for creating, deleting and kicking host-side virtio rings.

The host ring is not integrated with virtiqueues and cannot be managed
through virtio-config. So the virtio drivers must call functions exported
from remoteproc for handling the host-side virtio rings.

The functions rproc_virtio_get_vringh(), rproc_virtio_del_vringh(),
rproc_virtio_kick_vringh() are added to remoteproc_virtio.c. The
existing functions rproc_vq_interrupt() and rproc_virtio_find_vqs()
are updated to handle the new vhost rings.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_virtio.c |  116 ++++++++++++++++++++++++++++++--
 include/linux/remoteproc.h             |   14 ++++
 2 files changed, 124 insertions(+), 6 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 9e198e5..1928433 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -23,6 +23,7 @@
 #include <linux/virtio_config.h>
 #include <linux/virtio_ids.h>
 #include <linux/virtio_ring.h>
+#include <linux/vringh.h>
 #include <linux/err.h>
 #include <linux/kref.h>
 #include <linux/slab.h>
@@ -63,7 +64,10 @@ irqreturn_t rproc_vq_interrupt(struct rproc *rproc, int notifyid)
 	if (!rvring || !rvring->vq)
 		return IRQ_NONE;
 
-	return vring_interrupt(0, rvring->vq);
+	if (rvring->vringh && rvring->vringh_cb)
+		return rvring->vringh_cb(&rvring->rvdev->vdev, rvring->vringh);
+	else
+		return vring_interrupt(0, rvring->vq);
 }
 EXPORT_SYMBOL(rproc_vq_interrupt);
 
@@ -149,14 +153,21 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		       const char *names[])
 {
 	struct rproc *rproc = vdev_to_rproc(vdev);
-	int i, ret;
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	int rng, id, ret, nrings = ARRAY_SIZE(rvdev->vring);
+
+	for (id = 0, rng = 0; rng < nrings; ++rng) {
+		struct rproc_vring *rvring = &rvdev->vring[rng];
+		/* Skip the host side rings */
+		if (rvring->vringh)
+			continue;
 
-	for (i = 0; i < nvqs; ++i) {
-		vqs[i] = rp_find_vq(vdev, i, callbacks[i], names[i]);
-		if (IS_ERR(vqs[i])) {
-			ret = PTR_ERR(vqs[i]);
+		vqs[id] = rp_find_vq(vdev, rng, callbacks[id], names[id]);
+		if (IS_ERR(vqs[id])) {
+			ret = PTR_ERR(vqs[id]);
 			goto error;
 		}
+		++id;
 	}
 
 	/* now that the vqs are all set, boot the remote processor */
@@ -173,6 +184,99 @@ error:
 	return ret;
 }
 
+/**
+ * rproc_virtio_new_vringh() - create a reversed virtio ring.
+ * @vdev: the virtio device
+ * @index: the virtio ring index
+ * @cb: callback for the reversed virtio ring
+ *
+ * This function should be called by the virtio-driver
+ * before calling find_vqs(). It returns a struct vringh for
+ * accessing the virtio ring.
+ *
+ * Return: struct vhost, or NULL upon error.
+ */
+struct vringh *
+rproc_virtio_new_vringh(struct virtio_device *vdev, unsigned index,
+			irqreturn_t (*cb)(struct virtio_device *vdev,
+					  struct vringh *vring))
+{
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	struct rproc_vring *rvring;
+	struct vringh *vrh;
+	int err;
+
+	if (index > ARRAY_SIZE(rvdev->vring)) {
+		dev_err(&rvdev->vdev.dev, "bad vring index: %d\n", index);
+		return NULL;
+	}
+
+	vrh = kzalloc(sizeof(*vrh), GFP_KERNEL);
+	if (!vrh)
+		return NULL;
+
+
+	rvring = &rvdev->vring[index];
+	vring_init(&vrh->vring, rvring->len, rvring->va, rvring->align);
+	/* zero vring */
+	memset(&vrh->vring, 0, vring_size(rvring->len, rvring->align));
+	rvring->vringh_cb = cb;
+	rvring->vringh = vrh;
+
+	err = vringh_init_kern(vrh,
+			       rvdev->dfeatures,
+			       rvring->len,
+			       false,
+			       vrh->vring.desc,
+			       vrh->vring.avail,
+			       vrh->vring.used);
+	if (err) {
+		dev_err(&vdev->dev, "failed to create vhost: %d\n", err);
+		kfree(vrh);
+		vrh = NULL;
+	}
+
+	return vrh;
+}
+EXPORT_SYMBOL(rproc_virtio_get_vringh);
+
+/**
+ * rproc_virtio_del_vringh() - release a reversed virtio ring.
+ * @vdev: the virtio device
+ * @index: the virtio ring index
+ *
+ * This function release the reversed virtio ring.
+ */
+void rproc_virtio_del_vringh(struct virtio_device *vdev, unsigned index)
+{
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	struct rproc_vring *rvring = &rvdev->vring[index];
+	kfree(rvring->vringh);
+	rvring->vringh_cb = NULL;
+	rvring->vringh = NULL;
+}
+EXPORT_SYMBOL(rproc_virtio_del_vringh);
+
+/**
+ * rproc_virtio_kick_vringh() - kick the remote processor.
+ * @vdev: the virtio device
+ * @index: the virtio ring index
+ *
+ * kick the remote processor, and let it know which vring to poke at
+ */
+void rproc_virtio_kick_vringh(struct virtio_device *vdev, unsigned index)
+{
+	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
+	struct rproc_vring *rvring = &rvdev->vring[index];
+	struct rproc *rproc = rvring->rvdev->rproc;
+	int notifyid = rvring->notifyid;
+
+	dev_dbg(&rproc->dev, "kicking vq index: %d\n", notifyid);
+
+	rproc->ops->kick(rproc, notifyid);
+}
+EXPORT_SYMBOL(rproc_virtio_kick_vringh);
+
 /*
  * We don't support yet real virtio status semantics.
  *
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index faf3332..414a1fd 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -39,7 +39,9 @@
 #include <linux/klist.h>
 #include <linux/mutex.h>
 #include <linux/virtio.h>
+#include <linux/vringh.h>
 #include <linux/completion.h>
+#include <linux/interrupt.h>
 #include <linux/idr.h>
 
 /**
@@ -444,6 +446,8 @@ struct rproc {
  * @notifyid: rproc-specific unique vring index
  * @rvdev: remote vdev
  * @vq: the virtqueue of this vring
+ * @vringh_cb: callback used when device has kicked
+ * @vringh: the reversed host-side vring
  */
 struct rproc_vring {
 	void *va;
@@ -454,6 +458,9 @@ struct rproc_vring {
 	int notifyid;
 	struct rproc_vdev *rvdev;
 	struct virtqueue *vq;
+	irqreturn_t (*vringh_cb)(struct virtio_device *vdev,
+				 struct vringh *vring);
+	struct vringh *vringh;
 };
 
 /**
@@ -485,6 +492,13 @@ int rproc_boot(struct rproc *rproc);
 void rproc_shutdown(struct rproc *rproc);
 void rproc_report_crash(struct rproc *rproc, enum rproc_crash_type type);
 
+struct vringh *
+rproc_virtio_new_vringh(struct virtio_device *vdev, unsigned index,
+			irqreturn_t (*cb)(struct virtio_device *vdev,
+					  struct vringh *vring));
+void rproc_virtio_del_vringh(struct virtio_device *vdev, unsigned index);
+void rproc_virtio_kick_vringh(struct virtio_device *vdev, unsigned index);
+
 static inline struct rproc_vdev *vdev_to_rvdev(struct virtio_device *vdev)
 {
 	return container_of(vdev, struct rproc_vdev, vdev);
-- 
1.7.5.4

