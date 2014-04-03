Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162329AbaDCG01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 02:26:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58114 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162290AbaDCG0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 02:26:18 -0400
X-AuditID: cbfee690-b7f266d00000287c-09-533cff09e601
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: introduce f2fs_issue_flush to avoid redundant flush issue
Date: Thu, 03 Apr 2014 15:24:21 +0900
Message-id: <1396506261-13341-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zY13O/zbBBj3b2Cyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgynh2tahgr1fF8mk2
	DYzttl2MnBwSAiYSu3veskPYYhIX7q1n62Lk4hASWMYoMX/aMhaYovmn/zBDJBYxSvzc0sEO
	4XQySay/08zYxcjBwSagLbF5vwFIg4gAs8SCqecZQWqYBSYwSvxf9J4FpEZYIEBiU18lSA2L
	gKrEgsc3wBbwCrhLzJz3mhlimbbEtucTwXolBG6zSVx5PYMFokFA4tvkQ2BzJARkJTYdgKqX
	lDi44gbLBEbBBYwMqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzFCwm/CDsZ7B6wPMSYDjZvI
	LCWanA8M37ySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYKy2qDlqoLvswf5GXwlhW7NlTV4ivTHsylMbpgrJBC68+WvxHOavwU8Fveu9HJd7uJlI
	sJTby4WeWe38XjtbqXdK4lHbt9dUuXjfpoomCr97kP3TdsqM2Zs4HnkolM+rFXtg+ebPa43b
	DOl3zpboskyLM7rrGee5mU0i1P7OR/1N+d+Le9ZXKLEUZyQaajEXFScCAGh7voRVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jAV3O/zbBBsdWM1pc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jx7GpRwV6viuXTbBoY2227GDk5JARMJOaf/sMMYYtJXLi3nq2LkYtDSGAR
	o8TPLR3sEE4nk8T6O82MXYwcHGwC2hKb9xuANIgIMEssmHqeEaSGWWACo8T/Re9ZQGqEBQIk
	NvVVgtSwCKhKLHh8gwXE5hVwl5g57zXUMm2Jbc8nMk5g5F7AyLCKUTS1ILmgOCk910ivODG3
	uDQvXS85P3cTIzi4n0nvYFzVYHGIUYCDUYmH11LKJliINbGsuDL3EKMEB7OSCO/FL0Ah3pTE
	yqrUovz4otKc1OJDjMlA2ycyS4km5wMjL68k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJ
	JanZqakFqUUwW5g4OKUaGLkTBX6vXd7KoyfnsbNZ8s7EBMG2N7vuOvyJqHVbMPedWqpR9Y0J
	5gLmjdbKz4VbWmLmvLk/O7rpy8NFhQcjIiPtjpTsPfWF1b9j67+gIv2KMFbbLZ6NX+8s3D5L
	36c/6Mwt89UH6h9+NzvRv+7Fhbbrb3M0O+5ySadsWGnh5tiVtVe37+qkfUosxRmJhlrMRcWJ
	ADFXMBayAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some storage devices show relatively high latencies to complete cache_flush
commands, even though their normal IO speed is prettry much high. In such
the case, it needs to merge cache_flush commands as much as possible to avoid
issuing them redundantly.
So, this patch introduces a mount option, "-o flush_merge", to mitigate such
the overhead.

If this option is enabled by user, F2FS merges the cache_flush commands and then
issues just one cache_flush on behalf of them. Once the single command is
finished, F2FS sends a completion signal to all the pending threads.

Note that, this option can be used under a workload consisting of very intensive
concurrent fsync calls, while the storage handles cache_flush commands slowly.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 Documentation/filesystems/f2fs.txt |  4 ++
 fs/f2fs/f2fs.h                     | 16 +++++++
 fs/f2fs/file.c                     |  2 +-
 fs/f2fs/segment.c                  | 87 ++++++++++++++++++++++++++++++++++++++
 fs/f2fs/super.c                    |  7 +++
 5 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index 2f6d021..25311e11 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -122,6 +122,10 @@ disable_ext_identify   Disable the extension list configured by mkfs, so f2fs
 inline_xattr           Enable the inline xattrs feature.
 inline_data            Enable the inline data feature: New created small(<~3.4k)
                        files can be written into inode block.
+flush_merge	       Merge concurrent cache_flush commands as much as possible
+                       to eliminate redundant command issues. If the underlying
+		       device handles the cache_flush command relatively slowly,
+		       recommend to enable this option.
 
 ================================================================================
 DEBUGFS ENTRIES
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1e3d869..2ecac83 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -40,6 +40,7 @@
 #define F2FS_MOUNT_DISABLE_EXT_IDENTIFY	0x00000040
 #define F2FS_MOUNT_INLINE_XATTR		0x00000080
 #define F2FS_MOUNT_INLINE_DATA		0x00000100
