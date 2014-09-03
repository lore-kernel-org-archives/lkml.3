Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaICFE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:04:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:37788 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbaICFCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:02:39 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/6] f2fs: introduce F2FS_I_SB, F2FS_M_SB, and F2FS_P_SB
Date: Tue,  2 Sep 2014 22:02:29 -0700
Message-Id: <1409720554-72925-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds three inline functions to clean up dirty casting codes.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 18 +++++++-----------
 fs/f2fs/data.c       | 31 ++++++++++++++-----------------
 fs/f2fs/dir.c        | 13 +++++--------
 fs/f2fs/f2fs.h       | 23 +++++++++++++++++++----
 fs/f2fs/file.c       | 20 ++++++++++----------
 fs/f2fs/inline.c     | 13 +++++--------
 fs/f2fs/inode.c      |  8 ++++----
 fs/f2fs/namei.c      | 21 ++++++++++-----------
 fs/f2fs/node.c       | 43 +++++++++++++++++--------------------------
 fs/f2fs/node.h       |  3 +--
 fs/f2fs/recovery.c   |  2 +-
 fs/f2fs/segment.c    | 14 ++++++--------
 fs/f2fs/segment.h    |  2 +-
 fs/f2fs/xattr.c      |  6 +++---
 14 files changed, 103 insertions(+), 114 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index ec3b7a5..cb5cb4c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -151,8 +151,7 @@ out:
 static int f2fs_write_meta_page(struct page *page,
 				struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_P_SB(page);
 
 	trace_f2fs_writepage(page, META);
 
@@ -177,7 +176,7 @@ redirty_out:
 static int f2fs_write_meta_pages(struct address_space *mapping,
 				struct writeback_control *wbc)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_M_SB(mapping);
 	long diff, written;
 
 	trace_f2fs_writepages(mapping->host, wbc, META);
@@ -259,15 +258,12 @@ continue_unlock:
 
 static int f2fs_set_meta_page_dirty(struct page *page)
 {
-	struct address_space *mapping = page->mapping;
-	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
-
 	trace_f2fs_set_page_dirty(page, META);
 
 	SetPageUptodate(page);
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
-		inc_page_count(sbi, F2FS_DIRTY_META);
+		inc_page_count(F2FS_P_SB(page), F2FS_DIRTY_META);
 		return 1;
 	}
 	return 0;
@@ -619,7 +615,7 @@ fail_no_cp:
 
 static int __add_dirty_inode(struct inode *inode, struct dir_inode_entry *new)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
 	if (is_inode_flag_set(F2FS_I(inode), FI_DIRTY_DIR))
 		return -EEXIST;
@@ -633,7 +629,7 @@ static int __add_dirty_inode(struct inode *inode, struct dir_inode_entry *new)
 
 void set_dirty_dir_page(struct inode *inode, struct page *page)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dir_inode_entry *new;
 	int ret = 0;
 
@@ -656,7 +652,7 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
 
 void add_dirty_dir_inode(struct inode *inode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dir_inode_entry *new =
 			f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
 	int ret = 0;
@@ -674,7 +670,7 @@ void add_dirty_dir_inode(struct inode *inode)
 
 void remove_dirty_dir_inode(struct inode *inode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dir_inode_entry *entry;
 
 	if (!S_ISDIR(inode->i_mode))
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 76de83e..8eb6fca 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -236,7 +236,7 @@ static void __set_data_blkaddr(struct dnode_of_data *dn, block_t new_addr)
 
 int reserve_new_block(struct dnode_of_data *dn)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
 
 	if (unlikely(is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC)))
 		return -EPERM;
@@ -396,7 +396,6 @@ end_update:
 
 struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct address_space *mapping = inode->i_mapping;
 	struct dnode_of_data dn;
 	struct page *page;
@@ -429,7 +428,7 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
 		return page;
 	}
 
-	err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
+	err = f2fs_submit_page_bio(F2FS_I_SB(inode), page, dn.data_blkaddr,
 					sync ? READ_SYNC : READA);
 	if (err)
 		return ERR_PTR(err);
@@ -451,7 +450,6 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
  */
 struct page *get_lock_data_page(struct inode *inode, pgoff_t index)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct address_space *mapping = inode->i_mapping;
 	struct dnode_of_data dn;
 	struct page *page;
@@ -490,7 +488,8 @@ repeat:
 		return page;
 	}
 
