Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaJWQUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:20:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbaJWQUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:20:39 -0400
Date: Thu, 23 Oct 2014 19:24:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RFC v4 02/17] virtio_ring: switch to new memory access APIs
Message-ID: <1414081380-14623-3-git-send-email-mst@redhat.com>
References: <1414081380-14623-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414081380-14623-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use virtioXX_to_cpu and friends for access to
all multibyte structures in memory.

Note: this is intentionally mechanical.
A follow-up patch will split long lines etc.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_ring.c | 89 ++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 44 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 3b1f89b..048e1bc 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -99,7 +99,8 @@ struct vring_virtqueue
 
 #define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)
 
-static struct vring_desc *alloc_indirect(unsigned int total_sg, gfp_t gfp)
+static struct vring_desc *alloc_indirect(struct virtqueue *_vq,
+					 unsigned int total_sg, gfp_t gfp)
 {
 	struct vring_desc *desc;
 	unsigned int i;
@@ -116,7 +117,7 @@ static struct vring_desc *alloc_indirect(unsigned int total_sg, gfp_t gfp)
 		return NULL;
 
 	for (i = 0; i < total_sg; i++)
-		desc[i].next = i+1;
+		desc[i].next = cpu_to_virtio16(_vq->vdev, i + 1);
 	return desc;
 }
 
@@ -165,17 +166,17 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 	/* If the host supports indirect descriptor tables, and we have multiple
 	 * buffers, then go indirect. FIXME: tune this threshold */
 	if (vq->indirect && total_sg > 1 && vq->vq.num_free)
-		desc = alloc_indirect(total_sg, gfp);
+		desc = alloc_indirect(_vq, total_sg, gfp);
 	else
 		desc = NULL;
 
 	if (desc) {
 		/* Use a single buffer which doesn't continue */
-		vq->vring.desc[head].flags = VRING_DESC_F_INDIRECT;
-		vq->vring.desc[head].addr = virt_to_phys(desc);
+		vq->vring.desc[head].flags = cpu_to_virtio16(_vq->vdev, VRING_DESC_F_INDIRECT);
+		vq->vring.desc[head].addr = cpu_to_virtio64(_vq->vdev, virt_to_phys(desc));
 		/* avoid kmemleak false positive (hidden by virt_to_phys) */
 		kmemleak_ignore(desc);
-		vq->vring.desc[head].len = total_sg * sizeof(struct vring_desc);
+		vq->vring.desc[head].len = cpu_to_virtio32(_vq->vdev, total_sg * sizeof(struct vring_desc));
 
 		/* Set up rest to use this indirect table. */
 		i = 0;
@@ -205,28 +206,28 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 
 	for (n = 0; n < out_sgs; n++) {
 		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
-			desc[i].flags = VRING_DESC_F_NEXT;
-			desc[i].addr = sg_phys(sg);
-			desc[i].len = sg->length;
+			desc[i].flags = cpu_to_virtio16(_vq->vdev, VRING_DESC_F_NEXT);
+			desc[i].addr = cpu_to_virtio64(_vq->vdev, sg_phys(sg));
+			desc[i].len = cpu_to_virtio32(_vq->vdev, sg->length);
 			prev = i;
-			i = desc[i].next;
+			i = virtio16_to_cpu(_vq->vdev, desc[i].next);
 		}
 	}
 	for (; n < (out_sgs + in_sgs); n++) {
 		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
-			desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
-			desc[i].addr = sg_phys(sg);
-			desc[i].len = sg->length;
+			desc[i].flags = cpu_to_virtio16(_vq->vdev, VRING_DESC_F_NEXT | VRING_DESC_F_WRITE);
+			desc[i].addr = cpu_to_virtio64(_vq->vdev, sg_phys(sg));
+			desc[i].len = cpu_to_virtio32(_vq->vdev, sg->length);
 			prev = i;
-			i = desc[i].next;
+			i = virtio16_to_cpu(_vq->vdev, desc[i].next);
 		}
 	}
 	/* Last one doesn't continue. */
-	desc[prev].flags &= ~VRING_DESC_F_NEXT;
+	desc[prev].flags &= cpu_to_virtio16(_vq->vdev, ~VRING_DESC_F_NEXT);
 
 	/* Update free pointer */
 	if (indirect)
-		vq->free_head = vq->vring.desc[head].next;
+		vq->free_head = virtio16_to_cpu(_vq->vdev, vq->vring.desc[head].next);
 	else
 		vq->free_head = i;
 
@@ -235,13 +236,13 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 
 	/* Put entry in available array (but don't update avail->idx until they
 	 * do sync). */
