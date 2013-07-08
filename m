Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3GHTHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:07:35 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:52819 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3GHTHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:07:33 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Bruce Fields <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] locks: close potential race between setlease and open
Date: Mon,  8 Jul 2013 15:07:24 -0400
Message-Id: <1373310444-25862-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
- fix potential double-free of lease if second check finds conflict
- add smp_mb's to ensure that other CPUs see i_flock changes

(Full disclosure: I don't have a great feel for memory barriers. Some
		  guidance here would be appreciated)

As Al Viro points out, there is an unlikely, but possible race between
opening a file and setting a lease on it. generic_add_lease is done with
the i_lock held, but the inode->i_flock check in break_lease is
lockless. It's possible for another task doing an open to do the entire
pathwalk and call break_lease between the point where generic_add_lease
checks for a conflicting open and adds the lease to the list. If this
occurs, we can end up with a lease set on the file with a conflicting
open.

To guard against that, check again for a conflicting open after adding
the lease to the i_flock list. If the above race occurs, then we can
simply unwind the lease setting and return -EAGAIN.

Finally, as Bruce points out, we must also ensure that the effects of
locks_insert_lock are seen by any break_lease callers prior to doing
the recheck for conflicting opens. So, add a smp_mb pairing in
break_lease and generic_add_lease to ensure that.

Cc: Bruce Fields <bfields@fieldses.org>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c         | 65 ++++++++++++++++++++++++++++++++++++++++++++----------
 include/linux/fs.h |  2 ++
 2 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index b27a300..c870a85 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -653,14 +653,13 @@ static void locks_insert_lock(struct file_lock **pos, struct file_lock *fl)
 }
 
 /*
- * Delete a lock and then free it.
- * Wake up processes that are blocked waiting for this lock,
- * notify the FS that the lock has been cleared and
- * finally free the lock.
+ * Unlink a lock from all lists and free the namespace reference, but don't
+ * free it yet. Wake up processes that are blocked waiting for this lock,
+ * notify the FS that the lock has been cleared and finally free the lock.
  *
  * Must be called with the i_lock held!
  */
-static void locks_delete_lock(struct file_lock **thisfl_p)
+static void locks_unlink_lock(struct file_lock **thisfl_p)
 {
 	struct file_lock *fl = *thisfl_p;
 
@@ -675,6 +674,18 @@ static void locks_delete_lock(struct file_lock **thisfl_p)
 	}
 
 	locks_wake_up_blocks(fl);
+}
+
+/*
+ * Unlink a lock from all lists and free it.
+ *
+ * Must be called with i_lock held!
+ */
+static void locks_delete_lock(struct file_lock **thisfl_p)
+{
+	struct file_lock *fl = *thisfl_p;
+
+	locks_unlink_lock(thisfl_p);
 	locks_free_lock(fl);
 }
 
@@ -1455,6 +1466,29 @@ int fcntl_getlease(struct file *filp)
 	return type;
 }
 
+/**
+ * check_conflicting_open - see if the given dentry points to a file that has
+ * 	an existing open that would conflict with the desired lease.
+ *
+ * @dentry:	dentry to check
+ * @arg:	type of lease that we're trying to acquire
+ *
+ * Check to see if there's an existing open fd on this file that would
+ * conflict with the lease we're trying to set.
+ */
+static int
+check_conflicting_open(struct dentry *dentry, long arg)
+{
+	struct inode *inode = dentry->d_inode;
+
+	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
+		return -EAGAIN;
+	if ((arg == F_WRLCK) && ((d_count(dentry) > 1) ||
+	    (atomic_read(&inode->i_count) > 1)))
+		return -EAGAIN;
+	return 0;
+}
+
 static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
 {
 	struct file_lock *fl, **before, **my_before = NULL, *lease;
@@ -1464,12 +1498,8 @@ static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp
 
 	lease = *flp;
 
-	error = -EAGAIN;
-	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
-		goto out;
-	if ((arg == F_WRLCK)
-	    && ((d_count(dentry) > 1)
-		|| (atomic_read(&inode->i_count) > 1)))
+	error = check_conflicting_open(dentry, arg);
+	if (error)
 		goto out;
 
 	/*
@@ -1514,8 +1544,19 @@ static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp
 		goto out;
 
 	locks_insert_lock(before, lease);
-	return 0;
 
+	/* ensure that break_lease sees change to i_flock list */
+	smp_mb();
+
+	/*
+	 * The check in break_lease() is lockless. It's possible for another
+	 * open to race in after we did the earlier check for a conflicting
+	 * open but before the lease was inserted. Check again for a
+	 * conflicting open and cancel the lease if there is one.
+	 */
+	error = check_conflicting_open(dentry, arg);
+	if (error)
+		locks_unlink_lock(flp);
 out:
 	return error;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 834c9e5..735f8b5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1953,6 +1953,8 @@ static inline int locks_verify_truncate(struct inode *inode,
 
 static inline int break_lease(struct inode *inode, unsigned int mode)
 {
+	/* make sure we see any change to i_flock list */
+	smp_mb();
 	if (inode->i_flock)
 		return __break_lease(inode, mode);
 	return 0;
-- 
1.8.1.4

