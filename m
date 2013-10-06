Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3JFPYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 11:24:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60745 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3JFPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 11:24:11 -0400
Message-Id: <20131006152410.735625042@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Sun, 06 Oct 2013 08:22:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] blk-mq: always complete bios in blk_mq_complete_request
References: <20131006152237.612666544@bombadil.infradead.org>
Content-Disposition: inline; filename=0003-blk-mq-always-complete-bios-in-blk_mq_complete_reque.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

Complete bios for all requests going through blk_mq_complete_request.

This mirrors the old I/O path and avoids blk-mq special casing in every
->end_io handler.

[hch: split up and reworded the changelog]

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-flush.c |    1 -
 block/blk-mq.c    |   13 ++++---------
 block/blk-mq.h    |    1 -
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index d835243..3e4cc9c 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -231,7 +231,6 @@ static void flush_end_io(struct request *flush_rq, int error)
 	unsigned long flags = 0;
 
 	if (q->mq_ops) {
-		blk_mq_finish_request(flush_rq, error);
 		blk_mq_free_request(flush_rq);
 		spin_lock_irqsave(&q->mq_flush_lock, flags);
 	}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9c32719..c137541 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -284,7 +284,7 @@ static void blk_mq_bio_endio(struct request *rq, struct bio *bio, int error)
 		bio_endio(bio, error);
 }
 
-void blk_mq_finish_request(struct request *rq, int error)
+static void blk_mq_finish_request(struct request *rq, int error)
 {
 	struct bio *bio = rq->bio;
 	unsigned int bytes = 0;
@@ -306,17 +306,12 @@ void blk_mq_complete_request(struct request *rq, int error)
 {
 	trace_block_rq_complete(rq->q, rq);
 
-	/*
-	 * If ->end_io is set, it's responsible for doing the rest of the
-	 * completion.
-	 */
+	blk_mq_finish_request(rq, error);
+
 	if (rq->end_io)
 		rq->end_io(rq, error);
-	else {
-		blk_mq_finish_request(rq, error);
+	else
 		blk_mq_free_request(rq);
-	}
-
 }
 
 void __blk_mq_end_io(struct request *rq, int error)
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 42d0110..52bf1f9 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -27,7 +27,6 @@ void blk_mq_complete_request(struct request *rq, int error);
 void blk_mq_run_request(struct request *rq, bool run_queue, bool async);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_init_flush(struct request_queue *q);
-void blk_mq_finish_request(struct request *rq, int error);
 
 /*
  * CPU hotplug helpers
-- 
1.7.10.4


