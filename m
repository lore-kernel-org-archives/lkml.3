Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837AbaE3OlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:41:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:29684 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933513AbaE3OlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:41:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="548946950"
From: Yuyang Du <yuyang.du@intel.com>
To: mingo@redhat.com, peterz@infradead.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, bsegall@google.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com, jacob.jun.pan@linux.intel.com,
        fengguang.wu@intel.com, yuyang.du@intel.com
Subject: [RFC PATCH 06/16 v3] Add Workload Consolidation fields in struct sched_domain
Date: Fri, 30 May 2014 14:36:02 +0800
Message-Id: <1401431772-14320-7-git-send-email-yuyang.du@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
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

Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 include/linux/sched.h |    6 ++++++
 kernel/sched/core.c   |    6 ++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c7..c6aac65 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -876,6 +876,7 @@ enum cpu_idle_type {
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 #define SD_OVERLAP		0x2000	/* sched_domains of this level overlap */
 #define SD_NUMA			0x4000	/* cross-node balancing */
+#define SD_WORKLOAD_CONSOLIDATION	0x8000	/* consolidate CPU workload */
 
 extern int __weak arch_sd_sibiling_asym_packing(void);
 
@@ -960,6 +961,11 @@ struct sched_domain {
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
index 69623f1..1cb7402 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4840,7 +4840,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(14);
+	struct ctl_table *table = sd_alloc_ctl_entry(15);
 
 	if (table == NULL)
 		return NULL;
@@ -4873,7 +4873,9 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[12], "name", sd->name,
 		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
-	/* &table[13] is terminator */
+	set_table_entry(&table[13], "consolidating_coeff", &sd->consolidating_coeff,
+		sizeof(int), 0644, proc_dointvec, false);
+	/* &table[14] is terminator */
 
 	return table;
 }
-- 
1.7.9.5

