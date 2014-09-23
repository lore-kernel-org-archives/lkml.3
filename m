Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaIWExU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:53:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:43366 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbaIWExR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:53:17 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/3] f2fs: introduce FITRIM in f2fs_ioctl
Date: Mon, 22 Sep 2014 21:53:09 -0700
Message-Id: <1411447990-37919-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1411447990-37919-1-git-send-email-jaegeuk@kernel.org>
References: <1411447990-37919-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces FITRIM in f2fs_ioctl.
In this case, f2fs will issue small discards and prefree discards as many as
possible for the given area.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c        |   4 +-
 fs/f2fs/f2fs.h              |   9 +++-
 fs/f2fs/file.c              |  29 ++++++++++++
 fs/f2fs/segment.c           | 110 +++++++++++++++++++++++++++++++++++++++-----
 fs/f2fs/super.c             |   1 +
 include/trace/events/f2fs.h |   3 +-
 6 files changed, 141 insertions(+), 15 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index e401ffd..5d793ba 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -997,7 +997,7 @@ void write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	mutex_lock(&sbi->cp_mutex);
 
-	if (!sbi->s_dirty)
+	if (!sbi->s_dirty && cpc->reason != CP_DISCARD)
 		goto out;
 	if (unlikely(f2fs_cp_error(sbi)))
 		goto out;
@@ -1020,7 +1020,7 @@ void write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	/* write cached NAT/SIT entries to NAT/SIT area */
 	flush_nat_entries(sbi);
-	flush_sit_entries(sbi);
+	flush_sit_entries(sbi, cpc);
 
 	/* unlock all the fs_lock[] in do_checkpoint() */
 	do_checkpoint(sbi, cpc);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 5298924..7b1e1d2 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -99,10 +99,15 @@ enum {
 enum {
 	CP_UMOUNT,
 	CP_SYNC,
+	CP_DISCARD,
 };
 
 struct cp_control {
 	int reason;
+	__u64 trim_start;
+	__u64 trim_end;
+	__u64 trim_minlen;
+	__u64 trimmed;
 };
 
 /*
@@ -1276,9 +1281,11 @@ void destroy_flush_cmd_control(struct f2fs_sb_info *);
 void invalidate_blocks(struct f2fs_sb_info *, block_t);
 void refresh_sit_entry(struct f2fs_sb_info *, block_t, block_t);
 void clear_prefree_segments(struct f2fs_sb_info *);
+void release_discard_addrs(struct f2fs_sb_info *);
 void discard_next_dnode(struct f2fs_sb_info *, block_t);
 int npages_for_summary_flush(struct f2fs_sb_info *);
 void allocate_new_segments(struct f2fs_sb_info *);
+int f2fs_trim_fs(struct f2fs_sb_info *, struct fstrim_range *);
 struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
 void write_meta_page(struct f2fs_sb_info *, struct page *);
 void write_node_page(struct f2fs_sb_info *, struct page *,
@@ -1295,7 +1302,7 @@ void write_data_summaries(struct f2fs_sb_info *, block_t);
 void write_node_summaries(struct f2fs_sb_info *, block_t);
 int lookup_journal_in_cursum(struct f2fs_summary_block *,
 					int, unsigned int, int);
-void flush_sit_entries(struct f2fs_sb_info *);
+void flush_sit_entries(struct f2fs_sb_info *, struct cp_control *);
 int build_segment_manager(struct f2fs_sb_info *);
 void destroy_segment_manager(struct f2fs_sb_info *);
 int __init create_segment_manager_caches(void);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index ac8c680..1184207 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -860,6 +860,35 @@ out:
 		mnt_drop_write_file(filp);
 		return ret;
 	}
+	case FITRIM:
+	{
+		struct super_block *sb = inode->i_sb;
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
+		struct fstrim_range range;
+		int ret = 0;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		if (!blk_queue_discard(q))
+			return -EOPNOTSUPP;
+
+		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
+					sizeof(range)))
+			return -EFAULT;
+
+		range.minlen = max((unsigned int)range.minlen,
+				   q->limits.discard_granularity);
+		ret = f2fs_trim_fs(F2FS_SB(sb), &range);
+		if (ret < 0)
+			return ret;
+
+		if (copy_to_user((struct fstrim_range __user *)arg, &range,
+					sizeof(range)))
+			return -EFAULT;
+
+		return 0;
+	}
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3125a3d..b423005 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -386,45 +386,92 @@ void discard_next_dnode(struct f2fs_sb_info *sbi, block_t blkaddr)
 	}
 }
 
-static void add_discard_addrs(struct f2fs_sb_info *sbi,
-			unsigned int segno, struct seg_entry *se)
+static void add_discard_addrs(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 {
 	struct list_head *head = &SM_I(sbi)->discard_list;
 	struct discard_entry *new;
 	int entries = SIT_VBLOCK_MAP_SIZE / sizeof(unsigned long);
 	int max_blocks = sbi->blocks_per_seg;
+	struct seg_entry *se = get_seg_entry(sbi, cpc->trim_start);
 	unsigned long *cur_map = (unsigned long *)se->cur_valid_map;
 	unsigned long *ckpt_map = (unsigned long *)se->ckpt_valid_map;
-	unsigned long dmap[entries];
+	unsigned long *dmap;
 	unsigned int start = 0, end = -1;
+	bool force = (cpc->reason == CP_DISCARD);
 	int i;
 
-	if (!test_opt(sbi, DISCARD))
+	if (!force && !test_opt(sbi, DISCARD))
 		return;
 
+	if (force && !se->valid_blocks) {
+		struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
+		/*
+		 * if this segment is registered in the prefree list, then
+		 * we should skip adding a discard candidate, and let the
+		 * checkpoint do that later.
+		 */
+		mutex_lock(&dirty_i->seglist_lock);
+		if (test_bit(cpc->trim_start, dirty_i->dirty_segmap[PRE])) {
+			mutex_unlock(&dirty_i->seglist_lock);
+			cpc->trimmed += sbi->blocks_per_seg;
+			return;
+		}
+		mutex_unlock(&dirty_i->seglist_lock);
+
+		new = f2fs_kmem_cache_alloc(discard_entry_slab, GFP_NOFS);
+		INIT_LIST_HEAD(&new->list);
+		new->blkaddr = START_BLOCK(sbi, cpc->trim_start);
+		new->len = sbi->blocks_per_seg;
+		list_add_tail(&new->list, head);
+		SM_I(sbi)->nr_discards += sbi->blocks_per_seg;
+		cpc->trimmed += sbi->blocks_per_seg;
+		return;
+	}
+
 	/* zero block will be discarded through the prefree list */
 	if (!se->valid_blocks || se->valid_blocks == max_blocks)
 		return;
 
