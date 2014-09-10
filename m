Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaIJO3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:29:10 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:57070 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaIJO3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:29:05 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, bfields@fieldses.org
Subject: [RFC PATCH 05/12] locks: convert posix locks to file_lock_context
Date: Wed, 10 Sep 2014 10:28:43 -0400
Message-Id: <1410359330-27564-6-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 fs/locks.c         | 119 ++++++++++++++++++++++++++++-------------------------
 fs/read_write.c    |   2 +-
 include/linux/fs.h |   3 +-
 3 files changed, 65 insertions(+), 59 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 7f8c2c68a769..750813e708c8 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -157,9 +157,6 @@ static int target_leasetype(struct file_lock *fl)
 int leases_enable = 1;
 int lease_break_time = 45;
 
-#define for_each_lock(inode, lockp) \
-	for (lockp = &inode->i_flock; *lockp != NULL; lockp = &(*lockp)->fl_next)
-
 /*
  * The global file_lock_list is only used for displaying /proc/locks, so we
  * keep a list on each CPU, with each list protected by its own spinlock via
@@ -221,6 +218,7 @@ locks_get_lock_context(struct inode *inode)
 	if (likely(!inode->i_flctx)) {
 		spin_lock_init(&new->flc_lock);
 		INIT_LIST_HEAD(&new->flc_flock);
+		INIT_LIST_HEAD(&new->flc_posix);
 		swap(inode->i_flctx, new);
 	}
 	spin_unlock(&inode->i_lock);
@@ -235,6 +233,7 @@ locks_free_lock_context(struct file_lock_context *ctx)
 {
 	if (ctx) {
 		WARN_ON_ONCE(!list_empty(&ctx->flc_flock));
+		WARN_ON_ONCE(!list_empty(&ctx->flc_posix));
 		kmem_cache_free(flctx_cache, ctx);
 	}
 }
@@ -803,22 +802,27 @@ void
 posix_test_lock(struct file *filp, struct file_lock *fl)
 {
 	struct file_lock *cfl;
+	struct file_lock_context *ctx;
 	struct inode *inode = file_inode(filp);
 
-	spin_lock(&inode->i_lock);
-	for (cfl = file_inode(filp)->i_flock; cfl; cfl = cfl->fl_next) {
-		if (!IS_POSIX(cfl))
-			continue;
-		if (posix_locks_conflict(fl, cfl))
-			break;
-	}
-	if (cfl) {
-		locks_copy_conflock(fl, cfl);
-		if (cfl->fl_nspid)
-			fl->fl_pid = pid_vnr(cfl->fl_nspid);
-	} else
+	ctx = inode->i_flctx;
+	if (!ctx) {
 		fl->fl_type = F_UNLCK;
-	spin_unlock(&inode->i_lock);
+		return;
+	}
+
+	spin_lock(&ctx->flc_lock);
+	list_for_each_entry(cfl, &ctx->flc_posix, fl_list) {
+		if (posix_locks_conflict(fl, cfl)) {
+			locks_copy_conflock(fl, cfl);
+			if (cfl->fl_nspid)
+				fl->fl_pid = pid_vnr(cfl->fl_nspid);
+			goto out;
+		}
+	}
+	fl->fl_type = F_UNLCK;
+out:
+	spin_unlock(&ctx->flc_lock);
 	return;
 }
 EXPORT_SYMBOL(posix_test_lock);
@@ -977,16 +981,20 @@ out:
 
 static int __posix_lock_file(struct inode *inode, struct file_lock *request, struct file_lock *conflock)
 {
-	struct file_lock *fl;
+	struct file_lock *fl, *tmp;
 	struct file_lock *new_fl = NULL;
 	struct file_lock *new_fl2 = NULL;
 	struct file_lock *left = NULL;
 	struct file_lock *right = NULL;
-	struct file_lock **before;
+	struct file_lock_context *ctx;
 	int error;
 	bool added = false;
 	LIST_HEAD(dispose);
 
+	ctx = locks_get_lock_context(inode);
+	if (!ctx)
+		return -ENOMEM;
+
 	/*
 	 * We may need two file_lock structures for this operation,
 	 * so we get them in advance to avoid races.
@@ -1000,15 +1008,14 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 		new_fl2 = locks_alloc_lock();
 	}
 
-	spin_lock(&inode->i_lock);
+	spin_lock(&ctx->flc_lock);
 	/*
 	 * New lock request. Walk all POSIX locks and look for conflicts. If
 	 * there are any, either return error or put the request on the
 	 * blocker's list of waiters and the global blocked_hash.
 	 */
 	if (request->fl_type != F_UNLCK) {
-		for_each_lock(inode, before) {
-			fl = *before;
+		list_for_each_entry(fl, &ctx->flc_posix, fl_list) {
 			if (!IS_POSIX(fl))
 				continue;
 			if (!posix_locks_conflict(request, fl))
@@ -1038,29 +1045,25 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 	if (request->fl_flags & FL_ACCESS)
 		goto out;
 
-	/*
-	 * Find the first old lock with the same owner as the new lock.
-	 */
-	
-	before = &inode->i_flock;
-
-	/* First skip locks owned by other processes.  */
-	while ((fl = *before) && (!IS_POSIX(fl) ||
-				  !posix_same_owner(request, fl))) {
-		before = &fl->fl_next;
+	/* Find the first old lock with the same owner as the new lock */
+	list_for_each_entry(fl, &ctx->flc_posix, fl_list) {
+		if (posix_same_owner(request, fl))
+			break;
 	}
 
 	/* Process locks with this owner. */
-	while ((fl = *before) && posix_same_owner(request, fl)) {
-		/* Detect adjacent or overlapping regions (if same lock type)
-		 */
+	list_for_each_entry_safe_from(fl, tmp, &ctx->flc_posix, fl_list) {
+		if (!posix_same_owner(request, fl))
+			break;
+
+		/* Detect adjacent or overlapping regions (if same lock type) */
 		if (request->fl_type == fl->fl_type) {
 			/* In all comparisons of start vs end, use
 			 * "start - 1" rather than "end + 1". If end
 			 * is OFFSET_MAX, end + 1 will become negative.
 			 */
 			if (fl->fl_end < request->fl_start - 1)
-				goto next_lock;
+				continue;
 			/* If the next lock in the list has entirely bigger
 			 * addresses than the new one, insert the lock here.
 			 */
@@ -1081,18 +1084,17 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 			else
 				request->fl_end = fl->fl_end;
 			if (added) {
-				locks_delete_lock(before, &dispose);
+				locks_delete_lock_ctx(fl, &dispose);
 				continue;
 			}
 			request = fl;
 			added = true;
-		}
-		else {
+		} else {
 			/* Processing for different lock types is a bit
 			 * more complex.
 			 */
 			if (fl->fl_end < request->fl_start)
-				goto next_lock;
+				continue;
 			if (fl->fl_start > request->fl_end)
 				break;
 			if (request->fl_type == F_UNLCK)
@@ -1111,7 +1113,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 				 * one (This may happen several times).
 				 */
 				if (added) {
-					locks_delete_lock(before, &dispose);
+					locks_delete_lock_ctx(fl, &dispose);
 					continue;
 				}
 				/*
@@ -1127,15 +1129,11 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 				locks_copy_lock(new_fl, request);
 				request = new_fl;
 				new_fl = NULL;
-				locks_delete_lock(before, &dispose);
-				locks_insert_lock(before, request);
+				locks_insert_lock_ctx(request, &fl->fl_list);
+				locks_delete_lock_ctx(fl, &dispose);
 				added = true;
 			}
 		}
-		/* Go on to next lock.
-		 */
-	next_lock:
-		before = &fl->fl_next;
 	}
 
 	/*
@@ -1160,7 +1158,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 			goto out;
 		}
 		locks_copy_lock(new_fl, request);
-		locks_insert_lock(before, new_fl);
+		locks_insert_lock_ctx(new_fl, &fl->fl_list);
 		new_fl = NULL;
 	}
 	if (right) {
@@ -1171,7 +1169,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 			left = new_fl2;
 			new_fl2 = NULL;
 			locks_copy_lock(left, right);
-			locks_insert_lock(before, left);
+			locks_insert_lock_ctx(left, &fl->fl_list);
 		}
 		right->fl_start = request->fl_end + 1;
 		locks_wake_up_blocks(right);
@@ -1181,7 +1179,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 		locks_wake_up_blocks(left);
 	}
  out:
-	spin_unlock(&inode->i_lock);
+	spin_unlock(&ctx->flc_lock);
 	/*
 	 * Free any unused locks.
 	 */
@@ -1251,22 +1249,29 @@ EXPORT_SYMBOL(posix_lock_file_wait);
  */
 int locks_mandatory_locked(struct file *file)
 {
+	int ret;
 	struct inode *inode = file_inode(file);
+	struct file_lock_context *ctx;
 	struct file_lock *fl;
 
+	ctx = inode->i_flctx;
+	if (!ctx)
+		return 0;
+
 	/*
 	 * Search the lock list for this inode for any POSIX locks.
 	 */
-	spin_lock(&inode->i_lock);
-	for (fl = inode->i_flock; fl != NULL; fl = fl->fl_next) {
-		if (!IS_POSIX(fl))
-			continue;
+	spin_lock(&ctx->flc_lock);
+	ret = 0;
+	list_for_each_entry(fl, &ctx->flc_posix, fl_list) {
 		if (fl->fl_owner != current->files &&
-		    fl->fl_owner != file)
+		    fl->fl_owner != file) {
+			ret = -EAGAIN;
 			break;
+		}
 	}
-	spin_unlock(&inode->i_lock);
-	return fl ? -EAGAIN : 0;
+	spin_unlock(&ctx->flc_lock);
+	return ret;
 }
 
 /**
@@ -2389,7 +2394,7 @@ void locks_remove_posix(struct file *filp, fl_owner_t owner)
 	 * posix_lock_file().  Another process could be setting a lock on this
 	 * file at the same time, but we wouldn't remove that lock anyway.
 	 */
-	if (!file_inode(filp)->i_flock)
+	if (!file_inode(filp)->i_flctx)
 		return;
 
 	lock.fl_type = F_UNLCK;
diff --git a/fs/read_write.c b/fs/read_write.c
index 009d8542a889..0c77edf9fa25 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -358,7 +358,7 @@ int rw_verify_area(int read_write, struct file *file, const loff_t *ppos, size_t
 			return retval;
 	}
 
-	if (unlikely(inode->i_flock && mandatory_lock(inode))) {
+	if (unlikely(inode->i_flctx && mandatory_lock(inode))) {
 		retval = locks_mandatory_area(
 			read_write == READ ? FLOCK_VERIFY_READ : FLOCK_VERIFY_WRITE,
 			inode, file, pos, count);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 303dfcd3b663..9cdbda752b13 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -938,6 +938,7 @@ struct file_lock {
 struct file_lock_context {
 	spinlock_t		flc_lock;
 	struct list_head	flc_flock;
+	struct list_head	flc_posix;
 };
 
 /* The following constant reflects the upper bound of the file/locking space */
@@ -1920,7 +1921,7 @@ static inline int locks_verify_truncate(struct inode *inode,
 				    struct file *filp,
 				    loff_t size)
 {
-	if (inode->i_flock && mandatory_lock(inode))
+	if (inode->i_flctx && mandatory_lock(inode))
 		return locks_mandatory_area(
 			FLOCK_VERIFY_WRITE, inode, filp,
 			size < inode->i_size ? size : inode->i_size,
-- 
1.9.3

