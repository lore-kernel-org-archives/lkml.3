Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaINWOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 18:14:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:32828 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009AbaINWO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 18:14:28 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 03/10] f2fs: expand counting dirty pages in the inode page cache
Date: Sun, 14 Sep 2014 15:14:17 -0700
Message-Id: <1410732864-53069-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
References: <1410732864-53069-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously f2fs only counts dirty dentry pages, but there is no reason not to
expand the scope.

This patch changes the names on the management of dirty pages and to count
dirty pages in each inode info as well.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 10 ++++++----
 fs/f2fs/data.c       | 10 +++++-----
 fs/f2fs/dir.c        |  2 +-
 fs/f2fs/f2fs.h       | 24 ++++++++++++------------
 fs/f2fs/gc.c         |  2 +-
 fs/f2fs/inode.c      |  2 +-
 fs/f2fs/super.c      |  2 +-
 7 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 935a56e..7262d99 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -627,14 +627,16 @@ static int __add_dirty_inode(struct inode *inode, struct dir_inode_entry *new)
 	return 0;
 }
 
-void set_dirty_dir_page(struct inode *inode, struct page *page)
+void update_dirty_page(struct inode *inode, struct page *page)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct dir_inode_entry *new;
 	int ret = 0;
 
-	if (!S_ISDIR(inode->i_mode))
+	if (!S_ISDIR(inode->i_mode)) {
+		inode_inc_dirty_pages(inode);
 		return;
+	}
 
 	new = f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
 	new->inode = inode;
@@ -642,7 +644,7 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
 
 	spin_lock(&sbi->dir_inode_lock);
 	ret = __add_dirty_inode(inode, new);
-	inode_inc_dirty_dents(inode);
+	inode_inc_dirty_pages(inode);
 	SetPagePrivate(page);
 	spin_unlock(&sbi->dir_inode_lock);
 
@@ -677,7 +679,7 @@ void remove_dirty_dir_inode(struct inode *inode)
 		return;
 
 	spin_lock(&sbi->dir_inode_lock);
-	if (get_dirty_dents(inode) ||
+	if (get_dirty_pages(inode) ||
 			!is_inode_flag_set(F2FS_I(inode), FI_DIRTY_DIR)) {
 		spin_unlock(&sbi->dir_inode_lock);
 		return;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 64d8550..6637741 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -863,7 +863,7 @@ done:
 
 	clear_cold_data(page);
 out:
-	inode_dec_dirty_dents(inode);
+	inode_dec_dirty_pages(inode);
 	unlock_page(page);
 	if (need_balance_fs)
 		f2fs_balance_fs(sbi);
@@ -901,7 +901,7 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 		return 0;
 
 	if (S_ISDIR(inode->i_mode) && wbc->sync_mode == WB_SYNC_NONE &&
-			get_dirty_dents(inode) < nr_pages_to_skip(sbi, DATA) &&
+			get_dirty_pages(inode) < nr_pages_to_skip(sbi, DATA) &&
 			available_free_memory(sbi, DIRTY_DENTS))
 		goto skip_write;
 
@@ -923,7 +923,7 @@ static int f2fs_write_data_pages(struct address_space *mapping,
 	return ret;
 
 skip_write:
-	wbc->pages_skipped += get_dirty_dents(inode);
+	wbc->pages_skipped += get_dirty_pages(inode);
 	return 0;
 }
 
@@ -1108,7 +1108,7 @@ static void f2fs_invalidate_data_page(struct page *page, unsigned int offset,
 {
 	struct inode *inode = page->mapping->host;
 	if (PageDirty(page))
-		inode_dec_dirty_dents(inode);
+		inode_dec_dirty_pages(inode);
 	ClearPagePrivate(page);
 }
 
@@ -1130,7 +1130,7 @@ static int f2fs_set_data_page_dirty(struct page *page)
 
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
-		set_dirty_dir_page(inode, page);
+		update_dirty_page(inode, page);
 		return 1;
 	}
 	return 0;
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index f1ceeb2..b54f871 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -618,7 +618,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 		truncate_hole(dir, page->index, page->index + 1);
 		clear_page_dirty_for_io(page);
 		ClearPageUptodate(page);
-		inode_dec_dirty_dents(dir);
+		inode_dec_dirty_pages(dir);
 	}
 	f2fs_put_page(page, 1);
 }
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1def9ee..2756c16 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -237,7 +237,7 @@ struct f2fs_inode_info {
 	/* Use below internally in f2fs*/
 	unsigned long flags;		/* use to pass per-file flags */
 	struct rw_semaphore i_sem;	/* protect fi info */
-	atomic_t dirty_dents;		/* # of dirty dentry pages */
+	atomic_t dirty_pages;		/* # of dirty pages */
 	f2fs_hash_t chash;		/* hash value of given file name */
 	unsigned int clevel;		/* maximum level of given file name */
 	nid_t i_xattr_nid;		/* node id that contains xattrs */
@@ -747,10 +747,11 @@ static inline void inc_page_count(struct f2fs_sb_info *sbi, int count_type)
 	F2FS_SET_SB_DIRT(sbi);
 }
 
