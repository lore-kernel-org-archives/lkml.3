Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaLOH2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:28:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:34462 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbaLOH1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:27:47 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6/7] f2fs: remove unnecessary call to invalidate inmemory pages
Date: Sun, 14 Dec 2014 23:27:37 -0800
Message-Id: <1418628458-82740-6-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
References: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we use inmemory pages for atomic write only and provide abort procedure,
we don't need to truncate them explicitly.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c    |  3 ---
 fs/f2fs/f2fs.h    |  1 -
 fs/f2fs/segment.c | 17 -----------------
 3 files changed, 21 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 32264e3..caa08e4 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1114,9 +1114,6 @@ static void f2fs_invalidate_data_page(struct page *page, unsigned int offset,
 	if (offset % PAGE_CACHE_SIZE || length != PAGE_CACHE_SIZE)
 		return;
 
-	if (f2fs_is_atomic_file(inode))
-		invalidate_inmem_page(inode, page);
-
 	if (PageDirty(page))
 		inode_dec_dirty_pages(inode);
 	ClearPagePrivate(page);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 8c9bf3d..d3699da 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1397,7 +1397,6 @@ void destroy_node_manager_caches(void);
  * segment.c
  */
 void register_inmem_page(struct inode *, struct page *);
-void invalidate_inmem_page(struct inode *, struct page *);
 void commit_inmem_pages(struct inode *, bool);
 void f2fs_balance_fs(struct f2fs_sb_info *);
 void f2fs_balance_fs_bg(struct f2fs_sb_info *);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 335418c..3791fa9 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -205,23 +205,6 @@ retry:
 	mutex_unlock(&fi->inmem_lock);
 }
 
-void invalidate_inmem_page(struct inode *inode, struct page *page)
-{
-	struct f2fs_inode_info *fi = F2FS_I(inode);
-	struct inmem_pages *cur;
-
-	mutex_lock(&fi->inmem_lock);
-	cur = radix_tree_lookup(&fi->inmem_root, page->index);
-	if (cur) {
-		radix_tree_delete(&fi->inmem_root, cur->page->index);
-		f2fs_put_page(cur->page, 0);
-		list_del(&cur->list);
-		kmem_cache_free(inmem_entry_slab, cur);
-		dec_page_count(F2FS_I_SB(inode), F2FS_INMEM_PAGES);
-	}
-	mutex_unlock(&fi->inmem_lock);
-}
-
 void commit_inmem_pages(struct inode *inode, bool abort)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-- 
2.1.1

