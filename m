Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab3APP5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:57:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35608 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3APP5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:57:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 003/222] cgroup: cgroup_subsys->fork() should be called after the task is added to css_set
Date: Wed, 16 Jan 2013 13:53:23 -0200
Message-Id: <1358351822-7675-4-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 5edee61edeaaebafe584f8fb7074c1ef4658596b upstream.

cgroup core has a bug which violates a basic rule about event
notifications - when a new entity needs to be added, you add that to
the notification list first and then make the new entity conform to
the current state.  If done in the reverse order, an event happening
inbetween will be lost.

cgroup_subsys->fork() is invoked way before the new task is added to
the css_set.  Currently, cgroup_freezer is the only user of ->fork()
and uses it to make new tasks conform to the current state of the
freezer.  If FROZEN state is requested while fork is in progress
between cgroup_fork_callbacks() and cgroup_post_fork(), the child
could escape freezing - the cgroup isn't frozen when ->fork() is
called and the freezer couldn't see the new task on the css_set.

This patch moves cgroup_subsys->fork() invocation to
cgroup_post_fork() after the new task is added to the css_set.
cgroup_fork_callbacks() is removed.

Because now a task may be migrated during cgroup_subsys->fork(),
freezer_fork() is updated so that it adheres to the usual RCU locking
and the rather pointless comment on why locking can be different there
is removed (if it doesn't make anything simpler, why even bother?).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
[ herton: backport to 3.5, CGROUP_BUILTIN_SUBSYS_COUNT is still present,
  move the same code in cgroup_fork_callbacks over to cgroup_post_fork ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/cgroup.h  |    1 -
 kernel/cgroup.c         |   55 ++++++++++++++++++++++-------------------------
 kernel/cgroup_freezer.c |   13 ++++-------
 kernel/fork.c           |    9 +-------
 4 files changed, 31 insertions(+), 47 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d3f5fba..986b06a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -33,7 +33,6 @@ extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
 extern void cgroup_fork(struct task_struct *p);
-extern void cgroup_fork_callbacks(struct task_struct *p);
 extern void cgroup_post_fork(struct task_struct *p);
 extern void cgroup_exit(struct task_struct *p, int run_callbacks);
 extern int cgroupstats_build(struct cgroupstats *stats,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a91aa0b..a31b636 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4757,41 +4757,19 @@ void cgroup_fork(struct task_struct *child)
 }
 
 /**
- * cgroup_fork_callbacks - run fork callbacks
- * @child: the new task
- *
- * Called on a new task very soon before adding it to the
- * tasklist. No need to take any locks since no-one can
- * be operating on this task.
- */
-void cgroup_fork_callbacks(struct task_struct *child)
-{
-	if (need_forkexit_callback) {
-		int i;
-		/*
-		 * forkexit callbacks are only supported for builtin
-		 * subsystems, and the builtin section of the subsys array is
-		 * immutable, so we don't need to lock the subsys array here.
-		 */
-		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
-			struct cgroup_subsys *ss = subsys[i];
-			if (ss->fork)
-				ss->fork(child);
-		}
-	}
-}
-
-/**
  * cgroup_post_fork - called on a new task after adding it to the task list
  * @child: the task in question
  *
- * Adds the task to the list running through its css_set if necessary.
- * Has to be after the task is visible on the task list in case we race
- * with the first call to cgroup_iter_start() - to guarantee that the
- * new task ends up on its list.
+ * Adds the task to the list running through its css_set if necessary and
+ * call the subsystem fork() callbacks.  Has to be after the task is
+ * visible on the task list in case we race with the first call to
+ * cgroup_iter_start() - to guarantee that the new task ends up on its
+ * list.
  */
 void cgroup_post_fork(struct task_struct *child)
 {
+	int i;
+
 	/*
 	 * use_task_css_set_links is set to 1 before we walk the tasklist
 	 * under the tasklist_lock and we read it here after we added the child
@@ -4811,7 +4789,26 @@ void cgroup_post_fork(struct task_struct *child)
 		task_unlock(child);
 		write_unlock(&css_set_lock);
 	}
+
+	/*
+	 * Call ss->fork().  This must happen after @child is linked on
+	 * css_set; otherwise, @child might change state between ->fork()
+	 * and addition to css_set.
+	 */
+	if (need_forkexit_callback) {
+		/*
+		 * forkexit callbacks are only supported for builtin
+		 * subsystems, and the builtin section of the subsys array is
+		 * immutable, so we don't need to lock the subsys array here.
+		 */
+		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
+			struct cgroup_subsys *ss = subsys[i];
+			if (ss->fork)
+				ss->fork(child);
+		}
+	}
 }
+
 /**
  * cgroup_exit - detach cgroup from exiting task
  * @tsk: pointer to task_struct of exiting process
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 3649fc6..f990569 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -186,23 +186,15 @@ static void freezer_fork(struct task_struct *task)
 {
 	struct freezer *freezer;
 
-	/*
-	 * No lock is needed, since the task isn't on tasklist yet,
-	 * so it can't be moved to another cgroup, which means the
-	 * freezer won't be removed and will be valid during this
-	 * function call.  Nevertheless, apply RCU read-side critical
-	 * section to suppress RCU lockdep false positives.
-	 */
 	rcu_read_lock();
 	freezer = task_freezer(task);
-	rcu_read_unlock();
 
 	/*
 	 * The root cgroup is non-freezable, so we can skip the
 	 * following check.
 	 */
 	if (!freezer->css.cgroup->parent)
-		return;
+		goto out;
 
 	spin_lock_irq(&freezer->lock);
 	BUG_ON(freezer->state == CGROUP_FROZEN);
@@ -210,7 +202,10 @@ static void freezer_fork(struct task_struct *task)
 	/* Locking avoids race with FREEZING -> THAWED transitions. */
 	if (freezer->state == CGROUP_FREEZING)
 		freeze_task(task);
+
 	spin_unlock_irq(&freezer->lock);
+out:
+	rcu_read_unlock();
 }
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index f9d0499..bbb6881 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1160,7 +1160,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 {
 	int retval;
 	struct task_struct *p;
-	int cgroup_callbacks_done = 0;
 
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
@@ -1422,12 +1421,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	INIT_LIST_HEAD(&p->thread_group);
 	INIT_HLIST_HEAD(&p->task_works);
 
-	/* Now that the task is set up, run cgroup callbacks if
-	 * necessary. We need to run them before the task is visible
-	 * on the tasklist. */
-	cgroup_fork_callbacks(p);
-	cgroup_callbacks_done = 1;
-
 	/* Need tasklist lock for parent etc handling! */
 	write_lock_irq(&tasklist_lock);
 
@@ -1532,7 +1525,7 @@ bad_fork_cleanup_cgroup:
 #endif
 	if (clone_flags & CLONE_THREAD)
 		threadgroup_change_end(current);
-	cgroup_exit(p, cgroup_callbacks_done);
+	cgroup_exit(p, 0);
 	delayacct_tsk_free(p);
 	module_put(task_thread_info(p)->exec_domain->module);
 bad_fork_cleanup_count:
-- 
1.7.9.5

