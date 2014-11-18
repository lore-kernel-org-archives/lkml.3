Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaKRDTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 22:19:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19081 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaKRDTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 22:19:35 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-cb-546abac5f1ed
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 3/3] f2fs: introduce struct inode_management to wrap
 inner fields
Date: Tue, 18 Nov 2014 11:18:36 +0800
Message-id: <006801d002de$79595fc0$6c0c1f40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAC3egN/7mUToWdRGeXhlErvHglMQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd2ju7JCDFrWGFlc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr49WOX8wF
	HwIrni47xNrAuNa5i5GTQ0LAROLoycNsELaYxIV764FsLg4hgUWMEm9vbWeFcH4wSnyY/IQd
	pIpNQEViecd/JhBbRMBLYtL+EywgNrOAh0Rjx3dWEFtYIFbi4aI+sBoWAVWJ3fPfg/XyClhK
	nGpczAJhC0r8mHwPqldLYv3O40wQtrzE5jVvmSEuUpDYcfY1YxcjB9AuPYmZX5UhSsQlNh65
	xTKBUWAWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEh/Qz6R2M
	qxosDjEKcDAq8fAmTs0KEWJNLCuuzD3EKMHBrCTCe64bKMSbklhZlVqUH19UmpNafIhRmoNF
	SZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoGR76HT3KjZ9Qc5rS6wKr/UCLE446WhKpt2YJnQ
	km3Bp4UDHj27qGj1QMJ4k4Ni2C2bzrWz9X5+WtUhWJv4w6hzwsdbqqc050toJvYfuH/7NIv7
	3M+L3IKCVvw/Wq3Bd1Pp7oEz9ZZp/ydcucFqNt910t0AVyvG9H07Zij6FPx0fao498scNV1D
	JZbijERDLeai4kQAaHF46WUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now in f2fs, we have three inode cache: ORPHAN_INO, APPEND_INO, UPDATE_INO,
and we manage fields related to inode cache separately in struct f2fs_sb_info
for each inode cache type.
This makes codes a bit messy, so that this patch intorduce a new struct
inode_management to wrap inner fields as following which make codes more neat.

/* for inner inode cache management */
struct inode_management {
	struct radix_tree_root ino_root;	/* ino entry array */
	spinlock_t ino_lock;			/* for ino entry lock */
	struct list_head ino_list;		/* inode list head */
	unsigned long ino_num;			/* number of entries */
};

