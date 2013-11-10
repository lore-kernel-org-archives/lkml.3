Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab3KJPTY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 10:19:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:62424 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab3KJPTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 10:19:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="432794219"
From: Huajun Li <huajun.li.lee@gmail.com>
To: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Subject: [f2fs-dev][PATCH V2 3/6] f2fs: Add a new function: f2fs_reserve_block()
Date: Sun, 10 Nov 2013 23:13:18 +0800
Message-Id: <1384096401-25169-4-git-send-email-huajun.li.lee@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
References: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huajun Li <huajun.li@intel.com>

Add the function f2fs_reserve_block() to easily reserve new blocks, and
use it to clean up more codes.

Signed-off-by: Huajun Li <huajun.li@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Weihong Xu <weihong.xu@intel.com>
---
 fs/f2fs/data.c |   50 +++++++++++++++++++++++---------------------------
 fs/f2fs/f2fs.h |    1 +
 fs/f2fs/file.c |   38 ++++++--------------------------------
 3 files changed, 30 insertions(+), 59 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index aa3438c..92d0724 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -64,6 +64,22 @@ int reserve_new_block(struct dnode_of_data *dn)
 	return 0;
 }
 
+int f2fs_reserve_block(struct dnode_of_data *dn, pgoff_t index)
+{
+	bool need_put = dn->inode_page ? false : true;
+	int err;
+
+	err = get_dnode_of_data(dn, index, ALLOC_NODE);
+	if (err)
+		return err;
+	if (dn->data_blkaddr == NULL_ADDR)
+		err = reserve_new_block(dn);
+
+	if (need_put)
+		f2fs_put_dnode(dn);
+	return err;
+}
+
 static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 					struct buffer_head *bh_result)
 {
@@ -300,19 +316,10 @@ struct page *get_new_data_page(struct inode *inode,
 	int err;
 
 	set_new_dnode(&dn, inode, npage, npage, 0);
-	err = get_dnode_of_data(&dn, index, ALLOC_NODE);
+	err = f2fs_reserve_block(&dn, index);
 	if (err)
 		return ERR_PTR(err);
 
-	if (dn.data_blkaddr == NULL_ADDR) {
-		if (reserve_new_block(&dn)) {
-			if (!npage)
-				f2fs_put_dnode(&dn);
-			return ERR_PTR(-ENOSPC);
-		}
-	}
-	if (!npage)
-		f2fs_put_dnode(&dn);
 repeat:
 	page = grab_cache_page(mapping, index);
 	if (!page)
@@ -644,21 +651,15 @@ repeat:
 	*pagep = page;
 
 	f2fs_lock_op(sbi);
-
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = get_dnode_of_data(&dn, index, ALLOC_NODE);
-	if (err)
-		goto err;
-
-	if (dn.data_blkaddr == NULL_ADDR)
-		err = reserve_new_block(&dn);
-
-	f2fs_put_dnode(&dn);
-	if (err)
-		goto err;
-
+	err = f2fs_reserve_block(&dn, index);
 	f2fs_unlock_op(sbi);
 
+	if (err) {
+		f2fs_put_page(page, 1);
+		return err;
+	}
+
 	if ((len == PAGE_CACHE_SIZE) || PageUptodate(page))
 		return 0;
 
@@ -691,11 +692,6 @@ out:
 	SetPageUptodate(page);
 	clear_cold_data(page);
 	return 0;
-
-err:
-	f2fs_unlock_op(sbi);
-	f2fs_put_page(page, 1);
-	return err;
 }
 
 static int f2fs_write_end(struct file *file,
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cd7d2f9..de84f52 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1119,6 +1119,7 @@ void destroy_checkpoint_caches(void);
  * data.c
  */
 int reserve_new_block(struct dnode_of_data *);
+int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
 void update_extent_cache(block_t, struct dnode_of_data *);
 struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7d714f4..1cd8e44 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -33,7 +33,6 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 	struct page *page = vmf->page;
 	struct inode *inode = file_inode(vma->vm_file);
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	block_t old_blk_addr;
 	struct dnode_of_data dn;
 	int err;
 
@@ -44,24 +43,10 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 	/* block allocation */
 	f2fs_lock_op(sbi);
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = get_dnode_of_data(&dn, page->index, ALLOC_NODE);
-	if (err) {
-		f2fs_unlock_op(sbi);
-		goto out;
-	}
-
-	old_blk_addr = dn.data_blkaddr;
-
-	if (old_blk_addr == NULL_ADDR) {
-		err = reserve_new_block(&dn);
-		if (err) {
-			f2fs_put_dnode(&dn);
-			f2fs_unlock_op(sbi);
-			goto out;
-		}
-	}
-	f2fs_put_dnode(&dn);
+	err = f2fs_reserve_block(&dn, page->index);
 	f2fs_unlock_op(sbi);
+	if (err)
+		goto out;
 
 	file_update_time(vma->vm_file);
 	lock_page(page);
@@ -532,22 +517,11 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 
 		f2fs_lock_op(sbi);
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
-		ret = get_dnode_of_data(&dn, index, ALLOC_NODE);
-		if (ret) {
-			f2fs_unlock_op(sbi);
+		ret = f2fs_reserve_block(&dn, index);
+		f2fs_unlock_op(sbi);
+		if (ret)
 			break;
-		}
 
-		if (dn.data_blkaddr == NULL_ADDR) {
-			ret = reserve_new_block(&dn);
-			if (ret) {
-				f2fs_put_dnode(&dn);
-				f2fs_unlock_op(sbi);
-				break;
-			}
-		}
-		f2fs_put_dnode(&dn);
-		f2fs_unlock_op(sbi);
 
 		if (pg_start == pg_end)
 			new_size = offset + len;
-- 
1.7.9.5

