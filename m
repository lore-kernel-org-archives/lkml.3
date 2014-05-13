Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbaEMN43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:56:29 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:53734 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760292AbaEMN41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:56:27 -0400
Date: Tue, 13 May 2014 15:56:22 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Mikulas Patocka <mpatocka@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Joern Engel <joern@logfs.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Bob Copeland <me@bobcopeland.com>,
        Christoph Hellwig <hch@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH] vfs: add noreplace_rename2()
Message-ID: <20140513135622.GB17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

RENAME_NOREPLACE is trivial to implement for most filesystems.  This adds a
helper that can be assigned to ->rename2() and calls ->rename().

Only suitable for local filesystems, i.e. those that cannot have files
"spontaneously" appear (like NFS and friends).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Chris Mason <clm@fb.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Bob Copeland <me@bobcopeland.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
---
 fs/affs/dir.c        |    1 +
 fs/bfs/dir.c         |    1 +
 fs/btrfs/inode.c     |    1 +
 fs/ext2/namei.c      |    1 +
 fs/ext3/namei.c      |    1 +
 fs/f2fs/namei.c      |    1 +
 fs/fat/namei_msdos.c |    1 +
 fs/fat/namei_vfat.c  |    1 +
 fs/hfs/dir.c         |    1 +
 fs/hfsplus/dir.c     |    1 +
 fs/hpfs/namei.c      |    1 +
 fs/hugetlbfs/inode.c |    1 +
 fs/jffs2/dir.c       |    1 +
 fs/jfs/namei.c       |    1 +
 fs/libfs.c           |   25 +++++++++++++++++++++++++
 fs/logfs/dir.c       |    1 +
 fs/minix/namei.c     |    1 +
 fs/nilfs2/namei.c    |    1 +
 fs/omfs/dir.c        |    1 +
 fs/ramfs/inode.c     |    1 +
 fs/reiserfs/namei.c  |    1 +
 fs/sysv/namei.c      |    1 +
 fs/ubifs/dir.c       |    1 +
 fs/udf/namei.c       |    1 +
 fs/ufs/namei.c       |    1 +
 fs/xfs/xfs_iops.c    |    2 ++
 include/linux/fs.h   |    3 +++
 27 files changed, 54 insertions(+)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -352,6 +352,31 @@ int simple_rename(struct inode *old_dir,
 EXPORT_SYMBOL(simple_rename);
 
 /**
+ * noreplace_rename2 - trivial rename2 implementation for RENAME_NOREPLACE
+ * @old_dir: old dir
+ * @old_dentry: old dentry
+ * @new_dir: new dir
+ * @new_dentry: new dentry
+ * @flags: flags
+ *
+ * This just checks flags and calls ->rename().  Suitable for any filesystem
+ * that can only change through the VFS (i.e. most block fs).
+ *
+ * Network filesystems need to implement RENAME_NOREPLACE in their protocol to
+ * work correctly.
+ */
+int noreplace_rename2(struct inode *old_dir, struct dentry *old_dentry,
+		      struct inode *new_dir, struct dentry *new_dentry,
+		      unsigned int flags)
+
+{
+	if (flags & ~RENAME_NOREPLACE)
+		return -EINVAL;
+
+	return old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
+}
+
+/**
  * simple_setattr - setattr for simple filesystem
  * @dentry: dentry
  * @iattr: iattr structure
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2562,6 +2562,9 @@ extern int simple_link(struct dentry *,
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
 extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int noreplace_rename2(struct inode *old_dir, struct dentry *old_dentry,
+			     struct inode *new_dir, struct dentry *new_dentry,
+			     unsigned int flags);
 extern int noop_fsync(struct file *, loff_t, loff_t, int);
 extern int simple_empty(struct dentry *);
 extern int simple_readpage(struct file *file, struct page *page);
--- a/fs/affs/dir.c
+++ b/fs/affs/dir.c
@@ -36,6 +36,7 @@ const struct inode_operations affs_dir_i
 	.mkdir		= affs_mkdir,
 	.rmdir		= affs_rmdir,
 	.rename		= affs_rename,
+	.rename2	= noreplace_rename2,
 	.setattr	= affs_notify_change,
 };
 
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -273,6 +273,7 @@ const struct inode_operations bfs_dir_in
 	.link			= bfs_link,
 	.unlink			= bfs_unlink,
 	.rename			= bfs_rename,
+	.rename2		= noreplace_rename2,
 };
 
 static int bfs_add_entry(struct inode *dir, const unsigned char *name,
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8898,6 +8898,7 @@ static const struct inode_operations btr
 	.mkdir		= btrfs_mkdir,
 	.rmdir		= btrfs_rmdir,
 	.rename		= btrfs_rename,
+	.rename2	= noreplace_rename2,
 	.symlink	= btrfs_symlink,
 	.setattr	= btrfs_setattr,
 	.mknod		= btrfs_mknod,
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -413,6 +413,7 @@ const struct inode_operations ext2_dir_i
 	.rmdir		= ext2_rmdir,
 	.mknod		= ext2_mknod,
 	.rename		= ext2_rename,
+	.rename2	= noreplace_rename2,
 #ifdef CONFIG_EXT2_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2561,6 +2561,7 @@ const struct inode_operations ext3_dir_i
 	.mknod		= ext3_mknod,
 	.tmpfile	= ext3_tmpfile,
 	.rename		= ext3_rename,
+	.rename2	= noreplace_rename2,
 	.setattr	= ext3_setattr,
 #ifdef CONFIG_EXT3_FS_XATTR
 	.setxattr	= generic_setxattr,
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -507,6 +507,7 @@ const struct inode_operations f2fs_dir_i
 	.rmdir		= f2fs_rmdir,
 	.mknod		= f2fs_mknod,
 	.rename		= f2fs_rename,
+	.rename2	= noreplace_rename2,
 	.getattr	= f2fs_getattr,
 	.setattr	= f2fs_setattr,
 	.get_acl	= f2fs_get_acl,
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -636,6 +636,7 @@ static const struct inode_operations msd
 	.mkdir		= msdos_mkdir,
 	.rmdir		= msdos_rmdir,
 	.rename		= msdos_rename,
+	.rename2	= noreplace_rename2,
 	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 };
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1037,6 +1037,7 @@ static const struct inode_operations vfa
 	.mkdir		= vfat_mkdir,
 	.rmdir		= vfat_rmdir,
 	.rename		= vfat_rename,
+	.rename2	= noreplace_rename2,
 	.setattr	= fat_setattr,
 	.getattr	= fat_getattr,
 };
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -315,5 +315,6 @@ const struct inode_operations hfs_dir_in
 	.mkdir		= hfs_mkdir,
 	.rmdir		= hfs_remove,
 	.rename		= hfs_rename,
+	.rename2	= noreplace_rename2,
 	.setattr	= hfs_inode_setattr,
 };
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -526,6 +526,7 @@ const struct inode_operations hfsplus_di
 	.symlink		= hfsplus_symlink,
 	.mknod			= hfsplus_mknod,
 	.rename			= hfsplus_rename,
+	.rename2		= noreplace_rename2,
 	.setxattr		= generic_setxattr,
 	.getxattr		= generic_getxattr,
 	.listxattr		= hfsplus_listxattr,
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -624,5 +624,6 @@ const struct inode_operations hpfs_dir_i
 	.rmdir		= hpfs_rmdir,
 	.mknod		= hpfs_mknod,
 	.rename		= hpfs_rename,
+	.rename2	= noreplace_rename2,
 	.setattr	= hpfs_setattr,
 };
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -743,6 +743,7 @@ static const struct inode_operations hug
 	.rmdir		= simple_rmdir,
 	.mknod		= hugetlbfs_mknod,
 	.rename		= simple_rename,
+	.rename2	= noreplace_rename2,
 	.setattr	= hugetlbfs_setattr,
 };
 
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -58,6 +58,7 @@ const struct inode_operations jffs2_dir_
 	.rmdir =	jffs2_rmdir,
 	.mknod =	jffs2_mknod,
 	.rename =	jffs2_rename,
+	.rename2 =	noreplace_rename2,
 	.get_acl =	jffs2_get_acl,
 	.set_acl =	jffs2_set_acl,
 	.setattr =	jffs2_setattr,
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1517,6 +1517,7 @@ const struct inode_operations jfs_dir_in
 	.rmdir		= jfs_rmdir,
 	.mknod		= jfs_mknod,
 	.rename		= jfs_rename,
+	.rename2	= noreplace_rename2,
 	.setxattr	= jfs_setxattr,
 	.getxattr	= jfs_getxattr,
 	.listxattr	= jfs_listxattr,
--- a/fs/logfs/dir.c
+++ b/fs/logfs/dir.c
@@ -788,6 +788,7 @@ const struct inode_operations logfs_dir_
 	.mkdir		= logfs_mkdir,
 	.mknod		= logfs_mknod,
 	.rename		= logfs_rename,
+	.rename2	= noreplace_rename2,
 	.rmdir		= logfs_rmdir,
 	.symlink	= logfs_symlink,
 	.unlink		= logfs_unlink,
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -265,6 +265,7 @@ const struct inode_operations minix_dir_
 	.rmdir		= minix_rmdir,
 	.mknod		= minix_mknod,
 	.rename		= minix_rename,
+	.rename2	= noreplace_rename2,
 	.getattr	= minix_getattr,
 	.tmpfile	= minix_tmpfile,
 };
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -551,6 +551,7 @@ const struct inode_operations nilfs_dir_
 	.rmdir		= nilfs_rmdir,
 	.mknod		= nilfs_mknod,
 	.rename		= nilfs_rename,
+	.rename2	= noreplace_rename2,
 	.setattr	= nilfs_setattr,
 	.permission	= nilfs_permission,
 	.fiemap		= nilfs_fiemap,
--- a/fs/omfs/dir.c
+++ b/fs/omfs/dir.c
@@ -445,6 +445,7 @@ const struct inode_operations omfs_dir_i
 	.lookup = omfs_lookup,
 	.mkdir = omfs_mkdir,
 	.rename = omfs_rename,
+	.rename2 = noreplace_rename2,
 	.create = omfs_create,
 	.unlink = omfs_remove,
 	.rmdir = omfs_remove,
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -155,6 +155,7 @@ static const struct inode_operations ram
 	.rmdir		= simple_rmdir,
 	.mknod		= ramfs_mknod,
 	.rename		= simple_rename,
+	.rename2	= noreplace_rename2,
 };
 
 static const struct super_operations ramfs_ops = {
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -1515,6 +1515,7 @@ const struct inode_operations reiserfs_d
 	.rmdir = reiserfs_rmdir,
 	.mknod = reiserfs_mknod,
 	.rename = reiserfs_rename,
+	.rename2 = noreplace_rename2,
 	.setattr = reiserfs_setattr,
 	.setxattr = reiserfs_setxattr,
 	.getxattr = reiserfs_getxattr,
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -286,5 +286,6 @@ const struct inode_operations sysv_dir_i
 	.rmdir		= sysv_rmdir,
 	.mknod		= sysv_mknod,
 	.rename		= sysv_rename,
+	.rename2	= noreplace_rename2,
 	.getattr	= sysv_getattr,
 };
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1164,6 +1164,7 @@ const struct inode_operations ubifs_dir_
 	.rmdir       = ubifs_rmdir,
 	.mknod       = ubifs_mknod,
 	.rename      = ubifs_rename,
+	.rename2     = noreplace_rename2,
 	.setattr     = ubifs_setattr,
 	.getattr     = ubifs_getattr,
 	.setxattr    = ubifs_setxattr,
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1334,6 +1334,7 @@ const struct inode_operations udf_dir_in
 	.rmdir				= udf_rmdir,
 	.mknod				= udf_mknod,
 	.rename				= udf_rename,
+	.rename2			= noreplace_rename2,
 	.tmpfile			= udf_tmpfile,
 };
 const struct inode_operations udf_symlink_inode_operations = {
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -343,4 +343,5 @@ const struct inode_operations ufs_dir_in
 	.rmdir		= ufs_rmdir,
 	.mknod		= ufs_mknod,
 	.rename		= ufs_rename,
+	.rename2	= noreplace_rename2,
 };
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1106,6 +1106,7 @@ static const struct inode_operations xfs
 	.rmdir			= xfs_vn_unlink,
 	.mknod			= xfs_vn_mknod,
 	.rename			= xfs_vn_rename,
+	.rename2		= noreplace_rename2,
 	.get_acl		= xfs_get_acl,
 	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
@@ -1134,6 +1135,7 @@ static const struct inode_operations xfs
 	.rmdir			= xfs_vn_unlink,
 	.mknod			= xfs_vn_mknod,
 	.rename			= xfs_vn_rename,
+	.rename2		= noreplace_rename2,
 	.get_acl		= xfs_get_acl,
 	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
