Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaIJEOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:14:39 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64882 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaIJEOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:14:35 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 8/8] blk-mq: support per-distpatch_queue flush machinery
Date: Wed, 10 Sep 2014 12:13:31 +0800
Message-Id: <1410322411-17389-9-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410322411-17389-1-git-send-email-ming.lei@canonical.com>
References: <1410322411-17389-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports to run one single lush machinery for
each blk-mq dispatch queue, so that:

- current init_request and exit_request callbacks can
cover flush request too, then the buggy copying way of
initializing flush request's pdu can be fixed

- flushing performance gets improved in case of multi hw-queue

In both fio write and randwrite test over virtio-blk(4 hw queues,
backed by nullblk) with sync=1, ioengine=sync, iodepth=64, numjobs=4,
it is observed that througput gets increased by 70% in the VM
over my laptop environment.

The multi virtqueue feature isn't merged to QEMU yet, and patches for
the feature can be found in below tree:

	git://kernel.ubuntu.com/ming/qemu.git  	v2.1.0-mq.3

And simply passing 'num_queues=4 vectors=5' should be enough to
enable multi queue feature for QEMU virtio-blk.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-flush.c      |   86 ++++++++++++++++++++++++++++++++++++++++++++----
 block/blk.h            |   12 ++++++-
 include/linux/blk-mq.h |    2 ++
 3 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index f8cc690..6a43b1c 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -483,22 +483,23 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 EXPORT_SYMBOL(blkdev_issue_flush);
 
 static struct blk_flush_queue *blk_alloc_flush_queue(
-		struct request_queue *q)
+		struct request_queue *q, struct blk_mq_hw_ctx *hctx)
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
 		rq_sz = round_up(rq_sz + q->tag_set->cmd_size,
 				cache_line_size());
 	}
 
-	fq->flush_rq = kzalloc(rq_sz, GFP_KERNEL);
+	fq->flush_rq = kzalloc_node(rq_sz, GFP_KERNEL, node);
 	if (!fq->flush_rq)
 		goto fail_rq;
 
@@ -520,9 +521,79 @@ static void blk_free_flush_queue(struct blk_flush_queue *fq)
 	kfree(fq);
 }
 
+static void __blk_mq_exit_flush(struct request_queue *q,
+		unsigned free_end, unsigned int exit_end)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int k;
+	struct blk_flush_queue *fq;
+	struct blk_mq_tag_set *set = q->tag_set;
+	unsigned start_idx = set->queue_depth;
+
+	queue_for_each_hw_ctx(q, hctx, k) {
+		if (k >= free_end)
+			break;
+
+		fq = hctx->fq;
+		if (k < exit_end && set->ops->exit_request)
+			set->ops->exit_request(set->driver_data,
+					fq->flush_rq, k,
+					start_idx + k);
+
+		blk_free_flush_queue(fq);
+	}
+
+}
+
+static int blk_mq_init_flush(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int i, j = 0;
+	struct blk_flush_queue *fq;
+	struct blk_mq_tag_set *set = q->tag_set;
+	unsigned start_idx = set->queue_depth;
+	int ret;
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		fq = blk_alloc_flush_queue(q, hctx);
+		if (IS_ERR(fq)) {
+			ret = PTR_ERR(fq);
+			goto fail;
+		}
+
+		hctx->fq = fq;
+	}
+	queue_for_each_hw_ctx(q, hctx, j) {
+		fq = hctx->fq;
+		if (set->ops->init_request) {
+			ret = set->ops->init_request(set->driver_data,
+					fq->flush_rq, j, start_idx + j,
+					hctx->numa_node);
+			if (ret)
+				goto fail;
+		}
+	}
+
+	return 0;
+
+ fail:
+	__blk_mq_exit_flush(q, i, j);
+	return ret;
+}
+
+static void blk_mq_exit_flush(struct request_queue *q)
+{
+	struct blk_mq_tag_set *set = q->tag_set;
+
+	__blk_mq_exit_flush(q, set->nr_hw_queues, set->nr_hw_queues);
+}
+
 int blk_init_flush(struct request_queue *q)
 {
-	q->fq = blk_alloc_flush_queue(q);
+	if (q->mq_ops)
+		return blk_mq_init_flush(q);
+
+	q->fq = blk_alloc_flush_queue(q, NULL);
 	if (IS_ERR(q->fq))
 		return PTR_ERR(q->fq);
 
@@ -531,5 +602,8 @@ int blk_init_flush(struct request_queue *q)
 
 void blk_exit_flush(struct request_queue *q)
 {
-	blk_free_flush_queue(q->fq);
+	if (q->mq_ops)
+		blk_mq_exit_flush(q);
+	else
+		blk_free_flush_queue(q->fq);
 }
diff --git a/block/blk.h b/block/blk.h
index 30f8033..dd9489f 100644
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

