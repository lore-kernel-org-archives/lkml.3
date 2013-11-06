Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab3KFCcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 21:32:13 -0500
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:46274 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3KFCcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 21:32:12 -0500
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: "vgoyal@redhat.com" <vgoyal@redhat.com>
CC: "jingbai.ma@hp.com" <jingbai.ma@hp.com>, "bhe@redhat.com" <bhe@redhat.com>,
        "tom.vaden@hp.com" <tom.vaden@hp.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ptesarik@suse.cz" <ptesarik@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lisa.mitchell@hp.com" <lisa.mitchell@hp.com>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "anderson@redhat.com" <anderson@redhat.com>
Subject: Re: [PATCH 0/3] makedumpfile: hugepage filtering for vmcore dump
Thread-Topic: [PATCH 0/3] makedumpfile: hugepage filtering for vmcore dump
Thread-Index: Ac7aluz8xTFfSsYQRCSuusZ9e9zm3A==
Date: Wed, 6 Nov 2013 02:21:39 +0000
Message-ID: <0910DD04CBD6DE4193FCF86B9C00BE971BB7A9@BPXM01GP.gisp.nec.co.jp>
References: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net>
 <20131105202631.GC4598@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.40.240]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/06 5:27), Vivek Goyal wrote:
> On Tue, Nov 05, 2013 at 09:45:32PM +0800, Jingbai Ma wrote:
>> This patch set intend to exclude unnecessary hugepages from vmcore dump file.
>>
>> This patch requires the kernel patch to export necessary data structures into
>> vmcore: "kexec: export hugepage data structure into vmcoreinfo"
>> http://lists.infradead.org/pipermail/kexec/2013-November/009997.html
>>
>> This patch introduce two new dump levels 32 and 64 to exclude all unused and
>> active hugepages. The level to exclude all unnecessary pages will be 127 now.
>
> Interesting. Why hugepages should be treated any differentely than normal
> pages?
>
> If user asked to filter out free page, then it should be filtered and
> it should not matter whether it is a huge page or not?

I'm making a RFC patch of hugepages filtering based on such policy.

I attach the prototype version.
It's able to filter out also THPs, and suitable for cyclic processing
because it depends on mem_map and looking up it can be divided into
cycles. This is the same idea as page_is_buddy().

So I think it's better.

-- 
Thanks
Atsushi Kumagai


From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Date: Wed, 6 Nov 2013 10:10:43 +0900
Subject: [PATCH] [RFC] Exclude hugepages.

Signed-off-by: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
---
   makedumpfile.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
   makedumpfile.h |   8 ++++
   2 files changed, 125 insertions(+), 5 deletions(-)

