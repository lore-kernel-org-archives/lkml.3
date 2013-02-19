Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab3BSCdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:33:08 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51075 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab3BSCdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:33:06 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 1/8] f2fs: add tracepoints for sync operations
Date: Tue, 19 Feb 2013 11:32:48 +0900
Message-Id: <1361241168-18039-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints in f2fs for tracing the syncing
operations like filesystem sync, file sync enter/exit.
It will helf to trace the code under debugging scenarios.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/file.c              |    3 ++
 fs/f2fs/super.c             |    4 +++
 include/trace/events/f2fs.h |   84 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+)
 create mode 100644 include/trace/events/f2fs.h

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index b7a053d..318708b 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -24,6 +24,7 @@
 #include "segment.h"
 #include "xattr.h"
 #include "acl.h"
+#include <trace/events/f2fs.h>
 
 static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 						struct vm_fault *vmf)
@@ -135,6 +136,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		return 0;
 
+	trace_f2fs_sync_file_enter(file, datasync);
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (ret)
 		return ret;
@@ -181,6 +183,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 out:
 	mutex_unlock(&inode->i_mutex);
+	trace_f2fs_sync_file_exit(inode, ret);
 	return ret;
 }
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 8c11764..2098ddb 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -27,6 +27,9 @@
 #include "node.h"
 #include "xattr.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/f2fs.h>
+
 static struct kmem_cache *f2fs_inode_cachep;
 
 enum {
@@ -132,6 +135,7 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 
+	trace_f2fs_sync_fs(sb, sync);
 	if (!sbi->s_dirty && !get_pages(sbi, F2FS_DIRTY_NODES))
 		return 0;
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
new file mode 100644
index 0000000..ab28831
--- /dev/null
+++ b/include/trace/events/f2fs.h
@@ -0,0 +1,84 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM f2fs
+
+#if !defined(_TRACE_F2FS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_F2FS_H
+
+#include <linux/tracepoint.h>
+
+
+TRACE_EVENT(f2fs_sync_file_enter,
+	TP_PROTO(struct file *file, int datasync),
+
+	TP_ARGS(file, datasync),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(ino_t,	parent)
+		__field(int,	datasync)
+	),
+
+	TP_fast_assign(
+		struct dentry *dentry = file->f_path.dentry;
+
+		__entry->dev		= dentry->d_inode->i_sb->s_dev;
+		__entry->ino		= dentry->d_inode->i_ino;
+		__entry->datasync	= datasync;
+		__entry->parent		= dentry->d_parent->d_inode->i_ino;
+	),
+
+	TP_printk("dev %d,%d ino %lu parent %lu datasync %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->parent, __entry->datasync)
+);
+
+TRACE_EVENT(f2fs_sync_file_exit,
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret),
+
+	TP_STRUCT__entry(
+		__field(int,	ret)
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+	),
+
+	TP_fast_assign(
+		__entry->ret		= ret;
+		__entry->ino		= inode->i_ino;
+		__entry->dev		= inode->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->ret)
+);
+
+TRACE_EVENT(f2fs_sync_fs,
+	TP_PROTO(struct super_block *sb, int wait),
+
+	TP_ARGS(sb, wait),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int,	wait)
+
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->wait	= wait;
+	),
+
+	TP_printk("dev %d,%d wait %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->wait)
+);
+
+#endif /* _TRACE_F2FS_H */
+
+ /* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.9.5

