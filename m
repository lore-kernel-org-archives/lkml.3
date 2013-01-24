Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab3AXDjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:39:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:14248 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab3AXDaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="247742567"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [PATCH 2/4] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
Date: Thu, 24 Jan 2013 11:30:41 +0800
Message-Id: <1358998243-23176-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1358998243-23176-1-git-send-email-alex.shi@intel.com>
References: <1358998243-23176-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are the base values in load balance, update them with rq runnable
load average, then the load balance will consider runnable load avg
naturally.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c |    8 ++++++++
 kernel/sched/fair.c |    4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4f4714e..f25b8d8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2539,7 +2539,11 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+	unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
+#else
 	unsigned long load = this_rq->load.weight;
+#endif
 	unsigned long pending_updates;
 
 	/*
@@ -2589,7 +2593,11 @@ static void update_cpu_load_active(struct rq *this_rq)
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
+#if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
+	__update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
+#else
 	__update_cpu_load(this_rq, this_rq->load.weight, 1);
+#endif
 
 	calc_load_account_active(this_rq);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7697171..9148bcc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2909,7 +2909,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->load.weight;
+	return (unsigned long)cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
 /*
@@ -2956,7 +2956,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
 	if (nr_running)
-		return rq->load.weight / nr_running;
+		return (unsigned long)rq->cfs.runnable_load_avg / nr_running;
 
 	return 0;
 }
-- 
1.7.0.1

