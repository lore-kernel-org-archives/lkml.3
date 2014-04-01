Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaDAJQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbaDAJQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:09 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/29] GFS2: journal data writepages update
Date: Tue,  1 Apr 2014 10:15:15 +0100
Message-Id: <1396343741-1524-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFS2 has carried what is more or less a copy of the
write_cache_pages() for some time. It seems that this
copy has slipped behind the core code over time. This
patch brings it back uptodate, and in addition adds the
tracepoint which would otherwise be missing.

We could go further, and eliminate some or all of the
code duplication here. The issue is that if we do that,
then the function we need to split out from the existing
write_cache_pages(), which will look a lot like
gfs2_jdata_write_pagevec(), would land up putting quite a
lot of extra variables on the stack. I know that has been
a problem in the past in the writeback code path, which
is why I've hesitated to do it here.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e0259a1..82a1456 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -94,6 +94,8 @@ static inline struct inode *wb_inode(struct list_head *head)
 #define CREATE_TRACE_POINTS
 #include <trace/events/writeback.h>
 
+EXPORT_TRACEPOINT_SYMBOL_GPL(wbc_writepage);
+
 static void bdi_queue_work(struct backing_dev_info *bdi,
 			   struct wb_writeback_work *work)
 {
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 49436fa..ce62dca 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -21,6 +21,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/backing-dev.h>
 #include <linux/aio.h>
+#include <trace/events/writeback.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -230,13 +231,11 @@ static int gfs2_writepages(struct address_space *mapping,
 static int gfs2_write_jdata_pagevec(struct address_space *mapping,
 				    struct writeback_control *wbc,
 				    struct pagevec *pvec,
-				    int nr_pages, pgoff_t end)
+				    int nr_pages, pgoff_t end,
+				    pgoff_t *done_index)
 {
 	struct inode *inode = mapping->host;
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	loff_t i_size = i_size_read(inode);
-	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
-	unsigned offset = i_size & (PAGE_CACHE_SIZE-1);
 	unsigned nrblocks = nr_pages * (PAGE_CACHE_SIZE/inode->i_sb->s_blocksize);
 	int i;
 	int ret;
@@ -248,40 +247,83 @@ static int gfs2_write_jdata_pagevec(struct address_space *mapping,
 	for(i = 0; i < nr_pages; i++) {
 		struct page *page = pvec->pages[i];
 
+		/*
+		 * At this point, the page may be truncated or
+		 * invalidated (changing page->mapping to NULL), or
+		 * even swizzled back from swapper_space to tmpfs file
+		 * mapping. However, page->index will not change
+		 * because we have a reference on the page.
+		 */
+		if (page->index > end) {
+			/*
+			 * can't be range_cyclic (1st pass) because
+			 * end == -1 in that case.
+			 */
+			ret = 1;
+			break;
+		}
+
+		*done_index = page->index;
+
 		lock_page(page);
 
 		if (unlikely(page->mapping != mapping)) {
+continue_unlock:
 			unlock_page(page);
 			continue;
 		}
 
-		if (!wbc->range_cyclic && page->index > end) {
-			ret = 1;
-			unlock_page(page);
-			continue;
+		if (!PageDirty(page)) {
+			/* someone wrote it for us */
+			goto continue_unlock;
 		}
 
-		if (wbc->sync_mode != WB_SYNC_NONE)
-			wait_on_page_writeback(page);
-
-		if (PageWriteback(page) ||
-		    !clear_page_dirty_for_io(page)) {
-			unlock_page(page);
-			continue;
+		if (PageWriteback(page)) {
+			if (wbc->sync_mode != WB_SYNC_NONE)
+				wait_on_page_writeback(page);
+			else
+				goto continue_unlock;
 		}
 
-		/* Is the page fully outside i_size? (truncate in progress) */
-		if (page->index > end_index || (page->index == end_index && !offset)) {
-			page->mapping->a_ops->invalidatepage(page, 0,
-							     PAGE_CACHE_SIZE);
-			unlock_page(page);
-			continue;
-		}
+		BUG_ON(PageWriteback(page));
+		if (!clear_page_dirty_for_io(page))
+			goto continue_unlock;
+
+		trace_wbc_writepage(wbc, mapping->backing_dev_info);
 
 		ret = __gfs2_jdata_writepage(page, wbc);
+		if (unlikely(ret)) {
+			if (ret == AOP_WRITEPAGE_ACTIVATE) {
+				unlock_page(page);
+				ret = 0;
+			} else {
+
+				/*
+				 * done_index is set past this page,
+				 * so media errors will not choke
+				 * background writeout for the entire
+				 * file. This has consequences for
+				 * range_cyclic semantics (ie. it may
+				 * not be suitable for data integrity
+				 * writeout).
+				 */
+				*done_index = page->index + 1;
+				ret = 1;
+				break;
+			}
+		}
 
-		if (ret || (--(wbc->nr_to_write) <= 0))
+		/*
+		 * We stop writing back only if we are not doing
+		 * integrity sync. In case of integrity sync we have to
+		 * keep going until we have written all the pages
+		 * we tagged for writeback prior to entering this loop.
+		 */
+		if (--wbc->nr_to_write <= 0 && wbc->sync_mode == WB_SYNC_NONE) {
 			ret = 1;
+			break;
+		}
+
 	}
 	gfs2_trans_end(sdp);
 	return ret;
@@ -306,51 +348,69 @@ static int gfs2_write_cache_jdata(struct address_space *mapping,
 	int done = 0;
 	struct pagevec pvec;
 	int nr_pages;
+	pgoff_t uninitialized_var(writeback_index);
 	pgoff_t index;
 	pgoff_t end;
-	int scanned = 0;
+	pgoff_t done_index;
+	int cycled;
 	int range_whole = 0;
+	int tag;
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
-		index = mapping->writeback_index; /* Start from prev offset */
+		writeback_index = mapping->writeback_index; /* prev offset */
+		index = writeback_index;
+		if (index == 0)
+			cycled = 1;
+		else
+			cycled = 0;
 		end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		scanned = 1;
+		cycled = 1; /* ignore range_cyclic tests */
 	}
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
+		tag = PAGECACHE_TAG_TOWRITE;
+	else
+		tag = PAGECACHE_TAG_DIRTY;
 
 retry:
-	 while (!done && (index <= end) &&
-		(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-					       PAGECACHE_TAG_DIRTY,
-					       min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		scanned = 1;
-		ret = gfs2_write_jdata_pagevec(mapping, wbc, &pvec, nr_pages, end);
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
+		tag_pages_for_writeback(mapping, index, end);
+	done_index = index;
+	while (!done && (index <= end)) {
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		if (nr_pages == 0)
+			break;
+
+		ret = gfs2_write_jdata_pagevec(mapping, wbc, &pvec, nr_pages, end, &done_index);
 		if (ret)
 			done = 1;
 		if (ret > 0)
 			ret = 0;
-
 		pagevec_release(&pvec);
 		cond_resched();
 	}
 
-	if (!scanned && !done) {
+	if (!cycled && !done) {
 		/*
+		 * range_cyclic:
 		 * We hit the last page and there is more work to be done: wrap
 		 * back to the start of the file
 		 */
-		scanned = 1;
+		cycled = 1;
 		index = 0;
+		end = writeback_index - 1;
 		goto retry;
 	}
 
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
-		mapping->writeback_index = index;
+		mapping->writeback_index = done_index;
+
 	return ret;
 }
 
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index c7bbbe7..309a086 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -4,6 +4,7 @@
 #if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_WRITEBACK_H
 
+#include <linux/tracepoint.h>
 #include <linux/backing-dev.h>
 #include <linux/writeback.h>
 
-- 
1.8.3.1

