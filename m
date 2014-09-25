Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaIYQaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:30:20 -0400
Received: from verein.lst.de ([213.95.11.211]:57243 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbaIYQaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:30:18 -0400
Date: Thu, 25 Sep 2014 18:30:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v5 0/10] block: per-distpatch_queue flush machinery
Message-ID: <20140925163015.GA31234@lst.de>
References: <1411658627-19754-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <1411658627-19754-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

To review this properly I had to actually squatch patches 2-4 and 6-9
into a single patch to read nicely over it, the result is attached below.

That one has one minor issue in __blk_drain_queue where a newly added
indent uses 4 spaces instead of tabs, but otherwise everything in this
series looks fine to me and passes sanity testing with scsi-mq.

Reviewed-by: Christoph Hellwig <hch@lst.de>

--uAKRQypu60I7Lcqm
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0003-blk-mq-allocate-flush_rq-in-blk_mq_init_flush.patch"

>From 48fb5773b19e6db3c2c26d76740e0995d0bbd136 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@canonical.com>
Date: Thu, 25 Sep 2014 23:23:39 +0800
Subject: blk-mq: allocate flush_rq in blk_mq_init_flush()

It is reasonable to allocate flush req in blk_mq_init_flush().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>

block: introduce blk_init_flush and its pair

These two temporary functions are introduced for holding flush
initialization and de-initialization, so that we can
introduce 'flush queue' easier in the following patch. And
once 'flush queue' and its allocation/free functions are ready,
they will be removed for sake of code readability.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>

block: move flush initialization to blk_flush_init

These fields are always used with the flush request, so
initialize them together.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>

block: introduce blk_flush_queue to drive flush machinery

This patch introduces 'struct blk_flush_queue' and puts all
flush machinery related fields into this structure, so that

	- flush implementation details aren't exposed to driver
	- it is easy to convert to per dispatch-queue flush machinery

This patch is basically a mechanical replacement.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>

block: remove blk_init_flush() and its pair

Now mission of the two helpers is over, and just call
blk_alloc_flush_queue() and blk_free_flush_queue() directly.

Signed-off-by: Ming Lei <ming.lei@canonical.com>

block: flush: avoid to figure out flush queue unnecessarily

Just figuring out flush queue at the entry of kicking off flush
machinery and request's completion handler, then pass it through.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>

block: introduce 'blk_mq_ctx' parameter to blk_get_flush_queue

This patch adds 'blk_mq_ctx' parameter to blk_get_flush_queue(),
so that this function can find the corresponding blk_flush_queue
bound with current mq context since the flush queue will become
per hw-queue.

For legacy queue, the parameter can be simply 'NULL'.

For multiqueue case, the parameter should be set as the context
from which the related request is originated. With this context
info, the hw queue and related flush queue can be found easily.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-core.c       |  13 +++---
 block/blk-flush.c      | 117 +++++++++++++++++++++++++++++++++----------------
 block/blk-mq.c         |  28 ++++++------
 block/blk-mq.h         |   1 -
 block/blk-sysfs.c      |   4 +-
 block/blk.h            |  25 ++++++++++-
 include/linux/blkdev.h |  10 +----
 7 files changed, 127 insertions(+), 71 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6946a42..b1dd4e0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -390,11 +390,13 @@ static void __blk_drain_queue(struct request_queue *q, bool drain_all)
 		 * be drained.  Check all the queues and counters.
 		 */
 		if (drain_all) {
+			struct blk_flush_queue *fq = blk_get_flush_queue(q, NULL);
 			drain |= !list_empty(&q->queue_head);
 			for (i = 0; i < 2; i++) {
 				drain |= q->nr_rqs[i];
 				drain |= q->in_flight[i];
-				drain |= !list_empty(&q->flush_queue[i]);
+				if (fq)
+				    drain |= !list_empty(&fq->flush_queue[i]);
 			}
 		}
 
@@ -600,9 +602,6 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 #ifdef CONFIG_BLK_CGROUP
 	INIT_LIST_HEAD(&q->blkg_list);
 #endif
-	INIT_LIST_HEAD(&q->flush_queue[0]);
-	INIT_LIST_HEAD(&q->flush_queue[1]);
-	INIT_LIST_HEAD(&q->flush_data_in_flight);
 	INIT_DELAYED_WORK(&q->delay_work, blk_delay_work);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
@@ -705,8 +704,8 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	if (!q)
 		return NULL;
 
