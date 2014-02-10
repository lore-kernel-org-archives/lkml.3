Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaBJL1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:27:40 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44243 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaBJL0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:26:49 -0500
Message-Id: <20140210112649.692674410@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 03:24:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] null_blk: use blk_complete_request and blk_mq_complete_request
References: <20140210112437.858399303@bombadil.infradead.org>
Content-Disposition: inline; filename=0003-null_blk-use-blk_complete_request-and-blk_mq_complet.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the block layer helpers for CPU-local completions instead of
reimplementing them locally.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/null_blk.c |   97 +++++++++++++++-------------------------------
 1 file changed, 32 insertions(+), 65 deletions(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index cc801cd..091b9ea 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -60,7 +60,9 @@ enum {
 	NULL_IRQ_NONE		= 0,
 	NULL_IRQ_SOFTIRQ	= 1,
 	NULL_IRQ_TIMER		= 2,
+};
 
+enum {
 	NULL_Q_BIO		= 0,
 	NULL_Q_RQ		= 1,
 	NULL_Q_MQ		= 2,
@@ -172,18 +174,20 @@ static struct nullb_cmd *alloc_cmd(struct nullb_queue *nq, int can_wait)
 
 static void end_cmd(struct nullb_cmd *cmd)
 {
-	if (cmd->rq) {
-		if (queue_mode == NULL_Q_MQ)
-			blk_mq_end_io(cmd->rq, 0);
-		else {
-			INIT_LIST_HEAD(&cmd->rq->queuelist);
-			blk_end_request_all(cmd->rq, 0);
-		}
-	} else if (cmd->bio)
+	switch (queue_mode)  {
+	case NULL_Q_MQ:
+		blk_mq_end_io(cmd->rq, 0);
+		return;
+	case NULL_Q_RQ:
+		INIT_LIST_HEAD(&cmd->rq->queuelist);
+		blk_end_request_all(cmd->rq, 0);
+		break;
+	case NULL_Q_BIO:
 		bio_endio(cmd->bio, 0);
+		break;
+	}
 
-	if (queue_mode != NULL_Q_MQ)
-		free_cmd(cmd);
+	free_cmd(cmd);
 }
 
 static enum hrtimer_restart null_cmd_timer_expired(struct hrtimer *timer)
@@ -222,62 +226,31 @@ static void null_cmd_end_timer(struct nullb_cmd *cmd)
 
 static void null_softirq_done_fn(struct request *rq)
 {
-	blk_end_request_all(rq, 0);
-}
-
-#ifdef CONFIG_SMP
-
-static void null_ipi_cmd_end_io(void *data)
-{
-	struct completion_queue *cq;
-	struct llist_node *entry, *next;
-	struct nullb_cmd *cmd;
-
-	cq = &per_cpu(completion_queues, smp_processor_id());
-
-	entry = llist_del_all(&cq->list);
-	entry = llist_reverse_order(entry);
-
-	while (entry) {
-		next = entry->next;
-		cmd = llist_entry(entry, struct nullb_cmd, ll_list);
-		end_cmd(cmd);
-		entry = next;
-	}
-}
-
-static void null_cmd_end_ipi(struct nullb_cmd *cmd)
-{
-	struct call_single_data *data = &cmd->csd;
-	int cpu = get_cpu();
-	struct completion_queue *cq = &per_cpu(completion_queues, cpu);
-
-	cmd->ll_list.next = NULL;
-
-	if (llist_add(&cmd->ll_list, &cq->list)) {
-		data->func = null_ipi_cmd_end_io;
-		data->flags = 0;
-		__smp_call_function_single(cpu, data, 0);
-	}
-
-	put_cpu();
+	end_cmd(rq->special);
 }
 
-#endif /* CONFIG_SMP */
-
 static inline void null_handle_cmd(struct nullb_cmd *cmd)
 {
 	/* Complete IO by inline, softirq or timer */
 	switch (irqmode) {
-	case NULL_IRQ_NONE:
-		end_cmd(cmd);
-		break;
 	case NULL_IRQ_SOFTIRQ:
-#ifdef CONFIG_SMP
-		null_cmd_end_ipi(cmd);
-#else
+		switch (queue_mode)  {
+		case NULL_Q_MQ:
+			blk_mq_complete_request(cmd->rq);
+			break;
+		case NULL_Q_RQ:
+			blk_complete_request(cmd->rq);
+			break;
+		case NULL_Q_BIO:
+			/*
+			 * XXX: no proper submitting cpu information available.
+			 */
+			end_cmd(cmd);
+			break;
+		}
+		break;
+	case NULL_IRQ_NONE:
 		end_cmd(cmd);
-#endif
 		break;
 	case NULL_IRQ_TIMER:
 		null_cmd_end_timer(cmd);
@@ -413,6 +386,7 @@ static struct blk_mq_ops null_mq_ops = {
 	.queue_rq       = null_queue_rq,
 	.map_queue      = blk_mq_map_queue,
 	.init_hctx	= null_init_hctx,
+	.complete	= null_softirq_done_fn,
 };
 
 static struct blk_mq_reg null_mq_reg = {
@@ -611,13 +585,6 @@ static int __init null_init(void)
 {
 	unsigned int i;
 
-#if !defined(CONFIG_SMP)
-	if (irqmode == NULL_IRQ_SOFTIRQ) {
-		pr_warn("null_blk: softirq completions not available.\n");
-		pr_warn("null_blk: using direct completions.\n");
-		irqmode = NULL_IRQ_NONE;
-	}
-#endif
 	if (bs > PAGE_SIZE) {
 		pr_warn("null_blk: invalid block size\n");
 		pr_warn("null_blk: defaults block size to %lu\n", PAGE_SIZE);
-- 
1.7.10.4


