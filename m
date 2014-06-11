Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbaFKLt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:49:27 -0400
Received: from verein.lst.de ([213.95.11.211]:42427 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaFKLt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:49:26 -0400
Date: Wed, 11 Jun 2014 13:49:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: remove elv_abort_queue and blk_abort_flushes
Message-ID: <20140611114923.GA21981@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

elv_abort_queue has no callers, and blk_abort_flushes is only called by
elv_abort_queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 8ffee4b..3cb5e9e 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -422,44 +422,6 @@ void blk_insert_flush(struct request *rq)
 }
 
 /**
- * blk_abort_flushes - @q is being aborted, abort flush requests
- * @q: request_queue being aborted
- *
- * To be called from elv_abort_queue().  @q is being aborted.  Prepare all
- * FLUSH/FUA requests for abortion.
- *
- * CONTEXT:
- * spin_lock_irq(q->queue_lock)
- */
-void blk_abort_flushes(struct request_queue *q)
-{
-	struct request *rq, *n;
-	int i;
-
-	/*
-	 * Requests in flight for data are already owned by the dispatch
-	 * queue or the device driver.  Just restore for normal completion.
-	 */
-	list_for_each_entry_safe(rq, n, &q->flush_data_in_flight, flush.list) {
-		list_del_init(&rq->flush.list);
-		blk_flush_restore_request(rq);
-	}
-
-	/*
-	 * We need to give away requests on flush queues.  Restore for
-	 * normal completion and put them on the dispatch queue.
-	 */
-	for (i = 0; i < ARRAY_SIZE(q->flush_queue); i++) {
-		list_for_each_entry_safe(rq, n, &q->flush_queue[i],
-					 flush.list) {
-			list_del_init(&rq->flush.list);
-			blk_flush_restore_request(rq);
-			list_add_tail(&rq->queuelist, &q->queue_head);
-		}
-	}
-}
-
-/**
  * blkdev_issue_flush - queue a flush
  * @bdev:	blockdev to issue flush for
  * @gfp_mask:	memory allocation flags (for bio_alloc)
diff --git a/block/blk.h b/block/blk.h
index 45385e9..6748c4f 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -84,7 +84,6 @@ static inline void blk_clear_rq_complete(struct request *rq)
 #define ELV_ON_HASH(rq) ((rq)->cmd_flags & REQ_HASHED)
 
 void blk_insert_flush(struct request *rq);
-void blk_abort_flushes(struct request_queue *q);
 
 static inline struct request *__elv_next_request(struct request_queue *q)
 {
diff --git a/block/elevator.c b/block/elevator.c
index 1e01b66..24c28b6 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -729,26 +729,6 @@ int elv_may_queue(struct request_queue *q, int rw)
 	return ELV_MQUEUE_MAY;
 }
 
-void elv_abort_queue(struct request_queue *q)
-{
-	struct request *rq;
-
-	blk_abort_flushes(q);
-
-	while (!list_empty(&q->queue_head)) {
-		rq = list_entry_rq(q->queue_head.next);
-		rq->cmd_flags |= REQ_QUIET;
-		trace_block_rq_abort(q, rq);
-		/*
-		 * Mark this request as started so we don't trigger
-		 * any debug logic in the end I/O path.
-		 */
-		blk_start_request(rq);
-		__blk_end_request_all(rq, -EIO);
-	}
-}
-EXPORT_SYMBOL(elv_abort_queue);
-
 void elv_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct elevator_queue *e = q->elevator;
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index df63bd3..45a9147 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -133,7 +133,6 @@ extern struct request *elv_latter_request(struct request_queue *, struct request
 extern int elv_register_queue(struct request_queue *q);
 extern void elv_unregister_queue(struct request_queue *q);
 extern int elv_may_queue(struct request_queue *, int);
-extern void elv_abort_queue(struct request_queue *);
 extern void elv_completed_request(struct request_queue *, struct request *);
 extern int elv_set_request(struct request_queue *q, struct request *rq,
 			   struct bio *bio, gfp_t gfp_mask);
