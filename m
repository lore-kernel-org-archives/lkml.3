Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaGWNQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:16:09 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50707 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbaGWNPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:15:55 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-kernel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 1/7] vfs: call rename2 if exists
Date: Wed, 23 Jul 2014 15:15:30 +0200
Message-Id: <1406121336-1379-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
References: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 fs/ext4/namei.c | 1 -
 fs/fuse/dir.c   | 7 -------
 fs/namei.c      | 5 +++--
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3520ab8a6639..b147a67baa0d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3455,7 +3455,6 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.rmdir		= ext4_rmdir,
 	.mknod		= ext4_mknod,
 	.tmpfile	= ext4_tmpfile,
-	.rename		= ext4_rename,
 	.rename2	= ext4_rename2,
 	.setattr	= ext4_setattr,
 	.setxattr	= generic_setxattr,
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 0c6048247a34..de1d84af9f7c 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -845,12 +845,6 @@ static int fuse_rename2(struct inode *olddir, struct dentry *oldent,
 	return err;
 }
 
-static int fuse_rename(struct inode *olddir, struct dentry *oldent,
-		       struct inode *newdir, struct dentry *newent)
-{
-	return fuse_rename2(olddir, oldent, newdir, newent, 0);
-}
-
 static int fuse_link(struct dentry *entry, struct inode *newdir,
 		     struct dentry *newent)
 {
@@ -2024,7 +2018,6 @@ static const struct inode_operations fuse_dir_inode_operations = {
 	.symlink	= fuse_symlink,
 	.unlink		= fuse_unlink,
 	.rmdir		= fuse_rmdir,
-	.rename		= fuse_rename,
 	.rename2	= fuse_rename2,
 	.link		= fuse_link,
 	.setattr	= fuse_setattr,
diff --git a/fs/namei.c b/fs/namei.c
index 985c6f368485..b268e7758a48 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4074,7 +4074,7 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (error)
 		return error;
 
-	if (!old_dir->i_op->rename)
+	if (!old_dir->i_op->rename && !old_dir->i_op->rename2)
 		return -EPERM;
 
 	if (flags && !old_dir->i_op->rename2)
@@ -4133,10 +4133,11 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
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
-- 
1.8.1.4

