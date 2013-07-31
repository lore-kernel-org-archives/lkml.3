Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011Ab3GaN0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:26:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47159 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759906Ab3GaN0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "Wolfram Gloger" <wmglo@dent.med.uni-muenchen.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.488553581@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [27/84] virtio: support unlocked queue poll
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
diff -upr linux-3.2.49/drivers/virtio/virtio_ring.c linux-3.2.49wg/drivers/virtio/virtio_ring.c
--- linux-3.2.49/drivers/virtio/virtio_ring.c	2013-07-27 18:13:40.000000000 +0200
+++ linux-3.2.49wg/drivers/virtio/virtio_ring.c	2013-07-27 13:57:28.000000000 +0200
@@ -360,9 +360,22 @@ void virtqueue_disable_cb(struct virtque
 }
 EXPORT_SYMBOL_GPL(virtqueue_disable_cb);
 
-bool virtqueue_enable_cb(struct virtqueue *_vq)
+/**
+ * virtqueue_enable_cb_prepare - restart callbacks after disable_cb
+ * @vq: the struct virtqueue we're talking about.
+ *
+ * This re-enables callbacks; it returns current queue state
+ * in an opaque unsigned value. This value should be later tested by
+ * virtqueue_poll, to detect a possible race between the driver checking for
+ * more work, and enabling callbacks.
+ *
+ * Caller must ensure we don't call this with other virtqueue
+ * operations at the same time (except where noted).
+ */
+unsigned virtqueue_enable_cb_prepare(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
+	u16 last_used_idx;
 
 	START_USE(vq);
 
@@ -372,15 +385,45 @@ bool virtqueue_enable_cb(struct virtqueu
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
 	virtio_mb();
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
 
diff -upr linux-3.2.49/include/linux/virtio.h linux-3.2.49wg/include/linux/virtio.h
--- linux-3.2.49/include/linux/virtio.h	2012-01-05 00:55:44.000000000 +0100
+++ linux-3.2.49wg/include/linux/virtio.h	2013-07-27 13:57:28.000000000 +0200
@@ -96,6 +96,10 @@ void virtqueue_disable_cb(struct virtque
 
 bool virtqueue_enable_cb(struct virtqueue *vq);
 
+unsigned virtqueue_enable_cb_prepare(struct virtqueue *vq);
+
+bool virtqueue_poll(struct virtqueue *vq, unsigned);
+
 bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
 
 void *virtqueue_detach_unused_buf(struct virtqueue *vq);

