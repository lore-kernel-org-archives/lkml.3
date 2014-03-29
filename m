Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaC2TJP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 15:09:15 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:9233 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbaC2TJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 15:09:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlIGAOQZN1NbsF/9/2dsb2JhbABZgwbEH4ESF3SCUxMcGgkYgQIkE4d9AdFTjjFOhD8EjlSJeQGKXIdZgzE8
Date: Sat, 29 Mar 2014 20:09:10 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH v2] mm/readahead.c: inline ra_submit
Message-Id: <20140329200910.35212c0b8890199b578ba175@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

f9acc8c7b35a ("readahead: sanify file_ra_state names")
left ra_submit with a single function call.

Move ra_submit to internal.h and inline it to save some stack.
Thanks to Andrew Morton for commenting different versions.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 include/linux/mm.h |  3 ---
 mm/internal.h      | 15 +++++++++++++++
 mm/readahead.c     | 21 +++------------------
 3 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c1b7414..c8ecf29 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1847,9 +1847,6 @@ void page_cache_async_readahead(struct address_space *mapping,
 				unsigned long size);
 
 unsigned long max_sane_readahead(unsigned long nr);
-unsigned long ra_submit(struct file_ra_state *ra,
-			struct address_space *mapping,
-			struct file *filp);
 
 /* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
diff --git a/mm/internal.h b/mm/internal.h
index 29e1e76..51f309c 100644
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
index 0de2360..4d9f4c2 100644
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
@@ -244,20 +243,6 @@ unsigned long max_sane_readahead(unsigned long nr)
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

