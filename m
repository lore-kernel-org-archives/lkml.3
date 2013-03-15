Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab3COJai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:30:38 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:60044 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751965Ab3COJaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:30:35 -0400
From: Erwan Yvin <erwan.yvin@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Rusty Russel <rusty@ruscorp.com.au>,
        Ido Yariv <ido@wizery.com>
Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Erwan YVIN <erwan.yvin@stericsson.com>
Subject: [PATCH 1/2] remoteproc: refactor find_vqs to prepare for vringh
Date: Fri, 15 Mar 2013 10:29:55 +0100
Message-ID: <1363339796-14591-2-git-send-email-erwan.yvin@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1363339796-14591-1-git-send-email-erwan.yvin@stericsson.com>
References: <1363339796-14591-1-git-send-email-erwan.yvin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erwan YVIN <erwan.yvin@stericsson.com>

Refactor code for creating virtio queues and prepare
for accommodating the new host virtio rings.

This refactoring moves all handing of struct virtqueue
to a separate function __create_new_virtqueue().
A more generic function __rproc_virtio_find_rings()
allocates the virtio rings and ring IDs and calls the
virtqueue specific function when a virtio ring and the
ring IDs are allocated. Some type safety is sacrificed,
in order to make the code more generic.

Signed-off-by: Erwan Yvin <erwan.yvin@stericsson.com>
---
 drivers/remoteproc/remoteproc_virtio.c |  138 +++++++++++++++++++-------------
 1 file changed, 82 insertions(+), 56 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 9e198e5..ef5ec8a 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -67,50 +67,93 @@ irqreturn_t rproc_vq_interrupt(struct rproc *rproc, int notifyid)
 }
 EXPORT_SYMBOL(rproc_vq_interrupt);
 
-static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
-				    unsigned id,
-				    void (*callback)(struct virtqueue *vq),
-				    const char *name)
+/*
+ * Allocate and intitialize the virtio rings. We downcast some types here
+ * in order to have common code between virtqueue and vringh.
+ */
+static int __rproc_virtio_find_rings(struct virtio_device *vdev,
+					unsigned nrings, void *rings[],
+					void *callbacks[], const char *name[],
+					void *create(struct rproc_vring *rvring,
+							unsigned int index,
+							void *callbacks,
+							const char *name))
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 	struct rproc *rproc = vdev_to_rproc(vdev);
 	struct device *dev = &rproc->dev;
 	struct rproc_vring *rvring;
-	struct virtqueue *vq;
-	void *addr;
-	int len, size, ret;
+	/* Use resource entry fw_rsc_vdev.num_of_rings instead when available */
+	size_t max = ARRAY_SIZE(rvdev->vring);
+	const char *rng_name;
+	int rng, id, err;
 
 	/* we're temporarily limited to two virtqueues per rvdev */
-	if (id >= ARRAY_SIZE(rvdev->vring))
-		return ERR_PTR(-EINVAL);
+	if (nrings > max)
+		return -EINVAL;
 
-	if (!name)
-		return NULL;
+	/*
+	 * We have two different arrays here:
+	 * rvdev->vring[] holds the virtio rings in shared memory as
+	 * specified by the resource table. It uses "rng" as index.
+	 *
+	 * The parameter rings[] is used for passing the requested
+	 * virtio rings back to the caller. nrings is used by the
+	 * caller to specify the number of rings to return.
+	 */
+	for (id = rng = 0; id < nrings && rng < max; ++rng) {
+		rvring = &rvdev->vring[rng];
+		if (rvring->vq)
+			continue;
+
+		/* Allocate and initialize the virtio ring */
+		err = rproc_alloc_vring(rvdev, rng);
+		if (err)
+			return err;
+
+		memset(rvring->va, 0, vring_size(rvring->len, rvring->align));
+		rng_name = name ? name[id] : NULL;
+		rings[id] = create(rvring, id, callbacks[id], rng_name);
+		if (IS_ERR(rings[id])) {
+			rproc_free_vring(rvring);
+			return PTR_ERR(rings[id]);
+		}
 
-	ret = rproc_alloc_vring(rvdev, id);
-	if (ret)
-		return ERR_PTR(ret);
+		dev_dbg(dev, "vring%d: va %p qsz %d notifyid %d\n",
+			rng, rvring->va, rvring->len, rvring->notifyid);
+		++id;
+	}
 
