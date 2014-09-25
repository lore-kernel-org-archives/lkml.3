Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaIYPYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:24:41 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61347 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbaIYPYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:24:39 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v5 08/10] block: flush: avoid to figure out flush queue unnecessarily
Date: Thu, 25 Sep 2014 23:23:45 +0800
Message-Id: <1411658627-19754-9-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411658627-19754-1-git-send-email-ming.lei@canonical.com>
References: <1411658627-19754-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just figuring out flush queue at the entry of kicking off flush
machinery and request's completion handler, then pass it through.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-flush.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index d66cbf2..9bc5b4f 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
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
@@ -160,11 +162,11 @@ static bool blk_flush_queue_rq(struct request *rq, bool add_front)
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
-	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 	struct list_head *pending = &fq->flush_queue[fq->flush_pending_idx];
 	bool queued = false, kicked;
 
@@ -210,7 +212,7 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 		BUG();
 	}
 
-	kicked = blk_kick_flush(q);
+	kicked = blk_kick_flush(q, fq);
 	return kicked | queued;
 }
 
@@ -242,7 +244,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 		unsigned int seq = blk_flush_cur_seq(rq);
 
 		BUG_ON(seq != REQ_FSEQ_PREFLUSH && seq != REQ_FSEQ_POSTFLUSH);
-		queued |= blk_flush_complete_seq(rq, seq, error);
+		queued |= blk_flush_complete_seq(rq, fq, seq, error);
 	}
 
 	/*
@@ -268,6 +270,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 /**
  * blk_kick_flush - consider issuing flush request
  * @q: request_queue being kicked
+ * @fq: flush queue
  *
  * Flush related states of @q have changed, consider issuing flush request.
  * Please read the comment at the top of this file for more info.
@@ -278,9 +281,8 @@ static void flush_end_io(struct request *flush_rq, int error)
  * RETURNS:
  * %true if flush was issued, %false otherwise.
  */
-static bool blk_kick_flush(struct request_queue *q)
+static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq)
 {
-	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 	struct list_head *pending = &fq->flush_queue[fq->flush_pending_idx];
 	struct request *first_rq =
 		list_first_entry(pending, struct request, flush.list);
@@ -317,12 +319,13 @@ static bool blk_kick_flush(struct request_queue *q)
 static void flush_data_end_io(struct request *rq, int error)
 {
 	struct request_queue *q = rq->q;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 
 	/*
 	 * After populating an empty queue, kick it to avoid stall.  Read
 	 * the comment in flush_end_io().
 	 */
-	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
+	if (blk_flush_complete_seq(rq, fq, REQ_FSEQ_DATA, error))
 		blk_run_queue_async(q);
 }
 
@@ -342,7 +345,7 @@ static void mq_flush_data_end_io(struct request *rq, int error)
 	 * the comment in flush_end_io().
 	 */
 	spin_lock_irqsave(&fq->mq_flush_lock, flags);
-	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
+	if (blk_flush_complete_seq(rq, fq, REQ_FSEQ_DATA, error))
 		blk_mq_run_hw_queue(hctx, true);
 	spin_unlock_irqrestore(&fq->mq_flush_lock, flags);
 }
@@ -364,6 +367,7 @@ void blk_insert_flush(struct request *rq)
 	struct request_queue *q = rq->q;
 	unsigned int fflags = q->flush_flags;	/* may change, cache */
 	unsigned int policy = blk_flush_policy(fflags, rq);
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 
 	/*
 	 * @policy now records what operations need to be done.  Adjust
@@ -412,18 +416,16 @@ void blk_insert_flush(struct request *rq)
 	rq->cmd_flags |= REQ_FLUSH_SEQ;
 	rq->flush.saved_end_io = rq->end_io; /* Usually NULL */
 	if (q->mq_ops) {
-		struct blk_flush_queue *fq = blk_get_flush_queue(q);
-
 		rq->end_io = mq_flush_data_end_io;
 
 		spin_lock_irq(&fq->mq_flush_lock);
-		blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
+		blk_flush_complete_seq(rq, fq, REQ_FSEQ_ACTIONS & ~policy, 0);
 		spin_unlock_irq(&fq->mq_flush_lock);
 		return;
 	}
 	rq->end_io = flush_data_end_io;
 
-	blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
+	blk_flush_complete_seq(rq, fq, REQ_FSEQ_ACTIONS & ~policy, 0);
 }
 
 /**
-- 
1.7.9.5

