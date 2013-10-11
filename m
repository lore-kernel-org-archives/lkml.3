Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3JKJtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:49:46 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:42894 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3JKJto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:49:44 -0400
Message-ID: <5257C9AC.5090603@huawei.com>
Date: Fri, 11 Oct 2013 17:49:32 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2 01/12] cpuset: add cs->effective_cpus and cs->effective_mems
References: <5257C9A1.1030404@huawei.com>
In-Reply-To: <5257C9A1.1030404@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
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

Those behavior changes are for sane_behavior only. For !sane_behavior
effective_mask and configured_mask are the same, so we won't break old
interfaces.

This patch adds and initializes the effective masks to struct cpuset.
The effective masks of the top cpuset is the same with configured masks,
and a child cpuset inherits its parent's effective masks.

This won't introduce behavior change.

v2:
- s/real_{mems,cpus}_allowed/effective_{mems,cpus}, suggested by Tejun.
- don't init effective masks in cpuset_css_online() if !sane_behavior

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 6bf981e..e13fc2a 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -81,8 +81,14 @@ struct cpuset {
 	struct cgroup_subsys_state css;
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
-	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
-	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
+
+	/* user-configured CPUs and Memory Nodes allow to tasks */
+	cpumask_var_t cpus_allowed;
+	nodemask_t mems_allowed;
+
+	/* effective CPUs and Memory Nodes allow to tasks */
+	cpumask_var_t effective_cpus;
+	nodemask_t effective_mems;
 
 	/*
 	 * This is old Memory Nodes tasks took on.
@@ -381,13 +387,20 @@ static struct cpuset *alloc_trial_cpuset(struct cpuset *cs)
 	if (!trial)
 		return NULL;
 
-	if (!alloc_cpumask_var(&trial->cpus_allowed, GFP_KERNEL)) {
-		kfree(trial);
-		return NULL;
-	}
-	cpumask_copy(trial->cpus_allowed, cs->cpus_allowed);
+	if (!alloc_cpumask_var(&trial->cpus_allowed, GFP_KERNEL))
+		goto free_cs;
+	if (!alloc_cpumask_var(&trial->effective_cpus, GFP_KERNEL))
+		goto free_cpus;
 
+	cpumask_copy(trial->cpus_allowed, cs->cpus_allowed);
+	cpumask_copy(trial->effective_cpus, cs->effective_cpus);
 	return trial;
+
+free_cpus:
+	free_cpumask_var(trial->cpus_allowed);
+free_cs:
+	kfree(trial);
+	return NULL;
 }
 
 /**
@@ -396,6 +409,7 @@ static struct cpuset *alloc_trial_cpuset(struct cpuset *cs)
  */
 static void free_trial_cpuset(struct cpuset *trial)
 {
+	free_cpumask_var(trial->effective_cpus);
 	free_cpumask_var(trial->cpus_allowed);
 	kfree(trial);
 }
@@ -1948,18 +1962,26 @@ cpuset_css_alloc(struct cgroup_subsys_state *parent_css)
 	cs = kzalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
-	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL)) {
-		kfree(cs);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL))
+		goto free_cs;
+	if (!alloc_cpumask_var(&cs->effective_cpus, GFP_KERNEL))
+		goto free_cpus;
 
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	cpumask_clear(cs->cpus_allowed);
 	nodes_clear(cs->mems_allowed);
+	cpumask_clear(cs->effective_cpus);
+	nodes_clear(cs->effective_mems);
 	fmeter_init(&cs->fmeter);
 	cs->relax_domain_level = -1;
 
 	return &cs->css;
+
+free_cpus:
+	free_cpumask_var(cs->cpus_allowed);
+free_cs:
+	kfree(cs);
+	return ERR_PTR(-ENOMEM);
 }
 
 static int cpuset_css_online(struct cgroup_subsys_state *css)
@@ -1982,6 +2004,13 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 
 	number_of_cpusets++;
 
+	mutex_lock(&callback_mutex);
+	if (cgroup_sane_behavior(cs->css.cgroup)) {
+		cpumask_copy(cs->effective_cpus, parent->effective_cpus);
+		cs->effective_mems = parent->effective_mems;
+	}
+	mutex_unlock(&callback_mutex);
+
 	if (!test_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags))
 		goto out_unlock;
 
@@ -2041,6 +2070,7 @@ static void cpuset_css_free(struct cgroup_subsys_state *css)
 {
 	struct cpuset *cs = css_cs(css);
 
+	free_cpumask_var(cs->effective_cpus);
 	free_cpumask_var(cs->cpus_allowed);
 	kfree(cs);
 }
@@ -2071,9 +2101,13 @@ int __init cpuset_init(void)
 
 	if (!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL))
 		BUG();
+	if (!alloc_cpumask_var(&top_cpuset.effective_cpus, GFP_KERNEL))
+		BUG();
 
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
+	cpumask_setall(top_cpuset.effective_cpus);
+	nodes_setall(top_cpuset.effective_mems);
 
 	fmeter_init(&top_cpuset.fmeter);
 	set_bit(CS_SCHED_LOAD_BALANCE, &top_cpuset.flags);
@@ -2311,6 +2345,9 @@ void __init cpuset_init_smp(void)
 	top_cpuset.mems_allowed = node_states[N_MEMORY];
 	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
 
+	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
+	top_cpuset.effective_mems = node_states[N_MEMORY];
+
 	register_hotmemory_notifier(&cpuset_track_online_nodes_nb);
 }
 
-- 
1.8.0.2

