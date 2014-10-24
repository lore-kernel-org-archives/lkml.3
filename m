Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaJXGO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:14:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:37393 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaJXGOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:14:25 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: revisit inline_data to avoid data races and potential bugs
Date: Thu, 23 Oct 2014 23:14:19 -0700
Message-Id: <1414131259-53454-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies the inline_data usage with the following rule.
1. inline_data is set during the file creation.
2. If new data is requested to be written ranges out of inline_data,
 f2fs converts that inode permanently.
3. There is no cases which converts non-inline_data inode to inline_data.
4. The inline_data flag should be changed under inode page lock.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c          |  89 +++++++++++------------
 fs/f2fs/f2fs.h          |  18 ++++-
 fs/f2fs/file.c          |  81 +++++++++------------
 fs/f2fs/inline.c        | 188 +++++++++++++++++++++++++-----------------------
 fs/f2fs/namei.c         |   3 +
 include/linux/f2fs_fs.h |   1 +
 6 files changed, 193 insertions(+), 187 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index e3788bd..ceee1a6 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -737,14 +737,14 @@ int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 static int f2fs_read_data_page(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
-	int ret;
+	int ret = -EAGAIN;
 
 	trace_f2fs_readpage(page, DATA);
 
 	/* If the file has inline data, try to read it directly */
 	if (f2fs_has_inline_data(inode))
 		ret = f2fs_read_inline_data(inode, page);
-	else
+	if (ret == -EAGAIN)
 		ret = mpage_readpage(page, get_data_block);
 
 	return ret;
@@ -856,10 +856,11 @@ write:
 	else if (has_not_enough_free_secs(sbi, 0))
 		goto redirty_out;
 
+	err = -EAGAIN;
 	f2fs_lock_op(sbi);
-	if (f2fs_has_inline_data(inode) || f2fs_may_inline(inode))
-		err = f2fs_write_inline_data(inode, page, offset);
-	else
+	if (f2fs_has_inline_data(inode))
+		err = f2fs_write_inline_data(inode, page);
+	if (err == -EAGAIN)
 		err = do_write_data_page(page, &fio);
 	f2fs_unlock_op(sbi);
 done:
@@ -957,24 +958,14 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 
 	f2fs_balance_fs(sbi);
 repeat:
-	err = f2fs_convert_inline_data(inode, pos + len, NULL);
-	if (err)
-		goto fail;
-
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
 		err = -ENOMEM;
 		goto fail;
 	}
 
-	/* to avoid latency during memory pressure */
-	unlock_page(page);
-
 	*pagep = page;
 
-	if (f2fs_has_inline_data(inode) && (pos + len) <= MAX_INLINE_DATA)
-		goto inline_data;
-
 	f2fs_lock_op(sbi);
 
 	/* check inline_data */
@@ -982,32 +973,42 @@ repeat:
 	if (IS_ERR(ipage))
 		goto unlock_fail;
 
+	set_new_dnode(&dn, inode, ipage, ipage, 0);
+
 	if (f2fs_has_inline_data(inode)) {
-		f2fs_put_page(ipage, 1);
-		f2fs_unlock_op(sbi);
-		f2fs_put_page(page, 0);
-		goto repeat;
+		if (pos + len <= MAX_INLINE_DATA) {
+			read_inline_data(page, ipage);
+			set_inode_flag(F2FS_I(inode), FI_DATA_EXIST);
+			sync_inode_page(&dn);
+			goto put_next;
+		} else if (page->index == 0) {
+			err = f2fs_convert_inline_page(&dn, page);
+			if (err)
+				goto unlock_fail;
+		} else {
+			struct page *p = grab_cache_page(inode->i_mapping, 0);
+			if (!p) {
+				err = -ENOMEM;
+				goto unlock_fail;
+			}
+			err = f2fs_convert_inline_page(&dn, p);
+			f2fs_put_page(p, 1);
+			if (err)
+				goto unlock_fail;
+		}
 	}
-
-	set_new_dnode(&dn, inode, ipage, NULL, 0);
 	err = f2fs_reserve_block(&dn, index);
 	if (err)
 		goto unlock_fail;
+put_next:
 	f2fs_put_dnode(&dn);
 	f2fs_unlock_op(sbi);
 
-inline_data:
-	lock_page(page);
-	if (unlikely(page->mapping != mapping)) {
-		f2fs_put_page(page, 1);
-		goto repeat;
-	}
-
-	f2fs_wait_on_page_writeback(page, DATA);
-
 	if ((len == PAGE_CACHE_SIZE) || PageUptodate(page))
 		return 0;
 
