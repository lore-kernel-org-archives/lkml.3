Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3JVNwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:52:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:38809 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab3JVNwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:52:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="422919780"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] x86, mm: get ASLR work for hugetlb mappings
Date: Tue, 22 Oct 2013 16:52:20 +0300
Message-Id: <1382449940-24357-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew noticed that hugetlb doesn't participate in ASLR on x86-64.
The reason is genereic hugetlb_get_unmapped_area() which is used on
x86-64. It doesn't support randomization and use bottom-up unmapped area
lookup, instead of usual top-down on x86-64.

x86 has arch-specific hugetlb_get_unmapped_area(), but it's used only on
x86-32.

Let's use arch-specific hugetlb_get_unmapped_area() on x86-64 too.
It fixes the issue and make hugetlb use top-down unmapped area lookup.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
---
 arch/x86/include/asm/page.h    | 1 +
 arch/x86/include/asm/page_32.h | 4 ----
 arch/x86/mm/hugetlbpage.c      | 9 +++------
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index c87892442e..775873d3be 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -71,6 +71,7 @@ extern bool __virt_addr_valid(unsigned long kaddr);
 #include <asm-generic/getorder.h>
 
 #define __HAVE_ARCH_GATE_AREA 1
+#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 
 #endif	/* __KERNEL__ */
 #endif /* _ASM_X86_PAGE_H */
diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index 4d550d04b6..904f528cc8 100644
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
index 9d980d88b7..8c9f647ff9 100644
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
1.8.4.rc3

