Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaA3N0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:26:33 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaA3N0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:26:31 -0500
Date: Thu, 30 Jan 2014 05:26:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@fusionio.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140130132630.GB6031@infradead.org>
References: <20140130132620.GA6031@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130132620.GA6031@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Witch to using a preallocated flush_rq for blk-mq similar to what's done
with the old request path.  This allows us to set up the request properly
with a tag from the actually allowed range and ->rq_disk as needed by
some drivers.  To make life easier we also switch to dynamic allocation
of ->flush_rq for the old path.

This effectively reverts most of

    "blk-mq: fix for flush deadlock"

and

    "blk-mq: Don't reserve a tag for flush request"

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c       |   15 +++++--
 block/blk-flush.c      |  105 ++++++++++++++++++------------------------------
 block/blk-mq.c         |   54 +++++++++----------------
 block/blk-mq.h         |    1 +
 block/blk-sysfs.c      |    2 +
 include/linux/blk-mq.h |    5 +--
 include/linux/blkdev.h |   11 ++---
 7 files changed, 76 insertions(+), 117 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c00e0bd..d3eb330 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -693,11 +693,20 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	if (!uninit_q)
 		return NULL;
 
+	uninit_q->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);
+	if (!uninit_q->flush_rq)
+		goto out_cleanup_queue;
+
 	q = blk_init_allocated_queue(uninit_q, rfn, lock);
 	if (!q)
-		blk_cleanup_queue(uninit_q);
-
+		goto out_free_flush_rq;
 	return q;
+
+out_free_flush_rq:
+	kfree(uninit_q->flush_rq);
+out_cleanup_queue:
+	blk_cleanup_queue(uninit_q);
+	return NULL;
 }
 EXPORT_SYMBOL(blk_init_queue_node);
 
@@ -1127,7 +1136,7 @@ static struct request *blk_old_get_request(struct request_queue *q, int rw,
 struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 {
 	if (q->mq_ops)
-		return blk_mq_alloc_request(q, rw, gfp_mask, false);
+		return blk_mq_alloc_request(q, rw, gfp_mask);
 	else
 		return blk_old_get_request(q, rw, gfp_mask);
 }
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 9143e85..66e2b69 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -130,20 +130,26 @@ static void blk_flush_restore_request(struct request *rq)
 	blk_clear_rq_complete(rq);
 }
 
-static void mq_flush_data_run(struct work_struct *work)
+static void mq_flush_run(struct work_struct *work)
 {
 	struct request *rq;
 
-	rq = container_of(work, struct request, mq_flush_data);
+	rq = container_of(work, struct request, mq_flush_work);
 
 	memset(&rq->csd, 0, sizeof(rq->csd));
 	blk_mq_run_request(rq, true, false);
 }
 
-static void blk_mq_flush_data_insert(struct request *rq)
+static bool blk_flush_queue_rq(struct request *rq)
 {
-	INIT_WORK(&rq->mq_flush_data, mq_flush_data_run);
-	kblockd_schedule_work(rq->q, &rq->mq_flush_data);
+	if (rq->q->mq_ops) {
+		INIT_WORK(&rq->mq_flush_work, mq_flush_run);
+		kblockd_schedule_work(rq->q, &rq->mq_flush_work);
+		return false;
+	} else {
+		list_add_tail(&rq->queuelist, &rq->q->queue_head);
+		return true;
+	}
 }
 
 /**
@@ -187,12 +193,7 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 
 	case REQ_FSEQ_DATA:
 		list_move_tail(&rq->flush.list, &q->flush_data_in_flight);
-		if (q->mq_ops)
-			blk_mq_flush_data_insert(rq);
-		else {
-			list_add(&rq->queuelist, &q->queue_head);
-			queued = true;
-		}
+		queued = blk_flush_queue_rq(rq);
 		break;
 
 	case REQ_FSEQ_DONE:
@@ -216,9 +217,6 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 	}
 
 	kicked = blk_kick_flush(q);
-	/* blk_mq_run_flush will run queue */
-	if (q->mq_ops)
-		return queued;
 	return kicked | queued;
 }
 
