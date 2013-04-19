Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab3DSQ3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:29:05 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:38719 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab3DSQ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:29:00 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH v4 2/7] f2fs: add tracepoints for truncate operation
Date: Sat, 20 Apr 2013 01:28:52 +0900
Message-Id: <1366388932-18846-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

add tracepoints for tracing the truncate operations
like truncate node/data blocks, f2fs_truncate etc.

Tracepoints are added at entry and exit of operation
to trace the success & failure of operation.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/f2fs/file.c              |    8 +-
 fs/f2fs/node.c              |   16 +++-
 include/trace/events/f2fs.h |  197 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 218 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 830762a..31176d5 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -194,6 +194,9 @@ static int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
 		sync_inode_page(dn);
 	}
 	dn->ofs_in_node = ofs;
+
+	trace_f2fs_truncate_data_blocks_range(dn->inode, dn->nid,
+					 dn->ofs_in_node, nr_free);
 	return nr_free;
 }
 
@@ -230,6 +233,7 @@ static int truncate_blocks(struct inode *inode, u64 from)
 	int count = 0, ilock = -1;
 	int err;
 
+	trace_f2fs_truncate_blocks_enter(inode, from);
 	free_from = (pgoff_t)
 			((from + blocksize - 1) >> (sbi->log_blocksize));
 
@@ -240,6 +244,7 @@ static int truncate_blocks(struct inode *inode, u64 from)
 		if (err == -ENOENT)
 			goto free_next;
 		mutex_unlock_op(sbi, ilock);
+		trace_f2fs_truncate_blocks_exit(inode, err);
 		return err;
 	}
 
@@ -264,6 +269,7 @@ free_next:
 	/* lastly zero out the first data page */
 	truncate_partial_data_page(inode, from);
 
+	trace_f2fs_truncate_blocks_exit(inode, err);
 	return err;
 }
 
@@ -272,7 +278,7 @@ void f2fs_truncate(struct inode *inode)
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 				S_ISLNK(inode->i_mode)))
 		return;
-
+	trace_f2fs_truncate(inode);
 	if (!truncate_blocks(inode, i_size_read(inode))) {
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		mark_inode_dirty(inode);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 5a7edf9..02ed70f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -19,6 +19,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include <trace/events/f2fs.h>
 
 static struct kmem_cache *nat_entry_slab;
 static struct kmem_cache *free_nid_slab;
@@ -508,6 +509,7 @@ invalidate:
 
 	f2fs_put_page(dn->node_page, 1);
 	dn->node_page = NULL;
+	trace_f2fs_truncate_node(dn->inode, ni.blk_addr, dn->nid);
 }
 
 static int truncate_dnode(struct dnode_of_data *dn)
@@ -545,6 +547,7 @@ static int truncate_nodes(struct dnode_of_data *dn, unsigned int nofs,
 	int freed = 0;
 	int i, ret;
 
+	trace_f2fs_truncate_nodes_enter(dn->inode, dn->data_blkaddr, dn->nid);
 	if (dn->nid == 0)
 		return NIDS_PER_BLOCK + 1;
 
@@ -592,10 +595,12 @@ static int truncate_nodes(struct dnode_of_data *dn, unsigned int nofs,
 	} else {
 		f2fs_put_page(page, 1);
 	}
+	trace_f2fs_truncate_nodes_exit(dn->inode, freed);
 	return freed;
 
 out_err:
 	f2fs_put_page(page, 1);
+	trace_f2fs_truncate_nodes_exit(dn->inode, ret);
 	return ret;
 }
 
@@ -611,8 +616,10 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
 	int idx = depth - 2;
 
 	nid[0] = le32_to_cpu(ri->i_nid[offset[0] - NODE_DIR1_BLOCK]);
-	if (!nid[0])
+	if (!nid[0]) {
+		trace_f2fs_truncate_partial_nodes(dn->inode, nid, depth, err);
 		return 0;
+	}
 
 	/* get indirect nodes in the path */
 	for (i = 0; i < depth - 1; i++) {
@@ -650,6 +657,7 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
 fail:
 	for (i = depth - 3; i >= 0; i--)
 		f2fs_put_page(pages[i], 1);
+	trace_f2fs_truncate_partial_nodes(dn->inode, nid, depth, err);
 	return err;
 }
 
@@ -666,11 +674,14 @@ int truncate_inode_blocks(struct inode *inode, pgoff_t from)
 	struct dnode_of_data dn;
 	struct page *page;
 
+	trace_f2fs_truncate_inode_blocks_enter(inode, from);
 	level = get_node_path(from, offset, noffset);
 
 	page = get_node_page(sbi, inode->i_ino);
-	if (IS_ERR(page))
+	if (IS_ERR(page)) {
+		trace_f2fs_truncate_inode_blocks_exit(inode, PTR_ERR(page));
 		return PTR_ERR(page);
+	}
 
 	set_new_dnode(&dn, inode, page, NULL, 0);
 	unlock_page(page);
