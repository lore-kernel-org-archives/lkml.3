Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584Ab3ECQsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:48:12 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50904 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762762Ab3ECQsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:48:06 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux.com>, Hakan Akkan <hakanakkan@gmail.com>,
        Kevin Hilman <khilman@linaro.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] sched: Keep at least 1 tick per second for active dynticks tasks
Date: Fri,  3 May 2013 18:47:56 +0200
Message-Id: <1367599676-2049-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1367599676-2049-1-git-send-email-fweisbec@gmail.com>
References: <1367599676-2049-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler doesn't yet fully support environments
with a single task running without a periodic tick.

In order to ensure we still maintain the duties of scheduler_tick(),
keep at least 1 tick per second.

This makes sure that we keep the progression of various scheduler
accounting and background maintainance even with a very low granularity.
Examples include cpu load, sched average, CFS entity vruntime,
avenrun and events such as load balancing, amongst other details
handled in sched_class::task_tick().

This limitation will be removed in the future once we get
these individual items to work in full dynticks CPUs.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h    |    1 +
 kernel/sched/core.c      |   30 ++++++++++++++++++++++++++++++
 kernel/sched/idle_task.c |    1 +
 kernel/sched/sched.h     |   10 ++++++++++
 kernel/time/tick-sched.c |    7 +++++++
 5 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ebf7095..af008d7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1862,6 +1862,7 @@ static inline void wake_up_nohz_cpu(int cpu) { }
 
 #ifdef CONFIG_NO_HZ_FULL
 extern bool sched_can_stop_tick(void);
+extern u64 scheduler_tick_max_deferment(void);
 #else
 static inline bool sched_can_stop_tick(void) { return false; }
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e94842d..3bdf986 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2736,8 +2736,35 @@ void scheduler_tick(void)
 	rq->idle_balance = idle_cpu(cpu);
 	trigger_load_balance(rq, cpu);
 #endif
+	rq_last_tick_reset(rq);
 }
 
+#ifdef CONFIG_NO_HZ_FULL
+/**
+ * scheduler_tick_max_deferment
+ *
+ * Keep at least one tick per second when a single
+ * active task is running because the scheduler doesn't
+ * yet completely support full dynticks environment.
+ *
+ * This makes sure that uptime, CFS vruntime, load
+ * balancing, etc... continue to move forward, even
+ * with a very low granularity.
+ */
+u64 scheduler_tick_max_deferment(void)
+{
+	struct rq *rq = this_rq();
+	unsigned long next, now = ACCESS_ONCE(jiffies);
+
+	next = rq->last_sched_tick + HZ;
+
+	if (time_before_eq(next, now))
+		return 0;
+
+	return jiffies_to_usecs(next - now) * NSEC_PER_USEC;
+}
+#endif
+
 notrace unsigned long get_parent_ip(unsigned long addr)
 {
 	if (in_lock_functions(addr)) {
@@ -6993,6 +7020,9 @@ void __init sched_init(void)
 #ifdef CONFIG_NO_HZ_COMMON
 		rq->nohz_flags = 0;
 #endif
+#ifdef CONFIG_NO_HZ_FULL
+		rq->last_sched_tick = 0;
+#endif
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index b8ce773..d8da010 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -17,6 +17,7 @@ select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
 {
 	idle_exit_fair(rq);
+	rq_last_tick_reset(rq);
 }
 
 static void post_schedule_idle(struct rq *rq)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 24dc298..ce39224 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -410,6 +410,9 @@ struct rq {
 	u64 nohz_stamp;
 	unsigned long nohz_flags;
 #endif
+#ifdef CONFIG_NO_HZ_FULL
+	unsigned long last_sched_tick;
+#endif
 	int skip_clock_update;
 
 	/* capture load from *all* tasks on this cpu: */
@@ -1090,6 +1093,13 @@ static inline void dec_nr_running(struct rq *rq)
 	rq->nr_running--;
 }
 
+static inline void rq_last_tick_reset(struct rq *rq)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	rq->last_sched_tick = jiffies;
+#endif
+}
+
 extern void update_rq_clock(struct rq *rq);
 
 extern void activate_task(struct rq *rq, struct task_struct *p, int flags);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1c9f53b..07929c6 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -600,6 +600,13 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 			time_delta = KTIME_MAX;
 		}
 
+#ifdef CONFIG_NO_HZ_FULL
+		if (!ts->inidle) {
+			time_delta = min(time_delta,
+					 scheduler_tick_max_deferment());
+		}
+#endif
+
 		/*
 		 * calculate the expiry time for the next timer wheel
 		 * timer. delta_jiffies >= NEXT_TIMER_MAX_DELTA signals
-- 
1.7.5.4

