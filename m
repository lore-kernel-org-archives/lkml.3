Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaIMDJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 23:09:57 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55303 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaIMDIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 23:08:20 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v3 05/10] block: introduce blk_flush_queue to drive flush machinery
Date: Sat, 13 Sep 2014 11:07:49 +0800
Message-Id: <1410577674-17019-6-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410577674-17019-1-git-send-email-ming.lei@canonical.com>
References: <1410577674-17019-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces 'struct blk_flush_queue' and puts all
flush machinery related fields into this structure, so that

	- flush implementation details aren't exposed to driver
	- it is easy to convert to per dispatch-queue flush machinery

This patch is basically a mechanical replacement.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-core.c       |    3 +-
 block/blk-flush.c      |  107 +++++++++++++++++++++++++++++-------------------
 block/blk-mq.c         |   10 +++--
 block/blk.h            |   22 +++++++++-
 include/linux/blkdev.h |   10 +----
 5 files changed, 95 insertions(+), 57 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 222fe84..d278a30 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -390,11 +390,12 @@ static void __blk_drain_queue(struct request_queue *q, bool drain_all)
 		 * be drained.  Check all the queues and counters.
 		 */
 		if (drain_all) {
+			struct blk_flush_queue *fq = blk_get_flush_queue(q);
 			drain |= !list_empty(&q->queue_head);
 			for (i = 0; i < 2; i++) {
 				drain |= q->nr_rqs[i];
 				drain |= q->in_flight[i];
-				drain |= !list_empty(&q->flush_queue[i]);
+				drain |= !list_empty(&fq->flush_queue[i]);
 			}
 		}
 
diff --git a/block/blk-flush.c b/block/blk-flush.c
index a59dd1a..db269d4 100644
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
@@ -157,7 +157,7 @@ static bool blk_flush_queue_rq(struct request *rq, bool add_front)
  * completion and trigger the next step.
  *
  * CONTEXT:
- * spin_lock_irq(q->queue_lock or q->mq_flush_lock)
+ * spin_lock_irq(q->queue_lock or fq->mq_flush_lock)
  *
  * RETURNS:
  * %true if requests were added to the dispatch queue, %false otherwise.
