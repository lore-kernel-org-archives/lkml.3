Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaJTFTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:19:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:59726 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbaJTFSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:18:36 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 02/09] f2fs: invalidate inmemory page
Date: Sun, 19 Oct 2014 22:18:25 -0700
Message-Id: <1413782312-11631-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
References: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user truncates file's data, we should truncate inmemory pages too.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c    |  3 +++
 fs/f2fs/f2fs.h    |  1 +
 fs/f2fs/segment.c | 16 ++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 84f20e9..5b80ada 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1116,6 +1116,9 @@ static void f2fs_invalidate_data_page(struct page *page, unsigned int offset,
 	if (offset % PAGE_CACHE_SIZE || length != PAGE_CACHE_SIZE)
 		return;
 
+	if (f2fs_is_atomic_file(inode) || f2fs_is_volatile_file(inode))
+		invalidate_inmem_page(inode, page);
+
 	if (PageDirty(page))
 		inode_dec_dirty_pages(inode);
 	ClearPagePrivate(page);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 28f24ea..d41d1b7 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1297,6 +1297,7 @@ void destroy_node_manager_caches(void);
  * segment.c
  */
 void register_inmem_page(struct inode *, struct page *);
+void invalidate_inmem_page(struct inode *, struct page *);
 void commit_inmem_pages(struct inode *, bool);
 void f2fs_balance_fs(struct f2fs_sb_info *);
 void f2fs_balance_fs_bg(struct f2fs_sb_info *);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 9d4a7ab..902c4c3 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -203,6 +203,22 @@ retry:
 	mutex_unlock(&fi->inmem_lock);
 }
 
+void invalidate_inmem_page(struct inode *inode, struct page *page)
+{
+	struct f2fs_inode_info *fi = F2FS_I(inode);
+	struct inmem_pages *cur;
+
+	mutex_lock(&fi->inmem_lock);
+	cur = radix_tree_lookup(&fi->inmem_root, page->index);
+	if (cur) {
+		radix_tree_delete(&fi->inmem_root, cur->page->index);
+		f2fs_put_page(cur->page, 0);
+		list_del(&cur->list);
+		kmem_cache_free(inmem_entry_slab, cur);
+	}
+	mutex_unlock(&fi->inmem_lock);
+}
+
 void commit_inmem_pages(struct inode *inode, bool abort)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-- 
2.1.1

