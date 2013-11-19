Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3KSTTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:19:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51759 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3KSTTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:19:08 -0500
Date: Tue, 19 Nov 2013 11:18:35 -0800
From: "tip-bot for Kirill A. Shutemov" <tipbot@zytor.com>
Message-ID: <tip-fd8526ad14c182605e42b64646344b95befd9f94@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        dave.hansen@intel.com, kirill.shutemov@linux.intel.com,
        n-horiguchi@ah.jp.nec.com, willy@linux.intel.com,
        akpm@linux-foundation.org, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kirill.shutemov@linux.intel.com, dave.hansen@intel.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        n-horiguchi@ah.jp.nec.com, willy@linux.intel.com,
        akpm@linux-foundation.org, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <20131119131750.EA45CE0090@blue.fi.intel.com>
References: <20131119131750.EA45CE0090@blue.fi.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Implement ASLR for hugetlb mappings
Git-Commit-ID: fd8526ad14c182605e42b64646344b95befd9f94
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 19 Nov 2013 11:18:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd8526ad14c182605e42b64646344b95befd9f94
Gitweb:     http://git.kernel.org/tip/fd8526ad14c182605e42b64646344b95befd9f94
Author:     Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
AuthorDate: Tue, 19 Nov 2013 15:17:50 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 19 Nov 2013 14:24:50 +0100

x86/mm: Implement ASLR for hugetlb mappings

Matthew noticed that hugetlb mappings don't participate in ASLR on x86-64:

  %  for i in `seq 3`; do
  > tools/testing/selftests/vm/map_hugetlb | grep address
  > done
  Returned address is 0x2aaaaac00000
  Returned address is 0x2aaaaac00000
  Returned address is 0x2aaaaac00000

/proc/PID/maps entries for the mapping are always the same
(except inode number):

  2aaaaac00000-2aaabac00000 rw-p 00000000 00:0c 8200              /anon_hugepage (deleted)
  2aaaaac00000-2aaabac00000 rw-p 00000000 00:0c 256               /anon_hugepage (deleted)
  2aaaaac00000-2aaabac00000 rw-p 00000000 00:0c 7180              /anon_hugepage (deleted)

The reason is the generic hugetlb_get_unmapped_area() function
which is used on x86-64.  It doesn't support randomization and
use bottom-up unmapped area lookup, instead of usual top-down
on x86-64.

x86 has arch-specific hugetlb_get_unmapped_area(), but it's used
only on x86-32.

Let's use arch-specific hugetlb_get_unmapped_area() on x86-64
too. That adds ASLR and switches hugetlb mappings to use top-down
unmapped area lookup:

  %  for i in `seq 3`; do
  > tools/testing/selftests/vm/map_hugetlb | grep address
  > done
  Returned address is 0x7f4f08a00000
  Returned address is 0x7fdda4200000
  Returned address is 0x7febe0000000

/proc/PID/maps entries:

  7f4f08a00000-7f4f18a00000 rw-p 00000000 00:0c 1168              /anon_hugepage (deleted)
  7fdda4200000-7fddb4200000 rw-p 00000000 00:0c 7092              /anon_hugepage (deleted)
  7febe0000000-7febf0000000 rw-p 00000000 00:0c 7183              /anon_hugepage (deleted)

Unmapped area lookup policy for hugetlb mappings is consistent
with normal mappings now -- the only difference is alignment
requirements for huge pages.

libhugetlbfs test-suite didn't detect any regressions with the
patch applied (although it shows few failures on my machine
regardless the patch).

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mgorman@suse.de>
Link: http://lkml.kernel.org/r/20131119131750.EA45CE0090@blue.fi.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/page.h    | 1 +
 arch/x86/include/asm/page_32.h | 4 ----
 arch/x86/mm/hugetlbpage.c      | 9 +++------
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index c878924..775873d 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -71,6 +71,7 @@ extern bool __virt_addr_valid(unsigned long kaddr);
 #include <asm-generic/getorder.h>
 
 #define __HAVE_ARCH_GATE_AREA 1
+#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 
 #endif	/* __KERNEL__ */
 #endif /* _ASM_X86_PAGE_H */
diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index 4d550d0..904f528 100644
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
index 9d980d8..8c9f647 100644
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
