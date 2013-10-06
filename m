Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3JFQEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 12:04:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab3JFQEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 12:04:42 -0400
Date: Sun, 6 Oct 2013 09:04:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH, RFC] block: use a separate plug list for blk-mq requests
Message-ID: <20131006160430.GA5959@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_flush_plug_list became a bit of a mess with the introduction of blk-mq,
so I started looking into separating the blk-mq handling from it.  Turns
out that by doing this we can streamline the blk-mq submission path a lot.

If we branch out to a blk-mq specific code path early we can do the list sort
based on the hw ctx instead of the queue and thus avoid the later improvised
loop to sort again.  In addition we can also remove the hw irq disabling in
the submission path entirely and collapse a couple of functions in blk-mq.c,
all at the cost of an additional list_head in struct blk_plug which can go
away again as soon as we remove old-school request_fn based drivers.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 block/blk-core.c       |   29 ++++-------------
 block/blk-mq.c         |   81 ++++++++++++++++++++++++++++---------------------
 include/linux/blk-mq.h |    4 +-
 include/linux/blkdev.h |    6 +++
 4 files changed, 62 insertions(+), 58 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6d7fd79..7bedff6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2887,6 +2887,7 @@ void blk_start_plug(struct blk_plug *plug)
 
 	plug->magic = PLUG_MAGIC;
 	INIT_LIST_HEAD(&plug->list);
+	INIT_LIST_HEAD(&plug->mq_list);
 	INIT_LIST_HEAD(&plug->cb_list);
 
 	/*
@@ -2973,28 +2974,21 @@ struct blk_plug_cb *blk_check_plugged(blk_plug_cb_fn unplug, void *data,
 }
 EXPORT_SYMBOL(blk_check_plugged);
 
-static void do_queue_unplug(struct request_queue *q, bool from_schedule,
-			    unsigned int depth, struct list_head *list)
-{
-	if (q->mq_ops) {
-		trace_block_unplug(q, depth, !from_schedule);
-		blk_mq_insert_requests(q, list, 1, from_schedule);
-	} else
-		queue_unplugged(q, depth, from_schedule);
-}
-
 void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 {
 	struct request_queue *q;
 	unsigned long flags;
 	struct request *rq;
 	LIST_HEAD(list);
-	LIST_HEAD(q_list);
 	unsigned int depth;
 
 	BUG_ON(plug->magic != PLUG_MAGIC);
 
 	flush_plug_callbacks(plug, from_schedule);
+
+	if (!list_empty(&plug->mq_list))
+		blk_mq_flush_plug_list(plug, from_schedule);
+
 	if (list_empty(&plug->list))
 		return;
 
@@ -3019,17 +3013,10 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 			 * This drops the queue lock
 			 */
 			if (q)
-				do_queue_unplug(q, from_schedule, depth, &q_list);
+				queue_unplugged(q, depth, from_schedule);
 			q = rq->q;
 			depth = 0;
-			if (!q->mq_ops)
-				spin_lock(q->queue_lock);
-		}
-
-		if (q->mq_ops) {
-			depth++;
-			list_add_tail(&rq->queuelist, &q_list);
-			continue;
+			spin_lock(q->queue_lock);
 		}
 
 		/*
@@ -3055,7 +3042,7 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 	 * This drops the queue lock
 	 */
 	if (q)
-		do_queue_unplug(q, from_schedule, depth, &q_list);
+		queue_unplugged(q, depth, from_schedule);
 
 	local_irq_restore(flags);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2b85029..6a86881 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -9,6 +9,7 @@
 #include <linux/workqueue.h>
 #include <linux/smp.h>
 #include <linux/llist.h>
+#include <linux/list_sort.h>
 #include <linux/cpu.h>
 #include <linux/cache.h>
 #include <linux/sched/sysctl.h>
@@ -774,15 +775,18 @@ void blk_mq_run_request(struct request *rq, bool run_queue, bool async)
 		blk_mq_run_hw_queue(hctx, async);
 }
 
