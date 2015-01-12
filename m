Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbbALHRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:17:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55121 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbbALHRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:17:48 -0500
X-AuditID: cbfee61a-f79c06d000004e71-50-54b3751a7b1c
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][RFC PATCH 08/10] f2fs: enable rb-tree extent cache
Date: Mon, 12 Jan 2015 15:16:47 +0800
Message-id: <000c01d02e37$de221940$9a664bc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAuBqOE4prRPLvLR7aDe9KuvWTVZg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQV2p0s0hBqs/SFlc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEro331esaC
	G1oVK5u3szcwHlLuYuTkkBAwkbh3ZBYThC0mceHeerYuRi4OIYHpjBIvu1pZQBJCAj8YJY71
	KoHYbAIqEss7/oM1iAh4SUzafwKshlnAQ6Kx4zsriC0s4CaxedoERhCbRUBVYtf+uWBxXgFL
	if4Nm5kgbEGJH5PvQfVqSazfeZwJwpaX2LzmLTPEQQoSO86+ZoTYpSfx4MsbVogacYmNR26x
	TGAUmIVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEh/UxqB+PK
	BotDjAIcjEo8vBZSm0OEWBPLiitzDzFKcDArifCGWQOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ
	8yrZt4UICaQnlqRmp6YWpBbBZJk4OKUaGBd+DLw848eO6rk7zqe5LlrlsELk06LJD1YL2TwP
	Kp00Oc/A3dRJxmTbueyuzMf2bNt5atgDI+/H+1dPyi+9K7CktnaDt170sckLjLasj/zzq1Za
	PTHT9OWFJTfDty6RWvuMZXdjtZtZ+e7IfyuPtq4+WLsm4GFqoOfk5KcHyyerFWbkO7es9FVi
	Kc5INNRiLipOBABEKGrsZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enable rb-tree based extent cache in f2fs.

When we mount with "-o extent_cache", f2fs will try to add recently accessed
page-block mappings into rb-tree based extent cache as much as possible, instead
of original one extent info cache.
By this way, f2fs can support more effective cache between dnode page cache and
disk. It will supply high hit ratio in the cache with fewer memory when dnode
page cache are reclaimed in environment of low memory.

Extent Hit Ratio:
1.write file (size: 64M);
2.write file (offset: 32M, size: 1M);
3.write file (offset: 16M, size: 1M);
4.write file (offset: 48M, size: 1M);
5.echo 3 > /proc/sys/vm/drop_caches
6.read file
		original	new
Hit Ratio	61 / 264	264 / 264

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c    | 13 +++++++++++++
 fs/f2fs/f2fs.h    |  5 +++++
 fs/f2fs/inode.c   |  1 +
 fs/f2fs/segment.c |  3 +++
 fs/f2fs/super.c   |  9 ++++++++-
 5 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index bf8c5eb..ed7b9c5 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -718,6 +718,9 @@ void f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
 	unsigned int found;
 	unsigned int node_cnt = 0, tree_cnt = 0;
 
+	if (!test_opt(sbi, EXTENT_CACHE))
+		return;
+
 	if (available_free_memory(sbi, EXTENT_CACHE))
 		return;
 
@@ -768,6 +771,9 @@ void f2fs_destroy_extent_tree(struct inode *inode)
 	struct extent_tree *et;
 	unsigned int node_cnt = 0;
 
+	if (!test_opt(sbi, EXTENT_CACHE))
+		return;
+
 	down_read(&sbi->extent_tree_lock);
 	et = radix_tree_lookup(&sbi->extent_tree_root, inode->i_ino);
 	if (!et) {
@@ -803,6 +809,9 @@ out:
 static bool f2fs_lookup_extent_cache(struct inode *inode, pgoff_t pgofs,
 							struct extent_info *ei)
 {
+	if (test_opt(F2FS_I_SB(inode), EXTENT_CACHE))
+		return f2fs_lookup_extent_tree(inode, pgofs, ei);
+
 	return f2fs_lookup_extent_info(inode, pgofs, ei);
 }
 
@@ -819,6 +828,10 @@ void f2fs_update_extent_cache(struct dnode_of_data *dn)
 	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
 							dn->ofs_in_node;
 
+	if (test_opt(F2FS_I_SB(dn->inode), EXTENT_CACHE))
+		return f2fs_update_extent_tree(dn->inode, fofs,
+							dn->data_blkaddr);
+
 	if (f2fs_update_extent_info(dn->inode, fofs, dn->data_blkaddr))
 		sync_inode_page(dn);
 }
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d065ff1..811fd90 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1504,12 +1504,17 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *, struct page *,
 						struct f2fs_io_info *);
 int reserve_new_block(struct dnode_of_data *);
 int f2fs_reserve_block(struct dnode_of_data *, pgoff_t);
+void f2fs_shrink_extent_tree(struct f2fs_sb_info *, int);
+void f2fs_destroy_extent_tree(struct inode *);
 void f2fs_update_extent_cache(struct dnode_of_data *);
 struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
 struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
 int do_write_data_page(struct page *, struct f2fs_io_info *);
 int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *, u64, u64);
+void init_extent_cache_info(struct f2fs_sb_info *);
+int __init create_extent_cache(void);
+void destroy_extent_cache(void);
 
 /*
  * gc.c
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 28dd26a..b508744 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -335,6 +335,7 @@ void f2fs_evict_inode(struct inode *inode)
 no_delete:
 	stat_dec_inline_dir(inode);
 	stat_dec_inline_inode(inode);
+	f2fs_destroy_extent_tree(inode);
 	invalidate_mapping_pages(NODE_MAPPING(sbi), inode->i_ino, inode->i_ino);
 	if (xnid)
 		invalidate_mapping_pages(NODE_MAPPING(sbi), xnid, xnid);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 31c4e57..d8be623 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -277,6 +277,9 @@ void f2fs_balance_fs(struct f2fs_sb_info *sbi)
 
 void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi)
 {
+	/* try to shrink extent cache when there is no enough memory */
+	f2fs_shrink_extent_tree(sbi, EXTENT_CACHE_SHRINK_NUMBER);
+
 	/* check the # of cached NAT entries and prefree segments */
 	if (try_to_free_nats(sbi, NAT_ENTRY_PER_BLOCK) ||
 			excess_prefree_segs(sbi) ||
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 5041e719..228f96b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1056,6 +1056,8 @@ try_onemore:
 	INIT_LIST_HEAD(&sbi->dir_inode_list);
 	spin_lock_init(&sbi->dir_inode_lock);
 
+	init_extent_cache_info(sbi);
+
 	init_ino_entry_info(sbi);
 
 	/* setup f2fs internal modules */
@@ -1243,10 +1245,13 @@ static int __init init_f2fs_fs(void)
 	err = create_checkpoint_caches();
 	if (err)
 		goto free_segment_manager_caches;
+	err = create_extent_cache();
+	if (err)
+		goto free_checkpoint_caches;
 	f2fs_kset = kset_create_and_add("f2fs", NULL, fs_kobj);
 	if (!f2fs_kset) {
 		err = -ENOMEM;
-		goto free_checkpoint_caches;
+		goto free_extent_cache;
 	}
 	err = register_filesystem(&f2fs_fs_type);
 	if (err)
@@ -1257,6 +1262,8 @@ static int __init init_f2fs_fs(void)
 
 free_kset:
 	kset_unregister(f2fs_kset);
+free_extent_cache:
+	destroy_extent_cache();
 free_checkpoint_caches:
 	destroy_checkpoint_caches();
 free_segment_manager_caches:
-- 
2.2.1


