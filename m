Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3KJPTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 10:19:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:62424 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab3KJPTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 10:19:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="432794242"
From: Huajun Li <huajun.li.lee@gmail.com>
To: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Subject: [f2fs-dev][PATCH V2 4/6] f2fs: Key functions to handle inline data
Date: Sun, 10 Nov 2013 23:13:19 +0800
Message-Id: <1384096401-25169-5-git-send-email-huajun.li.lee@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
References: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huajun Li <huajun.li@intel.com>

Functions to implement inline data read/write, and move inline data to
normal data block when file size exceeds inline data limitation.

Signed-off-by: Huajun Li <huajun.li@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Weihong Xu <weihong.xu@intel.com>
---
 fs/f2fs/Makefile |    2 +-
 fs/f2fs/f2fs.h   |    8 +++
 fs/f2fs/inline.c |  172 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 181 insertions(+), 1 deletion(-)
 create mode 100644 fs/f2fs/inline.c

diff --git a/fs/f2fs/Makefile b/fs/f2fs/Makefile
index 27a0820..2e35da1 100644
--- a/fs/f2fs/Makefile
+++ b/fs/f2fs/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_F2FS_FS) += f2fs.o
 
-f2fs-y		:= dir.o file.o inode.o namei.o hash.o super.o
+f2fs-y		:= dir.o file.o inode.o namei.o hash.o super.o inline.o
 f2fs-y		+= checkpoint.o gc.o data.o node.o segment.o recovery.o
 f2fs-$(CONFIG_F2FS_STAT_FS) += debug.o
 f2fs-$(CONFIG_F2FS_FS_XATTR) += xattr.o
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index de84f52..5f78c9c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1253,4 +1253,12 @@ extern const struct inode_operations f2fs_dir_inode_operations;
 extern const struct inode_operations f2fs_symlink_inode_operations;
 extern const struct inode_operations f2fs_special_inode_operations;
 
+/*
+ * inline.c
+ */
+inline int f2fs_has_inline_data(struct inode *);
+bool f2fs_may_inline(struct inode *);
+int f2fs_read_inline_data(struct inode *, struct page *);
+int f2fs_convert_inline_data(struct inode *, struct page *, unsigned);
+int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
 #endif
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
new file mode 100644
index 0000000..e9b33d7
--- /dev/null
+++ b/fs/f2fs/inline.c
@@ -0,0 +1,172 @@
+/*
+ * fs/f2fs/inline.c
+ * Copyright (c) 2013, Intel Corporation
+ * Authors: Huajun Li <huajun.li@intel.com>
+ *          Haicheng Li <haicheng.li@intel.com>
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/fs.h>
+#include <linux/f2fs_fs.h>
+
+#include "f2fs.h"
+
+inline int f2fs_has_inline_data(struct inode *inode)
+{
+	return is_inode_flag_set(F2FS_I(inode), FI_INLINE_DATA);
+}
+
+bool f2fs_may_inline(struct inode *inode)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	block_t nr_blocks;
+	loff_t i_size;
+
+	if (!test_opt(sbi, INLINE_DATA))
+		return false;
+
+	nr_blocks = F2FS_I(inode)->i_xattr_nid ? 3 : 2;
+	if (inode->i_blocks > nr_blocks)
+		return false;
+
+	i_size = i_size_read(inode);
+	if (i_size > MAX_INLINE_DATA)
+		return false;
+
+	return true;
+}
+
+int f2fs_read_inline_data(struct inode *inode, struct page *page)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct page *ipage;
+	void *src_addr, *dst_addr;
+
+	ipage = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(ipage))
+		return PTR_ERR(ipage);
+
+	src_addr = inline_data_addr(ipage);
+	dst_addr = page_address(page);
+
+	zero_user_segment(page, INLINE_DATA_OFFSET,
+				INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+	/* Copy the whole inline data block */
+	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
+	f2fs_put_page(ipage, 1);
+
+	SetPageUptodate(page);
+	unlock_page(page);
+
+	return 0;
+}
+
+static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
+{
+	int err;
+	struct page *ipage;
+	struct dnode_of_data dn;
+	void *src_addr, *dst_addr;
+	block_t old_blk_addr, new_blk_addr;
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+
+	f2fs_lock_op(sbi);
+	ipage = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(ipage))
+		return PTR_ERR(ipage);
+
+	/*
+	 * i_addr[0] is not used for inline data,
+	 * so reserving new block will not destroy inline data
+	 */
+	set_new_dnode(&dn, inode, ipage, ipage, 0);
+	err = f2fs_reserve_block(&dn, 0);
+	if (err) {
+		f2fs_put_page(ipage, 1);
+		f2fs_unlock_op(sbi);
+		return err;
+	}
+
+	src_addr = inline_data_addr(ipage);
+	dst_addr = page_address(page);
+	zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+
+	/* Copy the whole inline data block */
+	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
+
+	/* write data page to try to make data consistent */
+	old_blk_addr = dn.data_blkaddr;
+	set_page_writeback(page);
+	write_data_page(inode, page, &dn,
+			old_blk_addr, &new_blk_addr);
+	update_extent_cache(new_blk_addr, &dn);
+	f2fs_wait_on_page_writeback(page, DATA, true);
+
+	/* clear inline data and flag after data writeback */
+	zero_user_segment(ipage, INLINE_DATA_OFFSET,
+				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+	clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
+
+	sync_inode_page(&dn);
+	f2fs_put_page(ipage, 1);
+	f2fs_unlock_op(sbi);
+
+	return err;
+}
+
+int f2fs_convert_inline_data(struct inode *inode,
+			     struct page *p, unsigned flags)
+{
+	int err;
+	struct page *page;
+
+	if (!p || p->index) {
+		page = grab_cache_page_write_begin(inode->i_mapping, 0, flags);
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+	} else {
+		page = p;
+	}
+
+	err = __f2fs_convert_inline_data(inode, page);
+
+	if (!p || p->index)
+		f2fs_put_page(page, 1);
+
+	return err;
+}
+
+int f2fs_write_inline_data(struct inode *inode,
+			   struct page *page, unsigned size)
+{
+	void *src_addr, *dst_addr;
+	struct page *ipage;
+	struct dnode_of_data dn;
+	int err;
+
+	set_new_dnode(&dn, inode, NULL, NULL, 0);
+	err = get_dnode_of_data(&dn, 0, LOOKUP_NODE);
+	if (err)
+		return err;
+	ipage = dn.inode_page;
+
+	src_addr = page_address(page);
+	dst_addr = inline_data_addr(ipage);
+
+	zero_user_segment(ipage, INLINE_DATA_OFFSET,
+				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+	memcpy(dst_addr, src_addr, size);
+
+	/* Release the first data block if it is allocated */
+	if (!f2fs_has_inline_data(inode)) {
+		truncate_data_blocks_range(&dn, 1);
+		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
+	}
+
+	sync_inode_page(&dn);
+	f2fs_put_dnode(&dn);
+
+	return 0;
+}
-- 
1.7.9.5

