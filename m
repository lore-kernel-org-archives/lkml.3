Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab3BSCeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:34:36 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:45205 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634Ab3BSCed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:34:33 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 7/8] f2fs: add tracepoints for write page operations
Date: Tue, 19 Feb 2013 11:34:18 +0900
Message-Id: <1361241259-18243-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints to debug the various page write operation
like data pages, meta pages.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/checkpoint.c        |    2 ++
 fs/f2fs/data.c              |    2 ++
 include/trace/events/f2fs.h |   62 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 2b6fc13..a0fce2c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -20,6 +20,7 @@
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
+#include <trace/events/f2fs.h>
 
 static struct kmem_cache *orphan_entry_slab;
 static struct kmem_cache *inode_entry_slab;
@@ -82,6 +83,7 @@ static int f2fs_write_meta_page(struct page *page,
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
 
+	trace_f2fs_write_page(page, META);
 	wait_on_page_writeback(page);
 
 	write_meta_page(sbi, page);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index be96b0e..7f59bb9 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -495,6 +495,7 @@ static int f2fs_write_data_page(struct page *page,
 	unsigned offset;
 	int err = 0;
 
+	trace_f2fs_write_page(page, DATA);
 	if (page->index < end_index)
 		goto out;
 
@@ -603,6 +604,7 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 	struct dnode_of_data dn;
 	int err = 0;
 
+	trace_f2fs_write_begin(inode, pos, len, flags);
 	/* for nobh_write_end */
 	*fsdata = NULL;
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 88ee2c7..46856bd 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -440,6 +440,68 @@ TRACE_EVENT(f2fs_reserve_new_block,
 		   __entry->nid)
 );
 
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

