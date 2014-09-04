Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaIDQcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:32:07 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:49865 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501AbaIDQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:31:21 -0400
X-Yandex-Uniq: 2ebf3a78-d380-4834-a116-ed767ee1bd77
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 08/19] smart: smart pull
Date: Thu,  4 Sep 2014 20:30:54 +0400
Message-Id: <1409848265-17150-8-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

This patch implements migration of running rt tasks (aka "smart pull").
The idea is quite simple: if there are free cores, there is no reason to
suffer from hyper-threading.

The implementation is a bit trickier:
in pre_schedule() we check, if we are switching from rt task to
non-rt (CFS or idle), and if so, we schedule a delayed work. This work
searches for a rt tasks, which is the best candidate for migrating (has
maximal smart_score). If there is a such candidate, migration occurs.
Such migration always occurs from non-first SMT thread on source core to
first SMT thread on destination core.

Smart score are counting in the following way: for each running rt task
on each scheduler tick we check if there are tasks concurrently running
on the same core. If so, we add this number to smart score.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 include/linux/sched.h |   3 ++
 kernel/sched/core.c   |  35 +++++++++++++++++
 kernel/sched/rt.c     | 107 +++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/sched.h  |  10 +++++
 4 files changed, 154 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 597c8ab..49b7361 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1023,6 +1023,9 @@ struct sched_rt_entity {
 	/* rq "owned" by this entity/group: */
 	struct rt_rq		*my_q;
 #endif
+#ifdef CONFIG_SMART
+	atomic_t smart_score;
+#endif
 };
 
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 832b3d0..9d888610c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4920,6 +4920,41 @@ static int migration_cpu_stop(void *data)
 	return 0;
 }
 
+#ifdef CONFIG_SMART
+int smart_migrate_task(struct task_struct *p, int prev_cpu,
+		       int dest_cpu)
+{
+	unsigned long flags;
+	struct rq *rq;
+
+	rq = task_rq_lock(p, &flags);
+
+	/* Something has changed? Do nothing. */
+	if (unlikely(prev_cpu != cpu_of(rq)))
+		goto out;
+
+	if (unlikely(!rt_task(p)))
+		goto out;
+
+	if (p->nr_cpus_allowed == 1 ||
+	    !cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+		goto out;
+
+	if (p->on_rq) {
+		struct migration_arg arg = { p, dest_cpu };
+		/* Need help from migration thread: drop lock and wait. */
+		task_rq_unlock(rq, p, &flags);
+		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
+		tlb_migrate_finish(p->mm);
+		return 0;
+	}
+out:
+	task_rq_unlock(rq, p, &flags);
+
+	return -1;
+}
+#endif
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 /*
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 3202ab4..7ef0fd0 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 
 #ifdef CONFIG_SMART
+#include <linux/workqueue.h>
 #include <linux/jump_label.h>
 
 struct static_key __smart_initialized = STATIC_KEY_INIT_FALSE;
@@ -18,12 +19,26 @@ DEFINE_PER_CPU_SHARED_ALIGNED(struct smart_core_data, smart_core_data);
 struct smart_node_data smart_node_data[MAX_NUMNODES] ____cacheline_aligned_in_smp;
 
 static int smart_find_lowest_rq(struct task_struct *task, bool wakeup);
+static void update_curr_smart(struct rq *rq, struct task_struct *p);
+static void pre_schedule_smart(struct rq *rq, struct task_struct *prev);
+
+static void smart_pull(struct work_struct *dummy);
+static DECLARE_WORK(smart_work, smart_pull);
+
 
 #else /* CONFIG_SMART */
 static inline int smart_find_lowest_rq(struct task_struct *task, bool wakeup)
 {
 	return -1;
 }
+
+static void update_curr_smart(struct rq *rq, struct task_struct *p)
+{
+}
+
+static void pre_schedule_smart(struct rq *rq, struct task_struct *prev)
+{
+}
 #endif /* CONFIG_SMART */
 
 int sched_rr_timeslice = RR_TIMESLICE;
@@ -1211,9 +1226,12 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
 
-	if (flags & ENQUEUE_WAKEUP)
+	if (flags & ENQUEUE_WAKEUP) {
 		rt_se->timeout = 0;
 
+		reset_smart_score(rt_se);
+	}
+
 	enqueue_rt_entity(rt_se, flags & ENQUEUE_HEAD);
 
 	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
@@ -1845,6 +1863,8 @@ static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 	/* Try to pull RT tasks here if we lower this rq's prio */
 	if (rq->rt.highest_prio.curr > prev->prio)
 		pull_rt_task(rq);
+
+	pre_schedule_smart(rq, prev);
 }
 
 static void post_schedule_rt(struct rq *rq)
