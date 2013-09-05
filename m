Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763508Ab3IEII5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:08:57 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:32051 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763483Ab3IEIIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:08:50 -0400
Message-ID: <52283BA5.3020809@huawei.com>
Date: Thu, 5 Sep 2013 16:07:01 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
CC: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH 1/2] mm: use pgdat_end_pfn() to simplify the code in arch
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "pgdat_end_pfn()" instead of "pgdat->node_start_pfn + pgdat->node_spanned_pages".
Simplify the code, no functional change.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 arch/ia64/mm/init.c    |    4 +---
 arch/metag/mm/init.c   |    2 +-
 arch/powerpc/mm/numa.c |    3 +--
 arch/sh/mm/init.c      |    2 +-
 4 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index b6f7f43..88504ab 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -357,9 +357,7 @@ int vmemmap_find_next_valid_pfn(int node, int i)
 
 	end_address = (unsigned long) &vmem_map[pgdat->node_start_pfn + i];
 	end_address = PAGE_ALIGN(end_address);
-
-	stop_address = (unsigned long) &vmem_map[
-		pgdat->node_start_pfn + pgdat->node_spanned_pages];
+	stop_address = (unsigned long) &vmem_map[pgdat_end_pfn(pgdat)];
 
 	do {
 		pgd_t *pgd;
diff --git a/arch/metag/mm/init.c b/arch/metag/mm/init.c
index 28813f1..51b045b 100644
--- a/arch/metag/mm/init.c
+++ b/arch/metag/mm/init.c
@@ -149,7 +149,7 @@ static void __init bootmem_init_one_node(unsigned int nid)
 	if (!p->node_spanned_pages)
 		return;
 
-	end_pfn = p->node_start_pfn + p->node_spanned_pages;
+	end_pfn = pgdat_end_pfn(p);
 #ifdef CONFIG_HIGHMEM
 	if (end_pfn > max_low_pfn)
 		end_pfn = max_low_pfn;
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 5850798..4ea1d57 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -935,8 +935,7 @@ static void __init mark_reserved_regions_for_nid(int nid)
 		unsigned long start_pfn = physbase >> PAGE_SHIFT;
 		unsigned long end_pfn = PFN_UP(physbase + size);
 		struct node_active_region node_ar;
-		unsigned long node_end_pfn = node->node_start_pfn +
-					     node->node_spanned_pages;
+		unsigned long node_end_pfn = pgdat_end_pfn(node);
 
 		/*
 		 * Check to make sure that this memblock.reserved area is
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 33890fd..2d089fe 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -231,7 +231,7 @@ static void __init bootmem_init_one_node(unsigned int nid)
 	if (!p->node_spanned_pages)
 		return;
 
-	end_pfn = p->node_start_pfn + p->node_spanned_pages;
+	end_pfn = pgdat_end_pfn(p);
 
 	total_pages = bootmem_bootmap_pages(p->node_spanned_pages);
 
-- 
1.7.1


