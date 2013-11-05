Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3KENpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:45:51 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:2733 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab3KENpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:45:49 -0500
Subject: [PATCH 1/3] makedumpfile: hugepage filtering: add hugepage
 filtering functions
To: ptesarik@suse.cz, d.hatayama@jp.fujitsu.com,
        kumagai-atsushi@mxc.nes.nec.co.jp
From: Jingbai Ma <jingbai.ma@hp.com>
Cc: bhe@redhat.com, tom.vaden@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com,
        anderson@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com
Date: Tue, 05 Nov 2013 21:45:43 +0800
Message-ID: <20131105134542.32112.3736.stgit@k.asiapacific.hpqcorp.net>
In-Reply-To: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net>
References: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions to exclude hugepage from vmcore dump.

Signed-off-by: Jingbai Ma <jingbai.ma@hp.com>
---
 makedumpfile.c |  272 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 makedumpfile.h |   19 ++++
 2 files changed, 289 insertions(+), 2 deletions(-)

diff --git a/makedumpfile.c b/makedumpfile.c
index b42565c..f0b2531 100644
--- a/makedumpfile.c
+++ b/makedumpfile.c
@@ -46,6 +46,8 @@ unsigned long long pfn_cache_private;
 unsigned long long pfn_user;
 unsigned long long pfn_free;
 unsigned long long pfn_hwpoison;
+unsigned long long pfn_free_huge;
+unsigned long long pfn_active_huge;
 
 unsigned long long num_dumped;
 
@@ -1038,6 +1040,7 @@ get_symbol_info(void)
 	SYMBOL_INIT(mem_map, "mem_map");
 	SYMBOL_INIT(vmem_map, "vmem_map");
 	SYMBOL_INIT(mem_section, "mem_section");
+	SYMBOL_INIT(hstates, "hstates");
 	SYMBOL_INIT(pkmap_count, "pkmap_count");
 	SYMBOL_INIT_NEXT(pkmap_count_next, "pkmap_count");
 	SYMBOL_INIT(system_utsname, "system_utsname");
@@ -1174,6 +1177,19 @@ get_structure_info(void)
 	OFFSET_INIT(list_head.prev, "list_head", "prev");
 
 	/*
+	 * Get offsets of the hstate's members.
+	 */
+	SIZE_INIT(hstate, "hstate");
+	OFFSET_INIT(hstate.order, "hstate", "order");
+	OFFSET_INIT(hstate.nr_huge_pages, "hstate", "nr_huge_pages");
+	OFFSET_INIT(hstate.free_huge_pages, "hstate", "free_huge_pages");
+	OFFSET_INIT(hstate.hugepage_activelist, "hstate",
+		"hugepage_activelist");
+	OFFSET_INIT(hstate.hugepage_freelists, "hstate", "hugepage_freelists");
+	MEMBER_ARRAY_LENGTH_INIT(hstate.hugepage_freelists, "hstate",
+		"hugepage_freelists");
+
+	/*
 	 * Get offsets of the node_memblk_s's members.
 	 */
 	SIZE_INIT(node_memblk_s, "node_memblk_s");
@@ -1555,6 +1571,7 @@ write_vmcoreinfo_data(void)
 	WRITE_SYMBOL("mem_map", mem_map);
 	WRITE_SYMBOL("vmem_map", vmem_map);
 	WRITE_SYMBOL("mem_section", mem_section);
+	WRITE_SYMBOL("hstates", hstates);
 	WRITE_SYMBOL("pkmap_count", pkmap_count);
 	WRITE_SYMBOL("pkmap_count_next", pkmap_count_next);
 	WRITE_SYMBOL("system_utsname", system_utsname);
@@ -1590,6 +1607,7 @@ write_vmcoreinfo_data(void)
 	WRITE_STRUCTURE_SIZE("zone", zone);
 	WRITE_STRUCTURE_SIZE("free_area", free_area);
 	WRITE_STRUCTURE_SIZE("list_head", list_head);