-	err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr, READ_SYNC);
+	err = f2fs_submit_page_bio(F2FS_I_SB(inode), page,
+					dn.data_blkaddr, READ_SYNC);
 	if (err)
 		return ERR_PTR(err);
 
@@ -517,7 +516,6 @@ repeat:
 struct page *get_new_data_page(struct inode *inode,
 		struct page *ipage, pgoff_t index, bool new_i_size)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
 	struct dnode_of_data dn;
@@ -541,8 +539,8 @@ repeat:
 		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 		SetPageUptodate(page);
 	} else {
-		err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
-								READ_SYNC);
+		err = f2fs_submit_page_bio(F2FS_I_SB(inode), page,
+						dn.data_blkaddr, READ_SYNC);
 		if (err)
 			goto put_err;
 
@@ -573,7 +571,7 @@ put_err:
 
 static int __allocate_data_block(struct dnode_of_data *dn)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
 	struct f2fs_summary sum;
 	block_t new_blkaddr;
 	struct node_info ni;
@@ -614,7 +612,6 @@ static int __allocate_data_block(struct dnode_of_data *dn)
 static int __get_data_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create, bool fiemap)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	unsigned int blkbits = inode->i_sb->s_blocksize_bits;
 	unsigned maxblocks = bh_result->b_size >> blkbits;
 	struct dnode_of_data dn;
