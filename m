Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3JYQIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:08:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:11503 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab3JYQIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:08:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,571,1378882800"; 
   d="scan'208";a="417211737"
From: Huajun Li <huajun.li.lee@gmail.com>
To: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Subject: [f2fs-dev 4/5] f2fs: Key functions to handle inline data
Date: Sat, 26 Oct 2013 00:01:58 +0800
Message-Id: <1382716919-23345-5-git-send-email-huajun.li.lee@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
References: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
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
 fs/f2fs/f2fs.h   |    7 +++
 fs/f2fs/inline.c |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+), 1 deletion(-)
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
index 4f34330..904ae3d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1246,4 +1246,11 @@ extern const struct inode_operations f2fs_dir_inode_operations;
 extern const struct inode_operations f2fs_symlink_inode_operations;
 extern const struct inode_operations f2fs_special_inode_operations;
 
+/*
+ * inline.c
+ */
+inline int f2fs_has_inline_data(struct inode *);
+int f2fs_read_inline_data(struct inode *, struct page *);
+int f2fs_convert_inline_data(struct inode *, struct page *, unsigned);
+int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
 #endif
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
new file mode 100644
index 0000000..ec0d00c
--- /dev/null
+++ b/fs/f2fs/inline.c
@@ -0,0 +1,144 @@
+/*
+ * fs/f2fs/inline.c
+ *
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
+int f2fs_read_inline_data(struct inode *inode, struct page *page)
+{
+	struct page *ipage;
+	void *src_addr, *dst_addr;
+
+	BUG_ON(page->index);
+	ipage = get_node_page(F2FS_SB(inode->i_sb), inode->i_ino);
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
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+
+	ipage = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(ipage))
+		return PTR_ERR(ipage);
+
+	f2fs_lock_op(sbi);
+	/* i_addr[0] is not used for inline data,
+	 * so reserving new block will not destroy inline data */
+	err = f2fs_reserve_block(inode, &dn, 0);
+	if (err) {
+		f2fs_put_page(ipage, 1);
+		f2fs_unlock_op(sbi);
+		return err;
+	}
+	f2fs_unlock_op(sbi);
+
+	src_addr = inline_data_addr(ipage);
+	dst_addr = page_address(page);
+	zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+	/* Copy the whole inline data block */
+	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
+	zero_user_segment(ipage, INLINE_DATA_OFFSET,
+				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+	clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
+	set_raw_inline(F2FS_I(inode),
+			(struct f2fs_inode *)page_address(ipage));
+
+	set_page_dirty(ipage);
+	f2fs_put_page(ipage, 1);
+	set_page_dirty(page);
+
+	return 0;
+}
+
+int f2fs_convert_inline_data(struct inode *inode,
+			     struct page *p, unsigned flags)
+{
+	int err;
+	struct page *page;
+
+	if (p && !p->index) {
+		page = p;
+	} else {
+		page = grab_cache_page_write_begin(inode->i_mapping, 0, flags);
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+	}
+
+	err = __f2fs_convert_inline_data(inode, page);
+
+	if (p && !p->index)
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
+	if (!f2fs_has_inline_data(inode))
+		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
+	set_raw_inline(F2FS_I(inode),
+			(struct f2fs_inode *)page_address(ipage));
+	set_page_dirty(ipage);
+
+	if ((F2FS_I(inode)->i_xattr_nid && inode->i_blocks == 2) ||
+		(!F2FS_I(inode)->i_xattr_nid && inode->i_blocks == 1)) {
+		f2fs_put_dnode(&dn);
+		return 0;
+	}
+
+	/* Release the first data block if it is allocated */
+	truncate_data_blocks_range(&dn, 1);
+	f2fs_put_dnode(&dn);
+
+	return 0;
+}
-- 
1.7.9.5

