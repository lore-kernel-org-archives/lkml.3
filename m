Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbbA2CAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:00:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33059 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbbA2CAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:00:01 -0500
X-AuditID: cbfee61a-f79c06d000004e71-1d-54c8b0acca52
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] f2fs: merge flags in struct f2fs_sb_info
Date: Wed, 28 Jan 2015 17:48:42 +0800
Message-id: <000701d03adf$b51ba430$1f52ec90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdA62BpLptvNp+xXThGUhNMjXnmhWQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd01G06EGPTstbC4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxr2Fj1gL
	dkVVrN+Z1cC43LOLkZNDQsBE4vGcL6wQtpjEhXvr2boYuTiEBBYxSlxqe8YC4fxglLg7vxus
	ik1ARWJ5x38mEFtEwEti0v4TLCA2s4CHRGPHd7AaYQFLiW3nF4LFWQRUJQ5MvcYIYvMCxTe/
	/M0KYQtK/Jh8D6pXS2L9zuNMELa8xOY1b5khLlKQ2HH2NSPELj2Jba/vsUHUiEtsPHKLZQKj
	wCwko2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgO6WdSOxhXNlgc
	YhTgYFTi4X1hdiJEiDWxrLgy9xCjBAezkghvwHqgEG9KYmVValF+fFFpTmrxIUZpDhYlcV4l
	+7YQIYH0xJLU7NTUgtQimCwTB6dUAyOf4CRFN+6II7csTOYHsuxd9TCncZ3WfJttM5N+97Tb
	dP77ec43+P+qt8n6b25+W2QtMWeKw8ktz5eL/dUqXWrKZLjuYN05tg/q08U7/2eYzjnZrLv6
	zu+7lXG8cv+Nfj977GEm23jc+UpUnKbcwbezHseud3Zl/m2murt21nHjstKIbZdNJrEosRRn
	JBpqMRcVJwIAT7imYWUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there are several variables with Boolean type as below:

struct f2fs_sb_info {
...
	int s_dirty;
	bool need_fsck;
	bool s_closing;
...
	bool por_doing;
...
}

For this there are some issues:
1. there are some space of f2fs_sb_info is wasted due to aligning after Boolean
   type variables by compiler.
2. if we continuously add new flag into f2fs_sb_info, structure will be messed
   up.

So in this patch, we try to:
1. switch s_dirty to Boolean type variable since it has two status 0/1.
2. merge s_dirty/need_fsck/s_closing/por_doing variables into s_flag.
3. introduce an enum type which can indicate different states of sbi.
4. use new introduced universal interfaces is_sbi_flag_set/{set,clear}_sbi_flag
   to operate flags for sbi.

After that, above issues will be fixed.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c        | 12 ++++++------
 fs/f2fs/data.c              |  2 +-
 fs/f2fs/f2fs.h              | 30 ++++++++++++++++++++----------
 fs/f2fs/node.c              |  4 ++--
 fs/f2fs/recovery.c          |  4 ++--
 fs/f2fs/segment.h           | 10 +++++-----
 fs/f2fs/super.c             | 15 ++++++++-------
 include/trace/events/f2fs.h |  4 ++--
 8 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 1ee6162..22165fb 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -190,7 +190,7 @@ static int f2fs_write_meta_page(struct page *page,
 
 	trace_f2fs_writepage(page, META);
 
-	if (unlikely(sbi->por_doing))
+	if (unlikely(is_sbi_flag_set(sbi, SBI_POR_DOING)))
 		goto redirty_out;
 	if (wbc->for_reclaim && page->index < GET_SUM_BLOCK(sbi, 0))
 		goto redirty_out;
@@ -485,7 +485,7 @@ void recover_orphan_inodes(struct f2fs_sb_info *sbi)
 	if (!is_set_ckpt_flags(F2FS_CKPT(sbi), CP_ORPHAN_PRESENT_FLAG))
 		return;
 
-	sbi->por_doing = true;
+	set_sbi_flag(sbi, SBI_POR_DOING);
 
 	start_blk = __start_cp_addr(sbi) + 1 +
 		le32_to_cpu(F2FS_RAW_SUPER(sbi)->cp_payload);
@@ -506,7 +506,7 @@ void recover_orphan_inodes(struct f2fs_sb_info *sbi)
 	}
 	/* clear Orphan Flag */
 	clear_ckpt_flags(F2FS_CKPT(sbi), CP_ORPHAN_PRESENT_FLAG);
