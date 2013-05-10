Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab3EJPSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:18:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:13258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab3EJPSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:18:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,648,1363158000"; 
   d="scan'208";a="334911166"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: [patch v6 6/8] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
Date: Fri, 10 May 2013 23:17:27 +0800
Message-Id: <1368199049-2798-7-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are the base values in load balance, update them with rq runnable
load average, then the load balance will consider runnable load avg
naturally.

We also try to include the blocked_load_avg as cpu load in balancing,
but that cause kbuild/aim7/oltp benchmark performance drop.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c |   16 ++++++++++++++--
 kernel/sched/fair.c |    5 +++--
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f1f9641..8ab37c3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2528,9 +2528,14 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long load = this_rq->load.weight;
+	unsigned long load;
 	unsigned long pending_updates;
 
+#ifdef CONFIG_SMP
+	load = this_rq->cfs.runnable_load_avg;
+#else
+	load = this_rq->load.weight;
+#endif
 	/*
 	 * bail if there's load or we're actually up-to-date.
 	 */
@@ -2574,11 +2579,18 @@ void update_cpu_load_nohz(void)
  */
 static void update_cpu_load_active(struct rq *this_rq)
 {
+	unsigned long load;
+
+#ifdef CONFIG_SMP
+	load = this_rq->cfs.runnable_load_avg;
+#else
+	load = this_rq->load.weight;
+#endif
 	/*
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, this_rq->load.weight, 1);
+	__update_cpu_load(this_rq, load, 1);
 
 	calc_load_account_active(this_rq);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8cd19f3..0159c85 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2920,7 +2920,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->load.weight;
+	return cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
 /*
@@ -2965,9 +2965,10 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
+	unsigned long load_avg = rq->cfs.runnable_load_avg;
 
 	if (nr_running)
-		return rq->load.weight / nr_running;
+		return load_avg / nr_running;
 
 	return 0;
 }
-- 
1.7.5.4

