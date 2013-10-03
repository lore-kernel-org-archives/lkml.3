Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3JCDcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 23:32:14 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34475 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3JCDcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 23:32:13 -0400
Message-ID: <524CE532.1030001@gmail.com>
Date: Thu, 03 Oct 2013 11:32:02 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Wen Congyang <wency@cn.fujitsu.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, isimatu.yasuaki@jp.fujitsu.com,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 2/2] mm/sparsemem: Fix a bug in free_map_bootmem when CONFIG_SPARSEMEM_VMEMMAP
References: <524CE4C1.8060508@gmail.com>
In-Reply-To: <524CE4C1.8060508@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

We pass the number of pages which hold page structs of a memory
section to function free_map_bootmem. This is right when
!CONFIG_SPARSEMEM_VMEMMAP but wrong when CONFIG_SPARSEMEM_VMEMMAP.
When CONFIG_SPARSEMEM_VMEMMAP, we should pass the number of pages
of a memory section to free_map_bootmem.

So the fix is removing the nr_pages parameter. When
CONFIG_SPARSEMEM_VMEMMAP, we directly use the prefined marco
PAGES_PER_SECTION in free_map_bootmem. When !CONFIG_SPARSEMEM_VMEMMAP,
we calculate page numbers needed to hold the page structs for a
memory section and use the value in free_map_bootmem.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/sparse.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index fbb9dbc..908c134 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -603,10 +603,10 @@ static void __kfree_section_memmap(struct page *memmap)
 	vmemmap_free(start, end);
 }
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
+static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
-	unsigned long end = (unsigned long)(memmap + nr_pages);
+	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
 	vmemmap_free(start, end);
 }
@@ -648,11 +648,13 @@ static void __kfree_section_memmap(struct page *memmap)
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
+static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long maps_section_nr, removing_section_nr, i;
 	unsigned long magic;
 	struct page *page = virt_to_page(memmap);
+	unsigned long nr_pages = get_order(sizeof(struct page) *
+					   PAGES_PER_SECTION);
 
 	for (i = 0; i < nr_pages; i++, page++) {
 		magic = (unsigned long) page->lru.next;
@@ -756,7 +758,6 @@ static inline void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
 static void free_section_usemap(struct page *memmap, unsigned long *usemap)
 {
 	struct page *usemap_page;
-	unsigned long nr_pages;
 
 	if (!usemap)
 		return;
@@ -777,12 +778,8 @@ static void free_section_usemap(struct page *memmap, unsigned long *usemap)
 	 * on the section which has pgdat at boot time. Just keep it as is now.
 	 */
 
-	if (memmap) {
-		nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
-			>> PAGE_SHIFT;
-
-		free_map_bootmem(memmap, nr_pages);
-	}
+	if (memmap)
+		free_map_bootmem(memmap);
 }
 
 void sparse_remove_one_section(struct zone *zone, struct mem_section *ms)
-- 
1.7.1