-	sbi->por_doing = false;
+	clear_sbi_flag(sbi, SBI_POR_DOING);
 	return;
 }
 
@@ -973,7 +973,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	else
 		clear_ckpt_flags(ckpt, CP_ORPHAN_PRESENT_FLAG);
 
-	if (sbi->need_fsck)
+	if (is_sbi_flag_set(sbi, SBI_NEED_FSCK))
 		set_ckpt_flags(ckpt, CP_FSCK_FLAG);
 
 	/* update SIT/NAT bitmap */
@@ -1047,7 +1047,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 		return;
 
 	clear_prefree_segments(sbi);
-	F2FS_RESET_SB_DIRT(sbi);
+	clear_sbi_flag(sbi, SBI_IS_DIRTY);
 }
 
 /*
@@ -1062,7 +1062,7 @@ void write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	mutex_lock(&sbi->cp_mutex);
 
-	if (!sbi->s_dirty &&
+	if (!is_sbi_flag_set(sbi, SBI_IS_DIRTY) &&
 			cpc->reason != CP_DISCARD && cpc->reason != CP_UMOUNT)
 		goto out;
 	if (unlikely(f2fs_cp_error(sbi)))
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 69b0781..ceaa913 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -838,7 +838,7 @@ static int f2fs_write_data_page(struct page *page,
 
 	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 write:
-	if (unlikely(sbi->por_doing))
+	if (unlikely(is_sbi_flag_set(sbi, SBI_POR_DOING)))
 		goto redirty_out;
 	if (f2fs_is_drop_cache(inode))
 		goto out;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ec4d16b..cda56da 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -28,7 +28,7 @@
 	do {								\
 		if (unlikely(condition)) {				\
 			WARN_ON(1);					\
-			sbi->need_fsck = true;				\
+			set_sbi_flag(sbi, SBI_NEED_FSCK);		\
 		}							\
 	} while (0)
 #define f2fs_down_write(x, y)	down_write(x)
@@ -516,14 +516,20 @@ struct inode_management {
 	unsigned long ino_num;			/* number of entries */
 };
 
