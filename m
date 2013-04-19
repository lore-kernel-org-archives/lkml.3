Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab3DSQbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:31:48 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:41785 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968460Ab3DSQaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:30:05 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH v4 6/7] f2fs: add tracepoints for write page operations
Date: Sat, 20 Apr 2013 01:29:58 +0900
Message-Id: <1366388998-18983-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints to debug the various page write operation
like data pages, meta pages.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/f2fs/checkpoint.c        |    2 +
 fs/f2fs/data.c              |    2 +
 fs/f2fs/segment.c           |    4 ++
 include/trace/events/f2fs.h |  120 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 128 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index be6aa2e..197796a 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -20,6 +20,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include <trace/events/f2fs.h>
 
 static struct kmem_cache *orphan_entry_slab;
 static struct kmem_cache *inode_entry_slab;
@@ -75,6 +76,7 @@ static int f2fs_write_meta_page(struct page *page,
 	struct inode *inode = page->mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 
+	trace_f2fs_write_page(page, META);
 	/* Should not write any meta pages, if any IO error was occurred */
 	if (wbc->for_reclaim ||
 			is_set_ckpt_flags(F2FS_CKPT(sbi), CP_ERROR_FLAG)) {
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 503b5bf..40c0577 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -499,6 +499,7 @@ static int f2fs_write_data_page(struct page *page,
 	bool need_balance_fs = false;
 	int err = 0;
 
+	trace_f2fs_write_page(page, DATA);
 	if (page->index < end_index)
 		goto write;
 
@@ -608,6 +609,7 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 	int err = 0;
 	int ilock;
 
+	trace_f2fs_write_begin(inode, pos, len, flags);
 	/* for nobh_write_end */
 	*fsdata = NULL;
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c83a59a..1193a26 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -18,6 +18,7 @@
 #include "f2fs.h"
 #include "segment.h"
 #include "node.h"
+#include <trace/events/f2fs.h>
 
 /*
  * This function balances dirty node and dentry pages.
@@ -690,6 +691,8 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 
 	if (sbi->bio[btype]) {
 		struct bio_private *p = sbi->bio[btype]->bi_private;
+		trace_f2fs_do_submit_bio(sbi->sb, btype, sync,
+			 sbi->bio[btype]->bi_sector, sbi->bio[btype]->bi_size);
 		p->sbi = sbi;
 		sbi->bio[btype]->bi_end_io = f2fs_end_io_write;
 		if (type == META_FLUSH) {
@@ -746,6 +749,7 @@ alloc_new:
 	sbi->last_block_in_bio[type] = blk_addr;
 
 	up_write(&sbi->bio_sem);
+	trace_f2fs_submit_write_page(page, blk_addr, type);
 }
 
 static bool __has_curseg_space(struct f2fs_sb_info *sbi, int type)
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index cf1bcdf8..32372a6 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -568,6 +568,126 @@ TRACE_EVENT(f2fs_reserve_new_block,
 		   __entry->nid, __entry->ofs_node)
 );
 
+TRACE_EVENT(f2fs_do_submit_bio,
+	TP_PROTO(struct super_block *sb, int btype, int sync, sector_t sector,
+							unsigned int size),
+	TP_ARGS(sb, btype, sync, sector, size),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int,	btype)
+		__field(int,	sync)
+		__field(sector_t,	sector)
+		__field(unsigned int,	size)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= sb->s_dev;
+		__entry->btype		= btype;
+		__entry->sync		= sync;
+		__entry->sector		= sector;
+		__entry->size		= size;
+	),
+
+	TP_printk("dev %d,%d: Bio type %d sync %d Sector %llu size %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->btype, __entry->sync,
+			 (unsigned long long) __entry->sector, __entry->size)
+);
+
+
+TRACE_EVENT(f2fs_write_begin,
+
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+		 unsigned int flags),
+
+	TP_ARGS(inode, pos, len, flags),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	pos)
+		__field(unsigned int, len)
+		__field(unsigned int, flags)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= pos;
+		__entry->len	= len;
+		__entry->flags	= flags;
+	),
+
+	TP_printk("dev %d,%d ino %lu pos %lld len %u flags %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->pos, __entry->len, __entry->flags)
+);
+
+TRACE_EVENT(f2fs_submit_write_page,
+
+	TP_PROTO(struct page *page, block_t blk_addr, int type),
+
+	TP_ARGS(page, blk_addr, type),
+
+	TP_STRUCT__entry(
+		__field(pgoff_t, index)
+		__field(int, type)
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+		__field(block_t, block)
+
+	),
+
+	TP_fast_assign(
+		__entry->index	= page->index;
+		__entry->type	= type;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+		__entry->block	= blk_addr;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu type %d block %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->index, __entry->type,
+						 __entry->block)
+);
+
+DECLARE_EVENT_CLASS(f2fs_page_type_op,
+	TP_PROTO(struct page *page, int type),
+
+	TP_ARGS(page, type),
+
+	TP_STRUCT__entry(
+		__field(pgoff_t, index)
+		__field(int, type)
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+
+	),
+
+	TP_fast_assign(
+		__entry->index	= page->index;
+		__entry->type	= type;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu type %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->index, __entry->type)
+);
+
+DEFINE_EVENT(f2fs_page_type_op, f2fs_write_page,
+
+	TP_PROTO(struct page *page, int type),
+
+	TP_ARGS(page, type)
+);
+
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.7.9.5

