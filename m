Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbaDWQKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:10:07 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64941 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbaDWQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:10:03 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>
Subject: [RFC PATCH] blk-mq: use hctx->nr_ctx to compute size of percpu tag cache
Date: Thu, 24 Apr 2014 00:09:46 +0800
Message-Id: <1398269386-15479-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea behind the patch is simple: if there are only
part of CPUs mapped to one hw queue, set the size of
percpu tag cache as total tags divided by count of these CPUs,
instead of all CPUs, then percpu tag allocation will
become more efficient than before.

The change is a bit complicated, because:

	- Christoph introduces tag set, so the tags can be shared
	by more than one request queue, and the patch delays
	tags' allocation until request queue's initialization 

	- hctx->nr_ctx's computing need to take account of cpu
	hotplug

With the patch, the below test on one quad core SMP VM:

	#modprobe null_blk irqmode=2 hw_queue_depth=16 submit_queues=4

shows percpu tag allocation is much more efficient than before,
	- for boot CPU, allocation from local CPU increases from ~5% to ~50%
	- for non-boot CPUs, allocation from local CPU increases from ~30% to ~90%

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq-tag.c     |    9 ++--
 block/blk-mq-tag.h     |    4 +-
 block/blk-mq.c         |  124 +++++++++++++++++++++++++++++++++---------------
 include/linux/blk-mq.h |    1 +
 include/linux/blkdev.h |    1 +
 5 files changed, 98 insertions(+), 41 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 7a799c4..117d3cc 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -104,10 +104,11 @@ void blk_mq_tag_busy_iter(struct blk_mq_tags *tags,
 	kfree(tag_map);
 }
 
-struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
+struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_hw_ctx *hctx,
+				     unsigned int total_tags,
 				     unsigned int reserved_tags, int node)
 {
-	unsigned int nr_tags, nr_cache;
+	unsigned int nr_tags, nr_cache, nr_cnt;
 	struct blk_mq_tags *tags;
 	int ret;
 
@@ -121,7 +122,9 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 		return NULL;
 
 	nr_tags = total_tags - reserved_tags;
-	nr_cache = nr_tags / num_possible_cpus();
+
+	nr_cnt = hctx->nr_ctx ? hctx->nr_ctx : 1;
+	nr_cache = nr_tags / nr_cnt;
 
 	if (nr_cache < BLK_MQ_TAG_CACHE_MIN)
 		nr_cache = BLK_MQ_TAG_CACHE_MIN;
diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
index b602e3f..2796a8d 100644
--- a/block/blk-mq-tag.h
+++ b/block/blk-mq-tag.h
@@ -20,7 +20,9 @@ struct blk_mq_tags {
 };
 
 
-extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsigned int reserved_tags, int node);
+extern struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_hw_ctx *hctx,
+				     unsigned int total_tags,
+				     unsigned int reserved_tags, int node);
 extern void blk_mq_free_tags(struct blk_mq_tags *tags);
 
 extern unsigned int blk_mq_get_tag(struct blk_mq_tags *tags, gfp_t gfp, bool reserved);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index cea1bd8..29f61e2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1107,6 +1107,9 @@ static void blk_mq_free_rq_map(struct blk_mq_tag_set *set,
 {
 	struct page *page;
 
+	if (!tags)
+		return;
+
 	if (tags->rqs && set->ops->exit_request) {
 		int i;
 
@@ -1135,14 +1138,15 @@ static size_t order_to_size(unsigned int order)
 }
 
 static struct blk_mq_tags *blk_mq_init_rq_map(struct blk_mq_tag_set *set,
-		unsigned int hctx_idx)
+		struct blk_mq_hw_ctx *hctx)
 {
 	struct blk_mq_tags *tags;
 	unsigned int i, j, entries_per_page, max_order = 4;
 	size_t rq_size, left;
+	unsigned int hctx_idx = hctx->queue_num;
 
-	tags = blk_mq_init_tags(set->queue_depth, set->reserved_tags,
-				set->numa_node);
+	tags = blk_mq_init_tags(hctx, set->queue_depth,
+				set->reserved_tags, set->numa_node);
 	if (!tags)
 		return NULL;
 
@@ -1216,11 +1220,30 @@ fail:
 	return NULL;
 }
 
+static void blk_mq_deinit_hw_queues(struct request_queue *q,
+		struct blk_mq_tag_set *set, unsigned int end)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int j;
+
+	queue_for_each_hw_ctx(q, hctx, j) {
+		if (end == j)
+			break;
+
+		if (set->ops->exit_hctx)
+			set->ops->exit_hctx(hctx, j);
+
+		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
+		kfree(hctx->ctxs);
+		kfree(hctx->ctx_map);
+	}
+}
+
 static int blk_mq_init_hw_queues(struct request_queue *q,
 		struct blk_mq_tag_set *set)
 {
 	struct blk_mq_hw_ctx *hctx;
-	unsigned int i, j;
+	unsigned int i;
 
 	/*
 	 * Initialize hardware queues
@@ -1274,22 +1297,58 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 	if (i == q->nr_hw_queues)
 		return 0;
 
-	/*
-	 * Init failed
-	 */
-	queue_for_each_hw_ctx(q, hctx, j) {
-		if (i == j)
-			break;
+	blk_mq_deinit_hw_queues(q, set, i);
 
-		if (set->ops->exit_hctx)
-			set->ops->exit_hctx(hctx, j);
+	return 1;
+}
 
-		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
-		kfree(hctx->ctxs);
-		kfree(hctx->ctx_map);
+static DEFINE_MUTEX(hw_postinit);
+
+static int blk_mq_postinit_hw_queues(struct request_queue *q,
+		struct blk_mq_tag_set *set)
+{
+	int ret = 0;
+	struct blk_mq_hw_ctx *hctx;
+	int i;
+
+	/* allocate tag for each hw queue in need */
+	mutex_lock(&hw_postinit);
+	if (set->flags & BLK_MQ_F_TAG_ALLOCATED)
+		goto out;
+	set->flags |= BLK_MQ_F_TAG_ALLOCATED;
+
+	for (i = 0; i < set->nr_hw_queues; i++) {
+		hctx = q->queue_hw_ctx[i];
+		set->tags[i] = blk_mq_init_rq_map(set, hctx);
+		if (!set->tags[i]) {
+			mutex_unlock(&hw_postinit);
+			ret = -ENOMEM;
+			goto out_unwind;
+		}
+		hctx->tags = set->tags[i];
 	}
+ out:
+	mutex_unlock(&hw_postinit);
+	return ret;
 
-	return 1;
+ out_unwind:
+	while (--i >= 0)
+		blk_mq_free_rq_map(set, set->tags[i], i);
+	return ret;
+}
+
+static void __blk_mq_free_tags(struct blk_mq_tag_set *set)
+{
+	int i;
+
+	for (i = 0; i < set->nr_hw_queues; i++) {
+		blk_mq_free_rq_map(set, set->tags[i], i);
+		set->tags[i] = NULL;
+	}
+
+	mutex_lock(&hw_postinit);
+	set->flags &= ~BLK_MQ_F_TAG_ALLOCATED;
+	mutex_unlock(&hw_postinit);
 }
 
 static void blk_mq_init_cpu_queues(struct request_queue *q,
@@ -1396,6 +1455,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	q->queue_ctx = ctx;
 	q->queue_hw_ctx = hctxs;
 
+	q->set = set;
 	q->mq_ops = set->ops;
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
 
@@ -1423,12 +1483,17 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 
 	blk_mq_map_swqueue(q);
 
+	if (blk_mq_postinit_hw_queues(q, set))
+		goto err_hw_init;
+
 	mutex_lock(&all_q_mutex);
 	list_add_tail(&q->all_q_node, &all_q_list);
 	mutex_unlock(&all_q_mutex);
 
 	return q;
 
+err_hw_init:
+	blk_mq_deinit_hw_queues(q, set, set->nr_hw_queues);
 err_flush_rq:
 	kfree(q->flush_rq);
 err_hw:
@@ -1492,6 +1557,9 @@ static void blk_mq_queue_reinit(struct request_queue *q)
 
 	blk_mq_map_swqueue(q);
 
+	__blk_mq_free_tags(q->set);
+	blk_mq_postinit_hw_queues(q, q->set);
+
 	blk_mq_unfreeze_queue(q);
 }
 
@@ -1519,8 +1587,6 @@ static int blk_mq_queue_reinit_notify(struct notifier_block *nb,
 
 int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 {
-	int i;
-
 	if (!set->nr_hw_queues)
 		return -EINVAL;
 	if (!set->queue_depth || set->queue_depth > BLK_MQ_MAX_DEPTH)
@@ -1534,34 +1600,18 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 		return -EINVAL;
 
 
-	set->tags = kmalloc_node(set->nr_hw_queues *
+	set->tags = kzalloc_node(set->nr_hw_queues *
 				 sizeof(struct blk_mq_tags *),
 				 GFP_KERNEL, set->numa_node);
 	if (!set->tags)
-		goto out;
-
-	for (i = 0; i < set->nr_hw_queues; i++) {
-		set->tags[i] = blk_mq_init_rq_map(set, i);
-		if (!set->tags[i])
-			goto out_unwind;
-	}
-
+		return -ENOMEM;
 	return 0;
-
-out_unwind:
-	while (--i >= 0)
-		blk_mq_free_rq_map(set, set->tags[i], i);
-out:
-	return -ENOMEM;
 }
 EXPORT_SYMBOL(blk_mq_alloc_tag_set);
 
 void blk_mq_free_tag_set(struct blk_mq_tag_set *set)
 {
-	int i;
-
-	for (i = 0; i < set->nr_hw_queues; i++)
-		blk_mq_free_rq_map(set, set->tags[i], i);
+	__blk_mq_free_tags(set);
 	kfree(set->tags);
 }
 EXPORT_SYMBOL(blk_mq_free_tag_set);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index ab469d5..7fb0b15 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -123,6 +123,7 @@ enum {
 	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
 	BLK_MQ_F_SHOULD_SORT	= 1 << 1,
 	BLK_MQ_F_SHOULD_IPI	= 1 << 2,
+	BLK_MQ_F_TAG_ALLOCATED	= 1 << 3,
 
 	BLK_MQ_S_STOPPED	= 0,
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 74ee55f..b6278f2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -330,6 +330,7 @@ struct request_queue {
 	dma_drain_needed_fn	*dma_drain_needed;
 	lld_busy_fn		*lld_busy_fn;
 
+	struct blk_mq_tag_set	*set;
 	struct blk_mq_ops	*mq_ops;
 
 	unsigned int		*mq_map;
-- 
1.7.9.5

