Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaEJEAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 00:00:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64865 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaEJEAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 00:00:33 -0400
Date: Sat, 10 May 2014 12:00:23 +0800
From: Shaohua Li <shli@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [patch]blk-mq: blk_mq_tag_to_rq should handle flush request
Message-ID: <20140510040023.GA13788@kernel.org>
References: <20140509120733.GA27918@kernel.org>
 <20140509150018.GA26215@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509150018.GA26215@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 08:00:18AM -0700, Christoph Hellwig wrote:
> On Fri, May 09, 2014 at 08:07:33PM +0800, Shaohua Li wrote:
> > 
> > flush request is special, which borrows tag from other request. Need a special
> > handling to get it from tag.
> 
> Thanks, we probably need this one.  But I think you can simply test
> REQ_FLUSH_SEQ the passed in request instead of the flush_rq_tag_valid
> flag/

fair enough. updated one.

 
Subject: blk-mq: blk_mq_tag_to_rq should handle flush request

flush request is special, which borrows tag from other request. Need a special
handling to get it from tag.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/blk-flush.c                 |    4 +++-
 block/blk-mq.c                    |    8 ++++++--
 drivers/block/mtip32xx/mtip32xx.c |    2 +-
 include/linux/blk-mq.h            |    3 ++-
 4 files changed, 12 insertions(+), 5 deletions(-)

Index: linux/block/blk-flush.c
===================================================================
--- linux.orig/block/blk-flush.c	2014-05-10 11:49:21.646830000 +0800
+++ linux/block/blk-flush.c	2014-05-10 11:49:21.638830100 +0800
@@ -231,8 +231,10 @@ static void flush_end_io(struct request
 	struct request *rq, *n;
 	unsigned long flags = 0;
 
-	if (q->mq_ops)
+	if (q->mq_ops) {
 		spin_lock_irqsave(&q->mq_flush_lock, flags);
+		q->flush_rq->cmd_flags = 0;
+	}
 
 	running = &q->flush_queue[q->flush_running_idx];
 	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
Index: linux/block/blk-mq.c
===================================================================
--- linux.orig/block/blk-mq.c	2014-05-10 11:49:21.646830000 +0800
+++ linux/block/blk-mq.c	2014-05-10 11:49:21.638830100 +0800
@@ -481,8 +481,12 @@ void blk_mq_requeue_request(struct reque
 }
 EXPORT_SYMBOL(blk_mq_requeue_request);
 
-struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
+struct request *blk_mq_tag_to_rq(struct request_queue *q,
+	struct blk_mq_tags *tags, unsigned int tag)
 {
+	if ((q->flush_rq->cmd_flags & REQ_FLUSH_SEQ) &&
+	    q->flush_rq->tag == tag)
+		return q->flush_rq;
 	return tags->rqs[tag];
 }
 EXPORT_SYMBOL(blk_mq_tag_to_rq);
@@ -512,7 +516,7 @@ static void blk_mq_timeout_check(void *_
 		if (tag >= hctx->tags->nr_tags)
 			break;
 
-		rq = blk_mq_tag_to_rq(hctx->tags, tag++);
+		rq = blk_mq_tag_to_rq(hctx->queue, hctx->tags, tag++);
 		if (rq->q != hctx->queue)
 			continue;
 		if (!test_bit(REQ_ATOM_STARTED, &rq->atomic_flags))
Index: linux/include/linux/blk-mq.h
===================================================================
--- linux.orig/include/linux/blk-mq.h	2014-05-10 11:49:21.646830000 +0800
+++ linux/include/linux/blk-mq.h	2014-05-10 11:49:21.638830100 +0800
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
--- linux.orig/drivers/block/mtip32xx/mtip32xx.c	2014-05-10 11:49:21.646830000 +0800
+++ linux/drivers/block/mtip32xx/mtip32xx.c	2014-05-10 11:49:21.638830100 +0800
@@ -195,7 +195,7 @@ static struct request *mtip_rq_from_tag(
 {
 	struct blk_mq_hw_ctx *hctx = dd->queue->queue_hw_ctx[0];
 
-	return blk_mq_tag_to_rq(hctx->tags, tag);
+	return blk_mq_tag_to_rq(dd->queue, hctx->tags, tag);
 }
 
 static struct mtip_cmd *mtip_cmd_from_tag(struct driver_data *dd,
