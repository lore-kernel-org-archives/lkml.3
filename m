Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab3GLCEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:04:15 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42376 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932556Ab3GLCEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:04:13 -0400
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, Nate Zimmer <nzimmer@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [RFC 3/4] Seperate page initialization into a separate function.
Date: Thu, 11 Jul 2013 21:03:54 -0500
Message-Id: <1373594635-131067-4-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1373594635-131067-1-git-send-email-holt@sgi.com>
References: <1373594635-131067-1-git-send-email-holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, memmap_init_zone() has all the smarts for initializing a
single page.  When we convert to initializing pages in a 2MiB chunk,
we will need to do this equivalent work from two separate places
so we are breaking out a helper function.

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Nate Zimmer <nzimmer@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linux MM <linux-mm@kvack.org>
Cc: Rob Landley <rob@landley.net>
Cc: Mike Travis <travis@sgi.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
---
 mm/mm_init.c    |  2 +-
 mm/page_alloc.c | 75 +++++++++++++++++++++++++++++++++------------------------
 2 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index c280a02..be8a539 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -128,7 +128,7 @@ void __init mminit_verify_pageflags_layout(void)
 	BUG_ON(or_mask != add_mask);
 }
 
-void __meminit mminit_verify_page_links(struct page *page, enum zone_type zone,
+void mminit_verify_page_links(struct page *page, enum zone_type zone,
 			unsigned long nid, unsigned long pfn)
 {
 	BUG_ON(page_to_nid(page) != nid);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c3edb62..635b131 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -697,6 +697,49 @@ static void free_one_page(struct zone *zone, struct page *page, int order,
 	spin_unlock(&zone->lock);
 }
 
+static void __init_single_page(struct page *page, unsigned long zone, int nid, int reserved)
+{
+	unsigned long pfn = page_to_pfn(page);
+	struct zone *z = &NODE_DATA(nid)->node_zones[zone];
+
+	set_page_links(page, zone, nid, pfn);
+	mminit_verify_page_links(page, zone, nid, pfn);
+	init_page_count(page);
+	page_mapcount_reset(page);
+	page_nid_reset_last(page);
+	if (reserved) {
+		SetPageReserved(page);
+	} else {
+		ClearPageReserved(page);
+		set_page_count(page, 0);
+	}
+	/*
+	 * Mark the block movable so that blocks are reserved for
+	 * movable at startup. This will force kernel allocations
+	 * to reserve their blocks rather than leaking throughout
+	 * the address space during boot when many long-lived
+	 * kernel allocations are made. Later some blocks near
+	 * the start are marked MIGRATE_RESERVE by
+	 * setup_zone_migrate_reserve()
+	 *
+	 * bitmap is created for zone's valid pfn range. but memmap
+	 * can be created for invalid pages (for alignment)
+	 * check here not to call set_pageblock_migratetype() against
+	 * pfn out of zone.
+	 */
+	if ((z->zone_start_pfn <= pfn)
+	    && (pfn < zone_end_pfn(z))
+	    && !(pfn & (pageblock_nr_pages - 1)))
+		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+
+	INIT_LIST_HEAD(&page->lru);
+#ifdef WANT_PAGE_VIRTUAL
+	/* The shift won't overflow because ZONE_NORMAL is below 4G. */
+	if (!is_highmem_idx(zone))
+		set_page_address(page, __va(pfn << PAGE_SHIFT));
+#endif
+}
+
 static bool free_pages_prepare(struct page *page, unsigned int order)
 {
 	int i;
@@ -3934,37 +3977,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 				continue;
 		}
 		page = pfn_to_page(pfn);
-		set_page_links(page, zone, nid, pfn);
-		mminit_verify_page_links(page, zone, nid, pfn);
-		init_page_count(page);
-		page_mapcount_reset(page);
-		page_nid_reset_last(page);
-		SetPageReserved(page);
-		/*
-		 * Mark the block movable so that blocks are reserved for
-		 * movable at startup. This will force kernel allocations
-		 * to reserve their blocks rather than leaking throughout
-		 * the address space during boot when many long-lived
-		 * kernel allocations are made. Later some blocks near
-		 * the start are marked MIGRATE_RESERVE by
-		 * setup_zone_migrate_reserve()
-		 *
-		 * bitmap is created for zone's valid pfn range. but memmap
-		 * can be created for invalid pages (for alignment)
-		 * check here not to call set_pageblock_migratetype() against
-		 * pfn out of zone.
-		 */
-		if ((z->zone_start_pfn <= pfn)
-		    && (pfn < zone_end_pfn(z))
-		    && !(pfn & (pageblock_nr_pages - 1)))
-			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-
-		INIT_LIST_HEAD(&page->lru);
-#ifdef WANT_PAGE_VIRTUAL
-		/* The shift won't overflow because ZONE_NORMAL is below 4G. */
-		if (!is_highmem_idx(zone))
-			set_page_address(page, __va(pfn << PAGE_SHIFT));
-#endif
+		__init_single_page(page, zone, nid, 1);
 	}
 }
 
-- 
1.8.2.1

