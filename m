Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbaFSIYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 04:24:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19840 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684AbaFSIYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 04:24:12 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-9e-53a29e291ad1
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: support ->tmpfile()
Date: Thu, 19 Jun 2014 16:23:19 +0800
Message-id: <001901cf8b97$d7dea910$879bfb30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+LhUO9NM6/Sc3yRoiPgYBMKenUiA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQV3NeYuCDQ6/07G4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	WraIFSyRqTg2tY+xgbFZvIuRk0NCwETi2bYVjBC2mMSFe+vZuhi5OIQEpjNKXLmxnB3C+cEo
	sfnlWVaQKjYBFYnlHf+ZQGwRAS+JSftPsIDYzAKZEveaZjCD2MJAU59PawezWQRUJf5tngM0
	lYODV8BSonGdDEiYV0BQ4sfke1CtWhLrdx5ngrDlJTavecsMcZCCxI6zrxkhVulJvFv+nxWi
	Rlxi45FbLBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw
	aD+T2sG4ssHiEKMAB6MSD6/HxYXBQqyJZcWVuYcYJTiYlUR4VVMXBQvxpiRWVqUW5ccXleak
	Fh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgbHKX4ZY4FZD/PVzd80uW/oQ5L67W
	Pg7eYXErvrn19Kt3/xrt7YyeSV9bd3jXVcOHBRy3On2qTP2/yTz9d0BxeSpLkSFPkxrbgpVr
	pLjWfD9pEuNlZ7apeFPz++P/X5j+OFERcdrvTZSVyvu/P3oCvykJnH1WUuN9bXZKs0G+49/j
	B71uC7QuU2Ipzkg01GIuKk4EAOJF5ctpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function f2fs_tmpfile() to support O_TMPFILE file creation, and modify logic
of init_inode_metadata to enable linkat temp file.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c   |   10 ++++++++-
 fs/f2fs/namei.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 966acb0..09760d5 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -333,10 +333,12 @@ static int make_empty_dir(struct inode *inode,
 static struct page *init_inode_metadata(struct inode *inode,
 		struct inode *dir, const struct qstr *name)
 {
+	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
 	struct page *page;
 	int err;
 
-	if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE)) {
+	if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE) &&
+			inode->i_nlink) {
 		page = new_inode_page(inode, name);
 		if (IS_ERR(page))
 			return page;
@@ -370,6 +372,12 @@ static struct page *init_inode_metadata(struct inode *inode,
 	 */
 	if (is_inode_flag_set(F2FS_I(inode), FI_INC_LINK)) {
 		file_lost_pino(inode);
+		/*
+		 * If link the tmpfile to alias through linkat path,
+		 * we should remove this inode from orphan list.
+		 */
+		if (inode->i_nlink == 0)
+			remove_orphan_inode(sbi, inode->i_ino);
 		inc_nlink(inode);
 	}
 	return page;
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 9138c32..0d55517 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/sched.h>
 #include <linux/ctype.h>
+#include <linux/dcache.h>
 
 #include "f2fs.h"
 #include "node.h"
@@ -488,6 +489,68 @@ out:
 	return err;
 }
 
+static int f2fs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
+{
+	struct super_block *sb = dir->i_sb;
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	struct inode *inode;
+	struct page *page;
+	int err;
+
+	inode = f2fs_new_inode(dir, mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	inode->i_op = &f2fs_file_inode_operations;
+	inode->i_fop = &f2fs_file_operations;
+	inode->i_mapping->a_ops = &f2fs_dblock_aops;
+
+	f2fs_lock_op(sbi);
+	err = acquire_orphan_inode(sbi);
+	if (err)
+		goto out;
+	/*
+	 * add this non-linked tmpfile to orphan list, in this way we could
+	 * remove all unused data of tmpfile after abnormal power-off.
+	 */
+	add_orphan_inode(sbi, inode->i_ino);
+
+	page = new_inode_page(inode, NULL);
+	if (IS_ERR(page)) {
+		err = PTR_ERR(page);
+		goto remove_out;
+	}
+
+	err = f2fs_init_acl(inode, dir, page);
+	if (err)
+		goto unlock_out;
+
+	err = f2fs_init_security(inode, dir, NULL, page);
+	if (err)
+		goto unlock_out;
+
+	f2fs_put_page(page, 1);
+	f2fs_unlock_op(sbi);
+
+	alloc_nid_done(sbi, inode->i_ino);
+	mark_inode_dirty(inode);
+	d_tmpfile(dentry, inode);
+	unlock_new_inode(inode);
+	return 0;
+unlock_out:
+	f2fs_put_page(page, 1);
+remove_out:
+	remove_orphan_inode(sbi, inode->i_ino);
+out:
+	f2fs_unlock_op(sbi);
+	clear_nlink(inode);
+	unlock_new_inode(inode);
+	make_bad_inode(inode);
+	iput(inode);
+	alloc_nid_failed(sbi, inode->i_ino);
+	return err;
+}
+
 const struct inode_operations f2fs_dir_inode_operations = {
 	.create		= f2fs_create,
 	.lookup		= f2fs_lookup,
@@ -498,6 +561,7 @@ const struct inode_operations f2fs_dir_inode_operations = {
 	.rmdir		= f2fs_rmdir,
 	.mknod		= f2fs_mknod,
 	.rename		= f2fs_rename,
+	.tmpfile	= f2fs_tmpfile,
 	.getattr	= f2fs_getattr,
 	.setattr	= f2fs_setattr,
 	.get_acl	= f2fs_get_acl,
-- 
1.7.9.5


