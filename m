Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab3DSQ2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:28:49 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:58754 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab3DSQ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:28:47 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH v4 1/7] f2fs: add tracepoints for sync & Inode operations
Date: Sat, 20 Apr 2013 01:28:40 +0900
Message-Id: <1366388920-18812-1-git-send-email-linkinjeon@gmail.com>
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
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/f2fs/file.c              |    8 +-
 fs/f2fs/inode.c             |   15 ++-
 fs/f2fs/namei.c             |    3 +
 fs/f2fs/super.c             |    4 +
 include/trace/events/f2fs.h |  217 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 243 insertions(+), 4 deletions(-)
 create mode 100644 include/trace/events/f2fs.h

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7be0f4b..830762a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -25,6 +25,7 @@
 #include "segment.h"
 #include "xattr.h"
 #include "acl.h"
+#include <trace/events/f2fs.h>
 
 static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 						struct vm_fault *vmf)
@@ -105,6 +106,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_inode_info *fi = F2FS_I(inode);
 	int ret = 0;
 	bool need_cp = false;
 	struct writeback_control wbc = {
@@ -116,9 +118,12 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		return 0;
 
+	trace_f2fs_sync_file_enter(file, fi->i_advise, datasync);
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (ret)
+	if (ret) {
+		trace_f2fs_sync_file_exit(inode, need_cp, ret);
 		return ret;
+	}
 
 	/* guarantee free sections for fsync */
 	f2fs_balance_fs(sbi);
@@ -153,6 +158,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 out:
 	mutex_unlock(&inode->i_mutex);
+	trace_f2fs_sync_file_exit(inode, need_cp, ret);
 	return ret;
 }
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 60105b7..56cfa02 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -15,6 +15,7 @@
 
 #include "f2fs.h"
 #include "node.h"
+#include <trace/events/f2fs.h>
 
 void f2fs_set_inode_flags(struct inode *inode)
 {
@@ -91,13 +92,18 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 	struct inode *inode;
-	int ret;
+	int ret = 0;
 
+	trace_f2fs_iget_enter(sb, ino);
 	inode = iget_locked(sb, ino);
-	if (!inode)
+	if (!inode) {
+		trace_f2fs_iget_exit(sb, ino, -ENOMEM);
 		return ERR_PTR(-ENOMEM);
-	if (!(inode->i_state & I_NEW))
+	}
+	if (!(inode->i_state & I_NEW)) {
+		trace_f2fs_iget_exit(sb, ino, ret);
 		return inode;
+	}
 	if (ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi))
 		goto make_now;
 
@@ -140,10 +146,12 @@ make_now:
 	}
 	unlock_new_inode(inode);
 
+	trace_f2fs_iget_exit(sb, ino, ret);
 	return inode;
 
 bad_inode:
 	iget_failed(inode);
+	trace_f2fs_iget_exit(sb, ino, ret);
 	return ERR_PTR(ret);
 }
 
@@ -239,6 +247,7 @@ void f2fs_evict_inode(struct inode *inode)
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	int ilock;
 
+	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages(&inode->i_data, 0);
 
 	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 841f6b4..6c5e804 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -18,6 +18,7 @@
 #include "node.h"
 #include "xattr.h"
 #include "acl.h"
+#include <trace/events/f2fs.h>
 
 static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 {
@@ -235,6 +236,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	int err = -ENOENT;
 	int ilock;
 
+	trace_f2fs_unlink_enter(dir, dentry);
 	f2fs_balance_fs(sbi);
 
 	de = f2fs_find_entry(dir, &dentry->d_name, &page);
@@ -255,6 +257,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	/* In order to evict this inode,  we set it dirty */
 	mark_inode_dirty(inode);
 fail:
+	trace_f2fs_unlink_exit(inode, err);
 	return err;
 }
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1b16cea..ddd284a 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -29,6 +29,9 @@
 #include "segment.h"
 #include "xattr.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/f2fs.h>
