Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab3FCKFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:05:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:31689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143Ab3FCKFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:05:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,791,1363158000"; 
   d="scan'208";a="249941810"
From: Huajun Li <huajun.li@intel.com>
To: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        huajun.li.lee@gmail.com
Cc: namjae.jeon@samsung.com, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [RFC 3/5] f2fs: Key functions to handle inline data
Date: Mon,  3 Jun 2013 18:04:12 +0800
Message-Id: <1370253854-15084-4-git-send-email-huajun.li@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
References: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions to implement inline data read/write, and move inline data to
normal data block when file size exceeds inline data limitation.

Signed-off-by: Huajun Li <huajun.li@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/inline.c |  152 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 152 insertions(+)
 create mode 100644 fs/f2fs/inline.c

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
new file mode 100644
index 0000000..a2aa056
--- /dev/null
+++ b/fs/f2fs/inline.c
@@ -0,0 +1,152 @@
+/*
+ * fs/f2fs/inline.c
+ *
+ * Copyright (c) 2013, Intel Corporation.
+ * Authors:
+ *      Huajun Li <huajun.li@intel.com>
+ *      Haicheng Li <haicheng.li@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/fs.h>
+#include <linux/f2fs_fs.h>
+
+#include "f2fs.h"
+
+void f2fs_clear_inode_inline_flag(struct f2fs_inode *raw_inode)
+{
+	raw_inode->i_reserved &= ~F2FS_INODE_INLINE_DATA;
+}
+
+void f2fs_set_inode_inline_flag(struct f2fs_inode *raw_inode)
+{
+	raw_inode->i_reserved |= F2FS_INODE_INLINE_DATA;
+}
+
+int f2fs_inline_data_attempt(struct inode *inode)
+{
+	return is_inode_dyn_flag_set(F2FS_I(inode), F2FS_INLINE_DATA_ATTEMPT);
+}
+
+int f2fs_has_inline_data(struct inode *inode)
+{
+	return is_inode_dyn_flag_set(F2FS_I(inode), F2FS_INLINE_DATA_FL);
+}
+
+static int f2fs_read_inline_data(struct inode *inode, struct page *page)
+{
+	void *src_addr, *dst_addr;
+	loff_t size = i_size_read(inode);
+	struct page *ipage = get_node_page(F2FS_SB(inode->i_sb), inode->i_ino);
+
+	if (IS_ERR(ipage))
+		return PTR_ERR(ipage);
+
+	src_addr = page_address(ipage);
+	dst_addr = page_address(page);
+
+	memcpy(dst_addr, src_addr + INLINE_DATA_OFFSET, size);
+	zero_user_segment(page, INLINE_DATA_OFFSET + size, PAGE_CACHE_SIZE);
+	SetPageUptodate(page);
+
+	f2fs_put_page(ipage, 1);
+
+	return 0;
+}
+
+int f2fs_read_inline_data_page(struct inode *inode, struct page *page)
+{
+	int ret = 0;
+
+	if (!page->index) {
+		ret = f2fs_read_inline_data(inode, page);
+	} else if (!PageUptodate(page)) {
+		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+		SetPageUptodate(page);
+	}
+
+	unlock_page(page);
+
+	return ret;
+}
+
+int f2fs_convert_inline_data(struct page *p,
+			     struct inode *inode, unsigned flags)
+{
+	int err;
+	int ilock;
+	loff_t size;
+	struct page *page, *ipage;
+	void *src_addr, *dst_addr;
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+
+	if (!p->index)
+		page = p;
+	else
+		page = grab_cache_page_write_begin(inode->i_mapping, 0, flags);
+
+	if (IS_ERR(page))
+		return PTR_ERR(page);
+
+	ipage = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(ipage)) {
+		f2fs_put_page(page, 1);
+		return PTR_ERR(ipage);
+	}
+
+	src_addr = page_address(ipage);
+	dst_addr = page_address(page);
+
+	size = i_size_read(inode);
+	memcpy(dst_addr, src_addr + INLINE_DATA_OFFSET, size);
+	zero_user_segment(ipage, INLINE_DATA_OFFSET,
+			  INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+	clear_inode_dyn_flag(F2FS_I(inode), F2FS_INLINE_DATA_FL);
+	set_page_dirty(ipage);
+	f2fs_put_page(ipage, 1);
+
+	if (!p->index) {
+		SetPageUptodate(page);
+	} else {
+		ilock = mutex_lock_op(sbi);
+		err = f2fs_reserve_block(inode, 0);
+		if (err)
+			goto err;
+		mutex_unlock_op(sbi, ilock);
+
+		set_page_dirty(page);
+		f2fs_put_page(page, 1);
+	}
+
+	return 0;
+
+err:
+	mutex_unlock_op(sbi, ilock);
+	f2fs_put_page(page, 1);
+	return err;
+}
+
+int f2fs_write_inline_data(struct inode *inode,
+			   struct page *page, unsigned size)
+{
+	void *src_addr, *dst_addr;
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct page *ipage = get_node_page(sbi, inode->i_ino);
+
+	if (IS_ERR(ipage))
+		return PTR_ERR(ipage);
+
+	src_addr = page_address(page);
+	dst_addr = page_address(ipage);
+
+	memcpy(dst_addr + INLINE_DATA_OFFSET, src_addr, size);
+	clear_inode_dyn_flag(F2FS_I(inode), F2FS_INLINE_DATA_ATTEMPT);
+	if (!f2fs_has_inline_data(inode))
+		set_inode_dyn_flag(F2FS_I(inode), F2FS_INLINE_DATA_FL);
+	set_page_dirty(ipage);
+	f2fs_put_page(ipage, 1);
+
+	return 0;
+}
-- 
1.7.9.5

