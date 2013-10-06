Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3JFPYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 11:24:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab3JFPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 11:24:11 -0400
Message-Id: <20131006152410.524512593@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Sun, 06 Oct 2013 08:22:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] blk-mq: dont call blk_mq_free_request from blk_mq_finish_request
References: <20131006152237.612666544@bombadil.infradead.org>
Content-Disposition: inline; filename=0002-blk-mq-don-t-call-blk_mq_free_request-from-blk_mq_fi.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

These are fundamentally different operations, so keep them separate.

[hch: split up and reworded the changelog]

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-flush.c |    1 +
 block/blk-mq.c    |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index c56c37d..d835243 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -232,6 +232,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 
 	if (q->mq_ops) {
 		blk_mq_finish_request(flush_rq, error);
+		blk_mq_free_request(flush_rq);
 		spin_lock_irqsave(&q->mq_flush_lock, flags);
 	}
 	running = &q->flush_queue[q->flush_running_idx];
diff --git a/block/blk-mq.c b/block/blk-mq.c
index d2e568e..9c32719 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -300,7 +300,6 @@ void blk_mq_finish_request(struct request *rq, int error)
 
 	blk_account_io_completion(rq, bytes);
 	blk_account_io_done(rq);
-	blk_mq_free_request(rq);
 }
 
 void blk_mq_complete_request(struct request *rq, int error)
@@ -313,8 +312,10 @@ void blk_mq_complete_request(struct request *rq, int error)
 	 */
 	if (rq->end_io)
 		rq->end_io(rq, error);
-	else
+	else {
 		blk_mq_finish_request(rq, error);
+		blk_mq_free_request(rq);
+	}
 
 }
 
-- 
1.7.10.4


