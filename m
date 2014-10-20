Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaJTFSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:18:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:59715 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaJTFSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:18:35 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 01/09] f2fs: do not make dirty any inmemory pages
Date: Sun, 19 Oct 2014 22:18:24 -0700
Message-Id: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch let inmemory pages be clean all the time.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c    | 11 +++++++----
 fs/f2fs/f2fs.h    |  1 +
 fs/f2fs/segment.c | 14 +++++++++++++-
 fs/f2fs/super.c   |  1 +
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8e58c4c..84f20e9 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1052,10 +1052,7 @@ static int f2fs_write_end(struct file *file,
 
 	trace_f2fs_write_end(inode, pos, len, copied);
 
-	if (f2fs_is_atomic_file(inode) || f2fs_is_volatile_file(inode))
-		register_inmem_page(inode, page);
-	else
-		set_page_dirty(page);
+	set_page_dirty(page);
 
 	if (pos + copied > i_size_read(inode)) {
 		i_size_write(inode, pos + copied);
@@ -1138,6 +1135,12 @@ static int f2fs_set_data_page_dirty(struct page *page)
 	trace_f2fs_set_page_dirty(page, DATA);
 
 	SetPageUptodate(page);
+
+	if (f2fs_is_atomic_file(inode) || f2fs_is_volatile_file(inode)) {
+		register_inmem_page(inode, page);
+		return 1;
+	}
+
 	mark_inode_dirty(inode);
 
 	if (!PageDirty(page)) {
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 8171e80..28f24ea 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -269,6 +269,7 @@ struct f2fs_inode_info {
 	struct extent_info ext;		/* in-memory extent cache entry */
 	struct dir_inode_entry *dirty_dir;	/* the pointer of dirty dir */
 
+	struct radix_tree_root inmem_root;	/* radix tree for inmem pages */
 	struct list_head inmem_pages;	/* inmemory pages managed by f2fs */
 	struct mutex inmem_lock;	/* lock for inmemory pages */
 };
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 923cb76..9d4a7ab 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -178,7 +178,8 @@ void register_inmem_page(struct inode *inode, struct page *page)
 {
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct inmem_pages *new;
-
+	int err;
+retry:
 	new = f2fs_kmem_cache_alloc(inmem_entry_slab, GFP_NOFS);
 
 	/* add atomic page indices to the list */
@@ -187,6 +188,16 @@ void register_inmem_page(struct inode *inode, struct page *page)
 
 	/* increase reference count with clean state */
 	mutex_lock(&fi->inmem_lock);
+	err = radix_tree_insert(&fi->inmem_root, page->index, new);
+	if (err == -EEXIST) {
+		mutex_unlock(&fi->inmem_lock);
+		kmem_cache_free(inmem_entry_slab, new);
+		return;
+	} else if (err) {
+		mutex_unlock(&fi->inmem_lock);
+		kmem_cache_free(inmem_entry_slab, new);
+		goto retry;
+	}
 	get_page(page);
 	list_add_tail(&new->list, &fi->inmem_pages);
 	mutex_unlock(&fi->inmem_lock);
@@ -216,6 +227,7 @@ void commit_inmem_pages(struct inode *inode, bool abort)
 			do_write_data_page(cur->page, &fio);
 			submit_bio = true;
 		}
+		radix_tree_delete(&fi->inmem_root, cur->page->index);
 		f2fs_put_page(cur->page, 1);
 		list_del(&cur->list);
 		kmem_cache_free(inmem_entry_slab, cur);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 41d6f70..76b14c8 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -373,6 +373,7 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 	fi->i_advise = 0;
 	rwlock_init(&fi->ext.ext_lock);
 	init_rwsem(&fi->i_sem);
+	INIT_RADIX_TREE(&fi->inmem_root, GFP_NOFS);
 	INIT_LIST_HEAD(&fi->inmem_pages);
 	mutex_init(&fi->inmem_lock);
 
-- 
2.1.1

