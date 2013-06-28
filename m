Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab3F1R4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:56:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:19866 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab3F1R4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:56:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,960,1363158000"; 
   d="scan'208";a="337139582"
Subject: [PATCH] x86: meminfo: fix DirectMap2M underflow
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 28 Jun 2013 10:56:33 -0700
Message-Id: <20130628175633.FCD5AF0B@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This bug seems familiar.  I'm not sure if I hit it a while ago
and ignored it or if it is something I've seen show up in a
couple of different forms.

I booted a kernel in a KVM instance which has a bunch of
debugging turned on.  Meminfo shows:

DirectMap4k:     2058232 kB
DirectMap2M:    18446744073709541376 kB

Which is a _bit_ bogus. :) In this case, I think DEBUG_PAGEALLOC
is what actually triggers this:

void free_init_pages(char *what, unsigned long begin, unsigned long end)
{
...
#ifdef CONFIG_DEBUG_PAGEALLOC
        printk(KERN_INFO "debug: unmapping init [mem %#010lx-%#010lx]\n",
                begin, end - 1);
        set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
#else
...

Here, we are freeing memory in this mapping (from
Documentation/x86/x86_64/mm.txt):

ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0

Which we map with 2M pages.  But, this is not a part of the
actual kernel linear map.  The change_page_attr() code calls in
to split_page_count() since it is splitting a 2M page.  We do
not have any 2M pages for the linear map (because of
DEBUG_PAGEALLOC), and the count underflows.

This patch adds a check (and an argument) to split_page_count()
to make sure that we can tell whether or not the address we are
splitting is part of the linear map.

It also changes the types of the direct_pages_count[] variables
and the accessor functions.  The callers are already passing
signed variables in:

	update_page_count(PG_LEVEL_1G, -pages);

to a function with unsigned arguments:

	void update_page_count(int level, unsigned long pages)

so we might as well make them signed.  We make the
direct_pages_count[] variables signed so that we can do easy
checks when they underflow.


---

 linux.git-davehans/arch/x86/include/asm/pgtable_types.h |    4 +-
 linux.git-davehans/arch/x86/mm/init_32.c                |    2 -
 linux.git-davehans/arch/x86/mm/pageattr.c               |   32 ++++++++++++----
 3 files changed, 27 insertions(+), 11 deletions(-)

diff -puN arch/x86/include/asm/pgtable_types.h~mm-meminfo-DirectMap2M-underflow arch/x86/include/asm/pgtable_types.h
--- linux.git/arch/x86/include/asm/pgtable_types.h~mm-meminfo-DirectMap2M-underflow	2013-06-28 10:55:42.528074131 -0700
+++ linux.git-davehans/arch/x86/include/asm/pgtable_types.h	2013-06-28 10:55:42.535074443 -0700
@@ -339,9 +339,9 @@ enum pg_level {
 };
 
 #ifdef CONFIG_PROC_FS
-extern void update_page_count(int level, unsigned long pages);
+extern void update_page_count(int level, int pages);
 #else
-static inline void update_page_count(int level, unsigned long pages) { }
+static inline void update_page_count(int level, int pages) { }
 #endif
 
 /*
diff -puN arch/x86/mm/init_32.c~mm-meminfo-DirectMap2M-underflow arch/x86/mm/init_32.c
--- linux.git/arch/x86/mm/init_32.c~mm-meminfo-DirectMap2M-underflow	2013-06-28 10:55:42.530074220 -0700
+++ linux.git-davehans/arch/x86/mm/init_32.c	2013-06-28 10:55:42.536074487 -0700
@@ -261,7 +261,7 @@ kernel_physical_mapping_init(unsigned lo
 	pgd_t *pgd;
 	pmd_t *pmd;
 	pte_t *pte;
-	unsigned pages_2m, pages_4k;
+	int pages_2m, pages_4k;
 	int mapping_iter;
 
 	start_pfn = start >> PAGE_SHIFT;
diff -puN arch/x86/mm/pageattr.c~mm-meminfo-DirectMap2M-underflow arch/x86/mm/pageattr.c
--- linux.git/arch/x86/mm/pageattr.c~mm-meminfo-DirectMap2M-underflow	2013-06-28 10:55:42.532074309 -0700
+++ linux.git-davehans/arch/x86/mm/pageattr.c	2013-06-28 10:55:42.537074532 -0700
@@ -53,31 +53,47 @@ static DEFINE_SPINLOCK(cpa_lock);
 #define CPA_PAGES_ARRAY 4
 
 #ifdef CONFIG_PROC_FS
-static unsigned long direct_pages_count[PG_LEVEL_NUM];
+static long direct_pages_count[PG_LEVEL_NUM];
 
-void update_page_count(int level, unsigned long pages)
+static void check_direct_pages_count(int level)
+{
+	WARN_ONCE(direct_pages_count[level] < 0,
+		"page table count underflow level: %d", level);
+}
+
+void update_page_count(int level, int pages)
 {
 	/* Protect against CPA */
 	spin_lock(&pgd_lock);
 	direct_pages_count[level] += pages;
+	check_direct_pages_count(level);
 	spin_unlock(&pgd_lock);
 }
 
-static void split_page_count(int level)
+static void split_page_count(unsigned long address, int level)
 {
+	/*
+	 * We only keep these pagetable counts for memory in
+	 * the linear map.  The things we do not care about
+	 * and do not track are all at or above VMALLOC_START.
+	 */
+	if (address >= VMALLOC_START)
+		return;
+
 	direct_pages_count[level]--;
+	check_direct_pages_count(level);
 	direct_pages_count[level - 1] += PTRS_PER_PTE;
 }
 
 void arch_report_meminfo(struct seq_file *m)
 {
-	seq_printf(m, "DirectMap4k:    %8lu kB\n",
+	seq_printf(m, "DirectMap4k:    %8ld kB\n",
 			direct_pages_count[PG_LEVEL_4K] << 2);
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
-	seq_printf(m, "DirectMap2M:    %8lu kB\n",
+	seq_printf(m, "DirectMap2M:    %8ld kB\n",
 			direct_pages_count[PG_LEVEL_2M] << 11);
 #else
-	seq_printf(m, "DirectMap4M:    %8lu kB\n",
+	seq_printf(m, "DirectMap4M:    %8ld kB\n",
 			direct_pages_count[PG_LEVEL_2M] << 12);
 #endif
 #ifdef CONFIG_X86_64
@@ -87,7 +103,7 @@ void arch_report_meminfo(struct seq_file
 #endif
 }
 #else
-static inline void split_page_count(int level) { }
+static inline void split_page_count(unsigned long address, int level) { }
 #endif
 
 #ifdef CONFIG_X86_64
@@ -607,7 +623,7 @@ __split_large_page(pte_t *kpte, unsigned
 
 	if (pfn_range_is_mapped(PFN_DOWN(__pa(address)),
 				PFN_DOWN(__pa(address)) + 1))
-		split_page_count(level);
+		split_page_count(address, level);
 
 	/*
 	 * Install the new, split up pagetable.
_