@@ -630,8 +627,8 @@ static int __get_data_block(struct inode *inode, sector_t iblock,
 		goto out;
 
 	if (create) {
-		f2fs_balance_fs(sbi);
-		f2fs_lock_op(sbi);
+		f2fs_balance_fs(F2FS_I_SB(inode));
+		f2fs_lock_op(F2FS_I_SB(inode));
 	}
 
 	/* When reading holes, we need its node page */
@@ -707,7 +704,7 @@ put_out:
 	f2fs_put_dnode(&dn);
 unlock_out:
 	if (create)
-		f2fs_unlock_op(sbi);
+		f2fs_unlock_op(F2FS_I_SB(inode));
 out:
 	trace_f2fs_get_data_block(inode, iblock, bh_result, err);
 	return err;
@@ -804,7 +801,7 @@ static int f2fs_write_data_page(struct page *page,
 					struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = ((unsigned long long) i_size)
 							>> PAGE_CACHE_SHIFT;
@@ -892,7 +889,7 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	bool locked = false;
 	int ret;
 	long diff;
@@ -945,7 +942,7 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 		struct page **pagep, void **fsdata)
 {
 	struct inode *inode = mapping->host;
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct page *page;
 	pgoff_t index = ((unsigned long long) pos) >> PAGE_CACHE_SHIFT;
 	struct dnode_of_data dn;
@@ -1093,7 +1090,7 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 		return 0;
 
 	/* clear fsync mark to recover these blocks */
-	fsync_mark_clear(F2FS_SB(inode->i_sb), inode->i_ino);
+	fsync_mark_clear(F2FS_I_SB(inode), inode->i_ino);
 
 	trace_f2fs_direct_IO_enter(inode, offset, count, rw);
 
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 155fb05..c242904 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -284,10 +284,9 @@ static void init_dent_inode(const struct qstr *name, struct page *ipage)
 
 int update_dent_inode(struct inode *inode, const struct qstr *name)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct page *page;
 
-	page = get_node_page(sbi, inode->i_ino);
+	page = get_node_page(F2FS_I_SB(inode), inode->i_ino);
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 
@@ -337,7 +336,6 @@ static int make_empty_dir(struct inode *inode,
 static struct page *init_inode_metadata(struct inode *inode,
 		struct inode *dir, const struct qstr *name)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
 	struct page *page;
 	int err;
 
@@ -360,7 +358,7 @@ static struct page *init_inode_metadata(struct inode *inode,
 		if (err)
 			goto put_error;
 	} else {
-		page = get_node_page(F2FS_SB(dir->i_sb), inode->i_ino);
+		page = get_node_page(F2FS_I_SB(dir), inode->i_ino);
 		if (IS_ERR(page))
 			return page;
 
@@ -381,7 +379,7 @@ static struct page *init_inode_metadata(struct inode *inode,
 		 * we should remove this inode from orphan list.
 		 */
 		if (inode->i_nlink == 0)
-			remove_orphan_inode(sbi, inode->i_ino);
+			remove_orphan_inode(F2FS_I_SB(dir), inode->i_ino);
 		inc_nlink(inode);
 	}
 	return page;
@@ -571,8 +569,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 {
 	struct	f2fs_dentry_block *dentry_blk;
 	unsigned int bit_pos;
-	struct address_space *mapping = page->mapping;
-	struct inode *dir = mapping->host;
+	struct inode *dir = page->mapping->host;
 	int slots = GET_DENTRY_SLOTS(le16_to_cpu(dentry->name_len));
 	int i;
 
@@ -594,7 +591,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 
 	if (inode) {
-		struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+		struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 
 		down_write(&F2FS_I(inode)->i_sem);
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e921242..222ff5b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -539,6 +539,21 @@ static inline struct f2fs_sb_info *F2FS_SB(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+static inline struct f2fs_sb_info *F2FS_I_SB(struct inode *inode)
+{
+	return F2FS_SB(inode->i_sb);
+}
+
+static inline struct f2fs_sb_info *F2FS_M_SB(struct address_space *mapping)
+{
+	return F2FS_I_SB(mapping->host);
+}
+
+static inline struct f2fs_sb_info *F2FS_P_SB(struct page *page)
+{
+	return F2FS_M_SB(page->mapping);
+}
+
 static inline struct f2fs_super_block *F2FS_RAW_SUPER(struct f2fs_sb_info *sbi)
 {
 	return (struct f2fs_super_block *)(sbi->raw_super);
@@ -718,7 +733,7 @@ static inline void inc_page_count(struct f2fs_sb_info *sbi, int count_type)
 
 static inline void inode_inc_dirty_dents(struct inode *inode)
 {
-	inc_page_count(F2FS_SB(inode->i_sb), F2FS_DIRTY_DENTS);
+	inc_page_count(F2FS_I_SB(inode), F2FS_DIRTY_DENTS);
 	atomic_inc(&F2FS_I(inode)->dirty_dents);
 }
 
@@ -732,7 +747,7 @@ static inline void inode_dec_dirty_dents(struct inode *inode)
 	if (!S_ISDIR(inode->i_mode))
 		return;
 
-	dec_page_count(F2FS_SB(inode->i_sb), F2FS_DIRTY_DENTS);
+	dec_page_count(F2FS_I_SB(inode), F2FS_DIRTY_DENTS);
 	atomic_dec(&F2FS_I(inode)->dirty_dents);
 }
 
@@ -1359,12 +1374,12 @@ static inline struct f2fs_stat_info *F2FS_STAT(struct f2fs_sb_info *sbi)
 #define stat_inc_inline_inode(inode)					\
 	do {								\
 		if (f2fs_has_inline_data(inode))			\
-			((F2FS_SB(inode->i_sb))->inline_inode++);	\
+			((F2FS_I_SB(inode))->inline_inode++);		\
 	} while (0)
 #define stat_dec_inline_inode(inode)					\
 	do {								\
 		if (f2fs_has_inline_data(inode))			\
-			((F2FS_SB(inode->i_sb))->inline_inode--);	\
+			((F2FS_I_SB(inode))->inline_inode--);		\
 	} while (0)
 
 #define stat_inc_seg_type(sbi, curseg)					\
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 060aee6..411f053 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -33,7 +33,7 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 {
 	struct page *page = vmf->page;
 	struct inode *inode = file_inode(vma->vm_file);
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dnode_of_data dn;
 	int err;
 
@@ -117,7 +117,7 @@ static int get_parent_ino(struct inode *inode, nid_t *pino)
 
 static inline bool need_do_checkpoint(struct inode *inode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	bool need_cp = false;
 
 	if (!S_ISREG(inode->i_mode) || inode->i_nlink != 1)
@@ -138,7 +138,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	struct f2fs_inode_info *fi = F2FS_I(inode);
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	int ret = 0;
 	bool need_cp = false;
 	struct writeback_control wbc = {
@@ -226,7 +226,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 flush_out:
 		remove_dirty_inode(sbi, inode->i_ino, UPDATE_INO);
 		clear_inode_flag(fi, FI_UPDATE_WRITE);
-		ret = f2fs_issue_flush(F2FS_SB(inode->i_sb));
+		ret = f2fs_issue_flush(F2FS_I_SB(inode));
 	}
 out:
 	trace_f2fs_sync_file_exit(inode, need_cp, datasync, ret);
@@ -369,7 +369,7 @@ static int f2fs_file_mmap(struct file *file, struct vm_area_struct *vma)
 int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
 {
 	int nr_free = 0, ofs = dn->ofs_in_node;
-	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
 	struct f2fs_node *raw_node;
 	__le32 *addr;
 
@@ -432,7 +432,7 @@ out:
 
 int truncate_blocks(struct inode *inode, u64 from, bool lock)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	unsigned int blocksize = inode->i_sb->s_blocksize;
 	struct dnode_of_data dn;
 	pgoff_t free_from;
@@ -555,7 +555,7 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 
 		truncate_setsize(inode, attr->ia_size);
 		f2fs_truncate(inode);
-		f2fs_balance_fs(F2FS_SB(inode->i_sb));
+		f2fs_balance_fs(F2FS_I_SB(inode));
 	}
 
 	__setattr_copy(inode, attr);
@@ -589,7 +589,7 @@ const struct inode_operations f2fs_file_inode_operations = {
 static void fill_zero(struct inode *inode, pgoff_t index,
 					loff_t start, loff_t len)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct page *page;
 
 	if (!len)
@@ -661,7 +661,7 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		if (pg_start < pg_end) {
 			struct address_space *mapping = inode->i_mapping;
 			loff_t blk_start, blk_end;
-			struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+			struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
 			f2fs_balance_fs(sbi);
 
@@ -682,7 +682,7 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
 static int expand_inode_data(struct inode *inode, loff_t offset,
 					loff_t len, int mode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	pgoff_t index, pg_start, pg_end;
 	loff_t new_size = i_size_read(inode);
 	loff_t off_start, off_end;
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 3e8ecdf..289f99e 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -15,11 +15,10 @@
 
 bool f2fs_may_inline(struct inode *inode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	block_t nr_blocks;
 	loff_t i_size;
 
-	if (!test_opt(sbi, INLINE_DATA))
+	if (!test_opt(F2FS_I_SB(inode), INLINE_DATA))
 		return false;
 
 	nr_blocks = F2FS_I(inode)->i_xattr_nid ? 3 : 2;
@@ -35,7 +34,6 @@ bool f2fs_may_inline(struct inode *inode)
 
 int f2fs_read_inline_data(struct inode *inode, struct page *page)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct page *ipage;
 	void *src_addr, *dst_addr;
 
@@ -44,7 +42,7 @@ int f2fs_read_inline_data(struct inode *inode, struct page *page)
 		goto out;
 	}
 
-	ipage = get_node_page(sbi, inode->i_ino);
+	ipage = get_node_page(F2FS_I_SB(inode), inode->i_ino);
 	if (IS_ERR(ipage)) {
 		unlock_page(page);
 		return PTR_ERR(ipage);
@@ -73,7 +71,7 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 	struct dnode_of_data dn;
 	void *src_addr, *dst_addr;
 	block_t new_blk_addr;
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_io_info fio = {
 		.type = DATA,
 		.rw = WRITE_SYNC | REQ_PRIO,
@@ -189,13 +187,12 @@ int f2fs_write_inline_data(struct inode *inode,
 
 void truncate_inline_data(struct inode *inode, u64 from)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct page *ipage;
 
 	if (from >= MAX_INLINE_DATA)
 		return;
 
-	ipage = get_node_page(sbi, inode->i_ino);
+	ipage = get_node_page(F2FS_I_SB(inode), inode->i_ino);
 	if (IS_ERR(ipage))
 		return;
 
@@ -209,7 +206,7 @@ void truncate_inline_data(struct inode *inode, u64 from)
 
 bool recover_inline_data(struct inode *inode, struct page *npage)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_inode *ri = NULL;
 	void *src_addr, *dst_addr;
 	struct page *ipage;
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 2c39999..bf99e1f 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -69,7 +69,7 @@ static void __set_inode_rdev(struct inode *inode, struct f2fs_inode *ri)
 
 static int do_read_inode(struct inode *inode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct page *node_page;
 	struct f2fs_inode *ri;
@@ -218,7 +218,7 @@ void update_inode(struct inode *inode, struct page *node_page)
 
 void update_inode_page(struct inode *inode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct page *node_page;
 retry:
 	node_page = get_node_page(sbi, inode->i_ino);
@@ -238,7 +238,7 @@ retry:
 
 int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
 	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
 			inode->i_ino == F2FS_META_INO(sbi))
@@ -266,7 +266,7 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
  */
 void f2fs_evict_inode(struct inode *inode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
 
 	trace_f2fs_evict_inode(inode);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index ee103fd..ba0779d 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -23,7 +23,7 @@
 
 static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	nid_t ino;
 	struct inode *inode;
 	bool nid_free = false;
@@ -102,7 +102,7 @@ static inline void set_cold_files(struct f2fs_sb_info *sbi, struct inode *inode,
 static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 						bool excl)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	struct inode *inode;
 	nid_t ino = 0;
 	int err;
@@ -143,7 +143,7 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
 		struct dentry *dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
-	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	int err;
 
 	f2fs_balance_fs(sbi);
@@ -203,7 +203,7 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 
 static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	struct inode *inode = dentry->d_inode;
 	struct f2fs_dir_entry *de;
 	struct page *page;
@@ -237,7 +237,7 @@ fail:
 static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
 					const char *symname)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	struct inode *inode;
 	size_t symlen = strlen(symname) + 1;
 	int err;
@@ -272,7 +272,7 @@ out:
 
 static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	struct inode *inode;
 	int err;
 
@@ -320,7 +320,7 @@ static int f2fs_rmdir(struct inode *dir, struct dentry *dentry)
 static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
 				umode_t mode, dev_t rdev)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	struct inode *inode;
 	int err = 0;
 
@@ -356,7 +356,7 @@ out:
 static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(old_dir->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(old_dir);
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
 	struct page *old_dir_page;
@@ -480,8 +480,7 @@ out:
 static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 			     struct inode *new_dir, struct dentry *new_dentry)
 {
-	struct super_block *sb = old_dir->i_sb;
-	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(old_dir);
 	struct inode *old_inode = old_dentry->d_inode;
 	struct inode *new_inode = new_dentry->d_inode;
 	struct page *old_dir_page, *new_dir_page;
@@ -642,7 +641,7 @@ static int f2fs_rename2(struct inode *old_dir, struct dentry *old_dentry,
 
 static int f2fs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	struct inode *inode;
 	int err;
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 4537819..725a471 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -54,7 +54,6 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
 static void clear_node_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
-	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
 	unsigned int long flags;
 
 	if (PageDirty(page)) {
@@ -65,7 +64,7 @@ static void clear_node_page_dirty(struct page *page)
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 
 		clear_page_dirty_for_io(page);
-		dec_page_count(sbi, F2FS_DIRTY_NODES);
+		dec_page_count(F2FS_M_SB(mapping), F2FS_DIRTY_NODES);
 	}
 	ClearPageUptodate(page);
 }
@@ -411,7 +410,7 @@ got:
  */
 int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
 	struct page *npage[4];
 	struct page *parent;
 	int offset[4];
@@ -504,7 +503,7 @@ release_out:
 
 static void truncate_node(struct dnode_of_data *dn)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
 	struct node_info ni;
 
 	get_node_info(sbi, dn->nid, &ni);
@@ -540,14 +539,13 @@ invalidate:
 
 static int truncate_dnode(struct dnode_of_data *dn)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
 	struct page *page;
 
 	if (dn->nid == 0)
 		return 1;
 
 	/* get direct node */
-	page = get_node_page(sbi, dn->nid);
+	page = get_node_page(F2FS_I_SB(dn->inode), dn->nid);
 	if (IS_ERR(page) && PTR_ERR(page) == -ENOENT)
 		return 1;
 	else if (IS_ERR(page))
@@ -564,7 +562,6 @@ static int truncate_dnode(struct dnode_of_data *dn)
 static int truncate_nodes(struct dnode_of_data *dn, unsigned int nofs,
 						int ofs, int depth)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
 	struct dnode_of_data rdn = *dn;
 	struct page *page;
 	struct f2fs_node *rn;
@@ -578,7 +575,7 @@ static int truncate_nodes(struct dnode_of_data *dn, unsigned int nofs,
 
 	trace_f2fs_truncate_nodes_enter(dn->inode, dn->nid, dn->data_blkaddr);
 
-	page = get_node_page(sbi, dn->nid);
+	page = get_node_page(F2FS_I_SB(dn->inode), dn->nid);
 	if (IS_ERR(page)) {
 		trace_f2fs_truncate_nodes_exit(dn->inode, PTR_ERR(page));
 		return PTR_ERR(page);
@@ -636,7 +633,6 @@ out_err:
 static int truncate_partial_nodes(struct dnode_of_data *dn,
 			struct f2fs_inode *ri, int *offset, int depth)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
 	struct page *pages[2];
 	nid_t nid[3];
 	nid_t child_nid;
@@ -651,7 +647,7 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
 	/* get indirect nodes in the path */
 	for (i = 0; i < idx + 1; i++) {
 		/* reference count'll be increased */
-		pages[i] = get_node_page(sbi, nid[i]);
+		pages[i] = get_node_page(F2FS_I_SB(dn->inode), nid[i]);
 		if (IS_ERR(pages[i])) {
 			err = PTR_ERR(pages[i]);
 			idx = i - 1;
@@ -696,7 +692,7 @@ fail:
  */
 int truncate_inode_blocks(struct inode *inode, pgoff_t from)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	int err = 0, cont = 1;
 	int level, offset[4], noffset[4];
 	unsigned int nofs = 0;
@@ -792,7 +788,7 @@ fail:
 
 int truncate_xattr_node(struct inode *inode, struct page *page)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	nid_t nid = F2FS_I(inode)->i_xattr_nid;
 	struct dnode_of_data dn;
 	struct page *npage;
@@ -860,7 +856,7 @@ struct page *new_inode_page(struct inode *inode)
 struct page *new_node_page(struct dnode_of_data *dn,
 				unsigned int ofs, struct page *ipage)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
 	struct node_info old_ni, new_ni;
 	struct page *page;
 	int err;
@@ -918,7 +914,7 @@ fail:
  */
 static int read_node_page(struct page *page, int rw)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_P_SB(page);
 	struct node_info ni;
 
 	get_node_info(sbi, page->index, &ni);
@@ -994,7 +990,7 @@ got_it:
  */
 struct page *get_node_page_ra(struct page *parent, int start)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(parent->mapping->host->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_P_SB(parent);
 	struct blk_plug plug;
 	struct page *page;
 	int err, i, end;
@@ -1206,7 +1202,7 @@ int wait_on_node_pages_writeback(struct f2fs_sb_info *sbi, nid_t ino)
 static int f2fs_write_node_page(struct page *page,
 				struct writeback_control *wbc)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_P_SB(page);
 	nid_t nid;
 	block_t new_addr;
 	struct node_info ni;
@@ -1257,7 +1253,7 @@ redirty_out:
 static int f2fs_write_node_pages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_M_SB(mapping);
 	long diff;
 
 	trace_f2fs_writepages(mapping->host, wbc, NODE);
@@ -1282,15 +1278,12 @@ skip_write:
 
 static int f2fs_set_node_page_dirty(struct page *page)
 {
-	struct address_space *mapping = page->mapping;
-	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
-
 	trace_f2fs_set_page_dirty(page, NODE);
 
 	SetPageUptodate(page);
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
-		inc_page_count(sbi, F2FS_DIRTY_NODES);
+		inc_page_count(F2FS_P_SB(page), F2FS_DIRTY_NODES);
 		SetPagePrivate(page);
 		return 1;
 	}
@@ -1301,9 +1294,8 @@ static void f2fs_invalidate_node_page(struct page *page, unsigned int offset,
 				      unsigned int length)
 {
 	struct inode *inode = page->mapping->host;
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	if (PageDirty(page))
-		dec_page_count(sbi, F2FS_DIRTY_NODES);
+		dec_page_count(F2FS_I_SB(inode), F2FS_DIRTY_NODES);
 	ClearPagePrivate(page);
 }
 
@@ -1551,13 +1543,12 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
 
 void recover_inline_xattr(struct inode *inode, struct page *page)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	void *src_addr, *dst_addr;
 	size_t inline_size;
 	struct page *ipage;
 	struct f2fs_inode *ri;
 
-	ipage = get_node_page(sbi, inode->i_ino);
+	ipage = get_node_page(F2FS_I_SB(inode), inode->i_ino);
 	f2fs_bug_on(IS_ERR(ipage));
 
 	ri = F2FS_INODE(page);
@@ -1579,7 +1570,7 @@ update_inode:
 
 void recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	nid_t prev_xnid = F2FS_I(inode)->i_xattr_nid;
 	nid_t new_xnid = nid_of_node(page);
 	struct node_info ni;
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 8a116a4..b24f588 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -197,8 +197,7 @@ static inline void copy_node_footer(struct page *dst, struct page *src)
 
 static inline void fill_node_footer_blkaddr(struct page *page, block_t blkaddr)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
-	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
+	struct f2fs_checkpoint *ckpt = F2FS_CKPT(F2FS_P_SB(page));
 	struct f2fs_node *rn = F2FS_NODE(page);
 
 	rn->footer.cp_ver = ckpt->checkpoint_ver;
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 756c41c..5c095f7 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -75,7 +75,7 @@ retry:
 				err = -EEXIST;
 			goto out_unmap_put;
 		}
-		err = acquire_orphan_inode(F2FS_SB(inode->i_sb));
+		err = acquire_orphan_inode(F2FS_I_SB(inode));
 		if (err) {
 			iput(einode);
 			goto out_unmap_put;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 0aa337c..a270726 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -953,15 +953,14 @@ static int __get_segment_type_6(struct page *page, enum page_type p_type)
 
 static int __get_segment_type(struct page *page, enum page_type p_type)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
-	switch (sbi->active_logs) {
+	switch (F2FS_P_SB(page)->active_logs) {
 	case 2:
 		return __get_segment_type_2(page, p_type);
 	case 4:
 		return __get_segment_type_4(page, p_type);
 	}
 	/* NR_CURSEG_TYPE(6) logs by default */
-	f2fs_bug_on(sbi->active_logs != NR_CURSEG_TYPE);
+	f2fs_bug_on(F2FS_P_SB(page)->active_logs != NR_CURSEG_TYPE);
 	return __get_segment_type_6(page, p_type);
 }
 
@@ -1041,7 +1040,7 @@ void write_node_page(struct f2fs_sb_info *sbi, struct page *page,
 void write_data_page(struct page *page, struct dnode_of_data *dn,
 		block_t *new_blkaddr, struct f2fs_io_info *fio)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
 	struct f2fs_summary sum;
 	struct node_info ni;
 
@@ -1055,9 +1054,7 @@ void write_data_page(struct page *page, struct dnode_of_data *dn,
 void rewrite_data_page(struct page *page, block_t old_blkaddr,
 					struct f2fs_io_info *fio)
 {
-	struct inode *inode = page->mapping->host;
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	f2fs_submit_page_mbio(sbi, page, old_blkaddr, fio);
+	f2fs_submit_page_mbio(F2FS_P_SB(page), page, old_blkaddr, fio);
 }
 
 void recover_data_page(struct f2fs_sb_info *sbi,
@@ -1130,8 +1127,9 @@ out:
 void f2fs_wait_on_page_writeback(struct page *page,
 				enum page_type type)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
 	if (PageWriteback(page)) {
+		struct f2fs_sb_info *sbi = F2FS_P_SB(page);
+
 		if (is_merged_page(sbi, page, type))
 			f2fs_submit_merged_bio(sbi, type, WRITE);
 		wait_on_page_writeback(page);
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index ff48325..793ca27 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -480,7 +480,7 @@ enum {
 
 static inline bool need_inplace_update(struct inode *inode)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
 	/* IPU can be done only for the user data */
 	if (S_ISDIR(inode->i_mode))
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 728a5dc..d92a47d 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -266,7 +266,7 @@ static struct f2fs_xattr_entry *__find_xattr(void *base_addr, int index,
 
 static void *read_all_xattrs(struct inode *inode, struct page *ipage)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_xattr_header *header;
 	size_t size = PAGE_SIZE, inline_size = 0;
 	void *txattr_addr;
@@ -325,7 +325,7 @@ fail:
 static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
 				void *txattr_addr, struct page *ipage)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	size_t inline_size = 0;
 	void *xattr_addr;
 	struct page *xpage;
@@ -596,7 +596,7 @@ int f2fs_setxattr(struct inode *inode, int index, const char *name,
 				const void *value, size_t size,
 				struct page *ipage, int flags)
 {
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	int err;
 
 	/* this case is only from init_inode_metadata */
-- 
1.8.5.2 (Apple Git-48)

