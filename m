Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaE0S5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:57:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:39264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaE0S5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:57:39 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] blk-mq: merge blk_mq_alloc_reserved_request into blk_mq_alloc_request
Date: Tue, 27 May 2014 20:59:46 +0200
Message-Id: <1401217190-32453-2-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401217190-32453-1-git-send-email-hch@lst.de>
References: <1401217190-32453-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of having two almost identical copies of the same code just let
the callers pass in the reserved flag directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c                  |    2 +-
 block/blk-mq.c                    |   20 +++-----------------
 drivers/block/mtip32xx/mtip32xx.c |    2 +-
 include/linux/blk-mq.h            |    4 ++--
 4 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 29d5fba..d87be5b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1173,7 +1173,7 @@ static struct request *blk_old_get_request(struct request_queue *q, int rw,
 struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 {
 	if (q->mq_ops)
-		return blk_mq_alloc_request(q, rw, gfp_mask);
+		return blk_mq_alloc_request(q, rw, gfp_mask, false);
 	else
 		return blk_old_get_request(q, rw, gfp_mask);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 30bad93..f8f84e2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -294,35 +294,21 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 	return rq;
 }
 
-struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp)
+struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp,
+		bool reserved)
 {
 	struct request *rq;
 
 	if (blk_mq_queue_enter(q))
 		return NULL;
 
-	rq = blk_mq_alloc_request_pinned(q, rw, gfp, false);
+	rq = blk_mq_alloc_request_pinned(q, rw, gfp, reserved);
 	if (rq)
 		blk_mq_put_ctx(rq->mq_ctx);
 	return rq;
 }
 EXPORT_SYMBOL(blk_mq_alloc_request);
 
-struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw,
-					      gfp_t gfp)
-{
-	struct request *rq;
-
-	if (blk_mq_queue_enter(q))
-		return NULL;
-
-	rq = blk_mq_alloc_request_pinned(q, rw, gfp, true);
-	if (rq)
-		blk_mq_put_ctx(rq->mq_ctx);
-	return rq;
-}
-EXPORT_SYMBOL(blk_mq_alloc_reserved_request);
-
 static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
 				  struct blk_mq_ctx *ctx, struct request *rq)
 {
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index ae331ab..ea323e9 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -178,7 +178,7 @@ static struct mtip_cmd *mtip_get_int_command(struct driver_data *dd)
 {
 	struct request *rq;
 
-	rq = blk_mq_alloc_reserved_request(dd->queue, 0, __GFP_WAIT);
+	rq = blk_mq_alloc_request(dd->queue, 0, __GFP_WAIT, true);
 	return blk_mq_rq_to_pdu(rq);
 }
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index afeb934..2aefc3c 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -160,8 +160,8 @@ void blk_mq_insert_request(struct request *, bool, bool, bool);
 void blk_mq_run_queues(struct request_queue *q, bool async);
 void blk_mq_free_request(struct request *rq);
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
-struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp);
-struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw, gfp_t gfp);
+struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
+		gfp_t gfp, bool reserved);
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
 
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_index);
-- 
1.7.10.4

