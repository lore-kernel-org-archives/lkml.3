Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab3BSIKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:10:10 -0500
Received: from ozlabs.org ([203.10.76.45]:52148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130Ab3BSICo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Cc: sjur.brandeland@stericsson.com, mst@redhat.com,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/5] virtio_ring: expose virtio barriers for use in vringh.
Date: Tue, 19 Feb 2013 08:59:28 +1030
Message-Id: <1361226573-12481-2-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361226573-12481-1-git-send-email-rusty@rustcorp.com.au>
References: <1361226573-12481-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host side of ring needs this logic too.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_ring.c |   33 +++++-------------------
 include/linux/virtio_ring.h  |   57 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 27 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index ffd7e7d..245177c 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -24,27 +24,6 @@
 #include <linux/module.h>
 #include <linux/hrtimer.h>
 
-/* virtio guest is communicating with a virtual "device" that actually runs on
- * a host processor.  Memory barriers are used to control SMP effects. */
-#ifdef CONFIG_SMP
-/* Where possible, use SMP barriers which are more lightweight than mandatory
- * barriers, because mandatory barriers control MMIO effects on accesses
- * through relaxed memory I/O windows (which virtio-pci does not use). */
-#define virtio_mb(vq) \
-	do { if ((vq)->weak_barriers) smp_mb(); else mb(); } while(0)
-#define virtio_rmb(vq) \
-	do { if ((vq)->weak_barriers) smp_rmb(); else rmb(); } while(0)
-#define virtio_wmb(vq) \
-	do { if ((vq)->weak_barriers) smp_wmb(); else wmb(); } while(0)
-#else
-/* We must force memory ordering even if guest is UP since host could be
- * running on another CPU, but SMP barriers are defined to barrier() in that
- * configuration. So fall back to mandatory barriers instead. */
-#define virtio_mb(vq) mb()
-#define virtio_rmb(vq) rmb()
-#define virtio_wmb(vq) wmb()
-#endif
-
 #ifdef DEBUG
 /* For development, we want to crash whenever the ring is screwed. */
 #define BAD_RING(_vq, fmt, args...)				\
@@ -276,7 +255,7 @@ add_head:
 
 	/* Descriptors and available array need to be set before we expose the
 	 * new available array entries. */
-	virtio_wmb(vq);
+	virtio_wmb(vq->weak_barriers);
 	vq->vring.avail->idx++;
 	vq->num_added++;
 
@@ -312,7 +291,7 @@ bool virtqueue_kick_prepare(struct virtqueue *_vq)
 	START_USE(vq);
 	/* We need to expose available array entries before checking avail
 	 * event. */
-	virtio_mb(vq);
+	virtio_mb(vq->weak_barriers);
 
 	old = vq->vring.avail->idx - vq->num_added;
 	new = vq->vring.avail->idx;
@@ -436,7 +415,7 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 	}
 
 	/* Only get used array entries after they have been exposed by host. */
-	virtio_rmb(vq);
+	virtio_rmb(vq->weak_barriers);
 
 	last_used = (vq->last_used_idx & (vq->vring.num - 1));
 	i = vq->vring.used->ring[last_used].id;
@@ -460,7 +439,7 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 	 * the read in the next get_buf call. */
 	if (!(vq->vring.avail->flags & VRING_AVAIL_F_NO_INTERRUPT)) {
 		vring_used_event(&vq->vring) = vq->last_used_idx;
-		virtio_mb(vq);
+		virtio_mb(vq->weak_barriers);
 	}
 
 #ifdef DEBUG
@@ -513,7 +492,7 @@ bool virtqueue_enable_cb(struct virtqueue *_vq)
 	 * entry. Always do both to keep code simple. */
 	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
 	vring_used_event(&vq->vring) = vq->last_used_idx;
-	virtio_mb(vq);
+	virtio_mb(vq->weak_barriers);
 	if (unlikely(more_used(vq))) {
 		END_USE(vq);
 		return false;
@@ -553,7 +532,7 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
 	/* TODO: tune this threshold */
 	bufs = (u16)(vq->vring.avail->idx - vq->last_used_idx) * 3 / 4;
 	vring_used_event(&vq->vring) = vq->last_used_idx + bufs;
-	virtio_mb(vq);
+	virtio_mb(vq->weak_barriers);
 	if (unlikely((u16)(vq->vring.used->idx - vq->last_used_idx) > bufs)) {
 		END_USE(vq);
 		return false;
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 63c6ea1..ca3ad41 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -4,6 +4,63 @@
 #include <linux/irqreturn.h>
 #include <uapi/linux/virtio_ring.h>
 
+/*
+ * Barriers in virtio are tricky.  Non-SMP virtio guests can't assume
+ * they're not on an SMP host system, so they need to assume real
+ * barriers.  Non-SMP virtio hosts could skip the barriers, but does
+ * anyone care?
+ *
+ * For virtio_pci on SMP, we don't need to order with respect to MMIO
+ * accesses through relaxed memory I/O windows, so smp_mb() et al are
+ * sufficient.
+ *
+ * For using virtio to talk to real devices (eg. other heterogeneous
+ * CPUs) we do need real barriers.  In theory, we could be using both
+ * kinds of virtio, so it's a runtime decision, and the branch is
+ * actually quite cheap.
+ */
+
+#ifdef CONFIG_SMP
+static inline void virtio_mb(bool weak_barriers)
+{
+	if (weak_barriers)
+		smp_mb();
+	else
+		mb();
+}
+
+static inline void virtio_rmb(bool weak_barriers)
+{
+	if (weak_barriers)
+		smp_rmb();
+	else
+		rmb();
+}
+
+static inline void virtio_wmb(bool weak_barriers)
+{
+	if (weak_barriers)
+		smp_wmb();
+	else
+		wmb();
+}
+#else
+static inline void virtio_mb(bool weak_barriers)
+{
+	mb();
+}
+
+static inline void virtio_rmb(bool weak_barriers)
+{
+	rmb();
+}
+
+static inline void virtio_wmb(bool weak_barriers)
+{
+	wmb();
+}
+#endif
+
 struct virtio_device;
 struct virtqueue;
 
-- 
1.7.10.4

