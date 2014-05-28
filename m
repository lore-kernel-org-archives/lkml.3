Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaE1QIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:08:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:43570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbaE1QIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:08:53 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] blk-mq: remove alloc_hctx and free_hctx methods
Date: Wed, 28 May 2014 18:11:06 +0200
Message-Id: <1401293466-24155-1-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.7.10.4
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for drivers to control hardware context allocation
now that we do the context to node mapping in common code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c                    |   26 +++++---------------------
 drivers/block/mtip32xx/mtip32xx.c |    2 --
 drivers/block/null_blk.c          |   28 +---------------------------
 drivers/block/virtio_blk.c        |    2 --
 include/linux/blk-mq.h            |   10 ----------
 5 files changed, 6 insertions(+), 62 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 67066ec..fc3331a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1360,21 +1360,6 @@ struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q, const int cpu)
 }
 EXPORT_SYMBOL(blk_mq_map_queue);
 
-struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *set,
-						   unsigned int hctx_index,
-						   int node)
-{
-	return kzalloc_node(sizeof(struct blk_mq_hw_ctx), GFP_KERNEL, node);
-}
-EXPORT_SYMBOL(blk_mq_alloc_single_hw_queue);
-
-void blk_mq_free_single_hw_queue(struct blk_mq_hw_ctx *hctx,
-				 unsigned int hctx_index)
-{
-	kfree(hctx);
-}
-EXPORT_SYMBOL(blk_mq_free_single_hw_queue);
-
 static void blk_mq_free_rq_map(struct blk_mq_tag_set *set,
 		struct blk_mq_tags *tags, unsigned int hctx_idx)
 {
@@ -1615,7 +1600,7 @@ static void blk_mq_free_hw_queues(struct request_queue *q,
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		free_cpumask_var(hctx->cpumask);
-		set->ops->free_hctx(hctx, i);
+		kfree(hctx);
 	}
 }
 
@@ -1836,7 +1821,8 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	for (i = 0; i < set->nr_hw_queues; i++) {
 		int node = blk_mq_hw_queue_to_node(map, i);
 
-		hctxs[i] = set->ops->alloc_hctx(set, i, node);
+		hctxs[i] = kzalloc_node(sizeof(struct blk_mq_hw_ctx),
+					GFP_KERNEL, node);
 		if (!hctxs[i])
 			goto err_hctxs;
 
@@ -1923,7 +1909,7 @@ err_hctxs:
 		if (!hctxs[i])
 			break;
 		free_cpumask_var(hctxs[i]->cpumask);
-		set->ops->free_hctx(hctxs[i], i);
+		kfree(hctxs[i]);
 	}
 err_map:
 	kfree(hctxs);
@@ -2008,9 +1994,7 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 	if (set->queue_depth < set->reserved_tags + BLK_MQ_TAG_MIN)
 		return -EINVAL;
 
-	if (!set->nr_hw_queues ||
-	    !set->ops->queue_rq || !set->ops->map_queue ||
-	    !set->ops->alloc_hctx || !set->ops->free_hctx)
+	if (!set->nr_hw_queues || !set->ops->queue_rq || !set->ops->map_queue)
 		return -EINVAL;
 
 
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index ae331ab..ea975ee 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3832,8 +3832,6 @@ static int mtip_init_cmd(void *data, struct request *rq, unsigned int hctx_idx,
 static struct blk_mq_ops mtip_mq_ops = {
 	.queue_rq	= mtip_queue_rq,
 	.map_queue	= blk_mq_map_queue,
-	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
-	.free_hctx	= blk_mq_free_single_hw_queue,
 	.init_request	= mtip_init_cmd,
 	.exit_request	= mtip_free_cmd,
 };
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 5a80811..77087a2 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -321,18 +321,6 @@ static int null_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *rq)
 	return BLK_MQ_RQ_QUEUE_OK;
 }
 
