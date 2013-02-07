Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373Ab3BGMW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:22:56 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:39525 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321Ab3BGMWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:22:53 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, asias@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [RFC PATCH 4/8] virtio-blk: use virtqueue_start_buf on req path
Date: Thu,  7 Feb 2013 13:22:28 +0100
Message-Id: <1360239752-2470-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
References: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is similar to the previous patch, but a bit more radical
because the bio and req paths now share the buffer construction
code.  Because the req path doesn't use vbr->sg, however, we
need to add a couple of arguments to __virtblk_add_req.

We also need to teach __virtblk_add_req how to build SCSI command
requests.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/block/virtio_blk.c |   73 +++++++++++++++++++++++---------------------
 1 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 538cc40..5896b4d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -102,19 +102,27 @@ static inline struct virtblk_req *virtblk_alloc_req(struct virtio_blk *vblk,
 }
 
 static int __virtblk_add_req(struct virtqueue *vq,
-			     struct virtblk_req *vbr)
+			     struct virtblk_req *vbr,
+			     struct scatterlist *io_sg,
+			     unsigned io_sg_count)
 {
 	struct virtqueue_buf buf;
 	struct scatterlist sg;
 	enum dma_data_direction dir;
 	int ret;
 
+	int type = vbr->out_hdr.type & ~VIRTIO_BLK_T_OUT;
 	unsigned int count = 2;
 	unsigned int count_sg = 2;
 
-	if (vbr->sg_count) {
+	if (type == VIRTIO_BLK_T_SCSI_CMD) {
+		BUG_ON(use_bio);
+		count_sg += 3;
+		count += 3;
+	}
+	if (io_sg_count) {
 		count_sg++;
-		count += vbr->sg_count;
+		count += io_sg_count;
 	}
 
 	ret = virtqueue_start_buf(vq, &buf, vbr, count, count_sg, GFP_ATOMIC);
@@ -125,14 +133,32 @@ static int __virtblk_add_req(struct virtqueue *vq,
 	sg_init_one(&sg, &vbr->out_hdr, sizeof(vbr->out_hdr));
 	virtqueue_add_sg_single(&buf, &sg, dir);
 
-	if (vbr->sg_count) {
+	/*
+	 * If this is a packet command we need a couple of additional headers.
+	 * Behind the normal outhdr we put a segment with the scsi command
+	 * block, and before the normal inhdr we put the sense data and the
+	 * inhdr with additional status information before the normal inhdr.
+	 */
+	if (type == VIRTIO_BLK_T_SCSI_CMD) {
+		sg_init_one(&sg, vbr->req->cmd, vbr->req->cmd_len);
+		virtqueue_add_sg_single(&buf, &sg, dir);
+	}
+
+	if (io_sg_count) {
 		if ((vbr->out_hdr.type & VIRTIO_BLK_T_OUT) == 0)
 			dir = DMA_FROM_DEVICE;
 
-		virtqueue_add_sg(&buf, vbr->sg, vbr->sg_count, dir);
+		virtqueue_add_sg(&buf, io_sg, io_sg_count, dir);
 	}
 
 	dir = DMA_FROM_DEVICE;
+	if (type == VIRTIO_BLK_T_SCSI_CMD) {
+		sg_init_one(&sg, vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
+		virtqueue_add_sg_single(&buf, &sg, dir);
+		sg_init_one(&sg, &vbr->in_hdr, sizeof(vbr->in_hdr));
+		virtqueue_add_sg_single(&buf, &sg, dir);
+	}
+
 	sg_init_one(&sg, &vbr->status, sizeof(vbr->status));
 	virtqueue_add_sg_single(&buf, &sg, dir);
 
@@ -147,7 +173,8 @@ static void virtblk_add_req(struct virtblk_req *vbr)
 	int ret;
 
 	spin_lock_irq(vblk->disk->queue->queue_lock);
-	while (unlikely((ret = __virtblk_add_req(vblk->vq, vbr)) < 0)) {
+	while (unlikely((ret = __virtblk_add_req(vblk->vq, vbr, vbr->sg,
+						 vbr->sg_count)) < 0)) {
 		prepare_to_wait_exclusive(&vblk->queue_wait, &wait,
 					  TASK_UNINTERRUPTIBLE);
 
@@ -300,7 +327,7 @@ static void virtblk_done(struct virtqueue *vq)
 static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		   struct request *req)
 {
-	unsigned long num, out = 0, in = 0;
+	unsigned int num;
 	struct virtblk_req *vbr;
 
 	vbr = virtblk_alloc_req(vblk, GFP_ATOMIC);
@@ -337,40 +364,16 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		}
 	}
 
-	sg_set_buf(&vblk->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
-
-	/*
-	 * If this is a packet command we need a couple of additional headers.
-	 * Behind the normal outhdr we put a segment with the scsi command
-	 * block, and before the normal inhdr we put the sense data and the
-	 * inhdr with additional status information before the normal inhdr.
-	 */
-	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC)
-		sg_set_buf(&vblk->sg[out++], vbr->req->cmd, vbr->req->cmd_len);
-
-	num = blk_rq_map_sg(q, vbr->req, vblk->sg + out);
-
-	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC) {
-		sg_set_buf(&vblk->sg[num + out + in++], vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
-		sg_set_buf(&vblk->sg[num + out + in++], &vbr->in_hdr,
-			   sizeof(vbr->in_hdr));
-	}
-
-	sg_set_buf(&vblk->sg[num + out + in++], &vbr->status,
-		   sizeof(vbr->status));
+	num = blk_rq_map_sg(q, vbr->req, vblk->sg);
 
 	if (num) {
-		if (rq_data_dir(vbr->req) == WRITE) {
+		if (rq_data_dir(vbr->req) == WRITE)
 			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
-			out += num;
-		} else {
+		else
 			vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
-			in += num;
-		}
 	}
 
-	if (virtqueue_add_buf(vblk->vq, vblk->sg, out, in, vbr,
-			      GFP_ATOMIC) < 0) {
+	if (__virtblk_add_req(vblk->vq, vbr, vblk->sg, num) < 0) {
 		mempool_free(vbr, vblk->pool);
 		return false;
 	}
-- 
1.7.1


