Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab3FCKFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:05:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:31689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140Ab3FCKFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:05:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,791,1363158000"; 
   d="scan'208";a="249941770"
From: Huajun Li <huajun.li@intel.com>
To: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        huajun.li.lee@gmail.com
Cc: namjae.jeon@samsung.com, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [RFC 2/5] f2fs: Handle inline data read and write
Date: Mon,  3 Jun 2013 18:04:11 +0800
Message-Id: <1370253854-15084-3-git-send-email-huajun.li@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
References: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook inline data read/write in address space operations.

Signed-off-by: Huajun Li <huajun.li@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/data.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/f2fs/file.c |    9 +++++--
 2 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 93917e3..bac25f3 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -64,6 +64,23 @@ int reserve_new_block(struct dnode_of_data *dn)
 	return 0;
 }
 
+int f2fs_reserve_block(struct inode *inode, pgoff_t index)
+{
+	int err;
+	struct dnode_of_data dn;
+
+	set_new_dnode(&dn, inode, NULL, NULL, 0);
+	err = get_dnode_of_data(&dn, index, ALLOC_NODE);
+	if (err)
+		return err;
+	if (dn.data_blkaddr == NULL_ADDR)
+		err = reserve_new_block(&dn);
+
+	f2fs_put_dnode(&dn);
+
+	return err;
+}
+
 static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 					struct buffer_head *bh_result)
 {
@@ -461,13 +478,28 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 
 static int f2fs_read_data_page(struct file *file, struct page *page)
 {
-	return mpage_readpage(page, get_data_block_ro);
+	int ret;
+	struct inode *inode = file->f_mapping->host;
+
+	/* If the file has inline data, try to read it directlly */
+	if (f2fs_has_inline_data(inode))
+		ret = f2fs_read_inline_data_page(inode, page);
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
 
@@ -517,7 +549,7 @@ static int f2fs_write_data_page(struct page *page,
 	loff_t i_size = i_size_read(inode);
 	const pgoff_t end_index = ((unsigned long long) i_size)
 							>> PAGE_CACHE_SHIFT;
-	unsigned offset;
+	unsigned offset = 0;
 	bool need_balance_fs = false;
 	int err = 0;
 
@@ -551,7 +583,16 @@ write:
 		err = do_write_data_page(page);
 	} else {
 		int ilock = mutex_lock_op(sbi);
+
+#ifdef CONFIG_F2FS_INLINE_DATA
+		if (i_size <= MAX_INLINE_DATA)
+			err = f2fs_write_inline_data(inode, page, offset);
+		else
+			err = do_write_data_page(page);
+#else
 		err = do_write_data_page(page);
+#endif
+
 		mutex_unlock_op(sbi, ilock);
 		need_balance_fs = true;
 	}
@@ -643,6 +684,25 @@ repeat:
 		return -ENOMEM;
 	*pagep = page;
 
+#ifdef CONFIG_F2FS_INLINE_DATA
+	if ((pos + len) <= MAX_INLINE_DATA) {
+		set_inode_dyn_flag(F2FS_I(inode), F2FS_INLINE_DATA_ATTEMPT);
+		goto inline_data;
+	} else if (f2fs_has_inline_data(inode)) {
+		err = f2fs_convert_inline_data(page, inode, flags);
+		if (err)
+			return err;
+	} else if (f2fs_inline_data_attempt(inode)) {
+		clear_inode_dyn_flag(F2FS_I(inode), F2FS_INLINE_DATA_ATTEMPT);
+
+		ilock = mutex_lock_op(sbi);
+		err = f2fs_reserve_block(inode, 0);
+		if (err)
+			goto err;
+		mutex_unlock_op(sbi, ilock);
+	}
+#endif
+
 	ilock = mutex_lock_op(sbi);
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
@@ -659,6 +719,7 @@ repeat:
 
 	mutex_unlock_op(sbi, ilock);
 
+inline_data:
 	if ((len == PAGE_CACHE_SIZE) || PageUptodate(page))
 		return 0;
 
@@ -674,7 +735,16 @@ repeat:
 	if (dn.data_blkaddr == NEW_ADDR) {
 		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 	} else {
+#ifdef CONFIG_F2FS_INLINE_DATA
+		if ((pos + len) <= MAX_INLINE_DATA)
+			err = f2fs_read_inline_data_page(inode, page);
+		else
+			err = f2fs_readpage(sbi, page,
+					    dn.data_blkaddr, READ_SYNC);
+#else
 		err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
+#endif
+
 		if (err)
 			return err;
 		lock_page(page);
@@ -707,6 +777,10 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
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
index deefd25..03b13b3 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -178,6 +178,9 @@ int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
 	raw_node = page_address(dn->node_page);
 	addr = blkaddr_in_node(raw_node) + ofs;
 
+	if (f2fs_has_inline_data(dn->inode))
+		return nr_free;
+
 	for ( ; count > 0; count--, addr++, dn->ofs_in_node++) {
 		block_t blkaddr = le32_to_cpu(*addr);
 		if (blkaddr == NULL_ADDR)
@@ -267,11 +270,13 @@ static int truncate_blocks(struct inode *inode, u64 from)
 
 	f2fs_put_dnode(&dn);
 free_next:
-	err = truncate_inode_blocks(inode, free_from);
+	if (!f2fs_has_inline_data(inode))
+		err = truncate_inode_blocks(inode, free_from);
 	mutex_unlock_op(sbi, ilock);
 
 	/* lastly zero out the first data page */
-	truncate_partial_data_page(inode, from);
+	if (!f2fs_has_inline_data(inode))
+		truncate_partial_data_page(inode, from);
 
 	trace_f2fs_truncate_blocks_exit(inode, err);
 	return err;
-- 
1.7.9.5

