Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3JDNu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:50:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53086 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab3JDNuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:50:22 -0400
Message-Id: <20131004135014.524075942@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 04 Oct 2013 06:49:10 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] [PATCH 2/5] revert: "blk-mq: blk-mq should free bios in pass through
 case"
References: <20131004134908.231874670@bombadil.infradead.org>
Content-Disposition: inline; filename=0002-revert-blk-mq-blk-mq-should-free-bios-in-pass-throug.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch causes boot failures when using REQ_FLUSH requests.  Also the
following statement in the commit log:

    For non mq calls, the block layer will free the bios when
    blk_finish_request is called.

    For mq calls, the blk mq code wants the caller to do this.

Seems incorrect as far as I can follow the code as blk_finish_request only
calls __blk_put_request which then completes the bios if req->end_io is
not set.  This matches the blk-mq behaviour before this patch, so reverting
it makes the code more similar to the legacy case in addition to fixing the
boot failure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-flush.c |    2 +-
 block/blk-mq.c    |   14 ++++++++++----
 block/blk-mq.h    |    1 +
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 3e4cc9c..c56c37d 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -231,7 +231,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 	unsigned long flags = 0;
 
 	if (q->mq_ops) {
-		blk_mq_free_request(flush_rq);
+		blk_mq_finish_request(flush_rq, error);
 		spin_lock_irqsave(&q->mq_flush_lock, flags);
 	}
 	running = &q->flush_queue[q->flush_running_idx];
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 93563e0..423089d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -270,7 +270,7 @@ void blk_mq_free_request(struct request *rq)
 }
 EXPORT_SYMBOL(blk_mq_free_request);
 
-static void blk_mq_finish_request(struct request *rq, int error)
+void blk_mq_finish_request(struct request *rq, int error)
 {
 	struct bio *bio = rq->bio;
 	unsigned int bytes = 0;
@@ -286,17 +286,22 @@ static void blk_mq_finish_request(struct request *rq, int error)
 
 	blk_account_io_completion(rq, bytes);
 	blk_account_io_done(rq);
+	blk_mq_free_request(rq);
 }
 
 void blk_mq_complete_request(struct request *rq, int error)
 {
 	trace_block_rq_complete(rq->q, rq);
-	blk_mq_finish_request(rq, error);
 
+	/*
+	 * If ->end_io is set, it's responsible for doing the rest of the
+	 * completion.
+	 */
 	if (rq->end_io)
 		rq->end_io(rq, error);
 	else
-		blk_mq_free_request(rq);
+		blk_mq_finish_request(rq, error);
+
 }
 
 void __blk_mq_end_io(struct request *rq, int error)
@@ -984,7 +989,8 @@ int blk_mq_execute_rq(struct request_queue *q, struct request *rq)
 	if (rq->errors)
 		err = -EIO;
 
-	blk_mq_free_request(rq);
+	blk_mq_finish_request(rq, rq->errors);
+
 	return err;
 }
 EXPORT_SYMBOL(blk_mq_execute_rq);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 52bf1f9..42d0110 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -27,6 +27,7 @@ void blk_mq_complete_request(struct request *rq, int error);
 void blk_mq_run_request(struct request *rq, bool run_queue, bool async);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_init_flush(struct request_queue *q);
+void blk_mq_finish_request(struct request *rq, int error);
 
 /*
  * CPU hotplug helpers
-- 
1.7.10.4


