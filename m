Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab3CSLNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:13:16 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44745 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3CSLNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:13:14 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, efault@gmx.de
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v5] sched: fix init NOHZ_IDLE flag
Date: Tue, 19 Mar 2013 12:12:12 +0100
Message-Id: <1363691532-4626-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my smp platform which is made of 5 cores in 2 clusters, I have the
nr_busy_cpu field of sched_group_power struct that is not null when the
platform is fully idle. The root cause is:
During the boot sequence, some CPUs reach the idle loop and set their
NOHZ_IDLE flag while waiting for others CPUs to boot. But the nr_busy_cpus
field is initialized later with the assumption that all CPUs are in the busy
state whereas some CPUs have already set their NOHZ_IDLE flag.

More generally, the NOHZ_IDLE flag must be initialized when new sched_domains
are created in order to ensure that NOHZ_IDLE and nr_busy_cpus are aligned.

This condition can be ensured by adding a synchronize_rcu between the
destruction of old sched_domains and the creation of new ones so the NOHZ_IDLE
flag will not be updated with old sched_domain once it has been initialized.
But this solution introduces a additionnal latency in the rebuild sequence
that is called during cpu hotplug.

As suggested by Frederic Weisbecker, another solution is to have the same
rcu lifecycle for both NOHZ_IDLE and sched_domain struct. I have introduce
a new sched_domain_rq struct that is the entry point for both sched_domains
and objects that must follow the same lifecycle like NOHZ_IDLE flags. They
will share the same RCU lifecycle and will be always synchronized.

The synchronization is done at the cost of :
 - an additional indirection for accessing the first sched_domain level
 - an additional indirection and a rcu_dereference before accessing to the
   NOHZ_IDLE flag.

Change since v4:
 - link both sched_domain and NOHZ_IDLE flag in one RCU object so
   their states are always synchronized.

Change since V3;
 - NOHZ flag is not cleared if a NULL domain is attached to the CPU
 - Remove patch 2/2 which becomes useless with latest modifications

Change since V2:
 - change the initialization to idle state instead of busy state so a CPU that
   enters idle during the build of the sched_domain will not corrupt the
   initialization state

Change since V1:
 - remove the patch for SCHED softirq on an idle core use case as it was
   a side effect of the other use cases.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched.h |    6 +++
 kernel/sched/core.c   |  105 ++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched/fair.c   |   35 +++++++++++------
 kernel/sched/sched.h  |   24 +++++++++--
 4 files changed, 145 insertions(+), 25 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..2a52188 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -959,6 +959,12 @@ struct sched_domain {
 	unsigned long span[0];
 };
 
+struct sched_domain_rq {
+	struct sched_domain *sd;
+	unsigned long flags;
+	struct rcu_head rcu;	/* used during destruction */
+};
+
 static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
 {
 	return to_cpumask(sd->span);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..69e2313 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5602,6 +5602,15 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
 		destroy_sched_domain(sd, cpu);
 }
 
+static void destroy_sched_domain_rq(struct sched_domain_rq *sd_rq, int cpu)
+{
+	if (!sd_rq)
+		return;
+
+	destroy_sched_domains(sd_rq->sd, cpu);
+	kfree_rcu(sd_rq, rcu);
+}
+
 /*
  * Keep a special pointer to the highest sched_domain that has
  * SD_SHARE_PKG_RESOURCE set (Last Level Cache Domain) for this
@@ -5632,10 +5641,23 @@ static void update_top_cache_domain(int cpu)
  * hold the hotplug lock.
  */
 static void
-cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
+cpu_attach_domain(struct sched_domain_rq *sd_rq, struct root_domain *rd,
+		int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	struct sched_domain *tmp;
+	struct sched_domain_rq *tmp_rq;
+	struct sched_domain *tmp, *sd = NULL;
+
+	/*
+	 * If we don't have any sched_domain and associated object, we can
+	 * directly jump to the attach sequence otherwise we try to degenerate
+	 * the sched_domain
+	 */
+	if (!sd_rq)
+		goto attach;
+
+	/* Get a pointer to the 1st sched_domain */
+	sd = sd_rq->sd;
 
 	/* Remove the sched domains which do not contribute to scheduling. */
 	for (tmp = sd; tmp; ) {
@@ -5658,14 +5680,17 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 		destroy_sched_domain(tmp, cpu);
 		if (sd)
 			sd->child = NULL;
+		/* update sched_domain_rq */
+		sd_rq->sd = sd;
 	}
 
+attach:
 	sched_domain_debug(sd, cpu);
 
 	rq_attach_root(rq, rd);
-	tmp = rq->sd;
-	rcu_assign_pointer(rq->sd, sd);
-	destroy_sched_domains(tmp, cpu);
+	tmp_rq = rq->sd_rq;
+	rcu_assign_pointer(rq->sd_rq, sd_rq);
+	destroy_sched_domain_rq(tmp_rq, cpu);
 
 	update_top_cache_domain(cpu);
 }
