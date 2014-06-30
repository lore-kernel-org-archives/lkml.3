Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaF3VLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:11:14 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35273 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaF3VLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:11:13 -0400
Date: Mon, 30 Jun 2014 14:09:49 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: replace init_page_accessed by __SetPageReferenced
In-Reply-To: <alpine.LSU.2.11.1406301405230.1096@eggly.anvils>
Message-ID: <alpine.LSU.2.11.1406301408310.1096@eggly.anvils>
References: <alpine.LSU.2.11.1406301405230.1096@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do we really need an exported alias for __SetPageReferenced()?
Its callers better know what they're doing, in which case the page
would not be already marked referenced.  Kill init_page_accessed(),
just __SetPageReferenced() inline.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 include/linux/swap.h |    1 -
 mm/filemap.c         |    4 ++--
 mm/shmem.c           |    2 +-
 mm/swap.c            |   14 +++-----------
 4 files changed, 6 insertions(+), 15 deletions(-)

--- 3.16-rc3+/include/linux/swap.h	2014-06-16 00:28:54.916076526 -0700
+++ linux/include/linux/swap.h	2014-06-30 12:55:35.216149853 -0700
@@ -311,7 +311,6 @@ extern void lru_add_page_tail(struct pag
 			 struct lruvec *lruvec, struct list_head *head);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
-extern void init_page_accessed(struct page *page);
 extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_all(void);
--- 3.16-rc3+/mm/filemap.c	2014-06-16 00:28:55.100076530 -0700
+++ linux/mm/filemap.c	2014-06-30 12:55:35.216149853 -0700
@@ -1100,9 +1100,9 @@ no_page:
 		if (WARN_ON_ONCE(!(fgp_flags & FGP_LOCK)))
 			fgp_flags |= FGP_LOCK;
 
-		/* Init accessed so avoit atomic mark_page_accessed later */
+		/* Init accessed so avoid atomic mark_page_accessed later */
 		if (fgp_flags & FGP_ACCESSED)
-			init_page_accessed(page);
+			__SetPageReferenced(page);
 
 		err = add_to_page_cache_lru(page, mapping, offset, radix_gfp_mask);
 		if (unlikely(err)) {
--- 3.16-rc3+/mm/shmem.c	2014-06-30 12:15:52.204093217 -0700
+++ linux/mm/shmem.c	2014-06-30 12:55:35.216149853 -0700
@@ -1143,7 +1143,7 @@ repeat:
 		__SetPageSwapBacked(page);
 		__set_page_locked(page);
 		if (sgp == SGP_WRITE)
-			init_page_accessed(page);
+			__SetPageReferenced(page);
 
 		error = mem_cgroup_charge_file(page, current->mm,
 						gfp & GFP_RECLAIM_MASK);
--- 3.16-rc3+/mm/swap.c	2014-06-16 00:28:55.132076531 -0700
+++ linux/mm/swap.c	2014-06-30 12:55:35.216149853 -0700
@@ -589,6 +589,9 @@ static void __lru_cache_activate_page(st
  * inactive,unreferenced	->	inactive,referenced
  * inactive,referenced		->	active,unreferenced
  * active,unreferenced		->	active,referenced
+ *
+ * When a newly allocated page is not yet visible, so safe for non-atomic ops,
+ * __SetPageReferenced(page) may be substituted for mark_page_accessed(page).
  */
 void mark_page_accessed(struct page *page)
 {
@@ -614,17 +617,6 @@ void mark_page_accessed(struct page *pag
 }
 EXPORT_SYMBOL(mark_page_accessed);
 
-/*
- * Used to mark_page_accessed(page) that is not visible yet and when it is
- * still safe to use non-atomic ops
- */
-void init_page_accessed(struct page *page)
-{
-	if (!PageReferenced(page))
-		__SetPageReferenced(page);
-}
-EXPORT_SYMBOL(init_page_accessed);
-
 static void __lru_cache_add(struct page *page)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvec);
