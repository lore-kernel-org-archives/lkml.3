Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaIXKUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:20:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14935 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbaIXKUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:20:09 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-2c-54229ad740b8
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 5/6 v2] f2fs: enable inline dir handling
Date: Wed, 24 Sep 2014 18:19:10 +0800
Message-id: <004001cfd7e1$1b5e92f0$521bb8d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/X357PWqGGWa3/QhWCVKLLaFfnsg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd3rs5RCDNavVrG4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxo2rzcwF
	760r9l7pYW1g/G/QxcjJISFgInH97C42CFtM4sK99UA2F4eQwHRGia43z1ghnB+MEr/mtjCD
	VLEJqEgs7/jPBGKLCHhJTNp/ggXEZhbwkGjs+M4KYgsLOEmcuvcZbCqLgKrEsZ0zwGp4BSwl
	Nnw7yQphC0r8mHwPqldLYv3O40wQtrzE5jVvmSEuUpDYcfY1I8QuPYmZZ+ZD1YtLbDxyi2UC
	o8AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDupn0jsYVzVY
	HGIU4GBU4uGdIK4UIsSaWFZcmXuIUYKDWUmE91UPUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjv
	wVbrQCGB9MSS1OzU1ILUIpgsEwenVAPjZu3vize+n2jqcdLN/OiufPZlh75Oer8jrqixdYOV
	vXGKrljK45PM3y13VDl+M/XzqZn3W/LRhq/hu/WbrnPYZMn4ui4wr5PasLNrj2qcPbftw0nN
	P95Jtuuujlnm9jVALPboSoXFV24uNM3w2jB5lVu+MLPnv5j1jjtmbn5o9+B6xIpfUWfvKbEU
	ZyQaajEXFScCAA/bTO1mAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add inline dir functions into normal dir ops' function to handle inline ops.
Besides, we enable inline dir mode when a new dir inode is created if
inline_data option is on.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c      | 32 ++++++++++++++++++++++++++++++--
 fs/f2fs/file.c     |  2 +-
 fs/f2fs/inline.c   |  2 +-
 fs/f2fs/namei.c    | 34 ++++++++++++++++++++++++----------
 fs/f2fs/recovery.c |  3 ++-
 5 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 99e944e..cc6474a 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -201,6 +201,9 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *dir,
 	unsigned int max_depth;
 	unsigned int level;
 
+	if (f2fs_has_inline_dentry(dir))
+		return find_in_inline_dir(dir, child, res_page);
+
 	if (npages == 0)
 		return NULL;
 
@@ -227,6 +230,9 @@ struct f2fs_dir_entry *f2fs_parent_dir(struct inode *dir, struct page **p)
 	struct f2fs_dir_entry *de;
 	struct f2fs_dentry_block *dentry_blk;
 
+	if (f2fs_has_inline_dentry(dir))
+		return f2fs_parent_inline_dir(dir, p);
+
 	page = get_lock_data_page(dir, 0);
 	if (IS_ERR(page))
 		return NULL;
@@ -247,7 +253,8 @@ ino_t f2fs_inode_by_name(struct inode *dir, struct qstr *qstr)
 	de = f2fs_find_entry(dir, qstr, &page);
 	if (de) {
 		res = le32_to_cpu(de->ino);
-		kunmap(page);
+		if (!f2fs_has_inline_dentry(dir))
+			kunmap(page);
 		f2fs_put_page(page, 0);
 	}
 
@@ -261,7 +268,8 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
 	f2fs_wait_on_page_writeback(page, DATA);
 	de->ino = cpu_to_le32(inode->i_ino);
 	set_de_type(de, inode);