struct f2fs_sb_info {
	...
	struct inode_management im[MAX_INO_ENTRY];      /* manage inode cache */
	...
}

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c | 95 +++++++++++++++++++++++++++++-----------------------
 fs/f2fs/debug.c      |  2 +-
 fs/f2fs/f2fs.h       | 14 +++++---
 fs/f2fs/node.c       |  4 +--
 4 files changed, 66 insertions(+), 49 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index bcd686e..838e8ed 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -298,47 +298,49 @@ const struct address_space_operations f2fs_meta_aops = {
 
 static void __add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
 {
+	struct inode_management *im = &sbi->im[type];
 	struct ino_entry *e;
 retry:
-	spin_lock(&sbi->ino_lock[type]);
+	spin_lock(&im->ino_lock);
 
-	e = radix_tree_lookup(&sbi->ino_root[type], ino);
+	e = radix_tree_lookup(&im->ino_root, ino);
 	if (!e) {
 		e = kmem_cache_alloc(ino_entry_slab, GFP_ATOMIC);
 		if (!e) {
-			spin_unlock(&sbi->ino_lock[type]);
+			spin_unlock(&im->ino_lock);
 			goto retry;
 		}
-		if (radix_tree_insert(&sbi->ino_root[type], ino, e)) {
-			spin_unlock(&sbi->ino_lock[type]);
+		if (radix_tree_insert(&im->ino_root, ino, e)) {
+			spin_unlock(&im->ino_lock);
 			kmem_cache_free(ino_entry_slab, e);
 			goto retry;
 		}
 		memset(e, 0, sizeof(struct ino_entry));
 		e->ino = ino;
 
-		list_add_tail(&e->list, &sbi->ino_list[type]);
+		list_add_tail(&e->list, &im->ino_list);
 		if (type != ORPHAN_INO)
-			sbi->ino_num[type]++;
+			im->ino_num++;
 	}
-	spin_unlock(&sbi->ino_lock[type]);
+	spin_unlock(&im->ino_lock);
 }
 
 static void __remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
 {
+	struct inode_management *im = &sbi->im[type];
 	struct ino_entry *e;
 
-	spin_lock(&sbi->ino_lock[type]);
-	e = radix_tree_lookup(&sbi->ino_root[type], ino);
+	spin_lock(&im->ino_lock);
+	e = radix_tree_lookup(&im->ino_root, ino);
 	if (e) {
 		list_del(&e->list);
-		radix_tree_delete(&sbi->ino_root[type], ino);
-		sbi->ino_num[type]--;
-		spin_unlock(&sbi->ino_lock[type]);
+		radix_tree_delete(&im->ino_root, ino);
+		im->ino_num--;
+		spin_unlock(&im->ino_lock);
 		kmem_cache_free(ino_entry_slab, e);
 		return;
 	}
-	spin_unlock(&sbi->ino_lock[type]);
+	spin_unlock(&im->ino_lock);
 }
 
 void add_dirty_inode(struct f2fs_sb_info *sbi, nid_t ino, int type)
@@ -356,10 +358,12 @@ void remove_dirty_inode(struct f2fs_sb_info *sbi, nid_t ino, int type)
 /* mode should be APPEND_INO or UPDATE_INO */
 bool exist_written_data(struct f2fs_sb_info *sbi, nid_t ino, int mode)
 {
+	struct inode_management *im = &sbi->im[mode];
 	struct ino_entry *e;
-	spin_lock(&sbi->ino_lock[mode]);
-	e = radix_tree_lookup(&sbi->ino_root[mode], ino);
-	spin_unlock(&sbi->ino_lock[mode]);
+
+	spin_lock(&im->ino_lock);
+	e = radix_tree_lookup(&im->ino_root, ino);
+	spin_unlock(&im->ino_lock);
 	return e ? true : false;
 }
 
@@ -369,37 +373,42 @@ void release_dirty_inode(struct f2fs_sb_info *sbi)
 	int i;
 
 	for (i = APPEND_INO; i <= UPDATE_INO; i++) {
-		spin_lock(&sbi->ino_lock[i]);
-		list_for_each_entry_safe(e, tmp, &sbi->ino_list[i], list) {
+		struct inode_management *im = &sbi->im[i];
+
+		spin_lock(&im->ino_lock);
+		list_for_each_entry_safe(e, tmp, &im->ino_list, list) {
 			list_del(&e->list);
-			radix_tree_delete(&sbi->ino_root[i], e->ino);
+			radix_tree_delete(&im->ino_root, e->ino);
 			kmem_cache_free(ino_entry_slab, e);
-			sbi->ino_num[i]--;
+			im->ino_num--;
 		}
-		spin_unlock(&sbi->ino_lock[i]);
+		spin_unlock(&im->ino_lock);
 	}
 }
 
 int acquire_orphan_inode(struct f2fs_sb_info *sbi)
 {
+	struct inode_management *im = &sbi->im[ORPHAN_INO];
 	int err = 0;
 
-	spin_lock(&sbi->ino_lock[ORPHAN_INO]);
-	if (unlikely(sbi->ino_num[ORPHAN_INO] >= sbi->max_orphans))
+	spin_lock(&im->ino_lock);
+	if (unlikely(im->ino_num >= sbi->max_orphans))
 		err = -ENOSPC;
 	else
-		sbi->ino_num[ORPHAN_INO]++;
-	spin_unlock(&sbi->ino_lock[ORPHAN_INO]);
+		im->ino_num++;
+	spin_unlock(&im->ino_lock);
 
 	return err;
 }
 
 void release_orphan_inode(struct f2fs_sb_info *sbi)
 {
-	spin_lock(&sbi->ino_lock[ORPHAN_INO]);
-	f2fs_bug_on(sbi, sbi->ino_num[ORPHAN_INO] == 0);
-	sbi->ino_num[ORPHAN_INO]--;
-	spin_unlock(&sbi->ino_lock[ORPHAN_INO]);
+	struct inode_management *im = &sbi->im[ORPHAN_INO];
+
+	spin_lock(&im->ino_lock);
+	f2fs_bug_on(sbi, im->ino_num == 0);
+	im->ino_num--;
+	spin_unlock(&im->ino_lock);
 }
 
 void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
@@ -465,15 +474,16 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 	unsigned short orphan_blocks;
 	struct page *page = NULL;
 	struct ino_entry *orphan = NULL;
+	struct inode_management *im = &sbi->im[ORPHAN_INO];
 
-	orphan_blocks = GET_ORPHAN_BLOCKS(sbi->ino_num[ORPHAN_INO]);
+	orphan_blocks = GET_ORPHAN_BLOCKS(im->ino_num);
 
 	for (index = 0; index < orphan_blocks; index++)
 		grab_meta_page(sbi, start_blk + index);
 
 	index = 1;
-	spin_lock(&sbi->ino_lock[ORPHAN_INO]);
-	head = &sbi->ino_list[ORPHAN_INO];
+	spin_lock(&im->ino_lock);
+	head = &im->ino_list;
 
 	/* loop for each orphan inode entry and write them in Jornal block */
 	list_for_each_entry(orphan, head, list) {
@@ -513,7 +523,7 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 		f2fs_put_page(page, 1);
 	}
 
-	spin_unlock(&sbi->ino_lock[ORPHAN_INO]);
+	spin_unlock(&im->ino_lock);
 }
 
 static struct page *validate_checkpoint(struct f2fs_sb_info *sbi,
@@ -836,6 +846,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
+	unsigned long orphan_num = sbi->im[ORPHAN_INO].ino_num;
 	nid_t last_nid = nm_i->next_scan_nid;
 	block_t start_blk;
 	struct page *cp_page;
@@ -895,7 +906,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	else
 		clear_ckpt_flags(ckpt, CP_COMPACT_SUM_FLAG);
 
-	orphan_blocks = GET_ORPHAN_BLOCKS(sbi->ino_num[ORPHAN_INO]);
+	orphan_blocks = GET_ORPHAN_BLOCKS(orphan_num);
 	ckpt->cp_pack_start_sum = cpu_to_le32(1 + cp_payload_blks +
 			orphan_blocks);
 
@@ -911,7 +922,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 				orphan_blocks);
 	}
 