@@ -166,7 +166,8 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 				   int error)
 {
 	struct request_queue *q = rq->q;
-	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
+	struct list_head *pending = &fq->flush_queue[fq->flush_pending_idx];
 	bool queued = false, kicked;
 
 	BUG_ON(rq->flush.seq & seq);
@@ -182,12 +183,12 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
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
 
@@ -222,17 +223,18 @@ static void flush_end_io(struct request *flush_rq, int error)
 	bool queued = false;
 	struct request *rq, *n;
 	unsigned long flags = 0;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 
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
@@ -256,13 +258,13 @@ static void flush_end_io(struct request *flush_rq, int error)
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
@@ -273,33 +275,34 @@ static void flush_end_io(struct request *flush_rq, int error)
  * Please read the comment at the top of this file for more info.
  *
  * CONTEXT:
- * spin_lock_irq(q->queue_lock or q->mq_flush_lock)
+ * spin_lock_irq(q->queue_lock or fq->mq_flush_lock)
  *
  * RETURNS:
  * %true if flush was issued, %false otherwise.
  */
 static bool blk_kick_flush(struct request_queue *q)
 {
-	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
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
@@ -331,6 +334,7 @@ static void mq_flush_data_end_io(struct request *rq, int error)
 	struct blk_mq_hw_ctx *hctx;
 	struct blk_mq_ctx *ctx;
 	unsigned long flags;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 
 	ctx = rq->mq_ctx;
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
@@ -339,10 +343,10 @@ static void mq_flush_data_end_io(struct request *rq, int error)
 	 * After populating an empty queue, kick it to avoid stall.  Read
 	 * the comment in flush_end_io().
 	 */
-	spin_lock_irqsave(&q->mq_flush_lock, flags);
+	spin_lock_irqsave(&fq->mq_flush_lock, flags);
 	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
 		blk_mq_run_hw_queue(hctx, true);
-	spin_unlock_irqrestore(&q->mq_flush_lock, flags);
+	spin_unlock_irqrestore(&fq->mq_flush_lock, flags);
 }
 
 /**
@@ -410,11 +414,13 @@ void blk_insert_flush(struct request *rq)
 	rq->cmd_flags |= REQ_FLUSH_SEQ;
 	rq->flush.saved_end_io = rq->end_io; /* Usually NULL */
 	if (q->mq_ops) {
+		struct blk_flush_queue *fq = blk_get_flush_queue(q);
+
 		rq->end_io = mq_flush_data_end_io;
 
-		spin_lock_irq(&q->mq_flush_lock);
+		spin_lock_irq(&fq->mq_flush_lock);
 		blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
-		spin_unlock_irq(&q->mq_flush_lock);
+		spin_unlock_irq(&fq->mq_flush_lock);
 		return;
 	}
 	rq->end_io = flush_data_end_io;
@@ -475,31 +481,48 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL(blkdev_issue_flush);
 
-static int blk_mq_init_flush(struct request_queue *q)
+static struct blk_flush_queue *blk_alloc_flush_queue(
+		struct request_queue *q)
 {
-	struct blk_mq_tag_set *set = q->tag_set;
+	struct blk_flush_queue *fq;
+	int rq_sz = sizeof(struct request);
 
-	spin_lock_init(&q->mq_flush_lock);
+	fq = kzalloc(sizeof(*fq), GFP_KERNEL);
+	if (!fq)
+		goto fail;
 
-	q->flush_rq = kzalloc(round_up(sizeof(struct request) +
-				set->cmd_size, cache_line_size()),
-				GFP_KERNEL);
-	if (!q->flush_rq)
-		return -ENOMEM;
-	return 0;
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
 }
 
-int blk_init_flush(struct request_queue *q)
+static void blk_free_flush_queue(struct blk_flush_queue *fq)
 {
-	INIT_LIST_HEAD(&q->flush_queue[0]);
-	INIT_LIST_HEAD(&q->flush_queue[1]);
-	INIT_LIST_HEAD(&q->flush_data_in_flight);
-
-	if (q->mq_ops)
-		return blk_mq_init_flush(q);
+	kfree(fq->flush_rq);
+	kfree(fq);
+}
 
-	q->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);
-	if (!q->flush_rq)
+int blk_init_flush(struct request_queue *q)
+{
+	q->fq = blk_alloc_flush_queue(q);
+	if (!q->fq)
 		return -ENOMEM;
 
 	return 0;
@@ -507,5 +530,5 @@ int blk_init_flush(struct request_queue *q)
 
 void blk_exit_flush(struct request_queue *q)
 {
-	kfree(q->flush_rq);
+	blk_free_flush_queue(q->fq);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 467b1d8..a819af4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -508,20 +508,22 @@ void blk_mq_kick_requeue_list(struct request_queue *q)
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
+	struct blk_flush_queue *fq = blk_get_flush_queue(rq->q);
 
-	if (!is_flush_request(rq, tag))
+	if (!is_flush_request(rq, fq, tag))
 		return rq;
 
-	return rq->q->flush_rq;
+	return fq->flush_rq;
 }
 EXPORT_SYMBOL(blk_mq_tag_to_rq);
 
diff --git a/block/blk.h b/block/blk.h
index 261f734..2637349 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -12,11 +12,28 @@
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
+		struct request_queue *q)
+{
+	return q->fq;
+}
+
 static inline void __blk_get_queue(struct request_queue *q)
 {
 	kobject_get(&q->kobj);
@@ -91,6 +108,7 @@ void blk_insert_flush(struct request *rq);
 static inline struct request *__elv_next_request(struct request_queue *q)
 {
 	struct request *rq;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 
 	while (1) {
 		if (!list_empty(&q->queue_head)) {
@@ -113,9 +131,9 @@ static inline struct request *__elv_next_request(struct request_queue *q)
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
1.7.9.5

