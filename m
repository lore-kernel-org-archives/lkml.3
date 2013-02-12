Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216Ab3BLNYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 08:24:16 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54442 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab3BLNYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 08:24:15 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, efault@gmx.de
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2] sched: fix wrong rq's runnable_avg update with rt task
Date: Tue, 12 Feb 2013 14:23:54 +0100
Message-Id: <1360675434-4259-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a RT task is scheduled on an idle CPU, the update of the rq's load is
not done because CFS's functions are not called. Then, the idle_balance,
which is called just before entering the idle function, updates the
rq's load and makes the assumption that the elapsed time since the last
update, was only running time.

The rq's load of a CPU that only runs a periodic RT task, is close to
LOAD_AVG_MAX whatever the running duration of the RT task is.

A new idle_exit function is called when the prev task is the idle function
so the elapsed time will be accounted as idle time in the rq's load.

Changes since V1:
- move code out of schedule function and create a pre_schedule callback for
  idle class instead.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c      |   10 ++++++++++
 kernel/sched/idle_task.c |    7 +++++++
 kernel/sched/sched.h     |    5 +++++
 3 files changed, 22 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 81fa536..60951f1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1562,6 +1562,16 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
 	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
 }
+
+/*
+ * Update the rq's load with the elapsed idle time before a task is
+ * scheduled. if the newly scheduled task is not a CFS task, idle_exit will
+ * be the only way to update the runnable statistic.
+ */
+void idle_exit(int this_cpu, struct rq *this_rq)
+{
+	update_rq_runnable_avg(this_rq, 0);
+}
 #else
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index b6baf37..27cd379 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -13,6 +13,12 @@ select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
+
+static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
+{
+	/* Update rq's load with elapsed idle time */
+	idle_exit(smp_processor_id(), rq);
+}
 #endif /* CONFIG_SMP */
 /*
  * Idle tasks are unconditionally rescheduled:
@@ -86,6 +92,7 @@ const struct sched_class idle_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
+	.pre_schedule		= pre_schedule_idle,
 #endif
 
 	.set_curr_task          = set_curr_task_idle,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..9707092 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -877,6 +877,7 @@ extern const struct sched_class idle_sched_class;
 
 extern void trigger_load_balance(struct rq *rq, int cpu);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
+extern void idle_exit(int this_cpu, struct rq *this_rq);
 
 #else	/* CONFIG_SMP */
 
@@ -884,6 +885,10 @@ static inline void idle_balance(int cpu, struct rq *rq)
 {
 }
 
+static inline void idle_exit(int this_cpu, struct rq *this_rq)
+{
+}
+
 #endif
 
 extern void sysrq_sched_debug_show(void);
-- 
1.7.9.5