diff --git a/makedumpfile.c b/makedumpfile.c
index 428c53e..75b7123 100644
--- a/makedumpfile.c
+++ b/makedumpfile.c
@@ -63,6 +63,7 @@ do { \
   
   static void check_cyclic_buffer_overrun(void);
   static void setup_page_is_buddy(void);
+static void setup_page_is_hugepage(void);
   
   void
   initialize_tables(void)
@@ -270,6 +271,18 @@ update_mmap_range(off_t offset, int initial) {
   }
   
   static int
+page_is_hugepage(unsigned long flags) {
+	if (NUMBER(PG_head) != NOT_FOUND_NUMBER) {
+		return isHead(flags);
+	} else if (NUMBER(PG_tail) != NOT_FOUND_NUMBER) {
+		return isTail(flags);
+	}if (NUMBER(PG_compound) != NOT_FOUND_NUMBER) {
+		return isCompound(flags);
+	}
+	return 0;
+}
+
+static int
   is_mapped_with_mmap(off_t offset) {
   
   	if (info->flag_usemmap
@@ -1107,6 +1120,8 @@ get_symbol_info(void)
   		SYMBOL_ARRAY_LENGTH_INIT(node_remap_start_pfn,
   					"node_remap_start_pfn");
   
+	SYMBOL_INIT(free_huge_page, "free_huge_page");
+
   	return TRUE;
   }
   
@@ -1214,11 +1229,19 @@ get_structure_info(void)
   
   	ENUM_NUMBER_INIT(PG_lru, "PG_lru");
   	ENUM_NUMBER_INIT(PG_private, "PG_private");
+	ENUM_NUMBER_INIT(PG_head, "PG_head");
+	ENUM_NUMBER_INIT(PG_tail, "PG_tail");
+	ENUM_NUMBER_INIT(PG_compound, "PG_compound");
   	ENUM_NUMBER_INIT(PG_swapcache, "PG_swapcache");
   	ENUM_NUMBER_INIT(PG_buddy, "PG_buddy");
   	ENUM_NUMBER_INIT(PG_slab, "PG_slab");
   	ENUM_NUMBER_INIT(PG_hwpoison, "PG_hwpoison");
   
+	if (NUMBER(PG_head) == NOT_FOUND_NUMBER &&
+	    NUMBER(PG_compound) == NOT_FOUND_NUMBER)
+		/* Pre-2.6.26 kernels did not have pageflags */
+		NUMBER(PG_compound) = PG_compound_ORIGINAL;
+
   	ENUM_TYPE_SIZE_INIT(pageflags, "pageflags");
   
   	TYPEDEF_SIZE_INIT(nodemask_t, "nodemask_t");
@@ -1603,6 +1626,7 @@ write_vmcoreinfo_data(void)
   	WRITE_SYMBOL("node_remap_start_vaddr", node_remap_start_vaddr);
   	WRITE_SYMBOL("node_remap_end_vaddr", node_remap_end_vaddr);
   	WRITE_SYMBOL("node_remap_start_pfn", node_remap_start_pfn);
+	WRITE_SYMBOL("free_huge_page", free_huge_page);
   
   	/*
   	 * write the structure size of 1st kernel
@@ -1685,6 +1709,9 @@ write_vmcoreinfo_data(void)
   
   	WRITE_NUMBER("PG_lru", PG_lru);
   	WRITE_NUMBER("PG_private", PG_private);
+	WRITE_NUMBER("PG_head", PG_head);
+	WRITE_NUMBER("PG_tail", PG_tail);
+	WRITE_NUMBER("PG_compound", PG_compound);
   	WRITE_NUMBER("PG_swapcache", PG_swapcache);
   	WRITE_NUMBER("PG_buddy", PG_buddy);
   	WRITE_NUMBER("PG_slab", PG_slab);
@@ -1932,6 +1959,7 @@ read_vmcoreinfo(void)
   	READ_SYMBOL("node_remap_start_vaddr", node_remap_start_vaddr);
   	READ_SYMBOL("node_remap_end_vaddr", node_remap_end_vaddr);
   	READ_SYMBOL("node_remap_start_pfn", node_remap_start_pfn);
+	READ_SYMBOL("free_huge_page", free_huge_page);
   
   	READ_STRUCTURE_SIZE("page", page);
   	READ_STRUCTURE_SIZE("mem_section", mem_section);
@@ -2000,6 +2028,9 @@ read_vmcoreinfo(void)
   
   	READ_NUMBER("PG_lru", PG_lru);
   	READ_NUMBER("PG_private", PG_private);
+	READ_NUMBER("PG_head", PG_head);
+	READ_NUMBER("PG_tail", PG_tail);
+	READ_NUMBER("PG_compound", PG_compound);
   	READ_NUMBER("PG_swapcache", PG_swapcache);
   	READ_NUMBER("PG_slab", PG_slab);
   	READ_NUMBER("PG_buddy", PG_buddy);
@@ -3126,6 +3157,9 @@ out:
   	if (!get_value_for_old_linux())
   		return FALSE;
   
+	/* Get page flags for compound pages */
+	setup_page_is_hugepage();
+
   	/* use buddy identification of free pages whether cyclic or not */
   	/* (this can reduce pages scan of 1TB memory from 60sec to 30sec) */
   	if (info->dump_level & DL_EXCLUDE_FREE)
@@ -4197,6 +4231,23 @@ out:
   			  "follow free lists instead of mem_map array.\n");
   }
   
