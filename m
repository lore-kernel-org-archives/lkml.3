Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab3CTASP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:18:15 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:48364 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab3CTASO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:18:14 -0400
Date: Tue, 19 Mar 2013 17:18:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, hugetlb: include hugepages in meminfo
Message-ID: <alpine.DEB.2.02.1303191714440.13526@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Particularly in oom conditions, it's troublesome that hugetlb memory is 
not displayed.  All other meminfo that is emitted will not add up to what 
is expected, and there is no artifact left in the kernel log to show that 
a potentially significant amount of memory is actually allocated as 
hugepages which are not available to be reclaimed.

Booting with hugepages=8192 on the command line, this memory is now shown 
in oom conditions.  For example, with echo m > /proc/sysrq-trigger:

Node 0 hugepages_total=2048 hugepages_free=2048 hugepages_surp=0 hugepages_size=2048kB
Node 1 hugepages_total=2048 hugepages_free=2048 hugepages_surp=0 hugepages_size=2048kB
Node 2 hugepages_total=2048 hugepages_free=2048 hugepages_surp=0 hugepages_size=2048kB
Node 3 hugepages_total=2048 hugepages_free=2048 hugepages_surp=0 hugepages_size=2048kB

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/hugetlb.h |  4 ++++
 mm/hugetlb.c            | 14 ++++++++++++++
 mm/page_alloc.c         |  3 +++
 3 files changed, 21 insertions(+)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -58,6 +58,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 int hugetlb_prefault(struct address_space *, struct vm_area_struct *);
 void hugetlb_report_meminfo(struct seq_file *);
 int hugetlb_report_node_meminfo(int, char *);
+void hugetlb_show_meminfo(void);
 unsigned long hugetlb_total_pages(void);
 int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, unsigned int flags);
@@ -114,6 +115,9 @@ static inline void hugetlb_report_meminfo(struct seq_file *m)
 {
 }
 #define hugetlb_report_node_meminfo(n, buf)	0
+static inline void hugetlb_show_meminfo(void)
+{
+}
 #define follow_huge_pmd(mm, addr, pmd, write)	NULL
 #define follow_huge_pud(mm, addr, pud, write)	NULL
 #define prepare_hugepage_range(file, addr, len)	(-EINVAL)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2121,6 +2121,20 @@ int hugetlb_report_node_meminfo(int nid, char *buf)
 		nid, h->surplus_huge_pages_node[nid]);
 }
 
+void hugetlb_show_meminfo(void)
+{
+	struct hstate *h = &default_hstate;
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY)
+		pr_info("Node %d hugepages_total=%u hugepages_free=%u hugepages_surp=%u hugepages_size=%lukB\n",
+		        nid,
+			h->nr_huge_pages_node[nid],
+			h->free_huge_pages_node[nid],
+			h->surplus_huge_pages_node[nid],
+			1UL << (huge_page_order(h) + PAGE_SHIFT - 10));
+}
+
 /* Return the number pages of memory we physically have, in PAGE_SIZE units. */
 unsigned long hugetlb_total_pages(void)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -58,6 +58,7 @@
 #include <linux/prefetch.h>
 #include <linux/migrate.h>
 #include <linux/page-debug-flags.h>
+#include <linux/hugetlb.h>
 #include <linux/sched/rt.h>
 
 #include <asm/tlbflush.h>
@@ -3105,6 +3106,8 @@ void show_free_areas(unsigned int filter)
 		printk("= %lukB\n", K(total));
 	}
 
+	hugetlb_show_meminfo();
+
 	printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
 
 	show_swap_cache_info();
