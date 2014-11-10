Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaKJFs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:48:27 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44422 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaKJFs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:48:26 -0500
From: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, mturquette@linaro.org, amit.kucheria@linaro.org,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        peterz@infradead.org, mingo@kernel.org, linaro-kernel@lists.linaro.org,
        Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Subject: [RFC 1/2] sched/fair: Add cumulative average of load_avg_contrib to a task
Date: Mon, 10 Nov 2014 11:15:57 +0530
Message-Id: <1415598358-26505-2-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415598358-26505-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
References: <1415598358-26505-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111005-0025-0000-0000-00000077B7DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch aims to identify a suitable metric which can define
the nature of the task as CPU intensive or non-intensive. This
metric's value will be used to optimize the logic to scale CPU
frequency during an idle wakeup scenario i.e., to make the cpufreq
governor to scale the frequency optimized for workloads.

Given the properties of 'load_avg_contrib' of a task's sched entity,
it forms a potential candidate for frequency scaling. By the virtue of
its design this metric picks up the load slowly during an idle wakeup.
So at that instant of wakeup we cannot account on the latest value of
this metric as it is unreliable. This can be seen in the test results
below.

I ran a modified version of ebizzy which sleeps in between its
execution such that its utilization can be user defined value. The
below trace was observed for a single thread ebizzy run for a 40%
utilization.

T1 ebizzy   309.613862: .__update_entity_load_avg_contrib: ebizzy load_avg_contrib=1022
T2 ebizzy   309.613864: sched_switch: prev_comm=ebizzy ==> next_comm=swapper/8
T3 <idle>   310.062932: .__update_entity_load_avg_contrib: ebizzy load_avg_contrib=0
T4 <idle>   310.062936: sched_switch: prev_comm=swapper/8 ==> next_comm=ebizzy
T5 ebizzy   310.063104: .__update_entity_load_avg_contrib: ebizzy load_avg_contrib=67
T6 ebizzy   310.063106: .__update_entity_load_avg_contrib: kworker/8:1 load_avg_contrib=0
T7 ebizzy   310.063108: sched_switch: prev_comm=ebizzy ==> next_comm=kworker/8:1

At 309.613862 the 'load_avg_contrib' value of ebizzy is equal to 1022
which indicates its high utilization. It goes to sleep at 309.613864.
After a long idle peroid ebizzy wakes up at 310.062932. Once a cpu
wakes up from an idle state all the timers that were deferred on that
cpu will be fired. The cpufreq governor's timer is one such deferred
timer which gets fired consequently after ebizzy wakes up. On next
context_switch at 310.063104 we can see that load_avg_contrib's value
gets updated to 67. Further at 310.063108 the cpufreq governor gets
switched in to calculate the load, now if it were to consider ebizzy's
'load_avg_contrib' value then we will not benefit as the recent value
is far less compared to the value ebizzy had before going to sleep.

We can hide these fluctuations of 'load_avg_contrib' by calculating
the average of all the values of 'load_avg_contrib'. The cumulative
average of 'load_avg_contrib' will always preserve the long-term
behavior of the task. Thus using the cumulative average of
'load_avg_contrib' we can scale the cpu frequency as best suited for
the task.

'load_avg_contrib' of ebizzy is updated at T1, T3 and T5. So in
a period from T1-T7 ebizzy has the following values :
	load_avg_contrib 	cumulative_average
T1		1022		1022/1        = 1022
T3		0		(1022+0)/2    = 511
T5		67		(1022+0+67)/3 = 363

At T5 the cumulative_average is 363 which is better than the
load_avg_contrib value 67 when used to decide the nature of the task.
Thus we can use cumulative_average to scale the cpu frequency during
an idle wakeup.

Signed-off-by: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Suggested-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 include/linux/sched.h |  4 ++++
 kernel/sched/core.c   | 35 +++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c   |  6 +++++-
 kernel/sched/sched.h  |  2 +-
 4 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bb..212a0a7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1081,6 +1081,8 @@ struct sched_avg {
 	u64 last_runnable_update;
 	s64 decay_count;
 	unsigned long load_avg_contrib;
+	unsigned long cumulative_avg;
+	unsigned long cumulative_avg_count;
 };
 
 #ifdef CONFIG_SCHEDSTATS
@@ -3032,3 +3034,5 @@ static inline unsigned long rlimit_max(unsigned int limit)
 }
 
 #endif
+
+extern unsigned int task_cumulative_load(int cpu);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4499950..b3d0d5a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2853,6 +2853,7 @@ need_resched:
 	if (likely(prev != next)) {
 		rq->nr_switches++;
 		rq->curr = next;
+		rq->prev = prev;
 		++*switch_count;
 
 		context_switch(rq, prev, next); /* unlocks the rq */
@@ -8219,3 +8220,37 @@ void dump_cpu_task(int cpu)
 	pr_info("Task dump for CPU %d:\n", cpu);
 	sched_show_task(cpu_curr(cpu));
 }
+
+/**
+ * task_cumulative_load - return the cumulative load of
+ * the previous task if cpu is the current cpu OR the
+ * cumulative load of current task on the cpu. If cpu
+ * is idle then return 0.
+ *
+ * Invoked by the cpufreq governor to calculate the
+ * load when the CPU is woken from an idle state.
+ *
+ */
+unsigned int task_cumulative_load(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	struct task_struct *p;
+
+	if (cpu == smp_processor_id()) {
+		if (rq->prev == rq->idle)
+			goto idle;
+		p = rq->prev;
+	} else {
+		if (rq->curr == rq->idle)
+			goto idle;
+		p = rq->curr;
+	}
+	/*
+	 * Removing the priority as we are interested in CPU
+	 * utilization of the task
+	 */
+	return (100 * p->se.avg.cumulative_avg / p->se.load.weight);
+idle:
+	return 0;
+}
+EXPORT_SYMBOL(task_cumulative_load);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0b069bf..58c27e3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -680,6 +680,8 @@ void init_task_runnable_average(struct task_struct *p)
 	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
 	p->se.avg.runnable_avg_sum = slice;
 	p->se.avg.runnable_avg_period = slice;
+	p->se.avg.cumulative_avg_count = 1;
+	p->se.avg.cumulative_avg = p->se.load.weight;
 	__update_task_entity_contrib(&p->se);
 }
 #else
@@ -2476,11 +2478,13 @@ static inline void update_rq_runnable_avg(struct rq *rq, int runnable) {}
 static inline void __update_task_entity_contrib(struct sched_entity *se)
 {
 	u32 contrib;
-
 	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
 	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
 	contrib /= (se->avg.runnable_avg_period + 1);
 	se->avg.load_avg_contrib = scale_load(contrib);
+	se->avg.cumulative_avg *= se->avg.cumulative_avg_count;
+	se->avg.cumulative_avg += se->avg.load_avg_contrib;
+	se->avg.cumulative_avg /= ++se->avg.cumulative_avg_count;
 }
 
 /* Compute the current contribution to load_avg by se, return any delta */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 24156c84..064d6b1 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -565,7 +565,7 @@ struct rq {
 	 */
 	unsigned long nr_uninterruptible;
 
-	struct task_struct *curr, *idle, *stop;
+	struct task_struct *curr, *idle, *stop, *prev;
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 
-- 
1.9.3

