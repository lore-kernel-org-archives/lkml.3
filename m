Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaIWExR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:53:17 -0400
Received: from mail.kernel.org ([198.145.19.201]:43355 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbaIWExP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:53:15 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/3] f2fs: introduce cp_control structure
Date: Mon, 22 Sep 2014 21:53:08 -0700
Message-Id: <1411447990-37919-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a new data structure to control checkpoint parameters.
Currently, it presents the reason of checkpoint such as is_umount and normal
sync.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c        | 16 ++++++++--------
 fs/f2fs/f2fs.h              | 11 ++++++++++-
 fs/f2fs/gc.c                |  7 +++++--
 fs/f2fs/recovery.c          |  5 ++++-
 fs/f2fs/super.c             | 13 ++++++++++---
 include/trace/events/f2fs.h | 15 ++++++++++-----
 6 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index e519aaf..e401ffd 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -826,7 +826,7 @@ static void wait_on_all_pages_writeback(struct f2fs_sb_info *sbi)
 	finish_wait(&sbi->cp_wait, &wait);
 }
 
-static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
+static void do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 {
 	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
@@ -894,7 +894,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	ckpt->cp_pack_start_sum = cpu_to_le32(1 + cp_payload_blks +
 			orphan_blocks);
 
-	if (is_umount) {
+	if (cpc->reason == CP_UMOUNT) {
 		set_ckpt_flags(ckpt, CP_UMOUNT_FLAG);
 		ckpt->cp_pack_total_block_count = cpu_to_le32(F2FS_CP_PACKS+
 				cp_payload_blks + data_sum_blocks +
@@ -948,7 +948,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 
 	write_data_summaries(sbi, start_blk);
 	start_blk += data_sum_blocks;
-	if (is_umount) {
+	if (cpc->reason == CP_UMOUNT) {
 		write_node_summaries(sbi, start_blk);
 		start_blk += NR_CURSEG_NODE_TYPE;
 	}
@@ -988,12 +988,12 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 /*
  * We guarantee that this checkpoint procedure will not fail.
  */
-void write_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
+void write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 {
 	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
 	unsigned long long ckpt_ver;
 
-	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "start block_ops");
+	trace_f2fs_write_checkpoint(sbi->sb, cpc->reason, "start block_ops");
 
 	mutex_lock(&sbi->cp_mutex);
 
@@ -1004,7 +1004,7 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	if (block_operations(sbi))
 		goto out;
 
-	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "finish block_ops");
+	trace_f2fs_write_checkpoint(sbi->sb, cpc->reason, "finish block_ops");
 
 	f2fs_submit_merged_bio(sbi, DATA, WRITE);
 	f2fs_submit_merged_bio(sbi, NODE, WRITE);
@@ -1023,13 +1023,13 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	flush_sit_entries(sbi);
 
 	/* unlock all the fs_lock[] in do_checkpoint() */
-	do_checkpoint(sbi, is_umount);
+	do_checkpoint(sbi, cpc);
 
 	unblock_operations(sbi);
 	stat_inc_cp_count(sbi->stat_info);
 out:
 	mutex_unlock(&sbi->cp_mutex);
-	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "finish checkpoint");
+	trace_f2fs_write_checkpoint(sbi->sb, cpc->reason, "finish checkpoint");
 }
 
 void init_ino_entry_info(struct f2fs_sb_info *sbi)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 3b70b01..5298924 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -96,6 +96,15 @@ enum {
 	SIT_BITMAP
 };
 
+enum {
+	CP_UMOUNT,
+	CP_SYNC,
+};
+
+struct cp_control {
+	int reason;
+};
+
 /*
  * For CP/NAT/SIT/SSA readahead
  */
@@ -1314,7 +1323,7 @@ void update_dirty_page(struct inode *, struct page *);
 void add_dirty_dir_inode(struct inode *);
 void remove_dirty_dir_inode(struct inode *);
 void sync_dirty_dir_inodes(struct f2fs_sb_info *);
-void write_checkpoint(struct f2fs_sb_info *, bool);
+void write_checkpoint(struct f2fs_sb_info *, struct cp_control *);
 void init_ino_entry_info(struct f2fs_sb_info *);
 int __init create_checkpoint_caches(void);
 void destroy_checkpoint_caches(void);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 7bf8392..e88fcf6 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -694,6 +694,9 @@ int f2fs_gc(struct f2fs_sb_info *sbi)
 	int gc_type = BG_GC;
 	int nfree = 0;
 	int ret = -1;
+	struct cp_control cpc = {
+		.reason = CP_SYNC,
+	};
 
 	INIT_LIST_HEAD(&ilist);
 gc_more:
@@ -704,7 +707,7 @@ gc_more:
 
 	if (gc_type == BG_GC && has_not_enough_free_secs(sbi, nfree)) {
 		gc_type = FG_GC;
-		write_checkpoint(sbi, false);
+		write_checkpoint(sbi, &cpc);
 	}
 
 	if (!__get_victim(sbi, &segno, gc_type, NO_CHECK_TYPE))
@@ -729,7 +732,7 @@ gc_more:
 		goto gc_more;
 
 	if (gc_type == FG_GC)
-		write_checkpoint(sbi, false);
+		write_checkpoint(sbi, &cpc);
 stop:
 	mutex_unlock(&sbi->gc_mutex);
 
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index a3fcea3..4189003 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -542,8 +542,11 @@ out:
 		set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
 		mutex_unlock(&sbi->cp_mutex);
 	} else if (need_writecp) {
+		struct cp_control cpc = {
+			.reason = CP_SYNC,
+		};
 		mutex_unlock(&sbi->cp_mutex);
-		write_checkpoint(sbi, false);
+		write_checkpoint(sbi, &cpc);
 	} else {
 		mutex_unlock(&sbi->cp_mutex);
 	}
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 7a91a38..128c420 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -434,8 +434,12 @@ static void f2fs_put_super(struct super_block *sb)
 	stop_gc_thread(sbi);
 
 	/* We don't need to do checkpoint when it's clean */
-	if (sbi->s_dirty)
-		write_checkpoint(sbi, true);
+	if (sbi->s_dirty) {
+		struct cp_control cpc = {
+			.reason = CP_UMOUNT,
+		};
+		write_checkpoint(sbi, &cpc);
+	}
 
 	/*
 	 * normally superblock is clean, so we need to release this.
@@ -466,8 +470,11 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
 	trace_f2fs_sync_fs(sb, sync);
 
 	if (sync) {
+		struct cp_control cpc = {
+			.reason = CP_SYNC,
+		};
 		mutex_lock(&sbi->gc_mutex);
-		write_checkpoint(sbi, false);
+		write_checkpoint(sbi, &cpc);
 		mutex_unlock(&sbi->gc_mutex);
 	} else {
 		f2fs_balance_fs(sbi);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index d06d443..66eaace 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -69,6 +69,11 @@
 		{ GC_GREEDY,	"Greedy" },				\
 		{ GC_CB,	"Cost-Benefit" })
 
+#define show_cpreason(type)						\
+	__print_symbolic(type,						\
+		{ CP_UMOUNT,	"Umount" },				\
+		{ CP_SYNC,	"Sync" })
+
 struct victim_sel_policy;
 
 DECLARE_EVENT_CLASS(f2fs__inode,
@@ -944,25 +949,25 @@ TRACE_EVENT(f2fs_submit_page_mbio,
 
 TRACE_EVENT(f2fs_write_checkpoint,
 
-	TP_PROTO(struct super_block *sb, bool is_umount, char *msg),
+	TP_PROTO(struct super_block *sb, int reason, char *msg),
 
-	TP_ARGS(sb, is_umount, msg),
+	TP_ARGS(sb, reason, msg),
 
 	TP_STRUCT__entry(
 		__field(dev_t,	dev)
-		__field(bool,	is_umount)
+		__field(int,	reason)
 		__field(char *,	msg)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
-		__entry->is_umount	= is_umount;
+		__entry->reason		= reason;
 		__entry->msg		= msg;
 	),
 
 	TP_printk("dev = (%d,%d), checkpoint for %s, state = %s",
 		show_dev(__entry),
-		__entry->is_umount ? "clean umount" : "consistency",
+		show_cpreason(__entry->reason),
 		__entry->msg)
 );
 
-- 
1.8.5.2 (Apple Git-48)

