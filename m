Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab3EJPRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:17:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:13258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab3EJPRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,648,1363158000"; 
   d="scan'208";a="334911061"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: [patch v6 3/8] sched: set initial value of runnable avg for new forked task
Date: Fri, 10 May 2013 23:17:24 +0800
Message-Id: <1368199049-2798-4-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need initialize the se.avg.{decay_count, load_avg_contrib} for a
new forked task.
Otherwise random values of above variables cause mess when do new task
enqueue:
    enqueue_task_fair
        enqueue_entity
            enqueue_entity_load_avg

and make forking balancing imbalance since incorrect load_avg_contrib.

Further more, Morten Rasmussen notice some tasks were not launched at
once after created. So Paul and Peter suggest giving a start value for
new task runnable avg time same as sched_slice().

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c  |    6 ++----
 kernel/sched/fair.c  |   23 +++++++++++++++++++++++
 kernel/sched/sched.h |    2 ++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c8db984..866c05a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1563,10 +1563,6 @@ static void __sched_fork(struct task_struct *p)
 	p->se.vruntime			= 0;
 	INIT_LIST_HEAD(&p->se.group_node);
 
-#ifdef CONFIG_SMP
-	p->se.avg.runnable_avg_period = 0;
-	p->se.avg.runnable_avg_sum = 0;
-#endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
@@ -1710,6 +1706,8 @@ void wake_up_new_task(struct task_struct *p)
 	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
 #endif
 
+	/* Give new task start runnable values */
+	set_task_runnable_avg(p);
 	rq = __task_rq_lock(p);
 	activate_task(rq, p, 0);
 	p->on_rq = 1;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9c2f726..203f236 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -661,6 +661,26 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
+#ifdef CONFIG_SMP
+static inline void __update_task_entity_contrib(struct sched_entity *se);
+
+/* Give new task start runnable values to heavy its load in infant time */
+void set_task_runnable_avg(struct task_struct *p)
+{
+	u32 slice;
+
+	p->se.avg.decay_count = 0;
+	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
+	p->se.avg.runnable_avg_sum = slice;
+	p->se.avg.runnable_avg_period = slice;
+	__update_task_entity_contrib(&p->se);
+}
+#else
+void set_task_runnable_avg(struct task_struct *p)
+{
+}
+#endif
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -1508,6 +1528,9 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	 * We track migrations using entity decay_count <= 0, on a wake-up
 	 * migration we use a negative decay count to track the remote decays
 	 * accumulated while sleeping.
+	 *
+	 * When enqueue a new forked task, the se->avg.decay_count == 0, so
+	 * we bypass update_entity_load_avg(), use avg.load_avg_contrib direct.
 	 */
 	if (unlikely(se->avg.decay_count <= 0)) {
 		se->avg.last_runnable_update = rq_of(cfs_rq)->clock_task;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c6634f1..518f3d8a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -900,6 +900,8 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
 
 extern void update_idle_cpu_load(struct rq *this_rq);
 
+extern void set_task_runnable_avg(struct task_struct *p);
+
 #ifdef CONFIG_CGROUP_CPUACCT
 #include <linux/cgroup.h>
 /* track cpu usage of a group of tasks and its child groups */
-- 
1.7.5.4

