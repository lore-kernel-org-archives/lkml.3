Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbaGIIrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:47:41 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:65429 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaGIIri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:47:38 -0400
Message-ID: <53BD01A1.2060302@huawei.com>
Date: Wed, 9 Jul 2014 16:47:29 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v3 03/12] cpuset: update cs->effective_{cpus,mems} when config
 changes
References: <53BD0174.4060002@huawei.com>
In-Reply-To: <53BD0174.4060002@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020207.53BD01A7.00C9,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: e5ab87945636ea16e97839ae0b1e4368
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

To make cs->effective_{cpus,mems} to be effective masks, we need to
  - update the effective masks at hotplug
  - update the effective masks at config change
  - take on ancestor's mask when the effective mask is empty

The second item is done here. We don't need to treat root_cs specially
in update_cpumasks_hier().

This won't introduce behavior change.

v3:
- add a WARN_ON() to check if effective masks are the same with configured
  masks on legacy hierarchy.
- pass trialcs->cpus_allowed to update_cpumasks_hier() and add a comment for
  it. Similar change for update_nodemasks_hier(). Suggested by Tejun.

v2:
- revise the comment in update_{cpu,node}masks_hier(), suggested by Tejun.
- fix to use @cp instead of @cs in these two functions.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 88 +++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 54 insertions(+), 34 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 94f651d..da766c3 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -855,36 +855,45 @@ static void update_tasks_cpumask(struct cpuset *cs)
 }
 
 /*
- * update_tasks_cpumask_hier - Update the cpumasks of tasks in the hierarchy.
- * @root_cs: the root cpuset of the hierarchy
- * @update_root: update root cpuset or not?
+ * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
+ * @cs: the cpuset to consider
+ * @new_cpus: temp variable for calculating new effective_cpus
+ *
+ * When congifured cpumask is changed, the effective cpumasks of this cpuset
+ * and all its descendants need to be updated.
  *
- * This will update cpumasks of tasks in @root_cs and all other empty cpusets
- * which take on cpumask of @root_cs.
+ * On legacy hierachy, effective_cpus will be the same with cpu_allowed.
  *
  * Called with cpuset_mutex held
  */
-static void update_tasks_cpumask_hier(struct cpuset *root_cs, bool update_root)
+static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 {
 	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
 
 	rcu_read_lock();
-	cpuset_for_each_descendant_pre(cp, pos_css, root_cs) {
-		if (cp == root_cs) {
-			if (!update_root)
-				continue;
-		} else {
-			/* skip the whole subtree if @cp have some CPU */
-			if (!cpumask_empty(cp->cpus_allowed)) {
-				pos_css = css_rightmost_descendant(pos_css);
-				continue;
-			}
+	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
+		struct cpuset *parent = parent_cs(cp);
+
+		cpumask_and(new_cpus, cp->cpus_allowed, parent->effective_cpus);
+
+		/* Skip the whole subtree if the cpumask remains the same. */
+		if (cpumask_equal(new_cpus, cp->effective_cpus)) {
+			pos_css = css_rightmost_descendant(pos_css);
+			continue;
 		}
+
 		if (!css_tryget_online(&cp->css))
 			continue;
 		rcu_read_unlock();
 
+		mutex_lock(&callback_mutex);
+		cpumask_copy(cp->effective_cpus, new_cpus);
+		mutex_unlock(&callback_mutex);
+
+		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
+			!cpumask_equal(cp->cpus_allowed, cp->effective_cpus));
+
 		update_tasks_cpumask(cp);
 
 		rcu_read_lock();
@@ -940,7 +949,8 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
-	update_tasks_cpumask_hier(cs, true);
+	/* use trialcs->cpus_allowed as a temp variable */
+	update_cpumasks_hier(cs, trialcs->cpus_allowed);
 
 	if (is_load_balanced)
 		rebuild_sched_domains_locked();
@@ -1091,36 +1101,45 @@ static void update_tasks_nodemask(struct cpuset *cs)
 }
 
 /*
- * update_tasks_nodemask_hier - Update the nodemasks of tasks in the hierarchy.
- * @cs: the root cpuset of the hierarchy
- * @update_root: update the root cpuset or not?
+ * update_nodemasks_hier - Update effective nodemasks and tasks in the subtree
+ * @cs: the cpuset to consider
+ * @new_mems: a temp variable for calculating new effective_mems
+ *
+ * When configured nodemask is changed, the effective nodemasks of this cpuset
+ * and all its descendants need to be updated.
  *
- * This will update nodemasks of tasks in @root_cs and all other empty cpusets
- * which take on nodemask of @root_cs.
+ * On legacy hiearchy, effective_mems will be the same with mems_allowed.
  *
  * Called with cpuset_mutex held
  */
-static void update_tasks_nodemask_hier(struct cpuset *root_cs, bool update_root)
+static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 {
 	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
 
 	rcu_read_lock();
-	cpuset_for_each_descendant_pre(cp, pos_css, root_cs) {
-		if (cp == root_cs) {
-			if (!update_root)
-				continue;
-		} else {
-			/* skip the whole subtree if @cp have some CPU */
-			if (!nodes_empty(cp->mems_allowed)) {
-				pos_css = css_rightmost_descendant(pos_css);
-				continue;
-			}
+	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
+		struct cpuset *parent = parent_cs(cp);
+
+		nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
+
+		/* Skip the whole subtree if the nodemask remains the same. */
+		if (nodes_equal(*new_mems, cp->effective_mems)) {
+			pos_css = css_rightmost_descendant(pos_css);
+			continue;
 		}
+
 		if (!css_tryget_online(&cp->css))
 			continue;
 		rcu_read_unlock();
 
+		mutex_lock(&callback_mutex);
+		cp->effective_mems = *new_mems;
+		mutex_unlock(&callback_mutex);
+
+		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
+			nodes_equal(cp->mems_allowed, cp->effective_mems));
+
 		update_tasks_nodemask(cp);
 
 		rcu_read_lock();
@@ -1188,7 +1207,8 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 	cs->mems_allowed = trialcs->mems_allowed;
 	mutex_unlock(&callback_mutex);
 
-	update_tasks_nodemask_hier(cs, true);
+	/* use trialcs->mems_allowed as a temp variable */
+	update_nodemasks_hier(cs, &cs->mems_allowed);
 done:
 	return retval;
 }
-- 
1.8.0.2

