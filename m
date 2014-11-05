Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaKEJAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:00:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:20156 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaKEJAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:00:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,318,1413270000"; 
   d="scan'208";a="626841689"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@arm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [RFC PATCH v2] sched/deadline: support dl task migration during cpu hotplug
Date: Wed,  5 Nov 2014 16:51:57 +0800
Message-Id: <1415177517-7189-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I observe that dl task can't be migrated to other cpus during cpu hotplug, in
addition, task may/may not be running again if cpu is added back. The root cause
which I found is that dl task will be throtted and removed from dl rq after
comsuming all budget, which leads to stop task can't pick it up from dl rq and
migrate to other cpus during hotplug.

The method to reproduce:
schedtool -E -t 50000:100000 -e ./test
Actually test is just a simple for loop. Then observe which cpu the test
task is on.
echo 0 > /sys/devices/system/cpu/cpuN/online

This patch fix it by push the task to another cpu in dl_task_timer() if 
rq is offline.

Note: dl task can be migrated successfully if rq is offline currently, however, 
I'm still not sure why task_rq(task)->rd->span just include the cpu which the dl 
task previous running on, so cpu_active_mask is used in the patch. 

Peterz, Juri?

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v1 -> v2:
 * push the task to another cpu in dl_task_timer() if rq is offline.

 kernel/sched/deadline.c | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 04c2cbb..233e482 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -487,6 +487,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
 	return hrtimer_active(&dl_se->dl_timer);
 }
 
+static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq);
 /*
  * This is the bandwidth enforcement timer callback. If here, we know
  * a task is not on its dl_rq, since the fact that the timer was running
@@ -538,6 +539,39 @@ again:
 	update_rq_clock(rq);
 	dl_se->dl_throttled = 0;
 	dl_se->dl_yielded = 0;
+
+	/*
+	 * So if we find that the rq the task was on is no longer
+	 * available, we need to select a new rq.
+	 */
+	if (!rq->online) {
+		struct rq *later_rq = NULL;
+
+		/* We will release rq lock */
+		get_task_struct(p);
+
+		raw_spin_unlock(&rq->lock);
+
+		later_rq = find_lock_later_rq(p, rq);
+
+		if (!later_rq) {
+			put_task_struct(p);
+			goto out;
+		}
+
+		deactivate_task(rq, p, 0);
+		set_task_cpu(p, later_rq->cpu);
+		activate_task(later_rq, p, 0);
+
+		resched_curr(later_rq);
+
+		double_unlock_balance(rq, later_rq);
+
+		put_task_struct(p);
+
+		goto out;
+	}
+
 	if (task_on_rq_queued(p)) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
 		if (dl_task(rq->curr))
@@ -555,7 +589,7 @@ again:
 	}
 unlock:
 	raw_spin_unlock(&rq->lock);
-
+out:
 	return HRTIMER_NORESTART;
 }
 
@@ -1182,8 +1216,7 @@ static int find_later_rq(struct task_struct *task)
 	 * We have to consider system topology and task affinity
 	 * first, then we can look for a suitable cpu.
 	 */
-	cpumask_copy(later_mask, task_rq(task)->rd->span);
-	cpumask_and(later_mask, later_mask, cpu_active_mask);
+	cpumask_copy(later_mask, cpu_active_mask);
 	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
 	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
 			task, later_mask);
-- 
1.9.1

