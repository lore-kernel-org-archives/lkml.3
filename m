Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3JFPYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 11:24:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60746 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3JFPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 11:24:11 -0400
Message-Id: <20131006152410.938932914@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Sun, 06 Oct 2013 08:22:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] blk-mq: kill blk_mq_finish_request
References: <20131006152237.612666544@bombadil.infradead.org>
Content-Disposition: inline; filename=0004-blk-mq-kill-blk_mq_finish_request.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can be merged into the only caller, and doing so allows accounting for
I/O completion in the correct place as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c137541..99a600e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -284,11 +284,13 @@ static void blk_mq_bio_endio(struct request *rq, struct bio *bio, int error)
 		bio_endio(bio, error);
 }
 
-static void blk_mq_finish_request(struct request *rq, int error)
+void blk_mq_complete_request(struct request *rq, int error)
 {
 	struct bio *bio = rq->bio;
 	unsigned int bytes = 0;
 
+	trace_block_rq_complete(rq->q, rq);
+
 	while (bio) {
 		struct bio *next = bio->bi_next;
 
@@ -299,19 +301,13 @@ static void blk_mq_finish_request(struct request *rq, int error)
 	}
 
 	blk_account_io_completion(rq, bytes);
-	blk_account_io_done(rq);
-}
-
-void blk_mq_complete_request(struct request *rq, int error)
-{
-	trace_block_rq_complete(rq->q, rq);
-
-	blk_mq_finish_request(rq, error);
 
 	if (rq->end_io)
 		rq->end_io(rq, error);
 	else
 		blk_mq_free_request(rq);
+
+	blk_account_io_done(rq);
 }
 
 void __blk_mq_end_io(struct request *rq, int error)
-- 
1.7.10.4


