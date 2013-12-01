Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab3LAJ2d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 04:28:33 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59483 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3LAJ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 04:28:28 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: fix mq request allocation
Date: Sun,  1 Dec 2013 17:27:57 +0800
Message-Id: <1385890077-30873-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_mq_alloc_request_pinned() may return NULL request in case of
!__GFP_WAIT, so cause its callers to derefence NULL pointer for
releasing current context.

This patch introduces two flags to address the issue.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |   27 ++++++++++++++++-----------
 block/blk-mq.h |    3 +++
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index fb9ffdb..6875736 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -188,26 +188,32 @@ static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
 
 static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 						   int rw, gfp_t gfp,
-						   bool reserved)
+						   unsigned int flags)
 {
 	struct request *rq;
+	struct blk_mq_ctx *ctx;
+	struct blk_mq_hw_ctx *hctx;
 
 	do {
-		struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
-		struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
+		ctx = blk_mq_get_ctx(q);
+		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-		rq = __blk_mq_alloc_request(hctx, gfp & ~__GFP_WAIT, reserved);
+		rq = __blk_mq_alloc_request(hctx, gfp & ~__GFP_WAIT,
+				!!(flags & MQ_ALLOC_RESERVED));
 		if (rq) {
 			blk_mq_rq_ctx_init(q, ctx, rq, rw);
-			break;
+			goto exit;
 		} else if (!(gfp & __GFP_WAIT))
-			break;
+			goto exit;
 
 		blk_mq_put_ctx(ctx);
 		__blk_mq_run_hw_queue(hctx);
 		blk_mq_wait_for_tags(hctx->tags);
 	} while (1);
 
+exit:
+	if (!(flags & MQ_ALLOC_HOLD_CTX))
+		blk_mq_put_ctx(ctx);
 	return rq;
 }
 
@@ -219,8 +225,8 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 	if (blk_mq_queue_enter(q))
 		return NULL;
 
-	rq = blk_mq_alloc_request_pinned(q, rw, gfp, reserved);
-	blk_mq_put_ctx(rq->mq_ctx);
+	rq = blk_mq_alloc_request_pinned(q, rw, gfp, reserved ?
+			MQ_ALLOC_RESERVED : 0);
 	return rq;
 }
 
@@ -232,8 +238,7 @@ struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw,
 	if (blk_mq_queue_enter(q))
 		return NULL;
 
-	rq = blk_mq_alloc_request_pinned(q, rw, gfp, true);
-	blk_mq_put_ctx(rq->mq_ctx);
+	rq = blk_mq_alloc_request_pinned(q, rw, gfp, MQ_ALLOC_RESERVED);
 	return rq;
 }
 EXPORT_SYMBOL(blk_mq_alloc_reserved_request);
@@ -890,7 +895,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_put_ctx(ctx);
 		trace_block_sleeprq(q, bio, rw);
 		rq = blk_mq_alloc_request_pinned(q, rw, __GFP_WAIT|GFP_ATOMIC,
-							false);
+							MQ_ALLOC_HOLD_CTX);
 		ctx = rq->mq_ctx;
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 	}
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 5761eed..998911e 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -22,6 +22,9 @@ struct blk_mq_ctx {
 	struct kobject		kobj;
 };
 
+#define MQ_ALLOC_RESERVED	(1U << 0)
+#define MQ_ALLOC_HOLD_CTX	(1U << 1)
+
 void __blk_mq_end_io(struct request *rq, int error);
 void blk_mq_complete_request(struct request *rq, int error);
 void blk_mq_run_request(struct request *rq, bool run_queue, bool async);
-- 
1.7.9.5

