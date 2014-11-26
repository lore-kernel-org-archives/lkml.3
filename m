Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaKZApd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:45:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:59970 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaKZApa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:45:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,459,1413270000"; 
   d="scan'208";a="628294387"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v6 7/7] sched/deadline: support dl task migration during cpu hotplug
Date: Wed, 26 Nov 2014 08:44:07 +0800
Message-Id: <1416962647-76792-8-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I observe that dl task can't be migrated to other cpus during cpu hotplug,
in addition, task may/may not be running again if cpu is added back. The
root cause which I found is that dl task will be throtted and removed from
dl rq after comsuming all budget, which leads to stop task can't pick it up
from dl rq and migrate to other cpus during hotplug.

The method to reproduce:
schedtool -E -t 50000:100000 -e ./test
Actually test is just a simple for loop. Then observe which cpu the test
task is on.
echo 0 > /sys/devices/system/cpu/cpuN/online

This patch adds the dl task migration during cpu hotplug by finding a most
suitable later deadline rq after dl timer fire if current rq is offline,
if fail to find a suitable later deadline rq then fallback to any eligible
online cpu in order that the deadline task will come back to us, and the
push/pull mechanism should then move it around properly.

Cc: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v5 -> v6:
 * add double_lock_balance in the fallback path
v4 -> v5:
 * remove raw_spin_unlock(&rq->lock)
 * cleanup codes, spotted by Peterz
 * cleanup patch description
v3 -> v4:
 * use tsk_cpus_allowed wrapper
 * fix compile error
v2 -> v3:
 * don't get_task_struct
 * if cannot preempt any rq, fallback to pick any online cpus
 * use cpu_active_mask as original later_mask if cpu is offline
v1 -> v2:
 * push the task to another cpu in dl_task_timer() if rq is offline.

 kernel/sched/deadline.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b102f35..b907fdf 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -487,6 +487,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
 	return hrtimer_active(&dl_se->dl_timer);
 }
 
+static struct rq *find_lock_later_rq(struct task_struct *task, struct rq *rq);
 /*
  * This is the bandwidth enforcement timer callback. If here, we know
  * a task is not on its dl_rq, since the fact that the timer was running
@@ -538,6 +539,44 @@ again:
 	update_rq_clock(rq);
 	dl_se->dl_throttled = 0;
 	dl_se->dl_yielded = 0;
+
+	/*
+	 * So if we find that the rq the task was on is no longer
+	 * available, we need to select a new rq.
+	 */
+	if (unlikely(!rq->online)) {
+		struct rq *later_rq = NULL;
+
+		later_rq = find_lock_later_rq(p, rq);
+
+		if (!later_rq) {
+			int cpu;
+
+			/*
+			 * If cannot preempt any rq, fallback to pick any
+			 * online cpu.
+			 */
+			cpu = cpumask_any_and(cpu_active_mask,
+					tsk_cpus_allowed(p));
+			if (cpu >= nr_cpu_ids) {
+				pr_warn("fail to find any online cpu and task will never come back\n");
+				goto unlock;
+			}
+			later_rq = cpu_rq(cpu);
+			double_lock_balance(rq, later_rq);
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
+		goto unlock;
+	}
+
 	if (task_on_rq_queued(p)) {
 		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
 		if (dl_task(rq->curr))
@@ -1196,8 +1235,9 @@ static int find_later_rq(struct task_struct *task)
 	 * We have to consider system topology and task affinity
 	 * first, then we can look for a suitable cpu.
 	 */
-	cpumask_copy(later_mask, task_rq(task)->rd->span);
-	cpumask_and(later_mask, later_mask, cpu_active_mask);
+	cpumask_copy(later_mask, cpu_active_mask);
+	if (likely(task_rq(task)->online))
+		cpumask_and(later_mask, later_mask, task_rq(task)->rd->span);
 	cpumask_and(later_mask, later_mask, &task->cpus_allowed);
 	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
 			task, later_mask);
-- 
1.9.1

