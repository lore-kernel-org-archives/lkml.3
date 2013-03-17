Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3CQIlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:41:01 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60585 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3CQIkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:40:02 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH v2 1/7] f2fs: add tracepoints for sync and inode operations
Date: Sun, 17 Mar 2013 17:39:54 +0900
Message-Id: <1363509594-3503-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints in f2fs for tracing the syncing
operations like filesystem sync, file sync enter/exit.
It will helf to trace the code under debugging scenarios.

Also add tracepoints for tracing the various inode operations
like building inode, eviction of inode, link/unlike of
inodes.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/file.c              |    3 +
 fs/f2fs/inode.c             |    3 +
 fs/f2fs/namei.c             |    3 +
 fs/f2fs/super.c             |    4 ++
 include/trace/events/f2fs.h |  164 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 177 insertions(+)
 create mode 100644 include/trace/events/f2fs.h

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 269645e..7207371 100644
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
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 6d82020..ae305ab 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -15,6 +15,7 @@
 
 #include "f2fs.h"
 #include "node.h"
+#include <trace/events/f2fs.h>
 
 void f2fs_set_inode_flags(struct inode *inode)
 {
@@ -94,6 +95,7 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 	struct inode *inode;
 	int ret;
 
+	trace_f2fs_iget(sb, ino);
 	inode = iget_locked(sb, ino);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
@@ -237,6 +239,7 @@ void f2fs_evict_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 
+	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages(&inode->i_data, 0);
 
 	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 261d821..af1e528 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -17,6 +17,7 @@
 #include "f2fs.h"
 #include "xattr.h"
 #include "acl.h"
+#include <trace/events/f2fs.h>
 
 static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 {
@@ -220,6 +221,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	struct page *page;
 	int err = -ENOENT;
 
+	trace_f2fs_unlink_enter(dir, dentry);
 	f2fs_balance_fs(sbi);
 
 	de = f2fs_find_entry(dir, &dentry->d_name, &page);
@@ -238,6 +240,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	/* In order to evict this inode,  we set it dirty */
 	mark_inode_dirty(inode);
 fail:
+	trace_f2fs_unlink_exit(inode, err);
 	return err;
 }
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index a8573c8..344091b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -28,6 +28,9 @@
 #include "node.h"
 #include "xattr.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/f2fs.h>
+
 static struct kmem_cache *f2fs_inode_cachep;
 
 enum {
@@ -133,6 +136,7 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 
+	trace_f2fs_sync_fs(sb, sync);
 	if (!sbi->s_dirty && !get_pages(sbi, F2FS_DIRTY_NODES))
 		return 0;
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
new file mode 100644
index 0000000..fd50db9
--- /dev/null
+++ b/include/trace/events/f2fs.h
@@ -0,0 +1,164 @@
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
+DECLARE_EVENT_CLASS(f2fs_file_inode_ret,
+	TP_PROTO(struct inode *inode, int ret),
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
+DEFINE_EVENT(f2fs_file_inode_ret, f2fs_sync_file_exit,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret)
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
+DEFINE_EVENT(f2fs_file_inode_ret, f2fs_unlink_exit,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret)
+);
+
+#endif /* _TRACE_F2FS_H */
+
+ /* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.9.5

