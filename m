Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaL2H51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 02:57:27 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:10929 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaL2H50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 02:57:26 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-d1-54a1096434b6
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH] f2fs: reuse inode_entry_slab in gc procedure for
 using slab more effectively
Date: Mon, 29 Dec 2014 15:56:18 +0800
Message-id: <003401d0233d$1474cac0$3d5e6040$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAjPOs4IErGMm99QaKyf0aR4/VEDQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jAd0UzoUhBssfc1pc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro+WrWMFH
	p4qbl98xNTB+N+ti5OSQEDCRWDFpCxOELSZx4d56NhBbSGARo8Sn7QldjFxA9g9Gif1Nm8CK
	2ARUJJZ3/AezRQS8JCbtP8ECYjMLeEg0dnxnBbGFBbIkNq5dD2RzcLAIqErMPCMMEuYVsJQ4
	umsHM4QtKPFj8j2oVi2J9TuPM0HY8hKb17xlhrhHQWLH2deMEKv0JJZ92Q5VIy6x8cgtlgmM
	ArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4nJ9J72Bc1WBx
	iFGAg1GJh5fj2IIQIdbEsuLK3EOMEhzMSiK8138DhXhTEiurUovy44tKc1KLDzFKc7AoifMq
	2beFCAmkJ5akZqemFqQWwWSZODilGhgLDm6q1paW+8X373NVu5qCKTNntpGSydlV+5599GF5
	amlgZZLttNqK4/AB4/v3LtdaRGR1BDi6W2+sfPPv39pZ2c2Vl9i7e/pU6yZ8Tl49NzmyS5zr
	zCF3m4VSH5l2/Yma/v3gpf0btbPFWJ7PnTa7bXr6BkaxomDNmOYtsibHTnuG773GNEuJpTgj
	0VCLuag4EQBp0ibkYwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two slab cache inode_entry_slab and winode_slab using the same
structure as below:

struct dir_inode_entry {
	struct list_head list;	/* list head */
	struct inode *inode;	/* vfs inode pointer */
};

struct inode_entry {
	struct list_head list;
	struct inode *inode;
};

It's a little waste that the two cache can not share their memory space for each
other.
So in this patch we remove one redundant winode_slab slab cache, then use more
universal name struct inode_entry as remaining data structure name of slab,
finally we reuse the inode_entry_slab to store dirty dir item and gc item for
more effective.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c | 18 +++++++++---------
 fs/f2fs/debug.c      |  2 +-
 fs/f2fs/f2fs.h       | 14 +++++++++-----
 fs/f2fs/gc.c         | 20 ++------------------
 fs/f2fs/gc.h         |  7 ++-----
 fs/f2fs/super.c      |  8 +-------
 6 files changed, 24 insertions(+), 45 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 3999933..9f5317c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -24,7 +24,7 @@
 #include <trace/events/f2fs.h>
 
 static struct kmem_cache *ino_entry_slab;
-static struct kmem_cache *inode_entry_slab;
+struct kmem_cache *inode_entry_slab;
 
 /*
  * We guarantee no failure on the returned page.
@@ -673,7 +673,7 @@ fail_no_cp:
 	return -EINVAL;
 }
 
-static int __add_dirty_inode(struct inode *inode, struct dir_inode_entry *new)
+static int __add_dirty_inode(struct inode *inode, struct inode_entry *new)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
@@ -690,7 +690,7 @@ static int __add_dirty_inode(struct inode *inode, struct dir_inode_entry *new)
 void update_dirty_page(struct inode *inode, struct page *page)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct dir_inode_entry *new;
+	struct inode_entry *new;
 	int ret = 0;
 
 	if (!S_ISDIR(inode->i_mode) && !S_ISREG(inode->i_mode))
@@ -720,7 +720,7 @@ out:
 void add_dirty_dir_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct dir_inode_entry *new =
+	struct inode_entry *new =
 			f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
 	int ret = 0;
 
@@ -738,7 +738,7 @@ void add_dirty_dir_inode(struct inode *inode)
 void remove_dirty_dir_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct dir_inode_entry *entry;
+	struct inode_entry *entry;
 
 	if (!S_ISDIR(inode->i_mode))
 		return;
@@ -768,7 +768,7 @@ void remove_dirty_dir_inode(struct inode *inode)
 void sync_dirty_dir_inodes(struct f2fs_sb_info *sbi)
 {
 	struct list_head *head;
-	struct dir_inode_entry *entry;
+	struct inode_entry *entry;
 	struct inode *inode;
 retry:
 	if (unlikely(f2fs_cp_error(sbi)))
@@ -781,7 +781,7 @@ retry:
 		spin_unlock(&sbi->dir_inode_lock);
 		return;
 	}
-	entry = list_entry(head->next, struct dir_inode_entry, list);
+	entry = list_entry(head->next, struct inode_entry, list);
 	inode = igrab(entry->inode);
 	spin_unlock(&sbi->dir_inode_lock);
 	if (inode) {
@@ -1107,8 +1107,8 @@ int __init create_checkpoint_caches(void)
 			sizeof(struct ino_entry));
 	if (!ino_entry_slab)
 		return -ENOMEM;
-	inode_entry_slab = f2fs_kmem_cache_create("f2fs_dirty_dir_entry",
-			sizeof(struct dir_inode_entry));
+	inode_entry_slab = f2fs_kmem_cache_create("f2fs_inode_entry",
+			sizeof(struct inode_entry));
 	if (!inode_entry_slab) {
 		kmem_cache_destroy(ino_entry_slab);
 		return -ENOMEM;
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 2b64221..dd7835b 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -172,7 +172,7 @@ get_cache:
 	si->cache_mem += npages << PAGE_CACHE_SHIFT;
 	npages = META_MAPPING(sbi)->nrpages;
 	si->cache_mem += npages << PAGE_CACHE_SHIFT;
-	si->cache_mem += sbi->n_dirty_dirs * sizeof(struct dir_inode_entry);
+	si->cache_mem += sbi->n_dirty_dirs * sizeof(struct inode_entry);
 	for (i = 0; i <= UPDATE_INO; i++)
 		si->cache_mem += sbi->im[i].ino_num * sizeof(struct ino_entry);
 }
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 3226af0..c48847e 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -136,8 +136,14 @@ struct ino_entry {
 	nid_t ino;		/* inode number */
 };
 