-	avail = (vq->vring.avail->idx & (vq->vring.num-1));
-	vq->vring.avail->ring[avail] = head;
+	avail = virtio16_to_cpu(_vq->vdev, vq->vring.avail->idx) & (vq->vring.num - 1);
+	vq->vring.avail->ring[avail] = cpu_to_virtio16(_vq->vdev, head);
 
 	/* Descriptors and available array need to be set before we expose the
 	 * new available array entries. */
 	virtio_wmb(vq->weak_barriers);
-	vq->vring.avail->idx++;
+	vq->vring.avail->idx = cpu_to_virtio16(_vq->vdev, virtio16_to_cpu(_vq->vdev, vq->vring.avail->idx) + 1);
 	vq->num_added++;
 
 	/* This is very unlikely, but theoretically possible.  Kick
@@ -354,8 +355,8 @@ bool virtqueue_kick_prepare(struct virtqueue *_vq)
 	 * event. */
 	virtio_mb(vq->weak_barriers);
 
-	old = vq->vring.avail->idx - vq->num_added;
-	new = vq->vring.avail->idx;
+	old = virtio16_to_cpu(_vq->vdev, vq->vring.avail->idx) - vq->num_added;
+	new = virtio16_to_cpu(_vq->vdev, vq->vring.avail->idx);
 	vq->num_added = 0;
 
 #ifdef DEBUG
