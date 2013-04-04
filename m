Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765487Ab3DDXg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:36:56 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:42153 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765461Ab3DDXgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:36:54 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] cgroup, cpuset: replace move_member_tasks_to_cpuset() with cgroup_transfer_tasks()
Date: Thu,  4 Apr 2013 16:36:25 -0700
Message-Id: <1365118589-10619-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365118589-10619-1-git-send-email-tj@kernel.org>
References: <1365118589-10619-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a cpuset becomes empty (no CPU or memory), its tasks are
transferred with the nearest ancestor with execution resources.  This
is implemented using cgroup_scan_tasks() with a callback which grabs
cgroup_mutex and invokes cgroup_attach_task() on each task.

Both cgroup_mutex and cgroup_attach_task() are scheduled to be
unexported.  Implement cgroup_transfer_tasks() in cgroup proper which
is essentially the same as move_member_tasks_to_cpuset() except that
it takes cgroups instead of cpusets and @to comes before @from like
normal functions with those arguments, and replace
move_member_tasks_to_cpuset() with it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 28 +++++++++++++++++++++++++++
 kernel/cpuset.c        | 51 ++++++--------------------------------------------
 3 files changed, 35 insertions(+), 45 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 01c48c6..f8eb01d 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -696,6 +696,7 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 		       bool threadgroup);
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
+int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
 
 /*
  * CSS ID is ID for cgroup_subsys_state structs under subsys. This only works
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4aee5bd..147d7cc 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3269,6 +3269,34 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan)
 	return 0;
 }
 
+static void cgroup_transfer_one_task(struct task_struct *task,
+				     struct cgroup_scanner *scan)
+{
+	struct cgroup *new_cgroup = scan->data;
+
+	cgroup_lock();
+	cgroup_attach_task(new_cgroup, task, false);
+	cgroup_unlock();
+}
+
+/**
+ * cgroup_trasnsfer_tasks - move tasks from one cgroup to another
+ * @to: cgroup to which the tasks will be moved
+ * @from: cgroup in which the tasks currently reside
+ */
+int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
+{
+	struct cgroup_scanner scan;
+
+	scan.cg = from;
+	scan.test_task = NULL; /* select all tasks in cgroup */
+	scan.process_task = cgroup_transfer_one_task;
+	scan.heap = NULL;
+	scan.data = to;
+
+	return cgroup_scan_tasks(&scan);
+}
+
 /*
  * Stuff for reading the 'tasks'/'procs' files.
  *
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 98d458a..866d78e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1994,50 +1994,6 @@ int __init cpuset_init(void)
 	return 0;
 }
 
-/**
- * cpuset_do_move_task - move a given task to another cpuset
- * @tsk: pointer to task_struct the task to move
- * @scan: struct cgroup_scanner contained in its struct cpuset_hotplug_scanner
- *
- * Called by cgroup_scan_tasks() for each task in a cgroup.
- * Return nonzero to stop the walk through the tasks.
- */
-static void cpuset_do_move_task(struct task_struct *tsk,
-				struct cgroup_scanner *scan)
-{
-	struct cgroup *new_cgroup = scan->data;
-
-	cgroup_lock();
-	cgroup_attach_task(new_cgroup, tsk, false);
-	cgroup_unlock();
-}
-
-/**
- * move_member_tasks_to_cpuset - move tasks from one cpuset to another
- * @from: cpuset in which the tasks currently reside
- * @to: cpuset to which the tasks will be moved
- *
- * Called with cpuset_mutex held
- * callback_mutex must not be held, as cpuset_attach() will take it.
- *
- * The cgroup_scan_tasks() function will scan all the tasks in a cgroup,
- * calling callback functions for each.
- */
-static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)
-{
-	struct cgroup_scanner scan;
-
-	scan.cg = from->css.cgroup;
-	scan.test_task = NULL; /* select all tasks in cgroup */
-	scan.process_task = cpuset_do_move_task;
-	scan.heap = NULL;
-	scan.data = to->css.cgroup;
-
-	if (cgroup_scan_tasks(&scan))
-		printk(KERN_ERR "move_member_tasks_to_cpuset: "
-				"cgroup_scan_tasks failed\n");
-}
-
 /*
  * If CPU and/or memory hotplug handlers, below, unplug any CPUs
  * or memory nodes, we need to walk over the cpuset hierarchy,
@@ -2058,7 +2014,12 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 			nodes_empty(parent->mems_allowed))
 		parent = parent_cs(parent);
 
-	move_member_tasks_to_cpuset(cs, parent);
+	if (cgroup_transfer_tasks(parent->css.cgroup, cs->css.cgroup)) {
+		rcu_read_lock();
+		printk(KERN_ERR "cpuset: failed to transfer tasks out of empty cpuset %s\n",
+		       cgroup_name(cs->css.cgroup));
+		rcu_read_unlock();
+	}
 }
 
 /**
-- 
1.8.1.4