-	q->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);
-	if (!q->flush_rq)
+	q->fq = blk_alloc_flush_queue(q);
+	if (!q->fq)
 		return NULL;
 
 	if (blk_init_rl(&q->root_rl, q, GFP_KERNEL))
@@ -742,7 +741,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	return q;
 
 fail:
-	kfree(q->flush_rq);
+	blk_free_flush_queue(q->fq);
 	return NULL;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 1bafbfe..004d95e 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -28,7 +28,7 @@
  *
  * The actual execution of flush is double buffered.  Whenever a request
  * needs to execute PRE or POSTFLUSH, it queues at
- * q->flush_queue[q->flush_pending_idx].  Once certain criteria are met, a
+ * fq->flush_queue[fq->flush_pending_idx].  Once certain criteria are met, a
  * flush is issued and the pending_idx is toggled.  When the flush
  * completes, all the requests which were pending are proceeded to the next
  * step.  This allows arbitrary merging of different types of FLUSH/FUA
@@ -91,7 +91,8 @@ enum {
 	FLUSH_PENDING_TIMEOUT	= 5 * HZ,
 };
 
-static bool blk_kick_flush(struct request_queue *q);
+static bool blk_kick_flush(struct request_queue *q,
+			   struct blk_flush_queue *fq);
 
 static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
 {
@@ -148,6 +149,7 @@ static bool blk_flush_queue_rq(struct request *rq, bool add_front)
 /**
  * blk_flush_complete_seq - complete flush sequence
  * @rq: FLUSH/FUA request being sequenced
+ * @fq: flush queue
  * @seq: sequences to complete (mask of %REQ_FSEQ_*, can be zero)
  * @error: whether an error occurred
  *
@@ -155,16 +157,17 @@ static bool blk_flush_queue_rq(struct request *rq, bool add_front)
  * completion and trigger the next step.
  *
  * CONTEXT:
- * spin_lock_irq(q->queue_lock or q->mq_flush_lock)
+ * spin_lock_irq(q->queue_lock or fq->mq_flush_lock)
  *
  * RETURNS:
  * %true if requests were added to the dispatch queue, %false otherwise.
  */
-static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
-				   int error)
+static bool blk_flush_complete_seq(struct request *rq,
+				   struct blk_flush_queue *fq,
+				   unsigned int seq, int error)
 {
 	struct request_queue *q = rq->q;
-	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
+	struct list_head *pending = &fq->flush_queue[fq->flush_pending_idx];
 	bool queued = false, kicked;
 
 	BUG_ON(rq->flush.seq & seq);
@@ -180,12 +183,12 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 	case REQ_FSEQ_POSTFLUSH:
 		/* queue for flush */
 		if (list_empty(pending))
-			q->flush_pending_since = jiffies;
+			fq->flush_pending_since = jiffies;
 		list_move_tail(&rq->flush.list, pending);
 		break;
 
 	case REQ_FSEQ_DATA:
-		list_move_tail(&rq->flush.list, &q->flush_data_in_flight);
+		list_move_tail(&rq->flush.list, &fq->flush_data_in_flight);
 		queued = blk_flush_queue_rq(rq, true);
 		break;
 
@@ -209,7 +212,7 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 		BUG();
 	}
 
-	kicked = blk_kick_flush(q);
+	kicked = blk_kick_flush(q, fq);
 	return kicked | queued;
 }
 
@@ -220,17 +223,18 @@ static void flush_end_io(struct request *flush_rq, int error)
 	bool queued = false;
 	struct request *rq, *n;
 	unsigned long flags = 0;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q, flush_rq->mq_ctx);
 
 	if (q->mq_ops) {
-		spin_lock_irqsave(&q->mq_flush_lock, flags);
+		spin_lock_irqsave(&fq->mq_flush_lock, flags);
 		flush_rq->tag = -1;
 	}
 
-	running = &q->flush_queue[q->flush_running_idx];
-	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
+	running = &fq->flush_queue[fq->flush_running_idx];
+	BUG_ON(fq->flush_pending_idx == fq->flush_running_idx);
 
 	/* account completion of the flush request */
-	q->flush_running_idx ^= 1;
+	fq->flush_running_idx ^= 1;
 
 	if (!q->mq_ops)
 		elv_completed_request(q, flush_rq);
@@ -240,7 +244,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 		unsigned int seq = blk_flush_cur_seq(rq);
 
 		BUG_ON(seq != REQ_FSEQ_PREFLUSH && seq != REQ_FSEQ_POSTFLUSH);