@@ -230,10 +228,9 @@ static void flush_end_io(struct request *flush_rq, int error)
 	struct request *rq, *n;
 	unsigned long flags = 0;
 
-	if (q->mq_ops) {
-		blk_mq_free_request(flush_rq);
+	if (q->mq_ops)
 		spin_lock_irqsave(&q->mq_flush_lock, flags);
-	}
+
 	running = &q->flush_queue[q->flush_running_idx];
 	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
 
@@ -263,48 +260,14 @@ static void flush_end_io(struct request *flush_rq, int error)
 	 * kblockd.
 	 */
 	if (queued || q->flush_queue_delayed) {
-		if (!q->mq_ops)
-			blk_run_queue_async(q);
-		else
-		/*
-		 * This can be optimized to only run queues with requests
-		 * queued if necessary.
-		 */
-			blk_mq_run_queues(q, true);
+		WARN_ON(q->mq_ops);
+		blk_run_queue_async(q);
 	}
 	q->flush_queue_delayed = 0;
 	if (q->mq_ops)
 		spin_unlock_irqrestore(&q->mq_flush_lock, flags);
 }
 
-static void mq_flush_work(struct work_struct *work)
-{
-	struct request_queue *q;
-	struct request *rq;
-
-	q = container_of(work, struct request_queue, mq_flush_work);
-
-	rq = blk_mq_alloc_request(q, WRITE_FLUSH|REQ_FLUSH_SEQ,
-		__GFP_WAIT|GFP_ATOMIC, false);
-	rq->cmd_type = REQ_TYPE_FS;
-	rq->end_io = flush_end_io;
-
-	blk_mq_run_request(rq, true, false);
-}
-
-/*
- * We can't directly use q->flush_rq, because it doesn't have tag and is not in
- * hctx->rqs[]. so we must allocate a new request, since we can't sleep here,
- * so offload the work to workqueue.
- *
- * Note: we assume a flush request finished in any hardware queue will flush
- * the whole disk cache.
- */
-static void mq_run_flush(struct request_queue *q)
-{
-	kblockd_schedule_work(q, &q->mq_flush_work);
-}
-
 /**
  * blk_kick_flush - consider issuing flush request
  * @q: request_queue being kicked
@@ -339,19 +302,31 @@ static bool blk_kick_flush(struct request_queue *q)
 	 * different from running_idx, which means flush is in flight.
 	 */
 	q->flush_pending_idx ^= 1;
+
 	if (q->mq_ops) {
-		mq_run_flush(q);
-		return true;
+		struct blk_mq_ctx *ctx = first_rq->mq_ctx;
+		struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
+
+		blk_mq_rq_init(hctx, q->flush_rq);
+		q->flush_rq->mq_ctx = ctx;
+
+		/*
+		 * Reuse the tag value from the fist waiting request,
+		 * with blk-mq the tag is generated during request
+		 * allocation and drivers can rely on it being inside
+		 * the range they asked for.
+		 */
+		q->flush_rq->tag = first_rq->tag;
+	} else {
+		blk_rq_init(q, q->flush_rq);
 	}
 
-	blk_rq_init(q, &q->flush_rq);
-	q->flush_rq.cmd_type = REQ_TYPE_FS;
-	q->flush_rq.cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
-	q->flush_rq.rq_disk = first_rq->rq_disk;
-	q->flush_rq.end_io = flush_end_io;
+	q->flush_rq->cmd_type = REQ_TYPE_FS;
+	q->flush_rq->cmd_flags = WRITE_FLUSH | REQ_FLUSH_SEQ;
+	q->flush_rq->rq_disk = first_rq->rq_disk;
+	q->flush_rq->end_io = flush_end_io;
 
-	list_add_tail(&q->flush_rq.queuelist, &q->queue_head);
-	return true;
+	return blk_flush_queue_rq(q->flush_rq);
 }
 
 static void flush_data_end_io(struct request *rq, int error)
@@ -407,11 +382,8 @@ void blk_insert_flush(struct request *rq)
 	/*
 	 * @policy now records what operations need to be done.  Adjust
 	 * REQ_FLUSH and FUA for the driver.
-	 * We keep REQ_FLUSH for mq to track flush requests. For !FUA,
-	 * we never dispatch the request directly.
 	 */
