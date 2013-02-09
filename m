Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab3BIPCi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 10:02:38 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:58771 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab3BIPCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 10:02:34 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v6 4/7] fat: restructure export_operations
Date: Sun, 10 Feb 2013 00:02:25 +0900
Message-Id: <1360422145-12280-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Define two nfs export_operation structures,one for 'stale_rw' mounts and
the other for 'nostale_ro'.The latter uses i_pos as a basis for encoding
and decoding file handles.

Also, assign i_pos to kstat->ino.The logic for rebuilding the inode is
added in the subsequent patches.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/fat.h             |    8 +--
 fs/fat/file.c            |    9 ++++
 fs/fat/inode.c           |   11 ++--
 fs/fat/nfs.c             |  126 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/exportfs.h |   11 ++++
 5 files changed, 146 insertions(+), 19 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 980c034..c517fc0 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -406,12 +406,8 @@ int fat_cache_init(void);
 void fat_cache_destroy(void);
 
 /* fat/nfs.c */
-struct fid;
-extern struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
-				       int fh_len, int fh_type);
-extern struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
-				       int fh_len, int fh_type);
-extern struct dentry *fat_get_parent(struct dentry *child_dir);
+extern const struct export_operations fat_export_ops;
+extern const struct export_operations fat_export_ops_nostale;
 
 /* helper for printk */
 typedef unsigned long long	llu;
diff --git a/fs/fat/file.c b/fs/fat/file.c
index a62e0ec..de74655 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -306,6 +306,15 @@ int fat_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	struct inode *inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
 	stat->blksize = MSDOS_SB(inode->i_sb)->cluster_size;
+
+	if (MSDOS_SB(inode->i_sb)->options.nfs == FAT_NFS_NOSTALE_RO) {
+		if (inode->i_ino == MSDOS_ROOT_INO)
+			stat->ino = MSDOS_ROOT_INO;
+		else
+			/* Use i_pos for ino. This is used as fileid of nfs. */
+			stat->ino = fat_i_pos_read(MSDOS_SB(inode->i_sb),
+						   inode);
+	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fat_getattr);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 8356a05..951e675 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -18,7 +18,6 @@
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/buffer_head.h>
-#include <linux/exportfs.h>
 #include <linux/mount.h>
 #include <linux/aio.h>
 #include <linux/vfs.h>
@@ -749,12 +748,6 @@ static const struct super_operations fat_sops = {
 	.show_options	= fat_show_options,
 };
 
-static const struct export_operations fat_export_ops = {
-	.fh_to_dentry	= fat_fh_to_dentry,
-	.fh_to_parent	= fat_fh_to_parent,
-	.get_parent	= fat_get_parent,
-};
-
 static int fat_show_options(struct seq_file *m, struct dentry *root)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(root->d_sb);
@@ -1178,8 +1171,10 @@ out:
 		opts->allow_utime = ~opts->fs_dmask & (S_IWGRP | S_IWOTH);
 	if (opts->unicode_xlate)
 		opts->utf8 = 0;
-	if (opts->nfs == FAT_NFS_NOSTALE_RO)
+	if (opts->nfs == FAT_NFS_NOSTALE_RO) {
 		sb->s_flags |= MS_RDONLY;
+		sb->s_export_op = &fat_export_ops_nostale;
+	}
 
 	return 0;
 }
diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index 499c104..bad8f46 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -14,6 +14,18 @@
 #include <linux/exportfs.h>
 #include "fat.h"
 
+struct fat_fid {
+	u32 i_gen;
+	u32 i_pos_low;
+	u16 i_pos_hi;
+	u16 parent_i_pos_hi;
+	u32 parent_i_pos_low;
+	u32 parent_i_gen;
+} __packed;
+
+#define FAT_FID_SIZE_WITHOUT_PARENT 3
+#define FAT_FID_SIZE_WITH_PARENT (sizeof(struct fat_fid)/sizeof(u32))
+
 /**
  * Look up a directory inode given its starting cluster.
  */
@@ -38,8 +50,8 @@ static struct inode *fat_dget(struct super_block *sb, int i_logstart)
 	return inode;
 }
 
