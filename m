Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbaHICrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 22:47:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58867 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaHICrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 22:47:52 -0400
X-AuditID: cbfee61b-f79f86d00000144c-67-53e58bd6594b
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/5] f2fs: export dir operations for inline dir
Date: Sat, 09 Aug 2014 10:47:02 +0800
Message-id: <00c001cfb37c$4ceb7650$e6c262f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+yuaICFWNi5FjFRJ+JuQ7/dhCB3w==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd1r3U+DDV4d47O4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxotpV1gL
	NhpU3Ht/hrmBcY16FyMnh4SAicSxM09ZIWwxiQv31rN1MXJxCAksYpR4OfUgE4Tzg1FifetT
	NpAqNgEVieUd/5lAbBEBL4lJ+0+wgNjMAh4SjR3fwSYJC3hK7OyczAxiswioStw9f5cRxOYV
	sJS41H4ayhaU+DH5HlSvlsTmbU2sELa8xOY1b5khLlKQ2HH2NSPELj2J3muzmCFqxCU2HrnF
	MoFRYBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQH9TPpHYyr
	GiwOMQpwMCrx8K6weRosxJpYVlyZe4hRgoNZSYR3YSVQiDclsbIqtSg/vqg0J7X4EKM0B4uS
	OO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA6Od6YuXumsMVFZvur+K9auCh7Rx29xfczP8Hn7p
	eLBXitOA3+9isPxn17nBmkuKgraxi05ZsZvnVY/rjnz9G2piNd9fvrApXXTi4beWarEst+tN
	D1y3RB0M5Ha6rhdtdUkqsifH3mGlxlWOCzce7U74Wv1F3OV7ZbJ2f/L0lqVt07l55M/Fyymx
	FGckGmoxFxUnAgAZBevtZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch export and share some static functions and array in dir.c for inline
dir functions.

Additionally add a parameter in f2fs_delete_entry to pass dir inode from caller
instead of acquiring from page for inline dir op.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c      | 22 ++++++++++------------
 fs/f2fs/f2fs.h     |  9 ++++++++-
 fs/f2fs/namei.c    |  4 ++--
 fs/f2fs/recovery.c |  2 +-
 4 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index bcf893c..154a5fa 100644
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
@@ -308,7 +308,6 @@ static int make_empty_dir(struct inode *inode,
 	if (IS_ERR(dentry_page))
 		return PTR_ERR(dentry_page);
 
-
 	dentry_blk = kmap_atomic(dentry_page);
 
 	de = &dentry_blk->dentry[0];
@@ -334,7 +333,7 @@ static int make_empty_dir(struct inode *inode,
 	return 0;
 }
 
-static struct page *init_inode_metadata(struct inode *inode,
+struct page *init_inode_metadata(struct inode *inode,
 		struct inode *dir, const struct qstr *name)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
@@ -397,7 +396,7 @@ error:
 	return ERR_PTR(err);
 }
 
-static void update_parent_metadata(struct inode *dir, struct inode *inode,
+void update_parent_metadata(struct inode *dir, struct inode *inode,
 						unsigned int current_depth)
 {
 	if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE)) {
@@ -567,12 +566,10 @@ fail:
  * entry in name page does not need to be touched during deletion.
  */
 void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
-						struct inode *inode)
+					struct inode *dir, struct inode *inode)
 {
 	struct	f2fs_dentry_block *dentry_blk;
-	unsigned int bit_pos;
-	struct address_space *mapping = page->mapping;
-	struct inode *dir = mapping->host;
+	unsigned int bit_pos = 0;
 	int slots = GET_DENTRY_SLOTS(le16_to_cpu(dentry->name_len));
 	int i;
 
@@ -631,7 +628,7 @@ bool f2fs_empty_dir(struct inode *dir)
 	unsigned long bidx;
 	struct page *dentry_page;
 	unsigned int bit_pos;
-	struct	f2fs_dentry_block *dentry_blk;
+	struct f2fs_dentry_block *dentry_blk;
 	unsigned long nblock = dir_blocks(dir);
 
 	for (bidx = 0; bidx < nblock; bidx++) {
@@ -643,7 +640,6 @@ bool f2fs_empty_dir(struct inode *dir)
 				return false;
 		}
 
-
 		dentry_blk = kmap_atomic(dentry_page);
 		if (bidx == 0)
 			bit_pos = 2;
@@ -705,6 +701,8 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 					le32_to_cpu(de->ino), d_type))
 				goto stop;
 
+			f2fs_bug_on(!de->name_len);
+
 			bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 			ctx->pos = n * NR_DENTRY_IN_BLOCK + bit_pos;
 		}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 4dab533..58c1a49 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1145,6 +1145,12 @@ struct dentry *f2fs_get_parent(struct dentry *child);
 /*
  * dir.c
  */
+extern unsigned char f2fs_filetype_table[F2FS_FT_MAX];
+bool early_match_name(size_t, f2fs_hash_t, struct f2fs_dir_entry *);
+void set_de_type(struct f2fs_dir_entry *, struct inode *);
+struct page *init_inode_metadata(struct inode *, struct inode *,
+							const struct qstr *);
+void update_parent_metadata(struct inode *, struct inode *, unsigned int);
 struct f2fs_dir_entry *f2fs_find_entry(struct inode *, struct qstr *,
 							struct page **);
 struct f2fs_dir_entry *f2fs_parent_dir(struct inode *, struct page **);
@@ -1153,7 +1159,8 @@ void f2fs_set_link(struct inode *, struct f2fs_dir_entry *,
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
index 27b0377..648b968 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -226,7 +226,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 		f2fs_put_page(page, 0);
 		goto fail;
 	}
-	f2fs_delete_entry(de, page, inode);
+	f2fs_delete_entry(de, page, dir, inode);
 	f2fs_unlock_op(sbi);
 
 	/* In order to evict this inode,  we set it dirty */
@@ -450,7 +450,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(old_inode);
 
-	f2fs_delete_entry(old_entry, old_page, NULL);
+	f2fs_delete_entry(old_entry, old_page, old_dir, NULL);
 
 	if (old_dir_entry) {
 		if (old_dir != new_dir) {
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index fe1c6d9..6f7d5a1 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -78,7 +78,7 @@ retry:
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


