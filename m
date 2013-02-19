Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab3BSIHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:07:49 -0500
Received: from ozlabs.org ([203.10.76.45]:52148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758195Ab3BSICp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:02:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 04/16] virtio-blk: use virtqueue_start_buf on bio path
Date: Tue, 19 Feb 2013 18:26:22 +1030
Message-Id: <1361260594-601-5-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is a respin of Paolo Bonzini's patch, but it calls
virtqueue_add_sgs() instead of his multi-part API).

Move the creation of the request header and response footer to
__virtblk_add_req.  vbr->sg only contains the data scatterlist,
the header/footer are added separately using virtqueue_add_sgs().

With this change, virtio-blk (with use_bio) is not relying anymore on
the virtio functions ignoring the end markers in a scatterlist.
The next patch will do the same for the other path.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/block/virtio_blk.c |   58 ++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index fd8a689..e27bc6c 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -62,6 +62,7 @@ struct virtblk_req
 	struct virtio_blk *vblk;
 	int flags;
 	u8 status;
+	int nents;
 	struct scatterlist sg[];
 };
 
@@ -100,24 +101,36 @@ static inline struct virtblk_req *virtblk_alloc_req(struct virtio_blk *vblk,
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
+	struct scatterlist hdr, tailer, *sgs[3];
+	unsigned int num_out = 0, num_in = 0;
+
+	sg_init_one(&hdr, &vbr->out_hdr, sizeof(vbr->out_hdr));
+	sgs[num_out++] = &hdr;
+
+	if (vbr->nents) {
+		if (vbr->out_hdr.type & VIRTIO_BLK_T_OUT)
+			sgs[num_out++] = vbr->sg;
+		else
+			sgs[num_out + num_in++] = vbr->sg;
+	}
+
+	sg_init_one(&tailer, &vbr->status, sizeof(vbr->status));
+	sgs[num_out + num_in++] = &tailer;
+
+	return virtqueue_add_sgs(vq, sgs, num_out, num_in, vbr, GFP_ATOMIC);
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
 
@@ -134,22 +147,18 @@ static void virtblk_add_req(struct virtblk_req *vbr,
 
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
@@ -157,24 +166,15 @@ static void virtblk_bio_send_data(struct virtblk_req *vbr)
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
1.7.10.4

