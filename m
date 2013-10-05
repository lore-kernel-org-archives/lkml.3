Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3JEQzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 12:55:31 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:59085 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3JEQza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 12:55:30 -0400
Message-ID: <52504476.6060607@gmail.com>
Date: Sun, 06 Oct 2013 00:55:18 +0800
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
Subject: [PATCH v2] mm/sparsemem: Fix a bug in free_map_bootmem when CONFIG_SPARSEMEM_VMEMMAP
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
v2: Fix a bug introduced in v1 patch. Thanks wanpeng!
---
 mm/sparse.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 4ac1d7e..fe32b48 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -604,10 +604,10 @@ static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
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
@@ -650,12 +650,15 @@ static void __kfree_section_memmap(struct page *memmap, unsigned long nr_pages)
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static void free_map_bootmem(struct page *memmap, unsigned long nr_pages)
+static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long maps_section_nr, removing_section_nr, i;
-	unsigned long magic;
+	unsigned long magic, nr_pages;
 	struct page *page = virt_to_page(memmap);
 
+	nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
+		>> PAGE_SHIFT;
+
 	for (i = 0; i < nr_pages; i++, page++) {
 		magic = (unsigned long) page->lru.next;
 
@@ -759,7 +762,6 @@ static inline void clear_hwpoisoned_pages(struct page *memmap, int nr_pages)
 static void free_section_usemap(struct page *memmap, unsigned long *usemap)
 {
 	struct page *usemap_page;
-	unsigned long nr_pages;
 
 	if (!usemap)
 		return;
@@ -780,12 +782,8 @@ static void free_section_usemap(struct page *memmap, unsigned long *usemap)
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