+static void
+setup_page_is_hugepage(void)
+{
+	if (NUMBER(PG_head) != NOT_FOUND_NUMBER) {
+		if (NUMBER(PG_tail) == NOT_FOUND_NUMBER) {
+			/* If PG_tail is not explicitly saved, then assume
+			 * that it immediately follows PG_head.
+			 */
+			NUMBER(PG_tail) = NUMBER(PG_head) + 1;
+		}
+	} else if ((NUMBER(PG_compound) != NOT_FOUND_NUMBER)
+		   && (info->dump_level & DL_EXCLUDE_USER_DATA)) {
+		MSG("Compound page bit could not be determined: ");
+		MSG("huge pages will NOT be filtered.\n");
+	}
+}
+
   /*
    * If using a dumpfile in kdump-compressed format as a source file
    * instead of /proc/vmcore, 1st-bitmap of a new dumpfile must be
@@ -4404,8 +4455,9 @@ __exclude_unnecessary_pages(unsigned long mem_map,
   	unsigned long long pfn_read_start, pfn_read_end, index_pg;
   	unsigned char page_cache[SIZE(page) * PGMM_CACHED];
   	unsigned char *pcache;
-	unsigned int _count, _mapcount = 0;
+	unsigned int _count, _mapcount = 0, compound_order = 0;
   	unsigned long flags, mapping, private = 0;
+	unsigned long hugetlb_dtor;
   
   	/*
   	 * Refresh the buffer of struct page, when changing mem_map.
@@ -4459,6 +4511,27 @@ __exclude_unnecessary_pages(unsigned long mem_map,
   		flags   = ULONG(pcache + OFFSET(page.flags));
   		_count  = UINT(pcache + OFFSET(page._count));
   		mapping = ULONG(pcache + OFFSET(page.mapping));
+
+		if (index_pg < PGMM_CACHED - 1) {
+			compound_order = ULONG(pcache + SIZE(page) + OFFSET(page.lru)
+					       + OFFSET(list_head.prev));
+			hugetlb_dtor = ULONG(pcache + SIZE(page) + OFFSET(page.lru)
+					     + OFFSET(list_head.next));
+		} else if (pfn + 1 < pfn_end) {
+			unsigned char page_cache_next[SIZE(page)];
+			if (!readmem(VADDR, mem_map, page_cache_next, SIZE(page))) {
+				ERRMSG("Can't read the buffer of struct page.\n");
+				return FALSE;
+			}
+			compound_order = ULONG(page_cache_next + OFFSET(page.lru)
+					       + OFFSET(list_head.prev));
+			hugetlb_dtor = ULONG(page_cache_next + OFFSET(page.lru)
+					     + OFFSET(list_head.next));
+		} else {
+			compound_order = 0;
+			hugetlb_dtor = 0;
+		}
+
   		if (OFFSET(page._mapcount) != NOT_FOUND_STRUCTURE)
   			_mapcount = UINT(pcache + OFFSET(page._mapcount));
   		if (OFFSET(page.private) != NOT_FOUND_STRUCTURE)
@@ -4497,6 +4570,10 @@ __exclude_unnecessary_pages(unsigned long mem_map,
   		    && !isPrivate(flags) && !isAnon(mapping)) {
   			if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
   				pfn_cache++;
+			/*
+			 * NOTE: If THP for cache is introduced, the check for
+			 *       compound pages is needed here.
+			 */
   		}
   		/*
   		 * Exclude the cache page with the private page.
@@ -4506,14 +4583,49 @@ __exclude_unnecessary_pages(unsigned long mem_map,
   		    && !isAnon(mapping)) {
   			if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
   				pfn_cache_private++;
+			/*
+			 * NOTE: If THP for cache is introduced, the check for
+			 *       compound pages is needed here.
+			 */
   		}
   		/*
   		 * Exclude the data page of the user process.
   		 */
