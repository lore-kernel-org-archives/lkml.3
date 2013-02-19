Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab3BSCdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:33:45 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:47972 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab3BSCdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:33:43 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 4/8] f2fs: add tracepoint for tracing the page i/o operations
Date: Tue, 19 Feb 2013 11:33:35 +0900
Message-Id: <1361241215-18141-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints for page i/o operations and block allocation
tracing during page read operation.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/data.c              |   10 ++++++-
 include/trace/events/f2fs.h |   68 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7bd22a2..61beb82 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -21,6 +21,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include <trace/events/f2fs.h>
 
 /*
  * Lock ordering for the change of data block address:
@@ -334,6 +335,9 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 	bool sync = (type == READ_SYNC);
 	struct bio *bio;
 
+	if (page->mapping)
+		trace_f2fs_readpage(page);
+
 	/* This page can be already read by other threads */
 	if (PageUptodate(page)) {
 		if (!sync)
@@ -384,6 +388,7 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 	pgoff_t pgofs;
 	int err;
 
+	trace_f2fs_get_data_block_enter(inode, iblock);
 	/* Get the page offset from the block offset(iblock) */
 	pgofs =	(pgoff_t)(iblock >> (PAGE_CACHE_SHIFT - blkbits));
 
@@ -393,8 +398,10 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 	/* When reading holes, we need its node page */
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, pgofs, RDONLY_NODE);
-	if (err)
+	if (err) {
+		trace_f2fs_get_data_block_exit(inode, err);
 		return (err == -ENOENT) ? 0 : err;
+	}
 
 	/* It does not support data allocation */
 	BUG_ON(create);
@@ -419,6 +426,7 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 		bh_result->b_size = (i << blkbits);
 	}
 	f2fs_put_dnode(&dn);
+	trace_f2fs_get_data_block_exit(inode, 0);
 	return 0;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index e29e782..ae25a1f 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -276,6 +276,74 @@ TRACE_EVENT(f2fs_truncate,
 		  (unsigned long) __entry->ino)
 );
 
+TRACE_EVENT(f2fs_readpage,
+	TP_PROTO(struct page *page),
+
+	TP_ARGS(page),
+
+	TP_STRUCT__entry(
+		__field(pgoff_t, index)
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+
+	),
+
+	TP_fast_assign(
+		__entry->index	= page->index;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->index)
+);
+
+TRACE_EVENT(f2fs_get_data_block_enter,
+	TP_PROTO(struct inode *inode, sector_t block),
+
+	TP_ARGS(inode, block),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(sector_t,	block)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->block	= block;
+	),
+
+	TP_printk("dev %d,%d ino %lu block number %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->block)
+);
+
+TRACE_EVENT(f2fs_get_data_block_exit,
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->ret	= ret;
+	),
+
+	TP_printk("dev %d,%d ino %lu return value %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->ret)
+);
+
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.7.9.5