-		queued |= blk_flush_complete_seq(rq, seq, error);
+		queued |= blk_flush_complete_seq(rq, fq, seq, error);
 	}
 
 	/*
@@ -254,50 +258,51 @@ static void flush_end_io(struct request *flush_rq, int error)
 	 * directly into request_fn may confuse the driver.  Always use
 	 * kblockd.
 	 */
-	if (queued || q->flush_queue_delayed) {
+	if (queued || fq->flush_queue_delayed) {
 		WARN_ON(q->mq_ops);
 		blk_run_queue_async(q);
 	}
-	q->flush_queue_delayed = 0;
+	fq->flush_queue_delayed = 0;
 	if (q->mq_ops)
-		spin_unlock_irqrestore(&q->mq_flush_lock, flags);
+		spin_unlock_irqrestore(&fq->mq_flush_lock, flags);
 }
 
 /**
  * blk_kick_flush - consider issuing flush request
  * @q: request_queue being kicked
+ * @fq: flush queue
  *
  * Flush related states of @q have changed, consider issuing flush request.
  * Please read the comment at the top of this file for more info.
  *
  * CONTEXT:
- * spin_lock_irq(q->queue_lock or q->mq_flush_lock)
+ * spin_lock_irq(q->queue_lock or fq->mq_flush_lock)
  *
  * RETURNS:
  * %true if flush was issued, %false otherwise.
  */
-static bool blk_kick_flush(struct request_queue *q)
+static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq)
 {
-	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
+	struct list_head *pending = &fq->flush_queue[fq->flush_pending_idx];
 	struct request *first_rq =
 		list_first_entry(pending, struct request, flush.list);
-	struct request *flush_rq = q->flush_rq;
+	struct request *flush_rq = fq->flush_rq;
 
 	/* C1 described at the top of this file */
-	if (q->flush_pending_idx != q->flush_running_idx || list_empty(pending))
+	if (fq->flush_pending_idx != fq->flush_running_idx || list_empty(pending))
 		return false;
 
 	/* C2 and C3 */
-	if (!list_empty(&q->flush_data_in_flight) &&
+	if (!list_empty(&fq->flush_data_in_flight) &&
 	    time_before(jiffies,
-			q->flush_pending_since + FLUSH_PENDING_TIMEOUT))
+			fq->flush_pending_since + FLUSH_PENDING_TIMEOUT))
 		return false;
 
 	/*
 	 * Issue flush and toggle pending_idx.  This makes pending_idx
 	 * different from running_idx, which means flush is in flight.
 	 */
-	q->flush_pending_idx ^= 1;
+	fq->flush_pending_idx ^= 1;
 
 	blk_rq_init(q, flush_rq);
 	if (q->mq_ops)
@@ -314,12 +319,13 @@ static bool blk_kick_flush(struct request_queue *q)
 static void flush_data_end_io(struct request *rq, int error)
 {
 	struct request_queue *q = rq->q;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q, NULL);
 
 	/*
 	 * After populating an empty queue, kick it to avoid stall.  Read
 	 * the comment in flush_end_io().
 	 */
-	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
+	if (blk_flush_complete_seq(rq, fq, REQ_FSEQ_DATA, error))
 		blk_run_queue_async(q);
 }
 
@@ -327,20 +333,20 @@ static void mq_flush_data_end_io(struct request *rq, int error)
 {
 	struct request_queue *q = rq->q;
 	struct blk_mq_hw_ctx *hctx;
-	struct blk_mq_ctx *ctx;
+	struct blk_mq_ctx *ctx = rq->mq_ctx;
 	unsigned long flags;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q, ctx);
 
-	ctx = rq->mq_ctx;
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
 	/*
 	 * After populating an empty queue, kick it to avoid stall.  Read
 	 * the comment in flush_end_io().
 	 */
-	spin_lock_irqsave(&q->mq_flush_lock, flags);
-	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
+	spin_lock_irqsave(&fq->mq_flush_lock, flags);
+	if (blk_flush_complete_seq(rq, fq, REQ_FSEQ_DATA, error))
 		blk_mq_run_hw_queue(hctx, true);
-	spin_unlock_irqrestore(&q->mq_flush_lock, flags);
+	spin_unlock_irqrestore(&fq->mq_flush_lock, flags);
 }
 
 /**
@@ -360,6 +366,7 @@ void blk_insert_flush(struct request *rq)
 	struct request_queue *q = rq->q;
 	unsigned int fflags = q->flush_flags;	/* may change, cache */
 	unsigned int policy = blk_flush_policy(fflags, rq);
