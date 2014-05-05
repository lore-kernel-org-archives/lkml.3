Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaEEII5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:08:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:46110 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbaEEIIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:08:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,986,1389772800"; 
   d="scan'208";a="526078613"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        yuyang.du@intel.com
Subject: [RFC PATCH 06/12 v1] Attach CPU topology
Date: Mon,  5 May 2014 08:02:46 +0800
Message-Id: <1399248172-13871-7-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
References: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 include/linux/sched.h    |   13 +++++++++++++
 include/linux/topology.h |   16 ++++++++++++++++
 kernel/sched/core.c      |   41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c7..29827ce 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -877,6 +877,12 @@ enum cpu_idle_type {
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 #define SD_NUMA			0x4000	/* cross-node balancing */
 
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+#define SD_ASYM_CONCURRENCY	0x8000	/* Higher concurrency in front to save power */
+#else
+#define SD_ASYM_CONCURRENCY	0
+#endif
+
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
 struct sched_domain_attr {
@@ -960,6 +966,13 @@ struct sched_domain {
 		struct rcu_head rcu;	/* used during destruction */
 	};
 
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	unsigned int total_groups;
+	unsigned int group_number;
+	unsigned int asym_concurrency;
+	struct sched_group *first_group;	/* ordered by CPU number */
+#endif
+
 	unsigned int span_weight;
 	/*
 	 * Span of all CPUs in this domain.
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 7062330..e57f4d6 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -66,6 +66,16 @@ int arch_update_cpu_topology(void);
 #define PENALTY_FOR_NODE_WITH_CPUS	(1)
 #endif
 
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+#ifndef ASYM_CONCURRENCY_INIT
+#define ASYM_CONCURRENCY_INIT(n) .asym_concurrency = (n),
+#endif
+#else
+#ifndef ASYM_CONCURRENCY_INIT
+#define ASYM_CONCURRENCY_INIT(n)
+#endif
+#endif
+
 /*
  * Below are the 3 major initializers used in building sched_domains:
  * SD_SIBLING_INIT, for SMT domains
@@ -102,12 +112,14 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
 				| arch_sd_sibling_asym_packing()	\
+				| 0*SD_ASYM_CONCURRENCY			\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
 	.smt_gain		= 1178,	/* 15% */			\
 	.max_newidle_lb_cost	= 0,					\
 	.next_decay_max_lb_cost	= jiffies,				\
+	ASYM_CONCURRENCY_INIT(0)					\
 }
 #endif
 #endif /* CONFIG_SCHED_SMT */
@@ -134,11 +146,13 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
+				| 1*SD_ASYM_CONCURRENCY			\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
 	.max_newidle_lb_cost	= 0,					\
 	.next_decay_max_lb_cost	= jiffies,				\
+	ASYM_CONCURRENCY_INIT(180)					\
 }
 #endif
 #endif /* CONFIG_SCHED_MC */
@@ -167,11 +181,13 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 1*SD_PREFER_SIBLING			\
+				| 1*SD_ASYM_CONCURRENCY			\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
 	.max_newidle_lb_cost	= 0,					\
 	.next_decay_max_lb_cost	= jiffies,				\
+	ASYM_CONCURRENCY_INIT(180)					\
 }
 #endif
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index aee8660..671f953 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4843,7 +4843,11 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	struct ctl_table *table = sd_alloc_ctl_entry(15);
+#else
 	struct ctl_table *table = sd_alloc_ctl_entry(14);
+#endif
 
 	if (table == NULL)
 		return NULL;
@@ -4876,7 +4880,13 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[12], "name", sd->name,
 		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	set_table_entry(&table[13], "asym_concurrency", &sd->asym_concurrency,
+		sizeof(int), 0644, proc_dointvec, false);
+	/* &table[14] is terminator */
+#else
 	/* &table[13] is terminator */
+#endif
 
 	return table;
 }
@@ -5497,6 +5507,33 @@ static void update_top_cache_domain(int cpu)
 	rcu_assign_pointer(per_cpu(sd_asym, cpu), sd);
 }
 
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+static void update_domain_extra_info(struct sched_domain *sd)
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
+}
+#endif
+
 /*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
@@ -5545,6 +5582,10 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	destroy_sched_domains(tmp, cpu);
 
 	update_top_cache_domain(cpu);
+
+#ifdef CONFIG_WORKLOAD_CONSOLIDATION
+	update_domain_extra_info(sd);
+#endif
 }
 
 /* cpus with isolated domains */
-- 
1.7.9.5

