Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaF3MDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:03:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52019 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753607AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Ben Myers <bpm@sgi.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 043/181] xfs: xfs_remove deadlocks due to inverted AGF vs AGI lock ordering
Date: Mon, 30 Jun 2014 13:51:04 +0200
Message-Id: <4769bc44fd1ce342c81e75d7f108a9ba23c9021c.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 273203699f82667296e1f14344c5a5a6c4600470 upstream.

Removing an inode from the namespace involves removing the directory
entry and dropping the link count on the inode. Removing the
directory entry can result in locking an AGF (directory blocks were
freed) and removing a link count can result in placing the inode on
an unlinked list which results in locking an AGI.

The big problem here is that we have an ordering constraint on AGF
and AGI locking - inode allocation locks the AGI, then can allocate
a new extent for new inodes, locking the AGF after the AGI.
Similarly, freeing the inode removes the inode from the unlinked
list, requiring that we lock the AGI first, and then freeing the
inode can result in an inode chunk being freed and hence freeing
disk space requiring that we lock an AGF.

Hence the ordering that is imposed by other parts of the code is AGI
before AGF. This means we cannot remove the directory entry before
we drop the inode reference count and put it on the unlinked list as
this results in a lock order of AGF then AGI, and this can deadlock
against inode allocation and freeing. Therefore we must drop the
link counts before we remove the directory entry.

This is still safe from a transactional point of view - it is not
until we get to xfs_bmap_finish() that we have the possibility of
multiple transactions in this operation. Hence as long as we remove
the directory entry and drop the link count in the first transaction
of the remove operation, there are no transactional constraints on
the ordering here.

Change the ordering of the operations in the xfs_remove() function
to align the ordering of AGI and AGF locking to match that of the
rest of the code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/xfs/xfs_inode.c | 72 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e3d75385aa76..7a460d8ad06e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2370,6 +2370,33 @@ xfs_iunpin_wait(
 		__xfs_iunpin_wait(ip);
 }
 
+/*
+ * Removing an inode from the namespace involves removing the directory entry
+ * and dropping the link count on the inode. Removing the directory entry can
+ * result in locking an AGF (directory blocks were freed) and removing a link
+ * count can result in placing the inode on an unlinked list which results in
+ * locking an AGI.
+ *
+ * The big problem here is that we have an ordering constraint on AGF and AGI
+ * locking - inode allocation locks the AGI, then can allocate a new extent for
+ * new inodes, locking the AGF after the AGI. Similarly, freeing the inode
+ * removes the inode from the unlinked list, requiring that we lock the AGI
+ * first, and then freeing the inode can result in an inode chunk being freed
+ * and hence freeing disk space requiring that we lock an AGF.
+ *
+ * Hence the ordering that is imposed by other parts of the code is AGI before
+ * AGF. This means we cannot remove the directory entry before we drop the inode
+ * reference count and put it on the unlinked list as this results in a lock
+ * order of AGF then AGI, and this can deadlock against inode allocation and
+ * freeing. Therefore we must drop the link counts before we remove the
+ * directory entry.
+ *
+ * This is still safe from a transactional point of view - it is not until we
+ * get to xfs_bmap_finish() that we have the possibility of multiple
+ * transactions in this operation. Hence as long as we remove the directory
+ * entry and drop the link count in the first transaction of the remove
+ * operation, there are no transactional constraints on the ordering here.
+ */
 int
 xfs_remove(
 	xfs_inode_t             *dp,
@@ -2439,6 +2466,7 @@ xfs_remove(
 	/*
 	 * If we're removing a directory perform some additional validation.
 	 */
+	cancel_flags |= XFS_TRANS_ABORT;
 	if (is_dir) {
 		ASSERT(ip->i_d.di_nlink >= 2);
 		if (ip->i_d.di_nlink != 2) {
@@ -2449,31 +2477,16 @@ xfs_remove(
 			error = XFS_ERROR(ENOTEMPTY);
 			goto out_trans_cancel;
 		}
-	}
 
-	xfs_bmap_init(&free_list, &first_block);
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
-					&first_block, &free_list, resblks);
-	if (error) {
-		ASSERT(error != ENOENT);
-		goto out_bmap_cancel;
-	}
-	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
-
-	if (is_dir) {
-		/*
-		 * Drop the link from ip's "..".
-		 */
+		/* Drop the link from ip's "..".  */
 		error = xfs_droplink(tp, dp);
 		if (error)
-			goto out_bmap_cancel;
+			goto out_trans_cancel;
 
-		/*
-		 * Drop the "." link from ip to self.
-		 */
+		/* Drop the "." link from ip to self.  */
 		error = xfs_droplink(tp, ip);
 		if (error)
-			goto out_bmap_cancel;
+			goto out_trans_cancel;
 	} else {
 		/*
 		 * When removing a non-directory we need to log the parent
@@ -2482,20 +2495,24 @@ xfs_remove(
 		 */
 		xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 	}
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
-	/*
-	 * Drop the link from dp to ip.
-	 */
+	/* Drop the link from dp to ip. */
 	error = xfs_droplink(tp, ip);
 	if (error)
-		goto out_bmap_cancel;
+		goto out_trans_cancel;
 
-	/*
-	 * Determine if this is the last link while
-	 * we are in the transaction.
-	 */
+	/* Determine if this is the last link while the inode is locked */
 	link_zero = (ip->i_d.di_nlink == 0);
 
+	xfs_bmap_init(&free_list, &first_block);
+	error = xfs_dir_removename(tp, dp, name, ip->i_ino,
+					&first_block, &free_list, resblks);
+	if (error) {
+		ASSERT(error != ENOENT);
+		goto out_bmap_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2525,7 +2542,6 @@ xfs_remove(
 
  out_bmap_cancel:
 	xfs_bmap_cancel(&free_list);
-	cancel_flags |= XFS_TRANS_ABORT;
  out_trans_cancel:
 	xfs_trans_cancel(tp, cancel_flags);
  std_return:
-- 
2.0.0

