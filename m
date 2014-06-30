Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaF3L4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:56:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754073AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Joel Becker <jlbec@evilplan.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 034/181] ocfs2: avoid blocking in ocfs2_mark_lockres_freeing() in downconvert thread
Date: Mon, 30 Jun 2014 13:50:55 +0200
Message-Id: <8f265718385a7aa2d396a5d8ac614cb80ff7d9a1.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 84d86f83f9d0e8431a3c9eae4c47e9d7ff49a411 upstream.

If we are dropping last inode reference from downconvert thread, we will
end up calling ocfs2_mark_lockres_freeing() which can block if the lock
we are freeing is queued thus creating an A-A deadlock.  Luckily, since
we are the downconvert thread, we can immediately dequeue the lock and
thus avoid waiting in this case.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ocfs2/dlmglue.c | 44 +++++++++++++++++++++++++++++++++++++++++---
 fs/ocfs2/dlmglue.h |  3 ++-
 fs/ocfs2/inode.c   |  7 ++++---
 3 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 3a44a648dae7..3988d0aeb72c 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3142,22 +3142,60 @@ out:
 	return 0;
 }
 
+static void ocfs2_process_blocked_lock(struct ocfs2_super *osb,
+				       struct ocfs2_lock_res *lockres);
+
 /* Mark the lockres as being dropped. It will no longer be
  * queued if blocking, but we still may have to wait on it
  * being dequeued from the downconvert thread before we can consider
  * it safe to drop.
  *
  * You can *not* attempt to call cluster_lock on this lockres anymore. */
-void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres)
+void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
+				struct ocfs2_lock_res *lockres)
 {
 	int status;
 	struct ocfs2_mask_waiter mw;
-	unsigned long flags;
+	unsigned long flags, flags2;
 
 	ocfs2_init_mask_waiter(&mw);
 
 	spin_lock_irqsave(&lockres->l_lock, flags);
 	lockres->l_flags |= OCFS2_LOCK_FREEING;
+	if (lockres->l_flags & OCFS2_LOCK_QUEUED && current == osb->dc_task) {
+		/*
+		 * We know the downconvert is queued but not in progress
+		 * because we are the downconvert thread and processing
+		 * different lock. So we can just remove the lock from the
+		 * queue. This is not only an optimization but also a way
+		 * to avoid the following deadlock:
+		 *   ocfs2_dentry_post_unlock()
+		 *     ocfs2_dentry_lock_put()
+		 *       ocfs2_drop_dentry_lock()
+		 *         iput()
+		 *           ocfs2_evict_inode()
+		 *             ocfs2_clear_inode()
+		 *               ocfs2_mark_lockres_freeing()
+		 *                 ... blocks waiting for OCFS2_LOCK_QUEUED
+		 *                 since we are the downconvert thread which
+		 *                 should clear the flag.
+		 */
+		spin_unlock_irqrestore(&lockres->l_lock, flags);
+		spin_lock_irqsave(&osb->dc_task_lock, flags2);
+		list_del_init(&lockres->l_blocked_list);
+		osb->blocked_lock_count--;
+		spin_unlock_irqrestore(&osb->dc_task_lock, flags2);
+		/*
+		 * Warn if we recurse into another post_unlock call.  Strictly
+		 * speaking it isn't a problem but we need to be careful if
+		 * that happens (stack overflow, deadlocks, ...) so warn if
+		 * ocfs2 grows a path for which this can happen.
+		 */
+		WARN_ON_ONCE(lockres->l_ops->post_unlock);
+		/* Since the lock is freeing we don't do much in the fn below */
+		ocfs2_process_blocked_lock(osb, lockres);
+		return;
+	}
 	while (lockres->l_flags & OCFS2_LOCK_QUEUED) {
 		lockres_add_mask_waiter(lockres, &mw, OCFS2_LOCK_QUEUED, 0);
 		spin_unlock_irqrestore(&lockres->l_lock, flags);
@@ -3178,7 +3216,7 @@ void ocfs2_simple_drop_lockres(struct ocfs2_super *osb,
 {
 	int ret;
 
-	ocfs2_mark_lockres_freeing(lockres);
+	ocfs2_mark_lockres_freeing(osb, lockres);
 	ret = ocfs2_drop_lock(osb, lockres);
 	if (ret)
 		mlog_errno(ret);
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index 1d596d8c4a4a..d293a22c32c5 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -157,7 +157,8 @@ int ocfs2_refcount_lock(struct ocfs2_refcount_tree *ref_tree, int ex);
 void ocfs2_refcount_unlock(struct ocfs2_refcount_tree *ref_tree, int ex);
 
 
-void ocfs2_mark_lockres_freeing(struct ocfs2_lock_res *lockres);
+void ocfs2_mark_lockres_freeing(struct ocfs2_super *osb,
+				struct ocfs2_lock_res *lockres);
 void ocfs2_simple_drop_lockres(struct ocfs2_super *osb,
 			       struct ocfs2_lock_res *lockres);
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 059fa362f4c0..e37a59a28644 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1069,6 +1069,7 @@ static void ocfs2_clear_inode(struct inode *inode)
 {
 	int status;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 
 	clear_inode(inode);
 	trace_ocfs2_clear_inode((unsigned long long)oi->ip_blkno,
@@ -1085,9 +1086,9 @@ static void ocfs2_clear_inode(struct inode *inode)
 
 	/* Do these before all the other work so that we don't bounce
 	 * the downconvert thread while waiting to destroy the locks. */
-	ocfs2_mark_lockres_freeing(&oi->ip_rw_lockres);
-	ocfs2_mark_lockres_freeing(&oi->ip_inode_lockres);
-	ocfs2_mark_lockres_freeing(&oi->ip_open_lockres);
+	ocfs2_mark_lockres_freeing(osb, &oi->ip_rw_lockres);
+	ocfs2_mark_lockres_freeing(osb, &oi->ip_inode_lockres);
+	ocfs2_mark_lockres_freeing(osb, &oi->ip_open_lockres);
 
 	ocfs2_resv_discard(&OCFS2_SB(inode->i_sb)->osb_la_resmap,
 			   &oi->ip_la_data_resv);
-- 
2.0.0

