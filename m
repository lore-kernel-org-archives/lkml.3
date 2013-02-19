Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab3BSCeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:34:16 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35018 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab3BSCeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:34:13 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 6/8] f2fs: add tracepoints to debug the block allocation and fallocate
Date: Tue, 19 Feb 2013 11:34:03 +0900
Message-Id: <1361241243-18209-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints to debug the block allocation and fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/data.c              |    1 +
 fs/f2fs/file.c              |    3 ++
 include/trace/events/f2fs.h |   76 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 61beb82..be96b0e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -55,6 +55,7 @@ int reserve_new_block(struct dnode_of_data *dn)
 	if (!inc_valid_block_count(sbi, dn->inode, 1))
 		return -ENOSPC;
 
+	trace_f2fs_reserve_new_block(dn->inode, dn->nid);
 	__set_data_blkaddr(dn, NEW_ADDR);
 	dn->data_blkaddr = NEW_ADDR;
 	sync_inode_page(dn);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 022d318..f8ba8c0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -554,6 +554,7 @@ static long f2fs_fallocate(struct file *file, int mode,
 	struct inode *inode = file->f_path.dentry->d_inode;
 	long ret;
 
+	trace_f2fs_fallocate_enter(inode, offset, len, mode);
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
@@ -566,6 +567,8 @@ static long f2fs_fallocate(struct file *file, int mode,
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		mark_inode_dirty(inode);
 	}
+
+	trace_f2fs_fallocate_exit(inode, offset, len, ret);
 	return ret;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 9abac346d..88ee2c7 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -364,6 +364,82 @@ TRACE_EVENT(f2fs_get_victim,
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

