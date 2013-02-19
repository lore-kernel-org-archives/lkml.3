Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab3BSCde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:33:34 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55253 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab3BSCdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:33:31 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 3/8] f2fs: add tracepoints for truncate operation
Date: Tue, 19 Feb 2013 11:33:23 +0900
Message-Id: <1361241203-18107-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints for tracing the truncate operations
like truncate node/data blocks, f2fs_truncate etc.

Tracepoints are added at entry and exit of operation
to trace the success & failure of operation.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/file.c              |    6 ++-
 fs/f2fs/node.c              |    7 +++
 include/trace/events/f2fs.h |  108 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 318708b..022d318 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -201,6 +201,8 @@ static int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
 	struct f2fs_node *raw_node;
 	__le32 *addr;
 
+	trace_f2fs_truncate_data_blocks_range_enter(dn->inode,
+						 dn->data_blkaddr, dn->nid);
 	raw_node = page_address(dn->node_page);
 	addr = blkaddr_in_node(raw_node) + ofs;
 
@@ -219,6 +221,8 @@ static int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
 		sync_inode_page(dn);
 	}
 	dn->ofs_in_node = ofs;
+
+	trace_f2fs_truncate_data_blocks_range_exit(dn->inode, nr_free);
 	return nr_free;
 }
 
@@ -297,7 +301,7 @@ void f2fs_truncate(struct inode *inode)
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 				S_ISLNK(inode->i_mode)))
 		return;
-
+	trace_f2fs_truncate(inode);
 	if (!truncate_blocks(inode, i_size_read(inode))) {
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		mark_inode_dirty(inode);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e275218..70025b3 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -19,6 +19,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include <trace/events/f2fs.h>
 
 static struct kmem_cache *nat_entry_slab;
 static struct kmem_cache *free_nid_slab;
@@ -544,6 +545,7 @@ static int truncate_nodes(struct dnode_of_data *dn, unsigned int nofs,
 	int freed = 0;
 	int i, ret;
 
+	trace_f2fs_truncate_nodes_enter(dn->inode, dn->data_blkaddr, dn->nid);
 	if (dn->nid == 0)
 		return NIDS_PER_BLOCK + 1;
 
@@ -591,10 +593,12 @@ static int truncate_nodes(struct dnode_of_data *dn, unsigned int nofs,
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
 
@@ -609,6 +613,8 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
 	int i;
 	int idx = depth - 2;
 
+	trace_f2fs_truncate_partial_nodes_enter(dn->inode,
+						 dn->data_blkaddr, dn->nid);
 	nid[0] = le32_to_cpu(ri->i_nid[offset[0] - NODE_DIR1_BLOCK]);
 	if (!nid[0])
 		return 0;
@@ -649,6 +655,7 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
 fail:
 	for (i = depth - 3; i >= 0; i--)
 		f2fs_put_page(pages[i], 1);
+	trace_f2fs_truncate_partial_nodes_exit(dn->inode, err);
 	return err;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 0c76885..e29e782 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -168,6 +168,114 @@ TRACE_EVENT(f2fs_unlink_exit,
 		  __entry->ret)
 );
 
+DECLARE_EVENT_CLASS(f2fs__truncate_op,
+	TP_PROTO(struct inode *inode, block_t blk_addr, unsigned int nid),
+
+	TP_ARGS(inode, blk_addr, nid),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(block_t, addr)
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
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->addr, __entry->nid)
+);
+
+DEFINE_EVENT(f2fs__truncate_op, f2fs_truncate_data_blocks_range_enter,
+
+	TP_PROTO(struct inode *inode, block_t blk_addr, unsigned int nid),
+
+	TP_ARGS(inode, blk_addr, nid)
+);
+
+DEFINE_EVENT(f2fs__truncate_op, f2fs_truncate_nodes_enter,
+
+	TP_PROTO(struct inode *inode, block_t blk_addr, unsigned int nid),
+
+	TP_ARGS(inode, blk_addr, nid)
+);
+
+DEFINE_EVENT(f2fs__truncate_op, f2fs_truncate_partial_nodes_enter,
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
+DEFINE_EVENT(f2fs__truncate_op_exit, f2fs_truncate_data_blocks_range_exit,
+
+	TP_PROTO(struct inode *inode, int nr_free),
+
+	TP_ARGS(inode, nr_free)
+);
+
+DEFINE_EVENT(f2fs__truncate_op_exit, f2fs_truncate_nodes_exit,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret)
+);
+
+DEFINE_EVENT(f2fs__truncate_op_exit, f2fs_truncate_partial_nodes_exit,
+
+	TP_PROTO(struct inode *inode, int err),
+
+	TP_ARGS(inode, err)
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

