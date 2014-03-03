Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaCCIuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:50:12 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:26800 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbaCCIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:50:10 -0500
Message-ID: <53144223.6000302@huawei.com>
Date: Mon, 3 Mar 2014 16:49:39 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] cpuset: use rcu_read_lock() to protect task_cs()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer use task_lock() to protect tsk->cgroups.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index c63a0d9..4b3560d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2235,10 +2235,10 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 	struct cpuset *cpus_cs;
 
 	mutex_lock(&callback_mutex);
-	task_lock(tsk);
+	rcu_read_lock();
 	cpus_cs = effective_cpumask_cpuset(task_cs(tsk));
 	guarantee_online_cpus(cpus_cs, pmask);
-	task_unlock(tsk);
+	rcu_read_unlock();
 	mutex_unlock(&callback_mutex);
 }
 
@@ -2291,10 +2291,10 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
 	nodemask_t mask;
 
 	mutex_lock(&callback_mutex);
-	task_lock(tsk);
+	rcu_read_lock();
 	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
 	guarantee_online_mems(mems_cs, &mask);
-	task_unlock(tsk);
+	rcu_read_unlock();
 	mutex_unlock(&callback_mutex);
 
 	return mask;
@@ -2410,10 +2410,10 @@ int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 	/* Not hardwall and node outside mems_allowed: scan up cpusets */
 	mutex_lock(&callback_mutex);
 
-	task_lock(current);
+	rcu_read_lock();
 	cs = nearest_hardwall_ancestor(task_cs(current));
 	allowed = node_isset(node, cs->mems_allowed);
-	task_unlock(current);
+	rcu_read_unlock();
 
 	mutex_unlock(&callback_mutex);
 	return allowed;
@@ -2539,24 +2539,26 @@ int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
  * @task: pointer to task_struct of some task.
  *
  * Description: Prints @task's name, cpuset name, and cached copy of its
- * mems_allowed to the kernel log.  Must hold task_lock(task) to allow
- * dereferencing task_cs(task).
+ * mems_allowed to the kernel log.
  */
 void cpuset_print_task_mems_allowed(struct task_struct *tsk)
 {
 	 /* Statically allocated to prevent using excess stack. */
 	static char cpuset_nodelist[CPUSET_NODELIST_LEN];
 	static DEFINE_SPINLOCK(cpuset_buffer_lock);
-	struct cgroup *cgrp = task_cs(tsk)->css.cgroup;
+	struct cgroup *cgrp;
 
 	spin_lock(&cpuset_buffer_lock);
+	rcu_read_lock();
 
+	cgrp = task_cs(tsk)->css.cgroup;
 	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
 			   tsk->mems_allowed);
 	printk(KERN_INFO "%s cpuset=", tsk->comm);
 	pr_cont_cgroup_name(cgrp);
 	pr_cont(" mems_allowed=%s\n", cpuset_nodelist);
 
+	rcu_read_unlock();
 	spin_unlock(&cpuset_buffer_lock);
 }
 
@@ -2588,9 +2590,9 @@ int cpuset_memory_pressure_enabled __read_mostly;
 
 void __cpuset_memory_pressure_bump(void)
 {
-	task_lock(current);
+	rcu_read_lock();
 	fmeter_markevent(&task_cs(current)->fmeter);
-	task_unlock(current);
+	rcu_read_unlock();
 }
 
 #ifdef CONFIG_PROC_PID_CPUSET
-- 
1.8.0.2
