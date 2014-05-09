Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaEIMHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:07:42 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37491 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaEIMHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:07:40 -0400
Date: Fri, 9 May 2014 20:07:33 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org
Subject: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
Message-ID: <20140509120733.GA27918@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


flush request is special, which borrows tag from other request. Need a special
handling to get it from tag.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/blk-flush.c                 |    4 +++-
 block/blk-mq.c                    |   13 +++++++++++--
 drivers/block/mtip32xx/mtip32xx.c |    2 +-
 include/linux/blk-mq.h            |    3 ++-
 include/linux/blkdev.h            |    1 +
 5 files changed, 18 insertions(+), 5 deletions(-)

Index: linux/block/blk-flush.c
===================================================================
--- linux.orig/block/blk-flush.c	2014-05-09 19:52:25.360415014 +0800
+++ linux/block/blk-flush.c	2014-05-09 19:53:59.795228450 +0800
@@ -231,8 +231,10 @@ static void flush_end_io(struct request
 	struct request *rq, *n;
 	unsigned long flags = 0;
 
-	if (q->mq_ops)
+	if (q->mq_ops) {
 		spin_lock_irqsave(&q->mq_flush_lock, flags);
+		q->flush_rq_tag_valid = false;
+	}
 
 	running = &q->flush_queue[q->flush_running_idx];
 	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
Index: linux/block/blk-mq.c
===================================================================
--- linux.orig/block/blk-mq.c	2014-05-09 19:52:25.360415014 +0800
+++ linux/block/blk-mq.c	2014-05-09 19:57:58.432227506 +0800
@@ -336,6 +336,8 @@ void blk_mq_clone_flush_request(struct r
 
 	flush_rq->mq_ctx = orig_rq->mq_ctx;
 	flush_rq->tag = orig_rq->tag;
+	smp_wmb();
+	orig_rq->q->flush_rq_tag_valid = true;
 	memcpy(blk_mq_rq_to_pdu(flush_rq), blk_mq_rq_to_pdu(orig_rq),
 		hctx->cmd_size);
 }
@@ -481,8 +483,14 @@ void blk_mq_requeue_request(struct reque
 }
 EXPORT_SYMBOL(blk_mq_requeue_request);
 
-struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
+struct request *blk_mq_tag_to_rq(struct request_queue *q,
+	struct blk_mq_tags *tags, unsigned int tag)
 {
+	if (q->flush_rq_tag_valid) {
+		smp_rmb();
+		if (q->flush_rq->tag == tag)
+			return q->flush_rq;
+	}
 	return tags->rqs[tag];
 }
 EXPORT_SYMBOL(blk_mq_tag_to_rq);
@@ -512,7 +520,7 @@ static void blk_mq_timeout_check(void *_
 		if (tag >= hctx->tags->nr_tags)
 			break;
 
-		rq = blk_mq_tag_to_rq(hctx->tags, tag++);
+		rq = blk_mq_tag_to_rq(hctx->queue, hctx->tags, tag++);
 		if (rq->q != hctx->queue)
 			continue;
 		if (!test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
@@ -1510,6 +1518,7 @@ struct request_queue *blk_mq_init_queue(
 				GFP_KERNEL);
 	if (!q->flush_rq)
 		goto err_hw;
+	q->flush_rq_tag_valid = false;
 
 	if (blk_mq_init_hw_queues(q, set))
 		goto err_flush_rq;
Index: linux/include/linux/blk-mq.h
===================================================================
--- linux.orig/include/linux/blk-mq.h	2014-05-09 19:52:25.360415014 +0800
+++ linux/include/linux/blk-mq.h	2014-05-09 19:52:25.352415140 +0800
@@ -149,7 +149,8 @@ void blk_mq_free_request(struct request
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *);
 struct request *blk_mq_alloc_request(struct request_queue *q, int rw, gfp_t gfp);
 struct request *blk_mq_alloc_reserved_request(struct request_queue *q, int rw, gfp_t gfp);
-struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
+struct request *blk_mq_tag_to_rq(struct request_queue *q,
+	struct blk_mq_tags *tags, unsigned int tag);
 
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_index);
 struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *, unsigned int);
Index: linux/drivers/block/mtip32xx/mtip32xx.c
===================================================================
--- linux.orig/drivers/block/mtip32xx/mtip32xx.c	2014-05-09 19:52:25.360415014 +0800
+++ linux/drivers/block/mtip32xx/mtip32xx.c	2014-05-09 19:52:25.352415140 +0800
@@ -195,7 +195,7 @@ static struct request *mtip_rq_from_tag(
 {
 	struct blk_mq_hw_ctx *hctx = dd->queue->queue_hw_ctx[0];
 
-	return blk_mq_tag_to_rq(hctx->tags, tag);
+	return blk_mq_tag_to_rq(dd->queue, hctx->tags, tag);
 }
 
 static struct mtip_cmd *mtip_cmd_from_tag(struct driver_data *dd,
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2014-05-09 19:42:28.000000000 +0800
+++ linux/include/linux/blkdev.h	2014-05-09 19:53:07.591883317 +0800
@@ -461,6 +461,7 @@ struct request_queue {
 	struct list_head	flush_queue[2];
 	struct list_head	flush_data_in_flight;
 	struct request		*flush_rq;
+	bool			flush_rq_tag_valid;
 	spinlock_t		mq_flush_lock;
 
 	struct mutex		sysfs_lock;