+
 static struct kmem_cache *f2fs_inode_cachep;
 
 enum {
@@ -134,6 +137,7 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 
+	trace_f2fs_sync_fs(sb, sbi->s_dirty, sync);
 	if (!sbi->s_dirty && !get_pages(sbi, F2FS_DIRTY_NODES))
 		return 0;
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
new file mode 100644
index 0000000..956ff07
--- /dev/null
+++ b/include/trace/events/f2fs.h
@@ -0,0 +1,217 @@
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
+	TP_PROTO(struct file *file, char advise, int datasync),
+
+	TP_ARGS(file, advise, datasync),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(ino_t,	parent)
+		__field(umode_t, i_mode)
+		__field(unsigned int, i_nlink)
+		__field(blkcnt_t, i_blocks)
+		__field(char,	advise)
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
+		__entry->i_mode		= dentry->d_inode->i_mode;
+		__entry->i_nlink	= dentry->d_inode->i_nlink;
+		__entry->i_blocks	= dentry->d_inode->i_blocks;
+		__entry->advise		= advise;
+	),
+
+	TP_printk("dev %d,%d ino %lu parent %lu datasync %d advise_flags %d "
+			"mode_flags %hu link_count %u block %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->parent, __entry->datasync,
+		   __entry->advise, __entry->i_mode, __entry->i_nlink,
+				 (unsigned long long) __entry->i_blocks)
+);
+
+TRACE_EVENT(f2fs_sync_file_exit,
+	TP_PROTO(struct inode *inode, bool need_cp, int ret),
+	TP_ARGS(inode, need_cp, ret),
+
+	TP_STRUCT__entry(
+		__field(int,	ret)
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+		__field(bool,	need_cp)
+	),
+
+	TP_fast_assign(
+		__entry->ret		= ret;
+		__entry->ino		= inode->i_ino;
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->need_cp	= need_cp;
+	),
+
+	TP_printk("dev %d,%d ino %lu checkpoint %s ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->need_cp ? "Needed" : "Not Needed", __entry->ret)
+);
+
+TRACE_EVENT(f2fs_sync_fs,
+	TP_PROTO(struct super_block *sb, int dirty, int wait),
+
+	TP_ARGS(sb, dirty, wait),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int,	wait)
+		__field(int,	dirty)
+
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->wait	= wait;
+		__entry->dirty	= dirty;
+	),
+
+	TP_printk("dev %d,%d Superblock dirty: %s wait %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dirty ? "Yes" : "No", __entry->wait)
+);
+
+TRACE_EVENT(f2fs_iget_enter,
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
+TRACE_EVENT(f2fs_iget_exit,
+	TP_PROTO(struct super_block *sb, unsigned long ino, int ret),
+
+	TP_ARGS(sb, ino, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(unsigned long,	ino)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->ino	= ino;
+		__entry->ret	= ret;
+	),
+
+	TP_printk("dev %d,%d ino %lu Error %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->ret)
+);
+
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
+		__field(blkcnt_t, blocks)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->nlink		= inode->i_nlink;
+		__entry->blocks		= inode->i_blocks;
+	),
+
+	TP_printk("dev %d,%d ino %lu nlink %d block %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->nlink,
+			(unsigned long long) __entry->blocks)
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
+		__field(blkcnt_t, blocks)
+		__field(const char *,	name)
+	),
+
+	TP_fast_assign(
+		__entry->parent		= parent->i_ino;
+		__entry->ino		= dentry->d_inode->i_ino;
+		__entry->size		= dentry->d_inode->i_size;
+		__entry->dev		= dentry->d_inode->i_sb->s_dev;
+		__entry->blocks		= dentry->d_inode->i_blocks;
+		__entry->name		= dentry->d_name.name;
+	),
+
+	TP_printk("dev %d,%d ino %lu size %lld block %llu name %s parent %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->size,
+		  (unsigned long long) __entry->blocks, __entry->name,
+		  (unsigned long) __entry->parent)
+);
+
+TRACE_EVENT(f2fs_unlink_exit,
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
+#endif /* _TRACE_F2FS_H */
+
+ /* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.9.5

