Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab3IPP1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:27:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab3IPP1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:27:09 -0400
Message-ID: <52372349.6030308@suse.cz>
Date: Mon, 16 Sep 2013 17:27:05 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [munlock] BUG: Bad page map in process killall5 pte:53425553
 pmd:075f4067
References: <20130916084752.GC11479@localhost>
In-Reply-To: <20130916084752.GC11479@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 10:47 AM, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 7a8010cd36273ff5f6fea5201ef9232f30cebbd9
> Author: Vlastimil Babka <vbabka@suse.cz>
> Date:   Wed Sep 11 14:22:35 2013 -0700
> 
>     mm: munlock: manual pte walk in fast path instead of follow_page_mask()
>     
 
> 
> [   56.020577] BUG: Bad page map in process killall5  pte:53425553 pmd:075f4067
> [   56.022578] addr:08800000 vm_flags:00100073 anon_vma:7f5f6f00 mapping:  (null) index:8800
> [   56.025276] CPU: 0 PID: 101 Comm: killall5 Not tainted 3.11.0-09272-g666a584 #52
> 

Hello,

the stacktrace points clearly to the code added by the patch (function __munlock_pagevec_fill),
no question about that. However, the addresses that are reported by print_bad_pte() in the logs
(08800000 and 0a000000) are both on the page table boundary (note this is x86_32 without PAE)
and should never appear inside the while loop of the function (and be passed to vm_normal_page()).
This could only happen if pmd_addr_end() failed to prevent crossing the page table boundary and
I just cannot see how that could occur without some variables being corrupted :/

Also, some of the failures during bisect were not due to this bug, but a WARNING for
list_add corruption which hopefully is not related to munlock. While it is probably a far stretch,
some kind of memory corruption could also lead to the erroneous behavior of the munlock code.

Can you therefore please retest with the bisected patch reverted (patch below) to see if the other
WARNING still occurs and can be dealt with separately, so there are not potentially two bugs to
be chased at the same time?

Thanks,
Vlastimil


-----8<-----
>From 979cbdeaaed76e25a9e08c7ccadba5baf5e7c619 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 16 Sep 2013 17:06:12 +0200
Subject: [PATCH] Revert "mm: munlock: manual pte walk in fast path instead of
 follow_page_mask()"

