Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaIXKRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:17:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51045 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbaIXKRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:17:35 -0400
X-AuditID: cbfee61a-f79c06d000004e71-6e-54229a3d7bc0
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 3/6 v2] f2fs: export dir operations for inline dir
Date: Wed, 24 Sep 2014 18:17:04 +0800
Message-id: <003e01cfd7e0$c1ec51d0$45c4f570$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/X35Sr3UM5tAk9QOiAeovN/9xHMA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAV3bWUohBj9+qFhc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr48D5ZraC
	V5YV16bOZmlg7NXvYuTkkBAwkVjz9SEbhC0mceHeeiCbi0NIYBGjxL83jxghnB+MEjtObmMC
	qWITUJFY3vEfzBYR8JKYtP8EC4jNLOAh0djxnRXEFhbwkXjX0sXexcjBwSKgKjGpNQskzCtg
	KfGj+x8ThC0o8WPyPahWLYn1O48zQdjyEpvXvGWGOEhBYsfZ14wQq/Qkdu9byAxRIy6x8cgt
	lgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4pJ9J7WBc
	2WBxiFGAg1GJh3eCuFKIEGtiWXFl7iFGCQ5mJRHeVz1AId6UxMqq1KL8+KLSnNTiQ4zSHCxK
	4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYxRbzcf1Lq7SmxjG3fPkw+HJ8xmPFsrznhXeuPF
	nHYdiQVTvmrOCjD/9P9qFv+m81KiameZPrznnfzZN3j6H+mkqAMGfyzzu+QXB23z3fZWTLjt
	U1rp7ajiy8d3H+bdb1+9vPDnB8epi2eZhab+1VA315+rWPdHVJPH+qHE/vgc0ZTde0/5Weso
	sRRnJBpqMRcVJwIABrmD+WUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports some dir operations for inline dir, additionally introduces
f2fs_drop_nlink from f2fs_delete_entry for reusing by inline dir function.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c      | 71 +++++++++++++++++++++++++++++-------------------------
 fs/f2fs/f2fs.h     | 10 +++++++-
 fs/f2fs/namei.c    |  4 +--
 fs/f2fs/recovery.c |  2 +-
 4 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index b54f871..99e944e 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -37,7 +37,7 @@ static unsigned int bucket_blocks(unsigned int level)
 		return 4;
 }
 
