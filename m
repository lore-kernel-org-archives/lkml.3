Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169AbaKCKbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:31:17 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44719 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaKCKbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:31:15 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH 1/3] sched/cpupri: Deal with cpupri.pri_to_cpu[CPUPRI_IDLE] for idle cases
Date: Mon,  3 Nov 2014 18:30:18 +0800
Message-Id: <1415010620-6176-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
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
or selecting RT tasks through find_lowest_rq(), it will try to find
one idle cpu as the goal.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 kernel/sched/idle_task.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 67ad4e7..3dc372e 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -26,6 +26,15 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 static struct task_struct *
 pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 {
+#ifdef CONFIG_SMP
+	struct cpupri *cp = &rq->rd->cpupri;
+	int currpri = cp->cpu_to_pri[rq->cpu];
+
+	BUG_ON(currpri != CPUPRI_NORMAL);
+	/* Set CPUPRI_IDLE bitmap for this cpu */
+	cpupri_set(cp, rq->cpu, MAX_PRIO);
+#endif
+
 	put_prev_task(rq, prev);
 
 	schedstat_inc(rq, sched_goidle);
@@ -47,6 +56,18 @@ dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
 
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
 {
+#ifdef CONFIG_SMP
+	struct cpupri *cp = &rq->rd->cpupri;
+	int currpri = cp->cpu_to_pri[rq->cpu];
+
+	/*
+	 * Set CPUPRI_NORMAL bitmap for this cpu when exiting from idle.
+	 * RT tasks may be queued beforehand, so the judgement is needed.
+	 */
+	if (currpri == CPUPRI_IDLE)
+		cpupri_set(cp, rq->cpu, MAX_RT_PRIO);
+#endif
+
 	idle_exit_fair(rq);
 	rq_last_tick_reset(rq);
 }
-- 
1.7.9.5

