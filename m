Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab3HNK55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:57:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34453 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab3HNKhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Gloger <wmglo@dent.med.uni-muenchen.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 15/75] virtio: support unlocked queue poll
Date: Wed, 14 Aug 2013 11:36:04 +0100
Message-Id: <1376476624-10011-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit cc229884d3f77ec3b1240e467e0236c3e0647c0c upstream.

This adds a way to check ring empty state after enable_cb outside any
locks. Will be used by virtio_net.

Note: there's room for more optimization: caller is likely to have a
memory barrier already, which means we might be able to get rid of a
barrier here.  Deferring this optimization until we do some
benchmarking.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[wg: Backported to 3.2]
Signed-off-by: Wolfram Gloger <wmglo@dent.med.uni-muenchen.de>
[bwh: Backported to 3.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Luis Henriques<luis.henriques@canonical.com>
---
 drivers/virtio/virtio_ring.c | 54 +++++++++++++++++++++++++++++++++++---------
 include/linux/virtio.h       |  4 ++++
 2 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 52bfd07..c212de7 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -498,16 +498,18 @@ EXPORT_SYMBOL_GPL(virtqueue_disable_cb);
  * virtqueue_enable_cb - restart callbacks after disable_cb.
  * @vq: the struct virtqueue we're talking about.
  *
- * This re-enables callbacks; it returns "false" if there are pending
- * buffers in the queue, to detect a possible race between the driver
- * checking for more work, and enabling callbacks.
+ * This re-enables callbacks; it returns current queue state
+ * in an opaque unsigned value. This value should be later tested by
+ * virtqueue_poll, to detect a possible race between the driver checking for
+ * more work, and enabling callbacks.
  *
  * Caller must ensure we don't call this with other virtqueue
  * operations at the same time (except where noted).
  */
-bool virtqueue_enable_cb(struct virtqueue *_vq)
+unsigned virtqueue_enable_cb_prepare(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
+	u16 last_used_idx;
 
 	START_USE(vq);
 
@@ -517,15 +519,45 @@ bool virtqueue_enable_cb(struct virtqueue *_vq)
 	 * either clear the flags bit or point the event index at the next
 	 * entry. Always do both to keep code simple. */
 	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
-	vring_used_event(&vq->vring) = vq->last_used_idx;
+	vring_used_event(&vq->vring) = last_used_idx = vq->last_used_idx;
+	END_USE(vq);
+	return last_used_idx;
+}
+EXPORT_SYMBOL_GPL(virtqueue_enable_cb_prepare);
+
+/**
+ * virtqueue_poll - query pending used buffers
+ * @vq: the struct virtqueue we're talking about.
+ * @last_used_idx: virtqueue state (from call to virtqueue_enable_cb_prepare).
+ *
+ * Returns "true" if there are pending used buffers in the queue.
+ *
+ * This does not need to be serialized.
+ */
+bool virtqueue_poll(struct virtqueue *_vq, unsigned last_used_idx)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
 	virtio_mb(vq);
-	if (unlikely(more_used(vq))) {
-		END_USE(vq);
-		return false;
-	}
+	return (u16)last_used_idx != vq->vring.used->idx;
+}
+EXPORT_SYMBOL_GPL(virtqueue_poll);
 
-	END_USE(vq);
-	return true;
+/**
+ * virtqueue_enable_cb - restart callbacks after disable_cb.
+ * @vq: the struct virtqueue we're talking about.
+ *
+ * This re-enables callbacks; it returns "false" if there are pending
+ * buffers in the queue, to detect a possible race between the driver
+ * checking for more work, and enabling callbacks.
+ *
+ * Caller must ensure we don't call this with other virtqueue
+ * operations at the same time (except where noted).
+ */
+bool virtqueue_enable_cb(struct virtqueue *_vq)
+{
+	unsigned last_used_idx = virtqueue_enable_cb_prepare(_vq);
+	return !virtqueue_poll(_vq, last_used_idx);
 }
 EXPORT_SYMBOL_GPL(virtqueue_enable_cb);
 
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 8efd28a..2b779bf 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -44,6 +44,10 @@ void virtqueue_disable_cb(struct virtqueue *vq);
 
 bool virtqueue_enable_cb(struct virtqueue *vq);
 
+unsigned virtqueue_enable_cb_prepare(struct virtqueue *vq);
+
+bool virtqueue_poll(struct virtqueue *vq, unsigned);
+
 bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
 
 void *virtqueue_detach_unused_buf(struct virtqueue *vq);
-- 
1.8.3.2

