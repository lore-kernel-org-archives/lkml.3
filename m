Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaE0Pfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:35:50 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:57396 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbaE0Pfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:35:46 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 2/3] blk-mq: avoid code duplication
Date: Tue, 27 May 2014 23:35:13 +0800
Message-Id: <1401204914-3340-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401204914-3340-1-git-send-email-tom.leiming@gmail.com>
References: <1401204914-3340-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_mq_exit_hw_queues() and blk_mq_free_hw_queues()
are introduced to avoid code duplication.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/blk-mq.c |   61 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index dad22a9..0785175 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1523,11 +1523,43 @@ static int blk_mq_hctx_notify(void *data, unsigned long action,
 	return NOTIFY_OK;
 }
 
+static void blk_mq_exit_hw_queues(struct request_queue *q,
+		struct blk_mq_tag_set *set, int nr_queue)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int i;
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		if (i == nr_queue)
+			break;
+
+		if (set->ops->exit_hctx)
+			set->ops->exit_hctx(hctx, i);
+
+		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
+		kfree(hctx->ctxs);
+		blk_mq_free_bitmap(&hctx->ctx_map);
+	}
+
+}
+
+static void blk_mq_free_hw_queues(struct request_queue *q,
+		struct blk_mq_tag_set *set)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int i;
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		free_cpumask_var(hctx->cpumask);
+		set->ops->free_hctx(hctx, i);
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
@@ -1579,17 +1611,7 @@ static int blk_mq_init_hw_queues(struct request_queue *q,
 	/*
 	 * Init failed
 	 */
-	queue_for_each_hw_ctx(q, hctx, j) {
-		if (i == j)
-			break;
-
-		if (set->ops->exit_hctx)
-			set->ops->exit_hctx(hctx, j);
-
-		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
-		kfree(hctx->ctxs);
-		blk_mq_free_bitmap(&hctx->ctx_map);
-	}
+	blk_mq_exit_hw_queues(q, set, i);
 
 	return 1;
 }
@@ -1838,21 +1860,12 @@ EXPORT_SYMBOL(blk_mq_init_queue);
 
 void blk_mq_free_queue(struct request_queue *q)
 {
-	struct blk_mq_hw_ctx *hctx;
-	int i;
+	struct blk_mq_tag_set	*set = q->tag_set;
 
 	blk_mq_del_queue_tag_set(q);
 
-	queue_for_each_hw_ctx(q, hctx, i) {
-		blk_mq_tag_idle(hctx);
-		kfree(hctx->ctxs);
-		blk_mq_free_bitmap(&hctx->ctx_map);
-		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
-		if (q->mq_ops->exit_hctx)
-			q->mq_ops->exit_hctx(hctx, i);
-		free_cpumask_var(hctx->cpumask);
-		q->mq_ops->free_hctx(hctx, i);
-	}
+	blk_mq_exit_hw_queues(q, set, set->nr_hw_queues);
+	blk_mq_free_hw_queues(q, set);
 
 	free_percpu(q->queue_ctx);
 	kfree(q->queue_hw_ctx);
-- 
1.7.9.5