+	f2fs_wait_on_page_writeback(page, DATA);
+
 	if ((pos & PAGE_CACHE_MASK) >= i_size_read(inode)) {
 		unsigned start = pos & (PAGE_CACHE_SIZE - 1);
 		unsigned end = start + len;
@@ -1017,13 +1018,7 @@ inline_data:
 		goto out;
 	}
 
-	if (f2fs_has_inline_data(inode)) {
-		err = f2fs_read_inline_data(inode, page);
-		if (err) {
-			page_cache_release(page);
-			goto fail;
-		}
-	} else if (dn.data_blkaddr == NEW_ADDR) {
+	if (dn.data_blkaddr == NEW_ADDR) {
 		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 	} else {
 		err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
@@ -1049,7 +1044,7 @@ out:
 
 unlock_fail:
 	f2fs_unlock_op(sbi);
-	f2fs_put_page(page, 0);
+	f2fs_put_page(page, 1);
 fail:
 	f2fs_write_failed(mapping, pos + len);
 	return err;
@@ -1102,9 +1097,12 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 	size_t count = iov_iter_count(iter);
 	int err;
 
-	/* Let buffer I/O handle the inline data case. */
-	if (f2fs_has_inline_data(inode))
-		return 0;
+	/* we don't need to use inline_data strictly */
+	if (f2fs_has_inline_data(inode)) {
+		err = f2fs_convert_inline_inode(inode);
+		if (err)
+			return err;
+	}
 
 	if (check_direct_IO(inode, rw, iter, offset))
 		return 0;
@@ -1170,9 +1168,12 @@ static sector_t f2fs_bmap(struct address_space *mapping, sector_t block)
 {
 	struct inode *inode = mapping->host;
 
-	if (f2fs_has_inline_data(inode))
-		return 0;
-
+	/* we don't need to use inline_data strictly */
+	if (f2fs_has_inline_data(inode)) {
+		int err = f2fs_convert_inline_inode(inode);
+		if (err)
+			return err;
+	}
 	return generic_block_bmap(mapping, block, get_data_block);
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2e9d2e3..3c13ad2 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1101,6 +1101,7 @@ enum {
 	FI_NEED_IPU,		/* used for ipu per file */
 	FI_ATOMIC_FILE,		/* indicate atomic file */
 	FI_VOLATILE_FILE,	/* indicate volatile file */
+	FI_DATA_EXIST,		/* indicate data exists */
 };
 
 static inline void set_inode_flag(struct f2fs_inode_info *fi, int flag)
@@ -1135,6 +1136,8 @@ static inline void get_inline_info(struct f2fs_inode_info *fi,
 		set_inode_flag(fi, FI_INLINE_DATA);
 	if (ri->i_inline & F2FS_INLINE_DENTRY)
 		set_inode_flag(fi, FI_INLINE_DENTRY);
+	if (ri->i_inline & F2FS_DATA_EXIST)
+		set_inode_flag(fi, FI_DATA_EXIST);
 }
 
 static inline void set_raw_inline(struct f2fs_inode_info *fi,
@@ -1148,6 +1151,8 @@ static inline void set_raw_inline(struct f2fs_inode_info *fi,
 		ri->i_inline |= F2FS_INLINE_DATA;
 	if (is_inode_flag_set(fi, FI_INLINE_DENTRY))
 		ri->i_inline |= F2FS_INLINE_DENTRY;
+	if (is_inode_flag_set(fi, FI_DATA_EXIST))
+		ri->i_inline |= F2FS_DATA_EXIST;
 }
 
 static inline int f2fs_has_inline_xattr(struct inode *inode)
@@ -1182,6 +1187,11 @@ static inline int f2fs_has_inline_data(struct inode *inode)
 	return is_inode_flag_set(F2FS_I(inode), FI_INLINE_DATA);
 }
 
+static inline int f2fs_exist_data(struct inode *inode)
+{
+	return is_inode_flag_set(F2FS_I(inode), FI_DATA_EXIST);
+}
+
 static inline bool f2fs_is_atomic_file(struct inode *inode)
 {
 	return is_inode_flag_set(F2FS_I(inode), FI_ATOMIC_FILE);
@@ -1590,10 +1600,12 @@ extern const struct inode_operations f2fs_special_inode_operations;
  * inline.c
  */
 bool f2fs_may_inline(struct inode *);
+void read_inline_data(struct page *, struct page *);
 int f2fs_read_inline_data(struct inode *, struct page *);
-int f2fs_convert_inline_data(struct inode *, pgoff_t, struct page *);
-int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
-void truncate_inline_data(struct inode *, u64);
+int f2fs_convert_inline_page(struct dnode_of_data *, struct page *);
+int f2fs_convert_inline_inode(struct inode *);
+int f2fs_write_inline_data(struct inode *, struct page *);
+int truncate_inline_data(struct inode *, u64);
 bool recover_inline_data(struct inode *, struct page *);
 struct f2fs_dir_entry *find_in_inline_dir(struct inode *, struct qstr *,
 							struct page **);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 402e381..3ce88bd 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -35,35 +35,22 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 	struct inode *inode = file_inode(vma->vm_file);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dnode_of_data dn;
-	struct page *ipage;
 	int err;
 
 	f2fs_balance_fs(sbi);
 
 	sb_start_pagefault(inode->i_sb);
-retry:
-	/* force to convert with normal data indices */
-	err = f2fs_convert_inline_data(inode, MAX_INLINE_DATA + 1, page);
-	if (err)
-		goto out;
-
-	/* block allocation */
-	f2fs_lock_op(sbi);
-
-	/* check inline_data */
-	ipage = get_node_page(sbi, inode->i_ino);
-	if (IS_ERR(ipage)) {
-		f2fs_unlock_op(sbi);
-		goto out;
-	}
 
+	/* we don't need to use inline_data strictly */
 	if (f2fs_has_inline_data(inode)) {
-		f2fs_put_page(ipage, 1);
-		f2fs_unlock_op(sbi);
-		goto retry;
+		err = f2fs_convert_inline_inode(inode);
+		if (err)
+			goto out;
 	}
 
-	set_new_dnode(&dn, inode, ipage, NULL, 0);
+	/* block allocation */
+	f2fs_lock_op(sbi);
+	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = f2fs_reserve_block(&dn, page->index);
 	if (err) {
 		f2fs_unlock_op(sbi);
@@ -433,20 +420,23 @@ void truncate_data_blocks(struct dnode_of_data *dn)
 	truncate_data_blocks_range(dn, ADDRS_PER_BLOCK);
 }
 
-static void truncate_partial_data_page(struct inode *inode, u64 from)
+static int truncate_partial_data_page(struct inode *inode, u64 from)
 {
 	unsigned offset = from & (PAGE_CACHE_SIZE - 1);
 	struct page *page;
 
-	if (f2fs_has_inline_data(inode))
-		return truncate_inline_data(inode, from);
+	if (f2fs_has_inline_data(inode)) {
+		int err = truncate_inline_data(inode, from);
+		if (err != -EAGAIN)
+			return err;
+	}
 
 	if (!offset)
-		return;
+		return 0;
 
 	page = find_data_page(inode, from >> PAGE_CACHE_SHIFT, false);
 	if (IS_ERR(page))
-		return;
+		return 0;
 
 	lock_page(page);
 	if (unlikely(!PageUptodate(page) ||
@@ -456,9 +446,9 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
 	f2fs_wait_on_page_writeback(page, DATA);
 	zero_user(page, offset, PAGE_CACHE_SIZE - offset);
 	set_page_dirty(page);
-
 out:
 	f2fs_put_page(page, 1);
+	return 0;
 }
 
 int truncate_blocks(struct inode *inode, u64 from, bool lock)
@@ -471,11 +461,11 @@ int truncate_blocks(struct inode *inode, u64 from, bool lock)
 
 	trace_f2fs_truncate_blocks_enter(inode, from);
 
-	if (f2fs_has_inline_data(inode) || f2fs_has_inline_dentry(inode))
-		goto done;
-
 	free_from = (pgoff_t)
-			((from + blocksize - 1) >> (sbi->log_blocksize));
+		((from + blocksize - 1) >> (sbi->log_blocksize));
+
+	if (f2fs_has_inline_data(inode))
+		goto done;
 
 	if (lock)
 		f2fs_lock_op(sbi);
@@ -491,12 +481,6 @@ int truncate_blocks(struct inode *inode, u64 from, bool lock)
 		return err;
 	}
 
-	/* writepage can convert inline_data under get_donde_of_data */
-	if (f2fs_has_inline_data(inode)) {
-		f2fs_put_dnode(&dn);
-		goto unlock_done;
-	}
-
 	count = ADDRS_PER_PAGE(dn.node_page, F2FS_I(inode));
 
 	count -= dn.ofs_in_node;
@@ -510,12 +494,11 @@ int truncate_blocks(struct inode *inode, u64 from, bool lock)
 	f2fs_put_dnode(&dn);
 free_next:
 	err = truncate_inode_blocks(inode, free_from);
-unlock_done:
 	if (lock)
 		f2fs_unlock_op(sbi);
 done:
 	/* lastly zero out the first data page */
-	truncate_partial_data_page(inode, from);
+	err = truncate_partial_data_page(inode, from);
 
 	trace_f2fs_truncate_blocks_exit(inode, err);
 	return err;
@@ -586,10 +569,6 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 		return err;
 
 	if (attr->ia_valid & ATTR_SIZE) {
-		err = f2fs_convert_inline_data(inode, attr->ia_size, NULL);
-		if (err)
-			return err;
-
 		if (attr->ia_size != i_size_read(inode)) {
 			truncate_setsize(inode, attr->ia_size);
 			f2fs_truncate(inode);
@@ -690,9 +669,11 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	if (offset >= inode->i_size)
 		return ret;
 
-	ret = f2fs_convert_inline_data(inode, MAX_INLINE_DATA + 1, NULL);
-	if (ret)
-		return ret;
+	if (f2fs_has_inline_data(inode)) {
+		ret = f2fs_convert_inline_inode(inode);
+		if (ret)
+			return ret;
+	}
 
 	pg_start = ((unsigned long long) offset) >> PAGE_CACHE_SHIFT;
 	pg_end = ((unsigned long long) offset + len) >> PAGE_CACHE_SHIFT;
@@ -746,9 +727,11 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 	if (ret)
 		return ret;
 
-	ret = f2fs_convert_inline_data(inode, offset + len, NULL);
-	if (ret)
-		return ret;
+	if (f2fs_has_inline_data(inode)) {
+		ret = f2fs_convert_inline_inode(inode);
+		if (ret)
+			return ret;
+	}
 
 	pg_start = ((unsigned long long) offset) >> PAGE_CACHE_SHIFT;
 	pg_end = ((unsigned long long) offset + len) >> PAGE_CACHE_SHIFT;
@@ -899,7 +882,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 
 	set_inode_flag(F2FS_I(inode), FI_ATOMIC_FILE);
 
-	return f2fs_convert_inline_data(inode, MAX_INLINE_DATA + 1, NULL);
+	return f2fs_convert_inline_inode(inode);
 }
 
 static int f2fs_ioc_commit_atomic_write(struct file *filp)
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index d9daf76..1ec38a4 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -15,41 +15,26 @@
 
 bool f2fs_may_inline(struct inode *inode)
 {
-	block_t nr_blocks;
-	loff_t i_size;
-
 	if (!test_opt(F2FS_I_SB(inode), INLINE_DATA))
 		return false;
 
 	if (f2fs_is_atomic_file(inode))
 		return false;
 
-	nr_blocks = F2FS_I(inode)->i_xattr_nid ? 3 : 2;
-	if (inode->i_blocks > nr_blocks)
-		return false;
-
-	i_size = i_size_read(inode);
-	if (i_size > MAX_INLINE_DATA)
+	if (!S_ISREG(inode->i_mode))
 		return false;
 
 	return true;
 }
 
-int f2fs_read_inline_data(struct inode *inode, struct page *page)
+void read_inline_data(struct page *page, struct page *ipage)
 {
-	struct page *ipage;
 	void *src_addr, *dst_addr;
 
-	if (page->index) {
-		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
-		goto out;
-	}
+	if (PageUptodate(page))
+		return;
 
-	ipage = get_node_page(F2FS_I_SB(inode), inode->i_ino);
-	if (IS_ERR(ipage)) {
-		unlock_page(page);
-		return PTR_ERR(ipage);
-	}
+	f2fs_bug_on(F2FS_SB_P(page), page->index);
 
 	zero_user_segment(page, MAX_INLINE_DATA, PAGE_CACHE_SIZE);
 
@@ -58,104 +43,123 @@ int f2fs_read_inline_data(struct inode *inode, struct page *page)
 	dst_addr = kmap_atomic(page);
 	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
 	kunmap_atomic(dst_addr);
-	f2fs_put_page(ipage, 1);
-out:
 	SetPageUptodate(page);
-	unlock_page(page);
+}
+
+int f2fs_read_inline_data(struct inode *inode, struct page *page)
+{
+	struct page *ipage;
+
+	ipage = get_node_page(F2FS_I_SB(inode), inode->i_ino);
+	if (IS_ERR(ipage)) {
+		unlock_page(page);
+		return PTR_ERR(ipage);
+	}
+
+	if (!f2fs_has_inline_data(inode)) {
+		f2fs_put_page(ipage, 1);
+		return -EAGAIN;
+	}
+
+	if (page->index)
+		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+	else
+		read_inline_data(page, ipage);
 
+	SetPageUptodate(page);
+	f2fs_put_page(ipage, 1);
+	unlock_page(page);
 	return 0;
 }
 
-static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
+int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 {
-	int err = 0;
-	struct page *ipage;
-	struct dnode_of_data dn;
 	void *src_addr, *dst_addr;
 	block_t new_blk_addr;
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_io_info fio = {
 		.type = DATA,
 		.rw = WRITE_SYNC | REQ_PRIO,
 	};
+	int err;
 
-	f2fs_lock_op(sbi);
-	ipage = get_node_page(sbi, inode->i_ino);
-	if (IS_ERR(ipage)) {
-		err = PTR_ERR(ipage);
-		goto out;
-	}
+	f2fs_bug_on(F2FS_I_SB(dn->inode), page->index);
 
-	/* someone else converted inline_data already */
-	if (!f2fs_has_inline_data(inode))
-		goto out;
+	if (!f2fs_exist_data(dn->inode))
+		goto clear_out;
 
-	/*
-	 * i_addr[0] is not used for inline data,
-	 * so reserving new block will not destroy inline data
-	 */
-	set_new_dnode(&dn, inode, ipage, NULL, 0);
-	err = f2fs_reserve_block(&dn, 0);
+	err = f2fs_reserve_block(dn, 0);
 	if (err)
-		goto out;
+		return err;
 
 	f2fs_wait_on_page_writeback(page, DATA);
+
+	if (PageUptodate(page))
+		goto no_update;
+
 	zero_user_segment(page, MAX_INLINE_DATA, PAGE_CACHE_SIZE);
 
 	/* Copy the whole inline data block */
-	src_addr = inline_data_addr(ipage);
+	src_addr = inline_data_addr(dn->inode_page);
 	dst_addr = kmap_atomic(page);
 	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
 	kunmap_atomic(dst_addr);
 	SetPageUptodate(page);
-
+no_update:
 	/* write data page to try to make data consistent */
 	set_page_writeback(page);
-	write_data_page(page, &dn, &new_blk_addr, &fio);
-	update_extent_cache(new_blk_addr, &dn);
+
+	write_data_page(page, dn, &new_blk_addr, &fio);
+	update_extent_cache(new_blk_addr, dn);
 	f2fs_wait_on_page_writeback(page, DATA);
 
 	/* clear inline data and flag after data writeback */
-	zero_user_segment(ipage, INLINE_DATA_OFFSET,
+	zero_user_segment(dn->inode_page, INLINE_DATA_OFFSET,
 				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
-	clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
-	stat_dec_inline_inode(inode);
+clear_out:
+	stat_dec_inline_inode(dn->inode);
+	clear_inode_flag(F2FS_I(dn->inode), FI_INLINE_DATA);
+	clear_inode_flag(F2FS_I(dn->inode), FI_DATA_EXIST);
 
-	sync_inode_page(&dn);
-	f2fs_put_dnode(&dn);
-out:
-	f2fs_unlock_op(sbi);
-	return err;
+	sync_inode_page(dn);
+	f2fs_put_dnode(dn);
+	return 0;
 }
 
-int f2fs_convert_inline_data(struct inode *inode, pgoff_t to_size,
-						struct page *page)
+int f2fs_convert_inline_inode(struct inode *inode)
 {
-	struct page *new_page = page;
-	int err;
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	struct dnode_of_data dn;
+	struct page *ipage, *page;
+	int err = 0;
 
-	if (!f2fs_has_inline_data(inode))
-		return 0;
-	else if (to_size <= MAX_INLINE_DATA)
-		return 0;
+	page = grab_cache_page(inode->i_mapping, 0);
+	if (!page)
+		return -ENOMEM;
 
-	if (!page || page->index != 0) {
-		new_page = grab_cache_page(inode->i_mapping, 0);
-		if (!new_page)
-			return -ENOMEM;
+	f2fs_lock_op(sbi);
+
+	ipage = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(ipage)) {
+		f2fs_unlock_op(sbi);
+		return PTR_ERR(ipage);
 	}
 
-	err = __f2fs_convert_inline_data(inode, new_page);
-	if (!page || page->index != 0)
-		f2fs_put_page(new_page, 1);
+	set_new_dnode(&dn, inode, ipage, ipage, 0);
+
+	if (f2fs_has_inline_data(inode))
+		err = f2fs_convert_inline_page(&dn, page);
+
+	f2fs_put_dnode(&dn);
+
+	f2fs_unlock_op(sbi);
+
+	f2fs_put_page(page, 1);
 	return err;
 }
 
-int f2fs_write_inline_data(struct inode *inode,
-				struct page *page, unsigned size)
+int f2fs_write_inline_data(struct inode *inode, struct page *page)
 {
 	void *src_addr, *dst_addr;
-	struct page *ipage;
 	struct dnode_of_data dn;
 	int err;
 
@@ -163,48 +167,50 @@ int f2fs_write_inline_data(struct inode *inode,
 	err = get_dnode_of_data(&dn, 0, LOOKUP_NODE);
 	if (err)
 		return err;
-	ipage = dn.inode_page;
 
-	/* Release any data block if it is allocated */
 	if (!f2fs_has_inline_data(inode)) {
-		int count = ADDRS_PER_PAGE(dn.node_page, F2FS_I(inode));
-		truncate_data_blocks_range(&dn, count);
-		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
-		stat_inc_inline_inode(inode);
+		f2fs_put_dnode(&dn);
+		return -EAGAIN;
 	}
 
-	f2fs_wait_on_page_writeback(ipage, NODE);
-	zero_user_segment(ipage, INLINE_DATA_OFFSET,
-				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+	f2fs_bug_on(F2FS_I_SB(inode), page->index);
+
+	f2fs_wait_on_page_writeback(dn.inode_page, NODE);
 	src_addr = kmap_atomic(page);
-	dst_addr = inline_data_addr(ipage);
-	memcpy(dst_addr, src_addr, size);
+	dst_addr = inline_data_addr(dn.inode_page);
+	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
 	kunmap_atomic(src_addr);
 
 	set_inode_flag(F2FS_I(inode), FI_APPEND_WRITE);
 	sync_inode_page(&dn);
 	f2fs_put_dnode(&dn);
-
 	return 0;
 }
 
-void truncate_inline_data(struct inode *inode, u64 from)
+int truncate_inline_data(struct inode *inode, u64 from)
 {
 	struct page *ipage;
-
-	if (from >= MAX_INLINE_DATA)
-		return;
+	int err = 0;
 
 	ipage = get_node_page(F2FS_I_SB(inode), inode->i_ino);
 	if (IS_ERR(ipage))
-		return;
+		return PTR_ERR(ipage);
+
+	if (!f2fs_has_inline_data(inode)) {
+		err = -EAGAIN;
+		goto out;
+	}
+	if (from >= MAX_INLINE_DATA)
+		goto out;
 
 	f2fs_wait_on_page_writeback(ipage, NODE);
 
 	zero_user_segment(ipage, INLINE_DATA_OFFSET + from,
 				INLINE_DATA_OFFSET + MAX_INLINE_DATA);
 	set_page_dirty(ipage);
+out:
 	f2fs_put_page(ipage, 1);
+	return err;
 }
 
 bool recover_inline_data(struct inode *inode, struct page *npage)
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index a004a97..6312dd2 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -55,6 +55,8 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 		goto out;
 	}
 
+	if (f2fs_may_inline(inode))
+		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
 	if (test_opt(sbi, INLINE_DENTRY) && S_ISDIR(inode->i_mode))
 		set_inode_flag(F2FS_I(inode), FI_INLINE_DENTRY);
 
@@ -133,6 +135,7 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	alloc_nid_done(sbi, ino);
 
+	stat_inc_inline_inode(inode);
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
 	return 0;
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 63f8303..07a0aa2 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -172,6 +172,7 @@ struct f2fs_extent {
 #define F2FS_INLINE_XATTR	0x01	/* file inline xattr flag */
 #define F2FS_INLINE_DATA	0x02	/* file inline data flag */
 #define F2FS_INLINE_DENTRY	0x04	/* file inline dentry flag */
+#define F2FS_DATA_EXIST		0x04	/* file inline data exist flag */
 
 #define MAX_INLINE_DATA		(sizeof(__le32) * (DEF_ADDRS_PER_INODE - \
 						F2FS_INLINE_XATTR_ADDRS - 1))
-- 
2.1.1

