Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbaEMOj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:39:58 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:32779 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933912AbaEMOiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:38:55 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 4/5] nohz: Move full nohz kick to its own IPI
Date: Tue, 13 May 2014 16:38:40 +0200
Message-Id: <1399991921-17618-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399991921-17618-1-git-send-email-fweisbec@gmail.com>
References: <1399991921-17618-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the irq work subsystem can queue remote callbacks, it's
a perfect fit to safely queue IPIs when interrupts are disabled
without worrying about concurrent callers.

Lets use it for the full dynticks kick to notify a CPU that it's
exiting single task mode.

This unbloats a bit the scheduler IPI that the nohz code was abusing
for its cool "callable anywhere/anytime" properties.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/tick.h     |  9 ++++++++-
 kernel/sched/core.c      |  5 +----
 kernel/sched/sched.h     |  2 +-
 kernel/time/tick-sched.c | 10 ++++++----
 4 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..8a4987f 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -181,7 +181,13 @@ static inline bool tick_nohz_full_cpu(int cpu)
 
 extern void tick_nohz_init(void);
 extern void __tick_nohz_full_check(void);
-extern void tick_nohz_full_kick(void);
+extern void tick_nohz_full_kick_cpu(int cpu);
+
+static inline void tick_nohz_full_kick(void)
+{
+	tick_nohz_full_kick_cpu(smp_processor_id());
+}
+
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
 #else
@@ -189,6 +195,7 @@ static inline void tick_nohz_init(void) { }
 static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
 static inline void __tick_nohz_full_check(void) { }
+static inline void tick_nohz_full_kick_cpu(int cpu) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
 static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d9d8ece..fb6dfad 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1500,9 +1500,7 @@ void scheduler_ipi(void)
 	 */
 	preempt_fold_need_resched();
 
-	if (llist_empty(&this_rq()->wake_list)
-			&& !tick_nohz_full_cpu(smp_processor_id())
-			&& !got_nohz_idle_kick())
+	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
 		return;
 
 	/*
@@ -1519,7 +1517,6 @@ void scheduler_ipi(void)
 	 * somewhat pessimize the simple resched case.
 	 */
 	irq_enter();
-	tick_nohz_full_check();
 	sched_ttwu_pending();
 
 	/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 456e492..6089e00 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1225,7 +1225,7 @@ static inline void inc_nr_running(struct rq *rq)
 		if (tick_nohz_full_cpu(rq->cpu)) {
 			/* Order rq->nr_running write against the IPI */
 			smp_wmb();
-			smp_send_reschedule(rq->cpu);
+			tick_nohz_full_kick_cpu(rq->cpu);
 		}
        }
 #endif
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6558b7a..3d63944 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -224,13 +224,15 @@ static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) = {
 };
 
 /*
- * Kick the current CPU if it's full dynticks in order to force it to
+ * Kick the CPU if it's full dynticks in order to force it to
  * re-evaluate its dependency on the tick and restart it if necessary.
  */
-void tick_nohz_full_kick(void)
+void tick_nohz_full_kick_cpu(int cpu)
 {
-	if (tick_nohz_full_cpu(smp_processor_id()))
-		irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
+	if (!tick_nohz_full_cpu(cpu))
+		return;
+
+	irq_work_queue_on(&per_cpu(nohz_full_kick_work, cpu), cpu);
 }
 
 static void nohz_full_kick_ipi(void *info)
-- 
1.8.3.1