-	kunmap(page);
+	if (!f2fs_has_inline_dentry(dir))
+		kunmap(page);
 	set_page_dirty(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(dir);
@@ -303,6 +311,9 @@ static int make_empty_dir(struct inode *inode,
 	struct f2fs_dentry_block *dentry_blk;
 	struct f2fs_dir_entry *de;
 
+	if (f2fs_has_inline_dentry(inode))
+		return make_empty_inline_dir(inode, parent, page);
+
 	dentry_page = get_new_data_page(inode, page, 0, true);
 	if (IS_ERR(dentry_page))
 		return PTR_ERR(dentry_page);
@@ -462,6 +473,14 @@ int __f2fs_add_link(struct inode *dir, const struct qstr *name,
 	int err = 0;
 	int i;
 
+	if (f2fs_has_inline_dentry(dir)) {
+		err = f2fs_add_inline_entry(dir, name, inode);
+		if (!err || err != -EAGAIN)
+			return err;
+		else
+			err = 0;
+	}
+
 	dentry_hash = f2fs_dentry_hash(name);
 	level = 0;
 	current_depth = F2FS_I(dir)->i_current_depth;
@@ -600,6 +619,9 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	int slots = GET_DENTRY_SLOTS(le16_to_cpu(dentry->name_len));
 	int i;
 
+	if (f2fs_has_inline_dentry(dir))
+		return f2fs_delete_inline_entry(dentry, page, dir, inode);
+
 	lock_page(page);
 	f2fs_wait_on_page_writeback(page, DATA);
 
@@ -637,6 +659,9 @@ bool f2fs_empty_dir(struct inode *dir)
 	struct f2fs_dentry_block *dentry_blk;
 	unsigned long nblock = dir_blocks(dir);
 
+	if (f2fs_has_inline_dentry(dir))
+		return f2fs_empty_inline_dir(dir);
+
 	for (bidx = 0; bidx < nblock; bidx++) {
 		dentry_page = get_lock_data_page(dir, bidx);
 		if (IS_ERR(dentry_page)) {
@@ -676,6 +701,9 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 	unsigned int n = ((unsigned long)ctx->pos / NR_DENTRY_IN_BLOCK);
 	unsigned char d_type = DT_UNKNOWN;
 
+	if (f2fs_has_inline_dentry(inode))
+		return f2fs_read_inline_dir(file, ctx);
+
 	bit_pos = ((unsigned long)ctx->pos % NR_DENTRY_IN_BLOCK);
 
 	/* readahead for multi pages of dir */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 1184207..e1735b4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -296,7 +296,7 @@ static loff_t f2fs_seek_block(struct file *file, loff_t offset, int whence)
 		goto fail;
 
 	/* handle inline data case */
-	if (f2fs_has_inline_data(inode)) {
+	if (f2fs_has_inline_data(inode) || f2fs_has_inline_dentry(inode)) {
 		if (whence == SEEK_HOLE)
 			data_ofs = isize;
 		goto found;
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 3c85def..358194d 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -421,7 +421,7 @@ int f2fs_convert_inline_dir(struct inode *dir, struct page *ipage,
 	/* clear inline dir and flag after data writeback */
 	zero_user_segment(ipage, INLINE_DATA_OFFSET,
 				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
-
+	clear_inode_flag(F2FS_I(dir), FI_INLINE_DENTRY);
 	stat_dec_inline_inode(dir);
 
 	if (i_size_read(dir) < PAGE_CACHE_SIZE) {
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 58c1276..788e926 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -54,6 +54,10 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 		nid_free = true;
 		goto out;
 	}
+
+	if (test_opt(sbi, INLINE_DENTRY) && S_ISDIR(inode->i_mode))
+		set_inode_flag(F2FS_I(inode), FI_INLINE_DENTRY);
+
 	trace_f2fs_new_inode(inode, 0);
 	mark_inode_dirty(inode);
 	return inode;
@@ -188,7 +192,8 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 	de = f2fs_find_entry(dir, &dentry->d_name, &page);
 	if (de) {
 		nid_t ino = le32_to_cpu(de->ino);
-		kunmap(page);
+		if (!f2fs_has_inline_dentry(dir))
+			kunmap(page);
 		f2fs_put_page(page, 0);
 
 		inode = f2fs_iget(dir->i_sb, ino);
@@ -220,7 +225,8 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	err = acquire_orphan_inode(sbi);
 	if (err) {
 		f2fs_unlock_op(sbi);
-		kunmap(page);
+		if (!f2fs_has_inline_dentry(dir))
+			kunmap(page);
 		f2fs_put_page(page, 0);
 		goto fail;
 	}
@@ -450,7 +456,8 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 						old_dir_page, new_dir);
 			update_inode_page(old_inode);
 		} else {
-			kunmap(old_dir_page);
+			if (!f2fs_has_inline_dentry(old_inode))
+				kunmap(old_dir_page);
 			f2fs_put_page(old_dir_page, 0);
 		}
 		drop_nlink(old_dir);
@@ -463,15 +470,18 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 put_out_dir:
 	f2fs_unlock_op(sbi);
-	kunmap(new_page);
+	if (!f2fs_has_inline_dentry(new_dir))
+		kunmap(new_page);
 	f2fs_put_page(new_page, 0);
 out_dir:
 	if (old_dir_entry) {
-		kunmap(old_dir_page);
+		if (!f2fs_has_inline_dentry(old_inode))
+			kunmap(old_dir_page);
 		f2fs_put_page(old_dir_page, 0);
 	}
 out_old:
-	kunmap(old_page);
+	if (!f2fs_has_inline_dentry(old_dir))
+		kunmap(old_page);
 	f2fs_put_page(old_page, 0);
 out:
 	return err;
@@ -603,19 +613,23 @@ out_unlock:
 	f2fs_unlock_op(sbi);
 out_new_dir:
 	if (new_dir_entry) {
-		kunmap(new_dir_page);
+		if (!f2fs_has_inline_dentry(new_inode))
+			kunmap(new_dir_page);
 		f2fs_put_page(new_dir_page, 0);
 	}
 out_old_dir:
 	if (old_dir_entry) {
-		kunmap(old_dir_page);
+		if (!f2fs_has_inline_dentry(old_inode))
+			kunmap(old_dir_page);
 		f2fs_put_page(old_dir_page, 0);
 	}
 out_new:
-	kunmap(new_page);
+	if (!f2fs_has_inline_dentry(new_dir))
+		kunmap(new_page);
 	f2fs_put_page(new_page, 0);
 out_old:
-	kunmap(old_page);
+	if (!f2fs_has_inline_dentry(old_dir))
+		kunmap(old_page);
 	f2fs_put_page(old_page, 0);
 out:
 	return err;
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index fdbcea4..9ce392d0 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -129,7 +129,8 @@ retry:
 	goto out;
 
 out_unmap_put:
-	kunmap(page);
+	if (!f2fs_has_inline_dentry(dir))
+		kunmap(page);
 	f2fs_put_page(page, 0);
 out_err:
 	iput(dir);
-- 
2.0.1.474.g72c7794


