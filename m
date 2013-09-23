Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3IWTkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:40:16 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:31981 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3IWTkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:40:11 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH 2/2] sched, numa: reduce load/runnable_avg computation frequency
Date: Mon, 23 Sep 2013 15:39:23 -0400
Message-Id: <1379965163-18440-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1379965163-18440-1-git-send-email-Waiman.Long@hp.com>
References: <1379965163-18440-1-git-send-email-Waiman.Long@hp.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For large NUMA machine, there can be significant cacheline contention
due to the computation of the task_group's load_avg and runnable_avg
values, which should happen more or less simultaneously if the clock
ticks of the CPUs are synchronized. If they are not (like with the
highres=off clocksource=tsc kernel command-line options), it will not
be an issue at all. Having heavy cacheline contention reduces the CPU
cycles for other tasks. As a result, it may be desirable to reduce
the frequency of those computations. This trades less up-to-date
load data with slight better performance.

The frequency reduction is currently determined by the number of nodes
in the NUMA machine. An 8-node machine will have its load computation
frequency reduce to 1/8 of the original. The selection of cores for
load_avg computation are such that they are clustered around 2 nodes
each time to reduce inter-socket contention as much as possible for
each clock tick.

This frequency reduction feature is optional and is enabled by setting
the FGS_SPARSE_AVG configuration parameter. The table below shows the
performance difference of running kernbench (3.11 allmodconfig) with
this parameter enabled and disabled on a 3.11 kernel (with the tg load
reduction patch) on a 8-node 80-core DL980 with Westmere-EX processors:

FGS_SPARSE_AVG	HT	E.Time	S.Time	U.Time
--------------	--	------	------	------
    off		off	149.3s	914.5s	6153.8s
    on		off	149.1s	910.6s	6111.8s
    off		on	140.0s	1313.3s	9944.3s
    on		on	138.2s	1316.7s	9907.1s

There are some slight decreases in the elapsed time as well as the
reported system and user times.

The follow perf profile shows the %CPU cycles spent in the scheduler
tick related functions with FGS_SPARSE_AVG off:

  3.77%     cc1  [kernel.kallsyms]   [k] update_cfs_rq_blocked_load
  1.50%     cc1  [kernel.kallsyms]   [k] update_curr
  0.78%     cc1  [kernel.kallsyms]   [k] update_cfs_shares
  0.11%     cc1  [kernel.kallsyms]   [k] entity_tick

With FGS_SPARSE_AVG on, the profile becomes:

  0.84%     cc1  [kernel.kallsyms]   [k] update_cfs_rq_blocked_load
  0.27%     cc1  [kernel.kallsyms]   [k] entity_tick
  0.04%     cc1  [kernel.kallsyms]   [k] update_curr
  0.07%     cc1  [kernel.kallsyms]   [k] update_cfs_shares

So there are significant reduction in the cpu time spent in those
functions.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 init/Kconfig         |   13 +++++++++++
 kernel/sched/core.c  |    1 +
 kernel/sched/fair.c  |   55 +++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/sched.h |   23 ++++++++++++++++++++
 4 files changed, 91 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index fed81b5..24ca9f1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1033,6 +1033,19 @@ config RT_GROUP_SCHED
 	  realtime bandwidth for them.
 	  See Documentation/scheduler/sched-rt-group.txt for more information.
 
+config FGS_SPARSE_AVG
+	bool "Less frequent load computation to reduce overhead"
+	depends on FAIR_GROUP_SCHED
+	depends on NUMA
+	default n
+	help
+	  This option reduces the frequency of doing average load computation
+	  at clock tick time to reduce overhead and cacheline contention on a
+	  NUMA systems. The frequency reduction factor is determined by the
+	  number of nodes in the NUMA machine. It can slightly improve the
+	  performance of a NUMA system at the expense of less up-to-date
+	  average load value.
+
 endif #CGROUP_SCHED
 
 config BLK_CGROUP
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 05c39f0..55595d2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6360,6 +6360,7 @@ void __init sched_init_smp(void)
 	free_cpumask_var(non_isolated_cpus);
 
 	init_sched_rt_class();
+	init_tg_period_mask(&root_task_group);
 }
 #else
 void __init sched_init_smp(void)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 979f04d..f8f4abf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1368,6 +1368,9 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
 		cfs_rq->tg_load_save =
 			atomic_long_add_return(tg_contrib, &tg->load_avg);
 		cfs_rq->tg_load_contrib += tg_contrib;
+#ifdef CONFIG_FGS_SPARSE_AVG
+		cfs_rq->tg_load_jiffies = jiffies;
+#endif
 	}
 }
 
@@ -1390,6 +1393,9 @@ static inline void __update_tg_runnable_avg(struct sched_avg *sa,
 		cfs_rq->tg_runnable_save =
 			atomic_add_return(contrib, &tg->runnable_avg);
 		cfs_rq->tg_runnable_contrib += contrib;
+#ifdef CONFIG_FGS_SPARSE_AVG
+		cfs_rq->tg_runnable_jiffies = jiffies;
+#endif
 	}
 }
 