@@ -5695,12 +5720,14 @@ struct sd_data {
 };
 
 struct s_data {
+	struct sched_domain_rq ** __percpu sd_rq;
 	struct sched_domain ** __percpu sd;
 	struct root_domain	*rd;
 };
 
 enum s_alloc {
 	sa_rootdomain,
+	sa_sd_rq,
 	sa_sd,
 	sa_sd_storage,
 	sa_none,
@@ -5935,7 +5962,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 		return;
 
 	update_group_power(sd, cpu);
-	atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
+	atomic_set(&sg->sgp->nr_busy_cpus, 0);
 }
 
 int __weak arch_sd_sibling_asym_packing(void)
@@ -6011,6 +6038,8 @@ static void set_domain_attribute(struct sched_domain *sd,
 
 static void __sdt_free(const struct cpumask *cpu_map);
 static int __sdt_alloc(const struct cpumask *cpu_map);
+static void __sdrq_free(const struct cpumask *cpu_map, struct s_data *d);
+static int __sdrq_alloc(const struct cpumask *cpu_map, struct s_data *d);
 
 static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 				 const struct cpumask *cpu_map)
@@ -6019,6 +6048,9 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 	case sa_rootdomain:
 		if (!atomic_read(&d->rd->refcount))
 			free_rootdomain(&d->rd->rcu); /* fall through */
+	case sa_sd_rq:
+		__sdrq_free(cpu_map, d); /* fall through */
+		free_percpu(d->sd_rq); /* fall through */
 	case sa_sd:
 		free_percpu(d->sd); /* fall through */
 	case sa_sd_storage:
@@ -6038,9 +6070,14 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 	d->sd = alloc_percpu(struct sched_domain *);
 	if (!d->sd)
 		return sa_sd_storage;
+	d->sd_rq = alloc_percpu(struct sched_domain_rq *);
+	if (!d->sd_rq)
+		return sa_sd;
+	if (__sdrq_alloc(cpu_map, d))
+		return sa_sd_rq;
 	d->rd = alloc_rootdomain();
 	if (!d->rd)
-		return sa_sd;
+		return sa_sd_rq;
 	return sa_rootdomain;
 }
 
@@ -6466,6 +6503,46 @@ static void __sdt_free(const struct cpumask *cpu_map)
 	}
 }
 
+static int __sdrq_alloc(const struct cpumask *cpu_map, struct s_data *d)
+{
+	int j;
+
+	for_each_cpu(j, cpu_map) {
+		struct sched_domain_rq *sd_rq;
+
+		sd_rq = kzalloc_node(sizeof(struct sched_domain_rq),
+				GFP_KERNEL, cpu_to_node(j));
+		if (!sd_rq)
+			return -ENOMEM;
+
+		*per_cpu_ptr(d->sd_rq, j) = sd_rq;
+	}
+
+	return 0;
+}
+
+static void __sdrq_free(const struct cpumask *cpu_map, struct s_data *d)
+{
+	int j;
+
+	for_each_cpu(j, cpu_map)
+		if (*per_cpu_ptr(d->sd_rq, j))
+			kfree(*per_cpu_ptr(d->sd_rq, j));
+}
+
+static void build_sched_domain_rq(struct s_data *d, int cpu)
+{
+	struct sched_domain_rq *sd_rq;
+	struct sched_domain *sd;
+
+	/* Attach sched_domain to sched_domain_rq */
+	sd = *per_cpu_ptr(d->sd, cpu);
+	sd_rq = *per_cpu_ptr(d->sd_rq, cpu);
+	sd_rq->sd = sd;
+	/* Init flags */
+	set_bit(NOHZ_IDLE, sched_rq_flags(sd_rq));
+}
+
 struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		struct s_data *d, const struct cpumask *cpu_map,
 		struct sched_domain_attr *attr, struct sched_domain *child,
@@ -6495,6 +6572,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 			       struct sched_domain_attr *attr)
 {
 	enum s_alloc alloc_state = sa_none;
+	struct sched_domain_rq *sd_rq;
 	struct sched_domain *sd;
 	struct s_data d;
 	int i, ret = -ENOMEM;
@@ -6547,11 +6625,18 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 		}
 	}
 
+	/* Init objects that must follow the sched_domain lifecycle */
+	for_each_cpu(i, cpu_map) {
+		build_sched_domain_rq(&d, i);
+	}
+
 	/* Attach the domains */
 	rcu_read_lock();
 	for_each_cpu(i, cpu_map) {
-		sd = *per_cpu_ptr(d.sd, i);
-		cpu_attach_domain(sd, d.rd, i);
+		sd_rq = *per_cpu_ptr(d.sd_rq, i);
+		cpu_attach_domain(sd_rq, d.rd, i);
+		/* claim allocation of sched_domain_rq object */
+		*per_cpu_ptr(d.sd_rq, i) = NULL;
 	}
 	rcu_read_unlock();
 
