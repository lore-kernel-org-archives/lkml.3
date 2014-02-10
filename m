Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaBJL04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:26:56 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaBJL0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:26:49 -0500
Message-Id: <20140210112649.504917395@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 03:24:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] virtio_blk: use blk_mq_complete_request
References: <20140210112437.858399303@bombadil.infradead.org>
Content-Disposition: inline; filename=0002-virtio_blk-use-blk_mq_complete_request.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure to complete requests on the submitting CPU.  Previously this
was done in blk_mq_end_io, but the responsibility shifted to the drivers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/virtio_blk.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6a680d4..b1cb3f4 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -110,9 +110,9 @@ static int __virtblk_add_req(struct virtqueue *vq,
 	return virtqueue_add_sgs(vq, sgs, num_out, num_in, vbr, GFP_ATOMIC);
 }
 
-static inline void virtblk_request_done(struct virtblk_req *vbr)
+static inline void virtblk_request_done(struct request *req)
 {
-	struct request *req = vbr->req;
+	struct virtblk_req *vbr = req->special;
 	int error = virtblk_result(vbr);
 
 	if (req->cmd_type == REQ_TYPE_BLOCK_PC) {
@@ -138,7 +138,7 @@ static void virtblk_done(struct virtqueue *vq)
 	do {
 		virtqueue_disable_cb(vq);
 		while ((vbr = virtqueue_get_buf(vblk->vq, &len)) != NULL) {
-			virtblk_request_done(vbr);
+			blk_mq_complete_request(vbr->req);
 			req_done = true;
 		}
 		if (unlikely(virtqueue_is_broken(vq)))
@@ -479,6 +479,7 @@ static struct blk_mq_ops virtio_mq_ops = {
 	.map_queue	= blk_mq_map_queue,
 	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
 	.free_hctx	= blk_mq_free_single_hw_queue,
+	.complete	= virtblk_request_done,
 };
 
 static struct blk_mq_reg virtio_mq_reg = {
-- 
1.7.10.4


