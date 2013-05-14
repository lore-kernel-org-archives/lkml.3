Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab3ENQmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:42:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590Ab3ENQh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:37:58 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        hughd@google.com, lczerner@redhat.com, xfs@oss.sgi.com
Subject: [PATCH v4 05/20] xfs: use ->invalidatepage() length argument
Date: Tue, 14 May 2013 18:37:19 +0200
Message-Id: <1368549454-8930-6-git-send-email-lczerner@redhat.com>
In-Reply-To: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->invalidatepage() aop now accepts range to invalidate so we can make
use of it in xfs_vm_invalidatepage()

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com
---
v4: use xfs_page_class instead of separate tracepoint

 fs/xfs/xfs_aops.c  |    9 +++++----
 fs/xfs/xfs_trace.h |   15 ++++++++++-----
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e426796..55c85ec 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -826,8 +826,9 @@ xfs_vm_invalidatepage(
 	unsigned int		offset,
 	unsigned int		length)
 {
-	trace_xfs_invalidatepage(page->mapping->host, page, offset);
-	block_invalidatepage(page, offset, PAGE_CACHE_SIZE - offset);
+	trace_xfs_invalidatepage(page->mapping->host, page, offset,
+				 length);
+	block_invalidatepage(page, offset, length);
 }
 
 /*
@@ -921,7 +922,7 @@ xfs_vm_writepage(
 	int			count = 0;
 	int			nonblocking = 0;
 
-	trace_xfs_writepage(inode, page, 0);
+	trace_xfs_writepage(inode, page, 0, 0);
 
 	ASSERT(page_has_buffers(page));
 
@@ -1152,7 +1153,7 @@ xfs_vm_releasepage(
 {
 	int			delalloc, unwritten;
 
-	trace_xfs_releasepage(page->mapping->host, page, 0);
+	trace_xfs_releasepage(page->mapping->host, page, 0, 0);
 
 	xfs_count_page_state(page, &delalloc, &unwritten);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 16a8129..7f075ed 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -950,14 +950,16 @@ DEFINE_RW_EVENT(xfs_file_splice_read);
 DEFINE_RW_EVENT(xfs_file_splice_write);
 
 DECLARE_EVENT_CLASS(xfs_page_class,
-	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),
-	TP_ARGS(inode, page, off),
+	TP_PROTO(struct inode *inode, struct page *page, unsigned long off,
+		 unsigned int len),
+	TP_ARGS(inode, page, off, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(pgoff_t, pgoff)
 		__field(loff_t, size)
 		__field(unsigned long, offset)
+		__field(unsigned int, length)
 		__field(int, delalloc)
 		__field(int, unwritten)
 	),
@@ -971,24 +973,27 @@ DECLARE_EVENT_CLASS(xfs_page_class,
 		__entry->pgoff = page_offset(page);
 		__entry->size = i_size_read(inode);
 		__entry->offset = off;
+		__entry->length = len;
 		__entry->delalloc = delalloc;
 		__entry->unwritten = unwritten;
 	),
 	TP_printk("dev %d:%d ino 0x%llx pgoff 0x%lx size 0x%llx offset %lx "
-		  "delalloc %d unwritten %d",
+		  "length %x delalloc %d unwritten %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->pgoff,
 		  __entry->size,
 		  __entry->offset,
+		  __entry->length,
 		  __entry->delalloc,
 		  __entry->unwritten)
 )
 
 #define DEFINE_PAGE_EVENT(name)		\
 DEFINE_EVENT(xfs_page_class, name,	\
-	TP_PROTO(struct inode *inode, struct page *page, unsigned long off),	\
-	TP_ARGS(inode, page, off))
+	TP_PROTO(struct inode *inode, struct page *page, unsigned long off, \
+		 unsigned int len),	\
+	TP_ARGS(inode, page, off, len))
 DEFINE_PAGE_EVENT(xfs_writepage);
 DEFINE_PAGE_EVENT(xfs_releasepage);
 DEFINE_PAGE_EVENT(xfs_invalidatepage);
-- 
1.7.7.6

