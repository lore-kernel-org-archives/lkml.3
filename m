Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3BJLF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 06:05:28 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:47380 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab3BJLFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 06:05:13 -0500
From: sjur.brandeland@stericsson.com
To: Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc: sjur@brendeland.net, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ido Yariv <ido@wizery.com>
Subject: [PATCH vringh 1/2] remoteproc: Add support for vringh (Host vrings)
Date: Sun, 10 Feb 2013 12:04:32 +0100
Message-Id: <1360494273-27889-2-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360494273-27889-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1360494273-27889-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add functions for creating, deleting and kicking host-side virtio rings.

The host ring is not integrated with virtiqueues and cannot be managed
through virtio-config. Remoteproc must export functions for handling the
host-side virtio rings.

The functions rproc_virtio_get_vringh(), rproc_virtio_del_vringh(),
rproc_virtio_kick_vringh() are added to remoteproc_virtio.c. The
existing functions rproc_vq_interrupt() and rproc_virtio_find_vqs()
are updated to handle the new vhost rings.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
cc: Ohad Ben-Cohen <ohad@wizery.com>
cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Ido Yariv <ido@wizery.com>
cc: Erwan Yvin <erwan.yvin@stericsson.com>

---
Hi Ohad,

I would really appreciate if you could find time to
review this patch. It will go via Rusty's vringh tree.

Feedback and review comments are welcomed.

Thanks,
Sjur


 drivers/remoteproc/Kconfig             |    3 +
 drivers/remoteproc/remoteproc_virtio.c |  127 ++++++++++++++++++++++++++++++--
 include/linux/remoteproc.h             |   14 ++++
 3 files changed, 137 insertions(+), 7 deletions(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 96ce101..c7d1d36 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -7,6 +7,9 @@ config REMOTEPROC
 	depends on HAS_DMA
 	select FW_CONFIG
 	select VIRTIO
+	select VHOST_RING
+
+source drivers/vhost/Kconfig
 
 config OMAP_REMOTEPROC
 	tristate "OMAP remoteproc support"
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 9e198e5..fa7bf7b 100644
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
@@ -60,10 +61,15 @@ irqreturn_t rproc_vq_interrupt(struct rproc *rproc, int notifyid)
 	dev_dbg(&rproc->dev, "vq index %d is interrupted\n", notifyid);
 
 	rvring = idr_find(&rproc->notifyids, notifyid);
-	if (!rvring || !rvring->vq)
+	if (!rvring)
 		return IRQ_NONE;
 
-	return vring_interrupt(0, rvring->vq);
+	if (rvring->vringh && rvring->vringh_cb)
+		return rvring->vringh_cb(&rvring->rvdev->vdev, rvring->vringh);
+	else if (rvring->vq)
+		return vring_interrupt(0, rvring->vq);
+	else
+		return IRQ_NONE;
 }
 EXPORT_SYMBOL(rproc_vq_interrupt);
 
@@ -149,14 +155,21 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
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
@@ -173,6 +186,106 @@ error:
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
+	err = rproc_alloc_vring(rvdev, index);
+	if (err)
+		goto free_vring;
+
+
+	rvring = &rvdev->vring[index];
+	/* zero vring */
+	memset(rvring->va, 0, vring_size(rvring->len, rvring->align));
+	vring_init(&vrh->vring, rvring->len, rvring->va, rvring->align);
+
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
+	if (!err)
+		return vrh;
+
+	dev_err(&vdev->dev, "failed to create vhost: %d\n", err);
+	rproc_free_vring(rvring);
+free_vring:
+	kfree(vrh);
+	return NULL;
+}
+EXPORT_SYMBOL(rproc_virtio_new_vringh);
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
+	rproc_free_vring(rvring);
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

