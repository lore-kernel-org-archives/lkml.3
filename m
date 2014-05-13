Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938AbaEMOi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:38:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51605 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933908AbaEMOiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:38:52 -0400
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
Date: Tue, 13 May 2014 16:38:39 +0200
Message-Id: <1399991921-17618-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399991921-17618-1-git-send-email-fweisbec@gmail.com>
References: <1399991921-17618-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq work currently only supports local callbacks. However its code
is mostly ready to run remote callbacks and we have some potential user.

The full nohz subsystem currently open codes its own remote irq work
on top of the scheduler ipi when it wants a CPU to revaluate its next
tick. However this ad hoc solution bloats the scheduler IPI.

Lets just extend the irq work subsystem to support remote queuing on top
of the generic SMP IPI to handle this kind of user. This shouldn't add
noticeable overhead.

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
 include/linux/irq_work.h |  2 ++
 kernel/irq_work.c        | 17 +++++++++++++++++
 kernel/smp.c             |  3 +++
 3 files changed, 22 insertions(+)

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
index 292a9ac..98dab29 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -66,6 +66,23 @@ bool __weak arch_irq_work_can_raise(void)
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
+	if (llist_add(&work->llnode, &per_cpu(raised_list, cpu)))
+		native_send_call_func_single_ipi(cpu);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(irq_work_queue_on);
+
 bool irq_work_queue(struct irq_work *work)
 {
 	unsigned long flags;
diff --git a/kernel/smp.c b/kernel/smp.c
index 06d574e..f5edb96 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -3,6 +3,7 @@
  *
  * (C) Jens Axboe <jens.axboe@oracle.com> 2008
  */
+#include <linux/irq_work.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
 #include <linux/kernel.h>
@@ -198,6 +199,8 @@ void generic_smp_call_function_single_interrupt(void)
 		csd->func(csd->info);
 		csd_unlock(csd);
 	}
+
+	irq_work_run();
 }
 
 /*
-- 
1.8.3.1