+	struct blk_flush_queue *fq = blk_get_flush_queue(q, rq->mq_ctx);
 
 	/*
 	 * @policy now records what operations need to be done.  Adjust
@@ -410,14 +417,14 @@ void blk_insert_flush(struct request *rq)
 	if (q->mq_ops) {
 		rq->end_io = mq_flush_data_end_io;
 
-		spin_lock_irq(&q->mq_flush_lock);
-		blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
-		spin_unlock_irq(&q->mq_flush_lock);
+		spin_lock_irq(&fq->mq_flush_lock);
+		blk_flush_complete_seq(rq, fq, REQ_FSEQ_ACTIONS & ~policy, 0);
+		spin_unlock_irq(&fq->mq_flush_lock);
 		return;
 	}
 	rq->end_io = flush_data_end_io;
 
-	blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
+	blk_flush_complete_seq(rq, fq, REQ_FSEQ_ACTIONS & ~policy, 0);
 }
 
 /**
@@ -473,7 +480,43 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL(blkdev_issue_flush);
 
-void blk_mq_init_flush(struct request_queue *q)
+struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q)
 {
-	spin_lock_init(&q->mq_flush_lock);
+	struct blk_flush_queue *fq;
+	int rq_sz = sizeof(struct request);
+
+	fq = kzalloc(sizeof(*fq), GFP_KERNEL);
+	if (!fq)
+		goto fail;
+
+	if (q->mq_ops) {
+		spin_lock_init(&fq->mq_flush_lock);
+		rq_sz = round_up(rq_sz + q->tag_set->cmd_size,
+				cache_line_size());
+	}
+
+	fq->flush_rq = kzalloc(rq_sz, GFP_KERNEL);
+	if (!fq->flush_rq)
+		goto fail_rq;
+
+	INIT_LIST_HEAD(&fq->flush_queue[0]);
+	INIT_LIST_HEAD(&fq->flush_queue[1]);
+	INIT_LIST_HEAD(&fq->flush_data_in_flight);
+
+	return fq;
+
+ fail_rq:
+	kfree(fq);
+ fail:
+	return NULL;
+}
+
+void blk_free_flush_queue(struct blk_flush_queue *fq)
+{
+	/* bio based request queue hasn't flush queue */
+	if (!fq)
+		return;
+
+	kfree(fq->flush_rq);
+	kfree(fq);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 66ef1fb..53b6def1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -508,20 +508,23 @@ void blk_mq_kick_requeue_list(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_mq_kick_requeue_list);
 
-static inline bool is_flush_request(struct request *rq, unsigned int tag)
+static inline bool is_flush_request(struct request *rq,
+		struct blk_flush_queue *fq, unsigned int tag)
 {
 	return ((rq->cmd_flags & REQ_FLUSH_SEQ) &&
-			rq->q->flush_rq->tag == tag);
+			fq->flush_rq->tag == tag);
 }
 
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
 {
 	struct request *rq = tags->rqs[tag];
+	/* mq_ctx of flush rq is always cloned from the corresponding req */
+	struct blk_flush_queue *fq = blk_get_flush_queue(rq->q, rq->mq_ctx);
 
-	if (!is_flush_request(rq, tag))
+	if (!is_flush_request(rq, fq, tag))
 		return rq;
 
-	return rq->q->flush_rq;
+	return fq->flush_rq;
 }
 EXPORT_SYMBOL(blk_mq_tag_to_rq);
 
@@ -1848,17 +1851,10 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	if (set->ops->complete)
 		blk_queue_softirq_done(q, set->ops->complete);
 
-	blk_mq_init_flush(q);
 	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 
-	q->flush_rq = kzalloc(round_up(sizeof(struct request) +
-				set->cmd_size, cache_line_size()),
-				GFP_KERNEL);
-	if (!q->flush_rq)
-		goto err_hw;
-
 	if (blk_mq_init_hw_queues(q, set))
-		goto err_flush_rq;
+		goto err_hw;
 
 	mutex_lock(&all_q_mutex);
 	list_add_tail(&q->all_q_node, &all_q_list);
@@ -1866,12 +1862,16 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 
 	blk_mq_add_queue_tag_set(set, q);
 
+	q->fq = blk_alloc_flush_queue(q);
+	if (!q->fq)
+		goto err_hw_queues;
+
 	blk_mq_map_swqueue(q);
 
 	return q;
 
