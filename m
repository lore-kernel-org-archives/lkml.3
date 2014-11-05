Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaKEPsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:48:47 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58377 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbaKEPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:48:45 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH v3 1/7] sched/rt: Deal with cpupri.pri_to_cpu[CPUPRI_IDLE] for idle cases
Date: Wed,  5 Nov 2014 23:48:20 +0800
Message-Id: <1415202506-7800-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a runqueue runs out of RT tasks, it may have non-RT tasks or
none tasks(idle). Currently, RT balance treats the two cases equally
and manipulates cpupri.pri_to_cpu[CPUPRI_NORMAL] only which may cause
problems.

For instance, 4 cpus system, non-RT task1 is running on cpu0, RT
task2 is running on cpu3, cpu1/cpu2 both are idle. Then RT task3
(usually CPU-intensive) is waken up or created on cpu3, it will
be placed to cpu0 (see find_lowest_rq()) causing task1 starving
until cfs load balance places task1 to another cpu, or even worse
if task1 is bound on cpu0. So, it would be reasonable to put task3
to cpu1 or cpu2 which is idle(even though doing this may break the
energy-saving idle state).

This patch tackles the problem by operating pri_to_cpu[CPUPRI_IDLE]
of cpupri according to the stages of idle task, so that when pushing
RT tasks through find_lowest_rq(), it will try to find one idle cpu
as the goal.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/idle_task.c |  3 +++
 kernel/sched/rt.c        | 21 +++++++++++++++++++++
 kernel/sched/sched.h     |  6 ++++++
 3 files changed, 30 insertions(+)

diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 67ad4e7..e053347 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -26,6 +26,8 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 static struct task_struct *
 pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 {
+	idle_enter_rt(rq);
+
 	put_prev_task(rq, prev);
 
 	schedstat_inc(rq, sched_goidle);
@@ -47,6 +49,7 @@ dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
 
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
 {
+	idle_exit_rt(rq);
 	idle_exit_fair(rq);
 	rq_last_tick_reset(rq);
 }
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index d024e6c..da6922e 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -992,6 +992,27 @@ enqueue_top_rt_rq(struct rt_rq *rt_rq)
 
 #if defined CONFIG_SMP
 
+/* Set CPUPRI_IDLE bitmap for this cpu when entering idle. */
+void idle_enter_rt(struct rq *this_rq)
+{
+	struct cpupri *cp = &this_rq->rd->cpupri;
+	int currpri = cp->cpu_to_pri[this_rq->cpu];
+
+	BUG_ON(currpri != CPUPRI_NORMAL);
+	cpupri_set(cp, this_rq->cpu, MAX_PRIO);
+}
+
+/* Set CPUPRI_NORMAL bitmap for this cpu when exiting from idle. */
+void idle_exit_rt(struct rq *this_rq)
+{
+	struct cpupri *cp = &this_rq->rd->cpupri;
+	int currpri = cp->cpu_to_pri[this_rq->cpu];
+
+	/* RT tasks may be queued before, this judgement is needed. */
+	if (currpri == CPUPRI_IDLE)
+		cpupri_set(cp, this_rq->cpu, MAX_RT_PRIO);
+}
+
 static void
 inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 24156c84..cc603fa 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1162,11 +1162,17 @@ extern void update_group_capacity(struct sched_domain *sd, int cpu);
 
 extern void trigger_load_balance(struct rq *rq);
 
+extern void idle_enter_rt(struct rq *this_rq);
+extern void idle_exit_rt(struct rq *this_rq);
+
 extern void idle_enter_fair(struct rq *this_rq);
 extern void idle_exit_fair(struct rq *this_rq);
 
 #else
 
+static inline void idle_enter_rt(struct rq *rq) { }
+static inline void idle_exit_rt(struct rq *rq) { }
+
 static inline void idle_enter_fair(struct rq *rq) { }
 static inline void idle_exit_fair(struct rq *rq) { }
 
-- 
2.1.0

