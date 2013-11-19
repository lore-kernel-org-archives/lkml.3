Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab3KSNR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:17:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:58791 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab3KSNR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:17:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,729,1378882800"; 
   d="scan'208";a="435992005"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: akpm@linux-foundation.org, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, kirill.shutemov@linux.intel.com,
        dave.hansen@intel.com, mingo@redhat.com, n-horiguchi@ah.jp.nec.com,
        willy@linux.intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20131119083053.GB1243@gmail.com>
References: <20131115221406.1692E1E418F@corp2gmr1-2.eem.corp.google.com>
 <20131119083053.GB1243@gmail.com>
Subject: Re: [patch 3/3] x86, mm: get ASLR work for hugetlb mappings
Content-Transfer-Encoding: 7bit
Message-Id: <20131119131750.EA45CE0090@blue.fi.intel.com>
Date: Tue, 19 Nov 2013 15:17:50 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> 
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > Subject: x86, mm: get ASLR work for hugetlb mappings
> > 
> > Matthew noticed that hugetlb doesn't participate in ASLR on x86-64.  The
> > reason is genereic hugetlb_get_unmapped_area() which is used on x86-64. 
> > It doesn't support randomization and use bottom-up unmapped area lookup,
> > instead of usual top-down on x86-64.
> > 
> > x86 has arch-specific hugetlb_get_unmapped_area(), but it's used only on
> > x86-32.
> > 
> > Let's use arch-specific hugetlb_get_unmapped_area() on x86-64 too.  It
> > fixes the issue and make hugetlb use top-down unmapped area lookup.
> 
> So the title and the changelog has typos (I counted three), which 
> makes me wonder how well this was tested.
> 
> To show/document the testing effort a before/after /proc/PID/maps 
> output showing hugetlb vma addresses would be nice, showing that ASLR 
> didn't work before and that it works adequately after the patch.
> 
> A word about the range and granularity of randomization in the typical 
> case would be nice as well.

What about this:

>From 440f2cd4a7e6918b9238680e4eacd75dc30291b6 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Fri, 15 Nov 2013 14:14:05 -0800
Subject: [PATCH] x86, mm: get ASLR works for hugetlb mappings

Matthew noticed that hugetlb doesn't participate in ASLR on x86-64.

%  for i in `seq 3`; do
> tools/testing/selftests/vm/map_hugetlb | grep address
> done
Returned address is 0x2aaaaac00000
Returned address is 0x2aaaaac00000
Returned address is 0x2aaaaac00000

/proc/PID/maps entries for the mapping are always the same (except inode
number):

2aaaaac00000-2aaabac00000 rw-p 00000000 00:0c 8200                       /anon_hugepage (deleted)
2aaaaac00000-2aaabac00000 rw-p 00000000 00:0c 256                        /anon_hugepage (deleted)
2aaaaac00000-2aaabac00000 rw-p 00000000 00:0c 7180                       /anon_hugepage (deleted)

The reason is generic hugetlb_get_unmapped_area() which is used on
x86-64.  It doesn't support randomization and use bottom-up unmapped
area lookup, instead of usual top-down on x86-64.

x86 has arch-specific hugetlb_get_unmapped_area(), but it's used only on
x86-32.

Let's use arch-specific hugetlb_get_unmapped_area() on x86-64 too.
It fixes the issue and switch hugetlb to use top-down unmapped area
lookup.

%  for i in `seq 3`; do
> tools/testing/selftests/vm/map_hugetlb | grep address
> done
Returned address is 0x7f4f08a00000
Returned address is 0x7fdda4200000
Returned address is 0x7febe0000000

/proc/PID/maps entries:

7f4f08a00000-7f4f18a00000 rw-p 00000000 00:0c 1168                       /anon_hugepage (deleted)
7fdda4200000-7fddb4200000 rw-p 00000000 00:0c 7092                       /anon_hugepage (deleted)
7febe0000000-7febf0000000 rw-p 00000000 00:0c 7183                       /anon_hugepage (deleted)

Unmapped area lookup policy for hugetlb mappings is consistent with
normal mappings now -- the only difference is alignment requirements for
huge pages.

libhugetlbfs test-suite didn't detect any regressions with the patch
applied (although it shows few failures on my machine regardless the
patch).

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/include/asm/page.h    | 1 +
 arch/x86/include/asm/page_32.h | 4 ----
 arch/x86/mm/hugetlbpage.c      | 9 +++------
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index c87892442e53..775873d3be55 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -71,6 +71,7 @@ extern bool __virt_addr_valid(unsigned long kaddr);
 #include <asm-generic/getorder.h>
 
 #define __HAVE_ARCH_GATE_AREA 1
+#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 
 #endif	/* __KERNEL__ */
 #endif /* _ASM_X86_PAGE_H */
diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index 4d550d04b609..904f528cc8e8 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -5,10 +5,6 @@
 
 #ifndef __ASSEMBLY__
 
-#ifdef CONFIG_HUGETLB_PAGE
-#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
-#endif
-
 #define __phys_addr_nodebug(x)	((x) - PAGE_OFFSET)
 #ifdef CONFIG_DEBUG_VIRTUAL
 extern unsigned long __phys_addr(unsigned long);
diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 9d980d88b747..8c9f647ff9e1 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -87,9 +87,7 @@ int pmd_huge_support(void)
 }
 #endif
 
-/* x86_64 also uses this file */
-
-#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
+#ifdef CONFIG_HUGETLB_PAGE
 static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
 		unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
@@ -99,7 +97,7 @@ static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
 
 	info.flags = 0;
 	info.length = len;
-	info.low_limit = TASK_UNMAPPED_BASE;
+	info.low_limit = current->mm->mmap_legacy_base;
 	info.high_limit = TASK_SIZE;
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
@@ -172,8 +170,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 		return hugetlb_get_unmapped_area_topdown(file, addr, len,
 				pgoff, flags);
 }
-
-#endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
+#endif /* CONFIG_HUGETLB_PAGE */
 
 #ifdef CONFIG_X86_64
 static __init int setup_hugepagesz(char *opt)
-- 
 Kirill A. Shutemov