-		else if ((info->dump_level & DL_EXCLUDE_USER_DATA)
-		    && isAnon(mapping)) {
-			if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
-				pfn_user++;
+		else if (info->dump_level & DL_EXCLUDE_USER_DATA) {
+			/*
+			 * Exclude the anonnymous pages as user pages.
+			 */
+			if (isAnon(mapping)) {
+				if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
+					pfn_user++;
+
+				/*
+				 * Check the compound page
+				 */
+				if (page_is_hugepage(flags) && compound_order > 0) {
+					int i, nr_pages = 1 << compound_order;
+
+					for (i = 1; i < nr_pages; ++i) {
+						if (clear_bit_on_2nd_bitmap_for_kernel(pfn + i))
+							pfn_user++;
+					}
+					pfn += nr_pages - 2;
+					mem_map += (nr_pages - 1) * SIZE(page);
+				}
+			}
+			/*
+			 * Exclude the hugetlbfs pages as user pages.
+			 */
+			else if (hugetlb_dtor == SYMBOL(free_huge_page)) {
+				int i, nr_pages = 1 << compound_order;
+
+				for (i = 0; i < nr_pages; ++i) {
+					if (clear_bit_on_2nd_bitmap_for_kernel(pfn + i))
+						pfn_user++;
+				}
+				pfn += nr_pages - 1;
+				mem_map += (nr_pages - 1) * SIZE(page);
+			}
   		}
   		/*
   		 * Exclude the hwpoison page.
diff --git a/makedumpfile.h b/makedumpfile.h
index 3a7e61a..d6ee832 100644
--- a/makedumpfile.h
+++ b/makedumpfile.h
@@ -74,6 +74,7 @@ int get_mem_type(void);
   #define PG_lru_ORIGINAL	 	(5)
   #define PG_slab_ORIGINAL	(7)
   #define PG_private_ORIGINAL	(11)	/* Has something at ->private */
+#define PG_compound_ORIGINAL	(14)	/* Is part of a compound page */
   #define PG_swapcache_ORIGINAL	(15)	/* Swap page: swp_entry_t in private */
   
   #define PAGE_BUDDY_MAPCOUNT_VALUE_v2_6_38	(-2)
@@ -140,6 +141,9 @@ test_bit(int nr, unsigned long addr)
   
   #define isLRU(flags)		test_bit(NUMBER(PG_lru), flags)
   #define isPrivate(flags)	test_bit(NUMBER(PG_private), flags)
+#define isHead(flags)		test_bit(NUMBER(PG_head), flags)
+#define isTail(flags)		test_bit(NUMBER(PG_tail), flags)
+#define isCompound(flags)	test_bit(NUMBER(PG_compound), flags)
   #define isSwapCache(flags)	test_bit(NUMBER(PG_swapcache), flags)
   #define isHWPOISON(flags)	(test_bit(NUMBER(PG_hwpoison), flags) \
   				&& (NUMBER(PG_hwpoison) != NOT_FOUND_NUMBER))
@@ -1124,6 +1128,7 @@ struct symbol_table {
   	unsigned long long	node_remap_start_vaddr;
   	unsigned long long	node_remap_end_vaddr;
   	unsigned long long	node_remap_start_pfn;
+	unsigned long long      free_huge_page;
   
   	/*
   	 * for Xen extraction
@@ -1383,6 +1388,9 @@ struct number_table {
   	 */
   	long	PG_lru;
   	long	PG_private;
+	long	PG_head;
+	long	PG_tail;
+	long	PG_compound;
   	long	PG_swapcache;
   	long	PG_buddy;
   	long	PG_slab;
-- 
1.8.0.2

