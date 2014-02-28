Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaB1OP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:15:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaB1OPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:15:34 -0500
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 4/6] mm: add set_pageblock_migratetype_nolock() for calls outside zone->lock
Date: Fri, 28 Feb 2014 15:15:02 +0100
Message-Id: <1393596904-16537-5-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1393596904-16537-1-git-send-email-vbabka@suse.cz>
References: <1393596904-16537-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prevent races, set_pageblock_migratetype() should be called with zone->lock
held. This patch adds a debugging assertion and introduces a _nolock variant
for zone init functions.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/page_alloc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index de5b419..fd6a64c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -232,7 +232,7 @@ EXPORT_SYMBOL(nr_online_nodes);
 
 int page_group_by_mobility_disabled __read_mostly;
 
-void set_pageblock_migratetype(struct page *page, int migratetype)
+static void set_pageblock_migratetype_nolock(struct page *page, int migratetype)
 {
 	if (unlikely(page_group_by_mobility_disabled &&
 		     migratetype < MIGRATE_PCPTYPES))
@@ -242,6 +242,13 @@ void set_pageblock_migratetype(struct page *page, int migratetype)
 					PB_migrate, PB_migrate_end);
 }
 
+void set_pageblock_migratetype(struct page *page, int migratetype)
+{
+	VM_BUG_ON(!spin_is_locked(&page_zone(page)->lock));
+
+	set_pageblock_migratetype_nolock(page, migratetype);
+}
+
 bool oom_killer_disabled __read_mostly;
 
 #ifdef CONFIG_DEBUG_VM
@@ -803,7 +810,7 @@ void __init init_cma_reserved_pageblock(struct page *page)
 	} while (++p, --i);
 
 	set_page_refcounted(page);
-	set_pageblock_migratetype(page, MIGRATE_CMA);
+	set_pageblock_migratetype_nolock(page, MIGRATE_CMA);
 	__free_pages(page, pageblock_order);
 	adjust_managed_page_count(page, pageblock_nr_pages);
 }
@@ -4100,7 +4107,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		if ((z->zone_start_pfn <= pfn)
 		    && (pfn < zone_end_pfn(z))
 		    && !(pfn & (pageblock_nr_pages - 1)))
-			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+			set_pageblock_migratetype_nolock(page, MIGRATE_MOVABLE);
 
 		INIT_LIST_HEAD(&page->lru);
 #ifdef WANT_PAGE_VIRTUAL
-- 
1.8.4.5

