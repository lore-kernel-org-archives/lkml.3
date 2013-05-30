Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967751Ab3E3HER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:04:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:60704 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967688Ab3E3HDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:03:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,769,1363158000"; 
   d="scan'208";a="345550480"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>
Subject: [patch v7 6/8] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
Date: Thu, 30 May 2013 15:02:02 +0800
Message-Id: <1369897324-16646-7-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1369897324-16646-1-git-send-email-alex.shi@intel.com>
References: <1369897324-16646-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are the base values in load balance, update them with rq runnable
load average, then the load balance will consider runnable load avg
naturally.

We also try to include the blocked_load_avg as cpu load in balancing,
but that cause kbuild performance drop 6% on every Intel machine, and
aim7/oltp drop on some of 4 CPU sockets machines.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |  5 +++--
 kernel/sched/proc.c | 17 +++++++++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 42c7be0..eadd2e7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2962,7 +2962,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->load.weight;
+	return cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
 /*
@@ -3007,9 +3007,10 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
+	unsigned long load_avg = rq->cfs.runnable_load_avg;
 
 	if (nr_running)
-		return rq->load.weight / nr_running;
+		return load_avg / nr_running;
 
 	return 0;
 }
diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index bb3a6a0..ce5cd48 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -501,6 +501,18 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 	sched_avg_update(this_rq);
 }
 
+#ifdef CONFIG_SMP
+unsigned long get_rq_runnable_load(struct rq *rq)
+{
+	return rq->cfs.runnable_load_avg;
+}
+#else
+unsigned long get_rq_runnable_load(struct rq *rq)
+{
+	return rq->load.weight;
+}
+#endif
+
 #ifdef CONFIG_NO_HZ_COMMON
 /*
  * There is no sane way to deal with nohz on smp when using jiffies because the
@@ -522,7 +534,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long load = this_rq->load.weight;
+	unsigned long load = get_rq_runnable_load(this_rq);
 	unsigned long pending_updates;
 
 	/*
@@ -568,11 +580,12 @@ void update_cpu_load_nohz(void)
  */
 void update_cpu_load_active(struct rq *this_rq)
 {
+	unsigned long load = get_rq_runnable_load(this_rq);
 	/*
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, this_rq->load.weight, 1);
+	__update_cpu_load(this_rq, load, 1);
 
 	calc_load_account_active(this_rq);
 }
-- 
1.7.12

