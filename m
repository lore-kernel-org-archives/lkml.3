Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaFJPP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:15:28 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44031 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaFJPPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:15:25 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/6] irq_work: Split raised and lazy lists
Date: Tue, 10 Jun 2014 17:15:04 +0200
Message-Id: <1402413309-3415-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An irq work can be handled from two places: from the tick if the work
carries the "lazy" flag and the tick is periodic, or from a self IPI.

We merge all these works in a single list and we use some per cpu latch
to avoid raising a self-IPI when one is already pending.

Now we could do away with this ugly latch if only the list was only made of
non-lazy works. Just enqueueing a work on the empty list would be enough
to know if we need to raise an IPI or not.

Also we are going to implement remote irq work queuing. Then the per CPU
latch will need to become atomic in the global scope. That's too bad
because, here as well, just enqueueing a work on an empty list of
non-lazy works would be enough to know if we need to raise an IPI or not.

So lets take a way out of this: split the works in two distinct lists,
one for the works that can be handled by the next tick and another
one for those handled by the IPI. Just checking if the latter is empty
when we queue a new work is enough to know if we need to raise an IPI.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/irq_work.c | 53 ++++++++++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index a82170e..126f254 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -19,8 +19,8 @@
 #include <asm/processor.h>
 
 
-static DEFINE_PER_CPU(struct llist_head, irq_work_list);
-static DEFINE_PER_CPU(int, irq_work_raised);
+static DEFINE_PER_CPU(struct llist_head, raised_list);
+static DEFINE_PER_CPU(struct llist_head, lazy_list);
 
 /*
  * Claim the entry so that no one else will poke at it.
@@ -70,15 +70,13 @@ bool irq_work_queue(struct irq_work *work)
 	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 
-	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
-
-	/*
-	 * If the work is not "lazy" or the tick is stopped, raise the irq
-	 * work interrupt (if supported by the arch), otherwise, just wait
-	 * for the next tick.
-	 */
-	if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
-		if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
+	/* If the work is "lazy", handle it from next tick if any */
+	if (work->flags & IRQ_WORK_LAZY) {
+		if (llist_add(&work->llnode, &__get_cpu_var(lazy_list)) &&
+		    tick_nohz_tick_stopped())
+			arch_irq_work_raise();
+	} else {
+		if (llist_add(&work->llnode, &__get_cpu_var(raised_list)))
 			arch_irq_work_raise();
 	}
 
@@ -90,10 +88,11 @@ EXPORT_SYMBOL_GPL(irq_work_queue);
 
 bool irq_work_needs_cpu(void)
 {
-	struct llist_head *this_list;
+	struct llist_head *raised, *lazy;
 
-	this_list = &__get_cpu_var(irq_work_list);
-	if (llist_empty(this_list))
+	raised = &__get_cpu_var(raised_list);
+	lazy = &__get_cpu_var(lazy_list);
+	if (llist_empty(raised) && llist_empty(lazy))
 		return false;
 
 	/* All work should have been flushed before going offline */
@@ -102,28 +101,18 @@ bool irq_work_needs_cpu(void)
 	return true;
 }
 
-static void __irq_work_run(void)
+static void irq_work_run_list(struct llist_head *list)
 {
 	unsigned long flags;
 	struct irq_work *work;
-	struct llist_head *this_list;
 	struct llist_node *llnode;
 
-
-	/*
-	 * Reset the "raised" state right before we check the list because
-	 * an NMI may enqueue after we find the list empty from the runner.
-	 */
-	__this_cpu_write(irq_work_raised, 0);
-	barrier();
-
-	this_list = &__get_cpu_var(irq_work_list);
-	if (llist_empty(this_list))
-		return;
-
 	BUG_ON(!irqs_disabled());
 
-	llnode = llist_del_all(this_list);
+	if (llist_empty(list))
+		return;
+
+	llnode = llist_del_all(list);
 	while (llnode != NULL) {
 		work = llist_entry(llnode, struct irq_work, llnode);
 
@@ -148,6 +137,12 @@ static void __irq_work_run(void)
 	}
 }
 
+static void __irq_work_run(void)
+{
+	irq_work_run_list(&__get_cpu_var(raised_list));
+	irq_work_run_list(&__get_cpu_var(lazy_list));
+}
+
 /*
  * Run the irq_work entries on this cpu. Requires to be ran from hardirq
  * context with local IRQs disabled.
-- 
1.8.3.1

