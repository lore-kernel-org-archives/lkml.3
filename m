Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaLOH1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:27:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:34427 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbaLOH1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:27:43 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/7] f2fs: don't need to call lock_op and lock_page for abort
Date: Sun, 14 Dec 2014 23:27:34 -0800
Message-Id: <1418628458-82740-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
References: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to call lock_op and lock_page at the aborting path.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/segment.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 11e4b5c..3ce86c5 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -240,33 +240,38 @@ void commit_inmem_pages(struct inode *inode, bool abort)
 	 * Otherwise, f2fs_gc in f2fs_balance_fs can wait forever until this
 	 * inode becomes free by iget_locked in f2fs_iget.
 	 */
-	if (!abort)
+	if (!abort) {
 		f2fs_balance_fs(sbi);
-
-	f2fs_lock_op(sbi);
+		f2fs_lock_op(sbi);
+	}
 
 	mutex_lock(&fi->inmem_lock);
 	list_for_each_entry_safe(cur, tmp, &fi->inmem_pages, list) {
-		lock_page(cur->page);
-		if (!abort && cur->page->mapping == inode->i_mapping) {
-			f2fs_wait_on_page_writeback(cur->page, DATA);
-			if (clear_page_dirty_for_io(cur->page))
-				inode_dec_dirty_pages(inode);
-			do_write_data_page(cur->page, &fio);
-			submit_bio = true;
+		if (!abort) {
+			lock_page(cur->page);
+			if (cur->page->mapping == inode->i_mapping) {
+				f2fs_wait_on_page_writeback(cur->page, DATA);
+				if (clear_page_dirty_for_io(cur->page))
+					inode_dec_dirty_pages(inode);
+				do_write_data_page(cur->page, &fio);
+				submit_bio = true;
+			}
+			f2fs_put_page(cur->page, 1);
+		} else {
+			put_page(cur->page);
 		}
 		radix_tree_delete(&fi->inmem_root, cur->page->index);
-		f2fs_put_page(cur->page, 1);
 		list_del(&cur->list);
 		kmem_cache_free(inmem_entry_slab, cur);
 		dec_page_count(F2FS_I_SB(inode), F2FS_INMEM_PAGES);
 	}
-	if (submit_bio)
-		f2fs_submit_merged_bio(sbi, DATA, WRITE);
 	mutex_unlock(&fi->inmem_lock);
 
-	filemap_fdatawait_range(inode->i_mapping, 0, LLONG_MAX);
-	f2fs_unlock_op(sbi);
+	if (!abort) {
+		f2fs_unlock_op(sbi);
+		if (submit_bio)
+			f2fs_submit_merged_bio(sbi, DATA, WRITE);
+	}
 }
 
 /*
-- 
2.1.1

