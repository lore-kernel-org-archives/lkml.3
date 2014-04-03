Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161088AbaDCAJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 20:09:54 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:33478 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933590AbaDCAJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 20:09:37 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
        Kevin Hilman <khilman@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] nohz: Move full nohz kick to its own IPI
Date: Thu,  3 Apr 2014 02:09:27 +0200
Message-Id: <1396483767-28607-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1396483767-28607-1-git-send-email-fweisbec@gmail.com>
References: <1396483767-28607-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have smp_queue_function_single() which can be used to
safely queue IPIs when interrupts are disabled and without worrying
about concurrent callers, lets use it for the full dynticks kick to
notify a CPU that it's exiting single task mode.

This unbloats a bit the scheduler IPI that the nohz code was abusing
for its cool "callable anywhere/anytime" properties.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/tick.h     |  2 ++
 kernel/sched/core.c      |  5 +----
 kernel/sched/sched.h     |  2 +-
 kernel/time/tick-sched.c | 21 +++++++++++++++++++++
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..9d3fcc2 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -182,6 +182,7 @@ static inline bool tick_nohz_full_cpu(int cpu)
 extern void tick_nohz_init(void);
 extern void __tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
+extern void tick_nohz_full_kick_cpu(int cpu);
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
 #else
@@ -190,6 +191,7 @@ static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
 static inline void __tick_nohz_full_check(void) { }
 static inline void tick_nohz_full_kick(void) { }
+static inline void tick_nohz_full_kick_cpu(int cpu) { }
 static inline void tick_nohz_full_kick_all(void) { }
 static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9cae286..e4b344e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1499,9 +1499,7 @@ void scheduler_ipi(void)
 	 */
 	preempt_fold_need_resched();
 
-	if (llist_empty(&this_rq()->wake_list)
-			&& !tick_nohz_full_cpu(smp_processor_id())
-			&& !got_nohz_idle_kick())
+	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
 		return;
 
 	/*
@@ -1518,7 +1516,6 @@ void scheduler_ipi(void)
 	 * somewhat pessimize the simple resched case.
 	 */
 	irq_enter();
-	tick_nohz_full_check();
 	sched_ttwu_pending();
 
 	/*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c9007f2..4771063 100644
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
index 9f8af69..582d3f6 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -230,6 +230,27 @@ void tick_nohz_full_kick(void)
 		irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
 }
 
+static void nohz_full_kick_queue(struct queue_single_data *qsd)
+{
+	__tick_nohz_full_check();
+}
+
+static DEFINE_PER_CPU(struct queue_single_data, nohz_full_kick_qsd) = {
+	.func = nohz_full_kick_queue,
+};
+
+void tick_nohz_full_kick_cpu(int cpu)
+{
+	if (!tick_nohz_full_cpu(cpu))
+		return;
+
+	if (cpu == smp_processor_id()) {
+		irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
+	} else {
+		smp_queue_function_single(cpu, &per_cpu(nohz_full_kick_qsd, cpu));
+	}
+}
+
 static void nohz_full_kick_ipi(void *info)
 {
 	__tick_nohz_full_check();
-- 
1.8.3.1

