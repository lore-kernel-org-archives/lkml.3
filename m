Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030909Ab3DSQaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:30:20 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:58718 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968397Ab3DSQaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:30:17 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH v4 7/7] f2fs: add tracepoints to debug checkpoint request
Date: Sat, 20 Apr 2013 01:30:10 +0900
Message-Id: <1366389010-19017-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints to debug checkpoint request.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/f2fs/checkpoint.c        |    4 ++++
 include/trace/events/f2fs.h |   22 ++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 197796a..c633efd 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -717,7 +717,10 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	unsigned long long ckpt_ver;
 
 	mutex_lock(&sbi->cp_mutex);
+	trace_f2fs_write_checkpoint(sbi->sb, is_umount,
+					 "Try to block operation");
 	block_operations(sbi);
+	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "Done block operation");
 
 	f2fs_submit_bio(sbi, DATA, true);
 	f2fs_submit_bio(sbi, NODE, true);
@@ -740,6 +743,7 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 
 	unblock_operations(sbi);
 	mutex_unlock(&sbi->cp_mutex);
+	trace_f2fs_write_checkpoint(sbi->sb, is_umount, "Done checkpoint");
 }
 
 void init_orphan_info(struct f2fs_sb_info *sbi)
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 32372a6..e49253a 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -688,6 +688,28 @@ DEFINE_EVENT(f2fs_page_type_op, f2fs_write_page,
 	TP_ARGS(page, type)
 );
 
+TRACE_EVENT(f2fs_write_checkpoint,
+	TP_PROTO(struct super_block *sb, int umount, char *str),
+
+	TP_ARGS(sb, umount, str),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int,	umount)
+		__field(char *,	msg)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->umount	= umount;
+		__entry->msg	= str;
+	),
+
+	TP_printk("dev %d,%d is_umount %d message %s ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+			__entry->umount, __entry->msg)
+
+);
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.7.9.5

