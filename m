Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965856Ab3E2LEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:04:05 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:10568 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965751Ab3E2LEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:04:00 -0400
From: Glauber Costa <glommer@openvz.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, <cgroups@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <devel@openvz.org>,
        Glauber Costa <glommer@openvz.org>
Subject: [PATCH v7 10/11] sched: change nr_context_switches calculation.
Date: Wed, 29 May 2013 15:03:21 +0400
Message-Id: <1369825402-31046-11-git-send-email-glommer@openvz.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369825402-31046-1-git-send-email-glommer@openvz.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the calculation of nr_context_switches. The variable
"nr_switches" is now used to account for the number of transition to the
idle task, or stop task. It is removed from the schedule() path.

The total calculation can be made using the fact that the transitions to
fair and rt classes are recorded in the root_task_group. One can easily
derive the total figure by adding those quantities together.

Signed-off-by: Glauber Costa <glommer@openvz.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>
---
 kernel/sched/core.c      | 17 +++++++++++++++--
 kernel/sched/idle_task.c |  3 +++
 kernel/sched/stop_task.c |  2 ++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3b1441f..892c828 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2031,13 +2031,27 @@ unsigned long nr_running(void)
 	return sum;
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+#define cfs_nr_switches(tg, cpu) (tg)->cfs_rq[cpu]->nr_switches
+#else
+#define cfs_nr_switches(tg, cpu) cpu_rq(cpu)->cfs.nr_switches
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+#define rt_nr_switches(tg, cpu) (tg)->rt_rq[cpu]->rt_nr_switches
+#else
+#define rt_nr_switches(tg, cpu) cpu_rq(cpu)->rt.rt_nr_switches
+#endif
+
 unsigned long long nr_context_switches(void)
 {
 	int i;
 	unsigned long long sum = 0;
 
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
+		sum += cfs_nr_switches(&root_task_group, i);
+		sum += rt_nr_switches(&root_task_group, i);
 		sum += cpu_rq(i)->nr_switches;
+	}
 
 	return sum;
 }
@@ -2417,7 +2431,6 @@ need_resched:
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
-		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
 
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 4f0a332..923286c 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -39,6 +39,9 @@ pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 	if (prev)
 		prev->sched_class->put_prev_task(rq, prev);
 
+	if (prev != rq->idle)
+		rq->nr_switches++;
+
 	schedstat_inc(rq, sched_goidle);
 #ifdef CONFIG_SMP
 	/* Trigger the post schedule to do an idle_enter for CFS */
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 6adf6a9..48c572a 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -32,6 +32,8 @@ pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 		stop->se.exec_start = rq_clock_task(rq);
 		if (prev)
 			prev->sched_class->put_prev_task(rq, prev);
+		if (prev != rq->stop)
+			rq->nr_switches++;
 		return stop;
 	}
 
-- 
1.8.1.4