+	WRITE_STRUCTURE_SIZE("hstate", hstate);
 	WRITE_STRUCTURE_SIZE("node_memblk_s", node_memblk_s);
 	WRITE_STRUCTURE_SIZE("nodemask_t", nodemask_t);
 	WRITE_STRUCTURE_SIZE("pageflags", pageflags);
@@ -1628,6 +1646,13 @@ write_vmcoreinfo_data(void)
 	WRITE_MEMBER_OFFSET("vm_struct.addr", vm_struct.addr);
 	WRITE_MEMBER_OFFSET("vmap_area.va_start", vmap_area.va_start);
 	WRITE_MEMBER_OFFSET("vmap_area.list", vmap_area.list);
+	WRITE_MEMBER_OFFSET("hstate.order", hstate.order);
+	WRITE_MEMBER_OFFSET("hstate.nr_huge_pages", hstate.nr_huge_pages);
+	WRITE_MEMBER_OFFSET("hstate.free_huge_pages", hstate.free_huge_pages);
+	WRITE_MEMBER_OFFSET("hstate.hugepage_activelist",
+		hstate.hugepage_activelist);
+	WRITE_MEMBER_OFFSET("hstate.hugepage_freelists",
+		hstate.hugepage_freelists);
 	WRITE_MEMBER_OFFSET("log.ts_nsec", log.ts_nsec);
 	WRITE_MEMBER_OFFSET("log.len", log.len);
 	WRITE_MEMBER_OFFSET("log.text_len", log.text_len);
@@ -1647,6 +1672,9 @@ write_vmcoreinfo_data(void)
 	WRITE_ARRAY_LENGTH("zone.free_area", zone.free_area);
 	WRITE_ARRAY_LENGTH("free_area.free_list", free_area.free_list);
 
+	WRITE_ARRAY_LENGTH("hstate.hugepage_freelists",
+		hstate.hugepage_freelists);
+
 	WRITE_NUMBER("NR_FREE_PAGES", NR_FREE_PAGES);
 	WRITE_NUMBER("N_ONLINE", N_ONLINE);
 
@@ -1659,6 +1687,8 @@ write_vmcoreinfo_data(void)
 
 	WRITE_NUMBER("PAGE_BUDDY_MAPCOUNT_VALUE", PAGE_BUDDY_MAPCOUNT_VALUE);
 
+	WRITE_NUMBER("HUGE_MAX_HSTATE", HUGE_MAX_HSTATE);
+
 	/*
 	 * write the source file of 1st kernel
 	 */
@@ -1874,6 +1904,7 @@ read_vmcoreinfo(void)
 	READ_SYMBOL("mem_map", mem_map);
 	READ_SYMBOL("vmem_map", vmem_map);
 	READ_SYMBOL("mem_section", mem_section);
+	READ_SYMBOL("hstates", hstates);
 	READ_SYMBOL("pkmap_count", pkmap_count);
 	READ_SYMBOL("pkmap_count_next", pkmap_count_next);
 	READ_SYMBOL("system_utsname", system_utsname);
@@ -1906,6 +1937,7 @@ read_vmcoreinfo(void)
 	READ_STRUCTURE_SIZE("zone", zone);
 	READ_STRUCTURE_SIZE("free_area", free_area);
 	READ_STRUCTURE_SIZE("list_head", list_head);
+	READ_STRUCTURE_SIZE("hstate", hstate);
 	READ_STRUCTURE_SIZE("node_memblk_s", node_memblk_s);
 	READ_STRUCTURE_SIZE("nodemask_t", nodemask_t);
 	READ_STRUCTURE_SIZE("pageflags", pageflags);
@@ -1940,6 +1972,13 @@ read_vmcoreinfo(void)
 	READ_MEMBER_OFFSET("vm_struct.addr", vm_struct.addr);
 	READ_MEMBER_OFFSET("vmap_area.va_start", vmap_area.va_start);
 	READ_MEMBER_OFFSET("vmap_area.list", vmap_area.list);
