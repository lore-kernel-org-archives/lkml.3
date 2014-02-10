Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaBJL0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:26:54 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaBJL0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:26:49 -0500
Message-Id: <20140210112649.324199173@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 03:24:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] blk-mq: rework I/O completions
References: <20140210112437.858399303@bombadil.infradead.org>
Content-Disposition: inline; filename=0001-blk-mq-rework-I-O-completions.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework I/O completions to work more like the old code path.  blk_mq_end_io
now stays out of the business of deferring completions to others CPUs
and calling blk_mark_rq_complete.  The latter is very important to allow
completing requests that have timed out and thus are already marked completed,
the former allows using the IPI callout even for driver specific completions
instead of having to reimplement them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c         |   52 +++++++++++++++++++++++++++++-------------------
 block/blk-mq.h         |    3 +--
 block/blk-timeout.c    |    2 +-
 include/linux/blk-mq.h |    4 ++++
 4 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index cee9623..14c8f35 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -326,7 +326,7 @@ static void blk_mq_bio_endio(struct request *rq, struct bio *bio, int error)
 		bio_endio(bio, error);
 }
 
-void blk_mq_complete_request(struct request *rq, int error)
+void blk_mq_end_io(struct request *rq, int error)
 {
 	struct bio *bio = rq->bio;
 	unsigned int bytes = 0;
@@ -351,46 +351,53 @@ void blk_mq_complete_request(struct request *rq, int error)
 	else
 		blk_mq_free_request(rq);
 }
+EXPORT_SYMBOL(blk_mq_end_io);
 
-void __blk_mq_end_io(struct request *rq, int error)
-{
-	if (!blk_mark_rq_complete(rq))
-		blk_mq_complete_request(rq, error);
-}
-
-static void blk_mq_end_io_remote(void *data)
+static void __blk_mq_complete_request_remote(void *data)
 {
 	struct request *rq = data;
 
-	__blk_mq_end_io(rq, rq->errors);
+	rq->q->softirq_done_fn(rq);
 }
 
-/*
- * End IO on this request on a multiqueue enabled driver. We'll either do
- * it directly inline, or punt to a local IPI handler on the matching
- * remote CPU.
- */
-void blk_mq_end_io(struct request *rq, int error)
+void __blk_mq_complete_request(struct request *rq)
 {
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
 	int cpu;
 
-	if (!ctx->ipi_redirect)
-		return __blk_mq_end_io(rq, error);
+	if (!ctx->ipi_redirect) {
+		rq->q->softirq_done_fn(rq);
+		return;
+	}
 
 	cpu = get_cpu();
 	if (cpu != ctx->cpu && cpu_online(ctx->cpu)) {
-		rq->errors = error;
-		rq->csd.func = blk_mq_end_io_remote;
+		rq->csd.func = __blk_mq_complete_request_remote;
 		rq->csd.info = rq;
 		rq->csd.flags = 0;
 		__smp_call_function_single(ctx->cpu, &rq->csd, 0);
 	} else {
-		__blk_mq_end_io(rq, error);
+		rq->q->softirq_done_fn(rq);
 	}
 	put_cpu();
 }
-EXPORT_SYMBOL(blk_mq_end_io);
+
+/**
+ * blk_mq_complete_request - end I/O on a request
+ * @rq:		the request being processed
+ *
+ * Description:
+ *	Ends all I/O on a request. It does not handle partial completions.
+ *	The actual completion happens out-of-order, through a IPI handler.
+ **/
+void blk_mq_complete_request(struct request *rq)
+{
+	if (unlikely(blk_should_fake_timeout(rq->q)))
+		return;
+	if (!blk_mark_rq_complete(rq))
+		__blk_mq_complete_request(rq);
+}
+EXPORT_SYMBOL(blk_mq_complete_request);
 
 static void blk_mq_start_request(struct request *rq)
 {
@@ -1399,6 +1406,9 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	if (reg->timeout)
 		blk_queue_rq_timeout(q, reg->timeout);
 
+	if (reg->ops->complete)
+		blk_queue_softirq_done(q, reg->ops->complete);
+
 	blk_mq_init_flush(q);
 	blk_mq_init_cpu_queues(q, reg->nr_hw_queues);
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 5c39179..f29b645 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -22,8 +22,7 @@ struct blk_mq_ctx {
 	struct kobject		kobj;
 };
 
-void __blk_mq_end_io(struct request *rq, int error);
-void blk_mq_complete_request(struct request *rq, int error);
+void __blk_mq_complete_request(struct request *rq);
 void blk_mq_run_request(struct request *rq, bool run_queue, bool async);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_init_flush(struct request_queue *q);
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index bba81c9..d96f706 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -91,7 +91,7 @@ static void blk_rq_timed_out(struct request *req)
 	case BLK_EH_HANDLED:
 		/* Can we use req->errors here? */
 		if (q->mq_ops)
-			blk_mq_complete_request(req, req->errors);
+			__blk_mq_complete_request(req);
 		else
 			__blk_complete_request(req);
 		break;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index b7638be..468be242d 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -86,6 +86,8 @@ struct blk_mq_ops {
 	 */
 	rq_timed_out_fn		*timeout;
 
+	softirq_done_fn		*complete;
+
 	/*
 	 * Override for hctx allocations (should probably go)
 	 */
@@ -137,6 +139,8 @@ void blk_mq_free_single_hw_queue(struct blk_mq_hw_ctx *, unsigned int);
 
 void blk_mq_end_io(struct request *rq, int error);
 
+void blk_mq_complete_request(struct request *rq);
+
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_stop_hw_queues(struct request_queue *q);
-- 
1.7.10.4


