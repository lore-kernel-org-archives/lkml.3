Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab3LZNb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 08:31:56 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42246 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3LZNby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 08:31:54 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 1/5] block: blk-mq: avoid initializing request during its completion
Date: Thu, 26 Dec 2013 21:31:34 +0800
Message-Id: <1388064698-27344-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388064698-27344-1-git-send-email-tom.leiming@gmail.com>
References: <1388064698-27344-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One problem is that request->start_time/start_time_ns could be
set as wrong.

Also it is normal to intialize one data structure just after its
allocation.

So move the initialization out of its completion path.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 53dc9f7..35ae189 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -82,6 +82,7 @@ static struct request *blk_mq_alloc_rq(struct blk_mq_hw_ctx *hctx, gfp_t gfp,
 	tag = blk_mq_get_tag(hctx->tags, gfp, reserved);
 	if (tag != BLK_MQ_TAG_FAIL) {
 		rq = hctx->rqs[tag];
+		blk_rq_init(hctx->queue, rq);
 		rq->tag = tag;
 
 		return rq;
@@ -169,9 +170,13 @@ bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
 }
 EXPORT_SYMBOL(blk_mq_can_queue);
 
-static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
-			       struct request *rq, unsigned int rw_flags)
+static void blk_mq_rq_init(struct request_queue *q, struct blk_mq_ctx *ctx,
+			       struct blk_mq_hw_ctx *hctx, struct request *rq,
+			       unsigned int rw_flags)
 {
+	if (hctx->cmd_size)
+		rq->special = blk_mq_rq_to_pdu(rq);
+
 	if (blk_queue_io_stat(q))
 		rw_flags |= REQ_IO_STAT;
 
@@ -198,7 +203,7 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 
 		rq = __blk_mq_alloc_request(hctx, gfp & ~__GFP_WAIT, reserved);
 		if (rq) {
-			blk_mq_rq_ctx_init(q, ctx, rq, rw);
+			blk_mq_rq_init(q, ctx, hctx, rq, rw);
 			break;
 		}
 
@@ -242,24 +247,12 @@ struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw,
 }
 EXPORT_SYMBOL(blk_mq_alloc_reserved_request);
 
-/*
- * Re-init and set pdu, if we have it
- */
-static void blk_mq_rq_init(struct blk_mq_hw_ctx *hctx, struct request *rq)
-{
-	blk_rq_init(hctx->queue, rq);
-
-	if (hctx->cmd_size)
-		rq->special = blk_mq_rq_to_pdu(rq);
-}
-
 static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
 				  struct blk_mq_ctx *ctx, struct request *rq)
 {
 	const int tag = rq->tag;
 	struct request_queue *q = rq->q;
 
-	blk_mq_rq_init(hctx, rq);
 	blk_mq_put_tag(hctx->tags, tag);
 
 	blk_mq_queue_exit(q);
@@ -889,7 +882,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	trace_block_getrq(q, bio, rw);
 	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, false);
 	if (likely(rq))
-		blk_mq_rq_ctx_init(q, ctx, rq, rw);
+		blk_mq_rq_init(q, ctx, hctx, rq, rw);
 	else {
 		blk_mq_put_ctx(ctx);
 		trace_block_sleeprq(q, bio, rw);
@@ -1123,7 +1116,6 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 		left -= to_do * rq_size;
 		for (j = 0; j < to_do; j++) {
 			hctx->rqs[i] = p;
-			blk_mq_rq_init(hctx, hctx->rqs[i]);
 			p += rq_size;
 			i++;
 		}
-- 
1.7.9.5