@@ -2058,6 +2078,8 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 
 	update_curr_rt(rq);
 
+	update_curr_smart(rq, p);
+
 	watchdog(rq, p);
 
 	/*
@@ -2365,4 +2387,87 @@ static int smart_find_lowest_rq(struct task_struct *task, bool wakeup)
 	rcu_read_unlock();
 	return best_cpu;
 }
+
+static void smart_pull(struct work_struct *dummy)
+{
+	int this_cpu = smp_processor_id();
+	int cpu;
+	struct rq *rq = cpu_rq(this_cpu);
+	struct task_struct *task;
+	int points;
+	struct task_struct *best_task = NULL;
+	int best_points = 2;
+
+	if (rq->rt.rt_nr_running > 0)
+		return;
+
+	if (core_acquired(this_cpu))
+		return;
+
+	rcu_read_lock();
+	for_each_online_cpu(cpu) {
+		if (cpu == cpu_core_id(cpu))
+			continue;
+
+		rq = cpu_rq(cpu);
+		if (!rq->rt.rt_nr_running)
+			continue;
+
+		task = ACCESS_ONCE(rq->curr);
+		if (!rt_task(task))
+			continue;
+
+		points = atomic_read(&task->rt.smart_score);
+		if (points > best_points) {
+			best_task = task;
+			best_points = points;
+		}
+	}
+
+	if (!best_task) {
+		rcu_read_unlock();
+		return;
+	}
+
+	get_task_struct(best_task);
+	rcu_read_unlock();
+
+	smart_migrate_task(best_task, task_cpu(best_task), this_cpu);
+
+	put_task_struct(best_task);
+}
+
+static void update_curr_smart(struct rq *this_rq, struct task_struct *p)
+{
+	int this_cpu = cpu_of(this_rq);
+	int cpu;
+	struct rq *rq;
+	int points = 0;
+
+	for_each_cpu(cpu, topology_thread_cpumask(this_cpu)) {
+		if (cpu == this_cpu)
+			continue;
+
+		rq = cpu_rq(cpu);
+
+		points += rq->nr_running;
+	}
+
+	if (points)
+		atomic_add(points, &p->rt.smart_score);
+}
+
+static void pre_schedule_smart(struct rq *rq, struct task_struct *prev)
+{
+	if (smart_enabled()) {
+		int cpu = cpu_of(rq);
+
+		if (cpu == cpu_core_id(cpu) && !rq->rt.rt_nr_running) {
+			/* Try to pull rt tasks */
+			raw_spin_unlock(&rq->lock);
+			schedule_work_on(cpu, &smart_work);
+			raw_spin_lock(&rq->lock);
+		}
+	}
+}
 #endif /* CONFIG_SMART */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index dd539ca..463fdbe 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1565,6 +1565,12 @@ static inline int find_rt_best_thread(int start_cpu, struct task_struct *task)
 	return best_cpu;
 }
 
+static inline void reset_smart_score(struct sched_rt_entity *rt_se)
+{
+	atomic_set(&rt_se->smart_score, 0);
+}
+
+int smart_migrate_task(struct task_struct *p, int prev_cpu, int dest_cpu);
 void build_smart_topology(void);
 
 #else /* CONFIG_SMART */
@@ -1589,4 +1595,8 @@ static inline void dec_node_running(int cpu)
 {
 }
 
+static inline void reset_smart_score(struct sched_rt_entity *rt_se)
+{
+}
+
 #endif /* CONFIG_SMART */
-- 
1.9.3

