Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3GHNhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:37:51 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:46364 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3GHNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:37:49 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Bruce Fields <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] locks: close potential race between setlease and open
Date: Mon,  8 Jul 2013 09:30:55 -0400
Message-Id: <1373290255-16977-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: Bruce Fields <bfields@fieldses.org>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index b27a300..9f7f647 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1455,6 +1455,19 @@ int fcntl_getlease(struct file *filp)
 	return type;
 }
 
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
@@ -1464,12 +1477,8 @@ static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp
 
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
@@ -1514,8 +1523,16 @@ static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp
 		goto out;
 
 	locks_insert_lock(before, lease);
-	return 0;
 
+	/*
+	 * The check in break_lease() is lockless. It's possible for another
+	 * open to race in after we did the earlier check for a conflicting
+	 * open but before the lease was inserted. Check again for a
+	 * conflicting open and cancel the lease if there is one.
+	 */
+	error = check_conflicting_open(dentry, arg);
+	if (error)
+		locks_delete_lock(flp);
 out:
 	return error;
 }
-- 
1.8.1.4

