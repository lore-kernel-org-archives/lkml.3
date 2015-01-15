Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbbAOM3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:29:39 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56881 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbbAOM3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:29:35 -0500
From: Imre Palik <imrep.amz@gmail.com>
To: linux-audit@redhat.com, Paul Moore <paul@paul-moore.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        "Palik, Imre" <imrep@amazon.de>, Matt Wilson <msw@amazon.com>
Subject: [RFC PATCH v3] audit: move the tree pruning to a dedicated thread
Date: Thu, 15 Jan 2015 13:27:50 +0100
Message-Id: <1421324870-15070-1-git-send-email-imrep.amz@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Palik, Imre" <imrep@amazon.de>

When file auditing is enabled, during a low memory situation, a memory
allocation with __GFP_FS can lead to pruning the inode cache.  Which can,
in turn lead to audit_tree_freeing_mark() being called.  This can call
audit_schedule_prune(), that tries to fork a pruning thread, and
waits until the thread is created.  But forking needs memory, and the
memory allocations there are done with __GFP_FS.

So we are waiting merrily for some __GFP_FS memory allocations to complete,
while holding some filesystem locks.  This can take a while ...

This patch creates a single thread for pruning the tree from
audit_add_tree_rule(), and thus avoids the deadlock that the on-demand
thread creation can cause.

Reported-by: Matt Wilson <msw@amazon.com>
Cc: Matt Wilson <msw@amazon.com>
Signed-off-by: Imre Palik <imrep@amazon.de>
---
 kernel/audit_tree.c |   86 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 58 insertions(+), 28 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 2e0c974..4883b6e 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -37,6 +37,7 @@ struct audit_chunk {
 
 static LIST_HEAD(tree_list);
 static LIST_HEAD(prune_list);
+static struct task_struct *prune_thread;
 
 /*
  * One struct chunk is attached to each inode of interest.
@@ -651,6 +652,55 @@ static int tag_mount(struct vfsmount *mnt, void *arg)
 	return tag_chunk(mnt->mnt_root->d_inode, arg);
 }
 
+/*
+ * That gets run when evict_chunk() ends up needing to kill audit_tree.
+ * Runs from a separate thread.
+ */
+static int prune_tree_thread(void *unused)
+{
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (list_empty(&prune_list))
+			schedule();
+		__set_current_state(TASK_RUNNING);
+
+		mutex_lock(&audit_cmd_mutex);
+		mutex_lock(&audit_filter_mutex);
+
+		while (!list_empty(&prune_list)) {
+			struct audit_tree *victim;
+
+			victim = list_entry(prune_list.next,
+					struct audit_tree, list);
+			list_del_init(&victim->list);
+
+			mutex_unlock(&audit_filter_mutex);
+
+			prune_one(victim);
+
+			mutex_lock(&audit_filter_mutex);
+		}
+
+		mutex_unlock(&audit_filter_mutex);
+		mutex_unlock(&audit_cmd_mutex);
+	}
+	return 0;
+}
+
+static int launch_prune_thread(void)
+{
+	prune_thread = kthread_create(prune_tree_thread, NULL,
+				"audit_prune_tree");
+	if (IS_ERR(prune_thread)) {
+		pr_err("cannot start thread audit_prune_tree");
+		prune_thread = NULL;
+		return -ENOMEM;
+	} else {
+		wake_up_process(prune_thread);
+		return 0;
+	}
+}
+
 /* called with audit_filter_mutex */
 int audit_add_tree_rule(struct audit_krule *rule)
 {
@@ -674,6 +724,12 @@ int audit_add_tree_rule(struct audit_krule *rule)
 	/* do not set rule->tree yet */
 	mutex_unlock(&audit_filter_mutex);
 
+	if (unlikely(!prune_thread)) {
+		err = launch_prune_thread();
+		if (err)
+			goto Err;
+	}
+
 	err = kern_path(tree->pathname, 0, &path);
 	if (err)
 		goto Err;
@@ -811,36 +867,10 @@ int audit_tag_tree(char *old, char *new)
 	return failed;
 }
 
-/*
- * That gets run when evict_chunk() ends up needing to kill audit_tree.
- * Runs from a separate thread.
- */
-static int prune_tree_thread(void *unused)
-{
-	mutex_lock(&audit_cmd_mutex);
-	mutex_lock(&audit_filter_mutex);
-
-	while (!list_empty(&prune_list)) {
-		struct audit_tree *victim;
-
-		victim = list_entry(prune_list.next, struct audit_tree, list);
-		list_del_init(&victim->list);
-
-		mutex_unlock(&audit_filter_mutex);
-
-		prune_one(victim);
-
-		mutex_lock(&audit_filter_mutex);
-	}
-
-	mutex_unlock(&audit_filter_mutex);
-	mutex_unlock(&audit_cmd_mutex);
-	return 0;
-}
 
 static void audit_schedule_prune(void)
 {
-	kthread_run(prune_tree_thread, NULL, "audit_prune_tree");
+	wake_up_process(prune_thread);
 }
 
 /*
@@ -907,9 +937,9 @@ static void evict_chunk(struct audit_chunk *chunk)
 	for (n = 0; n < chunk->count; n++)
 		list_del_init(&chunk->owners[n].list);
 	spin_unlock(&hash_lock);
+	mutex_unlock(&audit_filter_mutex);
 	if (need_prune)
 		audit_schedule_prune();
-	mutex_unlock(&audit_filter_mutex);
 }
 
 static int audit_tree_handle_event(struct fsnotify_group *group,
-- 
1.7.9.5

