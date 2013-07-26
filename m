Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730Ab3GZVls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:41:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab3GZUsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 18/79] virtio: support unlocked queue poll
Date: Fri, 26 Jul 2013 13:47:08 -0700
Message-Id: <20130726204723.835876415@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit cc229884d3f77ec3b1240e467e0236c3e0647c0c ]

This adds a way to check ring empty state after enable_cb outside any
locks. Will be used by virtio_net.

Note: there's room for more optimization: caller is likely to have a
memory barrier already, which means we might be able to get rid of a
barrier here.  Deferring this optimization until we do some
benchmarking.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio_ring.c |   56 +++++++++++++++++++++++++++++++++----------
 include/linux/virtio.h       |    4 +++
 2 files changed, 48 insertions(+), 12 deletions(-)

--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -607,19 +607,21 @@ void virtqueue_disable_cb(struct virtque
 EXPORT_SYMBOL_GPL(virtqueue_disable_cb);
 
 /**
- * virtqueue_enable_cb - restart callbacks after disable_cb.
+ * virtqueue_enable_cb_prepare - restart callbacks after disable_cb
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
 
@@ -629,15 +631,45 @@ bool virtqueue_enable_cb(struct virtqueu
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
 	virtio_mb(vq->weak_barriers);
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
 
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -70,6 +70,10 @@ void virtqueue_disable_cb(struct virtque
 
 bool virtqueue_enable_cb(struct virtqueue *vq);
 
+unsigned virtqueue_enable_cb_prepare(struct virtqueue *vq);
+
+bool virtqueue_poll(struct virtqueue *vq, unsigned);
+
 bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
 
 void *virtqueue_detach_unused_buf(struct virtqueue *vq);