+#define F2FS_MOUNT_FLUSH_MERGE		0x00000200
 
 #define clear_opt(sbi, option)	(sbi->mount_opt.opt &= ~F2FS_MOUNT_##option)
 #define set_opt(sbi, option)	(sbi->mount_opt.opt |= F2FS_MOUNT_##option)
@@ -316,6 +317,12 @@ enum {
 	NO_CHECK_TYPE
 };
 
+struct flush_cmd {
+	struct flush_cmd *next;
+	struct completion wait;
+	int ret;
+};
+
 struct f2fs_sm_info {
 	struct sit_info *sit_info;		/* whole segment information */
 	struct free_segmap_info *free_info;	/* free segment information */
@@ -344,6 +351,14 @@ struct f2fs_sm_info {
 
 	unsigned int ipu_policy;	/* in-place-update policy */
 	unsigned int min_ipu_util;	/* in-place-update threshold */
+
+	/* for flush command control */
+	struct task_struct *f2fs_issue_flush;	/* flush thread */
+	wait_queue_head_t flush_wait_queue;	/* waiting queue for wake-up */
+	struct flush_cmd *issue_list;		/* list for command issue */
+	struct flush_cmd *dispatch_list;	/* list for command dispatch */
+	spinlock_t issue_lock;			/* for issue list lock */
+	struct flush_cmd *issue_tail;		/* list tail of issue list */
 };
 
 /*
@@ -1160,6 +1175,7 @@ void destroy_node_manager_caches(void);
  */
 void f2fs_balance_fs(struct f2fs_sb_info *);
 void f2fs_balance_fs_bg(struct f2fs_sb_info *);
+int f2fs_issue_flush(struct f2fs_sb_info *);
 void invalidate_blocks(struct f2fs_sb_info *, block_t);
 void refresh_sit_entry(struct f2fs_sb_info *, block_t, block_t);
 void clear_prefree_segments(struct f2fs_sb_info *);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6ba2668..302d552 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -186,7 +186,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		ret = wait_on_node_pages_writeback(sbi, inode->i_ino);
 		if (ret)
 			goto out;
-		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		ret = f2fs_issue_flush(F2FS_SB(inode->i_sb));
 	}
 out:
 	trace_f2fs_sync_file_exit(inode, need_cp, datasync, ret);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index f799c6a..2993624 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -13,6 +13,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/prefetch.h>
+#include <linux/kthread.h>
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 
@@ -24,6 +25,7 @@
 #define __reverse_ffz(x) __reverse_ffs(~(x))
 
 static struct kmem_cache *discard_entry_slab;
