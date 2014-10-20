Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaJTFTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:19:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:59769 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbaJTFSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:18:42 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 06/09] f2fs: avoid to allocate when inline_data was written
Date: Sun, 19 Oct 2014 22:18:29 -0700
Message-Id: <1413782312-11631-6-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
References: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sceanrio is like this.
inline_data   i_size     page                 write_begin/vm_page_mkwrite
  X             30       dirty_page
  X             30                            write to #4096 position
  X             30       get_dnode_of_data    wait for get_dnode_of_data
  O             30       write inline_data
  O             30                            get_dnode_of_data
  O             30                            reserve data block
..

In this case, we have #0 = NEW_ADDR and inline_data as well.
We should not allow this condition for further access.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c | 32 +++++++++++++++++++++++---------
 fs/f2fs/file.c | 26 ++++++++++++++++++++++----
 2 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 5b80ada..973fd77 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -257,9 +257,6 @@ int f2fs_reserve_block(struct dnode_of_data *dn, pgoff_t index)
 	bool need_put = dn->inode_page ? false : true;
 	int err;
 
-	/* if inode_page exists, index should be zero */
-	f2fs_bug_on(F2FS_I_SB(dn->inode), !need_put && index);
-
 	err = get_dnode_of_data(dn, index, ALLOC_NODE);
 	if (err)
 		return err;
@@ -951,7 +948,7 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 {
 	struct inode *inode = mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct page *page;
+	struct page *page, *ipage;
 	pgoff_t index = ((unsigned long long) pos) >> PAGE_CACHE_SHIFT;
 	struct dnode_of_data dn;
 	int err = 0;
@@ -979,13 +976,26 @@ repeat:
 		goto inline_data;
 
 	f2fs_lock_op(sbi);
-	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = f2fs_reserve_block(&dn, index);
-	f2fs_unlock_op(sbi);
-	if (err) {
+
+	/* check inline_data */
+	ipage = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(ipage))
+		goto unlock_fail;
+
+	if (f2fs_has_inline_data(inode)) {
+		f2fs_put_page(ipage, 1);
+		f2fs_unlock_op(sbi);
 		f2fs_put_page(page, 0);
-		goto fail;
+		goto repeat;
 	}
+
+	set_new_dnode(&dn, inode, ipage, NULL, 0);
+	err = f2fs_reserve_block(&dn, index);
+	if (err)
+		goto unlock_fail;
+	f2fs_put_dnode(&dn);
+	f2fs_unlock_op(sbi);
+
 inline_data:
 	lock_page(page);
 	if (unlikely(page->mapping != mapping)) {
@@ -1038,6 +1048,10 @@ out:
 	SetPageUptodate(page);
 	clear_cold_data(page);
 	return 0;
+
+unlock_fail:
+	f2fs_unlock_op(sbi);
+	f2fs_put_page(page, 0);
 fail:
 	f2fs_write_failed(mapping, pos + len);
 	return err;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 543d8c6..456df07 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -35,12 +35,13 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 	struct inode *inode = file_inode(vma->vm_file);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dnode_of_data dn;
+	struct page *ipage;
 	int err;
 
 	f2fs_balance_fs(sbi);
 
 	sb_start_pagefault(inode->i_sb);
-
+retry:
 	/* force to convert with normal data indices */
 	err = f2fs_convert_inline_data(inode, MAX_INLINE_DATA + 1, page);
 	if (err)
@@ -48,11 +49,28 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 
 	/* block allocation */
 	f2fs_lock_op(sbi);
-	set_new_dnode(&dn, inode, NULL, NULL, 0);
+
+	/* check inline_data */
+	ipage = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(ipage)) {
+		f2fs_unlock_op(sbi);
+		goto out;
+	}
+
+	if (f2fs_has_inline_data(inode)) {
+		f2fs_put_page(ipage, 1);
+		f2fs_unlock_op(sbi);
+		goto retry;
+	}
+
+	set_new_dnode(&dn, inode, ipage, NULL, 0);
 	err = f2fs_reserve_block(&dn, page->index);
-	f2fs_unlock_op(sbi);
-	if (err)
+	if (err) {
+		f2fs_unlock_op(sbi);
 		goto out;
+	}
+	f2fs_put_dnode(&dn);
+	f2fs_unlock_op(sbi);
 
 	file_update_time(vma->vm_file);
 	lock_page(page);
-- 
2.1.1

