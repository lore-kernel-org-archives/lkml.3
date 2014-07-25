Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaGYWrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:47:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:48591 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbaGYWrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:47:19 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 01/11] f2fs: add nobarrier mount option
Date: Fri, 25 Jul 2014 15:47:15 -0700
Message-Id: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a mount option, nobarrier, in f2fs.
The assumption in here is that file system keeps the IO ordering, but
doesn't care about cache flushes inside the storages.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c    | 5 ++++-
 fs/f2fs/f2fs.h    | 1 +
 fs/f2fs/segment.c | 3 +++
 fs/f2fs/super.c   | 7 +++++++
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c77c667..482313d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -139,7 +139,10 @@ void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
 	/* change META to META_FLUSH in the checkpoint procedure */
 	if (type >= META_FLUSH) {
 		io->fio.type = META_FLUSH;
-		io->fio.rw = WRITE_FLUSH_FUA | REQ_META | REQ_PRIO;
+		if (test_opt(sbi, NOBARRIER))
+			io->fio.rw = WRITE_FLUSH | REQ_META | REQ_PRIO;
+		else
+			io->fio.rw = WRITE_FLUSH_FUA | REQ_META | REQ_PRIO;
 	}
 	__submit_merged_bio(io);
 	up_write(&io->io_rwsem);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 8f507d4..e999eec 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -41,6 +41,7 @@
 #define F2FS_MOUNT_INLINE_XATTR		0x00000080
 #define F2FS_MOUNT_INLINE_DATA		0x00000100
 #define F2FS_MOUNT_FLUSH_MERGE		0x00000200
+#define F2FS_MOUNT_NOBARRIER		0x00000400
 
 #define clear_opt(sbi, option)	(sbi->mount_opt.opt &= ~F2FS_MOUNT_##option)
 #define set_opt(sbi, option)	(sbi->mount_opt.opt |= F2FS_MOUNT_##option)
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 8a6e57d..9fce0f47 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -239,6 +239,9 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi)
 	struct flush_cmd_control *fcc = SM_I(sbi)->cmd_control_info;
 	struct flush_cmd cmd;
 
+	if (test_opt(sbi, NOBARRIER))
+		return 0;
+
 	if (!test_opt(sbi, FLUSH_MERGE))
 		return blkdev_issue_flush(sbi->sb->s_bdev, GFP_KERNEL, NULL);
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 34649aa..eec89a2 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -52,6 +52,7 @@ enum {
 	Opt_inline_xattr,
 	Opt_inline_data,
 	Opt_flush_merge,
+	Opt_nobarrier,
 	Opt_err,
 };
 
@@ -69,6 +70,7 @@ static match_table_t f2fs_tokens = {
 	{Opt_inline_xattr, "inline_xattr"},
 	{Opt_inline_data, "inline_data"},
 	{Opt_flush_merge, "flush_merge"},
+	{Opt_nobarrier, "nobarrier"},
 	{Opt_err, NULL},
 };
 
@@ -339,6 +341,9 @@ static int parse_options(struct super_block *sb, char *options)
 		case Opt_flush_merge:
 			set_opt(sbi, FLUSH_MERGE);
 			break;
+		case Opt_nobarrier:
+			set_opt(sbi, NOBARRIER);
+			break;
 		default:
 			f2fs_msg(sb, KERN_ERR,
 				"Unrecognized mount option \"%s\" or missing value",
@@ -544,6 +549,8 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 		seq_puts(seq, ",inline_data");
 	if (!f2fs_readonly(sbi->sb) && test_opt(sbi, FLUSH_MERGE))
 		seq_puts(seq, ",flush_merge");
+	if (!f2fs_readonly(sbi->sb) && test_opt(sbi, NOBARRIER))
+		seq_puts(seq, ",nobarrier");
 	seq_printf(seq, ",active_logs=%u", sbi->active_logs);
 
 	return 0;
-- 
1.8.5.2 (Apple Git-48)

