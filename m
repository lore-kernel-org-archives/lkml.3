Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507Ab3BGMZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:25:00 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:57248 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab3BGMWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:22:51 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, asias@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [RFC PATCH 3/8] virtio-blk: use virtqueue_start_buf on bio path
Date: Thu,  7 Feb 2013 13:22:27 +0100
Message-Id: <1360239752-2470-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
References: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the creation of the request header and response footer to
__virtblk_add_req.  vbr->sg only contains the data scatterlist,
the header/footer are added separately using the new piecewise
API for building virtqueue buffers.

With this change, virtio-blk is not relying anymore on the virtio
functions ignoring the end markers in a scatterlist.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/block/virtio_blk.c |   75 +++++++++++++++++++++++++++-----------------
 1 files changed, 46 insertions(+), 29 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index fd8a689..538cc40 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -62,6 +62,7 @@ struct virtblk_req
 	struct virtio_blk *vblk;
 	int flags;
 	u8 status;
+	int sg_count;
 	struct scatterlist sg[];
 };
 
@@ -100,24 +101,53 @@ static inline struct virtblk_req *virtblk_alloc_req(struct virtio_blk *vblk,
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
+	struct virtqueue_buf buf;
+	struct scatterlist sg;
+	enum dma_data_direction dir;
+	int ret;
+
+	unsigned int count = 2;
+	unsigned int count_sg = 2;
+
+	if (vbr->sg_count) {
+		count_sg++;
+		count += vbr->sg_count;
+	}
+
+	ret = virtqueue_start_buf(vq, &buf, vbr, count, count_sg, GFP_ATOMIC);
+	if (ret < 0)
+		return ret;
+
+	dir = DMA_TO_DEVICE;
+	sg_init_one(&sg, &vbr->out_hdr, sizeof(vbr->out_hdr));
+	virtqueue_add_sg_single(&buf, &sg, dir);
+
+	if (vbr->sg_count) {
+		if ((vbr->out_hdr.type & VIRTIO_BLK_T_OUT) == 0)
+			dir = DMA_FROM_DEVICE;
+
+		virtqueue_add_sg(&buf, vbr->sg, vbr->sg_count, dir);
+	}
+
+	dir = DMA_FROM_DEVICE;
+	sg_init_one(&sg, &vbr->status, sizeof(vbr->status));
+	virtqueue_add_sg_single(&buf, &sg, dir);
+
+	virtqueue_end_buf(&buf);
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
 
@@ -134,22 +164,18 @@ static void virtblk_add_req(struct virtblk_req *vbr,
 
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
+	vbr->sg_count = 0;
 
-	virtblk_add_req(vbr, out, in);
+	virtblk_add_req(vbr);
 }
 
 static void virtblk_bio_send_data(struct virtblk_req *vbr)
 {
 	struct virtio_blk *vblk = vbr->vblk;
-	unsigned int num, out = 0, in = 0;
 	struct bio *bio = vbr->bio;
 
 	vbr->flags &= ~VBLK_IS_FLUSH;
@@ -157,24 +183,15 @@ static void virtblk_bio_send_data(struct virtblk_req *vbr)
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
+	vbr->sg_count = blk_bio_map_sg(vblk->disk->queue, bio, vbr->sg);
+	if (vbr->sg_count) {
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