-	if (sbi->ino_num[ORPHAN_INO])
+	if (orphan_num)
 		set_ckpt_flags(ckpt, CP_ORPHAN_PRESENT_FLAG);
 	else
 		clear_ckpt_flags(ckpt, CP_ORPHAN_PRESENT_FLAG);
@@ -946,7 +957,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 		f2fs_put_page(cp_page, 1);
 	}
 
-	if (sbi->ino_num[ORPHAN_INO]) {
+	if (orphan_num) {
 		write_orphan_inodes(sbi, start_blk);
 		start_blk += orphan_blocks;
 	}
@@ -1045,10 +1056,12 @@ void init_ino_entry_info(struct f2fs_sb_info *sbi)
 	int i;
 
 	for (i = 0; i < MAX_INO_ENTRY; i++) {
-		INIT_RADIX_TREE(&sbi->ino_root[i], GFP_ATOMIC);
-		spin_lock_init(&sbi->ino_lock[i]);
-		INIT_LIST_HEAD(&sbi->ino_list[i]);
-		sbi->ino_num[i] = 0;
+		struct inode_management *im = &sbi->im[i];
+
+		INIT_RADIX_TREE(&im->ino_root, GFP_ATOMIC);
+		spin_lock_init(&im->ino_lock);
+		INIT_LIST_HEAD(&im->ino_list);
+		im->ino_num = 0;
 	}
 
 	/*
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 74a0d78..40b679c 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -171,7 +171,7 @@ get_cache:
 	si->cache_mem += npages << PAGE_CACHE_SHIFT;
 	si->cache_mem += sbi->n_dirty_dirs * sizeof(struct dir_inode_entry);
 	for (i = 0; i <= UPDATE_INO; i++)
-		si->cache_mem += sbi->ino_num[i] * sizeof(struct ino_entry);
+		si->cache_mem += sbi->im[i].ino_num * sizeof(struct ino_entry);
 }
 
 static int stat_show(struct seq_file *s, void *v)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 994b87e..418c852 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -499,6 +499,14 @@ struct f2fs_bio_info {
 	struct rw_semaphore io_rwsem;	/* blocking op for bio */
 };
 
+/* for inner inode cache management */
+struct inode_management {
+	struct radix_tree_root ino_root;	/* ino entry array */
+	spinlock_t ino_lock;			/* for ino entry lock */
+	struct list_head ino_list;		/* inode list head */
+	unsigned long ino_num;			/* number of entries */
+};
+
 struct f2fs_sb_info {
 	struct super_block *sb;			/* pointer to VFS super block */
 	struct proc_dir_entry *s_proc;		/* proc entry */
@@ -528,11 +536,7 @@ struct f2fs_sb_info {
 	bool por_doing;				/* recovery is doing or not */
 	wait_queue_head_t cp_wait;
 
-	/* for inode management */
-	struct radix_tree_root ino_root[MAX_INO_ENTRY];	/* ino entry array */
-	spinlock_t ino_lock[MAX_INO_ENTRY];		/* for ino entry lock */
-	struct list_head ino_list[MAX_INO_ENTRY];	/* inode list head */
-	unsigned long ino_num[MAX_INO_ENTRY];		/* number of entries */
+	struct inode_management im[MAX_INO_ENTRY];      /* manage inode cache */
 
 	/* for orphan inode, use 0'th array */
 	unsigned int max_orphans;		/* max orphan inodes */
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 6f514fb..478ce1e 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -60,8 +60,8 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
 		if (sbi->sb->s_bdi->dirty_exceeded)
 			return false;
 		for (i = 0; i <= UPDATE_INO; i++)
-			mem_size += (sbi->ino_num[i] * sizeof(struct ino_entry))
-							>> PAGE_CACHE_SHIFT;
+			mem_size += (sbi->im[i].ino_num *
+				sizeof(struct ino_entry)) >> PAGE_CACHE_SHIFT;
 		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 1);
 	}
 	return res;
-- 
2.1.2