+	READ_MEMBER_OFFSET("hstate.order", hstate.order);
+	READ_MEMBER_OFFSET("hstate.nr_huge_pages", hstate.nr_huge_pages);
+	READ_MEMBER_OFFSET("hstate.free_huge_pages", hstate.free_huge_pages);
+	READ_MEMBER_OFFSET("hstate.hugepage_activelist",
+		hstate.hugepage_activelist);
+	READ_MEMBER_OFFSET("hstate.hugepage_freelists",
+		hstate.hugepage_freelists);
 	READ_MEMBER_OFFSET("log.ts_nsec", log.ts_nsec);
 	READ_MEMBER_OFFSET("log.len", log.len);
 	READ_MEMBER_OFFSET("log.text_len", log.text_len);
@@ -1950,6 +1989,8 @@ read_vmcoreinfo(void)
 	READ_ARRAY_LENGTH("node_memblk", node_memblk);
 	READ_ARRAY_LENGTH("zone.free_area", zone.free_area);
 	READ_ARRAY_LENGTH("free_area.free_list", free_area.free_list);
+	READ_ARRAY_LENGTH("hstate.hugepage_freelists",
+		hstate.hugepage_freelists);
 	READ_ARRAY_LENGTH("node_remap_start_pfn", node_remap_start_pfn);
 
 	READ_NUMBER("NR_FREE_PAGES", NR_FREE_PAGES);
@@ -1966,6 +2007,8 @@ read_vmcoreinfo(void)
 
 	READ_NUMBER("PAGE_BUDDY_MAPCOUNT_VALUE", PAGE_BUDDY_MAPCOUNT_VALUE);
 
+	READ_NUMBER("HUGE_MAX_HSTATE", HUGE_MAX_HSTATE);
+
 	return TRUE;
 }
 
@@ -4040,6 +4083,214 @@ exclude_free_page(void)
 	return TRUE;
 }
 
