Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaBINxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:53:16 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:40168 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaBINxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:53:13 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/16] cgroup: move css_set_rwsem locking outside of cgroup_task_migrate()
Date: Sun,  9 Feb 2014 08:52:39 -0500
Message-Id: <1391953964-22088-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391953964-22088-1-git-send-email-tj@kernel.org>
References: <1391953964-22088-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of repeatedly locking and unlocking css_set_rwsem inside
cgroup_task_migrate(), update cgroup_attach_task() to grab it outside
of the loop and update cgroup_task_migrate() to use
put_css_set_locked().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 63d1a4e..ac78311 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1713,10 +1713,13 @@ int cgroup_taskset_size(struct cgroup_taskset *tset)
 EXPORT_SYMBOL_GPL(cgroup_taskset_size);
 
 
-/*
+/**
  * cgroup_task_migrate - move a task from one cgroup to another.
+ * @old_cgrp; the cgroup @tsk is being migrated from
+ * @tsk: the task being migrated
+ * @new_cset: the new css_set @tsk is being attached to
  *
- * Must be called with cgroup_mutex and threadgroup locked.
+ * Must be called with cgroup_mutex, threadgroup and css_set_rwsem locked.
  */
 static void cgroup_task_migrate(struct cgroup *old_cgrp,
 				struct task_struct *tsk,
@@ -1724,6 +1727,9 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
 {
 	struct css_set *old_cset;
 
+	lockdep_assert_held(&cgroup_mutex);
+	lockdep_assert_held(&css_set_rwsem);
+
 	/*
 	 * We are synchronized through threadgroup_lock() against PF_EXITING
 	 * setting such that we can't race against cgroup_exit() changing the
@@ -1737,9 +1743,7 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
 	task_unlock(tsk);
 
 	/* Update the css_set linked lists if we're using them */
-	down_write(&css_set_rwsem);
 	list_move(&tsk->cg_list, &new_cset->tasks);
-	up_write(&css_set_rwsem);
 
 	/*
 	 * We just gained a reference on old_cset by taking it from the
@@ -1747,7 +1751,7 @@ static void cgroup_task_migrate(struct cgroup *old_cgrp,
 	 * we're safe to drop it here; it will be freed under RCU.
 	 */
 	set_bit(CGRP_RELEASABLE, &old_cgrp->flags);
-	put_css_set(old_cset, false);
+	put_css_set_locked(old_cset, false);
 }
 
 /**
@@ -1870,10 +1874,12 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 	 * proceed to move all tasks to the new cgroup.  There are no
 	 * failure cases after here, so this is the commit point.
 	 */
+	down_write(&css_set_rwsem);
 	for (i = 0; i < group_size; i++) {
 		tc = flex_array_get(group, i);
 		cgroup_task_migrate(tc->cgrp, tc->task, tc->cset);
 	}
+	up_write(&css_set_rwsem);
 	/* nothing is sensitive to fork() after this point. */
 
 	/*
-- 
1.8.5.3