-	rvring = &rvdev->vring[id];
-	addr = rvring->va;
-	len = rvring->len;
+	if (id < nrings) {
+		dev_err(dev, "couldn't find the requested rings: %d\n", nrings);
+		return -ENOBUFS;
+	}
 
-	/* zero vring */
-	size = vring_size(len, rvring->align);
-	memset(addr, 0, size);
+	/* now that the rings are all set, boot the remote processor */
+	return rproc_boot(rproc);
+}
 
-	dev_dbg(dev, "vring%d: va %p qsz %d notifyid %d\n",
-					id, addr, len, rvring->notifyid);
+/* Helper function that creates and initializes the virtqueue */
+static void *__create_new_virtqueue(struct rproc_vring *rvring,
+					unsigned int id,
+					void *callback,
+					const char *name)
+{
+	struct virtio_device *vdev = &rvring->rvdev->vdev;
+	struct virtqueue *vq;
+
+	if (!name)
+		return ERR_PTR(-EINVAL);
 
 	/*
 	 * Create the new vq, and tell virtio we're not interested in
 	 * the 'weak' smp barriers, since we're talking with a real device.
 	 */
-	vq = vring_new_virtqueue(id, len, rvring->align, vdev, false, addr,
-					rproc_virtio_notify, callback, name);
+	vq = vring_new_virtqueue(id, rvring->len, rvring->align, vdev, false,
+				 rvring->va, rproc_virtio_notify, callback,
+				 name);
 	if (!vq) {
-		dev_err(dev, "vring_new_virtqueue %s failed\n", name);
-		rproc_free_vring(rvring);
+		dev_err(&vdev->dev, "vring_new_virtqueue %s failed\n", name);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -133,44 +176,27 @@ static void __rproc_virtio_del_vqs(struct virtio_device *vdev)
 	}
 }
 
-static void rproc_virtio_del_vqs(struct virtio_device *vdev)
+static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
+					struct virtqueue *vqs[],
+					vq_callback_t *callbacks[],
+					const char *names[])
 {
-	struct rproc *rproc = vdev_to_rproc(vdev);
-
-	/* power down the remote processor before deleting vqs */
-	rproc_shutdown(rproc);
-
-	__rproc_virtio_del_vqs(vdev);
+	void *cbs = callbacks, *rings = vqs;
+	int err = __rproc_virtio_find_rings(vdev, nvqs, rings, cbs,
+						names, __create_new_virtqueue);
+	if (err)
+		__rproc_virtio_del_vqs(vdev);
+	return err;
 }
 
-static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
-		       struct virtqueue *vqs[],
-		       vq_callback_t *callbacks[],
-		       const char *names[])
+static void rproc_virtio_del_vqs(struct virtio_device *vdev)
 {
 	struct rproc *rproc = vdev_to_rproc(vdev);
-	int i, ret;
 
-	for (i = 0; i < nvqs; ++i) {
-		vqs[i] = rp_find_vq(vdev, i, callbacks[i], names[i]);
-		if (IS_ERR(vqs[i])) {
-			ret = PTR_ERR(vqs[i]);
-			goto error;
-		}
-	}
-
-	/* now that the vqs are all set, boot the remote processor */
-	ret = rproc_boot(rproc);
-	if (ret) {
-		dev_err(&rproc->dev, "rproc_boot() failed %d\n", ret);
-		goto error;
-	}
-
-	return 0;
+	/* power down the remote processor before deleting vqs */
+	rproc_shutdown(rproc);
 
-error:
 	__rproc_virtio_del_vqs(vdev);
-	return ret;
 }
 
 /*
-- 
1.7.9.2