+inline int
+clear_huge_page(unsigned long long pfn, unsigned int order)
+{
+	unsigned int i;
+
+	DEBUG_MSG("Exclude huge page. start pfn: %lld, order: %d\n",
+		pfn, order);
+
+	for (i = 0; i < (1 << order); i++) {
+		if (!clear_bit_on_2nd_bitmap_for_kernel(pfn + i)) {
+			ERRMSG("Can't clear 2nd bitmap! pfn=0x%llx\n", pfn + i);
+			return FALSE;
+		}
+	}
+
+	return TRUE;
+}
+
+int
+_exclude_huge_page(void)
+{
+	int i, node, freelist_length;
+	unsigned long curr_hstate, curr_page, head, curr, previous, curr_prev;
+	struct timeval tv_start;
+	unsigned long long pfn;
+	unsigned int order;
+	unsigned long nr_huge_pages, free_huge_pages, active_huge_pages;
+
+	freelist_length = ARRAY_LENGTH(hstate.hugepage_freelists);
+	/* Exclude free huge pages */
+	if (info->dump_level & (DL_EXCLUDE_FREE_HUGE
+		| DL_EXCLUDE_ACTIVE_HUGE)) {
+		gettimeofday(&tv_start, NULL);
+		for (i = 0; i < NUMBER(HUGE_MAX_HSTATE); i++) {
+			curr_hstate = SYMBOL(hstates) + SIZE(hstate) * i;
+			/* Read order */
+			if (!readmem(VADDR,
+				curr_hstate + OFFSET(hstate.order),
+				&order, sizeof(order))) {
+				ERRMSG("Can't get hstate.order!");
+					return FALSE;
+			}
+			/* Read free_huge_pages */
+			if (!readmem(VADDR,
+				curr_hstate + OFFSET(hstate.free_huge_pages),
+				&free_huge_pages, sizeof(free_huge_pages))) {
+				ERRMSG("Can't get hstate.free_huge_pages!");
+					return FALSE;
+			}
+			for (node = 0; node < freelist_length; node++) {
+				/* head = hstate.hugepage_freelists[node] */
+				head = curr_hstate
+					+ OFFSET(hstate.hugepage_freelists)
+					+ SIZE(list_head) * node;
+				if (!readmem(VADDR,
+					head + OFFSET(list_head.next),
+					&curr, sizeof(curr))) {
+					ERRMSG("Can't get free list!");
+						return FALSE;
+				}
+				curr_prev = head;
+				/* Walking free list of the node */
+				while (head != curr && curr != 0) {
+					print_progress(PROGRESS_FREE_HUGE,
+						pfn_free_huge, free_huge_pages);
+					if (!readmem(VADDR,
+						curr + OFFSET(list_head.prev),
+						&previous, sizeof(previous))) {
+						ERRMSG("Can't get free list!");
+						return FALSE;
+					}
+					if (previous != curr_prev) {
+						ERRMSG("Free list is broken!");
+						return FALSE;
+					}
+					curr_page = curr - OFFSET(page.lru);
+					pfn = page_to_pfn(curr_page);
+					if (!clear_huge_page(pfn, order))
+						return FALSE;
+					pfn_free_huge++;
+					curr_prev = curr;
+					if (!readmem(VADDR,
+						curr + OFFSET(list_head.next),
+						&curr, sizeof(curr))) {
+						ERRMSG("Can't get free list!");
+						return FALSE;
+					}
+				}
+			}
+		}
+		/*
+		 * print [100 %]
+		 */
+		print_progress(PROGRESS_FREE_HUGE, 1, 1);
+		print_execution_time(PROGRESS_FREE_HUGE, &tv_start);
+	}
+
+	/* Exclude active huge pages */
+	if (info->dump_level & DL_EXCLUDE_ACTIVE_HUGE) {
+		gettimeofday(&tv_start, NULL);
+		for (i = 0; i < NUMBER(HUGE_MAX_HSTATE); i++) {
+			curr_hstate = SYMBOL(hstates) + SIZE(hstate) * i;
+			/* Read order */
+			if (!readmem(VADDR,
+				curr_hstate + OFFSET(hstate.order),
+				&order, sizeof(order))) {
+				ERRMSG("Can't get hstate.order!");
+					return FALSE;
+			}
+			/* Read nr_huge_pages */
+			if (!readmem(VADDR,
+				curr_hstate + OFFSET(hstate.nr_huge_pages),
+				&nr_huge_pages, sizeof(nr_huge_pages))) {
+				ERRMSG("Can't get hstate.nr_huge_pages!");
+					return FALSE;
+			}
+			/* Read free_huge_pages */
+			if (!readmem(VADDR,
+				curr_hstate + OFFSET(hstate.free_huge_pages),
+				&free_huge_pages, sizeof(free_huge_pages))) {
+				ERRMSG("Can't get hstate.free_huge_pages!");
+					return FALSE;
+			}
+			if (nr_huge_pages < free_huge_pages) {
+				ERRMSG("nr_huge_pages < free_huge_pages!");
+					return FALSE;
+			}
+			active_huge_pages = nr_huge_pages - free_huge_pages;
+			/* head = hstate.hugepage_freelists[node] */
+			head = curr_hstate + OFFSET(hstate.hugepage_activelist);
+			if (!readmem(VADDR, head + OFFSET(list_head.next),
+				&curr, sizeof(curr))) {
+				ERRMSG("Can't get active list!");
+			}
+			curr_prev = head;
+			/* Walking active list */
+			while (head != curr && curr != 0) {
+				print_progress(PROGRESS_ACTIVE_HUGE,
+					pfn_active_huge,
+					active_huge_pages);
+				if (!readmem(VADDR,
+					curr + OFFSET(list_head.prev),
+					&previous, sizeof(previous))) {
+					ERRMSG("Can't get active list!");
+					return FALSE;
+				}
+				if (previous != curr_prev) {
+					ERRMSG("Active list is broken!");
+					return FALSE;
+				}
+				curr_page = curr - OFFSET(page.lru);
+				pfn = page_to_pfn(curr_page);
+				if (!clear_huge_page(pfn, order))
+					return FALSE;
+				pfn_active_huge++;
+				curr_prev = curr;
+				if (!readmem(VADDR,
+					curr + OFFSET(list_head.next),
+					&curr, sizeof(curr))) {
+					ERRMSG("Can't get active list!");
+					return FALSE;
+				}
+			}
+		}
+		/*
+		 * print [100 %]
+		 */
+		print_progress(PROGRESS_ACTIVE_HUGE, 1, 1);
+		print_execution_time(PROGRESS_ACTIVE_HUGE, &tv_start);
+	}
+
+	DEBUG_MSG("\n");
+	DEBUG_MSG("free huge pages  : %lld\n", pfn_free_huge);
+	DEBUG_MSG("active huge pages: %lld\n", pfn_active_huge);
+
+	return TRUE;
+}
+
+int
+exclude_huge_page(void)
+{
+	/*
+	 * Check having necessary information.
+	 */
+	if (SYMBOL(hstates) == NOT_FOUND_SYMBOL)
+		ERRMSG("Can't get necessary symbols for huge pages.\n");
+
+	if ((SIZE(hstate) == NOT_FOUND_STRUCTURE)
+	    || (OFFSET(hstate.order) == NOT_FOUND_STRUCTURE)
+	    || (OFFSET(hstate.nr_huge_pages) == NOT_FOUND_STRUCTURE)
+	    || (OFFSET(hstate.free_huge_pages) == NOT_FOUND_STRUCTURE)
+	    || (OFFSET(hstate.hugepage_activelist) == NOT_FOUND_STRUCTURE)
+	    || (OFFSET(hstate.hugepage_freelists) == NOT_FOUND_STRUCTURE)
+	    || (ARRAY_LENGTH(hstate.hugepage_freelists)
+		== NOT_FOUND_STRUCTURE)) {
+		ERRMSG("Can't get necessary structures for huge pages.\n");
+		return FALSE;
+	}
+
+	/*
+	 * Detect huge pages and update 2nd-bitmap.
+	 */
+	if (!_exclude_huge_page())
+		return FALSE;
+
+	return TRUE;
+}
+
 /*
  * Let C be a cyclic buffer size and B a bitmap size used for
  * representing maximum block size managed by buddy allocator.
@@ -4532,6 +4783,13 @@ exclude_unnecessary_pages_cyclic(void)
 			return FALSE;
 
 	/*
+	 * Exclude huge pages.
+	 */
+	if (info->dump_level & (DL_EXCLUDE_FREE_HUGE | DL_EXCLUDE_ACTIVE_HUGE))
+		if (!exclude_huge_page())
+			return FALSE;
+
+	/*
 	 * Exclude cache pages, cache private pages, user data pages,
 	 * free pages and hwpoison pages.
 	 */
