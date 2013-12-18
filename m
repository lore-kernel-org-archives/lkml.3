Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3LRMme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:42:34 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:49920 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3LRMl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:41:57 -0500
From: Matias Bjorling <m@bjorling.me>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH 2/3] null_blk: refactor init and init errors code paths
Date: Wed, 18 Dec 2013 13:41:43 +0100
Message-Id: <1387370504-30853-3-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387370504-30853-1-git-send-email-m@bjorling.me>
References: <1387370504-30853-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the initialization logic of the three block-layers.

- The queue initialization is split into two parts. This allows reuse of
  code when initializing the sq-, bio- and mq-based layers.
- Set submit_queues default value to 0 and always set it at init time.
- Simplify the init error code paths.

Signed-off-by: Matias Bjorling <m@bjorling.me>
---
 drivers/block/null_blk.c | 63 +++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 25 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index f370fc1..f0aeb2a 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -65,7 +65,7 @@ enum {
 	NULL_Q_MQ		= 2,
 };
 
-static int submit_queues = 1;
+static int submit_queues;
 module_param(submit_queues, int, S_IRUGO);
 MODULE_PARM_DESC(submit_queues, "Number of submission queues");
 
@@ -355,16 +355,24 @@ static void null_free_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_index)
 	kfree(hctx);
 }
 
+static void null_init_queue(struct nullb *nullb, struct nullb_queue *nq)
+{
+	BUG_ON(!nullb);
+	BUG_ON(!nq);
+
+	init_waitqueue_head(&nq->wait);
+	nq->queue_depth = nullb->queue_depth;
+}
+
 static int null_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 			  unsigned int index)
 {
 	struct nullb *nullb = data;
 	struct nullb_queue *nq = &nullb->queues[index];
 
-	init_waitqueue_head(&nq->wait);
-	nq->queue_depth = nullb->queue_depth;
-	nullb->nr_queues++;
 	hctx->driver_data = nq;
+	null_init_queue(nullb, nq);
+	nullb->nr_queues++;
 
 	return 0;
 }
@@ -417,13 +425,13 @@ static int setup_commands(struct nullb_queue *nq)
 
 	nq->cmds = kzalloc(nq->queue_depth * sizeof(*cmd), GFP_KERNEL);
 	if (!nq->cmds)
-		return 1;
+		return -ENOMEM;
 
 	tag_size = ALIGN(nq->queue_depth, BITS_PER_LONG) / BITS_PER_LONG;
 	nq->tag_map = kzalloc(tag_size * sizeof(unsigned long), GFP_KERNEL);
 	if (!nq->tag_map) {
 		kfree(nq->cmds);
-		return 1;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < nq->queue_depth; i++) {
@@ -454,33 +462,37 @@ static void cleanup_queues(struct nullb *nullb)
 
 static int setup_queues(struct nullb *nullb)
 {
-	struct nullb_queue *nq;
-	int i;
-
-	nullb->queues = kzalloc(submit_queues * sizeof(*nq), GFP_KERNEL);
+	nullb->queues = kzalloc(submit_queues * sizeof(struct nullb_queue),
+								GFP_KERNEL);
 	if (!nullb->queues)
-		return 1;
+		return -ENOMEM;
 
 	nullb->nr_queues = 0;
 	nullb->queue_depth = hw_queue_depth;
 
-	if (queue_mode == NULL_Q_MQ)
-		return 0;
+	return 0;
+}
+
+static int init_driver_queues(struct nullb *nullb)
+{
+	struct nullb_queue *nq;
+	int i, ret = 0;
 
 	for (i = 0; i < submit_queues; i++) {
 		nq = &nullb->queues[i];
-		init_waitqueue_head(&nq->wait);
-		nq->queue_depth = hw_queue_depth;
-		if (setup_commands(nq))
-			break;
+
+		null_init_queue(nullb, nq);
+
+		ret = setup_commands(nq);
+		if (ret)
+			goto err_queue;
 		nullb->nr_queues++;
 	}
 
-	if (i == submit_queues)
-		return 0;
-
+	return 0;
+err_queue:
 	cleanup_queues(nullb);
-	return 1;
+	return ret;
 }
 
 static int null_add_dev(void)
@@ -495,9 +507,6 @@ static int null_add_dev(void)
 
 	spin_lock_init(&nullb->lock);
 
-	if (queue_mode == NULL_Q_MQ && use_per_node_hctx)
-		submit_queues = nr_online_nodes;
-
 	if (setup_queues(nullb))
 		goto err;
 
@@ -518,11 +527,13 @@ static int null_add_dev(void)
 	} else if (queue_mode == NULL_Q_BIO) {
 		nullb->q = blk_alloc_queue_node(GFP_KERNEL, home_node);
 		blk_queue_make_request(nullb->q, null_queue_bio);
+		init_driver_queues(nullb);
 	} else {
 		nullb->q = blk_init_queue_node(null_request_fn, &nullb->lock, home_node);
 		blk_queue_prep_rq(nullb->q, null_rq_prep_fn);
 		if (nullb->q)
 			blk_queue_softirq_done(nullb->q, null_softirq_done_fn);
+		init_driver_queues(nullb);
 	}
 
 	if (!nullb->q)
@@ -579,7 +590,9 @@ static int __init null_init(void)
 	}
 #endif
 
-	if (submit_queues > nr_cpu_ids)
+	if (queue_mode == NULL_Q_MQ && use_per_node_hctx)
+		submit_queues = nr_online_nodes;
+	else if (submit_queues > nr_cpu_ids)
 		submit_queues = nr_cpu_ids;
 	else if (!submit_queues)
 		submit_queues = 1;
-- 
1.8.3.2