+/* For s_flag in struct f2fs_sb_info */
+enum {
+	SBI_IS_DIRTY,				/* dirty flag for checkpoint */
+	SBI_IS_CLOSE,				/* specify unmounting */
+	SBI_NEED_FSCK,				/* need fsck.f2fs to fix */
+	SBI_POR_DOING,				/* recovery is doing or not */
+};
+
 struct f2fs_sb_info {
 	struct super_block *sb;			/* pointer to VFS super block */
 	struct proc_dir_entry *s_proc;		/* proc entry */
 	struct buffer_head *raw_super_buf;	/* buffer head of raw sb */
 	struct f2fs_super_block *raw_super;	/* raw super block pointer */
-	int s_dirty;				/* dirty flag for checkpoint */
-	bool need_fsck;				/* need fsck.f2fs to fix */
-	bool s_closing;				/* specify unmounting */
+	int s_flag;				/* flags for sbi */
 
 	/* for node-related operations */
 	struct f2fs_nm_info *nm_info;		/* node manager */
@@ -543,7 +549,6 @@ struct f2fs_sb_info {
 	struct rw_semaphore cp_rwsem;		/* blocking FS operations */
 	struct rw_semaphore node_write;		/* locking node writes */
 	struct mutex writepages;		/* mutex for writepages() */
-	bool por_doing;				/* recovery is doing or not */
 	wait_queue_head_t cp_wait;
 
 	struct inode_management im[MAX_INO_ENTRY];      /* manage inode cache */
@@ -696,14 +701,19 @@ static inline struct address_space *NODE_MAPPING(struct f2fs_sb_info *sbi)
 	return sbi->node_inode->i_mapping;
 }
 
-static inline void F2FS_SET_SB_DIRT(struct f2fs_sb_info *sbi)
+static inline bool is_sbi_flag_set(struct f2fs_sb_info *sbi, unsigned int type)
+{
+	return sbi->s_flag & (0x01 << type);
+}
+
+static inline void set_sbi_flag(struct f2fs_sb_info *sbi, unsigned int type)
 {
-	sbi->s_dirty = 1;
+	sbi->s_flag |= (0x01 << type);
 }
 
-static inline void F2FS_RESET_SB_DIRT(struct f2fs_sb_info *sbi)
+static inline void clear_sbi_flag(struct f2fs_sb_info *sbi, unsigned int type)
 {
-	sbi->s_dirty = 0;
+	sbi->s_flag &= ~(0x01 << type);
 }
 
 static inline unsigned long long cur_cp_version(struct f2fs_checkpoint *cp)
@@ -815,7 +825,7 @@ static inline void dec_valid_block_count(struct f2fs_sb_info *sbi,
 static inline void inc_page_count(struct f2fs_sb_info *sbi, int count_type)
 {
 	atomic_inc(&sbi->nr_pages[count_type]);
-	F2FS_SET_SB_DIRT(sbi);
+	set_sbi_flag(sbi, SBI_IS_DIRTY);
 }
 
 static inline void inode_inc_dirty_pages(struct inode *inode)
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index d7c1436..05e6faa 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -588,7 +588,7 @@ static void truncate_node(struct dnode_of_data *dn)
 	}
 invalidate:
 	clear_node_page_dirty(dn->node_page);
-	F2FS_SET_SB_DIRT(sbi);
+	set_sbi_flag(sbi, SBI_IS_DIRTY);
 
 	f2fs_put_page(dn->node_page, 1);
 
@@ -1284,7 +1284,7 @@ static int f2fs_write_node_page(struct page *page,
 
 	trace_f2fs_writepage(page, NODE);
 
-	if (unlikely(sbi->por_doing))
+	if (unlikely(is_sbi_flag_set(sbi, SBI_POR_DOING)))
 		goto redirty_out;
 	if (unlikely(f2fs_cp_error(sbi)))
 		goto redirty_out;
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 82ea0d8..188a034 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -508,7 +508,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 	INIT_LIST_HEAD(&inode_list);
 
 	/* step #1: find fsynced inode numbers */
-	sbi->por_doing = true;
+	set_sbi_flag(sbi, SBI_POR_DOING);
 
 	/* prevent checkpoint */
 	mutex_lock(&sbi->cp_mutex);
@@ -541,7 +541,7 @@ out:
 		truncate_inode_pages_final(META_MAPPING(sbi));
 	}
 
-	sbi->por_doing = false;
+	clear_sbi_flag(sbi, SBI_POR_DOING);
 	if (err) {
 		discard_next_dnode(sbi, blkaddr);
 
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 7f327c0..421d579 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -460,7 +460,7 @@ static inline bool has_not_enough_free_secs(struct f2fs_sb_info *sbi, int freed)
 	int node_secs = get_blocktype_secs(sbi, F2FS_DIRTY_NODES);
 	int dent_secs = get_blocktype_secs(sbi, F2FS_DIRTY_DENTS);
 
-	if (unlikely(sbi->por_doing))
+	if (unlikely(is_sbi_flag_set(sbi, SBI_POR_DOING)))
 		return false;
 
 	return (free_sections(sbi) + freed) <= (node_secs + 2 * dent_secs +
@@ -599,13 +599,13 @@ static inline void check_block_count(struct f2fs_sb_info *sbi,
 static inline void check_seg_range(struct f2fs_sb_info *sbi, unsigned int segno)
 {
 	if (segno > TOTAL_SEGS(sbi) - 1)
-		sbi->need_fsck = true;
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
 }
 
 static inline void verify_block_addr(struct f2fs_sb_info *sbi, block_t blk_addr)
 {
 	if (blk_addr < SEG0_BLKADDR(sbi) || blk_addr >= MAX_BLKADDR(sbi))
-		sbi->need_fsck = true;
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
 }
 
 /*
@@ -616,11 +616,11 @@ static inline void check_block_count(struct f2fs_sb_info *sbi,
 {
 	/* check segment usage */
 	if (GET_SIT_VBLOCKS(raw_sit) > sbi->blocks_per_seg)
-		sbi->need_fsck = true;
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
 
 	/* check boundary of a given segment number */
 	if (segno > TOTAL_SEGS(sbi) - 1)
-		sbi->need_fsck = true;
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
 }
 #endif
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 7039969..a6fab27 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -460,7 +460,7 @@ static void f2fs_put_super(struct super_block *sb)
 	 * But, the previous checkpoint was not done by umount, it needs to do
 	 * clean checkpoint again.
 	 */
-	if (sbi->s_dirty ||
+	if (is_sbi_flag_set(sbi, SBI_IS_DIRTY) ||
 			!is_set_ckpt_flags(F2FS_CKPT(sbi), CP_UMOUNT_FLAG)) {
 		struct cp_control cpc = {
 			.reason = CP_UMOUNT,
@@ -500,8 +500,9 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
 	if (sync) {
 		struct cp_control cpc;
 
-		cpc.reason = (test_opt(sbi, FASTBOOT) || sbi->s_closing) ?
-							CP_UMOUNT : CP_SYNC;
+		cpc.reason = (test_opt(sbi, FASTBOOT) ||
+					is_sbi_flag_set(sbi, SBI_IS_CLOSE)) ?
+						CP_UMOUNT : CP_SYNC;
 		mutex_lock(&sbi->gc_mutex);
 		write_checkpoint(sbi, &cpc);
 		mutex_unlock(&sbi->gc_mutex);
@@ -903,7 +904,7 @@ static void init_sb_info(struct f2fs_sb_info *sbi)
 		atomic_set(&sbi->nr_pages[i], 0);
 
 	sbi->dir_level = DEF_DIR_LEVEL;
-	sbi->need_fsck = false;
+	clear_sbi_flag(sbi, SBI_NEED_FSCK);
 }
 
 /*
@@ -1021,7 +1022,7 @@ try_onemore:
 	mutex_init(&sbi->writepages);
 	mutex_init(&sbi->cp_mutex);
 	init_rwsem(&sbi->node_write);
-	sbi->por_doing = false;
+	clear_sbi_flag(sbi, SBI_POR_DOING);
 	spin_lock_init(&sbi->stat_lock);
 
 	init_rwsem(&sbi->read_io.io_rwsem);
@@ -1145,7 +1146,7 @@ try_onemore:
 		goto free_proc;
 
 	if (!retry)
-		sbi->need_fsck = true;
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
 
 	/* recover fsynced data */
 	if (!test_opt(sbi, DISABLE_ROLL_FORWARD)) {
@@ -1225,7 +1226,7 @@ static struct dentry *f2fs_mount(struct file_system_type *fs_type, int flags,
 static void kill_f2fs_super(struct super_block *sb)
 {
 	if (sb->s_root)
-		F2FS_SB(sb)->s_closing = true;
+		set_sbi_flag(F2FS_SB(sb), SBI_IS_CLOSE);
 	kill_block_super(sb);
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 13992f3..5e1c029 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -184,13 +184,13 @@ TRACE_EVENT(f2fs_sync_fs,
 
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
-		__field(int,	dirty)
+		__field(bool,	dirty)
 		__field(int,	wait)
 	),
 
 	TP_fast_assign(
 		__entry->dev	= sb->s_dev;
-		__entry->dirty	= F2FS_SB(sb)->s_dirty;
+		__entry->dirty	= is_sbi_flag_set(F2FS_SB(sb), SBI_IS_DIRTY);
 		__entry->wait	= wait;
 	),
 
-- 
2.2.1