@@ -6982,7 +7067,7 @@ void __init sched_init(void)
 		rq->last_load_update_tick = jiffies;
 
 #ifdef CONFIG_SMP
-		rq->sd = NULL;
+		rq->sd_rq = NULL;
 		rq->rd = NULL;
 		rq->cpu_power = SCHED_POWER_SCALE;
 		rq->post_schedule = 0;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..1c7447e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5392,31 +5392,39 @@ static inline void nohz_balance_exit_idle(int cpu)
 
 static inline void set_cpu_sd_state_busy(void)
 {
+	struct sched_domain_rq *sd_rq;
 	struct sched_domain *sd;
 	int cpu = smp_processor_id();
 
-	if (!test_bit(NOHZ_IDLE, nohz_flags(cpu)))
-		return;
-	clear_bit(NOHZ_IDLE, nohz_flags(cpu));
-
 	rcu_read_lock();
-	for_each_domain(cpu, sd)
+	sd_rq = get_sched_domain_rq(cpu);
+
+	if (!sd_rq || !test_bit(NOHZ_IDLE, sched_rq_flags(sd_rq)))
+		goto unlock;
+	clear_bit(NOHZ_IDLE, sched_rq_flags(sd_rq));
+
+	for_each_domain_from_rq(sd_rq, sd)
 		atomic_inc(&sd->groups->sgp->nr_busy_cpus);
+unlock:
 	rcu_read_unlock();
 }
 
 void set_cpu_sd_state_idle(void)
 {
+	struct sched_domain_rq *sd_rq;
 	struct sched_domain *sd;
 	int cpu = smp_processor_id();
 
-	if (test_bit(NOHZ_IDLE, nohz_flags(cpu)))
-		return;
-	set_bit(NOHZ_IDLE, nohz_flags(cpu));
-
 	rcu_read_lock();
-	for_each_domain(cpu, sd)
+	sd_rq = get_sched_domain_rq(cpu);
+
+	if (!sd_rq || test_bit(NOHZ_IDLE, sched_rq_flags(sd_rq)))
+		goto unlock;
+	set_bit(NOHZ_IDLE, sched_rq_flags(sd_rq));
+
+	for_each_domain_from_rq(sd_rq, sd)
 		atomic_dec(&sd->groups->sgp->nr_busy_cpus);
+unlock:
 	rcu_read_unlock();
 }
 
@@ -5673,7 +5681,12 @@ static void run_rebalance_domains(struct softirq_action *h)
 
 static inline int on_null_domain(int cpu)
 {
-	return !rcu_dereference_sched(cpu_rq(cpu)->sd);
+	struct sched_domain_rq *sd_rq =
+		rcu_dereference_sched(cpu_rq(cpu)->sd_rq);
+	struct sched_domain *sd = NULL;
+	if (sd_rq)
+		sd = sd_rq->sd;
+	return !sd;
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index cc03cfd..f589306 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -417,7 +417,7 @@ struct rq {
 
 #ifdef CONFIG_SMP
 	struct root_domain *rd;
-	struct sched_domain *sd;
+	struct sched_domain_rq *sd_rq;
 
 	unsigned long cpu_power;
 
@@ -505,21 +505,37 @@ DECLARE_PER_CPU(struct rq, runqueues);
 
 #ifdef CONFIG_SMP
 
-#define rcu_dereference_check_sched_domain(p) \
+#define rcu_dereference_check_sched_domain_rq(p) \
 	rcu_dereference_check((p), \
 			      lockdep_is_held(&sched_domains_mutex))
 
+#define get_sched_domain_rq(cpu) \
+	rcu_dereference_check_sched_domain_rq(cpu_rq(cpu)->sd_rq)
+
+#define rcu_dereference_check_sched_domain(cpu) ({ \
+	struct sched_domain_rq *__sd_rq = get_sched_domain_rq(cpu); \
+	struct sched_domain *__sd = NULL; \
+	if (__sd_rq) \
+		__sd = __sd_rq->sd; \
+	__sd; \
+})
+
+#define sched_rq_flags(sd_rq) (&sd_rq->flags)
+
 /*
- * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
+ * The domain tree (rq->sd_rq) is protected by RCU's quiescent state transition.
  * See detach_destroy_domains: synchronize_sched for details.
  *
  * The domain tree of any CPU may only be accessed from within
  * preempt-disabled sections.
  */
 #define for_each_domain(cpu, __sd) \
-	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); \
+	for (__sd = rcu_dereference_check_sched_domain(cpu); \
 			__sd; __sd = __sd->parent)
 
+#define for_each_domain_from_rq(sd_rq, __sd) \
+	for (__sd = sd_rq->sd; __sd; __sd = __sd->parent)
+
 #define for_each_lower_domain(sd) for (; sd; sd = sd->child)
 
 /**
-- 
1.7.9.5

