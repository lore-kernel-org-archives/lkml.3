Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaKIHgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 02:36:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:55382 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbaKIHgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 02:36:14 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/5] f2fs: introduce the number of inode entries
Date: Sat,  8 Nov 2014 23:36:06 -0800
Message-Id: <1415518569-20626-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
References: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds to monitor the number of ino entries.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 27 +++++++++++++++------------
 fs/f2fs/debug.c      |  4 +++-
 fs/f2fs/f2fs.h       |  2 +-
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index dd6a357..bcd686e 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -318,6 +318,8 @@ retry:
 		e->ino = ino;
 
 		list_add_tail(&e->list, &sbi->ino_list[type]);
+		if (type != ORPHAN_INO)
+			sbi->ino_num[type]++;
 	}
 	spin_unlock(&sbi->ino_lock[type]);
 }
@@ -331,8 +333,7 @@ static void __remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
 	if (e) {
 		list_del(&e->list);
 		radix_tree_delete(&sbi->ino_root[type], ino);
-		if (type == ORPHAN_INO)
-			sbi->n_orphans--;
+		sbi->ino_num[type]--;
 		spin_unlock(&sbi->ino_lock[type]);
 		kmem_cache_free(ino_entry_slab, e);
 		return;
@@ -373,6 +374,7 @@ void release_dirty_inode(struct f2fs_sb_info *sbi)
 			list_del(&e->list);
 			radix_tree_delete(&sbi->ino_root[i], e->ino);
 			kmem_cache_free(ino_entry_slab, e);
+			sbi->ino_num[i]--;
 		}
 		spin_unlock(&sbi->ino_lock[i]);
 	}
@@ -383,10 +385,10 @@ int acquire_orphan_inode(struct f2fs_sb_info *sbi)
 	int err = 0;
 
 	spin_lock(&sbi->ino_lock[ORPHAN_INO]);
-	if (unlikely(sbi->n_orphans >= sbi->max_orphans))
+	if (unlikely(sbi->ino_num[ORPHAN_INO] >= sbi->max_orphans))
 		err = -ENOSPC;
 	else
-		sbi->n_orphans++;
+		sbi->ino_num[ORPHAN_INO]++;
 	spin_unlock(&sbi->ino_lock[ORPHAN_INO]);
 
 	return err;
@@ -395,8 +397,8 @@ int acquire_orphan_inode(struct f2fs_sb_info *sbi)
 void release_orphan_inode(struct f2fs_sb_info *sbi)
 {
 	spin_lock(&sbi->ino_lock[ORPHAN_INO]);
-	f2fs_bug_on(sbi, sbi->n_orphans == 0);
-	sbi->n_orphans--;
+	f2fs_bug_on(sbi, sbi->ino_num[ORPHAN_INO] == 0);
+	sbi->ino_num[ORPHAN_INO]--;
 	spin_unlock(&sbi->ino_lock[ORPHAN_INO]);
 }
 
@@ -460,11 +462,12 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 	struct f2fs_orphan_block *orphan_blk = NULL;
 	unsigned int nentries = 0;
 	unsigned short index;
-	unsigned short orphan_blocks =
-			(unsigned short)GET_ORPHAN_BLOCKS(sbi->n_orphans);
+	unsigned short orphan_blocks;
 	struct page *page = NULL;
 	struct ino_entry *orphan = NULL;
 
+	orphan_blocks = GET_ORPHAN_BLOCKS(sbi->ino_num[ORPHAN_INO]);
+
 	for (index = 0; index < orphan_blocks; index++)
 		grab_meta_page(sbi, start_blk + index);
 
@@ -892,7 +895,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	else
 		clear_ckpt_flags(ckpt, CP_COMPACT_SUM_FLAG);
 
-	orphan_blocks = GET_ORPHAN_BLOCKS(sbi->n_orphans);
+	orphan_blocks = GET_ORPHAN_BLOCKS(sbi->ino_num[ORPHAN_INO]);
 	ckpt->cp_pack_start_sum = cpu_to_le32(1 + cp_payload_blks +
 			orphan_blocks);
 
@@ -908,7 +911,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 				orphan_blocks);
 	}
 
-	if (sbi->n_orphans)
+	if (sbi->ino_num[ORPHAN_INO])
 		set_ckpt_flags(ckpt, CP_ORPHAN_PRESENT_FLAG);
 	else
 		clear_ckpt_flags(ckpt, CP_ORPHAN_PRESENT_FLAG);
@@ -943,7 +946,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 		f2fs_put_page(cp_page, 1);
 	}
 
-	if (sbi->n_orphans) {
+	if (sbi->ino_num[ORPHAN_INO]) {
 		write_orphan_inodes(sbi, start_blk);
 		start_blk += orphan_blocks;
 	}
@@ -1045,6 +1048,7 @@ void init_ino_entry_info(struct f2fs_sb_info *sbi)
 		INIT_RADIX_TREE(&sbi->ino_root[i], GFP_ATOMIC);
 		spin_lock_init(&sbi->ino_lock[i]);
 		INIT_LIST_HEAD(&sbi->ino_list[i]);
+		sbi->ino_num[i] = 0;
 	}
 
 	/*
@@ -1053,7 +1057,6 @@ void init_ino_entry_info(struct f2fs_sb_info *sbi)
 	 * orphan entries with the limitation one reserved segment
 	 * for cp pack we can have max 1020*504 orphan entries
 	 */
-	sbi->n_orphans = 0;
 	sbi->max_orphans = (sbi->blocks_per_seg - F2FS_CP_PACKS -
 			NR_CURSEG_TYPE) * F2FS_ORPHANS_PER_BLOCK;
 }
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 86e6e92..74a0d78 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -119,6 +119,7 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_stat_info *si = F2FS_STAT(sbi);
 	unsigned npages;
+	int i;
 
 	if (si->base_mem)
 		goto get_cache;
@@ -168,8 +169,9 @@ get_cache:
 	si->cache_mem += npages << PAGE_CACHE_SHIFT;
 	npages = META_MAPPING(sbi)->nrpages;
 	si->cache_mem += npages << PAGE_CACHE_SHIFT;
-	si->cache_mem += sbi->n_orphans * sizeof(struct ino_entry);
 	si->cache_mem += sbi->n_dirty_dirs * sizeof(struct dir_inode_entry);
+	for (i = 0; i <= UPDATE_INO; i++)
+		si->cache_mem += sbi->ino_num[i] * sizeof(struct ino_entry);
 }
 
 static int stat_show(struct seq_file *s, void *v)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d45f3f4..994b87e 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -532,9 +532,9 @@ struct f2fs_sb_info {
 	struct radix_tree_root ino_root[MAX_INO_ENTRY];	/* ino entry array */
 	spinlock_t ino_lock[MAX_INO_ENTRY];		/* for ino entry lock */
 	struct list_head ino_list[MAX_INO_ENTRY];	/* inode list head */
+	unsigned long ino_num[MAX_INO_ENTRY];		/* number of entries */
 
 	/* for orphan inode, use 0'th array */
-	unsigned int n_orphans;			/* # of orphan inodes */
 	unsigned int max_orphans;		/* max orphan inodes */
 
 	/* for directory inode management */
-- 
2.1.1

