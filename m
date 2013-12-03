Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3LCCb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:31:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53709 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LCC3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:29:31 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 15/23] mm/sparse: Use memblock apis for early memory allocations
Date: Mon, 2 Dec 2013 21:27:30 -0500
Message-ID: <1386037658-3161-16-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to memblock interfaces for early memory allocator instead of
bootmem allocator. No functional change in beahvior than what it is
in current code from bootmem users points of view.

Archs already converted to NO_BOOTMEM now directly use memblock
interfaces instead of bootmem wrappers build on top of memblock. And the
archs which still uses bootmem, these new apis just fallback to exiting
bootmem APIs.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 mm/sparse-vmemmap.c |    6 ++++--
 mm/sparse.c         |   27 +++++++++++++++------------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 27eeab3..4cba9c2 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -40,7 +40,8 @@ static void * __init_refok __earlyonly_bootmem_alloc(int node,
 				unsigned long align,
 				unsigned long goal)
 {
-	return __alloc_bootmem_node_high(NODE_DATA(node), size, align, goal);
+	return memblock_virt_alloc_try_nid(size, align, goal,
+					    BOOTMEM_ALLOC_ACCESSIBLE, node);
 }
 
 static void *vmemmap_buf;
@@ -226,7 +227,8 @@ void __init sparse_mem_maps_populate_node(struct page **map_map,
 
 	if (vmemmap_buf_start) {
 		/* need to free left buf */
-		free_bootmem(__pa(vmemmap_buf), vmemmap_buf_end - vmemmap_buf);
+		memblock_free_early(__pa(vmemmap_buf),
+				    vmemmap_buf_end - vmemmap_buf);
 		vmemmap_buf = NULL;
 		vmemmap_buf_end = NULL;
 	}
diff --git a/mm/sparse.c b/mm/sparse.c
index 8cc7be0..02f57cc 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -69,7 +69,7 @@ static struct mem_section noinline __init_refok *sparse_index_alloc(int nid)
 		else
 			section = kzalloc(array_size, GFP_KERNEL);
 	} else {
-		section = alloc_bootmem_node(NODE_DATA(nid), array_size);
+		section = memblock_virt_alloc_node(array_size, nid);
 	}
 
 	return section;
@@ -279,8 +279,9 @@ sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
 	limit = goal + (1UL << PA_SECTION_SHIFT);
 	nid = early_pfn_to_nid(goal >> PAGE_SHIFT);
 again:
-	p = ___alloc_bootmem_node_nopanic(NODE_DATA(nid), size,
-					  SMP_CACHE_BYTES, goal, limit);
+	p = memblock_virt_alloc_try_nid_nopanic(size,
+						SMP_CACHE_BYTES, goal, limit,
+						nid);
 	if (!p && limit) {
 		limit = 0;
 		goto again;
@@ -331,7 +332,7 @@ static unsigned long * __init
 sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
 					 unsigned long size)
 {
-	return alloc_bootmem_node_nopanic(pgdat, size);
+	return memblock_virt_alloc_node_nopanic(size, pgdat->node_id);
 }
 
 static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
@@ -376,8 +377,9 @@ struct page __init *sparse_mem_map_populate(unsigned long pnum, int nid)
 		return map;
 
 	size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
-	map = __alloc_bootmem_node_high(NODE_DATA(nid), size,
-					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	map = memblock_virt_alloc_try_nid(size,
+					  PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
+					  BOOTMEM_ALLOC_ACCESSIBLE, nid);
 	return map;
 }
 void __init sparse_mem_maps_populate_node(struct page **map_map,
@@ -401,8 +403,9 @@ void __init sparse_mem_maps_populate_node(struct page **map_map,
 	}
 
 	size = PAGE_ALIGN(size);
-	map = __alloc_bootmem_node_high(NODE_DATA(nodeid), size * map_count,
-					 PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	map = memblock_virt_alloc_try_nid(size * map_count,
+					  PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
+					  BOOTMEM_ALLOC_ACCESSIBLE, nodeid);
 	if (map) {
 		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
 			if (!present_section_nr(pnum))
@@ -545,7 +548,7 @@ void __init sparse_init(void)
 	 * sparse_early_mem_map_alloc, so allocate usemap_map at first.
 	 */
 	size = sizeof(unsigned long *) * NR_MEM_SECTIONS;
-	usemap_map = alloc_bootmem(size);
+	usemap_map = memblock_virt_alloc(size);
 	if (!usemap_map)
 		panic("can not allocate usemap_map\n");
 	alloc_usemap_and_memmap(sparse_early_usemaps_alloc_node,
@@ -553,7 +556,7 @@ void __init sparse_init(void)
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 	size2 = sizeof(struct page *) * NR_MEM_SECTIONS;
-	map_map = alloc_bootmem(size2);
+	map_map = memblock_virt_alloc(size2);
 	if (!map_map)
 		panic("can not allocate map_map\n");
 	alloc_usemap_and_memmap(sparse_early_mem_maps_alloc_node,
@@ -583,9 +586,9 @@ void __init sparse_init(void)
 	vmemmap_populate_print_last();
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
-	free_bootmem(__pa(map_map), size2);
+	memblock_free_early(__pa(map_map), size2);
 #endif
-	free_bootmem(__pa(usemap_map), size);
+	memblock_free_early(__pa(usemap_map), size);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-- 
1.7.9.5

