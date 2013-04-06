Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3DFFqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 01:46:43 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59785 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3DFFql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 01:46:41 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH v3 5/7] f2fs: add tracepoints to debug the block allocation & fallocate
Date: Sat,  6 Apr 2013 14:46:34 +0900
Message-Id: <1365227194-15526-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints to debug the block allocation & fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/data.c              |    1 +
 fs/f2fs/file.c              |    3 ++
 include/trace/events/f2fs.h |   76 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index d5d5a7c..a517ec2 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -56,6 +56,7 @@ int reserve_new_block(struct dnode_of_data *dn)
 	if (!inc_valid_block_count(sbi, dn->inode, 1))
 		return -ENOSPC;
 
+	trace_f2fs_reserve_new_block(dn->inode, dn->nid);
 	__set_data_blkaddr(dn, NEW_ADDR);
 	dn->data_blkaddr = NEW_ADDR;
 	sync_inode_page(dn);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index f082a16..412fe77 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -528,6 +528,7 @@ static long f2fs_fallocate(struct file *file, int mode,
 	struct inode *inode = file_inode(file);
 	long ret;
 
+	trace_f2fs_fallocate_enter(inode, offset, len, mode);
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
@@ -540,6 +541,8 @@ static long f2fs_fallocate(struct file *file, int mode,
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		mark_inode_dirty(inode);
 	}
+
+	trace_f2fs_fallocate_exit(inode, offset, len, ret);
 	return ret;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index f9efe99..5665619 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -347,6 +347,82 @@ TRACE_EVENT(f2fs_get_victim,
 		   __entry->type)
 );
 
+TRACE_EVENT(f2fs_fallocate_enter,
+	TP_PROTO(struct inode *inode, loff_t offset, loff_t len, int mode),
+
+	TP_ARGS(inode, offset, len, mode),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	pos)
+		__field(loff_t,	len)
+		__field(int,	mode)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= offset;
+		__entry->len	= len;
+		__entry->mode	= mode;
+	),
+
+	TP_printk("dev %d,%d ino %lu pos %lld len %lld mode %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->pos,
+		  __entry->len, __entry->mode)
+);
+
+TRACE_EVENT(f2fs_fallocate_exit,
+	TP_PROTO(struct inode *inode, loff_t offset,
+		 loff_t len, int ret),
+
+	TP_ARGS(inode, offset, len, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	pos)
+		__field(loff_t,	len)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= offset;
+		__entry->len	= len;
+		__entry->ret	= ret;
+	),
+
+	TP_printk("dev %d,%d ino %lu pos %lld len %lld ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->pos, __entry->len,
+		  __entry->ret)
+);
+
+TRACE_EVENT(f2fs_reserve_new_block,
+	TP_PROTO(struct inode *inode, unsigned int nid),
+
+	TP_ARGS(inode, nid),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(unsigned int, nid)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->nid	= nid;
+	),
+
+	TP_printk("dev %d,%d: with Nid %u ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->nid)
+);
+
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.7.9.5

