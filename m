Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaIDQcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:32:05 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:49869 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847AbaIDQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:31:21 -0400
X-Yandex-Uniq: f53be01d-404b-47d4-b2ac-d036d1a5a688
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 10/19] smart: smart gathering
Date: Thu,  4 Sep 2014 20:30:56 +0400
Message-Id: <1409848265-17150-10-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

Previous patch denies starting new CFS tasks on a core with running rt
tasks. The problem still exists if there are already running CFS tasks
at the moment rt task starts.
This patch introduces smart gathering - migration of running CFS tasks
from all other CPUs to the CPU with rt task.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/sched/core.c  | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h | 14 ++++++++
 kernel/sysctl.c      |  1 +
 3 files changed, 113 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9d888610c..5954f48 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2753,6 +2753,8 @@ void scheduler_tick(void)
 	curr->sched_class->task_tick(rq, curr, 0);
 	raw_spin_unlock(&rq->lock);
 
+	smart_tick(cpu);
+
 	perf_event_task_tick();
 
 #ifdef CONFIG_SMP
@@ -4921,6 +4923,97 @@ static int migration_cpu_stop(void *data)
 }
 
 #ifdef CONFIG_SMART
+
+DEFINE_PER_CPU_SHARED_ALIGNED(struct smart_gathering, smart_gathering_data);
+
+static int smart_gathering_cpu_stop(void *data)
+{
+	int this_cpu = smp_processor_id();
+	int dest_cpu = cpu_core_id(this_cpu);
+	struct rq *rq = cpu_rq(this_cpu);
+	struct task_struct *next;
+	struct smart_gathering *sg;
+	unsigned long flags;
+	int ret;
+	int iter;
+
+	WARN_ON(this_cpu == dest_cpu);
+
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	for (iter = 0; iter < rq->cfs.h_nr_running; iter++) {
+		next = fair_sched_class.pick_next_task(rq);
+		if (!next)
+			break;
+		next->sched_class->put_prev_task(rq, next);
+
+		if (!cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(next)) ||
+		    !cpu_online(dest_cpu))
+			break;
+
+		raw_spin_unlock(&rq->lock);
+		ret = __migrate_task(next, this_cpu, dest_cpu);
+		raw_spin_lock(&rq->lock);
+
+		if (!ret)
+			break;
+	}
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+
+	sg = &smart_gathering_data(this_cpu);
+	spin_lock_irqsave(&sg->lock, flags);
+	WARN_ON(!sg->gather);
+	sg->gather = 0;
+	spin_unlock_irqrestore(&sg->lock, flags);
+
+	return 0;
+}
+
+void smart_tick(int cpu)
+{
+	unsigned long flags;
+	struct smart_gathering *sg;
+	int gather = 0;
+	struct rq *rq;
+	int core;
+	struct task_struct *curr;
+
+	if (idle_cpu(cpu) || !smart_enabled() ||
+	    !static_key_true(&smart_cfs_gather))
+		return;
+
+	rcu_read_lock();
+
+	core = cpu_core_id(cpu);
+	if (cpu != core) {
+		rq = cpu_rq(core);
+		curr = rq->curr;
+		if (rt_task(curr) && curr->mm)
+			gather = 1;
+
+		rq = cpu_rq(cpu);
+		curr = rq->curr;
+		if (rt_task(curr))
+			gather = 0;
+	}
+
+	if (gather) {
+		sg = &smart_gathering_data(cpu);
+
+		spin_lock_irqsave(&sg->lock, flags);
+		if (sg->gather)
+			gather = 0;
+		else
+			sg->gather = 1;
+		spin_unlock_irqrestore(&sg->lock, flags);
+	}
+
+	rcu_read_unlock();
+
+	if (gather)
+		stop_one_cpu_nowait(cpu, smart_gathering_cpu_stop, NULL,
+				    &sg->work);
+}
+
 int smart_migrate_task(struct task_struct *p, int prev_cpu,
 		       int dest_cpu)
 {
@@ -7093,6 +7186,11 @@ void __init sched_init(void)
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
+
+#ifdef CONFIG_SMART
+		spin_lock_init(&smart_gathering_data(i).lock);
+		smart_gathering_data(i).gather = 0;
+#endif
 	}
 
 	set_load_weight(&init_task);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c7c1cdc..80d202e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1394,11 +1394,19 @@ struct smart_node_data {
 	atomic_t nr_rt_running;
 } ____cacheline_aligned_in_smp;
 
+struct smart_gathering {
+	spinlock_t lock;
+	int gather;
+	struct cpu_stop_work work;
+};
+
 extern struct static_key __smart_initialized;
 extern struct static_key __smart_enabled;
+extern struct static_key smart_cfs_gather;
 extern struct static_key smart_cfs_throttle;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(struct smart_core_data, smart_core_data);
+DECLARE_PER_CPU_SHARED_ALIGNED(struct smart_gathering, smart_gathering_data);
 extern struct smart_node_data smart_node_data[MAX_NUMNODES];
 
 static inline int cpu_core_id(int cpu)
@@ -1408,6 +1416,7 @@ static inline int cpu_core_id(int cpu)
 
 #define smart_data(cpu) per_cpu(smart_core_data, cpu_core_id(cpu))
 #define smart_node_ptr(cpu) smart_node_data[cpu_to_node(cpu)]
+#define smart_gathering_data(cpu) per_cpu(smart_gathering_data, cpu)
 
 static inline bool smart_enabled(void)
 {
@@ -1586,6 +1595,7 @@ static inline void reset_smart_score(struct sched_rt_entity *rt_se)
 	atomic_set(&rt_se->smart_score, 0);
 }
 
+void smart_tick(int cpu);
 int smart_migrate_task(struct task_struct *p, int prev_cpu, int dest_cpu);
 void build_smart_topology(void);
 
@@ -1620,4 +1630,8 @@ static inline bool cpu_allowed_for_cfs(int cpu)
 	return true;
 }
 
+static inline void smart_tick(int cpu)
+{
+}
+
 #endif /* CONFIG_SMART */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7ee22ef..a1e71e9 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -176,6 +176,7 @@ extern int no_unaligned_warning;
 #endif
 
 #ifdef CONFIG_SMART
+struct static_key smart_cfs_gather = STATIC_KEY_INIT_TRUE;
 struct static_key smart_cfs_throttle = STATIC_KEY_INIT_TRUE;
 #endif
 
-- 
1.9.3

