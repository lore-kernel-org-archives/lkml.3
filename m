Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3JFPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 11:25:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60747 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab3JFPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 11:24:11 -0400
Message-Id: <20131006152411.068995974@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Sun, 06 Oct 2013 08:22:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] blk-mq: cleanup blk_mq_bio_to_request
References: <20131006152237.612666544@bombadil.infradead.org>
Content-Disposition: inline; filename=0005-blk-mq-cleanup-blk_mq_bio_to_request.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dead code and a dead argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 99a600e..2b85029 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -857,15 +857,8 @@ void blk_mq_insert_requests(struct request_queue *q, struct list_head *list,
 						from_schedule);
 }
 
-static void blk_mq_bio_to_request(struct request_queue *q,
-				  struct request *rq, struct bio *bio)
+static void blk_mq_bio_to_request(struct request *rq, struct bio *bio)
 {
-	unsigned int rw_flags;
-
-	rw_flags = bio_data_dir(bio);
-	if (rw_is_sync(bio->bi_rw))
-		rw_flags |= REQ_SYNC;
-
 	init_request_from_bio(rq, bio);
 	blk_account_io_start(rq, 1);
 }
@@ -915,7 +908,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	hctx->queued++;
 
 	if (unlikely(is_flush_fua)) {
-		blk_mq_bio_to_request(q, rq, bio);
+		blk_mq_bio_to_request(rq, bio);
 		blk_mq_put_ctx(ctx);
 		blk_insert_flush(rq);
 		goto run_queue;
@@ -930,7 +923,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		struct blk_plug *plug = current->plug;
 
 		if (plug) {
-			blk_mq_bio_to_request(q, rq, bio);
+			blk_mq_bio_to_request(rq, bio);
 			if (list_empty(&plug->list))
 				trace_block_plug(q);
 			else if (request_count >= BLK_MAX_REQUEST_COUNT) {
@@ -949,7 +942,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	    blk_mq_attempt_merge(q, ctx, bio))
 		__blk_mq_free_request(hctx, ctx, rq);
 	else {
-		blk_mq_bio_to_request(q, rq, bio);
+		blk_mq_bio_to_request(rq, bio);
 		__blk_mq_insert_request(hctx, rq);
 	}
 
-- 
1.7.10.4


