Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaIMDIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 23:08:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45398 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaIMDIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 23:08:36 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v3 10/10] blk-mq: support per-distpatch_queue flush machinery
Date: Sat, 13 Sep 2014 11:07:54 +0800
Message-Id: <1410577674-17019-11-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410577674-17019-1-git-send-email-ming.lei@canonical.com>
References: <1410577674-17019-1-git-send-email-ming.lei@canonical.com>
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
 block/blk-core.c       |    2 +-
 block/blk-flush.c      |   13 +++++++------
 block/blk-mq.c         |   30 ++++++++++++++++++++++++------
 block/blk.h            |   16 +++++++++++++---
 include/linux/blk-mq.h |    2 ++
 5 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0238c02..122781e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -703,7 +703,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	if (!q)
 		return NULL;
 
-	q->fq = blk_alloc_flush_queue(q);
+	q->fq = blk_alloc_flush_queue(q, NULL, 0);
 	if (!q->fq)
 		return NULL;
 
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 8ca65fb..6786934 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -482,22 +482,23 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL(blkdev_issue_flush);
 
-struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q)
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
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index eb4a90a..9437a7d 100644
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
+	if (!hctx->fq)
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
@@ -1869,16 +1893,10 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 
 	blk_mq_add_queue_tag_set(set, q);
 
-	q->fq = blk_alloc_flush_queue(q);
-	if (!q->fq)
-		goto err_hw_queues;
-
 	blk_mq_map_swqueue(q);
 
 	return q;
 
-err_hw_queues:
-	blk_mq_exit_hw_queues(q, set, set->nr_hw_queues);
 err_hw:
 	blk_cleanup_queue(q);
 err_hctxs:
diff --git a/block/blk.h b/block/blk.h
index b58c5d9..9051637 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -2,6 +2,8 @@
 #define BLK_INTERNAL_H
 
 #include <linux/idr.h>
+#include <linux/blk-mq.h>
+#include "blk-mq.h"
 
 /* Amount of time in which a process may batch requests */
 #define BLK_BATCH_TIME	(HZ/50UL)
@@ -31,7 +33,14 @@ extern struct ida blk_queue_ida;
 static inline struct blk_flush_queue *blk_get_flush_queue(
 		struct request_queue *q, struct blk_mq_ctx *ctx)
 {
-	return q->fq;
+	struct blk_mq_hw_ctx *hctx;
+
+	if (!q->mq_ops)
+		return q->fq;
+
+	hctx = q->mq_ops->map_queue(q, ctx->cpu);
+
+	return hctx->fq;
 }
 
 static inline void __blk_get_queue(struct request_queue *q)
@@ -39,8 +48,9 @@ static inline void __blk_get_queue(struct request_queue *q)
 	kobject_get(&q->kobj);
 }
 
-struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q);
-void blk_free_flush_queue(struct blk_flush_queue *fq);
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

