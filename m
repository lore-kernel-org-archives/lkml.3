Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaFPP7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:59:21 -0400
Received: from verein.lst.de ([213.95.11.211]:52436 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295AbaFPP7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:59:18 -0400
Date: Mon, 16 Jun 2014 17:59:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: block: remove REQ_ATOM_COMPLETE wrappers
Message-ID: <20140616155916.GA19234@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just opencoding the bitops makes it much easier to grep for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/block/blk-core.c b/block/blk-core.c
index 9aca8c7..fca5009 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1265,7 +1265,7 @@ EXPORT_SYMBOL(blk_rq_set_block_pc);
 void blk_requeue_request(struct request_queue *q, struct request *rq)
 {
 	blk_delete_timer(rq);
-	blk_clear_rq_complete(rq);
+	clear_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
 	trace_block_rq_requeue(q, rq);
 
 	if (blk_rq_tagged(rq))
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 8ffee4b..3c12f26 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -127,7 +127,7 @@ static void blk_flush_restore_request(struct request *rq)
 	rq->cmd_flags &= ~REQ_FLUSH_SEQ;
 	rq->end_io = rq->flush.saved_end_io;
 
-	blk_clear_rq_complete(rq);
+	clear_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
 }
 
 static bool blk_flush_queue_rq(struct request *rq, bool add_front)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index e11f5f8..3d868d3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -396,7 +396,7 @@ void blk_mq_complete_request(struct request *rq)
 
 	if (unlikely(blk_should_fake_timeout(q)))
 		return;
-	if (!blk_mark_rq_complete(rq))
+	if (!test_and_set_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags))
 		__blk_mq_complete_request(rq);
 }
 EXPORT_SYMBOL(blk_mq_complete_request);
@@ -460,7 +460,7 @@ static void __blk_mq_requeue_request(struct request *rq)
 void blk_mq_requeue_request(struct request *rq)
 {
 	__blk_mq_requeue_request(rq);
-	blk_clear_rq_complete(rq);
+	clear_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
 
 	BUG_ON(blk_queued_rq(rq));
 	blk_mq_add_to_requeue_list(rq, true);
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 53b1737..5144e84 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -167,7 +167,7 @@ void blk_complete_request(struct request *req)
 {
 	if (unlikely(blk_should_fake_timeout(req->q)))
 		return;
-	if (!blk_mark_rq_complete(req))
+	if (!test_and_set_bit(REQ_ATOM_COMPLETE, &req->atomic_flags))
 		__blk_complete_request(req);
 }
 EXPORT_SYMBOL(blk_complete_request);
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 95a0959..185ebbe 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -97,7 +97,7 @@ static void blk_rq_timed_out(struct request *req)
 		break;
 	case BLK_EH_RESET_TIMER:
 		blk_add_timer(req);
-		blk_clear_rq_complete(req);
+		clear_bit(REQ_ATOM_COMPLETE, &req->atomic_flags);
 		break;
 	case BLK_EH_NOT_HANDLED:
 		/*
@@ -122,7 +122,7 @@ void blk_rq_check_expired(struct request *rq, unsigned long *next_timeout,
 		/*
 		 * Check if we raced with end io completion
 		 */
-		if (!blk_mark_rq_complete(rq))
+		if (!test_and_set_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags))
 			blk_rq_timed_out(rq);
 	} else if (!*next_set || time_after(*next_timeout, rq->deadline)) {
 		*next_timeout = rq->deadline;
@@ -159,7 +159,7 @@ void blk_rq_timed_out_timer(unsigned long data)
  */
 void blk_abort_request(struct request *req)
 {
-	if (blk_mark_rq_complete(req))
+	if (test_and_set_bit(REQ_ATOM_COMPLETE, &req->atomic_flags))
 		return;
 	blk_delete_timer(req);
 	blk_rq_timed_out(req);
diff --git a/block/blk.h b/block/blk.h
index 45385e9..91f67e7 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -65,20 +65,6 @@ enum rq_atomic_flags {
 };
 
 /*
- * EH timer and IO completion will both attempt to 'grab' the request, make
- * sure that only one of them succeeds
- */
-static inline int blk_mark_rq_complete(struct request *rq)
-{
-	return test_and_set_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
-}
-
-static inline void blk_clear_rq_complete(struct request *rq)
-{
-	clear_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
-}
-
-/*
  * Internal elevator interface
  */
 #define ELV_ON_HASH(rq) ((rq)->cmd_flags & REQ_HASHED)
