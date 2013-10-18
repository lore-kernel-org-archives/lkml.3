Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab3JRL5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:57:23 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:61302 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3JRLyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:54:03 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 13/14] sched: differantiate idle cpu
Date: Fri, 18 Oct 2013 13:52:26 +0200
Message-Id: <1382097147-30088-13-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cost for waking up of a core varies according to its current idle state.
This includes C-state and intermediate state when some sync between cores is
required to reach a deep C-state.
Waking up a CPU in a deep C-state for running a short task is not efficient
from both a power and a performance point of view. We should take into account
the wake up latency of an idle CPU when the scheduler looks for the best CPU
to use for a waking task.
The wake up latency of a CPU is computed into a load that can be directly
compared with task load and other CPUs load.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ad8b99a..4863dad 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -394,6 +394,20 @@ static int check_nohz_packing(int cpu)
 
 	return false;
 }
+
+int sched_get_idle_load(int cpu)
+{
+	struct sched_pm *stat = &per_cpu(sched_stat, cpu);
+	int latency = atomic_read(&(stat->wake_latency));
+	/*
+	 * Transform the current wakeup latency (us) into an idle load that
+	 * will be compared to task load to decide if it's worth to wake up
+	 * the cpu. The current formula is quite simple but give good
+	 * approximation in the range [0:10ms]
+	 */
+	return (latency * 21) >> 10;
+}
+
 #else /* CONFIG_SCHED_PACKING_TASKS */
 
 static inline bool is_packing_cpu(int cpu)
@@ -416,6 +430,10 @@ static inline int check_nohz_packing(int cpu)
 	return false;
 }
 
+static inline int sched_get_idle_load(int cpu)
+{
+	return 0;
+}
 
 #endif /* CONFIG_SCHED_PACKING_TASKS */
 #endif /* CONFIG_SMP */
@@ -3207,6 +3225,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
+	if (idle_cpu(cpu))
+		return sched_get_idle_load(cpu);
 	return cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
@@ -3655,6 +3675,8 @@ static int select_idle_sibling(struct task_struct *p, int target)
 				if (i == target || !idle_cpu(i)
 						|| !is_packing_cpu(i))
 					goto next;
+				if (weighted_cpuload(i) > p->se.avg.load_avg_contrib)
+					goto next;
 			}
 
 			target = cpumask_first_and(sched_group_cpus(sg),
-- 
1.7.9.5