-static struct inode *fat_nfs_get_inode(struct super_block *sb,
-				       u64 ino, u32 generation)
+static struct inode *__fat_nfs_get_inode(struct super_block *sb,
+				       u64 ino, u32 generation, loff_t i_pos)
 {
 	struct inode *inode;
 
@@ -55,35 +67,126 @@ static struct inode *fat_nfs_get_inode(struct super_block *sb,
 	return inode;
 }
 
+static struct inode *fat_nfs_get_inode(struct super_block *sb,
+				       u64 ino, u32 generation)
+{
+
+	return __fat_nfs_get_inode(sb, ino, generation, 0);
+}
+
+static int
+fat_encode_fh_nostale(struct inode *inode, __u32 *fh, int *lenp,
+		      struct inode *parent)
+{
+	int len = *lenp;
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	struct fat_fid *fid = (struct fat_fid *) fh;
+	loff_t i_pos;
+	int type = FILEID_FAT_WITHOUT_PARENT;
+
+	if (parent && (len < FAT_FID_SIZE_WITH_PARENT)) {
+		*lenp = FAT_FID_SIZE_WITH_PARENT;
+		return 255;
+	} else if (len < FAT_FID_SIZE_WITHOUT_PARENT) {
+		*lenp = FAT_FID_SIZE_WITHOUT_PARENT;
+		return 255;
+	}
+
+	i_pos = fat_i_pos_read(sbi, inode);
+	*lenp = FAT_FID_SIZE_WITHOUT_PARENT;
+	fid->i_gen = inode->i_generation;
+	fid->i_pos_low = i_pos & 0xFFFFFFFF;
+	fid->i_pos_hi = (i_pos >> 32) & 0xFFFF;
+	if (parent) {
+		i_pos = fat_i_pos_read(sbi, parent);
+		fid->parent_i_pos_hi = (i_pos >> 32) & 0xFFFF;
+		fid->parent_i_pos_low = i_pos & 0xFFFFFFFF;
+		fid->parent_i_gen = parent->i_generation;
+		type = FILEID_FAT_WITH_PARENT;
+		*lenp = FAT_FID_SIZE_WITH_PARENT;
+	}
+
+	return type;
+}
+
 /**
  * Map a NFS file handle to a corresponding dentry.
  * The dentry may or may not be connected to the filesystem root.
  */
-struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
+static struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
 				int fh_len, int fh_type)
 {
 	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
 				    fat_nfs_get_inode);
 }
 
+static struct dentry *fat_fh_to_dentry_nostale(struct super_block *sb,
+					       struct fid *fh, int fh_len,
+					       int fh_type)
+{
+	struct inode *inode = NULL;
+	struct fat_fid *fid = (struct fat_fid *)fh;
+	loff_t i_pos;
+
+	switch (fh_type) {
+	case FILEID_FAT_WITHOUT_PARENT:
+		if (fh_len < FAT_FID_SIZE_WITHOUT_PARENT)
+			return NULL;
+		break;
+	case FILEID_FAT_WITH_PARENT:
+		if (fh_len < FAT_FID_SIZE_WITH_PARENT)
+			return NULL;
+		break;
+	default:
+		return NULL;
+	}
+	i_pos = fid->i_pos_hi;
+	i_pos = (i_pos << 32) | (fid->i_pos_low);
+	inode = __fat_nfs_get_inode(sb, 0, fid->i_gen, i_pos);
+
+	return d_obtain_alias(inode);
+}
+
 /*
  * Find the parent for a file specified by NFS handle.
  * This requires that the handle contain the i_ino of the parent.
  */
-struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
+static struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
 				int fh_len, int fh_type)
 {
 	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
 				    fat_nfs_get_inode);
 }
 
+static struct dentry *fat_fh_to_parent_nostale(struct super_block *sb,
+					       struct fid *fh, int fh_len,
+					       int fh_type)
+{
+	struct inode *inode = NULL;
+	struct fat_fid *fid = (struct fat_fid *)fh;
+	loff_t i_pos;
+
+	if (fh_len < FAT_FID_SIZE_WITH_PARENT)
+		return NULL;
+
+	switch (fh_type) {
+	case FILEID_FAT_WITH_PARENT:
+		i_pos = fid->parent_i_pos_hi;
+		i_pos = (i_pos << 32) | (fid->parent_i_pos_low);
+		inode = __fat_nfs_get_inode(sb, 0, fid->parent_i_gen, i_pos);
+		break;
+	}
+
+	return d_obtain_alias(inode);
+}
+
 /*
  * Find the parent for a directory that is not currently connected to
  * the filesystem root.
  *
  * On entry, the caller holds child_dir->d_inode->i_mutex.
  */
-struct dentry *fat_get_parent(struct dentry *child_dir)
+static struct dentry *fat_get_parent(struct dentry *child_dir)
 {
 	struct super_block *sb = child_dir->d_sb;
 	struct buffer_head *bh = NULL;
@@ -98,3 +201,16 @@ struct dentry *fat_get_parent(struct dentry *child_dir)
 
 	return d_obtain_alias(parent_inode);
 }
+
+const struct export_operations fat_export_ops = {
+	.fh_to_dentry   = fat_fh_to_dentry,
+	.fh_to_parent   = fat_fh_to_parent,
+	.get_parent     = fat_get_parent,
+};
+
+const struct export_operations fat_export_ops_nostale = {
+	.encode_fh      = fat_encode_fh_nostale,
+	.fh_to_dentry   = fat_fh_to_dentry_nostale,
+	.fh_to_parent   = fat_fh_to_parent_nostale,
+	.get_parent     = fat_get_parent,
+};
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 5b9b5b3..41b223a 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -85,6 +85,17 @@ enum fid_type {
 	FILEID_NILFS_WITH_PARENT = 0x62,
 
 	/*
+	 * 32 bit generation number, 40 bit i_pos.
+	 */
+	FILEID_FAT_WITHOUT_PARENT = 0x71,
+
+	/*
+	 * 32 bit generation number, 40 bit i_pos,
+	 * 32 bit parent generation number, 40 bit parent i_pos
+	 */
+	FILEID_FAT_WITH_PARENT = 0x72,
+
+	/*
 	 * Filesystems must not use 0xff file ID.
 	 */
 	FILEID_INVALID = 0xff,
-- 
1.7.9.5

