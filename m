Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaGKHuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:50:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:36840 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbaGKHfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:35:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="571589314"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC Patch V1 02/30] mm, sched: Use cpu_to_mem()/numa_mem_id() to support memoryless node
Date: Fri, 11 Jul 2014 15:37:19 +0800
Message-Id: <1405064267-11678-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_HAVE_MEMORYLESS_NODES is enabled, cpu_to_node()/numa_node_id()
may return a node without memory, and later cause system failure/panic
when calling kmalloc_node() and friends with returned node id.
So use cpu_to_mem()/numa_mem_id() instead to get the nearest node with
memory for the/current cpu.

If CONFIG_HAVE_MEMORYLESS_NODES is disabled, cpu_to_mem()/numa_mem_id()
is the same as cpu_to_node()/numa_node_id().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 kernel/sched/core.c     |    8 ++++----
 kernel/sched/deadline.c |    2 +-
 kernel/sched/fair.c     |    4 ++--
 kernel/sched/rt.c       |    6 +++---
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3bdf01b494fe..27e3af246310 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5743,7 +5743,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 			continue;
 
 		sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
-				GFP_KERNEL, cpu_to_node(cpu));
+				GFP_KERNEL, cpu_to_mem(cpu));
 
 		if (!sg)
 			goto fail;
@@ -6397,14 +6397,14 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 			struct sched_group_capacity *sgc;
 
 		       	sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
-					GFP_KERNEL, cpu_to_node(j));
+					GFP_KERNEL, cpu_to_mem(j));
 			if (!sd)
 				return -ENOMEM;
 
 			*per_cpu_ptr(sdd->sd, j) = sd;
 
 			sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
-					GFP_KERNEL, cpu_to_node(j));
+					GFP_KERNEL, cpu_to_mem(j));
 			if (!sg)
 				return -ENOMEM;
 
@@ -6413,7 +6413,7 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 			*per_cpu_ptr(sdd->sg, j) = sg;
 
 			sgc = kzalloc_node(sizeof(struct sched_group_capacity) + cpumask_size(),
-					GFP_KERNEL, cpu_to_node(j));
+					GFP_KERNEL, cpu_to_mem(j));
 			if (!sgc)
 				return -ENOMEM;
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fc4f98b1258f..95104d363a8c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1559,7 +1559,7 @@ void init_sched_dl_class(void)
 
 	for_each_possible_cpu(i)
 		zalloc_cpumask_var_node(&per_cpu(local_cpu_mask_dl, i),
-					GFP_KERNEL, cpu_to_node(i));
+					GFP_KERNEL, cpu_to_mem(i));
 }
 
 #endif /* CONFIG_SMP */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fea7d3335e1f..26e75b8a52e6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7611,12 +7611,12 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 
 	for_each_possible_cpu(i) {
 		cfs_rq = kzalloc_node(sizeof(struct cfs_rq),
-				      GFP_KERNEL, cpu_to_node(i));
+				      GFP_KERNEL, cpu_to_mem(i));
 		if (!cfs_rq)
 			goto err;
 
 		se = kzalloc_node(sizeof(struct sched_entity),
-				  GFP_KERNEL, cpu_to_node(i));
+				  GFP_KERNEL, cpu_to_mem(i));
 		if (!se)
 			goto err_free_rq;
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a49083192c64..88d1315c6223 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -184,12 +184,12 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 
 	for_each_possible_cpu(i) {
 		rt_rq = kzalloc_node(sizeof(struct rt_rq),
-				     GFP_KERNEL, cpu_to_node(i));
+				     GFP_KERNEL, cpu_to_mem(i));
 		if (!rt_rq)
 			goto err;
 
 		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
-				     GFP_KERNEL, cpu_to_node(i));
+				     GFP_KERNEL, cpu_to_mem(i));
 		if (!rt_se)
 			goto err_free_rq;
 
@@ -1945,7 +1945,7 @@ void __init init_sched_rt_class(void)
 
 	for_each_possible_cpu(i) {
 		zalloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
-					GFP_KERNEL, cpu_to_node(i));
+					GFP_KERNEL, cpu_to_mem(i));
 	}
 }
 #endif /* CONFIG_SMP */
-- 
1.7.10.4

