Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbaEKXeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 19:34:21 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:59174 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859AbaEKXeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 19:34:08 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/5] irq_work: Allow remote queueing
Date: Mon, 12 May 2014 01:33:55 +0200
Message-Id: <1399851237-2226-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
References: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq work currently only supports local callbacks. However its code
is mostly ready to run remote callbacks and we have some potential user.

The full nohz subsystem currently open codes its own remote irq work
on top of the scheduler ipi when it wants a CPU to revaluate its next
tick.

However this ad hoc solution bloats the scheduler IPI.

Lets just extend the irq work subsystem to handle this kind of user.
This shouldn't add noticeable overhead.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/irq_work.h |  2 ++
 kernel/irq_work.c        | 29 +++++++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 429b1ba..511e7f7 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -33,6 +33,8 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 #define DEFINE_IRQ_WORK(name, _f) struct irq_work name = { .func = (_f), }
 
 bool irq_work_queue(struct irq_work *work);
+bool irq_work_queue_on(struct irq_work *work, int cpu);
+
 void irq_work_run(void);
 void irq_work_run_tick(void);
 void irq_work_sync(struct irq_work *work);
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 0a554a6..3a7e163 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -55,12 +55,37 @@ void __weak arch_irq_work_raise(int cpu)
 	 */
 }
 
+static void irq_work_queue_raise(struct irq_work *work,
+				 struct llist_head *head, int cpu)
+{
+	if (llist_add(&work->llnode, head))
+		arch_irq_work_raise(cpu);
+}
+
+#ifdef CONFIG_HAVE_IRQ_WORK_IPI
 /*
  * Enqueue the irq_work @entry unless it's already pending
  * somewhere.
  *
  * Can be re-enqueued while the callback is still in progress.
  */
+bool irq_work_queue_on(struct irq_work *work, int cpu)
+{
+	/* Only queue if not already pending */
+	if (!irq_work_claim(work))
+		return false;
+
+	/* All work should have been flushed before going offline */
+	WARN_ON_ONCE(cpu_is_offline(cpu));
+	WARN_ON_ONCE(work->flags & IRQ_WORK_LAZY);
+
+	irq_work_queue_raise(work, &per_cpu(raised_list, cpu), cpu);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(irq_work_queue_on);
+#endif /* #endif CONFIG_HAVE_IRQ_WORK_IPI */
+
 bool irq_work_queue(struct irq_work *work)
 {
 	unsigned long flags;
@@ -78,8 +103,8 @@ bool irq_work_queue(struct irq_work *work)
 	 * for the next tick.
 	 */
 	if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
-		if (llist_add(&work->llnode, &__get_cpu_var(raised_list)))
-			arch_irq_work_raise(smp_processor_id());
+		irq_work_queue_raise(work, &__get_cpu_var(raised_list),
+				     smp_processor_id());
 	} else {
 		llist_add(&work->llnode, &__get_cpu_var(lazy_list));
 	}
-- 
1.8.3.1

