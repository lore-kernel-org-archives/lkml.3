Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765530Ab3DDXhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:37:36 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:37824 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765492Ab3DDXg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:36:58 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] cgroup: kill cgroup_[un]lock()
Date: Thu,  4 Apr 2013 16:36:28 -0700
Message-Id: <1365118589-10619-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365118589-10619-1-git-send-email-tj@kernel.org>
References: <1365118589-10619-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that locking interface is unexported, there's no reason to keep
around these thin wrappers.  Kill them and use mutex operations
directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 41 +++++++++++------------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 32ca030..1a65958 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -333,8 +333,8 @@ static inline struct cftype *__d_cft(struct dentry *dentry)
  * cgroup_lock_live_group - take cgroup_mutex and check that cgrp is alive.
  * @cgrp: the cgroup to be checked for liveness
  *
- * On success, returns true; the lock should be later released with
- * cgroup_unlock(). On failure returns false with no lock held.
+ * On success, returns true; the mutex should be later unlocked.  On
+ * failure returns false with no lock held.
  */
 static bool cgroup_lock_live_group(struct cgroup *cgrp)
 {
@@ -819,25 +819,6 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
  * update of a tasks cgroup pointer by cgroup_attach_task()
  */
 
-/**
- * cgroup_lock - lock out any changes to cgroup structures
- *
- */
-static void cgroup_lock(void)
-{
-	mutex_lock(&cgroup_mutex);
-}
-
-/**
- * cgroup_unlock - release lock on cgroup changes
- *
- * Undo the lock taken in a previous cgroup_lock() call.
- */
-static void cgroup_unlock(void)
-{
-	mutex_unlock(&cgroup_mutex);
-}
-
 /*
  * A couple of forward declarations required, due to cyclic reference loop:
  * cgroup_mkdir -> cgroup_create -> cgroup_populate_dir ->
@@ -1967,8 +1948,8 @@ static void cgroup_task_migrate(struct cgroup *oldcgrp,
  * Call holding cgroup_mutex and the group_rwsem of the leader. Will take
  * task_lock of @tsk or each thread in the threadgroup individually in turn.
  */
-int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
-		       bool threadgroup)
+static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
+			      bool threadgroup)
 {
 	int retval, i, group_size;
 	struct cgroup_subsys *ss, *failed_ss = NULL;
@@ -2191,7 +2172,7 @@ retry_find_task:
 
 	put_task_struct(tsk);
 out_unlock_cgroup:
-	cgroup_unlock();
+	mutex_unlock(&cgroup_mutex);
 	return ret;
 }
 
@@ -2205,7 +2186,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 	struct cgroupfs_root *root;
 	int retval = 0;
 
-	cgroup_lock();
+	mutex_lock(&cgroup_mutex);
 	for_each_active_root(root) {
 		struct cgroup *from_cg = task_cgroup_from_root(from, root);
 
@@ -2213,7 +2194,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 		if (retval)
 			break;
 	}
-	cgroup_unlock();
+	mutex_unlock(&cgroup_mutex);
 
 	return retval;
 }
@@ -2240,7 +2221,7 @@ static int cgroup_release_agent_write(struct cgroup *cgrp, struct cftype *cft,
 	mutex_lock(&cgroup_root_mutex);
 	strcpy(cgrp->root->release_agent_path, buffer);
 	mutex_unlock(&cgroup_root_mutex);
-	cgroup_unlock();
+	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
 
@@ -2251,7 +2232,7 @@ static int cgroup_release_agent_show(struct cgroup *cgrp, struct cftype *cft,
 		return -ENODEV;
 	seq_puts(seq, cgrp->root->release_agent_path);
 	seq_putc(seq, '\n');
-	cgroup_unlock();
+	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
 
@@ -3271,9 +3252,9 @@ static void cgroup_transfer_one_task(struct task_struct *task,
 {
 	struct cgroup *new_cgroup = scan->data;
 
-	cgroup_lock();
+	mutex_lock(&cgroup_mutex);
 	cgroup_attach_task(new_cgroup, task, false);
-	cgroup_unlock();
+	mutex_unlock(&cgroup_mutex);
 }
 
 /**
-- 
1.8.1.4