This reverts commit 7a8010cd36273ff5f6fea5201ef9232f30cebbd9 for testing.
---
 include/linux/mm.h |  12 +++---
 mm/mlock.c         | 110 +++++++++++++++--------------------------------------
 2 files changed, 37 insertions(+), 85 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8b6e55e..e9bab9c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -630,12 +630,12 @@ static inline enum zone_type page_zonenum(const struct page *page)
 #endif
 
 /*
- * The identification function is mainly used by the buddy allocator for
- * determining if two pages could be buddies. We are not really identifying
- * the zone since we could be using the section number id if we do not have
- * node id available in page flags.
- * We only guarantee that it will return the same value for two combinable
- * pages in a zone.
+ * The identification function is only used by the buddy allocator for
+ * determining if two pages could be buddies. We are not really
+ * identifying a zone since we could be using a the section number
+ * id if we have not node id available in page flags.
+ * We guarantee only that it will return the same value for two
+ * combinable pages in a zone.
  */
 static inline int page_zone_id(struct page *page)
 {
diff --git a/mm/mlock.c b/mm/mlock.c
index d638026..19a934d 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -280,7 +280,8 @@ static void __putback_lru_fast(struct pagevec *pvec, int pgrescued)
  * The second phase finishes the munlock only for pages where isolation
  * succeeded.
  *
- * Note that the pagevec may be modified during the process.
+ * Note that pvec is modified during the process. Before returning
+ * pagevec_reinit() is called on it.
  */
 static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 {
@@ -355,60 +356,8 @@ skip_munlock:
 	 */
 	if (pagevec_count(&pvec_putback))
 		__putback_lru_fast(&pvec_putback, pgrescued);
-}
-
-/*
- * Fill up pagevec for __munlock_pagevec using pte walk
- *
- * The function expects that the struct page corresponding to @start address is
- * a non-TPH page already pinned and in the @pvec, and that it belongs to @zone.
- *
- * The rest of @pvec is filled by subsequent pages within the same pmd and same
- * zone, as long as the pte's are present and vm_normal_page() succeeds. These
- * pages also get pinned.
- *
- * Returns the address of the next page that should be scanned. This equals
- * @start + PAGE_SIZE when no page could be added by the pte walk.
- */
-static unsigned long __munlock_pagevec_fill(struct pagevec *pvec,
-		struct vm_area_struct *vma, int zoneid,	unsigned long start,
-		unsigned long end)
-{
-	pte_t *pte;
-	spinlock_t *ptl;
-
-	/*
-	 * Initialize pte walk starting at the already pinned page where we
-	 * are sure that there is a pte.
-	 */
-	pte = get_locked_pte(vma->vm_mm, start,	&ptl);
-	end = min(end, pmd_addr_end(start, end));
-
-	/* The page next to the pinned page is the first we will try to get */
-	start += PAGE_SIZE;
-	while (start < end) {
-		struct page *page = NULL;
-		pte++;
-		if (pte_present(*pte))
-			page = vm_normal_page(vma, start, *pte);
-		/*
-		 * Break if page could not be obtained or the page's node+zone does not
-		 * match
-		 */
-		if (!page || page_zone_id(page) != zoneid)
-			break;
 
-		get_page(page);
-		/*
-		 * Increase the address that will be returned *before* the
-		 * eventual break due to pvec becoming full by adding the page
-		 */
-		start += PAGE_SIZE;
-		if (pagevec_add(pvec, page) == 0)
-			break;
-	}
-	pte_unmap_unlock(pte, ptl);
-	return start;
+	pagevec_reinit(pvec);
 }
 
 /*
@@ -432,16 +381,17 @@ static unsigned long __munlock_pagevec_fill(struct pagevec *pvec,
 void munlock_vma_pages_range(struct vm_area_struct *vma,
 			     unsigned long start, unsigned long end)
 {
+	struct pagevec pvec;
+	struct zone *zone = NULL;
+
+	pagevec_init(&pvec, 0);
 	vma->vm_flags &= ~VM_LOCKED;
 
 	while (start < end) {
-		struct page *page = NULL;
+		struct page *page;
 		unsigned int page_mask, page_increm;
-		struct pagevec pvec;
-		struct zone *zone;
-		int zoneid;
+		struct zone *pagezone;
 
-		pagevec_init(&pvec, 0);
 		/*
 		 * Although FOLL_DUMP is intended for get_dump_page(),
 		 * it just so happens that its special treatment of the
@@ -450,10 +400,22 @@ void munlock_vma_pages_range(struct vm_area_struct *vma,
 		 * has sneaked into the range, we won't oops here: great).
 		 */
 		page = follow_page_mask(vma, start, FOLL_GET | FOLL_DUMP,
-				&page_mask);
-
+					&page_mask);
 		if (page && !IS_ERR(page)) {
+			pagezone = page_zone(page);
+			/* The whole pagevec must be in the same zone */
+			if (pagezone != zone) {
+				if (pagevec_count(&pvec))
+					__munlock_pagevec(&pvec, zone);
+				zone = pagezone;
+			}
 			if (PageTransHuge(page)) {
+				/*
+				 * THP pages are not handled by pagevec due
+				 * to their possible split (see below).
+				 */
+				if (pagevec_count(&pvec))
+					__munlock_pagevec(&pvec, zone);
 				lock_page(page);
 				/*
 				 * Any THP page found by follow_page_mask() may
@@ -466,31 +428,21 @@ void munlock_vma_pages_range(struct vm_area_struct *vma,
 				put_page(page); /* follow_page_mask() */
 			} else {
 				/*
-				 * Non-huge pages are handled in batches via
-				 * pagevec. The pin from follow_page_mask()
-				 * prevents them from collapsing by THP.
-				 */
-				pagevec_add(&pvec, page);
-				zone = page_zone(page);
-				zoneid = page_zone_id(page);
-
-				/*
-				 * Try to fill the rest of pagevec using fast
-				 * pte walk. This will also update start to
-				 * the next page to process. Then munlock the
-				 * pagevec.
+				 * Non-huge pages are handled in batches
+				 * via pagevec. The pin from
+				 * follow_page_mask() prevents them from
+				 * collapsing by THP.
 				 */
-				start = __munlock_pagevec_fill(&pvec, vma,
-						zoneid, start, end);
-				__munlock_pagevec(&pvec, zone);
-				goto next;
+				if (pagevec_add(&pvec, page) == 0)
+					__munlock_pagevec(&pvec, zone);
 			}
 		}
 		page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
 		start += page_increm * PAGE_SIZE;
-next:
 		cond_resched();
 	}
+	if (pagevec_count(&pvec))
+		__munlock_pagevec(&pvec, zone);
 }
 
 /*
-- 
1.8.1.4