-static void __blk_mq_insert_requests(struct request_queue *q,
+static void blk_mq_insert_requests(struct request_queue *q,
 				     struct blk_mq_ctx *ctx,
 				     struct list_head *list,
-				     bool run_queue, bool from_schedule)
+				     int depth,
+				     bool from_schedule)
 
 {
 	struct blk_mq_hw_ctx *hctx;
 	struct blk_mq_ctx *current_ctx;
 
+	trace_block_unplug(q, depth, !from_schedule);
+
 	current_ctx = blk_mq_get_ctx(q);
 
 	if (!cpu_online(ctx->cpu))
@@ -806,55 +810,64 @@ static void __blk_mq_insert_requests(struct request_queue *q,
 
 	blk_mq_put_ctx(current_ctx);
 
-	if (run_queue)
-		blk_mq_run_hw_queue(hctx, from_schedule);
+	blk_mq_run_hw_queue(hctx, from_schedule);
 }
 
-void blk_mq_insert_requests(struct request_queue *q, struct list_head *list,
-			    bool run_queue, bool from_schedule)
+static int plug_ctx_cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct request *rqa = container_of(a, struct request, queuelist);
+	struct request *rqb = container_of(b, struct request, queuelist);
+
+	return !(rqa->mq_ctx < rqb->mq_ctx ||
+		 (rqa->mq_ctx == rqb->mq_ctx &&
+		  blk_rq_pos(rqa) < blk_rq_pos(rqb)));
+}
+
+void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 {
 	struct blk_mq_ctx *this_ctx;
+	struct request_queue *this_q;
+	struct request *rq;
+	LIST_HEAD(list);
 	LIST_HEAD(ctx_list);
+	unsigned int depth;
 
-	if (list_empty(list))
-		return;
+	list_splice_init(&plug->mq_list, &list);
 
-	/*
-	 * Iterate list, placing requests on the right ctx. Do one ctx
-	 * at the time. Given general CPU stickiness, the requests will
-	 * typically end up being ordered anyway.
-	 */
-	this_ctx = NULL;
-	while (!list_empty(list)) {
-		struct request *rq, *tmp;
+	list_sort(NULL, &list, plug_ctx_cmp);
 
-		/*
-		 * If this_ctx is set and different from rq->mq_ctx,
-		 * skip this 'rq'. This groups the same ctx's together,
-		 * so we batch completions for those.
-		 */
-		list_for_each_entry_safe(rq, tmp, list, queuelist) {
-			if (rq->mq_ctx != this_ctx) {
-				if (this_ctx)
-					continue;
+	this_q = NULL;
+	this_ctx = NULL;
+	depth = 0;
 
-				this_ctx = rq->mq_ctx;
+	while (!list_empty(&list)) {
+		rq = list_entry_rq(list.next);
+		list_del_init(&rq->queuelist);
+		BUG_ON(!rq->q);
+		if (rq->mq_ctx != this_ctx) {
+			if (this_ctx) {
+				blk_mq_insert_requests(this_q, this_ctx,
+							&ctx_list, depth,
+							from_schedule);
 			}
-			list_move_tail(&rq->queuelist, &ctx_list);
+
+			this_ctx = rq->mq_ctx;
+			this_q = rq->q;
+			depth = 0;
 		}
 
-		__blk_mq_insert_requests(q, this_ctx, &ctx_list, run_queue,
-						from_schedule);
-		this_ctx = NULL;
+		depth++;
+		list_add_tail(&rq->queuelist, &ctx_list);
 	}
 
 	/*
 	 * If 'this_ctx' is set, we know we have entries to complete
 	 * on 'ctx_list'. Do those.
 	 */
-	if (this_ctx)
-		__blk_mq_insert_requests(q, this_ctx, &ctx_list, run_queue,
-						from_schedule);
+	if (this_ctx) {
+		blk_mq_insert_requests(this_q, this_ctx, &ctx_list, depth,
+				       from_schedule);
+	}
 }
 
 static void blk_mq_bio_to_request(struct request *rq, struct bio *bio)
@@ -930,7 +943,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 				blk_flush_plug_list(plug, false);
 				trace_block_plug(q);
 			}
-			list_add_tail(&rq->queuelist, &plug->list);
+			list_add_tail(&rq->queuelist, &plug->mq_list);
 			blk_mq_put_ctx(ctx);
 			return;
 		}
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 4fddab2..746042ff 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -118,9 +118,9 @@ int blk_mq_register_disk(struct gendisk *);
 void blk_mq_unregister_disk(struct gendisk *);
 void blk_mq_init_commands(struct request_queue *, void (*init)(void *data, struct blk_mq_hw_ctx *, struct request *, unsigned int), void *data);
 
-void blk_mq_flush_plug(struct request_queue *, bool);
+void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule);
+
 void blk_mq_insert_request(struct request_queue *, struct request *, bool);
-void blk_mq_insert_requests(struct request_queue *, struct list_head *, bool, bool);
 void blk_mq_run_queues(struct request_queue *q, bool async);
 void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8771c0b..1b79592 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1035,6 +1035,7 @@ static inline void blk_post_runtime_resume(struct request_queue *q, int err) {}
 struct blk_plug {
 	unsigned long magic; /* detect uninitialized use-cases */
 	struct list_head list; /* requests */
+	struct list_head mq_list; /* blk-mq requests */
 	struct list_head cb_list; /* md requires an unplug callback */
 };
 #define BLK_MAX_REQUEST_COUNT 16
@@ -1072,7 +1073,10 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
 {
 	struct blk_plug *plug = tsk->plug;
 
-	return plug && (!list_empty(&plug->list) || !list_empty(&plug->cb_list));
+	return plug &&
+		(!list_empty(&plug->list) ||
+		 !list_empty(&plug->mq_list) ||
+		 !list_empty(&plug->cb_list));
 }
 
 /*
