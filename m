Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968432Ab3DSQ3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:29:15 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58969 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab3DSQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:29:13 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH v4 3/7] f2fs: add tracepoint for tracing the page i/o operations
Date: Sat, 20 Apr 2013 01:29:05 +0900
Message-Id: <1366388945-18881-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints for page i/o operations and block allocation
tracing during page read operation.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/f2fs/data.c              |   16 +++++++++--
 include/trace/events/f2fs.h |   63 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ea200d9..394ab68 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -22,6 +22,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include <trace/events/f2fs.h>
 
 /*
  * Lock ordering for the change of data block address:
@@ -349,6 +350,8 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 	struct block_device *bdev = sbi->sb->s_bdev;
 	struct bio *bio;
 
+	trace_f2fs_readpage(page, blk_addr, type);
+
 	down_read(&sbi->bio_sem);
 
 	/* Allocate a new bio */
@@ -389,14 +392,20 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 	/* Get the page offset from the block offset(iblock) */
 	pgofs =	(pgoff_t)(iblock >> (PAGE_CACHE_SHIFT - blkbits));
 
-	if (check_extent_cache(inode, pgofs, bh_result))
+	if (check_extent_cache(inode, pgofs, bh_result)) {
+		trace_f2fs_get_data_block(inode, iblock, bh_result->b_blocknr,
+							 bh_result->b_size, 0);
 		return 0;
+	}
 
 	/* When reading holes, we need its node page */
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, pgofs, LOOKUP_NODE_RA);
-	if (err)
+	if (err) {
+		trace_f2fs_get_data_block(inode, iblock, bh_result->b_blocknr,
+							bh_result->b_size, err);
 		return (err == -ENOENT) ? 0 : err;
+	}
 
 	/* It does not support data allocation */
 	BUG_ON(create);
@@ -421,6 +430,9 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 		bh_result->b_size = (i << blkbits);
 	}
 	f2fs_put_dnode(&dn);
+	trace_f2fs_get_data_block(inode, iblock, bh_result->b_blocknr,
+							bh_result->b_size, err);
+
 	return 0;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 5e780b6..c7e71f9 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -408,6 +408,69 @@ TRACE_EVENT(f2fs_truncate,
 		  (unsigned long) __entry->ino)
 );
 
+TRACE_EVENT_CONDITION(f2fs_readpage,
+	TP_PROTO(struct page *page, sector_t blk_addr, int type),
+
+	TP_ARGS(page, blk_addr, type),
+
+	TP_CONDITION(page->mapping),
+
+	TP_STRUCT__entry(
+		__field(pgoff_t, index)
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+		__field(sector_t,	block)
+		__field(int,	type)
+
+	),
+
+	TP_fast_assign(
+		__entry->index	= page->index;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+		__entry->block	= blk_addr;
+		__entry->type	= type;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu block %llu type %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->index,
+		  (unsigned long long) __entry->block, __entry->type)
+);
+
+TRACE_EVENT(f2fs_get_data_block,
+	TP_PROTO(struct inode *inode, sector_t block, sector_t bh_block,
+							 size_t size, int ret),
+
+	TP_ARGS(inode, block, bh_block, size, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(sector_t,	block)
+		__field(sector_t,	bh_block)
+		__field(size_t,	size)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->block	= block;
+		__entry->bh_block	= bh_block;
+		__entry->size	= size;
+		__entry->ret	= ret;
+	),
+
+	TP_printk("dev %d,%d ino %lu block number %llu Bh Start block %llu"
+						" Mapping Size %u error %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+			(unsigned long long) __entry->block,
+			 (unsigned long long) __entry->bh_block,
+					__entry->size,  __entry->ret)
+);
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.7.9.5

