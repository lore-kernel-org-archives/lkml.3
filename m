Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab3CFFY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:24:57 -0500
Received: from ozlabs.org ([203.10.76.45]:48226 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab3CFFY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:24:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: sjur.brandeland@stericsson.com, mst@redhat.com
Cc: virtualization@lists.linux-foundation.org,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] virtio_ring: virtqueue_add_sgs, to add multiple sgs.
In-Reply-To: <87k3plaz3d.fsf@rustcorp.com.au>
References: <87k3plaz3d.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 06 Mar 2013 16:19:01 +1100
Message-ID: <87fw09aywq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio_scsi can really use this, to avoid the current hack of copying
the whole sg array.  Some other things get slightly neater, too.

This causes a slowdown in virtqueue_add_buf(), which is naively
implemented as a wrapper.  This is addressed in the next patches.

for i in `seq 50`; do /usr/bin/time -f 'Wall time:%e' ./vringh_test --indirect --eventidx --parallel --fast-vringh; done 2>&1 | stats --trim-outliers:

Before:
	Using CPUS 0 and 3
	Guest: notified 0, pinged 39009-39063(39062)
	Host: notified 39009-39063(39062), pinged 0
	Wall time:1.700000-1.950000(1.723542)

After:
	Using CPUS 0 and 3
	Guest: notified 0, pinged 39019-39063(39061)
	Host: notified 39019-39063(39061), pinged 0
	Wall time:2.090000-2.520000(2.188542)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> 
Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reviewed-by: Asias He <asias@redhat.com>

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 245177c..27e31d3 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -100,14 +100,16 @@ struct vring_virtqueue
 
 /* Set up an indirect table of descriptors and add it to the queue. */
 static int vring_add_indirect(struct vring_virtqueue *vq,
-			      struct scatterlist sg[],
-			      unsigned int out,
-			      unsigned int in,
+			      struct scatterlist *sgs[],
+			      unsigned int total_sg,
+			      unsigned int out_sgs,
+			      unsigned int in_sgs,
 			      gfp_t gfp)
 {
 	struct vring_desc *desc;
 	unsigned head;
-	int i;
+	struct scatterlist *sg;
+	int i, n;
 
 	/*
 	 * We require lowmem mappings for the descriptors because
@@ -116,25 +118,31 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
 	 */
 	gfp &= ~(__GFP_HIGHMEM | __GFP_HIGH);
 
-	desc = kmalloc((out + in) * sizeof(struct vring_desc), gfp);
+	desc = kmalloc(total_sg * sizeof(struct vring_desc), gfp);
 	if (!desc)
 		return -ENOMEM;
 
-	/* Transfer entries from the sg list into the indirect page */
-	for (i = 0; i < out; i++) {
-		desc[i].flags = VRING_DESC_F_NEXT;
-		desc[i].addr = sg_phys(sg);
-		desc[i].len = sg->length;
-		desc[i].next = i+1;
-		sg++;
+	/* Transfer entries from the sg lists into the indirect page */
+	i = 0;
+	for (n = 0; n < out_sgs; n++) {
+		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
+			desc[i].flags = VRING_DESC_F_NEXT;
+			desc[i].addr = sg_phys(sg);
+			desc[i].len = sg->length;
+			desc[i].next = i+1;
+			i++;
+		}
 	}
-	for (; i < (out + in); i++) {
-		desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
-		desc[i].addr = sg_phys(sg);
-		desc[i].len = sg->length;
-		desc[i].next = i+1;
-		sg++;
+	for (; n < (out_sgs + in_sgs); n++) {
+		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
+			desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
+			desc[i].addr = sg_phys(sg);
+			desc[i].len = sg->length;
+			desc[i].next = i+1;
+			i++;
+		}
 	}
+	BUG_ON(i != total_sg);
 
 	/* Last one doesn't continue. */
 	desc[i-1].flags &= ~VRING_DESC_F_NEXT;
@@ -176,8 +184,48 @@ int virtqueue_add_buf(struct virtqueue *_vq,
 		      void *data,
 		      gfp_t gfp)
 {
+	struct scatterlist *sgs[2];
+	unsigned int i;
+
+	sgs[0] = sg;
+	sgs[1] = sg + out;
+
+	/* Workaround until callers pass well-formed sgs. */
+	for (i = 0; i < out + in; i++)
+		sg_unmark_end(sg + i);
+
+	sg_mark_end(sg + out + in - 1);
+	if (out && in)
+		sg_mark_end(sg + out - 1);
+
+	return virtqueue_add_sgs(_vq, sgs, out ? 1 : 0, in ? 1 : 0, data, gfp);
+}
+EXPORT_SYMBOL_GPL(virtqueue_add_buf);
+
+/**
+ * virtqueue_add_sgs - expose buffers to other end
+ * @vq: the struct virtqueue we're talking about.
+ * @sgs: array of terminated scatterlists.
+ * @out_num: the number of scatterlists readable by other side
+ * @in_num: the number of scatterlists which are writable (after readable ones)
+ * @data: the token identifying the buffer.
+ * @gfp: how to do memory allocations (if necessary).
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
+ *
+ * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
+ */
+int virtqueue_add_sgs(struct virtqueue *_vq,
+		      struct scatterlist *sgs[],
+		      unsigned int out_sgs,
+		      unsigned int in_sgs,
+		      void *data,
+		      gfp_t gfp)
+{
 	struct vring_virtqueue *vq = to_vvq(_vq);
-	unsigned int i, avail, uninitialized_var(prev);
+	struct scatterlist *sg;
+	unsigned int i, n, avail, uninitialized_var(prev), total_sg;
 	int head;
 
 	START_USE(vq);
@@ -197,46 +245,58 @@ int virtqueue_add_buf(struct virtqueue *_vq,
 	}
 #endif
 
+	/* Count them first. */
+	for (i = total_sg = 0; i < out_sgs + in_sgs; i++) {
+		struct scatterlist *sg;
+		for (sg = sgs[i]; sg; sg = sg_next(sg))
+			total_sg++;
+	}
+
 	/* If the host supports indirect descriptor tables, and we have multiple
 	 * buffers, then go indirect. FIXME: tune this threshold */
-	if (vq->indirect && (out + in) > 1 && vq->vq.num_free) {
-		head = vring_add_indirect(vq, sg, out, in, gfp);
+	if (vq->indirect && total_sg > 1 && vq->vq.num_free) {
+		head = vring_add_indirect(vq, sgs, total_sg, out_sgs, in_sgs,
+					  gfp);
 		if (likely(head >= 0))
 			goto add_head;
 	}
 
-	BUG_ON(out + in > vq->vring.num);
-	BUG_ON(out + in == 0);
+	BUG_ON(total_sg > vq->vring.num);
+	BUG_ON(total_sg == 0);
 
-	if (vq->vq.num_free < out + in) {
+	if (vq->vq.num_free < total_sg) {
 		pr_debug("Can't add buf len %i - avail = %i\n",
-			 out + in, vq->vq.num_free);
+			 total_sg, vq->vq.num_free);
 		/* FIXME: for historical reasons, we force a notify here if
 		 * there are outgoing parts to the buffer.  Presumably the
 		 * host should service the ring ASAP. */
-		if (out)
+		if (out_sgs)
 			vq->notify(&vq->vq);
 		END_USE(vq);
 		return -ENOSPC;
 	}
 
 	/* We're about to use some buffers from the free list. */
-	vq->vq.num_free -= out + in;
-
-	head = vq->free_head;
-	for (i = vq->free_head; out; i = vq->vring.desc[i].next, out--) {
-		vq->vring.desc[i].flags = VRING_DESC_F_NEXT;
-		vq->vring.desc[i].addr = sg_phys(sg);
-		vq->vring.desc[i].len = sg->length;
-		prev = i;
-		sg++;
+	vq->vq.num_free -= total_sg;
+
+	head = i = vq->free_head;
+	for (n = 0; n < out_sgs; n++) {
+		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
+			vq->vring.desc[i].flags = VRING_DESC_F_NEXT;
+			vq->vring.desc[i].addr = sg_phys(sg);
+			vq->vring.desc[i].len = sg->length;
+			prev = i;
+			i = vq->vring.desc[i].next;
+		}
 	}
-	for (; in; i = vq->vring.desc[i].next, in--) {
-		vq->vring.desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
-		vq->vring.desc[i].addr = sg_phys(sg);
-		vq->vring.desc[i].len = sg->length;
-		prev = i;
-		sg++;
+	for (; n < (out_sgs + in_sgs); n++) {
+		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
+			vq->vring.desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
+			vq->vring.desc[i].addr = sg_phys(sg);
+			vq->vring.desc[i].len = sg->length;
+			prev = i;
+			i = vq->vring.desc[i].next;
+		}
 	}
 	/* Last one doesn't continue. */
 	vq->vring.desc[prev].flags &= ~VRING_DESC_F_NEXT;
@@ -269,7 +329,7 @@ add_head:
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(virtqueue_add_buf);
+EXPORT_SYMBOL_GPL(virtqueue_add_sgs);
 
 /**
  * virtqueue_kick_prepare - first half of split virtqueue_kick call.
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index ff6714e..6eff15b 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -40,6 +40,13 @@ int virtqueue_add_buf(struct virtqueue *vq,
 		      void *data,
 		      gfp_t gfp);
 
+int virtqueue_add_sgs(struct virtqueue *vq,
+		      struct scatterlist *sgs[],
+		      unsigned int out_sgs,
+		      unsigned int in_sgs,
+		      void *data,
+		      gfp_t gfp);
+
 void virtqueue_kick(struct virtqueue *vq);
 
 bool virtqueue_kick_prepare(struct virtqueue *vq);
diff --git a/tools/virtio/linux/scatterlist.h b/tools/virtio/linux/scatterlist.h
index b2cf7d0..68c9e2a 100644
--- a/tools/virtio/linux/scatterlist.h
+++ b/tools/virtio/linux/scatterlist.h
@@ -125,6 +125,22 @@ static inline void sg_mark_end(struct scatterlist *sg)
 	sg->page_link &= ~0x01;
 }
 
+/**
+ * sg_unmark_end - Undo setting the end of the scatterlist
+ * @sg:		 SG entryScatterlist
+ *
+ * Description:
+ *   Removes the termination marker from the given entry of the scatterlist.
+ *
+ **/
+static inline void sg_unmark_end(struct scatterlist *sg)
+{
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
+	sg->page_link &= ~0x02;
+}
+
 static inline struct scatterlist *sg_next(struct scatterlist *sg)
 {
 #ifdef CONFIG_DEBUG_SG
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index e4af659..5fa612a 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -56,6 +56,13 @@ int virtqueue_add_buf(struct virtqueue *vq,
 		      void *data,
 		      gfp_t gfp);
 
+int virtqueue_add_sgs(struct virtqueue *vq,
+		      struct scatterlist *sgs[],
+		      unsigned int out_sgs,
+		      unsigned int in_sgs,
+		      void *data,
+		      gfp_t gfp);
+
 void virtqueue_kick(struct virtqueue *vq);
 
 void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
