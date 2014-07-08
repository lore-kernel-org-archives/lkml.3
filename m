Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbaGHTsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:48:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54036 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755648AbaGHTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Kara" <jack@suse.cz>,
        "Marco Stornelli" <marco.stornelli@gmail.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.550217343@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 009/125] reiserfs: drop vmtruncate
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Stornelli <marco.stornelli@gmail.com>

commit cfac4b47c664e207740880d6492938761c53d74b upstream.

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/reiserfs/file.c          |  3 +--
 fs/reiserfs/inode.c         | 15 +++++++++++----
 include/linux/reiserfs_fs.h |  1 +
 3 files changed, 13 insertions(+), 6 deletions(-)

--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -126,7 +126,7 @@ static int reiserfs_file_open(struct ino
 	return err;
 }
 
-static void reiserfs_vfs_truncate_file(struct inode *inode)
+void reiserfs_vfs_truncate_file(struct inode *inode)
 {
 	mutex_lock(&(REISERFS_I(inode)->tailpack));
 	reiserfs_truncate_file(inode, 1);
@@ -312,7 +312,6 @@ const struct file_operations reiserfs_fi
 };
 
 const struct inode_operations reiserfs_file_inode_operations = {
-	.truncate = reiserfs_vfs_truncate_file,
 	.setattr = reiserfs_setattr,
 	.setxattr = reiserfs_setxattr,
 	.getxattr = reiserfs_getxattr,
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3091,8 +3091,10 @@ static ssize_t reiserfs_direct_IO(int rw
 		loff_t isize = i_size_read(inode);
 		loff_t end = offset + iov_length(iov, nr_segs);
 
-		if (end > isize)
-			vmtruncate(inode, isize);
+		if ((end > isize) && inode_newsize_ok(inode, isize) == 0) {
+			truncate_setsize(inode, isize);
+			reiserfs_vfs_truncate_file(inode);
+		}
 	}
 
 	return ret;
@@ -3206,8 +3208,13 @@ int reiserfs_setattr(struct dentry *dent
 	 */
 	reiserfs_write_unlock_once(inode->i_sb, depth);
 	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode))
-		error = vmtruncate(inode, attr->ia_size);
+	    attr->ia_size != i_size_read(inode)) {
+		error = inode_newsize_ok(inode, attr->ia_size);
+		if (!error) {
+			truncate_setsize(inode, attr->ia_size);
+			reiserfs_vfs_truncate_file(inode);
+		}
+	}
 
 	if (!error) {
 		setattr_copy(inode, attr);
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -1882,6 +1882,7 @@ struct reiserfs_transaction_handle *reis
 								    *,
 								    int count);
 int reiserfs_end_persistent_transaction(struct reiserfs_transaction_handle *);
+void reiserfs_vfs_truncate_file(struct inode *inode);
 int reiserfs_commit_page(struct inode *inode, struct page *page,
 			 unsigned from, unsigned to);
 int reiserfs_flush_old_commits(struct super_block *);

