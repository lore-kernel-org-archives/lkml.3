Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaIJO3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:29:13 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:43105 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaIJO3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:29:04 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, bfields@fieldses.org
Subject: [RFC PATCH 04/12] locks: move flock locks to file_lock_context
Date: Wed, 10 Sep 2014 10:28:42 -0400
Message-Id: <1410359330-27564-5-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 fs/locks.c | 63 +++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 23 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 5e8b865814a2..7f8c2c68a769 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -242,6 +242,7 @@ locks_free_lock_context(struct file_lock_context *ctx)
 static void locks_init_lock_heads(struct file_lock *fl)
 {
 	INIT_HLIST_NODE(&fl->fl_link);
+	INIT_LIST_HEAD(&fl->fl_list);
 	INIT_LIST_HEAD(&fl->fl_block);
 	init_waitqueue_head(&fl->fl_wait);
 }
@@ -278,6 +279,7 @@ EXPORT_SYMBOL_GPL(locks_release_private);
 void locks_free_lock(struct file_lock *fl)
 {
 	BUG_ON(waitqueue_active(&fl->fl_wait));
+	BUG_ON(!list_empty(&fl->fl_list));
 	BUG_ON(!list_empty(&fl->fl_block));
 	BUG_ON(!hlist_unhashed(&fl->fl_link));
 
@@ -686,6 +688,14 @@ static void locks_insert_lock(struct file_lock **pos, struct file_lock *fl)
 	locks_insert_global_locks(fl);
 }
 
+static void
+locks_insert_lock_ctx(struct file_lock *fl, struct list_head *after)
+{
+	fl->fl_nspid = get_pid(task_tgid(current));
+	list_add(&fl->fl_list, after);
+	locks_insert_global_locks(fl);
+}
+
 /**
  * locks_delete_lock - Delete a lock and then free it.
  * @thisfl_p: pointer that points to the fl_next field of the previous
@@ -731,6 +741,18 @@ static void locks_delete_lock(struct file_lock **thisfl_p,
 		locks_free_lock(fl);
 }
 
+static void
+locks_delete_lock_ctx(struct file_lock *fl, struct list_head *dispose)
+{
+	locks_delete_global_locks(fl);
+	if (fl->fl_nspid) {
+		put_pid(fl->fl_nspid);
+		fl->fl_nspid = NULL;
+	}
+	locks_wake_up_blocks(fl);
+	list_move(&fl->fl_list, dispose);
+}
+
 /* Determine if lock sys_fl blocks lock caller_fl. Common functionality
  * checks for shared/exclusive status of overlapping locks.
  */
@@ -880,34 +902,34 @@ static int posix_locks_deadlock(struct file_lock *caller_fl,
 static int flock_lock_file(struct file *filp, struct file_lock *request)
 {
 	struct file_lock *new_fl = NULL;
-	struct file_lock **before;
-	struct inode * inode = file_inode(filp);
+	struct file_lock *fl;
+	struct file_lock_context *ctx;
+	struct inode *inode = file_inode(filp);
 	int error = 0;
-	int found = 0;
+	bool found = false;
 	LIST_HEAD(dispose);
 
+	ctx = locks_get_lock_context(inode);
+	if (!ctx)
+		return -ENOMEM;
+
 	if (!(request->fl_flags & FL_ACCESS) && (request->fl_type != F_UNLCK)) {
 		new_fl = locks_alloc_lock();
 		if (!new_fl)
 			return -ENOMEM;
 	}
 
-	spin_lock(&inode->i_lock);
+	spin_lock(&ctx->flc_lock);
 	if (request->fl_flags & FL_ACCESS)
 		goto find_conflict;
 
-	for_each_lock(inode, before) {
-		struct file_lock *fl = *before;
-		if (IS_POSIX(fl))
-			break;
-		if (IS_LEASE(fl))
-			continue;
+	list_for_each_entry(fl, &ctx->flc_flock, fl_list) {
 		if (filp != fl->fl_file)
 			continue;
 		if (request->fl_type == fl->fl_type)
 			goto out;
-		found = 1;
-		locks_delete_lock(before, &dispose);
+		found = true;
+		locks_delete_lock_ctx(fl, &dispose);
 		break;
 	}
 
@@ -922,18 +944,13 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
 	 * give it the opportunity to lock the file.
 	 */
 	if (found) {
-		spin_unlock(&inode->i_lock);
+		spin_unlock(&ctx->flc_lock);
 		cond_resched();
-		spin_lock(&inode->i_lock);
+		spin_lock(&ctx->flc_lock);
 	}
 
 find_conflict:
-	for_each_lock(inode, before) {
-		struct file_lock *fl = *before;
-		if (IS_POSIX(fl))
-			break;
-		if (IS_LEASE(fl))
-			continue;
+	list_for_each_entry(fl, &ctx->flc_flock, fl_list) {
 		if (!flock_locks_conflict(request, fl))
 			continue;
 		error = -EAGAIN;
@@ -946,12 +963,12 @@ find_conflict:
 	if (request->fl_flags & FL_ACCESS)
 		goto out;
 	locks_copy_lock(new_fl, request);
-	locks_insert_lock(before, new_fl);
+	locks_insert_lock_ctx(new_fl, &ctx->flc_flock);
 	new_fl = NULL;
 	error = 0;
 
 out:
-	spin_unlock(&inode->i_lock);
+	spin_unlock(&ctx->flc_lock);
 	if (new_fl)
 		locks_free_lock(new_fl);
 	locks_dispose_list(&dispose);
@@ -2405,7 +2422,7 @@ locks_remove_flock(struct file *filp)
 		.fl_end = OFFSET_MAX,
 	};
 
-	if (!file_inode(filp)->i_flock)
+	if (!file_inode(filp)->i_flctx)
 		return;
 
 	if (filp->f_op->flock)
-- 
1.9.3

