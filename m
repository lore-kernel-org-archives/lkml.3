Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaKJFsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:48:43 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52496 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaKJFsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:48:42 -0500
From: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, mturquette@linaro.org, amit.kucheria@linaro.org,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        peterz@infradead.org, mingo@kernel.org, linaro-kernel@lists.linaro.org,
        Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Subject: [RFC 2/2] cpufreq: governor: CPU frequency scaled from task's cumulative-load on an idle wakeup
Date: Mon, 10 Nov 2014 11:15:58 +0530
Message-Id: <1415598358-26505-3-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415598358-26505-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
References: <1415598358-26505-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111005-0029-0000-0000-0000008FD0AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"18b46a cpufreq: governor: Be friendly towards latency-sensitive
bursty workloads" patch by Srivatsa tried to solve a problem in
cpufreq governor's CPU load calculation logic. The fix is to detect
wakeup from cpuidle scenario and to start the workload at reasonably
high frequency and thus avoiding the redundant step to bring down
the frequency when a task wakes up on an idle CPU.

This logic used the 'previous load' as the CPU load for the alternate
wakeup-from-cpuidle and not newly calculating the load. The issue is
that sometimes the 'previous load' which is meant to help certain
latency sensitive tasks can get used by some kworker or similar task
to its advantage if it woke up first on the cpu. This will deprive
important tasks of high cpu frequency thus replicating the issue that
we set out to solve. Also if the bursty workloads were in a constant
migration of cpus then they will be deprived from running at high
frequency on every wakeup-on-idle-cpu scenarios. This is explained
below:

   Time(ms)		Events on CPU

   100		Task A is running on CPU

   110		Governor's timer fires and calculates CPU load:
   		load=100 prev_load=100. It marks the high load
   		and increases the CPU frequency

   110.5	Task A is running

   118		Task A went to sleep and CPU became idle

   140		Task B starts to run

   141		Governor's deferred timer fires and calculates CPU load.
   		It notices the long idle period and uses the prev_load
		as the current CPU load. load=100 prev_load=0. It
		increases the CPU frequency as it sees the high load.

   141.5	Task B is running

   142		Task B went to sleep and CPU became idle

   174		Task A woke up and started running again

   175		Governor's deferred timer fires and calculates CPU load.
   		load=3 prev_load=3. Even though it is a long idle
		period the CPU load is freshly calculated as the
		prev_load is copied for alternate wake_ups. The
		governor decides to decrease the frequency as it
		notices low load.

At 175ms governor decreases the CPU frequency as it freshly calculates
the load. So Task A is deprived from running at high frequency for the
next 10ms of its execution until the governor's timer fires again to
compute the load. This happened because Task B woke up first on the
CPU consuming the prev_load.

Considering latency sensitive bursty workloads like Task A and short
bursty housekeeping kernel functions like Task B; Task A will surely
fall short of chances of running at high frequency on its wakeup if
Task B continues to pop up in this fashion.

If the governor was aware of the history of the incoming task it could
make decisions more appropriately to scale the CPU frequency.
So instead of cpu load use a task's cumulative-load to calculate the
load on every wakeup from idle state. The cumulative-load of task will
explain the nature of the task's cpu utilization. But we cannot directly
map cumulative-load to scale cpu frequency. Because the current
cpufreq governor logic is implemented keeping cpu load in mind. This
logic intends to increase the CPU frequency if the task's cumulative
load is above a threshold limit.

Signed-off-by: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Suggested-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 drivers/cpufreq/cpufreq_governor.c | 39 +++++++++++++++-----------------------
 drivers/cpufreq/cpufreq_governor.h |  9 ++-------
 2 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 1b44496..de4896c 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -19,6 +19,7 @@
 #include <linux/export.h>
 #include <linux/kernel_stat.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #include "cpufreq_governor.h"
 
@@ -119,37 +120,29 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 		 * actually is. This is undesirable for latency-sensitive bursty
 		 * workloads.
 		 *
-		 * To avoid this, we reuse the 'load' from the previous
-		 * time-window and give this task a chance to start with a
-		 * reasonably high CPU frequency. (However, we shouldn't over-do
-		 * this copy, lest we get stuck at a high load (high frequency)
-		 * for too long, even when the current system load has actually
-		 * dropped down. So we perform the copy only once, upon the
-		 * first wake-up from idle.)
+		 * To avoid this, we use the task's cumulative load which woke
+		 * up the idle CPU to suitably scale the CPU frequency. For a
+		 * sibling CPU we use the cumulative load of the current task on
+		 * that CPU.
+		 *
+		 * A task is considered to be CPU intensive if its cumulative
+		 * load is greater than 10. Hence it is desirable to increase
+		 * the CPU frequency to frequency_max.
 		 *
 		 * Detecting this situation is easy: the governor's deferrable
 		 * timer would not have fired during CPU-idle periods. Hence
 		 * an unusually large 'wall_time' (as compared to the sampling
 		 * rate) indicates this scenario.
-		 *
-		 * prev_load can be zero in two cases and we must recalculate it
-		 * for both cases:
-		 * - during long idle intervals
-		 * - explicitly set to zero
 		 */
-		if (unlikely(wall_time > (2 * sampling_rate) &&
-			     j_cdbs->prev_load)) {
-			load = j_cdbs->prev_load;
 
-			/*
-			 * Perform a destructive copy, to ensure that we copy
-			 * the previous load only once, upon the first wake-up
-			 * from idle.
-			 */
-			j_cdbs->prev_load = 0;
+		if (unlikely(wall_time > (2 * sampling_rate))) {
+			load = task_cumulative_load(j);
+			if (load > 10) {
+				max_load = MAX_LOAD;
+				break;
+			}
 		} else {
 			load = 100 * (wall_time - idle_time) / wall_time;
-			j_cdbs->prev_load = load;
 		}
 
 		if (load > max_load)
@@ -381,8 +374,6 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 			prev_load = (unsigned int)
 				(j_cdbs->prev_cpu_wall - j_cdbs->prev_cpu_idle);
-			j_cdbs->prev_load = 100 * prev_load /
-					(unsigned int) j_cdbs->prev_cpu_wall;
 
 			if (ignore_nice)
 				j_cdbs->prev_cpu_nice =
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index cc401d1..bfae4fe 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -36,6 +36,8 @@
 #define MIN_LATENCY_MULTIPLIER			(20)
 #define TRANSITION_LATENCY_LIMIT		(10 * 1000 * 1000)
 
+#define MAX_LOAD				(99)
+
 /* Ondemand Sampling types */
 enum {OD_NORMAL_SAMPLE, OD_SUB_SAMPLE};
 
@@ -134,13 +136,6 @@ struct cpu_dbs_common_info {
 	u64 prev_cpu_idle;
 	u64 prev_cpu_wall;
 	u64 prev_cpu_nice;
-	/*
-	 * Used to keep track of load in the previous interval. However, when
-	 * explicitly set to zero, it is used as a flag to ensure that we copy
-	 * the previous load to the current interval only once, upon the first
-	 * wake-up from idle.
-	 */
-	unsigned int prev_load;
 	struct cpufreq_policy *cur_policy;
 	struct delayed_work work;
 	/*
-- 
1.9.3

