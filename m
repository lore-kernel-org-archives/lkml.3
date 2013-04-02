Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197Ab3DBDYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:24:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:45848 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab3DBDYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:24:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,391,1363158000"; 
   d="scan'208";a="310928562"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [patch v3 5/8] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
Date: Tue,  2 Apr 2013 11:23:25 +0800
Message-Id: <1364873008-3169-6-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364873008-3169-1-git-send-email-alex.shi@intel.com>
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com>
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
index e3233d3..a772de0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2534,7 +2534,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long load = this_rq->load.weight;
+	unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
 	unsigned long pending_updates;
 
 	/*
@@ -2584,7 +2584,7 @@ static void update_cpu_load_active(struct rq *this_rq)
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, this_rq->load.weight, 1);
+	__update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
 
 	calc_load_account_active(this_rq);
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 026e959..1f9026e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2900,7 +2900,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->load.weight;
+	return (unsigned long)cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
 /*
@@ -2947,7 +2947,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
 	if (nr_running)
-		return rq->load.weight / nr_running;
+		return (unsigned long)rq->cfs.runnable_load_avg / nr_running;
 
 	return 0;
 }
-- 
1.7.12

