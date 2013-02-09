Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab3BIPDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 10:03:09 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:41628 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab3BIPDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 10:03:05 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v6 6/7] fat (exportfs): rebuild directory-inode if fat_dget() fails
Date: Sun, 10 Feb 2013 00:02:55 +0900
Message-Id: <1360422175-12348-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This patch enables rebuilding of directory inodes which are not present
in the cache.This is done by traversing the disk clusters to find the
directory entry of the parent directory and using its i_pos to build the
inode.

The traversal is done by fat_scan_logstart() which is similar to
fat_scan() but matches i_pos values instead of names.fat_scan_logstart()
needs an inode parameter to work, for which a dummy inode is created by
it's caller fat_rebuild_parent(). This dummy inode is destroyed after
the traversal completes.

All this is done  only if the nostale_ro nfs mount option is specified.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/dir.c   |   23 +++++++++++++++++++++++
 fs/fat/fat.h   |    3 +++
 fs/fat/inode.c |    2 +-
 fs/fat/nfs.c   |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 78dabf00..2ca7c63 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -964,6 +964,29 @@ int fat_scan(struct inode *dir, const unsigned char *name,
 }
 EXPORT_SYMBOL_GPL(fat_scan);
 
+/*
+ * Scans a directory for a given logstart.
+ * Returns an error code or zero.
+ */
+int fat_scan_logstart(struct inode *dir, int i_logstart,
+		      struct fat_slot_info *sinfo)
+{
+	struct super_block *sb = dir->i_sb;
+
+	sinfo->slot_off = 0;
+	sinfo->bh = NULL;
+	while (fat_get_short_entry(dir, &sinfo->slot_off, &sinfo->bh,
+				   &sinfo->de) >= 0) {
+		if (fat_get_start(MSDOS_SB(sb), sinfo->de) == i_logstart) {
+			sinfo->slot_off -= sizeof(*sinfo->de);
+			sinfo->nr_slots = 1;
+			sinfo->i_pos = fat_make_i_pos(sb, sinfo->bh, sinfo->de);
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
 static int __fat_remove_entries(struct inode *dir, loff_t pos, int nr_slots)
 {
 	struct super_block *sb = dir->i_sb;
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 413eaaf..21664fc 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -296,6 +296,8 @@ extern int fat_dir_empty(struct inode *dir);
 extern int fat_subdirs(struct inode *dir);
 extern int fat_scan(struct inode *dir, const unsigned char *name,
 		    struct fat_slot_info *sinfo);
+extern int fat_scan_logstart(struct inode *dir, int i_logstart,
+			     struct fat_slot_info *sinfo);
 extern int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
 				struct msdos_dir_entry **de);
 extern int fat_alloc_new_dir(struct inode *dir, struct timespec *ts);
@@ -373,6 +375,7 @@ extern struct inode *fat_build_inode(struct super_block *sb,
 extern int fat_sync_inode(struct inode *inode);
 extern int fat_fill_super(struct super_block *sb, void *data, int silent,
 			  int isvfat, void (*setup)(struct super_block *));
+extern int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de);
 
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 			    struct inode *i2);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 88f1e4f..9f3c606 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -385,7 +385,7 @@ static int fat_calc_dir_size(struct inode *inode)
 }
 
 /* doesn't deal with root inode */
-static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
+int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	int error;
diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index 3f2691e..87fb018 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -212,6 +212,53 @@ static struct dentry *fat_fh_to_parent_nostale(struct super_block *sb,
 }
 
 /*
+ * Rebuild the parent for a directory that is not connected
+ *  to the filesystem root
+ */
+static
+struct inode *fat_rebuild_parent(struct super_block *sb, int parent_logstart)
+{
+	int search_clus, clus_to_match;
+	struct msdos_dir_entry *de;
+	struct inode *parent = NULL;
+	struct inode *dummy_grand_parent = NULL;
+	struct fat_slot_info sinfo;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	sector_t blknr = fat_clus_to_blknr(sbi, parent_logstart);
+	struct buffer_head *parent_bh = sb_bread(sb, blknr);
+	if (!parent_bh) {
+		fat_msg(sb, KERN_ERR,
+			"unable to read cluster of parent directory");
+		return NULL;
+	}
+
+	de = (struct msdos_dir_entry *) parent_bh->b_data;
+	clus_to_match = fat_get_start(sbi, &de[0]);
+	search_clus = fat_get_start(sbi, &de[1]);
+
+	dummy_grand_parent = fat_dget(sb, search_clus);
+	if (!dummy_grand_parent) {
+		dummy_grand_parent = new_inode(sb);
+		if (!dummy_grand_parent) {
+			brelse(parent_bh);
+			return parent;
+		}
+
+		dummy_grand_parent->i_ino = iunique(sb, MSDOS_ROOT_INO);
+		fat_fill_inode(dummy_grand_parent, &de[1]);
+		MSDOS_I(dummy_grand_parent)->i_pos = -1;
+	}
+
+	if (!fat_scan_logstart(dummy_grand_parent, clus_to_match, &sinfo))
+		parent = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
+
+	brelse(parent_bh);
+	iput(dummy_grand_parent);
+
+	return parent;
+}
+
+/*
  * Find the parent for a directory that is not currently connected to
  * the filesystem root.
  *
@@ -223,10 +270,13 @@ static struct dentry *fat_get_parent(struct dentry *child_dir)
 	struct buffer_head *bh = NULL;
 	struct msdos_dir_entry *de;
 	struct inode *parent_inode = NULL;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
 	if (!fat_get_dotdot_entry(child_dir->d_inode, &bh, &de)) {
-		int parent_logstart = fat_get_start(MSDOS_SB(sb), de);
+		int parent_logstart = fat_get_start(sbi, de);
 		parent_inode = fat_dget(sb, parent_logstart);
+		if (!parent_inode && sbi->options.nfs == FAT_NFS_NOSTALE_RO)
+			parent_inode = fat_rebuild_parent(sb, parent_logstart);
 	}
 	brelse(bh);
 
-- 
1.7.9.5

