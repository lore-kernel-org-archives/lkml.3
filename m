Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaA1XZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:25:20 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:36157 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbaA1XV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:21:58 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/11] kernfs: replace kernfs_node->u.completion with kernfs_root->deactivate_waitq
Date: Tue, 28 Jan 2014 18:21:41 -0500
Message-Id: <1390951311-15325-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951311-15325-1-git-send-email-tj@kernel.org>
References: <1390951311-15325-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_node->u.completion is used to notify deactivation completion
from kernfs_put_active() to kernfs_deactivate().  We now allow
multiple racing removals of the same node and the current removal
scheme is no longer correct - kernfs_remove() invocation may return
before the node is properly deactivated if it races against another
removal.  The removal path will be restructured to address the issue.

To help such restructure which requires supporting multiple waiters,
this patch replaces kernfs_node->u.completion with
kernfs_root->deactivate_waitq.  This makes deactivation event
notifications share a per-root waitqueue_head; however, the wait path
is quite cold and this will also allow shaving one pointer off
kernfs_node.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c        | 27 +++++++++++----------------
 include/linux/kernfs.h |  4 ++--
 2 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 5104cf5..9b00ebb 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -8,6 +8,7 @@
  * This file is released under the GPLv2.
  */
 
+#include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/idr.h>
@@ -151,6 +152,7 @@ struct kernfs_node *kernfs_get_active(struct kernfs_node *kn)
  */
 void kernfs_put_active(struct kernfs_node *kn)
 {
+	struct kernfs_root *root = kernfs_root(kn);
 	int v;
 
 	if (unlikely(!kn))
@@ -162,11 +164,7 @@ void kernfs_put_active(struct kernfs_node *kn)
 	if (likely(v != KN_DEACTIVATED_BIAS))
 		return;
 
-	/*
-	 * atomic_dec_return() is a mb(), we'll always see the updated
-	 * kn->u.completion.
-	 */
-	complete(kn->u.completion);
+	wake_up_all(&root->deactivate_waitq);
 }
 
 /**
@@ -177,26 +175,22 @@ void kernfs_put_active(struct kernfs_node *kn)
  */
 static void kernfs_deactivate(struct kernfs_node *kn)
 {
-	DECLARE_COMPLETION_ONSTACK(wait);
-	int v;
+	struct kernfs_root *root = kernfs_root(kn);
 
 	BUG_ON(!(kn->flags & KERNFS_REMOVED));
 
 	if (!(kernfs_type(kn) & KERNFS_ACTIVE_REF))
 		return;
 
-	kn->u.completion = (void *)&wait;
-
 	rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
-	/* atomic_add_return() is a mb(), put_active() will always see
-	 * the updated kn->u.completion.
-	 */
-	v = atomic_add_return(KN_DEACTIVATED_BIAS, &kn->active);
 
-	if (v != KN_DEACTIVATED_BIAS) {
+	atomic_add(KN_DEACTIVATED_BIAS, &kn->active);
+
+	if (atomic_read(&kn->active) != KN_DEACTIVATED_BIAS)
 		lock_contended(&kn->dep_map, _RET_IP_);
-		wait_for_completion(&wait);
-	}
+
+	wait_event(root->deactivate_waitq,
+		   atomic_read(&kn->active) == KN_DEACTIVATED_BIAS);
 
 	lock_acquired(&kn->dep_map, _RET_IP_);
 	rwsem_release(&kn->dep_map, 1, _RET_IP_);
@@ -626,6 +620,7 @@ struct kernfs_root *kernfs_create_root(struct kernfs_dir_ops *kdops, void *priv)
 
 	root->dir_ops = kdops;
 	root->kn = kn;
+	init_waitqueue_head(&root->deactivate_waitq);
 
 	return root;
 }
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 5be9f02..295a3bf 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -15,7 +15,7 @@
 #include <linux/lockdep.h>
 #include <linux/rbtree.h>
 #include <linux/atomic.h>
-#include <linux/completion.h>
+#include <linux/wait.h>
 
 struct file;
 struct dentry;
@@ -92,7 +92,6 @@ struct kernfs_node {
 	struct rb_node		rb;
 
 	union {
-		struct completion	*completion;
 		struct kernfs_node	*removed_list;
 	} u;
 
@@ -133,6 +132,7 @@ struct kernfs_root {
 	/* private fields, do not use outside kernfs proper */
 	struct ida		ino_ida;
 	struct kernfs_dir_ops	*dir_ops;
+	wait_queue_head_t	deactivate_waitq;
 };
 
 struct kernfs_open_file {
-- 
1.8.5.3