-	if (rq->cmd_flags & REQ_FUA)
-		rq->cmd_flags &= ~REQ_FLUSH;
+	rq->cmd_flags &= ~REQ_FLUSH;
 	if (!(fflags & REQ_FUA))
 		rq->cmd_flags &= ~REQ_FUA;
 
@@ -560,5 +532,4 @@ EXPORT_SYMBOL(blkdev_issue_flush);
 void blk_mq_init_flush(struct request_queue *q)
 {
 	spin_lock_init(&q->mq_flush_lock);
-	INIT_WORK(&q->mq_flush_work, mq_flush_work);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9072d0a..5c3073f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -194,27 +194,9 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 }
 
 static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
-					      gfp_t gfp, bool reserved,
-					      int rw)
+					      gfp_t gfp, bool reserved)
 {
-	struct request *req;
-	bool is_flush = false;
-	/*
-	 * flush need allocate a request, leave at least one request for
-	 * non-flush IO to avoid deadlock
-	 */
-	if ((rw & REQ_FLUSH) && !(rw & REQ_FLUSH_SEQ)) {
-		if (atomic_inc_return(&hctx->pending_flush) >=
-		    hctx->queue_depth - hctx->reserved_tags - 1) {
-			atomic_dec(&hctx->pending_flush);
-			return NULL;
-		}
-		is_flush = true;
-	}
-	req = blk_mq_alloc_rq(hctx, gfp, reserved);
-	if (!req && is_flush)
-		atomic_dec(&hctx->pending_flush);
-	return req;
+	return blk_mq_alloc_rq(hctx, gfp, reserved);
 }
 
 static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
@@ -227,7 +209,7 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 		struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
 		struct blk_mq_hw_ctx *hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-		rq = __blk_mq_alloc_request(hctx, gfp & ~__GFP_WAIT, reserved, rw);
+		rq = __blk_mq_alloc_request(hctx, gfp & ~__GFP_WAIT, reserved);
 		if (rq) {
 			blk_mq_rq_ctx_init(q, ctx, rq, rw);
 			break;
@@ -244,15 +226,14 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 	return rq;
 }
 
-struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
-		gfp_t gfp, bool reserved)
+struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp)
 {
 	struct request *rq;
 
 	if (blk_mq_queue_enter(q))
 		return NULL;
 
-	rq = blk_mq_alloc_request_pinned(q, rw, gfp, reserved);
+	rq = blk_mq_alloc_request_pinned(q, rw, gfp, false);
 	if (rq)
 		blk_mq_put_ctx(rq->mq_ctx);
 	return rq;
@@ -276,7 +257,7 @@ EXPORT_SYMBOL(blk_mq_alloc_reserved_request);
 /*
  * Re-init and set pdu, if we have it
  */
-static void blk_mq_rq_init(struct blk_mq_hw_ctx *hctx, struct request *rq)
+void blk_mq_rq_init(struct blk_mq_hw_ctx *hctx, struct request *rq)
 {
 	blk_rq_init(hctx->queue, rq);
 
@@ -290,9 +271,6 @@ static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
 	const int tag = rq->tag;
 	struct request_queue *q = rq->q;
 
-	if ((rq->cmd_flags & REQ_FLUSH) && !(rq->cmd_flags & REQ_FLUSH_SEQ))
-		atomic_dec(&hctx->pending_flush);
-
 	blk_mq_rq_init(hctx, rq);
 	blk_mq_put_tag(hctx->tags, tag);
 
@@ -921,14 +899,14 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
 	trace_block_getrq(q, bio, rw);
-	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, false, bio->bi_rw);
+	rq = __blk_mq_alloc_request(hctx, GFP_ATOMIC, false);
 	if (likely(rq))
-		blk_mq_rq_ctx_init(q, ctx, rq, bio->bi_rw);
+		blk_mq_rq_ctx_init(q, ctx, rq, rw);
 	else {
 		blk_mq_put_ctx(ctx);
 		trace_block_sleeprq(q, bio, rw);
-		rq = blk_mq_alloc_request_pinned(q, bio->bi_rw,
-				__GFP_WAIT|GFP_ATOMIC, false);
+		rq = blk_mq_alloc_request_pinned(q, rw, __GFP_WAIT|GFP_ATOMIC,
+							false);
 		ctx = rq->mq_ctx;
 		hctx = q->mq_ops->map_queue(q, ctx->cpu);
 	}
@@ -1205,9 +1183,7 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 		hctx->queue_num = i;
 		hctx->flags = reg->flags;
 		hctx->queue_depth = reg->queue_depth;
-		hctx->reserved_tags = reg->reserved_tags;
 		hctx->cmd_size = reg->cmd_size;
-		atomic_set(&hctx->pending_flush, 0);
 
 		blk_mq_init_cpu_notifier(&hctx->cpu_notifier,
 						blk_mq_hctx_notify, hctx);
@@ -1382,9 +1358,14 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	blk_mq_init_flush(q);
 	blk_mq_init_cpu_queues(q, reg->nr_hw_queues);
 
-	if (blk_mq_init_hw_queues(q, reg, driver_data))
+	q->flush_rq = kzalloc(round_up(sizeof(struct request) + reg->cmd_size,
+				cache_line_size()), GFP_KERNEL);
+	if (!q->flush_rq)
 		goto err_hw;
 
+	if (blk_mq_init_hw_queues(q, reg, driver_data))
+		goto err_flush_rq;
+
 	blk_mq_map_swqueue(q);
 
 	mutex_lock(&all_q_mutex);
@@ -1392,6 +1373,9 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	mutex_unlock(&all_q_mutex);
 
 	return q;
+
+err_flush_rq:
+	kfree(q->flush_rq);
 err_hw:
 	kfree(q->mq_map);
 err_map:
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 5c39179..b771080 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -29,6 +29,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_init_flush(struct request_queue *q);
 void blk_mq_drain_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
+void blk_mq_rq_init(struct blk_mq_hw_ctx *hctx, struct request *rq);
 
 /*
  * CPU hotplug helpers
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8095c4a..7500f87 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -549,6 +549,8 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->mq_ops)
 		blk_mq_free_queue(q);
 
+	kfree(q->flush_rq);
+
 	blk_trace_shutdown(q);
 
 	bdi_destroy(&q->backing_dev_info);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 1e8f16f..c1684ec 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -36,15 +36,12 @@ struct blk_mq_hw_ctx {
 	struct list_head	page_list;
 	struct blk_mq_tags	*tags;
 
-	atomic_t		pending_flush;
-
 	unsigned long		queued;
 	unsigned long		run;
 #define BLK_MQ_MAX_DISPATCH_ORDER	10
 	unsigned long		dispatched[BLK_MQ_MAX_DISPATCH_ORDER];
 
 	unsigned int		queue_depth;
-	unsigned int		reserved_tags;
 	unsigned int		numa_node;
 	unsigned int		cmd_size;	/* per-request extra data */
 
@@ -126,7 +123,7 @@ void blk_mq_insert_request(struct request_queue *, struct request *, bool);
 void blk_mq_run_queues(struct request_queue *q, bool async);
 void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
-struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp, bool reserved);
+struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp);
 struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw, gfp_t gfp);
 struct request *blk_mq_rq_from_tag(struct request_queue *q, unsigned int tag);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0375654..b2d25ec 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -101,7 +101,7 @@ struct request {
 	};
 	union {
 		struct call_single_data csd;
-		struct work_struct mq_flush_data;
+		struct work_struct mq_flush_work;
 	};
 
 	struct request_queue *q;
@@ -451,13 +451,8 @@ struct request_queue {
 	unsigned long		flush_pending_since;
 	struct list_head	flush_queue[2];
 	struct list_head	flush_data_in_flight;
-	union {
-		struct request	flush_rq;
-		struct {
-			spinlock_t mq_flush_lock;
-			struct work_struct mq_flush_work;
-		};
-	};
+	struct request		*flush_rq;
+	spinlock_t		mq_flush_lock;
 
 	struct mutex		sysfs_lock;
 
-- 
1.7.10.4

