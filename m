Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbaAHRdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:33:41 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60881 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaAHRdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:33:38 -0500
Date: Wed, 8 Jan 2014 09:33:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] blk-mq: use __smp_call_function_single directly
Message-ID: <20140108173337.GA29514@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__smp_call_function_single already avoids multiple IPIs by internally
queing up the items, and now also is available for non-SMP builds as
a trivially correct stub, so there is no need to wrap it.  If the
additional lock roundtrip cause problems my patch to convert the
generic IPI code to llists is waiting to get merged will fix it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-cpu.c |   31 ------------------------
 block/blk-mq.c     |   68 +++++++++-------------------------------------------
 block/blk-mq.h     |    1 -
 3 files changed, 11 insertions(+), 89 deletions(-)

diff --git a/block/blk-mq-cpu.c b/block/blk-mq-cpu.c
index 0045ace..20576e3 100644
--- a/block/blk-mq-cpu.c
+++ b/block/blk-mq-cpu.c
@@ -28,32 +28,6 @@ static int blk_mq_main_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static void blk_mq_cpu_notify(void *data, unsigned long action,
-			      unsigned int cpu)
-{
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		/*
-		 * If the CPU goes away, ensure that we run any pending
-		 * completions.
-		 */
-		struct llist_node *node;
-		struct request *rq;
-
-		local_irq_disable();
-
-		node = llist_del_all(&per_cpu(ipi_lists, cpu));
-		while (node) {
-			struct llist_node *next = node->next;
-
-			rq = llist_entry(node, struct request, ll_list);
-			__blk_mq_end_io(rq, rq->errors);
-			node = next;
-		}
-
-		local_irq_enable();
-	}
-}
-
 static struct notifier_block __cpuinitdata blk_mq_main_cpu_notifier = {
 	.notifier_call	= blk_mq_main_cpu_notify,
 };
@@ -82,12 +56,7 @@ void blk_mq_init_cpu_notifier(struct blk_mq_cpu_notifier *notifier,
 	notifier->data = data;
 }
 
-static struct blk_mq_cpu_notifier __cpuinitdata cpu_notifier = {
-	.notify = blk_mq_cpu_notify,
-};
-
 void __init blk_mq_cpu_init(void)
 {
 	register_hotcpu_notifier(&blk_mq_main_cpu_notifier);
-	blk_mq_register_cpu_notifier(&cpu_notifier);
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c79126e..ac383ea 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -27,8 +27,6 @@ static LIST_HEAD(all_q_list);
 
 static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx);
 
-DEFINE_PER_CPU(struct llist_head, ipi_lists);
-
 static struct blk_mq_ctx *__blk_mq_get_ctx(struct request_queue *q,
 					   unsigned int cpu)
 {
@@ -326,55 +324,12 @@ void __blk_mq_end_io(struct request *rq, int error)
 		blk_mq_complete_request(rq, error);
 }
 
-#if defined(CONFIG_SMP)
-
-/*
- * Called with interrupts disabled.
- */
-static void ipi_end_io(void *data)
+static void blk_mq_end_io_remote(void *data)
 {
-	struct llist_head *list = &per_cpu(ipi_lists, smp_processor_id());
-	struct llist_node *entry, *next;
-	struct request *rq;
-
-	entry = llist_del_all(list);
-
-	while (entry) {
-		next = entry->next;
-		rq = llist_entry(entry, struct request, ll_list);
-		__blk_mq_end_io(rq, rq->errors);
-		entry = next;
-	}
-}
-
-static int ipi_remote_cpu(struct blk_mq_ctx *ctx, const int cpu,
-			  struct request *rq, const int error)
-{
-	struct call_single_data *data = &rq->csd;
-
-	rq->errors = error;
-	rq->ll_list.next = NULL;
-
-	/*
-	 * If the list is non-empty, an existing IPI must already
-	 * be "in flight". If that is the case, we need not schedule
-	 * a new one.
-	 */
-	if (llist_add(&rq->ll_list, &per_cpu(ipi_lists, ctx->cpu))) {
-		data->func = ipi_end_io;
-		data->flags = 0;
-		__smp_call_function_single(ctx->cpu, data, 0);
-	}
+	struct request *rq = data;
 
-	return true;
+	__blk_mq_end_io(rq, rq->errors);
 }
-#else /* CONFIG_SMP */
-static int ipi_remote_cpu(struct blk_mq_ctx *ctx, const int cpu,
-			  struct request *rq, const int error)
-{
-	return false;
-}
-#endif
 
 /*
  * End IO on this request on a multiqueue enabled driver. We'll either do
@@ -390,11 +345,15 @@ void blk_mq_end_io(struct request *rq, int error)
 		return __blk_mq_end_io(rq, error);
 
 	cpu = get_cpu();
-
-	if (cpu == ctx->cpu || !cpu_online(ctx->cpu) ||
-	    !ipi_remote_cpu(ctx, cpu, rq, error))
+	if (cpu != ctx->cpu && cpu_online(ctx->cpu)) {
+		rq->errors = error;
+		rq->csd.func = blk_mq_end_io_remote;
+		rq->csd.info = rq;
+		rq->csd.flags = 0;
+		__smp_call_function_single(ctx->cpu, &rq->csd, 0);
+	} else {
 		__blk_mq_end_io(rq, error);
-
+	}
 	put_cpu();
 }
 EXPORT_SYMBOL(blk_mq_end_io);
@@ -1495,11 +1454,6 @@ static int blk_mq_queue_reinit_notify(struct notifier_block *nb,
 
 static int __init blk_mq_init(void)
 {
-	unsigned int i;
-
-	for_each_possible_cpu(i)
-		init_llist_head(&per_cpu(ipi_lists, i));
-
 	blk_mq_cpu_init();
 
 	/* Must be called after percpu_counter_hotcpu_callback() */
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 52bf1f9..5761eed 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -38,7 +38,6 @@ void blk_mq_init_cpu_notifier(struct blk_mq_cpu_notifier *notifier,
 void blk_mq_register_cpu_notifier(struct blk_mq_cpu_notifier *notifier);
 void blk_mq_unregister_cpu_notifier(struct blk_mq_cpu_notifier *notifier);
 void blk_mq_cpu_init(void);
-DECLARE_PER_CPU(struct llist_head, ipi_lists);
 
 /*
  * CPU -> queue mappings
-- 
1.7.10.4

