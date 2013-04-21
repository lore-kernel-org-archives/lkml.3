Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3DUMwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 08:52:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40738 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab3DUMwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 08:52:30 -0400
Date: Sun, 21 Apr 2013 05:52:13 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-642dbc39ab1ea00f47e0fee1b8e8a27da036d940@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl,
        vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, rostedt@goodmis.org,
        vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1366302867-5055-1-git-send-email-vincent.guittot@linaro.org>
References: <1366302867-5055-1-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix wrong rq'
 s runnable_avg update with rt tasks
Git-Commit-ID: 642dbc39ab1ea00f47e0fee1b8e8a27da036d940
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 21 Apr 2013 05:52:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  642dbc39ab1ea00f47e0fee1b8e8a27da036d940
Gitweb:     http://git.kernel.org/tip/642dbc39ab1ea00f47e0fee1b8e8a27da036d940
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Thu, 18 Apr 2013 18:34:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 21 Apr 2013 11:22:52 +0200

sched: Fix wrong rq's runnable_avg update with rt tasks

The current update of the rq's load can be erroneous when RT
tasks are involved.

The update of the load of a rq that becomes idle, is done only
if the avg_idle is less than sysctl_sched_migration_cost. If RT
tasks and short idle duration alternate, the runnable_avg will
not be updated correctly and the time will be accounted as idle
time when a CFS task wakes up.

A new idle_enter function is called when the next task is the
idle function so the elapsed time will be accounted as run time
in the load of the rq, whatever the average idle time is. The
function update_rq_runnable_avg is removed from idle_balance.

When a RT task is scheduled on an idle CPU, the update of the
rq's load is not done when the rq exit idle state because CFS's
functions are not called. Then, the idle_balance, which is
called just before entering the idle function, updates the rq's
load and makes the assumption that the elapsed time since the
last update, was only running time.

As a consequence, the rq's load of a CPU that only runs a
periodic RT task, is close to LOAD_AVG_MAX whatever the running
duration of the RT task is.

A new idle_exit function is called when the prev task is the
idle function so the elapsed time will be accounted as idle time
in the rq's load.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: linaro-kernel@lists.linaro.org
Cc: peterz@infradead.org
Cc: pjt@google.com
Cc: fweisbec@gmail.com
Cc: efault@gmx.de
Link: http://lkml.kernel.org/r/1366302867-5055-1-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c      | 23 +++++++++++++++++++++--
 kernel/sched/idle_task.c | 16 ++++++++++++++++
 kernel/sched/sched.h     | 12 ++++++++++++
 3 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 155783b..1c97735 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1563,6 +1563,27 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
 	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
 }
+
+/*
+ * Update the rq's load with the elapsed running time before entering
+ * idle. if the last scheduled task is not a CFS task, idle_enter will
+ * be the only way to update the runnable statistic.
+ */
+void idle_enter_fair(struct rq *this_rq)
+{
+	update_rq_runnable_avg(this_rq, 1);
+}
+
+/*
+ * Update the rq's load with the elapsed idle time before a task is
+ * scheduled. if the newly scheduled task is not a CFS task, idle_exit will
+ * be the only way to update the runnable statistic.
+ */
+void idle_exit_fair(struct rq *this_rq)
+{
+	update_rq_runnable_avg(this_rq, 0);
+}
+
 #else
 static inline void update_entity_load_avg(struct sched_entity *se,
 					  int update_cfs_rq) {}
@@ -5217,8 +5238,6 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
-	update_rq_runnable_avg(this_rq, 1);
-
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
 	 */
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index b6baf37..b8ce773 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -13,6 +13,16 @@ select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
+
+static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
+{
+	idle_exit_fair(rq);
+}
+
+static void post_schedule_idle(struct rq *rq)
+{
+	idle_enter_fair(rq);
+}
 #endif /* CONFIG_SMP */
 /*
  * Idle tasks are unconditionally rescheduled:
@@ -25,6 +35,10 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 static struct task_struct *pick_next_task_idle(struct rq *rq)
 {
 	schedstat_inc(rq, sched_goidle);
+#ifdef CONFIG_SMP
+	/* Trigger the post schedule to do an idle_enter for CFS */
+	rq->post_schedule = 1;
+#endif
 	return rq->idle;
 }
 
@@ -86,6 +100,8 @@ const struct sched_class idle_sched_class = {
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
+	.pre_schedule		= pre_schedule_idle,
+	.post_schedule		= post_schedule_idle,
 #endif
 
 	.set_curr_task          = set_curr_task_idle,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8116cf8..605426a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1024,6 +1024,18 @@ extern void update_group_power(struct sched_domain *sd, int cpu);
 extern void trigger_load_balance(struct rq *rq, int cpu);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
 
+/*
+ * Only depends on SMP, FAIR_GROUP_SCHED may be removed when runnable_avg
+ * becomes useful in lb
+ */
+#if defined(CONFIG_FAIR_GROUP_SCHED)
+extern void idle_enter_fair(struct rq *this_rq);
+extern void idle_exit_fair(struct rq *this_rq);
+#else
+static inline void idle_enter_fair(struct rq *this_rq) {}
+static inline void idle_exit_fair(struct rq *this_rq) {}
+#endif
+
 #else	/* CONFIG_SMP */
 
 static inline void idle_balance(int cpu, struct rq *rq)