-/* for the list of directory inodes */
-struct dir_inode_entry {
+/*
+ * for the list of directory inodes or gc inodes.
+ * NOTE: there are two slab users for this structure, if we add/modify/delete
+ * fields in structure for one of slab users, it may affect fields or size of
+ * other one, in this condition, it's better to split both of slab and related
+ * data structure.
+ */
+struct inode_entry {
 	struct list_head list;	/* list head */
 	struct inode *inode;	/* vfs inode pointer */
 };
@@ -297,7 +303,7 @@ struct f2fs_inode_info {
 	nid_t i_xattr_nid;		/* node id that contains xattrs */
 	unsigned long long xattr_ver;	/* cp version of xattr modification */
 	struct extent_info ext;		/* in-memory extent cache entry */
-	struct dir_inode_entry *dirty_dir;	/* the pointer of dirty dir */
+	struct inode_entry *dirty_dir;	/* the pointer of dirty dir */
 
 	struct radix_tree_root inmem_root;	/* radix tree for inmem pages */
 	struct list_head inmem_pages;	/* inmemory pages managed by f2fs */
@@ -1487,8 +1493,6 @@ void stop_gc_thread(struct f2fs_sb_info *);
 block_t start_bidx_of_node(unsigned int, struct f2fs_inode_info *);
 int f2fs_gc(struct f2fs_sb_info *);
 void build_gc_manager(struct f2fs_sb_info *);
-int __init create_gc_caches(void);
-void destroy_gc_caches(void);
 
 /*
  * recovery.c
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index eec0933..40887d3 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -24,8 +24,6 @@
 #include "gc.h"
 #include <trace/events/f2fs.h>
 
-static struct kmem_cache *winode_slab;
-
 static int gc_thread_func(void *data)
 {
 	struct f2fs_sb_info *sbi = data;
@@ -356,7 +354,7 @@ static void add_gc_inode(struct gc_inode_list *gc_list, struct inode *inode)
 		iput(inode);
 		return;
 	}
-	new_ie = f2fs_kmem_cache_alloc(winode_slab, GFP_NOFS);
+	new_ie = f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
 	new_ie->inode = inode;
 retry:
 	if (radix_tree_insert(&gc_list->iroot, inode->i_ino, new_ie)) {
@@ -373,7 +371,7 @@ static void put_gc_inode(struct gc_inode_list *gc_list)
 		radix_tree_delete(&gc_list->iroot, ie->inode->i_ino);
 		iput(ie->inode);
 		list_del(&ie->list);
-		kmem_cache_free(winode_slab, ie);
+		kmem_cache_free(inode_entry_slab, ie);
 	}
 }
 
@@ -750,17 +748,3 @@ void build_gc_manager(struct f2fs_sb_info *sbi)
 {
 	DIRTY_I(sbi)->v_ops = &default_v_ops;
 }
-
-int __init create_gc_caches(void)
-{
-	winode_slab = f2fs_kmem_cache_create("f2fs_gc_inodes",
-			sizeof(struct inode_entry));
-	if (!winode_slab)
-		return -ENOMEM;
-	return 0;
-}
-
-void destroy_gc_caches(void)
-{
-	kmem_cache_destroy(winode_slab);
-}
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index 6ff7ad3..524543a 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -35,16 +35,13 @@ struct f2fs_gc_kthread {
 	unsigned int gc_idle;
 };
 
-struct inode_entry {
-	struct list_head list;
-	struct inode *inode;
-};
-
 struct gc_inode_list {
 	struct list_head ilist;
 	struct radix_tree_root iroot;
 };
 
+extern struct kmem_cache *inode_entry_slab;
+
 /*
  * inline functions
  */
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index cf68e44..0ae6a2f 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1231,12 +1231,9 @@ static int __init init_f2fs_fs(void)
 	err = create_segment_manager_caches();
 	if (err)
 		goto free_node_manager_caches;
-	err = create_gc_caches();
-	if (err)
-		goto free_segment_manager_caches;
 	err = create_checkpoint_caches();
 	if (err)
-		goto free_gc_caches;
+		goto free_segment_manager_caches;
 	f2fs_kset = kset_create_and_add("f2fs", NULL, fs_kobj);
 	if (!f2fs_kset) {
 		err = -ENOMEM;
@@ -1253,8 +1250,6 @@ free_kset:
 	kset_unregister(f2fs_kset);
 free_checkpoint_caches:
 	destroy_checkpoint_caches();
-free_gc_caches:
-	destroy_gc_caches();
 free_segment_manager_caches:
 	destroy_segment_manager_caches();
 free_node_manager_caches:
@@ -1271,7 +1266,6 @@ static void __exit exit_f2fs_fs(void)
 	f2fs_destroy_root_stats();
 	unregister_filesystem(&f2fs_fs_type);
 	destroy_checkpoint_caches();
-	destroy_gc_caches();
 	destroy_segment_manager_caches();
 	destroy_node_manager_caches();
 	destroy_inodecache();
-- 
2.2.1


