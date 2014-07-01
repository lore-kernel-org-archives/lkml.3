Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbaGAKrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:47:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbaGAKri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:47:38 -0400
Date: Tue, 1 Jul 2014 13:49:31 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC 1/2] virtio: support for urgent descriptors
Message-ID: <1404203661-7521-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below should be useful for some experiments Jason is doing.
I thought I'd send it out for early review/feedback.

Compiled-only at this point.

event idx feature allows us to defer interrupts until
a specific # of descriptors were used.
Sometimes it might be useful to get an interrupt after
a specific descriptor, regardless.
This adds a descriptor flag for this, and an API
to create an urgent output descriptor.
This is still an RFC:
we'll need a feature bit for drivers to detect this,
but we've run out of feature bits for virtio 0.X.
For experimentation purposes, drivers can assume
this is set, or add a driver-specific feature bit.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio.h           |  6 ++++++
 include/uapi/linux/virtio_ring.h |  3 +++
 drivers/virtio/virtio_ring.c     | 46 ++++++++++++++++++++++++++++++++++++----
 3 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index b46671e..14625a6 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -39,6 +39,12 @@ int virtqueue_add_outbuf(struct virtqueue *vq,
 			 void *data,
 			 gfp_t gfp);
 
+int virtqueue_add_outbuf_urgent(struct virtqueue *vq,
+				struct scatterlist sg[], unsigned int num,
+				void *data,
+				gfp_t gfp);
+
+
 int virtqueue_add_inbuf(struct virtqueue *vq,
 			struct scatterlist sg[], unsigned int num,
 			void *data,
diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
index a99f9b7..d08b1e6 100644
--- a/include/uapi/linux/virtio_ring.h
+++ b/include/uapi/linux/virtio_ring.h
@@ -39,6 +39,9 @@
 #define VRING_DESC_F_WRITE	2
 /* This means the buffer contains a list of buffer descriptors. */
 #define VRING_DESC_F_INDIRECT	4
+/* This means the descriptor should cause an interrupt
+ * ignoring avail event idx. */
+#define VRING_DESC_F_URGENT	8
 
 /* The Host uses this in used->flags to advise the Guest: don't kick me when
  * you add a buffer.  It's unreliable, so it's simply an optimization.  Guest
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 4d08f45a..3e448b9 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -115,6 +115,7 @@ static inline struct scatterlist *sg_next_arr(struct scatterlist *sg,
 
 /* Set up an indirect table of descriptors and add it to the queue. */
 static inline int vring_add_indirect(struct vring_virtqueue *vq,
+				     bool urgent,
 				     struct scatterlist *sgs[],
 				     struct scatterlist *(*next)
 				       (struct scatterlist *, unsigned int *),
@@ -173,6 +174,8 @@ static inline int vring_add_indirect(struct vring_virtqueue *vq,
 	/* Use a single buffer which doesn't continue */
 	head = vq->free_head;
 	vq->vring.desc[head].flags = VRING_DESC_F_INDIRECT;
+	if (urgent)
+		vq->vring.desc[head].flags |= VRING_DESC_F_URGENT;
 	vq->vring.desc[head].addr = virt_to_phys(desc);
 	/* kmemleak gives a false positive, as it's hidden by virt_to_phys */
 	kmemleak_ignore(desc);
@@ -185,6 +188,7 @@ static inline int vring_add_indirect(struct vring_virtqueue *vq,
 }
 
 static inline int virtqueue_add(struct virtqueue *_vq,
+			        bool urgent,
 				struct scatterlist *sgs[],
 				struct scatterlist *(*next)
 				  (struct scatterlist *, unsigned int *),
@@ -227,7 +231,7 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 	/* If the host supports indirect descriptor tables, and we have multiple
 	 * buffers, then go indirect. FIXME: tune this threshold */
 	if (vq->indirect && total_sg > 1 && vq->vq.num_free) {
-		head = vring_add_indirect(vq, sgs, next, total_sg, total_out,
+		head = vring_add_indirect(vq, urgent, sgs, next, total_sg, total_out,
 					  total_in,
 					  out_sgs, in_sgs, gfp);
 		if (likely(head >= 0))
@@ -256,6 +260,10 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 	for (n = 0; n < out_sgs; n++) {
 		for (sg = sgs[n]; sg; sg = next(sg, &total_out)) {
 			vq->vring.desc[i].flags = VRING_DESC_F_NEXT;
+			if (urgent) {
+				vq->vring.desc[head].flags |= VRING_DESC_F_URGENT;
+				urgent = false;
+			}
 			vq->vring.desc[i].addr = sg_phys(sg);
 			vq->vring.desc[i].len = sg->length;
 			prev = i;
@@ -265,6 +273,10 @@ static inline int virtqueue_add(struct virtqueue *_vq,
 	for (; n < (out_sgs + in_sgs); n++) {
 		for (sg = sgs[n]; sg; sg = next(sg, &total_in)) {
 			vq->vring.desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
+			if (urgent) {
+				vq->vring.desc[head].flags |= VRING_DESC_F_URGENT;
+				urgent = false;
+			}
 			vq->vring.desc[i].addr = sg_phys(sg);
 			vq->vring.desc[i].len = sg->length;
 			prev = i;
@@ -305,6 +317,8 @@ add_head:
 
 /**
  * virtqueue_add_sgs - expose buffers to other end
+ * @urgent: in case virtqueue_enable_cb_delayed was called, cause an interrupt
+ *          after this descriptor was completed
  * @vq: the struct virtqueue we're talking about.
  * @sgs: array of terminated scatterlists.
  * @out_num: the number of scatterlists readable by other side
@@ -337,7 +351,7 @@ int virtqueue_add_sgs(struct virtqueue *_vq,
 		for (sg = sgs[i]; sg; sg = sg_next(sg))
 			total_in++;
 	}
-	return virtqueue_add(_vq, sgs, sg_next_chained,
+	return virtqueue_add(_vq, false, sgs, sg_next_chained,
 			     total_out, total_in, out_sgs, in_sgs, data, gfp);
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_sgs);
@@ -360,11 +374,35 @@ int virtqueue_add_outbuf(struct virtqueue *vq,
 			 void *data,
 			 gfp_t gfp)
 {
-	return virtqueue_add(vq, &sg, sg_next_arr, num, 0, 1, 0, data, gfp);
+	return virtqueue_add(vq, false, &sg, sg_next_arr, num, 0, 1, 0, data, gfp);
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_outbuf);
 
 /**
+ * virtqueue_add_outbuf - expose output buffers to other end
+ *          in case virtqueue_enable_cb_delayed was called, cause an interrupt
+ *          after this descriptor was completed
+ * @vq: the struct virtqueue we're talking about.
+ * @sgs: array of scatterlists (need not be terminated!)
+ * @num: the number of scatterlists readable by other side
+ * @data: the token identifying the buffer.
+ * @gfp: how to do memory allocations (if necessary).
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
+ *
+ * Returns zero or a negative error (ie. ENOSPC, ENOMEM, EIO).
+ */
+int virtqueue_add_outbuf_urgent(struct virtqueue *vq,
+			 struct scatterlist sg[], unsigned int num,
+			 void *data,
+			 gfp_t gfp)
+{
+	return virtqueue_add(vq, true, &sg, sg_next_arr, num, 0, 1, 0, data, gfp);
+}
+EXPORT_SYMBOL_GPL(virtqueue_add_outbuf_urgent);
+
+/**
  * virtqueue_add_inbuf - expose input buffers to other end
  * @vq: the struct virtqueue we're talking about.
  * @sgs: array of scatterlists (need not be terminated!)
@@ -382,7 +420,7 @@ int virtqueue_add_inbuf(struct virtqueue *vq,
 			void *data,
 			gfp_t gfp)
 {
-	return virtqueue_add(vq, &sg, sg_next_arr, 0, num, 0, 1, data, gfp);
+	return virtqueue_add(vq, false, &sg, sg_next_arr, 0, num, 0, 1, data, gfp);
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_inbuf);
 
-- 
MST

