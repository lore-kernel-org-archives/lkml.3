Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaFYIoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:44:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:15864 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbaFYIk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:40:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="449717455"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        Yuyang Du <yuyang.du@intel.com>
Subject: [RFC PATCH 4/9 v4] Define SD_WORKLOAD_CONSOLIDATION and attach to sched_domain
Date: Wed, 25 Jun 2014 08:36:03 +0800
Message-Id: <1403656568-32445-5-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403656568-32445-1-git-send-email-yuyang.du@intel.com>
References: <1403656568-32445-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workload Consolidation is completely CPU topology and policy driven. To do so,
we define SD_WORKLOAD_CONSOLIDATION, and add some fields in sched_domain struct:

1) total_groups is the group number in total in this domain
2) group_number is this CPU's group sequence number
3) consolidating_coeff is the coefficient for consolidating CPUs, and is changeable
   via sysctl tool to make consolidation more aggressive or less
4) first_group is the pointer to this domain's first group ordered by CPU number

This patchset enables SD_WORKLOAD_CONSOLIDATION in MC domain by default. But we need
to come up with a better way to determine on which architecture this flag should be
enabled or not. Thanks to PeterZ and Dietmar for pointing this out and help me
finally understand it.

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 include/linux/sched.h |    8 +++++++-
 kernel/sched/core.c   |   46 ++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched/sched.h  |   13 ++++++++++---
 3 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1b1997d..a339467 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -870,6 +870,7 @@ enum cpu_idle_type {
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 #define SD_NUMA			0x4000	/* cross-node balancing */
+#define SD_WORKLOAD_CONSOLIDATION  0x8000  /* consolidate CPU workload */
 
 #ifdef CONFIG_SCHED_SMT
 static inline const int cpu_smt_flags(void)
@@ -881,7 +882,7 @@ static inline const int cpu_smt_flags(void)
 #ifdef CONFIG_SCHED_MC
 static inline const int cpu_core_flags(void)
 {
-	return SD_SHARE_PKG_RESOURCES;
+	return SD_SHARE_PKG_RESOURCES | SD_WORKLOAD_CONSOLIDATION;
 }
 #endif
 
@@ -973,6 +974,11 @@ struct sched_domain {
 		struct rcu_head rcu;	/* used during destruction */
 	};
 
+	unsigned int total_groups;			/* total group number */
+	unsigned int group_number;			/* this CPU's group sequence */
+	unsigned int consolidating_coeff;	/* consolidating coefficient */
+	struct sched_group *first_group;	/* ordered by CPU number */
+
 	unsigned int span_weight;
 	/*
 	 * Span of all CPUs in this domain.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3bdf01b..da3cd74 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4941,7 +4941,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(14);
+	struct ctl_table *table = sd_alloc_ctl_entry(15);
 
 	if (table == NULL)
 		return NULL;
@@ -4974,7 +4974,9 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[12], "name", sd->name,
 		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
-	/* &table[13] is terminator */
+	set_table_entry(&table[13], "consolidating_coeff", &sd->consolidating_coeff,
+		sizeof(int), 0644, proc_dointvec, false);
+	/* &table[14] is terminator */
 
 	return table;
 }
@@ -5586,7 +5588,7 @@ static void update_top_cache_domain(int cpu)
 	int id = cpu;
 	int size = 1;
 
-	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
+	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES, 1);
 	if (sd) {
 		id = cpumask_first(sched_domain_span(sd));
 		size = cpumask_weight(sched_domain_span(sd));
@@ -5601,10 +5603,41 @@ static void update_top_cache_domain(int cpu)
 	sd = lowest_flag_domain(cpu, SD_NUMA);
 	rcu_assign_pointer(per_cpu(sd_numa, cpu), sd);
 
-	sd = highest_flag_domain(cpu, SD_ASYM_PACKING);
+	sd = highest_flag_domain(cpu, SD_ASYM_PACKING, 1);
 	rcu_assign_pointer(per_cpu(sd_asym, cpu), sd);
 }
 
+
+DEFINE_PER_CPU(struct sched_domain *, sd_wc);
+
+static void update_wc_domain(struct sched_domain *sd, int cpu)
+{
+	while (sd) {
+		int i = 0, j = 0, first, min = INT_MAX;
+		struct sched_group *group;
+
+		group = sd->groups;
+		first = group_first_cpu(group);
+		do {
+			int k = group_first_cpu(group);
+			i += 1;
+			if (k < first)
+				j += 1;
+			if (k < min) {
+				sd->first_group = group;
+				min = k;
+			}
+		} while (group = group->next, group != sd->groups);
+
+		sd->total_groups = i;
+		sd->group_number = j;
+		sd = sd->parent;
+	}
+
+	sd = highest_flag_domain(cpu, SD_WORKLOAD_CONSOLIDATION, 0);
+	rcu_assign_pointer(per_cpu(sd_wc, cpu), sd);
+}
+
 /*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
@@ -5653,6 +5686,8 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	destroy_sched_domains(tmp, cpu);
 
 	update_top_cache_domain(cpu);
+
+	update_wc_domain(sd, cpu);
 }
 
 /* cpus with isolated domains */
@@ -6069,6 +6104,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 #ifdef CONFIG_SCHED_DEBUG
 		.name			= tl->name,
 #endif
+		.consolidating_coeff = 0,
 	};
 
 	/*
@@ -6098,6 +6134,8 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
 		}
 
 #endif
+	} else if (sd->flags & SD_WORKLOAD_CONSOLIDATION) {
+		sd->consolidating_coeff = 160;
 	} else {
 		sd->flags |= SD_PREFER_SIBLING;
 		sd->cache_nice_tries = 1;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index eb47ce2..a2a7230 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -695,16 +695,22 @@ extern void sched_ttwu_pending(void);
  *		be returned.
  * @flag:	The flag to check for the highest sched_domain
  *		for the given cpu.
+ * @all: The flag is contained by all sched_domains from the hightest down
  *
  * Returns the highest sched_domain of a cpu which contains the given flag.
  */
-static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
+static inline struct
+sched_domain *highest_flag_domain(int cpu, int flag, int all)
 {
 	struct sched_domain *sd, *hsd = NULL;
 
 	for_each_domain(cpu, sd) {
-		if (!(sd->flags & flag))
-			break;
+		if (!(sd->flags & flag)) {
+			if (all)
+				break;
+			else
+				continue;
+		}
 		hsd = sd;
 	}
 
@@ -729,6 +735,7 @@ DECLARE_PER_CPU(int, sd_llc_id);
 DECLARE_PER_CPU(struct sched_domain *, sd_numa);
 DECLARE_PER_CPU(struct sched_domain *, sd_busy);
 DECLARE_PER_CPU(struct sched_domain *, sd_asym);
+DECLARE_PER_CPU(struct sched_domain *, sd_wc);
 
 struct sched_group_capacity {
 	atomic_t ref;
-- 
1.7.9.5

