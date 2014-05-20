Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaETJWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:22:54 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:60695 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaETJWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:22:52 -0400
Date: Tue, 20 May 2014 11:22:47 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] vfs: call rename2 if exists
Message-ID: <20140520092247.GJ17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please consider applying this patch to 3.15, so we can move forward with adding
RENAME_NOREPLACE support to filesystems during the next cycle.

Thanks,
Miklos

---
From: Miklos Szeredi <mszeredi@suse.cz>

Christoph Hellwig suggests:

1) make vfs_rename call ->rename2 if it exists instead of ->rename
2) switch all filesystems that you're adding NOREPLACE support for to
   use ->rename2
3) see how many ->rename instances we'll have left after a few
   iterations of 2.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 fs/ext4/namei.c |    1 -
 fs/fuse/dir.c   |   26 +++++++++++---------------
 fs/namei.c      |    5 +++--
 3 files changed, 14 insertions(+), 18 deletions(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -814,13 +814,6 @@ static int fuse_rename_common(struct ino
 	return err;
 }
 
-static int fuse_rename(struct inode *olddir, struct dentry *oldent,
-		       struct inode *newdir, struct dentry *newent)
-{
-	return fuse_rename_common(olddir, oldent, newdir, newent, 0,
-				  FUSE_RENAME, sizeof(struct fuse_rename_in));
-}
-
 static int fuse_rename2(struct inode *olddir, struct dentry *oldent,
 			struct inode *newdir, struct dentry *newent,
 			unsigned int flags)
@@ -831,17 +824,21 @@ static int fuse_rename2(struct inode *ol
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
 		return -EINVAL;
 
-	if (fc->no_rename2 || fc->minor < 23)
-		return -EINVAL;
+	if (flags) {
+		if (fc->no_rename2 || fc->minor < 23)
+			return -EINVAL;
 
-	err = fuse_rename_common(olddir, oldent, newdir, newent, flags,
+		err = fuse_rename_common(olddir, oldent, newdir, newent, flags,
 				 FUSE_RENAME2, sizeof(struct fuse_rename2_in));
-	if (err == -ENOSYS) {
-		fc->no_rename2 = 1;
-		err = -EINVAL;
+		if (err == -ENOSYS) {
+			fc->no_rename2 = 1;
+			err = -EINVAL;
+		}
+	} else {
+		err = fuse_rename_common(olddir, oldent, newdir, newent, 0,
+				 FUSE_RENAME, sizeof(struct fuse_rename_in));
 	}
 	return err;
-
 }
 
 static int fuse_link(struct dentry *entry, struct inode *newdir,
@@ -2017,7 +2014,6 @@ static const struct inode_operations fus
 	.symlink	= fuse_symlink,
 	.unlink		= fuse_unlink,
 	.rmdir		= fuse_rmdir,
-	.rename		= fuse_rename,
 	.rename2	= fuse_rename2,
 	.link		= fuse_link,
 	.setattr	= fuse_setattr,
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4073,7 +4073,7 @@ int vfs_rename(struct inode *old_dir, st
 	if (error)
 		return error;
 
-	if (!old_dir->i_op->rename)
+	if (!old_dir->i_op->rename && !old_dir->i_op->rename2)
 		return -EPERM;
 
 	if (flags && !old_dir->i_op->rename2)
@@ -4132,10 +4132,11 @@ int vfs_rename(struct inode *old_dir, st
 		if (error)
 			goto out;
 	}
-	if (!flags) {
+	if (!old_dir->i_op->rename2) {
 		error = old_dir->i_op->rename(old_dir, old_dentry,
 					      new_dir, new_dentry);
 	} else {
+		WARN_ON(old_dir->i_op->rename != NULL);
 		error = old_dir->i_op->rename2(old_dir, old_dentry,
 					       new_dir, new_dentry, flags);
 	}
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3434,7 +3434,6 @@ const struct inode_operations ext4_dir_i
 	.rmdir		= ext4_rmdir,
 	.mknod		= ext4_mknod,
 	.tmpfile	= ext4_tmpfile,
-	.rename		= ext4_rename,
 	.rename2	= ext4_rename2,
 	.setattr	= ext4_setattr,
 	.setxattr	= generic_setxattr,
