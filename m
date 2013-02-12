Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182Ab3BLMX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:23:56 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:51696 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160Ab3BLMXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:23:53 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, asias@redhat.com, mst@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 3/9] virtio-blk: use virtqueue_start_buf on bio path
Date: Tue, 12 Feb 2013 13:23:29 +0100
Message-Id: <1360671815-2135-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360671815-2135-1-git-send-email-pbonzini@redhat.com>
References: <1360671815-2135-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the creation of the request header and response footer to
__virtblk_add_req.  vbr->sg only contains the data scatterlist,
the header/footer are added separately using the new piecewise
API for building virtqueue buffers.

With this change, virtio-blk (with use_bio) is not relying anymore on
the virtio functions ignoring the end markers in a scatterlist.
The next patch will do the same for the other path.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/block/virtio_blk.c |   74 ++++++++++++++++++++++++++-----------------
 1 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index fd8a689..4a31fcc 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -62,6 +62,7 @@ struct virtblk_req
 	struct virtio_blk *vblk;
 	int flags;
 	u8 status;
+	int nents;
 	struct scatterlist sg[];
 };
 
@@ -100,24 +101,52 @@ static inline struct virtblk_req *virtblk_alloc_req(struct virtio_blk *vblk,
 	return vbr;
 }
 
-static inline int __virtblk_add_req(struct virtqueue *vq,
-			     struct virtblk_req *vbr,
-			     unsigned long out,
-			     unsigned long in)
+static int __virtblk_add_req(struct virtqueue *vq,
+			     struct virtblk_req *vbr)
 {
-	return virtqueue_add_buf(vq, vbr->sg, out, in, vbr, GFP_ATOMIC);
+	struct scatterlist sg;
+	enum dma_data_direction dir;
+	int ret;
+
+	unsigned int nents = 2;
+	unsigned int nsg = 2;
+
+	if (vbr->nents) {
+		nsg++;
+		nents += vbr->nents;
+	}
+
+	ret = virtqueue_start_buf(vq, vbr, nents, nsg, GFP_ATOMIC);
+	if (ret < 0)
+		return ret;
+
+	dir = DMA_TO_DEVICE;
+	sg_init_one(&sg, &vbr->out_hdr, sizeof(vbr->out_hdr));
+	virtqueue_add_sg(vq, &sg, 1, dir);
+
+	if (vbr->nents) {
+		if ((vbr->out_hdr.type & VIRTIO_BLK_T_OUT) == 0)
+			dir = DMA_FROM_DEVICE;
+
+		virtqueue_add_sg(vq, vbr->sg, vbr->nents, dir);
+	}
+
+	dir = DMA_FROM_DEVICE;
+	sg_init_one(&sg, &vbr->status, sizeof(vbr->status));
+	virtqueue_add_sg(vq, &sg, 1, dir);
+
+	virtqueue_end_buf(vq);
+	return 0;
 }
 
-static void virtblk_add_req(struct virtblk_req *vbr,
-			    unsigned int out, unsigned int in)
+static void virtblk_add_req(struct virtblk_req *vbr)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 	DEFINE_WAIT(wait);
 	int ret;
 
 	spin_lock_irq(vblk->disk->queue->queue_lock);
-	while (unlikely((ret = __virtblk_add_req(vblk->vq, vbr,
-						 out, in)) < 0)) {
+	while (unlikely((ret = __virtblk_add_req(vblk->vq, vbr)) < 0)) {
 		prepare_to_wait_exclusive(&vblk->queue_wait, &wait,
 					  TASK_UNINTERRUPTIBLE);
 
@@ -134,22 +163,18 @@ static void virtblk_add_req(struct virtblk_req *vbr,
 
 static void virtblk_bio_send_flush(struct virtblk_req *vbr)
 {
-	unsigned int out = 0, in = 0;
-
 	vbr->flags |= VBLK_IS_FLUSH;
 	vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
 	vbr->out_hdr.sector = 0;
 	vbr->out_hdr.ioprio = 0;
-	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
-	sg_set_buf(&vbr->sg[out + in++], &vbr->status, sizeof(vbr->status));
+	vbr->nents = 0;
 
-	virtblk_add_req(vbr, out, in);
+	virtblk_add_req(vbr);
 }
 
 static void virtblk_bio_send_data(struct virtblk_req *vbr)
 {
 	struct virtio_blk *vblk = vbr->vblk;
-	unsigned int num, out = 0, in = 0;
 	struct bio *bio = vbr->bio;
 
 	vbr->flags &= ~VBLK_IS_FLUSH;
@@ -157,24 +182,15 @@ static void virtblk_bio_send_data(struct virtblk_req *vbr)
 	vbr->out_hdr.sector = bio->bi_sector;
 	vbr->out_hdr.ioprio = bio_prio(bio);
 
-	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
-
-	num = blk_bio_map_sg(vblk->disk->queue, bio, vbr->sg + out);
-
-	sg_set_buf(&vbr->sg[num + out + in++], &vbr->status,
-		   sizeof(vbr->status));
-
-	if (num) {
-		if (bio->bi_rw & REQ_WRITE) {
+	vbr->nents = blk_bio_map_sg(vblk->disk->queue, bio, vbr->sg);
+	if (vbr->nents) {
+		if (bio->bi_rw & REQ_WRITE)
 			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
-			out += num;
-		} else {
+		else
 			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
-			in += num;
-		}
 	}
 
-	virtblk_add_req(vbr, out, in);
+	virtblk_add_req(vbr);
 }
 
 static void virtblk_bio_send_data_work(struct work_struct *work)
-- 
1.7.1


