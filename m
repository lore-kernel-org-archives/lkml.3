Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaIONMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:12:32 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61910 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaIONLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:11:54 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v4 09/10] blk-mq: handle failure path for initializing hctx
Date: Mon, 15 Sep 2014 21:11:13 +0800
Message-Id: <1410786675-7761-10-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410786675-7761-1-git-send-email-ming.lei@canonical.com>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Failure of initializing one hctx isn't handled, so this patch
introduces blk_mq_init_hctx() and its pair to handle it explicitly.
Also this patch makes code cleaner.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c |  114 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 45 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3106328..eb4a90a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1527,6 +1527,20 @@ static int blk_mq_hctx_notify(void *data, unsigned long action,
 	return NOTIFY_OK;
 }
 
+static void blk_mq_exit_hctx(struct request_queue *q,
+		struct blk_mq_tag_set *set,
+		struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
+{
+	blk_mq_tag_idle(hctx);
+
+	if (set->ops->exit_hctx)
+		set->ops->exit_hctx(hctx, hctx_idx);
+
+	blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
+	kfree(hctx->ctxs);
+	blk_mq_free_bitmap(&hctx->ctx_map);
+}
+
 static void blk_mq_exit_hw_queues(struct request_queue *q,
 		struct blk_mq_tag_set *set, int nr_queue)
 {
@@ -1536,17 +1550,8 @@ static void blk_mq_exit_hw_queues(struct request_queue *q,
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (i == nr_queue)
 			break;
-
-		blk_mq_tag_idle(hctx);
-
-		if (set->ops->exit_hctx)
-			set->ops->exit_hctx(hctx, i);
-
-		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
-		kfree(hctx->ctxs);
-		blk_mq_free_bitmap(&hctx->ctx_map);
+		blk_mq_exit_hctx(q, set, hctx, i);
 	}
-
 }
 
 static void blk_mq_free_hw_queues(struct request_queue *q,
@@ -1561,53 +1566,72 @@ static void blk_mq_free_hw_queues(struct request_queue *q,
 	}
 }
 
-static int blk_mq_init_hw_queues(struct request_queue *q,
-		struct blk_mq_tag_set *set)
+static int blk_mq_init_hctx(struct request_queue *q,
+		struct blk_mq_tag_set *set,
+		struct blk_mq_hw_ctx *hctx, unsigned hctx_idx)
 {
-	struct blk_mq_hw_ctx *hctx;
-	unsigned int i;
+	int node;
+
+	node = hctx->numa_node;
+	if (node == NUMA_NO_NODE)
+		node = hctx->numa_node = set->numa_node;
+
+	INIT_DELAYED_WORK(&hctx->run_work, blk_mq_run_work_fn);
+	INIT_DELAYED_WORK(&hctx->delay_work, blk_mq_delay_work_fn);
+	spin_lock_init(&hctx->lock);
+	INIT_LIST_HEAD(&hctx->dispatch);
+	hctx->queue = q;
+	hctx->queue_num = hctx_idx;
+	hctx->flags = set->flags;
+	hctx->cmd_size = set->cmd_size;
+
+	blk_mq_init_cpu_notifier(&hctx->cpu_notifier,
+					blk_mq_hctx_notify, hctx);
+	blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
+
+	hctx->tags = set->tags[hctx_idx];
 
 	/*
-	 * Initialize hardware queues
+	 * Allocate space for all possible cpus to avoid allocation at
+	 * runtime
 	 */
-	queue_for_each_hw_ctx(q, hctx, i) {
-		int node;
+	hctx->ctxs = kmalloc_node(nr_cpu_ids * sizeof(void *),
+					GFP_KERNEL, node);
+	if (!hctx->ctxs)
+		goto unregister_cpu_notifier;
 
-		node = hctx->numa_node;
-		if (node == NUMA_NO_NODE)
-			node = hctx->numa_node = set->numa_node;
+	if (blk_mq_alloc_bitmap(&hctx->ctx_map, node))
+		goto free_ctxs;
 
-		INIT_DELAYED_WORK(&hctx->run_work, blk_mq_run_work_fn);
-		INIT_DELAYED_WORK(&hctx->delay_work, blk_mq_delay_work_fn);
-		spin_lock_init(&hctx->lock);
-		INIT_LIST_HEAD(&hctx->dispatch);
-		hctx->queue = q;
-		hctx->queue_num = i;
-		hctx->flags = set->flags;
-		hctx->cmd_size = set->cmd_size;
+	hctx->nr_ctx = 0;
 
-		blk_mq_init_cpu_notifier(&hctx->cpu_notifier,
-						blk_mq_hctx_notify, hctx);
-		blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
+	if (set->ops->init_hctx &&
+	    set->ops->init_hctx(hctx, set->driver_data, hctx_idx))
+		goto free_bitmap;
 
-		hctx->tags = set->tags[i];
+	return 0;
 
-		/*
-		 * Allocate space for all possible cpus to avoid allocation at
-		 * runtime
-		 */
-		hctx->ctxs = kmalloc_node(nr_cpu_ids * sizeof(void *),
-						GFP_KERNEL, node);
-		if (!hctx->ctxs)
-			break;
+ free_bitmap:
+	blk_mq_free_bitmap(&hctx->ctx_map);
+ free_ctxs:
+	kfree(hctx->ctxs);
+ unregister_cpu_notifier:
+	blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
 
-		if (blk_mq_alloc_bitmap(&hctx->ctx_map, node))
-			break;
+	return -1;
+}
 
-		hctx->nr_ctx = 0;
+static int blk_mq_init_hw_queues(struct request_queue *q,
+		struct blk_mq_tag_set *set)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int i;
 
-		if (set->ops->init_hctx &&
-		    set->ops->init_hctx(hctx, set->driver_data, i))
+	/*
+	 * Initialize hardware queues
+	 */
+	queue_for_each_hw_ctx(q, hctx, i) {
+		if (blk_mq_init_hctx(q, set, hctx, i))
 			break;
 	}
 
-- 
1.7.9.5

