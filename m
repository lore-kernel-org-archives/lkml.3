Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaILOsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:48:22 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54566 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaILOsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:48:18 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 9/9] blk-mq: support per-distpatch_queue flush machinery
Date: Fri, 12 Sep 2014 22:47:33 +0800
Message-Id: <1410533253-8045-10-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410533253-8045-1-git-send-email-ming.lei@canonical.com>
References: <1410533253-8045-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports to run one single flush machinery for
each blk-mq dispatch queue, so that:

- current init_request and exit_request callbacks can
cover flush request too, then the buggy copying way of
initializing flush request's pdu can be fixed

- flushing performance gets improved in case of multi hw-queue

In fio sync write test over virtio-blk(4 hw queues, ioengine=sync,
iodepth=64, numjobs=4, bs=4K), it is observed that througput gets
increased a lot over my test environment:
	- throughput: +70% in case of virtio-blk over null_blk
	- throughput: +30% in case of virtio-blk over SSD image

The multi virtqueue feature isn't merged to QEMU yet, and patches for
the feature can be found in below tree:

	git://kernel.ubuntu.com/ming/qemu.git  	v2.1.0-mq.3

And simply passing 'num_queues=4 vectors=5' should be enough to
enable multi queue(quad queue) feature for QEMU virtio-blk.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-flush.c      |   18 +++++++++---------
 block/blk-mq.c         |   24 ++++++++++++++++++++++++
 block/blk.h            |   15 ++++++++++++++-
 include/linux/blk-mq.h |    2 ++
 4 files changed, 49 insertions(+), 10 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index f8cc690..3da32ca 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -482,23 +482,23 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL(blkdev_issue_flush);
 
-static struct blk_flush_queue *blk_alloc_flush_queue(
-		struct request_queue *q)
+struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx, int cmd_size)
 {
 	struct blk_flush_queue *fq;
 	int rq_sz = sizeof(struct request);
+	int node = hctx ? hctx->numa_node : NUMA_NO_NODE;
 
-	fq = kzalloc(sizeof(*fq), GFP_KERNEL);
+	fq = kzalloc_node(sizeof(*fq), GFP_KERNEL, node);
 	if (!fq)
 		goto fail;
 
-	if (q->mq_ops) {
+	if (hctx) {
 		spin_lock_init(&fq->mq_flush_lock);
-		rq_sz = round_up(rq_sz + q->tag_set->cmd_size,
-				cache_line_size());
+		rq_sz = round_up(rq_sz + cmd_size, cache_line_size());
 	}
 
-	fq->flush_rq = kzalloc(rq_sz, GFP_KERNEL);
+	fq->flush_rq = kzalloc_node(rq_sz, GFP_KERNEL, node);
 	if (!fq->flush_rq)
 		goto fail_rq;
 
@@ -514,7 +514,7 @@ static struct blk_flush_queue *blk_alloc_flush_queue(
 	return ERR_PTR(-ENOMEM);
 }
 
-static void blk_free_flush_queue(struct blk_flush_queue *fq)
+void blk_free_flush_queue(struct blk_flush_queue *fq)
 {
 	kfree(fq->flush_rq);
 	kfree(fq);
@@ -522,7 +522,7 @@ static void blk_free_flush_queue(struct blk_flush_queue *fq)
 
 int blk_init_flush(struct request_queue *q)
 {
-	q->fq = blk_alloc_flush_queue(q);
+	q->fq = blk_alloc_flush_queue(q, NULL, 0);
 	if (IS_ERR(q->fq))
 		return PTR_ERR(q->fq);
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index afb0dfe..5a0da6d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1531,12 +1531,20 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 		struct blk_mq_tag_set *set,
 		struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
 {
+	unsigned flush_start_tag = set->queue_depth;
+
 	blk_mq_tag_idle(hctx);
 
+	if (set->ops->exit_request)
+		set->ops->exit_request(set->driver_data,
+				       hctx->fq->flush_rq, hctx_idx,
+				       flush_start_tag + hctx_idx);
+
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
 
 	blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
+	blk_free_flush_queue(hctx->fq);
 	kfree(hctx->ctxs);
 	blk_mq_free_bitmap(&hctx->ctx_map);
 }
@@ -1571,6 +1579,7 @@ static int blk_mq_init_hctx(struct request_queue *q,
 		struct blk_mq_hw_ctx *hctx, unsigned hctx_idx)
 {
 	int node;
+	unsigned flush_start_tag = set->queue_depth;
 
 	node = hctx->numa_node;
 	if (node == NUMA_NO_NODE)
@@ -1609,8 +1618,23 @@ static int blk_mq_init_hctx(struct request_queue *q,
 	    set->ops->init_hctx(hctx, set->driver_data, hctx_idx))
 		goto free_bitmap;
 
+	hctx->fq = blk_alloc_flush_queue(q, hctx, set->cmd_size);
+	if (IS_ERR(hctx->fq))
+		goto exit_hctx;
+
+	if (set->ops->init_request &&
+	    set->ops->init_request(set->driver_data,
+				   hctx->fq->flush_rq, hctx_idx,
+				   flush_start_tag + hctx_idx, node))
+		goto free_fq;
+
 	return 0;
 
+ free_fq:
+	kfree(hctx->fq);
+ exit_hctx:
+	if (set->ops->exit_hctx)
+		set->ops->exit_hctx(hctx, hctx_idx);
  free_bitmap:
 	blk_mq_free_bitmap(&hctx->ctx_map);
  free_ctxs:
diff --git a/block/blk.h b/block/blk.h
index 30f8033..9f39b0d 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -2,6 +2,8 @@
 #define BLK_INTERNAL_H
 
 #include <linux/idr.h>
+#include <linux/blk-mq.h>
+#include "blk-mq.h"
 
 /* Amount of time in which a process may batch requests */
 #define BLK_BATCH_TIME	(HZ/50UL)
@@ -31,7 +33,15 @@ extern struct ida blk_queue_ida;
 static inline struct blk_flush_queue *blk_get_flush_queue(
 		struct request_queue *q, struct blk_mq_ctx *ctx)
 {
-	return q->fq;
+	struct blk_mq_hw_ctx *hctx;
+
+	if (!q->mq_ops)
+		return q->fq;
+
+	WARN_ON(!ctx);
+	hctx = q->mq_ops->map_queue(q, ctx->cpu);
+
+	return hctx->fq;
 }
 
 static inline void __blk_get_queue(struct request_queue *q)
@@ -41,6 +51,9 @@ static inline void __blk_get_queue(struct request_queue *q)
 
 int blk_init_flush(struct request_queue *q);
 void blk_exit_flush(struct request_queue *q);
+struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx, int cmd_size);
+void blk_free_flush_queue(struct blk_flush_queue *q);
 
 int blk_init_rl(struct request_list *rl, struct request_queue *q,
 		gfp_t gfp_mask);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a1e31f2..1f3c523 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -4,6 +4,7 @@
 #include <linux/blkdev.h>
 
 struct blk_mq_tags;
+struct blk_flush_queue;
 
 struct blk_mq_cpu_notifier {
 	struct list_head list;
@@ -34,6 +35,7 @@ struct blk_mq_hw_ctx {
 
 	struct request_queue	*queue;
 	unsigned int		queue_num;
+	struct blk_flush_queue	*fq;
 
 	void			*driver_data;
 
-- 
1.7.9.5

