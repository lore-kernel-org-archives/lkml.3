Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab3DLBS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:18:59 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49685 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3DLBO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:14:26 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Simon Jeons <simon.jeons@gmail.com>
Subject: [RFC PATCH v2 07/25] page_alloc: add return_pages_to_zone() when DYNAMIC_NUMA is enabled.
Date: Thu, 11 Apr 2013 18:13:39 -0700
Message-Id: <1365729237-29711-8-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1365729237-29711-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041201-3620-0000-0000-00000200144E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add return_pages_to_zone(), which uses return_page_to_zone().
It is a minimized version of __free_pages_ok() which handles adding
pages which have been removed from another zone into a new zone.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/internal.h   |  5 ++++-
 mm/page_alloc.c | 17 +++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index b11e574..a70c77b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -104,6 +104,10 @@ extern void prep_compound_page(struct page *page, unsigned long order);
 #ifdef CONFIG_MEMORY_FAILURE
 extern bool is_free_buddy_page(struct page *page);
 #endif
+#ifdef CONFIG_DYNAMIC_NUMA
+void return_pages_to_zone(struct page *page, unsigned int order,
+			  struct zone *zone);
+#endif
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
@@ -114,7 +118,6 @@ extern int ensure_zone_is_initialized(struct zone *zone,
 #endif
 
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
-
 /*
  * in mm/compaction.c
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 96909bb..1fbf5f2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -442,6 +442,12 @@ static inline void set_page_order(struct page *page, int order)
 	__SetPageBuddy(page);
 }
 
+static inline void set_free_page_order(struct page *page, int order)
+{
+	set_page_private(page, order);
+	VM_BUG_ON(!PageBuddy(page));
+}
+
 static inline void rmv_page_order(struct page *page)
 {
 	__ClearPageBuddy(page);
@@ -738,6 +744,17 @@ static void __free_pages_ok(struct page *page, unsigned int order)
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_DYNAMIC_NUMA
+void return_pages_to_zone(struct page *page, unsigned int order,
+			  struct zone *zone)
+{
+	unsigned long flags;
+	local_irq_save(flags);
+	free_one_page(zone, page, order, get_freepage_migratetype(page));
+	local_irq_restore(flags);
+}
+#endif
+
 /*
  * Read access to zone->managed_pages is safe because it's unsigned long,
  * but we still need to serialize writers. Currently all callers of
-- 
1.8.2.1

