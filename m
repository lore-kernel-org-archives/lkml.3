Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3IKEaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3IKE3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:04 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=yeiAu3vr6aMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=oyYRTeTTBMMA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=z9odyffjMVvEqKmo1QkA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042859.672610416@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [044/251] virtio: support unlocked queue poll
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0044-virtio-support-unlocked-queue-poll.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/virtio/virtio_ring.c |   54 +++++++++++++++++++++++++++++++++---------
 include/linux/virtio.h       |    4 ++++
 2 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5aa43c3..bdac497 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -491,16 +491,18 @@ EXPORT_SYMBOL_GPL(virtqueue_disable_cb);
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
 
@@ -510,15 +512,45 @@ bool virtqueue_enable_cb(struct virtqueue *_vq)
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
index a1ba8bb..765a133 100644
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
1.7.10.4