+	dmap = kzalloc(SIT_VBLOCK_MAP_SIZE, GFP_KERNEL);
+	if (!dmap)
+		return;
+
 	/* SIT_VBLOCK_MAP_SIZE should be multiple of sizeof(unsigned long) */
 	for (i = 0; i < entries; i++)
 		dmap[i] = (cur_map[i] ^ ckpt_map[i]) & ckpt_map[i];
 
-	while (SM_I(sbi)->nr_discards <= SM_I(sbi)->max_discards) {
+	while (force || SM_I(sbi)->nr_discards <= SM_I(sbi)->max_discards) {
 		start = __find_rev_next_bit(dmap, max_blocks, end + 1);
 		if (start >= max_blocks)
 			break;
 
 		end = __find_rev_next_zero_bit(dmap, max_blocks, start + 1);
 
+		if (end - start < cpc->trim_minlen)
+			continue;
+
 		new = f2fs_kmem_cache_alloc(discard_entry_slab, GFP_NOFS);
 		INIT_LIST_HEAD(&new->list);
-		new->blkaddr = START_BLOCK(sbi, segno) + start;
+		new->blkaddr = START_BLOCK(sbi, cpc->trim_start) + start;
 		new->len = end - start;
+		cpc->trimmed += end - start;
 
 		list_add_tail(&new->list, head);
 		SM_I(sbi)->nr_discards += end - start;
 	}
+	kfree(dmap);
+}
+
+void release_discard_addrs(struct f2fs_sb_info *sbi)
+{
+	struct list_head *head = &(SM_I(sbi)->discard_list);
+	struct discard_entry *entry, *this;
+
+	/* drop caches */
+	list_for_each_entry_safe(entry, this, head, list) {
+		list_del(&entry->list);
+		kmem_cache_free(discard_entry_slab, entry);
+	}
 }
 
 /*
@@ -897,6 +944,40 @@ static const struct segment_allocation default_salloc_ops = {
 	.allocate_segment = allocate_segment_by_default,
 };
 
+int f2fs_trim_fs(struct f2fs_sb_info *sbi, struct fstrim_range *range)
+{
+	block_t start_addr = SM_I(sbi)->main_blkaddr;
+	__u64 start = range->start >> sbi->log_blocksize;
+	__u64 end = start + (range->len >> sbi->log_blocksize) - 1;
+	__u64 segment = 1 << (sbi->log_blocksize + sbi->log_blocks_per_seg);
+	unsigned int start_segno, end_segno;
+	struct cp_control cpc;
+
+	if (range->minlen > segment || start >= TOTAL_BLKS(sbi) ||
+			range->len < sbi->blocksize)
+		return -EINVAL;
+
+	if (end <= start_addr)
+		goto out;
+
+	/* start/end segment number in main_area */
+	start_segno = (start <= start_addr) ? 0 : GET_SEGNO(sbi, start);
+	end_segno = (end >= TOTAL_BLKS(sbi)) ? TOTAL_SEGS(sbi) - 1 :
+		GET_SEGNO(sbi, end);
+
+	cpc.reason = CP_DISCARD;
+	cpc.trim_start = start_segno;
+	cpc.trim_end = end_segno;
+	cpc.trim_minlen = range->minlen >> sbi->log_blocksize;
+	cpc.trimmed = 0;
+
+	/* do checkpoint to issue discard commands safely */
+	write_checkpoint(sbi, &cpc);
+out:
+	range->len = cpc.trimmed << sbi->log_blocksize;
+	return 0;
+}
+
 static bool __has_curseg_space(struct f2fs_sb_info *sbi, int type)
 {
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
@@ -1524,7 +1605,7 @@ static void remove_sits_in_journal(struct f2fs_sb_info *sbi)
  * CP calls this function, which flushes SIT entries including sit_journal,
  * and moves prefree segs to free segs.
  */
-void flush_sit_entries(struct f2fs_sb_info *sbi)
+void flush_sit_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 {
 	struct sit_info *sit_i = SIT_I(sbi);
 	unsigned long *bitmap = sit_i->dirty_sentries_bitmap;
@@ -1534,6 +1615,7 @@ void flush_sit_entries(struct f2fs_sb_info *sbi)
 	struct list_head *head = &SM_I(sbi)->sit_entry_set;
 	unsigned long nsegs = TOTAL_SEGS(sbi);
 	bool to_journal = true;
+	struct seg_entry *se;
 
 	mutex_lock(&curseg->curseg_mutex);
 	mutex_lock(&sit_i->sentry_lock);
@@ -1580,11 +1662,14 @@ void flush_sit_entries(struct f2fs_sb_info *sbi)
 		/* flush dirty sit entries in region of current sit set */
 		for_each_set_bit_from(segno, bitmap, end) {
 			int offset, sit_offset;
-			struct seg_entry *se = get_seg_entry(sbi, segno);
+
+			se = get_seg_entry(sbi, segno);
 
 			/* add discard candidates */
-			if (SM_I(sbi)->nr_discards < SM_I(sbi)->max_discards)
-				add_discard_addrs(sbi, segno, se);
+			if (SM_I(sbi)->nr_discards < SM_I(sbi)->max_discards) {
+				cpc->trim_start = segno;
+				add_discard_addrs(sbi, cpc);
+			}
 
 			if (to_journal) {
 				offset = lookup_journal_in_cursum(sum,
@@ -1614,8 +1699,11 @@ void flush_sit_entries(struct f2fs_sb_info *sbi)
 
 	f2fs_bug_on(sbi, !list_empty(head));
 	f2fs_bug_on(sbi, sit_i->dirty_sentries);
-
 out:
+	if (cpc->reason == CP_DISCARD) {
+		for (; cpc->trim_start <= cpc->trim_end; cpc->trim_start++)
+			add_discard_addrs(sbi, cpc);
+	}
 	mutex_unlock(&sit_i->sentry_lock);
 	mutex_unlock(&curseg->curseg_mutex);
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 128c420..bb6b568 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -446,6 +446,7 @@ static void f2fs_put_super(struct super_block *sb)
 	 * In addition, EIO will skip do checkpoint, we need this as well.
 	 */
 	release_dirty_inode(sbi);
+	release_discard_addrs(sbi);
 
 	iput(sbi->node_inode);
 	iput(sbi->meta_inode);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 66eaace..bbc4de9 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -72,7 +72,8 @@
 #define show_cpreason(type)						\
 	__print_symbolic(type,						\
 		{ CP_UMOUNT,	"Umount" },				\
-		{ CP_SYNC,	"Sync" })
+		{ CP_SYNC,	"Sync" },				\
+		{ CP_DISCARD,	"Discard" })
 
 struct victim_sel_policy;
 
-- 
1.8.5.2 (Apple Git-48)

