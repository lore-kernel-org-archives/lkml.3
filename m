Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaBMUaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 15:30:52 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:59928 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaBMU26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:28:58 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] cgroup: add css_set->mg_tasks
Date: Thu, 13 Feb 2014 15:28:47 -0500
Message-Id: <1392323333-18907-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392323333-18907-1-git-send-email-tj@kernel.org>
References: <1392323333-18907-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, while migrating tasks from one cgroup to another,
cgroup_attach_task() builds a flex array of all target tasks;
unfortunately, this has a couple issues.

* Flex array has size limit.  On 64bit, struct task_and_cgroup is
  24bytes making the flex element limit around 87k.  It is a high
  number but not impossible to hit.  This means that the current
  cgroup implementation can't migrate a process with more than 87k
  threads.

* Process migration involves memory allocation whose size is dependent
  on the number of threads the process has.  This means that cgroup
  core can't guarantee success or failure of multi-process migrations
  as memory allocation failure can happen in the middle.  This is in
  part because cgroup can't grab threadgroup locks of multiple
  processes at the same time, so when there are multiple processes to
  migrate, it is imposible to tell how many tasks are to be migrated
  beforehand.

  Note that this already affects cgroup_transfer_tasks().  cgroup
  currently cannot guarantee atomic success or failure of the
  operation.  It may fail in the middle and after such failure cgroup
  doesn't have enough information to roll back properly.  It just
  aborts with some tasks migrated and others not.

To resolve the situation, we're going to use task->cg_list during
migration too.  Instead of building a separate array, target tasks
will be linked into a dedicated migration list_head on the owning
css_set.  Tasks on the migration list are treated the same as tasks on
the usual tasks list; however, being on a separate list allows cgroup
migration code path to keep track of the target tasks by simply
keeping the list of css_sets with tasks being migrated, making
unpredictable dynamic allocation unnecessary.

In prepartion of such migration path update, this patch introduces
css_set->mg_tasks list and updates css_set task iterations so that
they walk both css_set->tasks and ->mg_tasks.  Note that ->mg_tasks
isn't used yet.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  8 ++++++--
 kernel/cgroup.c        | 56 +++++++++++++++++++++++++++++++++-----------------
 2 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ef0b3af..3238abd 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -324,10 +324,14 @@ struct css_set {
 	struct hlist_node hlist;
 
 	/*
-	 * List running through all tasks using this cgroup
-	 * group. Protected by css_set_lock
+	 * Lists running through all tasks using this cgroup group.
+	 * mg_tasks lists tasks which belong to this cset but are in the
+	 * process of being migrated out or in.  Protected by
+	 * css_set_rwsem, but, during migration, once tasks are moved to
+	 * mg_tasks, it can be read safely while holding cgroup_mutex.
 	 */
 	struct list_head tasks;
+	struct list_head mg_tasks;
 
 	/*
 	 * List of cgrp_cset_links pointing at cgroups referenced from this
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 330f24a..c423bac 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -644,6 +644,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	atomic_set(&cset->refcount, 1);
 	INIT_LIST_HEAD(&cset->cgrp_links);
 	INIT_LIST_HEAD(&cset->tasks);
+	INIT_LIST_HEAD(&cset->mg_tasks);
 	INIT_HLIST_NODE(&cset->hlist);
 
 	/* Copy the set of subsystem state objects generated in
@@ -2587,9 +2588,14 @@ static void css_advance_task_iter(struct css_task_iter *it)
 		}
 		link = list_entry(l, struct cgrp_cset_link, cset_link);
 		cset = link->cset;
-	} while (list_empty(&cset->tasks));
+	} while (list_empty(&cset->tasks) && list_empty(&cset->mg_tasks));
+
 	it->cset_link = l;
-	it->task = cset->tasks.next;
+
+	if (!list_empty(&cset->tasks))
+		it->task = cset->tasks.next;
+	else
+		it->task = cset->mg_tasks.next;
 }
 
 /**
@@ -2633,24 +2639,29 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
 {
 	struct task_struct *res;
 	struct list_head *l = it->task;
-	struct cgrp_cset_link *link;
+	struct cgrp_cset_link *link = list_entry(it->cset_link,
+					struct cgrp_cset_link, cset_link);
 
 	/* If the iterator cg is NULL, we have no tasks */
 	if (!it->cset_link)
 		return NULL;
 	res = list_entry(l, struct task_struct, cg_list);
-	/* Advance iterator to find next entry */
+
+	/*
+	 * Advance iterator to find next entry.  cset->tasks is consumed
+	 * first and then ->mg_tasks.  After ->mg_tasks, we move onto the
+	 * next cset.
+	 */
 	l = l->next;
-	link = list_entry(it->cset_link, struct cgrp_cset_link, cset_link);
-	if (l == &link->cset->tasks) {
-		/*
-		 * We reached the end of this task list - move on to the
-		 * next cgrp_cset_link.
-		 */
+
+	if (l == &link->cset->tasks)
+		l = link->cset->mg_tasks.next;
+
+	if (l == &link->cset->mg_tasks)
 		css_advance_task_iter(it);
-	} else {
+	else
 		it->task = l;
-	}
+
 	return res;
 }
 
@@ -4499,16 +4510,23 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 		struct css_set *cset = link->cset;
 		struct task_struct *task;
 		int count = 0;
+
 		seq_printf(seq, "css_set %p\n", cset);
+
 		list_for_each_entry(task, &cset->tasks, cg_list) {
-			if (count++ > MAX_TASKS_SHOWN_PER_CSS) {
-				seq_puts(seq, "  ...\n");
-				break;
-			} else {
-				seq_printf(seq, "  task %d\n",
-					   task_pid_vnr(task));
-			}
+			if (count++ > MAX_TASKS_SHOWN_PER_CSS)
+				goto overflow;
+			seq_printf(seq, "  task %d\n", task_pid_vnr(task));
+		}
+
+		list_for_each_entry(task, &cset->mg_tasks, cg_list) {
+			if (count++ > MAX_TASKS_SHOWN_PER_CSS)
+				goto overflow;
+			seq_printf(seq, "  task %d\n", task_pid_vnr(task));
 		}
+		continue;
+	overflow:
+		seq_puts(seq, "  ...\n");
 	}
 	up_read(&css_set_rwsem);
 	return 0;
-- 
1.8.5.3

