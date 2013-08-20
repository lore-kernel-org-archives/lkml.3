Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab3HTGzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:55:25 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:42594 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3HTGzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:55:18 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 2/4] mm/sparse: introduce alloc_usemap_and_memmap
Date: Tue, 20 Aug 2013 14:54:54 +0800
Message-Id: <1376981696-4312-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082006-5816-0000-0000-0000097E8E44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 -> v2:
 * add comments to describe alloc_usemap_and_memmap 

After commit 9bdac91424075("sparsemem: Put mem map for one node together."),
vmemmap for one node will be allocated together, its logic is similar as
memory allocation for pageblock flags. This patch introduce alloc_usemap_and_memmap
to extract the same logic of memory alloction for pageblock flags and vmemmap.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/sparse.c | 140 ++++++++++++++++++++++++++++--------------------------------
 1 file changed, 66 insertions(+), 74 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 308d503..d27db9b 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -439,6 +439,14 @@ static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
 					 map_count, nodeid);
 }
 #else
+
+static void __init sparse_early_mem_maps_alloc_node(struct page **map_map,
+				unsigned long pnum_begin,
+				unsigned long pnum_end,
+				unsigned long map_count, int nodeid)
+{
+}
+
 static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
@@ -460,6 +468,62 @@ void __attribute__((weak)) __meminit vmemmap_populate_print_last(void)
 {
 }
 
+/**
+ *  alloc_usemap_and_memmap - memory alloction for pageblock flags and vmemmap
+ *  @map: usemap_map for pageblock flags or mmap_map for vmemmap
+ *  @use_map: true if memory allocated for pageblock flags, otherwise false
+ */
+static void alloc_usemap_and_memmap(unsigned long **map, bool use_map)
+{
+	unsigned long pnum;
+	unsigned long map_count;
+	int nodeid_begin = 0;
+	unsigned long pnum_begin = 0;
+
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+
+		if (!present_section_nr(pnum))
+			continue;
+		ms = __nr_to_section(pnum);
+		nodeid_begin = sparse_early_nid(ms);
+		pnum_begin = pnum;
+		break;
+	}
+	map_count = 1;
+	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
+		struct mem_section *ms;
+		int nodeid;
+
+		if (!present_section_nr(pnum))
+			continue;
+		ms = __nr_to_section(pnum);
+		nodeid = sparse_early_nid(ms);
+		if (nodeid == nodeid_begin) {
+			map_count++;
+			continue;
+		}
+		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
+		if (use_map)
+			sparse_early_usemaps_alloc_node(map, pnum_begin, pnum,
+						 map_count, nodeid_begin);
+		else
+			sparse_early_mem_maps_alloc_node((struct page **)map,
+				pnum_begin, pnum, map_count, nodeid_begin);
+		/* new start, update count etc*/
+		nodeid_begin = nodeid;
+		pnum_begin = pnum;
+		map_count = 1;
+	}
+	/* ok, last chunk */
+	if (use_map)
+		sparse_early_usemaps_alloc_node(map, pnum_begin,
+				NR_MEM_SECTIONS, map_count, nodeid_begin);
+	else
+		sparse_early_mem_maps_alloc_node((struct page **)map,
+			pnum_begin, NR_MEM_SECTIONS, map_count, nodeid_begin);
+}
+
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -471,11 +535,7 @@ void __init sparse_init(void)
 	unsigned long *usemap;
 	unsigned long **usemap_map;
 	int size;
-	int nodeid_begin = 0;
-	unsigned long pnum_begin = 0;
-	unsigned long usemap_count;
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
-	unsigned long map_count;
 	int size2;
 	struct page **map_map;
 #endif
@@ -501,82 +561,14 @@ void __init sparse_init(void)
 	usemap_map = alloc_bootmem(size);
 	if (!usemap_map)
 		panic("can not allocate usemap_map\n");
-
-	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		struct mem_section *ms;
-
-		if (!present_section_nr(pnum))
-			continue;
-		ms = __nr_to_section(pnum);
-		nodeid_begin = sparse_early_nid(ms);
-		pnum_begin = pnum;
-		break;
-	}
-	usemap_count = 1;
-	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
-		struct mem_section *ms;
-		int nodeid;
-
-		if (!present_section_nr(pnum))
-			continue;
-		ms = __nr_to_section(pnum);
-		nodeid = sparse_early_nid(ms);
-		if (nodeid == nodeid_begin) {
-			usemap_count++;
-			continue;
-		}
-		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
-		sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, pnum,
-						 usemap_count, nodeid_begin);
-		/* new start, update count etc*/
-		nodeid_begin = nodeid;
-		pnum_begin = pnum;
-		usemap_count = 1;
-	}
-	/* ok, last chunk */
-	sparse_early_usemaps_alloc_node(usemap_map, pnum_begin, NR_MEM_SECTIONS,
-					 usemap_count, nodeid_begin);
+	alloc_usemap_and_memmap(usemap_map, true);
 
 #ifdef CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER
 	size2 = sizeof(struct page *) * NR_MEM_SECTIONS;
 	map_map = alloc_bootmem(size2);
 	if (!map_map)
 		panic("can not allocate map_map\n");
-
-	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		struct mem_section *ms;
-
-		if (!present_section_nr(pnum))
-			continue;
-		ms = __nr_to_section(pnum);
-		nodeid_begin = sparse_early_nid(ms);
-		pnum_begin = pnum;
-		break;
-	}
-	map_count = 1;
-	for (pnum = pnum_begin + 1; pnum < NR_MEM_SECTIONS; pnum++) {
-		struct mem_section *ms;
-		int nodeid;
-
-		if (!present_section_nr(pnum))
-			continue;
-		ms = __nr_to_section(pnum);
-		nodeid = sparse_early_nid(ms);
-		if (nodeid == nodeid_begin) {
-			map_count++;
-			continue;
-		}
-		/* ok, we need to take cake of from pnum_begin to pnum - 1*/
-		sparse_early_mem_maps_alloc_node(map_map, pnum_begin, pnum,
-						 map_count, nodeid_begin);
-		/* new start, update count etc*/
-		nodeid_begin = nodeid;
-		pnum_begin = pnum;
-		map_count = 1;
-	}
-	/* ok, last chunk */
-	sparse_early_mem_maps_alloc_node(map_map, pnum_begin, NR_MEM_SECTIONS,
-					 map_count, nodeid_begin);
+	alloc_usemap_and_memmap((unsigned long **)map_map, false);
 #endif
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-- 
1.8.1.2

