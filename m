Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3KJPTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 10:19:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:55854 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab3KJPTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 10:19:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="432794263"
From: Huajun Li <huajun.li.lee@gmail.com>
To: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Subject: [f2fs-dev][PATCH V2 5/6] f2fs: Handle inline data operations
Date: Sun, 10 Nov 2013 23:13:20 +0800
Message-Id: <1384096401-25169-6-git-send-email-huajun.li.lee@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
References: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huajun Li <huajun.li@intel.com>

Hook inline data read/write, truncate, fallocate, setattr, etc.

Files need meet following 2 requirement to inline:
 1) file size is not greater than MAX_INLINE_DATA;
 2) file doesn't pre-allocate data blocks by fallocate().

FI_INLINE_DATA will not be set while creating a new regular inode because
most of the files are bigger than ~3.4K. Set FI_INLINE_DATA only when
data is submitted to block layer, ranther than set it while creating a new
inode, this also avoids converting data from inline to normal data block
and vice versa.

While writting inline data to inode block, the first data block should be
released if the file has a block indexed by i_addr[0].

On the other hand, when a file operation is appied to a file with inline
data, we need to test if this file can remain inline by doing this
operation, otherwise it should be convert into normal file by reserving
a new data block, copying inline data to this new block and clear
FI_INLINE_DATA flag. Because reserve a new data block here will make use
of i_addr[0], if we save inline data in i_addr[0..872], then the first
4 bytes would be overwriten. This problem can be avoided simply by
not using i_addr[0] for inline data.

Signed-off-by: Huajun Li <huajun.li@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Weihong Xu <weihong.xu@intel.com>
---
 fs/f2fs/data.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-----
 fs/f2fs/file.c |   43 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 84 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 92d0724..2e72260 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -471,13 +471,28 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 
 static int f2fs_read_data_page(struct file *file, struct page *page)
 {
-	return mpage_readpage(page, get_data_block_ro);
+	int ret;
+	struct inode *inode = file->f_mapping->host;
+
+	/* If the file has inline data, try to read it directlly */
+	if (f2fs_has_inline_data(inode))
+		ret = f2fs_read_inline_data(inode, page);
+	else
+		ret = mpage_readpage(page, get_data_block_ro);
+
+	return ret;
 }
 
 static int f2fs_read_data_pages(struct file *file,
 			struct address_space *mapping,
 			struct list_head *pages, unsigned nr_pages)
 {
+	struct inode *inode = file->f_mapping->host;
+
+	/* If the file has inline data, skip readpages */
+	if (f2fs_has_inline_data(inode))
+		return 0;
+
 	return mpage_readpages(mapping, pages, nr_pages, get_data_block_ro);
 }
 
@@ -528,7 +543,7 @@ static int f2fs_write_data_page(struct page *page,
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = ((unsigned long long) i_size)
 							>> PAGE_CACHE_SHIFT;
-	unsigned offset;
+	unsigned offset = 0;
 	bool need_balance_fs = false;
 	int err = 0;
 
@@ -562,7 +577,14 @@ write:
 		err = do_write_data_page(page);
 	} else {
 		f2fs_lock_op(sbi);
-		err = do_write_data_page(page);
+		if (f2fs_has_inline_data(inode) || f2fs_may_inline(inode)) {
+			err = f2fs_write_inline_data(inode, page, offset);
+			f2fs_unlock_op(sbi);
+			goto out;
+		} else {
+			err = do_write_data_page(page);
+		}
+
 		f2fs_unlock_op(sbi);
 		need_balance_fs = true;
 	}
@@ -650,6 +672,15 @@ repeat:
 		return -ENOMEM;
 	*pagep = page;
 
+	if ((pos + len) < MAX_INLINE_DATA) {
+		if (f2fs_has_inline_data(inode))
+			goto inline_data;
+	} else if (f2fs_has_inline_data(inode)) {
+		err = f2fs_convert_inline_data(inode, page, flags);
+		if (err)
+			return err;
+	}
+
 	f2fs_lock_op(sbi);
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = f2fs_reserve_block(&dn, index);
@@ -659,7 +690,7 @@ repeat:
 		f2fs_put_page(page, 1);
 		return err;
 	}
