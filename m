Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402AbaGYWsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:48:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:48684 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbaGYWsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:48:20 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 03/11] f2fs: add infra for ino management
Date: Fri, 25 Jul 2014 15:47:17 -0700
Message-Id: <1406328445-63707-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the naming of orphan-related data structures to use as
inode numbers managed globally.
Later, we can use this facility for managing any inode number lists.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 72 +++++++++++++++++++++++++++-------------------------
 fs/f2fs/debug.c      |  2 +-
 fs/f2fs/f2fs.h       | 19 +++++++++-----
 fs/f2fs/super.c      |  2 +-
 4 files changed, 53 insertions(+), 42 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 3e3c2c3..f93d154 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -22,7 +22,7 @@
 #include "segment.h"
 #include <trace/events/f2fs.h>
 
-static struct kmem_cache *orphan_entry_slab;
+static struct kmem_cache *ino_entry_slab;
 static struct kmem_cache *inode_entry_slab;
 
 /*
@@ -282,19 +282,18 @@ const struct address_space_operations f2fs_meta_aops = {
 	.set_page_dirty	= f2fs_set_meta_page_dirty,
 };
 
-static void __add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino)
+static void __add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
 {
-	struct list_head *head;
 	struct ino_entry *new, *e;
 
-	new = f2fs_kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
+	new = f2fs_kmem_cache_alloc(ino_entry_slab, GFP_ATOMIC);
 	new->ino = ino;
 
-	spin_lock(&sbi->orphan_inode_lock);
-	list_for_each_entry(e, &sbi->orphan_inode_list, list) {
+	spin_lock(&sbi->ino_lock[type]);
+	list_for_each_entry(e, &sbi->ino_list[type], list) {
 		if (e->ino == ino) {
-			spin_unlock(&sbi->orphan_inode_lock);
-			kmem_cache_free(orphan_entry_slab, new);
+			spin_unlock(&sbi->ino_lock[type]);
+			kmem_cache_free(ino_entry_slab, new);
 			return;
 		}
 		if (e->ino > ino)
@@ -303,58 +302,58 @@ static void __add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino)
 
 	/* add new entry into list which is sorted by inode number */
 	list_add_tail(&new->list, &e->list);
-	spin_unlock(&sbi->orphan_inode_lock);
+	spin_unlock(&sbi->ino_lock[type]);
 }
 
-static void __remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino)
+static void __remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
 {
 	struct ino_entry *e;
 
-	spin_lock(&sbi->orphan_inode_lock);
-	list_for_each_entry(e, &sbi->orphan_inode_list, list) {
+	spin_lock(&sbi->ino_lock[type]);
+	list_for_each_entry(e, &sbi->ino_list[type], list) {
 		if (e->ino == ino) {
 			list_del(&e->list);
 			sbi->n_orphans--;
-			spin_unlock(&sbi->orphan_inode_lock);
-			kmem_cache_free(orphan_entry_slab, e);
+			spin_unlock(&sbi->ino_lock[type]);
+			kmem_cache_free(ino_entry_slab, e);
 			return;
 		}
 	}
-	spin_unlock(&sbi->orphan_inode_lock);
+	spin_unlock(&sbi->ino_lock[type]);
 }
 
 int acquire_orphan_inode(struct f2fs_sb_info *sbi)
 {
 	int err = 0;
 
-	spin_lock(&sbi->orphan_inode_lock);
+	spin_lock(&sbi->ino_lock[ORPHAN_INO]);
 	if (unlikely(sbi->n_orphans >= sbi->max_orphans))
 		err = -ENOSPC;
 	else
 		sbi->n_orphans++;
-	spin_unlock(&sbi->orphan_inode_lock);
+	spin_unlock(&sbi->ino_lock[ORPHAN_INO]);
 
 	return err;
 }
 
 void release_orphan_inode(struct f2fs_sb_info *sbi)
 {
-	spin_lock(&sbi->orphan_inode_lock);
+	spin_lock(&sbi->ino_lock[ORPHAN_INO]);
 	f2fs_bug_on(sbi->n_orphans == 0);
 	sbi->n_orphans--;
-	spin_unlock(&sbi->orphan_inode_lock);
+	spin_unlock(&sbi->ino_lock[ORPHAN_INO]);
 }
 
 void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 {
 	/* add new orphan entry into list which is sorted by inode number */
-	__add_ino_entry(sbi, ino);
+	__add_ino_entry(sbi, ino, ORPHAN_INO);
 }
 
 void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 {
 	/* remove orphan entry from orphan list */
-	__remove_ino_entry(sbi, ino);
+	__remove_ino_entry(sbi, ino, ORPHAN_INO);
 }
 
 static void recover_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
@@ -408,14 +407,14 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 	unsigned short orphan_blocks = (unsigned short)((sbi->n_orphans +
 		(F2FS_ORPHANS_PER_BLOCK - 1)) / F2FS_ORPHANS_PER_BLOCK);
 	struct page *page = NULL;
-	struct orphan_inode_entry *orphan = NULL;
+	struct ino_entry *orphan = NULL;
 
 	for (index = 0; index < orphan_blocks; index++)
 		grab_meta_page(sbi, start_blk + index);
 
 	index = 1;
-	spin_lock(&sbi->orphan_inode_lock);
-	head = &sbi->orphan_inode_list;
+	spin_lock(&sbi->ino_lock[ORPHAN_INO]);
+	head = &sbi->ino_list[ORPHAN_INO];
 
 	/* loop for each orphan inode entry and write them in Jornal block */
 	list_for_each_entry(orphan, head, list) {
@@ -455,7 +454,7 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 		f2fs_put_page(page, 1);
 	}
 
-	spin_unlock(&sbi->orphan_inode_lock);
+	spin_unlock(&sbi->ino_lock[ORPHAN_INO]);
 }
 
 static struct page *validate_checkpoint(struct f2fs_sb_info *sbi,
@@ -939,31 +938,36 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "finish checkpoint");
 }
 