-static unsigned char f2fs_filetype_table[F2FS_FT_MAX] = {
+unsigned char f2fs_filetype_table[F2FS_FT_MAX] = {
 	[F2FS_FT_UNKNOWN]	= DT_UNKNOWN,
 	[F2FS_FT_REG_FILE]	= DT_REG,
 	[F2FS_FT_DIR]		= DT_DIR,
@@ -59,7 +59,7 @@ static unsigned char f2fs_type_by_mode[S_IFMT >> S_SHIFT] = {
 	[S_IFLNK >> S_SHIFT]	= F2FS_FT_SYMLINK,
 };
 
-static void set_de_type(struct f2fs_dir_entry *de, struct inode *inode)
+void set_de_type(struct f2fs_dir_entry *de, struct inode *inode)
 {
 	umode_t mode = inode->i_mode;
 	de->file_type = f2fs_type_by_mode[(mode & S_IFMT) >> S_SHIFT];
@@ -77,7 +77,7 @@ static unsigned long dir_block_index(unsigned int level,
 	return bidx;
 }
 
-static bool early_match_name(size_t namelen, f2fs_hash_t namehash,
+bool early_match_name(size_t namelen, f2fs_hash_t namehash,
 				struct f2fs_dir_entry *de)
 {
 	if (le16_to_cpu(de->name_len) != namelen)
@@ -307,7 +307,6 @@ static int make_empty_dir(struct inode *inode,
 	if (IS_ERR(dentry_page))
 		return PTR_ERR(dentry_page);
 
-
 	dentry_blk = kmap_atomic(dentry_page);
 
 	de = &dentry_blk->dentry[0];
@@ -333,7 +332,7 @@ static int make_empty_dir(struct inode *inode,
 	return 0;
 }
 
-static struct page *init_inode_metadata(struct inode *inode,
+struct page *init_inode_metadata(struct inode *inode,
 		struct inode *dir, const struct qstr *name)
 {
 	struct page *page;
@@ -395,7 +394,7 @@ error:
 	return ERR_PTR(err);
 }
 
-static void update_parent_metadata(struct inode *dir, struct inode *inode,
+void update_parent_metadata(struct inode *dir, struct inode *inode,
 						unsigned int current_depth)
 {
 	if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE)) {
@@ -560,16 +559,44 @@ fail:
 	return err;
 }
 
+void f2fs_drop_nlink(struct inode *dir, struct inode *inode, struct page *page)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
+
+	down_write(&F2FS_I(inode)->i_sem);
+
+	if (S_ISDIR(inode->i_mode)) {
+		drop_nlink(dir);
+		if (page)
+			update_inode(dir, page);
+		else
+			update_inode_page(dir);
+	}
+	inode->i_ctime = CURRENT_TIME;
+
+	drop_nlink(inode);
+	if (S_ISDIR(inode->i_mode)) {
+		drop_nlink(inode);
+		i_size_write(inode, 0);
+	}
+	up_write(&F2FS_I(inode)->i_sem);
+	update_inode_page(inode);
+
+	if (inode->i_nlink == 0)
+		add_orphan_inode(sbi, inode->i_ino);
+	else
+		release_orphan_inode(sbi);
+}
+
 /*
  * It only removes the dentry from the dentry page, corresponding name
  * entry in name page does not need to be touched during deletion.
  */
 void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
-						struct inode *inode)
+					struct inode *dir, struct inode *inode)
 {
 	struct	f2fs_dentry_block *dentry_blk;
 	unsigned int bit_pos;
-	struct inode *dir = page->mapping->host;
 	int slots = GET_DENTRY_SLOTS(le16_to_cpu(dentry->name_len));
 	int i;
 
@@ -590,29 +617,8 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 
-	if (inode) {
-		struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
-
-		down_write(&F2FS_I(inode)->i_sem);
-
-		if (S_ISDIR(inode->i_mode)) {
-			drop_nlink(dir);
-			update_inode_page(dir);
-		}
-		inode->i_ctime = CURRENT_TIME;
-		drop_nlink(inode);
-		if (S_ISDIR(inode->i_mode)) {
-			drop_nlink(inode);
-			i_size_write(inode, 0);
-		}
-		up_write(&F2FS_I(inode)->i_sem);
-		update_inode_page(inode);
-
-		if (inode->i_nlink == 0)
-			add_orphan_inode(sbi, inode->i_ino);
-		else
-			release_orphan_inode(sbi);
-	}
+	if (inode)
+		f2fs_drop_nlink(dir, inode, NULL);
 
 	if (bit_pos == NR_DENTRY_IN_BLOCK) {
 		truncate_hole(dir, page->index, page->index + 1);
@@ -628,7 +634,7 @@ bool f2fs_empty_dir(struct inode *dir)
 	unsigned long bidx;
 	struct page *dentry_page;
 	unsigned int bit_pos;
-	struct	f2fs_dentry_block *dentry_blk;
+	struct f2fs_dentry_block *dentry_blk;
 	unsigned long nblock = dir_blocks(dir);
 
 	for (bidx = 0; bidx < nblock; bidx++) {
@@ -640,7 +646,6 @@ bool f2fs_empty_dir(struct inode *dir)
 				return false;
 		}
 
-
 		dentry_blk = kmap_atomic(dentry_page);
 		if (bidx == 0)
 			bit_pos = 2;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b94721c..8e819b0 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1220,6 +1220,13 @@ struct dentry *f2fs_get_parent(struct dentry *child);
 /*
  * dir.c
  */
+extern unsigned char f2fs_filetype_table[F2FS_FT_MAX];
+bool early_match_name(size_t, f2fs_hash_t, struct f2fs_dir_entry *);
+void set_de_type(struct f2fs_dir_entry *, struct inode *);
+struct page *init_inode_metadata(struct inode *, struct inode *,
+							const struct qstr *);
+void update_parent_metadata(struct inode *, struct inode *, unsigned int);
+void f2fs_drop_nlink(struct inode *, struct inode *, struct page *);
 struct f2fs_dir_entry *f2fs_find_entry(struct inode *, struct qstr *,
 							struct page **);
 struct f2fs_dir_entry *f2fs_parent_dir(struct inode *, struct page **);
@@ -1228,7 +1235,8 @@ void f2fs_set_link(struct inode *, struct f2fs_dir_entry *,
 				struct page *, struct inode *);
 int update_dent_inode(struct inode *, const struct qstr *);
 int __f2fs_add_link(struct inode *, const struct qstr *, struct inode *);
-void f2fs_delete_entry(struct f2fs_dir_entry *, struct page *, struct inode *);
+void f2fs_delete_entry(struct f2fs_dir_entry *, struct page *, struct inode *,
+							struct inode *);
 int f2fs_do_tmpfile(struct inode *, struct inode *);
 int f2fs_make_empty(struct inode *, struct inode *);
 bool f2fs_empty_dir(struct inode *);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index ba0779d..58c1276 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -224,7 +224,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 		f2fs_put_page(page, 0);
 		goto fail;
 	}
-	f2fs_delete_entry(de, page, inode);
+	f2fs_delete_entry(de, page, dir, inode);
 	f2fs_unlock_op(sbi);
 
 	/* In order to evict this inode, we set it dirty */
@@ -442,7 +442,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(old_inode);
 
-	f2fs_delete_entry(old_entry, old_page, NULL);
+	f2fs_delete_entry(old_entry, old_page, old_dir, NULL);
 
 	if (old_dir_entry) {
 		if (old_dir != new_dir) {
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 4189003..fdbcea4 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -111,7 +111,7 @@ retry:
 			iput(einode);
 			goto out_unmap_put;
 		}
-		f2fs_delete_entry(de, page, einode);
+		f2fs_delete_entry(de, page, dir, einode);
 		iput(einode);
 		goto retry;
 	}
-- 
2.0.1.474.g72c7794


