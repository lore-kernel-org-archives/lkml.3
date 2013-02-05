Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab3BEROn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:14:43 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47679 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab3BEROk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:14:40 -0500
Message-ID: <51113DF6.9040308@gmail.com>
Date: Wed, 06 Feb 2013 01:14:30 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: akpm@linux-foundation.org, Linux MM <linux-mm@kvack.org>, mgorman@suse.de,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        m.szyprowski@samsung.com
CC: linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: [PATCH 3/3] mm: rename nr_free_pagecache_pages to nr_free_pagecache_high_pages
References: <51113CE3.5090000@gmail.com>
In-Reply-To: <51113CE3.5090000@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

This function actually counts RAM pages that are above high watermark within
all zones, so rename it to a reasonable name.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 include/linux/swap.h |    2 +-
 mm/memory_hotplug.c  |    4 ++--
 mm/page_alloc.c      |    7 ++++---
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0df8905..9a8ab19 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -217,7 +217,7 @@ extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
 extern unsigned long dirty_balance_reserve;
 extern unsigned int nr_free_buffer_high_pages(void);
-extern unsigned int nr_free_pagecache_pages(void);
+extern unsigned int nr_free_pagecache_high_pages(void);
 
 /* Definition of global_page_state not available yet */
 #define nr_free_pages() global_page_state(NR_FREE_PAGES)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index d04ed87..6e482c7 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -777,7 +777,7 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
 	if (onlined_pages)
 		kswapd_run(zone_to_nid(zone));
 
-	vm_total_pages = nr_free_pagecache_pages();
+	vm_total_pages = nr_free_pagecache_high_pages();
 
 	writeback_set_ratelimit();
 
@@ -1356,7 +1356,7 @@ repeat:
 	if (arg.status_change_nid >= 0)
 		kswapd_stop(node);
 
-	vm_total_pages = nr_free_pagecache_pages();
+	vm_total_pages = nr_free_pagecache_high_pages();
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a021d91..6e0d91a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2816,9 +2816,10 @@ unsigned int nr_free_buffer_high_pages(void)
 EXPORT_SYMBOL_GPL(nr_free_buffer_high_pages);
 
 /*
- * Amount of free RAM allocatable within all zones
+ * Amount of free RAM allocatable that is above high watermark
+ * within all zones
  */
-unsigned int nr_free_pagecache_pages(void)
+unsigned int nr_free_pagecache_high_pages(void)
 {
 	return nr_free_zone_high_pages(gfp_zone(GFP_HIGHUSER_MOVABLE));
 }
@@ -3649,7 +3650,7 @@ void __ref build_all_zonelists(pg_data_t *pgdat, struct zone *zone)
 		stop_machine(__build_all_zonelists, pgdat, NULL);
 		/* cpuset refresh routine should be here */
 	}
-	vm_total_pages = nr_free_pagecache_pages();
+	vm_total_pages = nr_free_pagecache_high_pages();
 	/*
 	 * Disable grouping by mobility if the number of pages in the
 	 * system is too low to allow the mechanism to work. It would be
-- 
1.7.1

