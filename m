Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaH1Sgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbaH1Sgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:39 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 50/97] mm/readahead.c: inline ra_submit
Date: Thu, 28 Aug 2014 19:34:58 +0100
Message-Id: <1409250945-30874-51-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

commit 29f175d125f0f3a9503af8a5596f93d714cceb08 upstream.

Commit f9acc8c7b35a ("readahead: sanify file_ra_state names") left
ra_submit with a single function call.

Move ra_submit to internal.h and inline it to save some stack.  Thanks
to Andrew Morton for commenting different versions.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/mm.h |  3 ---
 mm/internal.h      | 15 +++++++++++++++
 mm/readahead.c     | 21 +++------------------
 3 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 96fc7dd..2b3a533 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1631,9 +1631,6 @@ void page_cache_async_readahead(struct address_space *mapping,
 				unsigned long size);
 
 unsigned long max_sane_readahead(unsigned long nr);
-unsigned long ra_submit(struct file_ra_state *ra,
-			struct address_space *mapping,
-			struct file *filp);
 
 /* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
diff --git a/mm/internal.h b/mm/internal.h
index fdddbc83..c1488a3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -11,6 +11,7 @@
 #ifndef __MM_INTERNAL_H
 #define __MM_INTERNAL_H
 
+#include <linux/fs.h>
 #include <linux/mm.h>
 
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
@@ -21,6 +22,20 @@ static inline void set_page_count(struct page *page, int v)
 	atomic_set(&page->_count, v);
 }
 
+extern int __do_page_cache_readahead(struct address_space *mapping,
+		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
+		unsigned long lookahead_size);
+
+/*
+ * Submit IO for the read-ahead request in file_ra_state.
+ */
+static inline unsigned long ra_submit(struct file_ra_state *ra,
+		struct address_space *mapping, struct file *filp)
+{
+	return __do_page_cache_readahead(mapping, filp,
+					ra->start, ra->size, ra->async_size);
+}
+
 /*
  * Turn a non-refcounted page (->_count == 0) into refcounted with
  * a count of one.
diff --git a/mm/readahead.c b/mm/readahead.c
index 4ab0c93..0f35e98 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -8,9 +8,7 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/fs.h>
 #include <linux/gfp.h>
-#include <linux/mm.h>
 #include <linux/export.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
@@ -20,6 +18,8 @@
 #include <linux/syscalls.h>
 #include <linux/file.h>
 
+#include "internal.h"
+
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
  * memset *ra to zero.
@@ -149,8 +149,7 @@ out:
  *
  * Returns the number of pages requested, or the maximum amount of I/O allowed.
  */
-static int
-__do_page_cache_readahead(struct address_space *mapping, struct file *filp,
+int __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read,
 			unsigned long lookahead_size)
 {
@@ -248,20 +247,6 @@ unsigned long max_sane_readahead(unsigned long nr)
 }
 
 /*
- * Submit IO for the read-ahead request in file_ra_state.
- */
-unsigned long ra_submit(struct file_ra_state *ra,
-		       struct address_space *mapping, struct file *filp)
-{
-	int actual;
-
-	actual = __do_page_cache_readahead(mapping, filp,
-					ra->start, ra->size, ra->async_size);
-
-	return actual;
-}
-
-/*
  * Set the initial window size, round to next power of 2 and square
  * for small size, x 4 for medium, and x 2 for large
  * for 128k (32 page) max ra
-- 
1.8.4.5

