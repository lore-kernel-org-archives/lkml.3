Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3FEJRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:17:18 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:16782 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab3FEJQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:16:57 -0400
Message-ID: <51AF01F9.1020106@huawei.com>
Date: Wed, 5 Jun 2013 17:16:41 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: [PATCH v2 07/10] cpuset: introduce effective_{cpumask|nodemask}_cpuset()
References: <51AF0183.8070602@huawei.com>
In-Reply-To: <51AF0183.8070602@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

effective_cpumask_cpuset() returns an ancestor cpuset which has
non-empty cpumask.

If a cpuset is empty and the tasks in it need to update their
cpus_allowed, they take on the ancestor cpuset's cpumask.

This currently won't change any behavior, but it will later allow us
to keep tasks in empty cpusets.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 65 insertions(+), 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b848505..5252f94 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -795,6 +795,45 @@ void rebuild_sched_domains(void)
 	mutex_unlock(&cpuset_mutex);
 }
 
+/*
+ * effective_cpumask_cpuset - return nearest ancestor with non-empty cpus
+ * @cs: the cpuset in interest
+ *
+ * A cpuset's effective cpumask is the cpumask of the nearest ancestor
+ * with non-empty cpus. We use effective cpumask whenever:
+ * - we update tasks' cpus_allowed. (they take on the ancestor's cpumask
+ *   if the cpuset they reside in has no cpus)
+ * - we want to retrieve task_cs(tsk)'s cpus_allowed.
+ *
+ * Called with cpuset_mutex held. cpuset_cpus_allowed_fallback() is an
+ * exception. See comments there.
+ */
+static struct cpuset *effective_cpumask_cpuset(struct cpuset *cs)
+{
+	while (cpumask_empty(cs->cpus_allowed))
+		cs = parent_cs(cs);
+	return cs;
+}
+
+/*
+ * effective_nodemask_cpuset - return nearest ancestor with non-empty mems
+ * @cs: the cpuset in interest
+ *
+ * A cpuset's effective nodemask is the nodemask of the nearest ancestor
+ * with non-empty memss. We use effective nodemask whenever:
+ * - we update tasks' mems_allowed. (they take on the ancestor's nodemask
+ *   if the cpuset they reside in has no mems)
+ * - we want to retrieve task_cs(tsk)'s mems_allowed.
+ *
+ * Called with cpuset_mutex held.
+ */
+static struct cpuset *effective_nodemask_cpuset(struct cpuset *cs)
+{
+	while (nodes_empty(cs->mems_allowed))
+		cs = parent_cs(cs);
+	return cs;
+}
+
 /**
  * cpuset_change_cpumask - make a task's cpus_allowed the same as its cpuset's
  * @tsk: task to test
@@ -809,7 +848,10 @@ void rebuild_sched_domains(void)
 static void cpuset_change_cpumask(struct task_struct *tsk,
 				  struct cgroup_scanner *scan)
 {
-	set_cpus_allowed_ptr(tsk, ((cgroup_cs(scan->cg))->cpus_allowed));
+	struct cpuset *cpus_cs;
+
+	cpus_cs = effective_cpumask_cpuset(cgroup_cs(scan->cg));
+	set_cpus_allowed_ptr(tsk, cpus_cs->cpus_allowed);
 }
 
 /**
@@ -924,12 +966,14 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 							const nodemask_t *to)
 {
 	struct task_struct *tsk = current;
+	struct cpuset *mems_cs;
 
 	tsk->mems_allowed = *to;
 
 	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
 
-	guarantee_online_mems(task_cs(tsk),&tsk->mems_allowed);
+	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
+	guarantee_online_mems(mems_cs, &tsk->mems_allowed);
 }
 
 /*
@@ -1022,10 +1066,11 @@ static void update_tasks_nodemask(struct cpuset *cs, struct ptr_heap *heap)
 {
 	static nodemask_t newmems;	/* protected by cpuset_mutex */
 	struct cgroup_scanner scan;
+	struct cpuset *mems_cs = effective_nodemask_cpuset(cs);
 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
 
-	guarantee_online_mems(cs, &newmems);
+	guarantee_online_mems(mems_cs, &newmems);
 
 	scan.cg = cs->css.cgroup;
 	scan.test_task = NULL;
@@ -1409,6 +1454,8 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 	struct cgroup *oldcgrp = cgroup_taskset_cur_cgroup(tset);
 	struct cpuset *cs = cgroup_cs(cgrp);
 	struct cpuset *oldcs = cgroup_cs(oldcgrp);
+	struct cpuset *cpus_cs = effective_cpumask_cpuset(cs);
+	struct cpuset *mems_cs = effective_nodemask_cpuset(cs);
 
 	mutex_lock(&cpuset_mutex);
 
@@ -1416,9 +1463,9 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 	if (cs == &top_cpuset)
 		cpumask_copy(cpus_attach, cpu_possible_mask);
 	else
-		guarantee_online_cpus(cs, cpus_attach);
+		guarantee_online_cpus(cpus_cs, cpus_attach);
 
-	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
+	guarantee_online_mems(mems_cs, &cpuset_attach_nodemask_to);
 
 	cgroup_taskset_for_each(task, cgrp, tset) {
 		/*
@@ -1437,9 +1484,11 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 	 */
 	mm = get_task_mm(leader);
 	if (mm) {
+		struct cpuset *mems_oldcs = effective_nodemask_cpuset(oldcs);
+
 		mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
 		if (is_memory_migrate(cs))
-			cpuset_migrate_mm(mm, &oldcs->mems_allowed,
+			cpuset_migrate_mm(mm, &mems_oldcs->mems_allowed,
 					  &cpuset_attach_nodemask_to);
 		mmput(mm);
 	}
@@ -2217,20 +2266,23 @@ void __init cpuset_init_smp(void)
 
 void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
+	struct cpuset *cpus_cs;
+
 	mutex_lock(&callback_mutex);
 	task_lock(tsk);
-	guarantee_online_cpus(task_cs(tsk), pmask);
+	cpus_cs = effective_cpumask_cpuset(task_cs(tsk));
+	guarantee_online_cpus(cpus_cs, pmask);
 	task_unlock(tsk);
 	mutex_unlock(&callback_mutex);
 }
 
 void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
-	const struct cpuset *cs;
+	const struct cpuset *cpus_cs;
 
 	rcu_read_lock();
-	cs = task_cs(tsk);
-	do_set_cpus_allowed(tsk, cs->cpus_allowed);
+	cpus_cs = effective_cpumask_cpuset(task_cs(tsk));
+	do_set_cpus_allowed(tsk, cpus_cs->cpus_allowed);
 	rcu_read_unlock();
 
 	/*
@@ -2269,11 +2321,13 @@ void cpuset_init_current_mems_allowed(void)
 
 nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
 {
+	struct cpuset *mems_cs;
 	nodemask_t mask;
 
 	mutex_lock(&callback_mutex);
 	task_lock(tsk);
-	guarantee_online_mems(task_cs(tsk), &mask);
+	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
+	guarantee_online_mems(mems_cs, &mask);
 	task_unlock(tsk);
 	mutex_unlock(&callback_mutex);
 
-- 
1.8.0.2