@@ -740,6 +751,7 @@ skip_partial:
 	}
 fail:
 	f2fs_put_page(page, 0);
+	trace_f2fs_truncate_inode_blocks_exit(inode, err);
 	return err > 0 ? 0 : err;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 956ff07..5e780b6 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -211,6 +211,203 @@ TRACE_EVENT(f2fs_unlink_exit,
 		  (unsigned long) __entry->ino,
 		  __entry->ret)
 );
+
+TRACE_EVENT(f2fs_truncate_data_blocks_range,
+	TP_PROTO(struct inode *inode, unsigned int nid, unsigned int ofs,
+								 int free),
+
+	TP_ARGS(inode, nid,  ofs, free),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(unsigned int,	nid)
+		__field(unsigned int,	ofs)
+		__field(int,	free)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->nid	= nid;
+		__entry->ofs	= ofs;
+		__entry->free	= free;
+	),
+
+	TP_printk("dev %d,%d ino %lu  Nid %d offset %u Free count %u ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->nid, __entry->ofs,
+					__entry->free)
+);
+
+DECLARE_EVENT_CLASS(f2fs__truncate_op,
+	TP_PROTO(struct inode *inode, u64 from),
+
+	TP_ARGS(inode, from),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(u64,	addr)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->addr	= from;
+	),
+
+	TP_printk("dev %d,%d ino %lu address %llu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->addr)
+);
+
+DEFINE_EVENT(f2fs__truncate_op, f2fs_truncate_blocks_enter,
+
+	TP_PROTO(struct inode *inode, u64 from),
+
+	TP_ARGS(inode, from)
+);
+
+DEFINE_EVENT(f2fs__truncate_op, f2fs_truncate_inode_blocks_enter,
+
+	TP_PROTO(struct inode *inode, u64 from),
+
+	TP_ARGS(inode, from)
+);
+
+DECLARE_EVENT_CLASS(f2fs__truncate_node,
+	TP_PROTO(struct inode *inode, block_t blk_addr, unsigned int nid),
+
+	TP_ARGS(inode, blk_addr, nid),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(block_t,	addr)
+		__field(unsigned int,	nid)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->addr	= blk_addr;
+		__entry->nid	= nid;
+	),
+
+	TP_printk("dev %d,%d ino %lu block_address %llu Nid %d ",
+		MAJOR(__entry->dev), MINOR(__entry->dev),
+		(unsigned long) __entry->ino, __entry->addr, __entry->nid)
+);
+
+DEFINE_EVENT(f2fs__truncate_node, f2fs_truncate_nodes_enter,
+
+	TP_PROTO(struct inode *inode, block_t blk_addr, unsigned int nid),
+
+	TP_ARGS(inode, blk_addr, nid)
+);
+
+DEFINE_EVENT(f2fs__truncate_node, f2fs_truncate_node,
+
+	TP_PROTO(struct inode *inode, block_t blk_addr, unsigned int nid),
+
+	TP_ARGS(inode, blk_addr, nid)
+);
+
+DECLARE_EVENT_CLASS(f2fs__truncate_op_exit,
+	TP_PROTO(struct inode *inode, int value),
+	TP_ARGS(inode, value),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(int,	val)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->val	= value;
+	),
+
+	TP_printk("dev %d,%d ino %lu with return value %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->val)
+);
+
+DEFINE_EVENT(f2fs__truncate_op_exit, f2fs_truncate_blocks_exit,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret)
+);
+
+DEFINE_EVENT(f2fs__truncate_op_exit, f2fs_truncate_inode_blocks_exit,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret)
+);
+
+DEFINE_EVENT(f2fs__truncate_op_exit, f2fs_truncate_nodes_exit,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret)
+);
+
+TRACE_EVENT(f2fs_truncate_partial_nodes,
+	TP_PROTO(struct inode *inode, unsigned int nid[], int depth, int err),
+
+	TP_ARGS(inode, nid, depth, err),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(unsigned int,	nid[3])
+		__field(unsigned int,	depth)
+		__field(int,	err)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->nid[0]	= nid[0];
+		__entry->nid[1]	= nid[1];
+		__entry->nid[2]	= nid[2];
+		__entry->depth	= depth;
+		__entry->err	= err;
+	),
+
+	TP_printk("dev %d,%d ino %lu  Nid[0] %u Nid[1] %u Nid[2] %u depth %d"
+								" Error %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->nid[0],
+			 __entry->nid[1], __entry->nid[2], __entry->depth,
+					__entry->err)
+);
+
+TRACE_EVENT(f2fs_truncate,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+	),
+
+	TP_printk("dev %d,%d ino %lu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino)
+);
+
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.7.9.5

