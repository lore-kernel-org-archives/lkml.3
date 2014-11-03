Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097AbaKCIIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:08:53 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:64978 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaKCIIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:08:51 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 3 Nov 2014 17:10:31 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5 4/4] mm/page_alloc: restrict max order of merging on
 isolated pageblock
Message-ID: <20141103081031.GC7052@js1304-P5Q-DELUXE>
References: <1414740330-4086-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1414740330-4086-5-git-send-email-iamjoonsoo.kim@lge.com>
 <54539F11.7080501@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54539F11.7080501@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 03:39:13PM +0100, Vlastimil Babka wrote:
> On 10/31/2014 08:25 AM, Joonsoo Kim wrote:
> >@@ -571,6 +548,7 @@ static inline void __free_one_page(struct page *page,
> >  	unsigned long combined_idx;
> >  	unsigned long uninitialized_var(buddy_idx);
> >  	struct page *buddy;
> >+	int max_order = MAX_ORDER;
> >
> >  	VM_BUG_ON(!zone_is_initialized(zone));
> >
> >@@ -579,15 +557,23 @@ static inline void __free_one_page(struct page *page,
> >  			return;
> >
> >  	VM_BUG_ON(migratetype == -1);
> >-	if (!is_migrate_isolate(migratetype))
> >+	if (is_migrate_isolate(migratetype)) {
> >+		/*
> >+		 * We restrict max order of merging to prevent merge
> >+		 * between freepages on isolate pageblock and normal
> >+		 * pageblock. Without this, pageblock isolation
> >+		 * could cause incorrect freepage accounting.
> >+		 */
> >+		max_order = min(MAX_ORDER, pageblock_order + 1);
> >+	} else
> >  		__mod_zone_freepage_state(zone, 1 << order, migratetype);
> 
> Please add { } to the else branch, this looks ugly :)

Sure.

> 
> >-	page_idx = pfn & ((1 << MAX_ORDER) - 1);
> >+	page_idx = pfn & ((1 << max_order) - 1);
> >
> >  	VM_BUG_ON_PAGE(page_idx & ((1 << order) - 1), page);
> >  	VM_BUG_ON_PAGE(bad_range(zone, page), page);
> >
> >-	while (order < MAX_ORDER-1) {
> >+	while (order < max_order - 1) {
> >  		buddy_idx = __find_buddy_index(page_idx, order);
> >  		buddy = page + (buddy_idx - page_idx);
> >  		if (!page_is_buddy(page, buddy, order))
> >@@ -1590,7 +1576,7 @@ void split_page(struct page *page, unsigned int order)
> >  }
> >  EXPORT_SYMBOL_GPL(split_page);
> >
> >-static int __isolate_free_page(struct page *page, unsigned int order)
> >+int __isolate_free_page(struct page *page, unsigned int order)
> >  {
> >  	unsigned long watermark;
> >  	struct zone *zone;
> >diff --git a/mm/page_isolation.c b/mm/page_isolation.c
> >index 1fa4a4d..df61c93 100644
> >--- a/mm/page_isolation.c
> >+++ b/mm/page_isolation.c
> >@@ -76,17 +76,48 @@ void unset_migratetype_isolate(struct page *page, unsigned migratetype)
> >  {
> >  	struct zone *zone;
> >  	unsigned long flags, nr_pages;
> >+	struct page *isolated_page = NULL;
> >+	unsigned int order;
> >+	unsigned long page_idx, buddy_idx;
> >+	struct page *buddy;
> >+	int mt;
> >
> >  	zone = page_zone(page);
> >  	spin_lock_irqsave(&zone->lock, flags);
> >  	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
> >  		goto out;
> >+
> >+	/*
> >+	 * Because freepage with more than pageblock_order on isolated
> >+	 * pageblock is restricted to merge due to freepage counting problem,
> >+	 * it is possible that there is free buddy page.
> >+	 * move_freepages_block() doesn't care of merge so we need other
> >+	 * approach in order to merge them. Isolation and free will make
> >+	 * these pages to be merged.
> >+	 */
> >+	if (PageBuddy(page)) {
> >+		order = page_order(page);
> >+		if (order >= pageblock_order) {
> >+			page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
> >+			buddy_idx = __find_buddy_index(page_idx, order);
> >+			buddy = page + (buddy_idx - page_idx);
> >+			mt = get_pageblock_migratetype(buddy);
> >+
> >+			if (!is_migrate_isolate(mt)) {
> 
> You could use is_migrate_isolate_page(buddy) and save a variable.

Okay.

> >+				__isolate_free_page(page, order);
> >+				set_page_refcounted(page);
> >+				isolated_page = page;
> >+			}
> >+		}
> >+	}
> >  	nr_pages = move_freepages_block(zone, page, migratetype);
> 
> - this is a costly no-op when the whole pageblock is an isolated
> page, right?

Okay. I will fix it.

> 
> >  	__mod_zone_freepage_state(zone, nr_pages, migratetype);
> 
> - with isolated_page set, this means you increase freepage_state
> here, and then the second time in __free_pages() below?
> __isolate_free_page() won't decrease it as the pageblock is still
> MIGRATE_ISOLATE, so the net result is overcounting?

After __isolate_free_page(), freepage has no buddy flag and
move_freepages_block() doesn't move and count it. So, freepage_state
only increase in __free_pages(). So net result will be correct.

Below is the update for your comment.

Thanks.

------------>8----------------
>From 4bf298908aba16935c7699589c60d00fa0cf389c Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Mon, 25 Aug 2014 09:52:13 +0900
Subject: [PATCH v6 4/4] mm/page_alloc: restrict max order of merging on isolated
 pageblock

Current pageblock isolation logic could isolate each pageblock
individually. This causes freepage accounting problem if freepage with
pageblock order on isolate pageblock is merged with other freepage on
normal pageblock. We can prevent merging by restricting max order of
merging to pageblock order if freepage is on isolate pageblock.

Side-effect of this change is that there could be non-merged buddy
freepage even if finishing pageblock isolation, because undoing pageblock
isolation is just to move freepage from isolate buddy list to normal buddy
list rather than to consider merging. So, the patch also makes undoing
pageblock isolation consider freepage merge. When un-isolation, freepage
with more than pageblock order and it's buddy are checked. If they are
on normal pageblock, instead of just moving, we isolate the freepage and
free it in order to get merged.

Changes from v5:
Avoid costly move_freepages_block() if there is no freepage.
Some cosmetic changes.

Changes from v4:
Consider merging on un-isolation process.

Cc: <stable@vger.kernel.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 mm/internal.h       |   25 +++++++++++++++++++++++++
 mm/page_alloc.c     |   41 ++++++++++++++---------------------------
 mm/page_isolation.c |   41 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 78 insertions(+), 29 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 8293040..a4f90ba 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -108,6 +108,31 @@ extern pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
 /*
  * in mm/page_alloc.c
  */
+
+/*
+ * Locate the struct page for both the matching buddy in our
+ * pair (buddy1) and the combined O(n+1) page they form (page).
+ *
+ * 1) Any buddy B1 will have an order O twin B2 which satisfies
+ * the following equation:
+ *     B2 = B1 ^ (1 << O)
+ * For example, if the starting buddy (buddy2) is #8 its order
+ * 1 buddy is #10:
+ *     B2 = 8 ^ (1 << 1) = 8 ^ 2 = 10
+ *
+ * 2) Any buddy B will have an order O+1 parent P which
+ * satisfies the following equation:
+ *     P = B & ~(1 << O)
+ *
+ * Assumption: *_mem_map is contiguous at least up to MAX_ORDER
+ */
+static inline unsigned long
+__find_buddy_index(unsigned long page_idx, unsigned int order)
+{
+	return page_idx ^ (1 << order);
+}
+
+extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
 extern void prep_compound_page(struct page *page, unsigned long order);
 #ifdef CONFIG_MEMORY_FAILURE
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2bc7768..a009d0a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -469,29 +469,6 @@ static inline void rmv_page_order(struct page *page)
 }
 
 /*
- * Locate the struct page for both the matching buddy in our
- * pair (buddy1) and the combined O(n+1) page they form (page).
- *
- * 1) Any buddy B1 will have an order O twin B2 which satisfies
- * the following equation:
- *     B2 = B1 ^ (1 << O)
- * For example, if the starting buddy (buddy2) is #8 its order
- * 1 buddy is #10:
- *     B2 = 8 ^ (1 << 1) = 8 ^ 2 = 10
- *
- * 2) Any buddy B will have an order O+1 parent P which
- * satisfies the following equation:
- *     P = B & ~(1 << O)
- *
- * Assumption: *_mem_map is contiguous at least up to MAX_ORDER
- */
-static inline unsigned long
-__find_buddy_index(unsigned long page_idx, unsigned int order)
-{
-	return page_idx ^ (1 << order);
-}
-
-/*
  * This function checks whether a page is free && is the buddy
  * we can do coalesce a page and its buddy if
  * (a) the buddy is not in a hole &&
@@ -571,6 +548,7 @@ static inline void __free_one_page(struct page *page,
 	unsigned long combined_idx;
 	unsigned long uninitialized_var(buddy_idx);
 	struct page *buddy;
+	int max_order = MAX_ORDER;
 
 	VM_BUG_ON(!zone_is_initialized(zone));
 
@@ -579,15 +557,24 @@ static inline void __free_one_page(struct page *page,
 			return;
 
 	VM_BUG_ON(migratetype == -1);
-	if (!is_migrate_isolate(migratetype))
+	if (is_migrate_isolate(migratetype)) {
+		/*
+		 * We restrict max order of merging to prevent merge
+		 * between freepages on isolate pageblock and normal
+		 * pageblock. Without this, pageblock isolation
+		 * could cause incorrect freepage accounting.
+		 */
+		max_order = min(MAX_ORDER, pageblock_order + 1);
+	} else {
 		__mod_zone_freepage_state(zone, 1 << order, migratetype);
+	}
 
-	page_idx = pfn & ((1 << MAX_ORDER) - 1);
+	page_idx = pfn & ((1 << max_order) - 1);
 
 	VM_BUG_ON_PAGE(page_idx & ((1 << order) - 1), page);
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
-	while (order < MAX_ORDER-1) {
+	while (order < max_order - 1) {
 		buddy_idx = __find_buddy_index(page_idx, order);
 		buddy = page + (buddy_idx - page_idx);
 		if (!page_is_buddy(page, buddy, order))
@@ -1590,7 +1577,7 @@ void split_page(struct page *page, unsigned int order)
 }
 EXPORT_SYMBOL_GPL(split_page);
 
-static int __isolate_free_page(struct page *page, unsigned int order)
+int __isolate_free_page(struct page *page, unsigned int order)
 {
 	unsigned long watermark;
 	struct zone *zone;
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 1fa4a4d..c8778f7 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -76,17 +76,54 @@ void unset_migratetype_isolate(struct page *page, unsigned migratetype)
 {
 	struct zone *zone;
 	unsigned long flags, nr_pages;
+	struct page *isolated_page = NULL;
+	unsigned int order;
+	unsigned long page_idx, buddy_idx;
+	struct page *buddy;
 
 	zone = page_zone(page);
 	spin_lock_irqsave(&zone->lock, flags);
 	if (get_pageblock_migratetype(page) != MIGRATE_ISOLATE)
 		goto out;
-	nr_pages = move_freepages_block(zone, page, migratetype);
-	__mod_zone_freepage_state(zone, nr_pages, migratetype);
+
+	/*
+	 * Because freepage with more than pageblock_order on isolated
+	 * pageblock is restricted to merge due to freepage counting problem,
+	 * it is possible that there is free buddy page.
+	 * move_freepages_block() doesn't care of merge so we need other
+	 * approach in order to merge them. Isolation and free will make
+	 * these pages to be merged.
+	 */
+	if (PageBuddy(page)) {
+		order = page_order(page);
+		if (order >= pageblock_order) {
+			page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
+			buddy_idx = __find_buddy_index(page_idx, order);
+			buddy = page + (buddy_idx - page_idx);
+
+			if (!is_migrate_isolate_page(buddy)) {
+				__isolate_free_page(page, order);
+				set_page_refcounted(page);
+				isolated_page = page;
+			}
+		}
+	}
+
+	/*
+	 * If we isolate freepage with more than pageblock_order, there
+	 * should be no freepage in the range, so we could avoid costly
+	 * pageblock scanning for freepage moving.
+	 */
+	if (!isolated_page) {
+		nr_pages = move_freepages_block(zone, page, migratetype);
+		__mod_zone_freepage_state(zone, nr_pages, migratetype);
+	}
 	set_pageblock_migratetype(page, migratetype);
 	zone->nr_isolate_pageblock--;
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
+	if (isolated_page)
+		__free_pages(isolated_page, order);
 }
 
 static inline struct page *
-- 
1.7.9.5