-static struct blk_mq_hw_ctx *null_alloc_hctx(struct blk_mq_tag_set *set,
-					     unsigned int hctx_index,
-					     int node)
-{
-	return kzalloc_node(sizeof(struct blk_mq_hw_ctx), GFP_KERNEL, node);
-}
-
-static void null_free_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_index)
-{
-	kfree(hctx);
-}
-
 static void null_init_queue(struct nullb *nullb, struct nullb_queue *nq)
 {
 	BUG_ON(!nullb);
@@ -360,17 +348,6 @@ static struct blk_mq_ops null_mq_ops = {
 	.map_queue      = blk_mq_map_queue,
 	.init_hctx	= null_init_hctx,
 	.complete	= null_softirq_done_fn,
-	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
-	.free_hctx	= blk_mq_free_single_hw_queue,
-};
-
-static struct blk_mq_ops null_mq_ops_pernode = {
-	.queue_rq       = null_queue_rq,
-	.map_queue      = blk_mq_map_queue,
-	.init_hctx	= null_init_hctx,
-	.complete	= null_softirq_done_fn,
-	.alloc_hctx	= null_alloc_hctx,
-	.free_hctx	= null_free_hctx,
 };
 
 static void null_del_dev(struct nullb *nullb)
@@ -496,10 +473,7 @@ static int null_add_dev(void)
 		goto out_free_nullb;
 
 	if (queue_mode == NULL_Q_MQ) {
-		if (use_per_node_hctx)
-			nullb->tag_set.ops = &null_mq_ops_pernode;
-		else
-			nullb->tag_set.ops = &null_mq_ops;
+		nullb->tag_set.ops = &null_mq_ops;
 		nullb->tag_set.nr_hw_queues = submit_queues;
 		nullb->tag_set.queue_depth = hw_queue_depth;
 		nullb->tag_set.numa_node = home_node;
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 9f340fa..c8f286e 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -497,8 +497,6 @@ static int virtblk_init_request(void *data, struct request *rq,
 static struct blk_mq_ops virtio_mq_ops = {
 	.queue_rq	= virtio_queue_rq,
 	.map_queue	= blk_mq_map_queue,
-	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
-	.free_hctx	= blk_mq_free_single_hw_queue,
 	.complete	= virtblk_request_done,
 	.init_request	= virtblk_init_request,
 };
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index b9a74a3..50a1ea0 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -79,9 +79,6 @@ struct blk_mq_tag_set {
 
 typedef int (queue_rq_fn)(struct blk_mq_hw_ctx *, struct request *);
 typedef struct blk_mq_hw_ctx *(map_queue_fn)(struct request_queue *, const int);
-typedef struct blk_mq_hw_ctx *(alloc_hctx_fn)(struct blk_mq_tag_set *,
-		unsigned int, int);
-typedef void (free_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
 typedef int (init_hctx_fn)(struct blk_mq_hw_ctx *, void *, unsigned int);
 typedef void (exit_hctx_fn)(struct blk_mq_hw_ctx *, unsigned int);
 typedef int (init_request_fn)(void *, struct request *, unsigned int,
@@ -108,12 +105,6 @@ struct blk_mq_ops {
 	softirq_done_fn		*complete;
 
 	/*
-	 * Override for hctx allocations (should probably go)
-	 */
-	alloc_hctx_fn		*alloc_hctx;
-	free_hctx_fn		*free_hctx;
-
-	/*
 	 * Called when the block layer side of a hardware queue has been
 	 * set up, allowing the driver to allocate/init matching structures.
 	 * Ditto for exit/teardown.
@@ -166,7 +157,6 @@ struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
 
 struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *, const int ctx_index);
 struct blk_mq_hw_ctx *blk_mq_alloc_single_hw_queue(struct blk_mq_tag_set *, unsigned int, int);
-void blk_mq_free_single_hw_queue(struct blk_mq_hw_ctx *, unsigned int);
 
 void blk_mq_end_io(struct request *rq, int error);
 void __blk_mq_end_io(struct request *rq, int error);
-- 
1.7.10.4