-void init_orphan_info(struct f2fs_sb_info *sbi)
+void init_ino_entry_info(struct f2fs_sb_info *sbi)
 {
-	spin_lock_init(&sbi->orphan_inode_lock);
-	INIT_LIST_HEAD(&sbi->orphan_inode_list);
-	sbi->n_orphans = 0;
+	int i;
+
+	for (i = 0; i < MAX_INO_ENTRY; i++) {
+		spin_lock_init(&sbi->ino_lock[i]);
+		INIT_LIST_HEAD(&sbi->ino_list[i]);
+	}
+
 	/*
 	 * considering 512 blocks in a segment 8 blocks are needed for cp
 	 * and log segment summaries. Remaining blocks are used to keep
 	 * orphan entries with the limitation one reserved segment
 	 * for cp pack we can have max 1020*504 orphan entries
 	 */
+	sbi->n_orphans = 0;
 	sbi->max_orphans = (sbi->blocks_per_seg - 2 - NR_CURSEG_TYPE)
 				* F2FS_ORPHANS_PER_BLOCK;
 }
 
 int __init create_checkpoint_caches(void)
 {
-	orphan_entry_slab = f2fs_kmem_cache_create("f2fs_orphan_entry",
-			sizeof(struct orphan_inode_entry));
-	if (!orphan_entry_slab)
+	ino_entry_slab = f2fs_kmem_cache_create("f2fs_ino_entry",
+			sizeof(struct ino_entry));
+	if (!ino_entry_slab)
 		return -ENOMEM;
 	inode_entry_slab = f2fs_kmem_cache_create("f2fs_dirty_dir_entry",
 			sizeof(struct dir_inode_entry));
 	if (!inode_entry_slab) {
-		kmem_cache_destroy(orphan_entry_slab);
+		kmem_cache_destroy(ino_entry_slab);
 		return -ENOMEM;
 	}
 	return 0;
@@ -971,6 +975,6 @@ int __init create_checkpoint_caches(void)
 
 void destroy_checkpoint_caches(void)
 {
-	kmem_cache_destroy(orphan_entry_slab);
+	kmem_cache_destroy(ino_entry_slab);
 	kmem_cache_destroy(inode_entry_slab);
 }
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 3f99266..a441ba3 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -167,7 +167,7 @@ get_cache:
 	si->cache_mem += npages << PAGE_CACHE_SHIFT;
 	npages = META_MAPPING(sbi)->nrpages;
 	si->cache_mem += npages << PAGE_CACHE_SHIFT;
-	si->cache_mem += sbi->n_orphans * sizeof(struct orphan_inode_entry);
+	si->cache_mem += sbi->n_orphans * sizeof(struct ino_entry);
 	si->cache_mem += sbi->n_dirty_dirs * sizeof(struct dir_inode_entry);
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e999eec..b6fa6ec 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -100,8 +100,13 @@ enum {
 	META_SSA
 };
 
-/* for the list of orphan inodes */
-struct orphan_inode_entry {
+/* for the list of ino */
+enum {
+	ORPHAN_INO,		/* for orphan ino list */
+	MAX_INO_ENTRY,		/* max. list */
+};
+
+struct ino_entry {
 	struct list_head list;	/* list head */
 	nid_t ino;		/* inode number */
 };
@@ -450,9 +455,11 @@ struct f2fs_sb_info {
 	bool por_doing;				/* recovery is doing or not */
 	wait_queue_head_t cp_wait;
 
-	/* for orphan inode management */
-	struct list_head orphan_inode_list;	/* orphan inode list */
-	spinlock_t orphan_inode_lock;		/* for orphan inode list */
+	/* for inode management */
+	spinlock_t ino_lock[MAX_INO_ENTRY];		/* for ino entry lock */
+	struct list_head ino_list[MAX_INO_ENTRY];	/* inode list head */
+
+	/* for orphan inode, use 0'th array */
 	unsigned int n_orphans;			/* # of orphan inodes */
 	unsigned int max_orphans;		/* max orphan inodes */
 
@@ -1255,7 +1262,7 @@ void add_dirty_dir_inode(struct inode *);
 void remove_dirty_dir_inode(struct inode *);
 void sync_dirty_dir_inodes(struct f2fs_sb_info *);
 void write_checkpoint(struct f2fs_sb_info *, bool);
-void init_orphan_info(struct f2fs_sb_info *);
+void init_ino_entry_info(struct f2fs_sb_info *);
 int __init create_checkpoint_caches(void);
 void destroy_checkpoint_caches(void);
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index eec89a2..5a80755 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1003,7 +1003,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	INIT_LIST_HEAD(&sbi->dir_inode_list);
 	spin_lock_init(&sbi->dir_inode_lock);
 
-	init_orphan_info(sbi);
+	init_ino_entry_info(sbi);
 
 	/* setup f2fs internal modules */
 	err = build_segment_manager(sbi);
-- 
1.8.5.2 (Apple Git-48)