@@ -1407,9 +1413,25 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 	 * Retrieve & clear the saved tg's load_avg and use it if not 0
 	 */
 	load_avg = cfs_rq->tg_load_save;
+#ifdef CONFIG_FGS_SPARSE_AVG
+	/*
+	 * Reload the saved load_avg value if it expires
+	 */
+	if (likely(load_avg)) {
+		unsigned long now = jiffies;
+
+		if (now - cfs_rq->tg_load_jiffies > tg->period_mask) {
+			load_avg = cfs_rq->tg_load_save
+				 = atomic_long_read(&tg->load_avg);
+			cfs_rq->tg_load_jiffies = now;
+		}
+	} else
+		load_avg = atomic_long_read(&tg->load_avg);
+#else
 	cfs_rq->tg_load_save = 0;
 	if (unlikely(!load_avg))
 		load_avg = atomic_long_read(&tg->load_avg);
+#endif
 	se->avg.load_avg_contrib = div_u64(contrib, load_avg + 1);
 
 	/*
@@ -1436,9 +1458,25 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 	 * our upper bound of 1-cpu.
 	 */
 	runnable_avg = cfs_rq->tg_runnable_save;
+#ifdef CONFIG_FGS_SPARSE_AVG
+	/*
+	 * Reload the saved runnable_avg value if it expires
+	 */
+	if (likely(runnable_avg)) {
+		unsigned long now = jiffies;
+
+		if (now - cfs_rq->tg_runnable_jiffies > tg->period_mask) {
+			runnable_avg = cfs_rq->tg_runnable_save
+				     = atomic_read(&tg->runnable_avg);
+			cfs_rq->tg_runnable_jiffies = now;
+		}
+	} else
+		runnable_avg = atomic_read(&tg->runnable_avg);
+#else
 	cfs_rq->tg_runnable_save = 0;
 	if (unlikely(!runnable_avg))
 		runnable_avg = atomic_read(&tg->runnable_avg);
+#endif
 	if (runnable_avg < NICE_0_LOAD) {
 		se->avg.load_avg_contrib *= runnable_avg;
 		se->avg.load_avg_contrib >>= NICE_0_SHIFT;
@@ -2037,6 +2075,20 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 static void
 entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 {
+	int force_update = 1;
+
+#ifdef CONFIG_FGS_SPARSE_AVG
+	/*
+	 * Force the update of load_avg only if it is its turn or the
+	 * previous update was more than one period away.
+	 */
+	unsigned long now = jiffies;
+	int period_mask = cfs_rq->tg->period_mask;
+
+	if (((now & period_mask) != numa_node_id()) &&
+	    (now - cfs_rq->tg_load_jiffies <= period_mask + 1))
+		force_update = 0;
+#endif
 	/*
 	 * Update run-time statistics of the 'current'.
 	 */
@@ -2045,7 +2097,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	/*
 	 * Ensure that runnable average is periodically updated.
 	 */
-	update_cfs_rq_blocked_load(cfs_rq, 1);
+	update_cfs_rq_blocked_load(cfs_rq, force_update);
 	update_cfs_shares(cfs_rq);
 	update_entity_load_avg(curr, 1);
 
@@ -6052,6 +6104,7 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 	tg->shares = NICE_0_LOAD;
 
 	init_cfs_bandwidth(tg_cfs_bandwidth(tg));
+	init_tg_period_mask(tg);
 
 	for_each_possible_cpu(i) {
 		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 255e340..76cbe26 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -147,6 +147,10 @@ struct task_group {
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
+#ifdef	CONFIG_FGS_SPARSE_AVG
+	/* Mask for spreading average computation */
+	unsigned period_mask;
+#endif
 
 #ifdef	CONFIG_SMP
 	atomic_long_t load_avg ____cacheline_aligned;
@@ -287,6 +291,12 @@ struct cfs_rq {
 	int tg_runnable_save;
 	unsigned long tg_load_contrib;
 	long tg_load_save;
+#ifdef CONFIG_FGS_SPARSE_AVG
+	/* Time of last load_avg update */
+	unsigned long tg_load_jiffies;
+	/* Time of last runnable_avg update */
+	unsigned long tg_runnable_jiffies;
+#endif
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 	/*
@@ -1105,6 +1115,19 @@ static inline u64 sched_avg_period(void)
 	return (u64)sysctl_sched_time_avg * NSEC_PER_MSEC / 2;
 }
 
+#ifdef CONFIG_FGS_SPARSE_AVG
+static inline void init_tg_period_mask(struct task_group *tg)
+{
+	/*
+	 * Convert number of nodes into bitmask that cover all the nodes
+	 * e.g. 8 => 0b1111, 7 =>0b1111, 4 => 0b111
+	 */
+	tg->period_mask = (1 << fls(num_possible_nodes() - 1)) - 1;
+}
+#else
+static inline void init_tg_period_mask(struct task_group *tg) {}
+#endif	/* CONFIG_FGS_SPARSE_AVG */
+
 #ifdef CONFIG_SCHED_HRTICK
 
 /*
-- 
1.7.1

