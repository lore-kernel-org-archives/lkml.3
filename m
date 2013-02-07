Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab3BGMXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:23:08 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:41099 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab3BGMXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:23:04 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, asias@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [RFC PATCH 8/8] virtio: reimplement virtqueue_add_buf using new functions
Date: Thu,  7 Feb 2013 13:22:32 +0100
Message-Id: <1360239752-2470-9-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
References: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the code duplication between virtqueue_add_buf and
virtqueue_add_sg.  That's safe to do now that no devices will
pass scatterlists with a termination marker in the middle.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/virtio/virtio_ring.c |  157 +++---------------------------------------
 1 files changed, 11 insertions(+), 146 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 25f56e6..d19113d 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -119,63 +119,6 @@ struct vring_virtqueue
 
 #define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)
 
-/* Set up an indirect table of descriptors and add it to the queue. */
-static int vring_add_indirect(struct vring_virtqueue *vq,
-			      struct scatterlist sg[],
-			      unsigned int out,
-			      unsigned int in,
-			      gfp_t gfp)
-{
-	struct vring_desc *desc;
-	unsigned head;
-	int i;
-
-	/*
-	 * We require lowmem mappings for the descriptors because
-	 * otherwise virt_to_phys will give us bogus addresses in the
-	 * virtqueue.
-	 */
-	gfp &= ~(__GFP_HIGHMEM | __GFP_HIGH);
-
-	desc = kmalloc((out + in) * sizeof(struct vring_desc), gfp);
-	if (!desc)
-		return -ENOMEM;
-
-	/* Transfer entries from the sg list into the indirect page */
-	for (i = 0; i < out; i++) {
-		desc[i].flags = VRING_DESC_F_NEXT;
-		desc[i].addr = sg_phys(sg);
-		desc[i].len = sg->length;
-		desc[i].next = i+1;
-		sg++;
-	}
-	for (; i < (out + in); i++) {
-		desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
-		desc[i].addr = sg_phys(sg);
-		desc[i].len = sg->length;
-		desc[i].next = i+1;
-		sg++;
-	}
-
-	/* Last one doesn't continue. */
-	desc[i-1].flags &= ~VRING_DESC_F_NEXT;
-	desc[i-1].next = 0;
-
-	/* We're about to use a buffer */
-	vq->vq.num_free--;
-
-	/* Use a single buffer which doesn't continue */
-	head = vq->free_head;
-	vq->vring.desc[head].flags = VRING_DESC_F_INDIRECT;
-	vq->vring.desc[head].addr = virt_to_phys(desc);
-	vq->vring.desc[head].len = i * sizeof(struct vring_desc);
-
-	/* Update free pointer */
-	vq->free_head = vq->vring.desc[head].next;
-
-	return head;
-}
-
 /**
  * virtqueue_add_buf - expose buffer to other end
  * @vq: the struct virtqueue we're talking about.
@@ -190,104 +133,26 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
  *
  * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
  */
-int virtqueue_add_buf(struct virtqueue *_vq,
+int virtqueue_add_buf(struct virtqueue *vq,
 		      struct scatterlist sg[],
 		      unsigned int out,
 		      unsigned int in,
 		      void *data,
 		      gfp_t gfp)
 {
-	struct vring_virtqueue *vq = to_vvq(_vq);
-	unsigned int i, avail, uninitialized_var(prev);
-	int head;
-
-	START_USE(vq);
-
-	BUG_ON(data == NULL);
-
-#ifdef DEBUG
-	{
-		ktime_t now = ktime_get();
+	struct virtqueue_buf buf;
+	int ret;
 
-		/* No kick or get, with .1 second between?  Warn. */
-		if (vq->last_add_time_valid)
-			WARN_ON(ktime_to_ms(ktime_sub(now, vq->last_add_time))
-					    > 100);
-		vq->last_add_time = now;
-		vq->last_add_time_valid = true;
-	}
-#endif
+	ret = virtqueue_start_buf(vq, &buf, data, out + in, !!out + !!in, gfp);
+	if (ret < 0)
+		return ret;
 
-	/* If the host supports indirect descriptor tables, and we have multiple
-	 * buffers, then go indirect. FIXME: tune this threshold */
-	if (vq->indirect && (out + in) > 1 && vq->vq.num_free) {
-		head = vring_add_indirect(vq, sg, out, in, gfp);
-		if (likely(head >= 0))
-			goto add_head;
-	}
-
-	BUG_ON(out + in > vq->vring.num);
-	BUG_ON(out + in == 0);
-
-	if (vq->vq.num_free < out + in) {
-		pr_debug("Can't add buf len %i - avail = %i\n",
-			 out + in, vq->vq.num_free);
-		/* FIXME: for historical reasons, we force a notify here if
-		 * there are outgoing parts to the buffer.  Presumably the
-		 * host should service the ring ASAP. */
-		if (out)
-			vq->notify(&vq->vq);
-		END_USE(vq);
-		return -ENOSPC;
-	}
-
-	/* We're about to use some buffers from the free list. */
-	vq->vq.num_free -= out + in;
-
-	head = vq->free_head;
-	for (i = vq->free_head; out; i = vq->vring.desc[i].next, out--) {
-		vq->vring.desc[i].flags = VRING_DESC_F_NEXT;
-		vq->vring.desc[i].addr = sg_phys(sg);
-		vq->vring.desc[i].len = sg->length;
-		prev = i;
-		sg++;
-	}
-	for (; in; i = vq->vring.desc[i].next, in--) {
-		vq->vring.desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
-		vq->vring.desc[i].addr = sg_phys(sg);
-		vq->vring.desc[i].len = sg->length;
-		prev = i;
-		sg++;
-	}
-	/* Last one doesn't continue. */
-	vq->vring.desc[prev].flags &= ~VRING_DESC_F_NEXT;
-
-	/* Update free pointer */
-	vq->free_head = i;
-
-add_head:
-	/* Set token. */
-	vq->data[head] = data;
-
-	/* Put entry in available array (but don't update avail->idx until they
-	 * do sync). */
-	avail = (vq->vring.avail->idx & (vq->vring.num-1));
-	vq->vring.avail->ring[avail] = head;
-
-	/* Descriptors and available array need to be set before we expose the
-	 * new available array entries. */
-	virtio_wmb(vq);
-	vq->vring.avail->idx++;
-	vq->num_added++;
-
-	/* This is very unlikely, but theoretically possible.  Kick
-	 * just in case. */
-	if (unlikely(vq->num_added == (1 << 16) - 1))
-		virtqueue_kick(_vq);
-
-	pr_debug("Added buffer head %i to %p\n", head, vq);
-	END_USE(vq);
+	if (out)
+		virtqueue_add_sg(&buf, sg, out, DMA_TO_DEVICE);
+	if (in)
+		virtqueue_add_sg(&buf, sg + out, in, DMA_FROM_DEVICE);
 
+	virtqueue_end_buf(&buf);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_buf);
-- 
1.7.1

