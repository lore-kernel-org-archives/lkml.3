Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab3LaDjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 22:39:16 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38000 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3LaDjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 22:39:03 -0500
Date: Tue, 31 Dec 2013 11:38:50 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, kmo@daterainc.com
Subject: [patch 2/2]blk-mq: Don't reserve a tag for flush request
Message-ID: <20131231033850.GB31994@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reserving a tag (request) for flush to avoid dead lock is a overkill. tag is
valuable resource. We can track flush request number and disallow too many
pending flush requests allocated. With this patch,
blk_mq_alloc_request_pinned() could do a busy nop (but not a dead loop) if too
pending requests are allocated and new flush request is allocating. But this
should not be a problem, too many pending flush requests are very rare case.

I verified this can fix the deadlock caused by too many pending flush requests.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/blk-flush.c      |    8 +++++---
 block/blk-mq.c         |   46 ++++++++++++++++++++++++++++++----------------
 include/linux/blk-mq.h |    3 +++
 3 files changed, 38 insertions(+), 19 deletions(-)

Index: linux/block/blk-flush.c
===================================================================
--- linux.orig/block/blk-flush.c	2013-12-31 11:28:24.117417629 +0800
+++ linux/block/blk-flush.c	2013-12-31 11:28:24.109417628 +0800
@@ -284,9 +284,8 @@ static void mq_flush_work(struct work_st
 
 	q = container_of(work, struct request_queue, mq_flush_work);
 
-	/* We don't need set REQ_FLUSH_SEQ, it's for consistency */
 	rq = blk_mq_alloc_request(q, WRITE_FLUSH|REQ_FLUSH_SEQ,
-		__GFP_WAIT|GFP_ATOMIC, true);
+		__GFP_WAIT|GFP_ATOMIC, false);
 	rq->cmd_type = REQ_TYPE_FS;
 	rq->end_io = flush_end_io;
 
@@ -408,8 +407,11 @@ void blk_insert_flush(struct request *rq
 	/*
 	 * @policy now records what operations need to be done.  Adjust
 	 * REQ_FLUSH and FUA for the driver.
+	 * We keep REQ_FLUSH for mq to track flush requests. For !FUA,
+	 * we never dispatch the request directly.
 	 */
-	rq->cmd_flags &= ~REQ_FLUSH;
+	if (rq->cmd_flags & REQ_FUA)
+		rq->cmd_flags &= ~REQ_FLUSH;
 	if (!(fflags & REQ_FUA))
 		rq->cmd_flags &= ~REQ_FUA;
 
Index: linux/block/blk-mq.c
===================================================================
--- linux.orig/block/blk-mq.c	2013-12-31 11:28:24.117417629 +0800
+++ linux/block/blk-mq.c	2013-12-31 11:28:24.109417628 +0800
@@ -183,9 +183,27 @@ static void blk_mq_rq_ctx_init(struct re
 }
 
 static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
-					      gfp_t gfp, bool reserved)
+					      gfp_t gfp, bool reserved,
+					      int rw)
 {
-	return blk_mq_alloc_rq(hctx, gfp, reserved);
+	struct request *req;
+	bool is_flush = false;
+	/*
+	 * flush need allocate a request, leave at least one request for
+	 * non-flush IO to avoid deadlock
+	 */
+	if ((rw & REQ_FLUSH) && !(rw & REQ_FLUSH_SEQ)) {
+		if (atomic_inc_return(&hctx->pending_flush) >=
+		    hctx->queue_depth - hctx->reserved_tags - 1) {
+			atomic_dec(&hctx->pending_flush);
+			return NULL;
+		}
+		is_flush = true;
+	}
+	req = blk_mq_alloc_rq(hctx, gfp, reserved);
+	if (!req && is_flush)
+		atomic_dec(&hctx->pending_flush);
+	return req;
 }
 
 static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
@@ -198,7 +216,7 @@ static struct request *blk_mq_alloc_requ
 		struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
 		struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-		rq = __blk_mq_alloc_request(hctx, gfp & ~__GFP_WAIT, reserved);
+		rq = __blk_mq_alloc_request(hctx, gfp & ~__GFP_WAIT, reserved, rw);
 		if (rq) {
 			blk_mq_rq_ctx_init(q, ctx, rq, rw);
 			break;
@@ -261,6 +279,9 @@ static void __blk_mq_free_request(struct
 	const int tag = rq->tag;
 	struct request_queue *q = rq->q;
 
+	if ((rq->cmd_flags & REQ_FLUSH) && !(rq->cmd_flags & REQ_FLUSH_SEQ))
+		atomic_dec(&hctx->pending_flush);
+
 	blk_mq_rq_init(hctx, rq);
 	blk_mq_put_tag(hctx->tags, tag);
 
@@ -928,14 +949,14 @@ static void blk_mq_make_request(struct r
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
 	trace_block_getrq(q, bio, rw);
-	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, false);
+	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, false, bio->bi_rw);
 	if (likely(rq))
-		blk_mq_rq_ctx_init(q, ctx, rq, rw);
+		blk_mq_rq_ctx_init(q, ctx, rq, bio->bi_rw);
 	else {
 		blk_mq_put_ctx(ctx);
 		trace_block_sleeprq(q, bio, rw);
-		rq = blk_mq_alloc_request_pinned(q, rw, __GFP_WAIT|GFP_ATOMIC,
-							false);
+		rq = blk_mq_alloc_request_pinned(q, bio->bi_rw,
+				__GFP_WAIT|GFP_ATOMIC, false);
 		ctx = rq->mq_ctx;
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 	}
@@ -1212,7 +1233,9 @@ static int blk_mq_init_hw_queues(struct
 		hctx->queue_num = i;
 		hctx->flags = reg->flags;
 		hctx->queue_depth = reg->queue_depth;
+		hctx->reserved_tags = reg->reserved_tags;
 		hctx->cmd_size = reg->cmd_size;
+		atomic_set(&hctx->pending_flush, 0);
 
 		blk_mq_init_cpu_notifier(&hctx->cpu_notifier,
 						blk_mq_hctx_notify, hctx);
@@ -1337,15 +1360,6 @@ struct request_queue *blk_mq_init_queue(
 		reg->queue_depth = BLK_MQ_MAX_DEPTH;
 	}
 
-	/*
-	 * Set aside a tag for flush requests.  It will only be used while
-	 * another flush request is in progress but outside the driver.
-	 *
-	 * TODO: only allocate if flushes are supported
-	 */
-	reg->queue_depth++;
-	reg->reserved_tags++;
-
 	if (reg->queue_depth < (reg->reserved_tags + BLK_MQ_TAG_MIN))
 		return ERR_PTR(-EINVAL);
 
Index: linux/include/linux/blk-mq.h
===================================================================
--- linux.orig/include/linux/blk-mq.h	2013-12-31 11:28:24.117417629 +0800
+++ linux/include/linux/blk-mq.h	2013-12-31 11:28:24.109417628 +0800
@@ -36,12 +36,15 @@ struct blk_mq_hw_ctx {
 	struct list_head	page_list;
 	struct blk_mq_tags	*tags;
 
+	atomic_t		pending_flush;
+
 	unsigned long		queued;
 	unsigned long		run;
 #define BLK_MQ_MAX_DISPATCH_ORDER	10
 	unsigned long		dispatched[BLK_MQ_MAX_DISPATCH_ORDER];
 
 	unsigned int		queue_depth;
+	unsigned int		reserved_tags;
 	unsigned int		numa_node;
 	unsigned int		cmd_size;	/* per-request extra data */
 
