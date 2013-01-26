Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3AZBtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:49:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:39598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab3AZBtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:49:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,542,1355126400"; 
   d="scan'208";a="276820873"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [RFC patch v2 5/7] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
Date: Sat, 26 Jan 2013 09:49:22 +0800
Message-Id: <1359164964-29052-6-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1359164964-29052-1-git-send-email-alex.shi@intel.com>
References: <1359164964-29052-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are the base values in load balance, update them with rq runnable
load average, then the load balance will consider runnable load avg
naturally.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c | 4 ++--
 kernel/sched/fair.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4f4714e..5da13ff 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2539,7 +2539,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long load = this_rq->load.weight;
+	unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
 	unsigned long pending_updates;
 
 	/*
@@ -2589,7 +2589,7 @@ static void update_cpu_load_active(struct rq *this_rq)
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, this_rq->load.weight, 1);
+	__update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
 
 	calc_load_account_active(this_rq);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 017e040..729221b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2905,7 +2905,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->load.weight;
+	return (unsigned long)cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
 /*
@@ -2952,7 +2952,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
 	if (nr_running)
-		return rq->load.weight / nr_running;
+		return (unsigned long)rq->cfs.runnable_load_avg / nr_running;
 
 	return 0;
 }
-- 
1.7.12