@@ -367,10 +368,10 @@ bool virtqueue_kick_prepare(struct virtqueue *_vq)
 #endif
 
 	if (vq->event) {
-		needs_kick = vring_need_event(vring_avail_event(&vq->vring),
+		needs_kick = vring_need_event(virtio16_to_cpu(_vq->vdev, vring_avail_event(&vq->vring)),
 					      new, old);
 	} else {
-		needs_kick = !(vq->vring.used->flags & VRING_USED_F_NO_NOTIFY);
+		needs_kick = !(vq->vring.used->flags & cpu_to_virtio16(_vq->vdev, VRING_USED_F_NO_NOTIFY));
 	}
 	END_USE(vq);
 	return needs_kick;
@@ -432,15 +433,15 @@ static void detach_buf(struct vring_virtqueue *vq, unsigned int head)
 	i = head;
 
 	/* Free the indirect table */
-	if (vq->vring.desc[i].flags & VRING_DESC_F_INDIRECT)
-		kfree(phys_to_virt(vq->vring.desc[i].addr));
+	if (vq->vring.desc[i].flags & cpu_to_virtio16(vq->vq.vdev, VRING_DESC_F_INDIRECT))
+		kfree(phys_to_virt(virtio64_to_cpu(vq->vq.vdev, vq->vring.desc[i].addr)));
 
-	while (vq->vring.desc[i].flags & VRING_DESC_F_NEXT) {
-		i = vq->vring.desc[i].next;
+	while (vq->vring.desc[i].flags & cpu_to_virtio16(vq->vq.vdev, VRING_DESC_F_NEXT)) {
+		i = virtio16_to_cpu(vq->vq.vdev, vq->vring.desc[i].next);
 		vq->vq.num_free++;
 	}
 
-	vq->vring.desc[i].next = vq->free_head;
+	vq->vring.desc[i].next = cpu_to_virtio16(vq->vq.vdev, vq->free_head);
 	vq->free_head = head;
 	/* Plus final descriptor */
 	vq->vq.num_free++;
@@ -448,7 +449,7 @@ static void detach_buf(struct vring_virtqueue *vq, unsigned int head)
 
 static inline bool more_used(const struct vring_virtqueue *vq)
 {
-	return vq->last_used_idx != vq->vring.used->idx;
+	return vq->last_used_idx != virtio16_to_cpu(vq->vq.vdev, vq->vring.used->idx);
 }
 
 /**
@@ -491,8 +492,8 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 	virtio_rmb(vq->weak_barriers);
 
 	last_used = (vq->last_used_idx & (vq->vring.num - 1));
-	i = vq->vring.used->ring[last_used].id;
-	*len = vq->vring.used->ring[last_used].len;
+	i = virtio32_to_cpu(_vq->vdev, vq->vring.used->ring[last_used].id);
+	*len = virtio32_to_cpu(_vq->vdev, vq->vring.used->ring[last_used].len);
 
 	if (unlikely(i >= vq->vring.num)) {
 		BAD_RING(vq, "id %u out of range\n", i);
@@ -510,8 +511,8 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
 	/* If we expect an interrupt for the next entry, tell host
 	 * by writing event index and flush out the write before
 	 * the read in the next get_buf call. */
-	if (!(vq->vring.avail->flags & VRING_AVAIL_F_NO_INTERRUPT)) {
-		vring_used_event(&vq->vring) = vq->last_used_idx;
+	if (!(vq->vring.avail->flags & cpu_to_virtio16(_vq->vdev, VRING_AVAIL_F_NO_INTERRUPT))) {
+		vring_used_event(&vq->vring) = cpu_to_virtio16(_vq->vdev, vq->last_used_idx);
 		virtio_mb(vq->weak_barriers);
 	}
 
@@ -537,7 +538,7 @@ void virtqueue_disable_cb(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	vq->vring.avail->flags |= VRING_AVAIL_F_NO_INTERRUPT;
+	vq->vring.avail->flags |= cpu_to_virtio16(_vq->vdev, VRING_AVAIL_F_NO_INTERRUPT);
 }
 EXPORT_SYMBOL_GPL(virtqueue_disable_cb);
 
@@ -565,8 +566,8 @@ unsigned virtqueue_enable_cb_prepare(struct virtqueue *_vq)
 	/* Depending on the VIRTIO_RING_F_EVENT_IDX feature, we need to
 	 * either clear the flags bit or point the event index at the next
 	 * entry. Always do both to keep code simple. */
-	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
-	vring_used_event(&vq->vring) = last_used_idx = vq->last_used_idx;
+	vq->vring.avail->flags &= cpu_to_virtio16(_vq->vdev, ~VRING_AVAIL_F_NO_INTERRUPT);
+	vring_used_event(&vq->vring) = cpu_to_virtio16(_vq->vdev, last_used_idx = vq->last_used_idx);
 	END_USE(vq);
 	return last_used_idx;
 }
@@ -586,7 +587,7 @@ bool virtqueue_poll(struct virtqueue *_vq, unsigned last_used_idx)
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
 	virtio_mb(vq->weak_barriers);
-	return (u16)last_used_idx != vq->vring.used->idx;
+	return (u16)last_used_idx != virtio16_to_cpu(_vq->vdev, vq->vring.used->idx);
 }
 EXPORT_SYMBOL_GPL(virtqueue_poll);
 
@@ -633,12 +634,12 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
 	/* Depending on the VIRTIO_RING_F_USED_EVENT_IDX feature, we need to
 	 * either clear the flags bit or point the event index at the next
 	 * entry. Always do both to keep code simple. */
-	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
+	vq->vring.avail->flags &= cpu_to_virtio16(_vq->vdev, ~VRING_AVAIL_F_NO_INTERRUPT);
 	/* TODO: tune this threshold */
-	bufs = (u16)(vq->vring.avail->idx - vq->last_used_idx) * 3 / 4;
-	vring_used_event(&vq->vring) = vq->last_used_idx + bufs;
+	bufs = (u16)(virtio16_to_cpu(_vq->vdev, vq->vring.avail->idx) - vq->last_used_idx) * 3 / 4;
+	vring_used_event(&vq->vring) = cpu_to_virtio16(_vq->vdev, vq->last_used_idx + bufs);
 	virtio_mb(vq->weak_barriers);
-	if (unlikely((u16)(vq->vring.used->idx - vq->last_used_idx) > bufs)) {
+	if (unlikely((u16)(virtio16_to_cpu(_vq->vdev, vq->vring.used->idx) - vq->last_used_idx) > bufs)) {
 		END_USE(vq);
 		return false;
 	}
@@ -670,7 +671,7 @@ void *virtqueue_detach_unused_buf(struct virtqueue *_vq)
 		/* detach_buf clears data, so grab it now. */
 		buf = vq->data[i];
 		detach_buf(vq, i);
-		vq->vring.avail->idx--;
+		vq->vring.avail->idx = cpu_to_virtio16(_vq->vdev, virtio16_to_cpu(_vq->vdev, vq->vring.avail->idx) - 1);
 		END_USE(vq);
 		return buf;
 	}
@@ -747,12 +748,12 @@ struct virtqueue *vring_new_virtqueue(unsigned int index,
 
 	/* No callback?  Tell other side not to bother us. */
 	if (!callback)
-		vq->vring.avail->flags |= VRING_AVAIL_F_NO_INTERRUPT;
+		vq->vring.avail->flags |= cpu_to_virtio16(vdev, VRING_AVAIL_F_NO_INTERRUPT);
 
 	/* Put everything in free lists. */
 	vq->free_head = 0;
 	for (i = 0; i < num-1; i++) {
-		vq->vring.desc[i].next = i+1;
+		vq->vring.desc[i].next = cpu_to_virtio16(vdev, i + 1);
 		vq->data[i] = NULL;
 	}
 	vq->data[i] = NULL;
-- 
MST

