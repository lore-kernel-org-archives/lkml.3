Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3GONta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:49:30 -0400
Received: from relay.parallels.com ([195.214.232.42]:42966 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3GONt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:49:29 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: <pjt@google.com>, <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH v2] sched: move h_load calculation to task_h_load
Date: Mon, 15 Jul 2013 17:49:19 +0400
Message-ID: <1373896159-1278-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130715105950.GA23818@dyad.programming.kicks-ass.net>
References: <20130715105950.GA23818@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.24.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bad thing about update_h_load(), which computes hierarchical load
factor for task groups, is that it is called for each task group in the
system before every load balancer run, and since rebalance can be
triggered very often, this function can eat really a lot of cpu time if
there are many cpu cgroups in the system.

Although the situation was improved significantly by commit a35b646
('sched, cgroup: Reduce rq->lock hold times for large cgroup
hierarchies'), the problem still can arise under some kinds of loads,
e.g. when cpus are switching from idle to busy and back very frequently.

For instance, when I start 1000 of processes that wake up every
millisecond on my 8 cpus host, 'top' and 'perf top' show:

Cpu(s): 17.8%us, 24.3%sy,  0.0%ni, 57.9%id,  0.0%wa,  0.0%hi,  0.0%si
Events: 243K cycles
  7.57%  [kernel]               [k] __schedule
  7.08%  [kernel]               [k] timerqueue_add
  6.13%  libc-2.12.so           [.] usleep

Then if I create 10000 *idle* cpu cgroups (no processes in them), cpu
usage increases significantly although the 'wakers' are still executing
in the root cpu cgroup:

Cpu(s): 19.1%us, 48.7%sy,  0.0%ni, 31.6%id,  0.0%wa,  0.0%hi,  0.7%si
Events: 230K cycles
 24.56%  [kernel]            [k] tg_load_down
  5.76%  [kernel]            [k] __schedule

This happens because this particular kind of load triggers 'new idle'
rebalance very frequently, which requires calling update_h_load(),
which, in turn, calls tg_load_down() for every *idle* cpu cgroup even
though it is absolutely useless, because idle cpu cgroups have no tasks
to pull.

This patch tries to improve the situation by making h_load calculation
proceed only when h_load is really necessary. To achieve this, it
substitutes update_h_load() with update_cfs_rq_h_load(), which computes
h_load only for a given cfs_rq and all its ascendants, and makes the
load balancer call this function whenever it considers if a task should
be pulled, i.e. it moves h_load calculations directly to task_h_load().
For h_load of the same cfs_rq not to be updated multiple times (in case
several tasks in the same cgroup are considered during the same balance
run), the patch keeps the time of the last h_load update for each cfs_rq
and breaks calculation when it finds h_load to be uptodate.

The benefit of it is that h_load is computed only for those cfs_rq's,
which really need it, in particular all idle task groups are skipped.
Although this, in fact, moves h_load calculation under rq lock, it
should not affect latency much, because the amount of work done under rq
lock while trying to pull tasks is limited by sched_nr_migrate.

After the patch applied with the setup described above (1000 wakers in
the root cgroup and 10000 idle cgroups), I get:

Cpu(s): 16.9%us, 24.8%sy,  0.0%ni, 58.4%id,  0.0%wa,  0.0%hi,  0.0%si
Events: 242K cycles
  7.57%  [kernel]                  [k] __schedule
  6.70%  [kernel]                  [k] timerqueue_add
  5.93%  libc-2.12.so              [.] usleep

Changes in v2:
 * use jiffies instead of rq->clock for last_h_load_update.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 kernel/sched/fair.c  |   58 +++++++++++++++++++++++---------------------------
 kernel/sched/sched.h |    7 +++---
 2 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f77f9c5..12d0137 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4171,47 +4171,48 @@ static void update_blocked_averages(int cpu)
 }
 
 /*
- * Compute the cpu's hierarchical load factor for each task group.
+ * Compute the hierarchical load factor for cfs_rq and all its ascendants.
  * This needs to be done in a top-down fashion because the load of a child
  * group is a fraction of its parents load.
  */
-static int tg_load_down(struct task_group *tg, void *data)
+static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
 {
-	unsigned long load;
-	long cpu = (long)data;
-
-	if (!tg->parent) {
-		load = cpu_rq(cpu)->avg.load_avg_contrib;
-	} else {
-		load = tg->parent->cfs_rq[cpu]->h_load;
-		load = div64_ul(load * tg->se[cpu]->avg.load_avg_contrib,
-				tg->parent->cfs_rq[cpu]->runnable_load_avg + 1);
-	}
-
-	tg->cfs_rq[cpu]->h_load = load;
-
-	return 0;
-}
-
-static void update_h_load(long cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
+	struct rq *rq = rq_of(cfs_rq);
+	struct sched_entity *se = cfs_rq->tg->se[cpu_of(rq)];
 	unsigned long now = jiffies;
+	unsigned long load;
 
-	if (rq->h_load_throttle == now)
+	if (cfs_rq->last_h_load_update == now)
 		return;
 
-	rq->h_load_throttle = now;
+	cfs_rq->h_load_next = NULL;
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+		cfs_rq->h_load_next = se;
+		if (cfs_rq->last_h_load_update == now)
+			break;
+	}
 
-	rcu_read_lock();
-	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
-	rcu_read_unlock();
+	if (!se) {
+		cfs_rq->h_load = rq->avg.load_avg_contrib;
+		cfs_rq->last_h_load_update = now;
+	}
+
+	while ((se = cfs_rq->h_load_next) != NULL) {
+		load = cfs_rq->h_load;
+		load = div64_ul(load * se->avg.load_avg_contrib,
+				cfs_rq->runnable_load_avg + 1);
+		cfs_rq = group_cfs_rq(se);
+		cfs_rq->h_load = load;
+		cfs_rq->last_h_load_update = now;
+	}
 }
 
 static unsigned long task_h_load(struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 
+	update_cfs_rq_h_load(cfs_rq);
 	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
 			cfs_rq->runnable_load_avg + 1);
 }
@@ -4220,10 +4221,6 @@ static inline void update_blocked_averages(int cpu)
 {
 }
 
-static inline void update_h_load(long cpu)
-{
-}
-
 static unsigned long task_h_load(struct task_struct *p)
 {
 	return p->se.avg.load_avg_contrib;
@@ -5108,7 +5105,6 @@ redo:
 		env.src_rq    = busiest;
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
 
-		update_h_load(env.src_cpu);
 more_balance:
 		local_irq_save(flags);
 		double_rq_lock(env.dst_rq, busiest);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ef0a7b2..5e129ef 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -285,7 +285,6 @@ struct cfs_rq {
 	/* Required to track per-cpu representation of a task_group */
 	u32 tg_runnable_contrib;
 	unsigned long tg_load_contrib;
-#endif /* CONFIG_FAIR_GROUP_SCHED */
 
 	/*
 	 *   h_load = weight * f(tg)
@@ -294,6 +293,9 @@ struct cfs_rq {
 	 * this group.
 	 */
 	unsigned long h_load;
+	u64 last_h_load_update;
+	struct sched_entity *h_load_next;
+#endif /* CONFIG_FAIR_GROUP_SCHED */
 #endif /* CONFIG_SMP */
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -429,9 +431,6 @@ struct rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
-#ifdef CONFIG_SMP
-	unsigned long h_load_throttle;
-#endif /* CONFIG_SMP */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
-- 
1.7.10.4

