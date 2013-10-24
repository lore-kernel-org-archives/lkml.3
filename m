Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab3JXPY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:24:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52878 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab3JXPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:23:15 -0400
Message-Id: <20131024152313.505323357@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 24 Oct 2013 08:19:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] Revert: "softirq: Add support for triggering softirq work on softirqs"
References: <20131024151921.537751910@bombadil.infradead.org>
Content-Disposition: inline; filename=0001-Revert-softirq-Add-support-for-triggering-softirq-wo.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit was incomplete in that code to remove items from the per-cpu
lists was missing and never acquired a user in the 5 years it has been
in the tree.  We're going to implement what it seems to try to archive
in a simpler way, and this code is in the way of doing so.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/interrupt.h |   22 --------
 kernel/softirq.c          |  131 ---------------------------------------------
 2 files changed, 153 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5e865b5..8c0d4ba 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -11,8 +11,6 @@
 #include <linux/irqnr.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
-#include <linux/smp.h>
-#include <linux/percpu.h>
 #include <linux/hrtimer.h>
 #include <linux/kref.h>
 #include <linux/workqueue.h>
@@ -381,15 +379,6 @@ extern void __raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
 
-/* This is the worklist that queues up per-cpu softirq work.
- *
- * send_remote_sendirq() adds work to these lists, and
- * the softirq handler itself dequeues from them.  The queues
- * are protected by disabling local cpu interrupts and they must
- * only be accessed by the local cpu that they are for.
- */
-DECLARE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
-
 DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
 
 static inline struct task_struct *this_cpu_ksoftirqd(void)
@@ -397,17 +386,6 @@ static inline struct task_struct *this_cpu_ksoftirqd(void)
 	return this_cpu_read(ksoftirqd);
 }
 
-/* Try to send a softirq to a remote cpu.  If this cannot be done, the
- * work will be queued to the local cpu.
- */
-extern void send_remote_softirq(struct call_single_data *cp, int cpu, int softirq);
-
-/* Like send_remote_softirq(), but the caller must disable local cpu interrupts
- * and compute the current cpu, passed in as 'this_cpu'.
- */
-extern void __send_remote_softirq(struct call_single_data *cp, int cpu,
-				  int this_cpu, int softirq);
-
 /* Tasklets --- multithreaded analogue of BHs.
 
    Main feature differing them of generic softirqs: tasklet
diff --git a/kernel/softirq.c b/kernel/softirq.c
index d7d498d..c587b7f 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -6,8 +6,6 @@
  *	Distribute under GPLv2.
  *
  *	Rewritten. Old one was good in 2.2, but in 2.3 it was immoral. --ANK (990903)
- *
- *	Remote softirq infrastructure is by Jens Axboe.
  */
 
 #include <linux/export.h>
@@ -618,146 +616,17 @@ void tasklet_hrtimer_init(struct tasklet_hrtimer *ttimer,
 }
 EXPORT_SYMBOL_GPL(tasklet_hrtimer_init);
 
-/*
- * Remote softirq bits
- */
-
-DEFINE_PER_CPU(struct list_head [NR_SOFTIRQS], softirq_work_list);
-EXPORT_PER_CPU_SYMBOL(softirq_work_list);
-
-static void __local_trigger(struct call_single_data *cp, int softirq)
-{
-	struct list_head *head = &__get_cpu_var(softirq_work_list[softirq]);
-
-	list_add_tail(&cp->list, head);
-
-	/* Trigger the softirq only if the list was previously empty.  */
-	if (head->next == &cp->list)
-		raise_softirq_irqoff(softirq);
-}
-
-#ifdef CONFIG_USE_GENERIC_SMP_HELPERS
-static void remote_softirq_receive(void *data)
-{
-	struct call_single_data *cp = data;
-	unsigned long flags;
-	int softirq;
-
-	softirq = *(int *)cp->info;
-	local_irq_save(flags);
-	__local_trigger(cp, softirq);
-	local_irq_restore(flags);
-}
-
-static int __try_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
-{
-	if (cpu_online(cpu)) {
-		cp->func = remote_softirq_receive;
-		cp->info = &softirq;
-		cp->flags = 0;
-
-		__smp_call_function_single(cpu, cp, 0);
-		return 0;
-	}
-	return 1;
-}
-#else /* CONFIG_USE_GENERIC_SMP_HELPERS */
-static int __try_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
-{
-	return 1;
-}
-#endif
-
-/**
- * __send_remote_softirq - try to schedule softirq work on a remote cpu
- * @cp: private SMP call function data area
- * @cpu: the remote cpu
- * @this_cpu: the currently executing cpu
- * @softirq: the softirq for the work
- *
- * Attempt to schedule softirq work on a remote cpu.  If this cannot be
- * done, the work is instead queued up on the local cpu.
- *
- * Interrupts must be disabled.
- */
-void __send_remote_softirq(struct call_single_data *cp, int cpu, int this_cpu, int softirq)
-{
-	if (cpu == this_cpu || __try_remote_softirq(cp, cpu, softirq))
-		__local_trigger(cp, softirq);
-}
-EXPORT_SYMBOL(__send_remote_softirq);
-
-/**
- * send_remote_softirq - try to schedule softirq work on a remote cpu
- * @cp: private SMP call function data area
- * @cpu: the remote cpu
- * @softirq: the softirq for the work
- *
- * Like __send_remote_softirq except that disabling interrupts and
- * computing the current cpu is done for the caller.
- */
-void send_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
-{
-	unsigned long flags;
-	int this_cpu;
-
-	local_irq_save(flags);
-	this_cpu = smp_processor_id();
-	__send_remote_softirq(cp, cpu, this_cpu, softirq);
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL(send_remote_softirq);
-
-static int remote_softirq_cpu_notify(struct notifier_block *self,
-					       unsigned long action, void *hcpu)
-{
-	/*
-	 * If a CPU goes away, splice its entries to the current CPU
-	 * and trigger a run of the softirq
-	 */
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		int cpu = (unsigned long) hcpu;
-		int i;
-
-		local_irq_disable();
-		for (i = 0; i < NR_SOFTIRQS; i++) {
-			struct list_head *head = &per_cpu(softirq_work_list[i], cpu);
-			struct list_head *local_head;
-
-			if (list_empty(head))
-				continue;
-
-			local_head = &__get_cpu_var(softirq_work_list[i]);
-			list_splice_init(head, local_head);
-			raise_softirq_irqoff(i);
-		}
-		local_irq_enable();
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block remote_softirq_cpu_notifier = {
-	.notifier_call	= remote_softirq_cpu_notify,
-};
-
 void __init softirq_init(void)
 {
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		int i;
-
 		per_cpu(tasklet_vec, cpu).tail =
 			&per_cpu(tasklet_vec, cpu).head;
 		per_cpu(tasklet_hi_vec, cpu).tail =
 			&per_cpu(tasklet_hi_vec, cpu).head;
-		for (i = 0; i < NR_SOFTIRQS; i++)
-			INIT_LIST_HEAD(&per_cpu(softirq_work_list[i], cpu));
 	}
 
-	register_hotcpu_notifier(&remote_softirq_cpu_notifier);
-
 	open_softirq(TASKLET_SOFTIRQ, tasklet_action);
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
 }
-- 
1.7.10.4