+static struct kmem_cache *flush_cmd_slab;
 
 /*
  * __reverse_ffs is copied from include/asm-generic/bitops/__ffs.h since
@@ -195,6 +197,73 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi)
 		f2fs_sync_fs(sbi->sb, true);
 }
 
+static int issue_flush_thread(void *data)
+{
+	struct f2fs_sb_info *sbi = data;
+	struct f2fs_sm_info *sm_i = SM_I(sbi);
+	wait_queue_head_t *q = &sm_i->flush_wait_queue;
+repeat:
+	spin_lock(&sm_i->issue_lock);
+	if (sm_i->issue_list) {
+		sm_i->dispatch_list = sm_i->issue_list;
+		sm_i->issue_list = sm_i->issue_tail = NULL;
+	}
+	spin_unlock(&sm_i->issue_lock);
+
+	if (sm_i->dispatch_list) {
+		struct bio *bio = bio_alloc(GFP_NOIO, 0);
+		struct flush_cmd *cmd, *next;
+		int ret;
+
+		bio->bi_bdev = sbi->sb->s_bdev;
+		ret = submit_bio_wait(WRITE_FLUSH, bio);
+
+		for (cmd = sm_i->dispatch_list; cmd; cmd = next) {
+			cmd->ret = ret;
+			next = cmd->next;
+			complete(&cmd->wait);
+		}
+		sm_i->dispatch_list = NULL;
+	}
+
+	if (kthread_should_stop())
+		return 0;
+
+	wait_event_interruptible(*q, kthread_should_stop() || sm_i->issue_list);
+	goto repeat;
+}
+
+int f2fs_issue_flush(struct f2fs_sb_info *sbi)
+{
+	struct f2fs_sm_info *sm_i = SM_I(sbi);
+	struct flush_cmd *cmd;
+	int ret;
+
+	if (!test_opt(sbi, FLUSH_MERGE))
+		return blkdev_issue_flush(sbi->sb->s_bdev, GFP_KERNEL, NULL);
+
+	cmd = f2fs_kmem_cache_alloc(flush_cmd_slab, GFP_ATOMIC);
+	cmd->next = NULL;
+	cmd->ret = 0;
+	init_completion(&cmd->wait);
+
+	spin_lock(&sm_i->issue_lock);
+	if (sm_i->issue_list)
+		sm_i->issue_tail->next = cmd;
+	else
+		sm_i->issue_list = cmd;
+	sm_i->issue_tail = cmd;
+	spin_unlock(&sm_i->issue_lock);
+
+	if (!sm_i->dispatch_list)
+		wake_up(&sm_i->flush_wait_queue);
+
+	wait_for_completion(&cmd->wait);
+	ret = cmd->ret;
+	kmem_cache_free(flush_cmd_slab, cmd);
+	return ret;
+}
+
 static void __locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno,
 		enum dirty_type dirty_type)
 {
@@ -1763,6 +1832,7 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_super_block *raw_super = F2FS_RAW_SUPER(sbi);
 	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
+	dev_t dev = sbi->sb->s_bdev->bd_dev;
 	struct f2fs_sm_info *sm_info;
 	int err;
 
@@ -1790,6 +1860,15 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	sm_info->nr_discards = 0;
 	sm_info->max_discards = 0;
 
+	spin_lock_init(&sm_info->issue_lock);
+
+	sm_info->f2fs_issue_flush = kthread_run(issue_flush_thread, sbi,
+			"f2fs_issue_flush-%u:%u", MAJOR(dev), MINOR(dev));
+	if (IS_ERR(sm_info->f2fs_issue_flush))
+		return PTR_ERR(sm_info->f2fs_issue_flush);
+
+	init_waitqueue_head(&sm_info->flush_wait_queue);
+
 	err = build_sit_info(sbi);
 	if (err)
 		return err;
@@ -1898,6 +1977,7 @@ void destroy_segment_manager(struct f2fs_sb_info *sbi)
 	struct f2fs_sm_info *sm_info = SM_I(sbi);
 	if (!sm_info)
 		return;
+	kthread_stop(sm_info->f2fs_issue_flush);
 	destroy_dirty_segmap(sbi);
 	destroy_curseg(sbi);
 	destroy_free_segmap(sbi);
@@ -1912,10 +1992,17 @@ int __init create_segment_manager_caches(void)
 			sizeof(struct discard_entry));
 	if (!discard_entry_slab)
 		return -ENOMEM;
+	flush_cmd_slab = f2fs_kmem_cache_create("flush_command",
+			sizeof(struct flush_cmd));
+	if (!flush_cmd_slab) {
+		kmem_cache_destroy(discard_entry_slab);
+		return -ENOMEM;
+	}
 	return 0;
 }
 
 void destroy_segment_manager_caches(void)
 {
 	kmem_cache_destroy(discard_entry_slab);
+	kmem_cache_destroy(flush_cmd_slab);
 }
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 9598340..d31b767 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -51,6 +51,7 @@ enum {
 	Opt_disable_ext_identify,
 	Opt_inline_xattr,
 	Opt_inline_data,
+	Opt_flush_merge,
 	Opt_err,
 };
 
@@ -67,6 +68,7 @@ static match_table_t f2fs_tokens = {
 	{Opt_disable_ext_identify, "disable_ext_identify"},
 	{Opt_inline_xattr, "inline_xattr"},
 	{Opt_inline_data, "inline_data"},
+	{Opt_flush_merge, "flush_merge"},
 	{Opt_err, NULL},
 };
 
@@ -334,6 +336,9 @@ static int parse_options(struct super_block *sb, char *options)
 		case Opt_inline_data:
 			set_opt(sbi, INLINE_DATA);
 			break;
+		case Opt_flush_merge:
+			set_opt(sbi, FLUSH_MERGE);
+			break;
 		default:
 			f2fs_msg(sb, KERN_ERR,
 				"Unrecognized mount option \"%s\" or missing value",
@@ -537,6 +542,8 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",disable_ext_identify");
 	if (test_opt(sbi, INLINE_DATA))
 		seq_puts(seq, ",inline_data");
+	if (test_opt(sbi, FLUSH_MERGE))
+		seq_puts(seq, ",flush_merge");
 	seq_printf(seq, ",active_logs=%u", sbi->active_logs);
 
 	return 0;
-- 
1.8.4.474.g128a96c

