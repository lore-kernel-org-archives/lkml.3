Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3DFFqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 01:46:19 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38680 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3DFFqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 01:46:16 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH v3 3/7] f2fs: add tracepoint for tracing the page i/o operations
Date: Sat,  6 Apr 2013 14:46:09 +0900
Message-Id: <1365227169-15458-1-git-send-email-linkinjeon@gmail.com>
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
 fs/f2fs/data.c              |    9 ++++++-
 include/trace/events/f2fs.h |   61 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 4f4da0d..d5d5a7c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -22,6 +22,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include <trace/events/f2fs.h>
 
 /*
  * Lock ordering for the change of data block address:
@@ -346,6 +347,8 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 	struct block_device *bdev = sbi->sb->s_bdev;
 	struct bio *bio;
 
+	trace_f2fs_readpage(page);
+
 	down_read(&sbi->bio_sem);
 
 	/* Allocate a new bio */
@@ -383,6 +386,7 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 	pgoff_t pgofs;
 	int err;
 
+	trace_f2fs_get_data_block_enter(inode, iblock, 0);
 	/* Get the page offset from the block offset(iblock) */
 	pgofs =	(pgoff_t)(iblock >> (PAGE_CACHE_SHIFT - blkbits));
 
@@ -392,8 +396,10 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 	/* When reading holes, we need its node page */
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, pgofs, LOOKUP_NODE_RA);
-	if (err)
+	if (err) {
+		trace_f2fs_get_data_block_exit(inode, iblock, err);
 		return (err == -ENOENT) ? 0 : err;
+	}
 
 	/* It does not support data allocation */
 	BUG_ON(create);
@@ -418,6 +424,7 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 		bh_result->b_size = (i << blkbits);
 	}
 	f2fs_put_dnode(&dn);
+	trace_f2fs_get_data_block_exit(inode, iblock, 0);
 	return 0;
 }
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 0d39f58..3df0525 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -266,6 +266,67 @@ TRACE_EVENT(f2fs_truncate,
 		  (unsigned long) __entry->ino)
 );
 
+TRACE_EVENT_CONDITION(f2fs_readpage,
+	TP_PROTO(struct page *page),
+
+	TP_ARGS(page),
+
+	TP_CONDITION(page->mapping),
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
+DECLARE_EVENT_CLASS(f2fs_data_block,
+	TP_PROTO(struct inode *inode, sector_t block, int ret),
+
+	TP_ARGS(inode, block, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(sector_t,	block)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->block	= block;
+		__entry->ret	= ret;
+	),
+
+	TP_printk("dev %d,%d ino %lu block number %llu error %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+			(unsigned long long) __entry->block, __entry->ret)
+);
+
+DEFINE_EVENT(f2fs_data_block, f2fs_get_data_block_enter,
+	TP_PROTO(struct inode *inode, sector_t block, int ret),
+	TP_ARGS(inode, block, ret)
+);
+
+DEFINE_EVENT(f2fs_data_block, f2fs_get_data_block_exit,
+	TP_PROTO(struct inode *inode, sector_t block, int ret),
+	TP_ARGS(inode, block, ret)
+);
+
 #endif /* _TRACE_F2FS_H */
 
  /* This part must be outside protection */
-- 
1.7.9.5

