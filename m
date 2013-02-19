Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab3BSCdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:33:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:58918 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab3BSCdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:33:18 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 2/8] f2fs: add tracepoints for inode operations
Date: Tue, 19 Feb 2013 11:33:10 +0900
Message-Id: <1361241190-18073-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints for tracing the various inode operations
like building inode, eviction of inode, link/unlike of
inodes.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/inode.c             |    3 ++
 fs/f2fs/namei.c             |    3 ++
 include/trace/events/f2fs.h |   90 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index ddae412..9216d1a 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -15,6 +15,7 @@
 
 #include "f2fs.h"
 #include "node.h"
+#include <trace/events/f2fs.h>
 
 void f2fs_set_inode_flags(struct inode *inode)
 {
@@ -90,6 +91,7 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 	struct inode *inode;
 	int ret;
 
+	trace_f2fs_iget(sb, ino);
 	inode = iget_locked(sb, ino);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
@@ -233,6 +235,7 @@ void f2fs_evict_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 
+	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages(&inode->i_data, 0);
 
 	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 1a49b88..b6e5b94 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -17,6 +17,7 @@
 #include "f2fs.h"
 #include "xattr.h"
 #include "acl.h"
+#include <trace/events/f2fs.h>
 
 static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 {
@@ -223,6 +224,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	struct page *page;
 	int err = -ENOENT;
 
+	trace_f2fs_unlink_enter(dir, dentry);
 	f2fs_balance_fs(sbi);
 
 	de = f2fs_find_entry(dir, &dentry->d_name, &page);
@@ -241,6 +243,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	/* In order to evict this inode,  we set it dirty */
 	mark_inode_dirty(inode);
 fail:
+	trace_f2fs_unlink_exit(dentry, err);
 	return err;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index ab28831..0c76885 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -78,6 +78,96 @@ TRACE_EVENT(f2fs_sync_fs,
 		  __entry->wait)
 );
 
+TRACE_EVENT(f2fs_iget,
+	TP_PROTO(struct super_block *sb, unsigned long ino),
+
+	TP_ARGS(sb, ino),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(unsigned long,	ino)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->ino	= ino;
+	),
+
+	TP_printk("dev %d,%d ino %lu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino)
+);
+
+TRACE_EVENT(f2fs_evict_inode,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(int,	nlink)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->nlink	= inode->i_nlink;
+	),
+
+	TP_printk("dev %d,%d ino %lu nlink %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->nlink)
+);
+
+TRACE_EVENT(f2fs_unlink_enter,
+	TP_PROTO(struct inode *parent, struct dentry *dentry),
+
+	TP_ARGS(parent, dentry),
+
+	TP_STRUCT__entry(
+		__field(ino_t,	parent)
+		__field(ino_t,	ino)
+		__field(loff_t,	size)
+		__field(dev_t,	dev)
+	),
+
+	TP_fast_assign(
+		__entry->parent		= parent->i_ino;
+		__entry->ino		= dentry->d_inode->i_ino;
+		__entry->size		= dentry->d_inode->i_size;
+		__entry->dev		= dentry->d_inode->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu size %lld parent %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->size,
+		  (unsigned long) __entry->parent)
+);
+
+TRACE_EVENT(f2fs_unlink_exit,
+	TP_PROTO(struct dentry *dentry, int ret),
+
+	TP_ARGS(dentry, ret),
+
+	TP_STRUCT__entry(
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= dentry->d_inode->i_ino;
+		__entry->dev		= dentry->d_inode->i_sb->s_dev;
+		__entry->ret		= ret;
+	),
+
+	TP_printk("dev %d,%d ino %lu ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->ret)
+);
+
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.7.9.5

