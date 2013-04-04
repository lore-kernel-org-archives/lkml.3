Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765517Ab3DDXiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:38:09 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:36219 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765340Ab3DDXgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:36:55 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] cgroup: relocate cgroup_lock_live_group() and cgroup_attach_task_all()
Date: Thu,  4 Apr 2013 16:36:26 -0700
Message-Id: <1365118589-10619-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365118589-10619-1-git-send-email-tj@kernel.org>
References: <1365118589-10619-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_lock_live_group() and cgroup_attach_task() are scheduled to be
made static.  Relocate the former and cgroup_attach_task_all() so that
we don't need forward declarations.

This patch is pure relocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 84 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 147d7cc..ae76170 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -329,6 +329,24 @@ static inline struct cftype *__d_cft(struct dentry *dentry)
 	return __d_cfe(dentry)->type;
 }
 
+/**
+ * cgroup_lock_live_group - take cgroup_mutex and check that cgrp is alive.
+ * @cgrp: the cgroup to be checked for liveness
+ *
+ * On success, returns true; the lock should be later released with
+ * cgroup_unlock(). On failure returns false with no lock held.
+ */
+bool cgroup_lock_live_group(struct cgroup *cgrp)
+{
+	mutex_lock(&cgroup_mutex);
+	if (cgroup_is_removed(cgrp)) {
+		mutex_unlock(&cgroup_mutex);
+		return false;
+	}
+	return true;
+}
+EXPORT_SYMBOL_GPL(cgroup_lock_live_group);
+
 /* the list of cgroups eligible for automatic release. Protected by
  * release_list_lock */
 static LIST_HEAD(release_list);
@@ -1944,30 +1962,6 @@ static void cgroup_task_migrate(struct cgroup *oldcgrp,
 }
 
 /**
- * cgroup_attach_task_all - attach task 'tsk' to all cgroups of task 'from'
- * @from: attach to all cgroups of a given task
- * @tsk: the task to be attached
- */
-int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
-{
-	struct cgroupfs_root *root;
-	int retval = 0;
-
-	cgroup_lock();
-	for_each_active_root(root) {
-		struct cgroup *from_cg = task_cgroup_from_root(from, root);
-
-		retval = cgroup_attach_task(from_cg, tsk, false);
-		if (retval)
-			break;
-	}
-	cgroup_unlock();
-
-	return retval;
-}
-EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
-
-/**
  * cgroup_attach_task - attach a task or a whole threadgroup to a cgroup
  * @cgrp: the cgroup to attach to
  * @tsk: the task or the leader of the threadgroup to be attached
@@ -2204,6 +2198,30 @@ out_unlock_cgroup:
 	return ret;
 }
 
+/**
+ * cgroup_attach_task_all - attach task 'tsk' to all cgroups of task 'from'
+ * @from: attach to all cgroups of a given task
+ * @tsk: the task to be attached
+ */
+int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
+{
+	struct cgroupfs_root *root;
+	int retval = 0;
+
+	cgroup_lock();
+	for_each_active_root(root) {
+		struct cgroup *from_cg = task_cgroup_from_root(from, root);
+
+		retval = cgroup_attach_task(from_cg, tsk, false);
+		if (retval)
+			break;
+	}
+	cgroup_unlock();
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(cgroup_attach_task_all);
+
 static int cgroup_tasks_write(struct cgroup *cgrp, struct cftype *cft, u64 pid)
 {
 	return attach_task_by_pid(cgrp, pid, false);
@@ -2214,24 +2232,6 @@ static int cgroup_procs_write(struct cgroup *cgrp, struct cftype *cft, u64 tgid)
 	return attach_task_by_pid(cgrp, tgid, true);
 }
 
-/**
- * cgroup_lock_live_group - take cgroup_mutex and check that cgrp is alive.
- * @cgrp: the cgroup to be checked for liveness
- *
- * On success, returns true; the lock should be later released with
- * cgroup_unlock(). On failure returns false with no lock held.
- */
-bool cgroup_lock_live_group(struct cgroup *cgrp)
-{
-	mutex_lock(&cgroup_mutex);
-	if (cgroup_is_removed(cgrp)) {
-		mutex_unlock(&cgroup_mutex);
-		return false;
-	}
-	return true;
-}
-EXPORT_SYMBOL_GPL(cgroup_lock_live_group);
-
 static int cgroup_release_agent_write(struct cgroup *cgrp, struct cftype *cft,
 				      const char *buffer)
 {
-- 
1.8.1.4