-static inline void inode_inc_dirty_dents(struct inode *inode)
+static inline void inode_inc_dirty_pages(struct inode *inode)
 {
-	inc_page_count(F2FS_I_SB(inode), F2FS_DIRTY_DENTS);
-	atomic_inc(&F2FS_I(inode)->dirty_dents);
+	atomic_inc(&F2FS_I(inode)->dirty_pages);
+	if (S_ISDIR(inode->i_mode))
+		inc_page_count(F2FS_I_SB(inode), F2FS_DIRTY_DENTS);
 }
 
 static inline void dec_page_count(struct f2fs_sb_info *sbi, int count_type)
@@ -758,13 +759,12 @@ static inline void dec_page_count(struct f2fs_sb_info *sbi, int count_type)
 	atomic_dec(&sbi->nr_pages[count_type]);
 }
 
-static inline void inode_dec_dirty_dents(struct inode *inode)
+static inline void inode_dec_dirty_pages(struct inode *inode)
 {
-	if (!S_ISDIR(inode->i_mode))
-		return;
+	atomic_dec(&F2FS_I(inode)->dirty_pages);
 
-	dec_page_count(F2FS_I_SB(inode), F2FS_DIRTY_DENTS);
-	atomic_dec(&F2FS_I(inode)->dirty_dents);
+	if (S_ISDIR(inode->i_mode))
+		dec_page_count(F2FS_I_SB(inode), F2FS_DIRTY_DENTS);
 }
 
 static inline int get_pages(struct f2fs_sb_info *sbi, int count_type)
@@ -772,9 +772,9 @@ static inline int get_pages(struct f2fs_sb_info *sbi, int count_type)
 	return atomic_read(&sbi->nr_pages[count_type]);
 }
 
-static inline int get_dirty_dents(struct inode *inode)
+static inline int get_dirty_pages(struct inode *inode)
 {
-	return atomic_read(&F2FS_I(inode)->dirty_dents);
+	return atomic_read(&F2FS_I(inode)->dirty_pages);
 }
 
 static inline int get_blocktype_secs(struct f2fs_sb_info *sbi, int block_type)
@@ -1302,7 +1302,7 @@ void add_orphan_inode(struct f2fs_sb_info *, nid_t);
 void remove_orphan_inode(struct f2fs_sb_info *, nid_t);
 void recover_orphan_inodes(struct f2fs_sb_info *);
 int get_valid_checkpoint(struct f2fs_sb_info *);
-void set_dirty_dir_page(struct inode *, struct page *);
+void update_dirty_page(struct inode *, struct page *);
 void add_dirty_dir_inode(struct inode *);
 void remove_dirty_dir_inode(struct inode *);
 void sync_dirty_dir_inodes(struct f2fs_sb_info *);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 075ea1e..dca7818 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -537,7 +537,7 @@ static void move_data_page(struct inode *inode, struct page *page, int gc_type)
 		f2fs_wait_on_page_writeback(page, DATA);
 
 		if (clear_page_dirty_for_io(page))
-			inode_dec_dirty_dents(inode);
+			inode_dec_dirty_pages(inode);
 		set_cold_data(page);
 		do_write_data_page(page, &fio);
 		clear_cold_data(page);
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 95c0bc2..ff95547 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -276,7 +276,7 @@ void f2fs_evict_inode(struct inode *inode)
 			inode->i_ino == F2FS_META_INO(sbi))
 		goto out_clear;
 
-	f2fs_bug_on(sbi, get_dirty_dents(inode));
+	f2fs_bug_on(sbi, get_dirty_pages(inode));
 	remove_dirty_dir_inode(inode);
 
 	if (inode->i_nlink || is_bad_inode(inode))
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 3275e73..b5af9be 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -366,7 +366,7 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 
 	/* Initialize f2fs-specific inode info */
 	fi->vfs_inode.i_version = 1;
-	atomic_set(&fi->dirty_dents, 0);
+	atomic_set(&fi->dirty_pages, 0);
 	fi->i_current_depth = 1;
 	fi->i_advise = 0;
 	rwlock_init(&fi->ext.ext_lock);
-- 
1.8.5.2 (Apple Git-48)

