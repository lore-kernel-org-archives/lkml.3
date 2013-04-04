Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617Ab3DDOQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:16:56 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54151 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761560Ab3DDOQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:16:55 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, pjt@google.com,
        rostedt@goodmis.org, fweisbec@gmail.com, efault@gmx.de
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v4] sched: fix wrong rq's runnable_avg update with rt tasks
Date: Thu,  4 Apr 2013 16:15:59 +0200
Message-Id: <1365084959-28374-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current update of the rq's load can be erroneous when RT tasks are
involved

The update of the load of a rq that becomes idle, is done only if the avg_idle
is less than sysctl_sched_migration_cost. If RT tasks and short idle duration
alternate, the runnable_avg will not be updated correctly and the time will be
accounted as idle time when a CFS task wakes up.

A new idle_enter function is called when the next task is the idle function
so the elapsed time will be accounted as run time in the load of the rq,
whatever the average idle time is. The function update_rq_runnable_avg is
removed from idle_balance.

When a RT task is scheduled on an idle CPU, the update of the rq's load is
not done when the rq exit idle state because CFS's functions are not
called. Then, the idle_balance, which is called just before entering the
idle function, updates the rq's load and makes the assumption that the
elapsed time since the last update, was only running time.

As a consequence, the rq's load of a CPU that only runs a periodic RT task,
is close to LOAD_AVG_MAX whatever the running duration of the RT task is.

A new idle_exit function is called when the prev task is the idle function
so the elapsed time will be accounted as idle time in the rq's load.

Changes since V3:
- Remove dependancy with CONFIG_FAIR_GROUP_SCHED
- Add a new idle_enter function and create a post_schedule callback for
 idle class
- Remove the update_runnable_avg from idle_balance

Changes since V2:
- remove useless definition for UP platform
- rebased on top of Steven Rostedt's patches :
https://lkml.org/lkml/2013/2/12/558

Changes since V1:
- move code out of schedule function and create a pre_schedule callback for
  idle class instead.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c      |   23 +++++++++++++++++++++--
 kernel/sched/idle_task.c |   10 ++++++++++
 kernel/sched/sched.h     |   12 ++++++++++++
 3 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0fcdbff..1851ca8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1562,6 +1562,27 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
 	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
 }
+
+/*
+ * Update the rq's load with the elapsed running time before entering
+ * idle. if the last scheduled task is not a CFS task, idle_enter will
+ * be the only way to update the runnable statistic.
+ */
+void idle_enter(struct rq *this_rq)
+{
+	update_rq_runnable_avg(this_rq, 1);
+}
+
+/*
+ * Update the rq's load with the elapsed idle time before a task is
+ * scheduled. if the newly scheduled task is not a CFS task, idle_exit will
+ * be the only way to update the runnable statistic.
+ */
+void idle_exit(struct rq *this_rq)
+{
+	update_rq_runnable_avg(this_rq, 0);
+}
+
 #else
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
@@ -5219,8 +5240,6 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
-	update_rq_runnable_avg(this_rq, 1);
-
 	/*
 	 * Drop the rq->lock, but keep preempt disabled.
 	 */
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 66b5220..0775261 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -14,8 +14,17 @@ select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
 
+static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
+{
+	/* Update rq's load with elapsed idle time */
+	idle_exit(rq);
+}
+
 static void post_schedule_idle(struct rq *rq)
 {
+	/* Update rq's load with elapsed running time */
+	idle_enter(rq);
+
 	idle_balance(smp_processor_id(), rq);
 }
 #endif /* CONFIG_SMP */
@@ -95,6 +104,7 @@ const struct sched_class idle_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
+	.pre_schedule		= pre_schedule_idle,
 	.post_schedule		= post_schedule_idle,
 #endif
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc88644..ff4b029 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -878,6 +878,18 @@ extern const struct sched_class idle_sched_class;
 extern void trigger_load_balance(struct rq *rq, int cpu);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
 
+/*
+ * Only depends on SMP, FAIR_GROUP_SCHED may be removed when runnable_avg
+ * becomes useful in lb
+ */
+#if defined(CONFIG_FAIR_GROUP_SCHED)
+extern void idle_enter(struct rq *this_rq);
+extern void idle_exit(struct rq *this_rq);
+#else
+static inline void idle_enter(struct rq *this_rq) {}
+static inline void idle_exit(struct rq *this_rq) {}
+#endif
+
 #else	/* CONFIG_SMP */
 
 static inline void idle_balance(int cpu, struct rq *rq)
-- 
1.7.9.5

