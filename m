Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbaBJUW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:22:57 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:65367 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbaBJUVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:21:43 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] cgroup: separate out cset_group_from_root() from task_cgroup_from_root()
Date: Mon, 10 Feb 2014 15:21:32 -0500
Message-Id: <1392063694-26465-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392063694-26465-1-git-send-email-tj@kernel.org>
References: <1392063694-26465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be used by the planned migration path update.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6727171..9201160 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -758,25 +758,15 @@ static void cgroup_destroy_root(struct cgroupfs_root *root)
 	cgroup_free_root(root);
 }
 
-/*
- * Return the cgroup for "task" from the given hierarchy. Must be
- * called with cgroup_mutex and css_set_rwsem held.
- */
-static struct cgroup *task_cgroup_from_root(struct task_struct *task,
+/* look up cgroup associated with given css_set on the specified hierarchy */
+static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
 					    struct cgroupfs_root *root)
 {
-	struct css_set *cset;
 	struct cgroup *res = NULL;
 
 	lockdep_assert_held(&cgroup_mutex);
 	lockdep_assert_held(&css_set_rwsem);
 
-	/*
-	 * No need to lock the task - since we hold cgroup_mutex the
-	 * task can't change groups, so the only thing that can happen
-	 * is that it exits and its css is set back to init_css_set.
-	 */
-	cset = task_css_set(task);
 	if (cset == &init_css_set) {
 		res = &root->top_cgroup;
 	} else {
@@ -797,6 +787,21 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
 }
 
 /*
+ * Return the cgroup for "task" from the given hierarchy. Must be
+ * called with cgroup_mutex and css_set_rwsem held.
+ */
+static struct cgroup *task_cgroup_from_root(struct task_struct *task,
+					    struct cgroupfs_root *root)
+{
+	/*
+	 * No need to lock the task - since we hold cgroup_mutex the
+	 * task can't change groups, so the only thing that can happen
+	 * is that it exits and its css is set back to init_css_set.
+	 */
+	return cset_cgroup_from_root(task_css_set(task), root);
+}
+
+/*
  * There is one global cgroup mutex. We also require taking
  * task_lock() when dereferencing a task's cgroup subsys pointers.
  * See "The task_lock() exception", at the end of this comment.
-- 
1.8.5.3

