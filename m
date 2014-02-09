Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaBIN44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:56:56 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:63327 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaBINxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:53:04 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/16] cgroup: relocate cgroup_enable_task_cg_lists()
Date: Sun,  9 Feb 2014 08:52:32 -0500
Message-Id: <1391953964-22088-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391953964-22088-1-git-send-email-tj@kernel.org>
References: <1391953964-22088-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move it above so that prototype isn't necessary.  Let's also move the
definition of use_task_css_set_links next to it.

This is purely cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 103 ++++++++++++++++++++++++++------------------------------
 1 file changed, 48 insertions(+), 55 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index efae7e2..1ebc6e30 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -173,7 +173,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp);
 static int cgroup_addrm_files(struct cgroup *cgrp, struct cftype cfts[],
 			      bool is_add);
 static void cgroup_pidlist_destroy_all(struct cgroup *cgrp);
-static void cgroup_enable_task_cg_lists(void);
 
 /**
  * cgroup_css - obtain a cgroup's css for the specified subsystem
@@ -370,14 +369,6 @@ static unsigned long css_set_hash(struct cgroup_subsys_state *css[])
 	return key;
 }
 
-/*
- * We don't maintain the lists running through each css_set to its task
- * until after the first call to css_task_iter_start().  This reduces the
- * fork()/exit() overhead for people who have cgroups compiled into their
- * kernel but not actually in use.
- */
-static bool use_task_css_set_links __read_mostly;
-
 static void __put_css_set(struct css_set *cset, int taskexit)
 {
 	struct cgrp_cset_link *link, *tmp_link;
@@ -1305,6 +1296,54 @@ static int cgroup_remount(struct kernfs_root *kf_root, int *flags, char *data)
 	return ret;
 }
 
+/*
+ * To reduce the fork() overhead for systems that are not actually using
+ * their cgroups capability, we don't maintain the lists running through
+ * each css_set to its tasks until we see the list actually used - in other
+ * words after the first mount.
+ */
+static bool use_task_css_set_links __read_mostly;
+
+static void cgroup_enable_task_cg_lists(void)
+{
+	struct task_struct *p, *g;
+
+	write_lock(&css_set_lock);
+
+	if (use_task_css_set_links)
+		goto out_unlock;
+
+	use_task_css_set_links = true;
+
+	/*
+	 * We need tasklist_lock because RCU is not safe against
+	 * while_each_thread(). Besides, a forking task that has passed
+	 * cgroup_post_fork() without seeing use_task_css_set_links = 1
+	 * is not guaranteed to have its child immediately visible in the
+	 * tasklist if we walk through it with RCU.
+	 */
+	read_lock(&tasklist_lock);
+	do_each_thread(g, p) {
+		task_lock(p);
+
+		WARN_ON_ONCE(!list_empty(&p->cg_list) ||
+			     task_css_set(p) != &init_css_set);
+
+		/*
+		 * We should check if the process is exiting, otherwise
+		 * it will race with cgroup_exit() in that the list
+		 * entry won't be deleted though the process has exited.
+		 */
+		if (!(p->flags & PF_EXITING))
+			list_add(&p->cg_list, &task_css_set(p)->tasks);
+
+		task_unlock(p);
+	} while_each_thread(g, p);
+	read_unlock(&tasklist_lock);
+out_unlock:
+	write_unlock(&css_set_lock);
+}
+
 static void init_cgroup_housekeeping(struct cgroup *cgrp)
 {
 	atomic_set(&cgrp->refcnt, 1);
@@ -2363,52 +2402,6 @@ int cgroup_task_count(const struct cgroup *cgrp)
 	return count;
 }
 
-/*
- * To reduce the fork() overhead for systems that are not actually using
- * their cgroups capability, we don't maintain the lists running through
- * each css_set to its tasks until we see the list actually used - in other
- * words after the first mount.
- */
-static void cgroup_enable_task_cg_lists(void)
-{
-	struct task_struct *p, *g;
-
-	write_lock(&css_set_lock);
-
-	if (use_task_css_set_links)
-		goto out_unlock;
-
-	use_task_css_set_links = true;
-
-	/*
-	 * We need tasklist_lock because RCU is not safe against
-	 * while_each_thread(). Besides, a forking task that has passed
-	 * cgroup_post_fork() without seeing use_task_css_set_links = 1
-	 * is not guaranteed to have its child immediately visible in the
-	 * tasklist if we walk through it with RCU.
-	 */
-	read_lock(&tasklist_lock);
-	do_each_thread(g, p) {
-		task_lock(p);
-
-		WARN_ON_ONCE(!list_empty(&p->cg_list) ||
-			     task_css_set(p) != &init_css_set);
-
-		/*
-		 * We should check if the process is exiting, otherwise
-		 * it will race with cgroup_exit() in that the list
-		 * entry won't be deleted though the process has exited.
-		 */
-		if (!(p->flags & PF_EXITING))
-			list_add(&p->cg_list, &task_css_set(p)->tasks);
-
-		task_unlock(p);
-	} while_each_thread(g, p);
-	read_unlock(&tasklist_lock);
-out_unlock:
-	write_unlock(&css_set_lock);
-}
-
 /**
  * css_next_child - find the next child of a given css
  * @pos_css: the current position (%NULL to initiate traversal)
-- 
1.8.5.3