-err_flush_rq:
-	kfree(q->flush_rq);
+err_hw_queues:
+	blk_mq_exit_hw_queues(q, set, set->nr_hw_queues);
 err_hw:
 	blk_cleanup_queue(q);
 err_hctxs:
diff --git a/block/blk-mq.h b/block/blk-mq.h
index a3c613a..d567d52 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -27,7 +27,6 @@ struct blk_mq_ctx {
 
 void __blk_mq_complete_request(struct request *rq);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
-void blk_mq_init_flush(struct request_queue *q);
 void blk_mq_freeze_queue(struct request_queue *q);
 void blk_mq_free_queue(struct request_queue *q);
 void blk_mq_clone_flush_request(struct request *flush_rq,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 17f5c84..718cffc4c 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -517,11 +517,11 @@ static void blk_release_queue(struct kobject *kobj)
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
+	blk_free_flush_queue(q->fq);
+
 	if (q->mq_ops)
 		blk_mq_free_queue(q);
 
-	kfree(q->flush_rq);
-
 	blk_trace_shutdown(q);
 
 	bdi_destroy(&q->backing_dev_info);
diff --git a/block/blk.h b/block/blk.h
index e515a28..7ecdd85 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -12,16 +12,36 @@
 /* Max future timer expiry for timeouts */
 #define BLK_MAX_TIMEOUT		(5 * HZ)
 
+struct blk_flush_queue {
+	unsigned int		flush_queue_delayed:1;
+	unsigned int		flush_pending_idx:1;
+	unsigned int		flush_running_idx:1;
+	unsigned long		flush_pending_since;
+	struct list_head	flush_queue[2];
+	struct list_head	flush_data_in_flight;
+	struct request		*flush_rq;
+	spinlock_t		mq_flush_lock;
+};
+
 extern struct kmem_cache *blk_requestq_cachep;
 extern struct kmem_cache *request_cachep;
 extern struct kobj_type blk_queue_ktype;
 extern struct ida blk_queue_ida;
 
+static inline struct blk_flush_queue *blk_get_flush_queue(
+		struct request_queue *q, struct blk_mq_ctx *ctx)
+{
+	return q->fq;
+}
+
 static inline void __blk_get_queue(struct request_queue *q)
 {
 	kobject_get(&q->kobj);
 }
 
+struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q);
+void blk_free_flush_queue(struct blk_flush_queue *fq);
+
 int blk_init_rl(struct request_list *rl, struct request_queue *q,
 		gfp_t gfp_mask);
 void blk_exit_rl(struct request_list *rl);
@@ -86,6 +106,7 @@ void blk_insert_flush(struct request *rq);
 static inline struct request *__elv_next_request(struct request_queue *q)
 {
 	struct request *rq;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q, NULL);
 
 	while (1) {
 		if (!list_empty(&q->queue_head)) {
@@ -108,9 +129,9 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 		 * should be restarted later. Please see flush_end_io() for
 		 * details.
 		 */
-		if (q->flush_pending_idx != q->flush_running_idx &&
+		if (fq->flush_pending_idx != fq->flush_running_idx &&
 				!queue_flush_queueable(q)) {
-			q->flush_queue_delayed = 1;
+			fq->flush_queue_delayed = 1;
 			return NULL;
 		}
 		if (unlikely(blk_queue_bypass(q)) ||
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e267bf0..49f3461 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -36,6 +36,7 @@ struct request;
 struct sg_io_hdr;
 struct bsg_job;
 struct blkcg_gq;
+struct blk_flush_queue;
 
 #define BLKDEV_MIN_RQ	4
 #define BLKDEV_MAX_RQ	128	/* Default maximum */
@@ -455,14 +456,7 @@ struct request_queue {
 	 */
 	unsigned int		flush_flags;
 	unsigned int		flush_not_queueable:1;
-	unsigned int		flush_queue_delayed:1;
-	unsigned int		flush_pending_idx:1;
-	unsigned int		flush_running_idx:1;
-	unsigned long		flush_pending_since;
-	struct list_head	flush_queue[2];
-	struct list_head	flush_data_in_flight;
-	struct request		*flush_rq;
-	spinlock_t		mq_flush_lock;
+	struct blk_flush_queue	*fq;
 
 	struct list_head	requeue_list;
 	spinlock_t		requeue_lock;
-- 
1.9.1


--uAKRQypu60I7Lcqm--
