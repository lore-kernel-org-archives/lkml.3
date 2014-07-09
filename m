Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaGIIsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:48:01 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:21538 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaGIIr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:47:57 -0400
Message-ID: <53BD01B6.403@huawei.com>
Date: Wed, 9 Jul 2014 16:47:50 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v3 05/12] cpuset: use effective cpumask to build sched domains
References: <53BD0174.4060002@huawei.com>
In-Reply-To: <53BD0174.4060002@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're going to have separate user-configured masks and effective ones.

Eventually configured masks can only be changed by writing cpuset.cpus
and cpuset.mems, and they won't be restricted by parent cpuset. While
effective masks reflect cpu/memory hotplug and hierachical restriction,
and these are the real masks that apply to the tasks in the cpuset.

We calculate effective mask this way:
  - top cpuset's effective_mask == online_mask, otherwise
  - cpuset's effective_mask == configured_mask & parent effective_mask,
    if the result is empty, it inherits parent effective mask.

Those behavior changes are for default hierarchy only. For legacy
hierarchy, effective_mask and configured_mask are the same, so we won't
break old interfaces.

We should partition sched domains according to effective_cpus, which
is the real cpulist that takes effects on tasks in the cpuset.

This won't introduce behavior change.

v2:
- Add a comment for the call of rebuild_sched_domains(), suggested
by Tejun.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f834002..60577cc 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -494,11 +494,11 @@ out:
 #ifdef CONFIG_SMP
 /*
  * Helper routine for generate_sched_domains().
- * Do cpusets a, b have overlapping cpus_allowed masks?
+ * Do cpusets a, b have overlapping effective cpus_allowed masks?
  */
 static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
 {
-	return cpumask_intersects(a->cpus_allowed, b->cpus_allowed);
+	return cpumask_intersects(a->effective_cpus, b->effective_cpus);
 }
 
 static void
@@ -615,7 +615,7 @@ static int generate_sched_domains(cpumask_var_t **domains,
 			*dattr = SD_ATTR_INIT;
 			update_domain_attr_tree(dattr, &top_cpuset);
 		}
-		cpumask_copy(doms[0], top_cpuset.cpus_allowed);
+		cpumask_copy(doms[0], top_cpuset.effective_cpus);
 
 		goto done;
 	}
@@ -719,7 +719,7 @@ restart:
 			struct cpuset *b = csa[j];
 
 			if (apn == b->pn) {
-				cpumask_or(dp, dp, b->cpus_allowed);
+				cpumask_or(dp, dp, b->effective_cpus);
 				if (dattr)
 					update_domain_attr_tree(dattr + nslot, b);
 
@@ -771,7 +771,7 @@ static void rebuild_sched_domains_locked(void)
 	 * passing doms with offlined cpu to partition_sched_domains().
 	 * Anyways, hotplug work item will rebuild sched domains.
 	 */
-	if (!cpumask_equal(top_cpuset.cpus_allowed, cpu_active_mask))
+	if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
 		goto out;
 
 	/* Generate domain masks and attrs */
@@ -870,6 +870,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 {
 	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
+	bool need_rebuild_sched_domains = false;
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
@@ -903,10 +904,21 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 
 		update_tasks_cpumask(cp);
 
+		/*
+		 * If the effective cpumask of any non-empty cpuset is changed,
+		 * we need to rebuild sched domains.
+		 */
+		if (!cpumask_empty(cp->cpus_allowed) &&
+		    is_sched_load_balance(cp))
+			need_rebuild_sched_domains = true;
+
 		rcu_read_lock();
 		css_put(&cp->css);
 	}
 	rcu_read_unlock();
+
+	if (need_rebuild_sched_domains)
+		rebuild_sched_domains_locked();
 }
 
 /**
@@ -919,7 +931,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 			  const char *buf)
 {
 	int retval;
-	int is_load_balanced;
 
 	/* top_cpuset.cpus_allowed tracks cpu_online_mask; it's read-only */
 	if (cs == &top_cpuset)
@@ -950,17 +961,12 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		return retval;
 
-	is_load_balanced = is_sched_load_balance(trialcs);
-
 	mutex_lock(&callback_mutex);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
 	/* use trialcs->cpus_allowed as a temp variable */
 	update_cpumasks_hier(cs, trialcs->cpus_allowed);
-
-	if (is_load_balanced)
-		rebuild_sched_domains_locked();
 	return 0;
 }
 
-- 
1.8.0.2

