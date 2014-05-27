Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaE0S6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:58:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:39266 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaE0S5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:57:40 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] blk-mq: initialize request in __blk_mq_alloc_request
Date: Tue, 27 May 2014 20:59:47 +0200
Message-Id: <1401217190-32453-3-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401217190-32453-1-git-send-email-hch@lst.de>
References: <1401217190-32453-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both callers if __blk_mq_alloc_request want to initialize the request, so
lift it into the common path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |   62 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f8f84e2..848b3b6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -92,30 +92,6 @@ static void blk_mq_hctx_clear_pending(struct blk_mq_hw_ctx *hctx,
 	clear_bit(CTX_TO_BIT(hctx, ctx), &bm->word);
 }
 
-static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
-					      struct blk_mq_ctx *ctx,
-					      gfp_t gfp, bool reserved)
-{
-	struct request *rq;
-	unsigned int tag;
-
-	tag = blk_mq_get_tag(hctx, &ctx->last_tag, gfp, reserved);
-	if (tag != BLK_MQ_TAG_FAIL) {
-		rq = hctx->tags->rqs[tag];
-
-		rq->cmd_flags = 0;
-		if (blk_mq_tag_busy(hctx)) {
-			rq->cmd_flags = REQ_MQ_INFLIGHT;
-			atomic_inc(&hctx->nr_active);
-		}
-
-		rq->tag = tag;
-		return rq;
-	}
-
-	return NULL;
-}
-
 static int blk_mq_queue_enter(struct request_queue *q)
 {
 	int ret;
@@ -263,6 +239,32 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	ctx->rq_dispatched[rw_is_sync(rw_flags)]++;
 }
 
+static struct request *
+__blk_mq_alloc_request(struct request_queue *q, struct blk_mq_hw_ctx *hctx,
+		struct blk_mq_ctx *ctx, int rw, gfp_t gfp, bool reserved)
+{
+	struct request *rq;
+	unsigned int tag;
+
+	tag = blk_mq_get_tag(hctx, &ctx->last_tag, gfp, reserved);
+	if (tag != BLK_MQ_TAG_FAIL) {
+		rq = hctx->tags->rqs[tag];
+
+		rq->cmd_flags = 0;
+		if (blk_mq_tag_busy(hctx)) {
+			rq->cmd_flags = REQ_MQ_INFLIGHT;
+			atomic_inc(&hctx->nr_active);
+		}
+
+		rq->tag = tag;
+		blk_mq_rq_ctx_init(q, ctx, rq, rw);
+		return rq;
+	}
+
+	return NULL;
+}
+
+
 static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 						   int rw, gfp_t gfp,
 						   bool reserved)
@@ -273,12 +275,10 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 		struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
 		struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-		rq = __blk_mq_alloc_request(hctx, ctx, gfp & ~__GFP_WAIT,
+		rq = __blk_mq_alloc_request(q, hctx, ctx, rw, gfp & ~__GFP_WAIT,
 						reserved);
-		if (rq) {
-			blk_mq_rq_ctx_init(q, ctx, rq, rw);
+		if (rq)
 			break;
-		}
 
 		if (gfp & __GFP_WAIT) {
 			__blk_mq_run_hw_queue(hctx);
@@ -1114,10 +1114,8 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 		rw |= REQ_SYNC;
 
 	trace_block_getrq(q, bio, rw);
-	rq = __blk_mq_alloc_request(hctx, ctx, GFP_ATOMIC, false);
-	if (likely(rq))
-		blk_mq_rq_ctx_init(q, ctx, rq, rw);
-	else {
+	rq = __blk_mq_alloc_request(q, hctx, ctx, rw, GFP_ATOMIC, false);
+	if (unlikely(!rq)) {
 		blk_mq_put_ctx(ctx);
 		trace_block_sleeprq(q, bio, rw);
 		rq = blk_mq_alloc_request_pinned(q, rw, __GFP_WAIT|GFP_ATOMIC,
-- 
1.7.10.4

