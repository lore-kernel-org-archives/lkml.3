Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaLDLjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:39:42 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61692 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaLDLjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:39:40 -0500
From: Imre Palik <imrep.amz@gmail.com>
To: linux-audit@redhat.com
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        "Palik, Imre" <imrep@amazon.de>, Matt Wilson <msw@amazon.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH RFC] audit: move the tree pruning to a dedicated thread
Date: Thu,  4 Dec 2014 12:39:21 +0100
Message-Id: <1417693161-11132-1-git-send-email-imrep.amz@gmail.com>
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
audit_tree_init(), and thus avoids the deadlock that the on-demand thread
creation can cause.

An alternative approach would be to move the thread creation outside of the
lock.  This would assume that other layers of the filesystem code don't
hold any locks, and it would need some rewrite of the code to limit the
amount of threads possibly spawned.

Reported-by: Matt Wilson <msw@amazon.com>
Cc: Matt Wilson <msw@amazon.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Imre Palik <imrep@amazon.de>
---
 kernel/audit_tree.c |   53 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 0caf1f8..cf6db88 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -37,6 +37,7 @@ struct audit_chunk {
 
 static LIST_HEAD(tree_list);
 static LIST_HEAD(prune_list);
+static struct task_struct *prune_thread;
 
 /*
  * One struct chunk is attached to each inode of interest.
@@ -806,30 +807,39 @@ int audit_tag_tree(char *old, char *new)
  */
 static int prune_tree_thread(void *unused)
 {
-	mutex_lock(&audit_cmd_mutex);
-	mutex_lock(&audit_filter_mutex);
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (list_empty(&prune_list))
+			schedule();
+		__set_current_state(TASK_RUNNING);
 
-	while (!list_empty(&prune_list)) {
-		struct audit_tree *victim;
+		mutex_lock(&audit_cmd_mutex);
+		mutex_lock(&audit_filter_mutex);
 
-		victim = list_entry(prune_list.next, struct audit_tree, list);
-		list_del_init(&victim->list);
+		while (!list_empty(&prune_list)) {
+			struct audit_tree *victim;
 
-		mutex_unlock(&audit_filter_mutex);
+			victim = list_entry(prune_list.next,
+					struct audit_tree, list);
+			list_del_init(&victim->list);
 
-		prune_one(victim);
+			mutex_unlock(&audit_filter_mutex);
 
-		mutex_lock(&audit_filter_mutex);
-	}
+			prune_one(victim);
 
-	mutex_unlock(&audit_filter_mutex);
-	mutex_unlock(&audit_cmd_mutex);
+			mutex_lock(&audit_filter_mutex);
+		}
+
+		mutex_unlock(&audit_filter_mutex);
+		mutex_unlock(&audit_cmd_mutex);
+	}
 	return 0;
 }
 
 static void audit_schedule_prune(void)
 {
-	kthread_run(prune_tree_thread, NULL, "audit_prune_tree");
+	BUG_ON(!prune_thread);
+	wake_up_process(prune_thread);
 }
 
 /*
@@ -896,9 +906,10 @@ static void evict_chunk(struct audit_chunk *chunk)
 	for (n = 0; n < chunk->count; n++)
 		list_del_init(&chunk->owners[n].list);
 	spin_unlock(&hash_lock);
+	mutex_unlock(&audit_filter_mutex);
 	if (need_prune)
 		audit_schedule_prune();
-	mutex_unlock(&audit_filter_mutex);
+
 }
 
 static int audit_tree_handle_event(struct fsnotify_group *group,
@@ -938,10 +949,16 @@ static int __init audit_tree_init(void)
 {
 	int i;
 
-	audit_tree_group = fsnotify_alloc_group(&audit_tree_ops);
-	if (IS_ERR(audit_tree_group))
-		audit_panic("cannot initialize fsnotify group for rectree watches");
-
+	prune_thread = kthread_create(prune_tree_thread, NULL,
+				"audit_prune_tree");
+	if (IS_ERR(prune_thread)) {
+		audit_panic("cannot start thread audit_prune_tree");
+	} else {
+		wake_up_process(prune_thread);
+		audit_tree_group = fsnotify_alloc_group(&audit_tree_ops);
+		if (IS_ERR(audit_tree_group))
+			audit_panic("cannot initialize fsnotify group for rectree watches");
+	}
 	for (i = 0; i < HASH_SIZE; i++)
 		INIT_LIST_HEAD(&chunk_hash_heads[i]);
 
-- 
1.7.9.5

