Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaE0S5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:57:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:39272 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaE0S5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:57:43 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] blk-mq: remove blk_mq_alloc_request_pinned
Date: Tue, 27 May 2014 20:59:50 +0200
Message-Id: <1401217190-32453-6-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401217190-32453-1-git-send-email-hch@lst.de>
References: <1401217190-32453-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now only have one caller left and can open code it there in a cleaner
way.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |   48 ++++++++++++++++--------------------------------
 1 file changed, 16 insertions(+), 32 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7489d19..9d27077 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -264,46 +264,30 @@ __blk_mq_alloc_request(struct request_queue *q, struct blk_mq_hw_ctx *hctx,
 	return NULL;
 }
 
-static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
-						   int rw, gfp_t gfp,
-						   bool reserved)
-{
-	bool gfp_mask = gfp & ~__GFP_WAIT;
-	struct request *rq;
-
-	do {
-		struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
-		struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
-
-		rq = __blk_mq_alloc_request(q, hctx, ctx, rw, gfp_mask,
-						reserved);
-		if (rq)
-			break;
-
-		if (!(gfp & __GFP_WAIT)) {
-			blk_mq_put_ctx(ctx);
-			break;
-		}
-
-		__blk_mq_run_hw_queue(hctx);
-		blk_mq_put_ctx(ctx);
-		gfp_mask = gfp;
-	} while (1);
-
-	return rq;
-}
-
 struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp,
 		bool reserved)
 {
+	struct blk_mq_ctx *ctx;
+	struct blk_mq_hw_ctx *hctx;
 	struct request *rq;
 
 	if (blk_mq_queue_enter(q))
 		return NULL;
 
-	rq = blk_mq_alloc_request_pinned(q, rw, gfp, reserved);
-	if (rq)
-		blk_mq_put_ctx(rq->mq_ctx);
+	ctx = blk_mq_get_ctx(q);
+	hctx = q->mq_ops->map_queue(q, ctx->cpu);
+
+	rq = __blk_mq_alloc_request(q, hctx, ctx, rw, gfp & ~__GFP_WAIT,
+				    reserved);
+	if (!rq && (gfp & __GFP_WAIT)) {
+		__blk_mq_run_hw_queue(hctx);
+		blk_mq_put_ctx(ctx);
+
+		ctx = blk_mq_get_ctx(q);
+		hctx = q->mq_ops->map_queue(q, ctx->cpu);
+		rq =  __blk_mq_alloc_request(q, hctx, ctx, rw, gfp, reserved);
+	}
+	blk_mq_put_ctx(ctx);
 	return rq;
 }
 EXPORT_SYMBOL(blk_mq_alloc_request);
-- 
1.7.10.4