-
+inline_data:
 	if ((len == PAGE_CACHE_SIZE) || PageUptodate(page))
 		return 0;
 
@@ -675,7 +706,11 @@ repeat:
 	if (dn.data_blkaddr == NEW_ADDR) {
 		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 	} else {
-		err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
+		if (f2fs_has_inline_data(inode))
+			err = f2fs_read_inline_data(inode, page);
+		else
+			err = f2fs_readpage(sbi, page,
+					dn.data_blkaddr, READ_SYNC);
 		if (err)
 			return err;
 		lock_page(page);
@@ -724,6 +759,10 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 	if (rw == WRITE)
 		return 0;
 
+	/* Let buffer I/O handle the inline data case. */
+	if (f2fs_has_inline_data(inode))
+		return 0;
+
 	/* Needs synchronization with the cleaner */
 	return blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
 						  get_data_block_ro);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 1cd8e44..ffafcb9 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -291,7 +291,9 @@ static int truncate_blocks(struct inode *inode, u64 from)
 
 	f2fs_put_dnode(&dn);
 free_next:
-	err = truncate_inode_blocks(inode, free_from);
+
+	if (!f2fs_has_inline_data(inode))
+		err = truncate_inode_blocks(inode, free_from);
 	f2fs_unlock_op(sbi);
 
 	/* lastly zero out the first data page */
@@ -367,8 +369,17 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 			attr->ia_size != i_size_read(inode)) {
+		if (f2fs_has_inline_data(inode) &&
+				(attr->ia_size > MAX_INLINE_DATA)) {
+			unsigned flags = AOP_FLAG_NOFS;
+			err = f2fs_convert_inline_data(inode, NULL, flags);
+			if (err)
+				return err;
+		}
+
 		truncate_setsize(inode, attr->ia_size);
-		f2fs_truncate(inode);
+		if (!f2fs_has_inline_data(inode))
+			f2fs_truncate(inode);
 		f2fs_balance_fs(F2FS_SB(inode->i_sb));
 	}
 
@@ -450,6 +461,26 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len, int mode)
 	loff_t off_start, off_end;
 	int ret = 0;
 
+	if (f2fs_has_inline_data(inode)) {
+		struct page *page;
+		unsigned flags = AOP_FLAG_NOFS;
+		page = grab_cache_page_write_begin(inode->i_mapping, 0, flags);
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+		if (offset + len > MAX_INLINE_DATA) {
+			ret = f2fs_convert_inline_data(inode, page, flags);
+			f2fs_put_page(page, 1);
+			if (ret)
+				return ret;
+		} else {
+			zero_user_segment(page, offset, offset + len);
+			SetPageUptodate(page);
+			set_page_dirty(page);
+			f2fs_put_page(page, 1);
+			goto out;
+		}
+	}
+
 	pg_start = ((unsigned long long) offset) >> PAGE_CACHE_SHIFT;
 	pg_end = ((unsigned long long) offset + len) >> PAGE_CACHE_SHIFT;
 
@@ -483,7 +514,7 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len, int mode)
 			f2fs_unlock_op(sbi);
 		}
 	}
-
+out:
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		i_size_read(inode) <= (offset + len)) {
 		i_size_write(inode, offset);
@@ -502,6 +533,12 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 	loff_t off_start, off_end;
 	int ret = 0;
 
+	if (f2fs_has_inline_data(inode) && (offset + len > MAX_INLINE_DATA)) {
+		ret = f2fs_convert_inline_data(inode, NULL, AOP_FLAG_NOFS);
+		if (ret)
+			return ret;
+	}
+
 	ret = inode_newsize_ok(inode, (len + offset));
 	if (ret)
 		return ret;
-- 
1.7.9.5

