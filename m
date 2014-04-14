Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaDNIaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:30:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:43819 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaDNI2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:28:06 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 5/7] blk-mq: initialize request on allocation
Date: Mon, 14 Apr 2014 10:30:10 +0200
Message-Id: <1397464212-4454-6-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397464212-4454-1-git-send-email-hch@lst.de>
References: <blk-mq updates>
 <1397464212-4454-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we want to share tag and request allocation between queues we cannot
initialize the request at init/free time, but need to initialize it
at allocation time as it might get used for different queues over its
lifetime.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ef7acc0..1cb7618 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -82,6 +82,7 @@ static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
 	tag = blk_mq_get_tag(hctx->tags, gfp, reserved);
 	if (tag != BLK_MQ_TAG_FAIL) {
 		rq = hctx->rqs[tag];
+		blk_rq_init(hctx->queue, rq);
 		rq->tag = tag;
 
 		return rq;
@@ -254,9 +255,7 @@ static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
 	const int tag = rq->tag;
 	struct request_queue *q = rq->q;
 
-	blk_rq_init(hctx->queue, rq);
 	blk_mq_put_tag(hctx->tags, tag);
-
 	blk_mq_queue_exit(q);
 }
 
@@ -1100,7 +1099,6 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 		left -= to_do * rq_size;
 		for (j = 0; j < to_do; j++) {
 			hctx->rqs[i] = p;
-			blk_rq_init(hctx->queue, hctx->rqs[i]);
 			if (reg->ops->init_request) {
 				error = reg->ops->init_request(driver_data,
 						hctx, hctx->rqs[i], i);
-- 
1.7.10.4