@@ -4661,6 +4919,13 @@ create_2nd_bitmap(void)
 			return FALSE;
 
 	/*
+	 * Exclude huge pages.
+	 */
+	if (info->dump_level & (DL_EXCLUDE_FREE_HUGE | DL_EXCLUDE_ACTIVE_HUGE))
+		if (!exclude_huge_page())
+			return FALSE;
+
+	/*
 	 * Exclude Xen user domain.
 	 */
 	if (info->flag_exclude_xen_dom) {
@@ -6513,6 +6778,7 @@ write_kdump_pages_and_bitmap_cyclic(struct cache_data *cd_header, struct cache_d
 	 */
 	pfn_zero = pfn_cache = pfn_cache_private = 0;
 	pfn_user = pfn_free = pfn_hwpoison = 0;
+	pfn_free_huge = pfn_active_huge = 0;
 	pfn_memhole = info->max_mapnr;
 
 	cd_header->offset
@@ -7416,7 +7682,8 @@ print_report(void)
 	pfn_original = info->max_mapnr - pfn_memhole;
 
 	pfn_excluded = pfn_zero + pfn_cache + pfn_cache_private
-	    + pfn_user + pfn_free + pfn_hwpoison;
+	    + pfn_user + pfn_free + pfn_hwpoison
+	    + pfn_free_huge + pfn_active_huge;
 	shrinking = (pfn_original - pfn_excluded) * 100;
 	shrinking = shrinking / pfn_original;
 
@@ -7429,6 +7696,9 @@ print_report(void)
 	    pfn_cache_private);
 	REPORT_MSG("    User process data pages : 0x%016llx\n", pfn_user);
 	REPORT_MSG("    Free pages              : 0x%016llx\n", pfn_free);
+	REPORT_MSG("    Free hugepage pages     : 0x%016llx\n", pfn_free_huge);
+	REPORT_MSG("    Active hugepage pages   : 0x%016llx\n",
+		pfn_active_huge);
 	REPORT_MSG("    Hwpoison pages          : 0x%016llx\n", pfn_hwpoison);
 	REPORT_MSG("  Remaining pages  : 0x%016llx\n",
 	    pfn_original - pfn_excluded);
diff --git a/makedumpfile.h b/makedumpfile.h
index a5826e0..1a0a5fa 100644
--- a/makedumpfile.h
+++ b/makedumpfile.h
@@ -178,7 +178,7 @@ isAnon(unsigned long mapping)
  * Dump Level
  */
 #define MIN_DUMP_LEVEL		(0)
-#define MAX_DUMP_LEVEL		(31)
+#define MAX_DUMP_LEVEL		(127)
 #define NUM_ARRAY_DUMP_LEVEL	(MAX_DUMP_LEVEL + 1) /* enough to allocate
 							all the dump_level */
 #define DL_EXCLUDE_ZERO		(0x001) /* Exclude Pages filled with Zeros */
@@ -189,6 +189,9 @@ isAnon(unsigned long mapping)
 #define DL_EXCLUDE_USER_DATA	(0x008) /* Exclude UserProcessData Pages */
 #define DL_EXCLUDE_FREE		(0x010)	/* Exclude Free Pages */
 
+#define DL_EXCLUDE_FREE_HUGE	(0x020) /* Exclude Free Huge Pages */
+#define DL_EXCLUDE_ACTIVE_HUGE	(0x040) /* Exclude Active Huge Pages */
+
 
 /*
  * For parse_line()
@@ -1098,6 +1101,7 @@ struct symbol_table {
 	unsigned long long	mem_map;
 	unsigned long long	vmem_map;
 	unsigned long long	mem_section;
+	unsigned long long	hstates;
 	unsigned long long	pkmap_count;
 	unsigned long long	pkmap_count_next;
 	unsigned long long	system_utsname;
@@ -1174,6 +1178,7 @@ struct size_table {
 	long	zone;
 	long	free_area;
 	long	list_head;
+	long	hstate;
 	long	node_memblk_s;
 	long	nodemask_t;
 
@@ -1232,6 +1237,13 @@ struct offset_table {
 	struct free_area {
 		long	free_list;
 	} free_area;
+	struct hstate {
+		long	order;
+		long	nr_huge_pages;
+		long	free_huge_pages;
+		long	hugepage_activelist;
+		long	hugepage_freelists;
+	} hstate;
 	struct list_head {
 		long	next;
 		long	prev;
@@ -1368,6 +1380,9 @@ struct array_table {
 	struct free_area_at {
 		long	free_list;
 	} free_area;
+	struct hstate_at {
+		long	hugepage_freelists;
+	} hstate;
 	struct kimage_at {
 		long	segment;
 	} kimage;
@@ -1388,6 +1403,8 @@ struct number_table {
 	long    PG_hwpoison;
 
 	long	PAGE_BUDDY_MAPCOUNT_VALUE;
+
+	long	HUGE_MAX_HSTATE;
 };
 
 struct srcfile_table {

