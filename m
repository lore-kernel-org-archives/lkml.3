Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaJNLdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:33:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846AbaJNLdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:33:50 -0400
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH] xen: delay construction of mfn_list_list
Date: Tue, 14 Oct 2014 13:33:46 +0200
Message-Id: <1413286426-1415-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 3 level p2m tree for the Xen tools is constructed very early at
boot by calling xen_build_mfn_list_list(). Memory needed for this tree
is allocated via extend_brk().

As this tree (other than the kernel internal p2m tree) is only needed
for domain save/restore, live migration and crash dump analysis it
doesn't matter whether it is constructed very early or just some
milliseconds later when memory allocation is possible by other means.

This patch moves the call of xen_build_mfn_list_list() just after
calling xen_pagetable_p2m_copy() simplifying this function, too, as it
doesn't have to bother with two parallel trees now. The same applies
for some other internal functions.

While simplifying code, make early_can_reuse_p2m_middle() static and
drop the unused second parameter. p2m_mid_identity_mfn can be removed
as well, it isn't used either.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/enlighten.c |  3 ---
 arch/x86/xen/mmu.c       |  5 +++-
 arch/x86/xen/p2m.c       | 65 +++++++++++-------------------------------------
 3 files changed, 18 insertions(+), 55 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index acb0eff..be32e5b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1636,9 +1636,6 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	xen_setup_kernel_pagetable((pgd_t *)xen_start_info->pt_base, xen_start_info->nr_pages);
 
-	/* Allocate and initialize top and mid mfn levels for p2m structure */
-	xen_build_mfn_list_list();
-
 	/* keep using Xen gdt for now; no urgent need to change it */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f62af76..a8a1a3d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1217,10 +1217,13 @@ static void __init xen_pagetable_p2m_copy(void)
 static void __init xen_pagetable_init(void)
 {
 	paging_init();
-	xen_setup_shared_info();
 #ifdef CONFIG_X86_64
 	xen_pagetable_p2m_copy();
 #endif
+	/* Allocate and initialize top and mid mfn levels for p2m structure */
+	xen_build_mfn_list_list();
+
+	xen_setup_shared_info();
 	xen_post_allocator_init();
 }
 static void xen_write_cr2(unsigned long cr2)
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 4534320..d1b3da2 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -163,6 +163,7 @@
 #include <linux/hash.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
+#include <linux/bootmem.h>
 
 #include <asm/cache.h>
 #include <asm/setup.h>
@@ -181,21 +182,20 @@ static void __init m2p_override_init(void);
 
 unsigned long xen_max_p2m_pfn __read_mostly;
 
+static unsigned long *p2m_mid_missing_mfn;
+static unsigned long *p2m_top_mfn;
+static unsigned long **p2m_top_mfn_p;
+
 /* Placeholders for holes in the address space */
 static RESERVE_BRK_ARRAY(unsigned long, p2m_missing, P2M_PER_PAGE);
 static RESERVE_BRK_ARRAY(unsigned long *, p2m_mid_missing, P2M_MID_PER_PAGE);
-static RESERVE_BRK_ARRAY(unsigned long, p2m_mid_missing_mfn, P2M_MID_PER_PAGE);
 
 static RESERVE_BRK_ARRAY(unsigned long **, p2m_top, P2M_TOP_PER_PAGE);
-static RESERVE_BRK_ARRAY(unsigned long, p2m_top_mfn, P2M_TOP_PER_PAGE);
-static RESERVE_BRK_ARRAY(unsigned long *, p2m_top_mfn_p, P2M_TOP_PER_PAGE);
 
 static RESERVE_BRK_ARRAY(unsigned long, p2m_identity, P2M_PER_PAGE);
 static RESERVE_BRK_ARRAY(unsigned long *, p2m_mid_identity, P2M_MID_PER_PAGE);
-static RESERVE_BRK_ARRAY(unsigned long, p2m_mid_identity_mfn, P2M_MID_PER_PAGE);
 
 RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
-RESERVE_BRK(p2m_mid_mfn, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
 
 /* For each I/O range remapped we may lose up to two leaf pages for the boundary
  * violations and three mid pages to cover up to 3GB. With
@@ -272,11 +272,11 @@ static void p2m_init(unsigned long *p2m)
  * Build the parallel p2m_top_mfn and p2m_mid_mfn structures
  *
  * This is called both at boot time, and after resuming from suspend:
- * - At boot time we're called very early, and must use extend_brk()
+ * - At boot time we're called rather early, and must use alloc_bootmem*()
  *   to allocate memory.
  *
  * - After resume we're called from within stop_machine, but the mfn
- *   tree should alreay be completely allocated.
+ *   tree should already be completely allocated.
  */
 void __ref xen_build_mfn_list_list(void)
 {
@@ -287,20 +287,17 @@ void __ref xen_build_mfn_list_list(void)
 
 	/* Pre-initialize p2m_top_mfn to be completely missing */
 	if (p2m_top_mfn == NULL) {
-		p2m_mid_missing_mfn = extend_brk(PAGE_SIZE, PAGE_SIZE);
+		p2m_mid_missing_mfn = alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
 		p2m_mid_mfn_init(p2m_mid_missing_mfn, p2m_missing);
-		p2m_mid_identity_mfn = extend_brk(PAGE_SIZE, PAGE_SIZE);
-		p2m_mid_mfn_init(p2m_mid_identity_mfn, p2m_identity);
 
-		p2m_top_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
+		p2m_top_mfn_p = alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
 		p2m_top_mfn_p_init(p2m_top_mfn_p);
 
-		p2m_top_mfn = extend_brk(PAGE_SIZE, PAGE_SIZE);
+		p2m_top_mfn = alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
 		p2m_top_mfn_init(p2m_top_mfn);
 	} else {
 		/* Reinitialise, mfn's all change after migration */
 		p2m_mid_mfn_init(p2m_mid_missing_mfn, p2m_missing);
-		p2m_mid_mfn_init(p2m_mid_identity_mfn, p2m_identity);
 	}
 
 	for (pfn = 0; pfn < xen_max_p2m_pfn; pfn += P2M_PER_PAGE) {
@@ -328,10 +325,9 @@ void __ref xen_build_mfn_list_list(void)
 			/*
 			 * XXX boot-time only!  We should never find
 			 * missing parts of the mfn tree after
-			 * runtime.  extend_brk() will BUG if we call
-			 * it too late.
+			 * runtime.
 			 */
-			mid_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
+			mid_mfn_p = alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
 			p2m_mid_mfn_init(mid_mfn_p, p2m_missing);
 
 			p2m_top_mfn_p[topidx] = mid_mfn_p;
@@ -415,7 +411,6 @@ void __init xen_build_dynamic_phys_to_machine(void)
 	m2p_override_init();
 }
 #ifdef CONFIG_X86_64
-#include <linux/bootmem.h>
 unsigned long __init xen_revector_p2m_tree(void)
 {
 	unsigned long va_start;
@@ -477,7 +472,6 @@ unsigned long __init xen_revector_p2m_tree(void)
 
 			copy_page(new, mid_p);
 			p2m_top[topidx][mididx] = &mfn_list[pfn_free];
-			p2m_top_mfn_p[topidx][mididx] = virt_to_mfn(&mfn_list[pfn_free]);
 
 			pfn_free += P2M_PER_PAGE;
 
@@ -610,7 +604,6 @@ static bool __init early_alloc_p2m(unsigned long pfn, bool check_boundary)
 {
 	unsigned topidx, mididx, idx;
 	unsigned long *p2m;
-	unsigned long *mid_mfn_p;
 
 	topidx = p2m_top_index(pfn);
 	mididx = p2m_mid_index(pfn);
@@ -637,43 +630,21 @@ static bool __init early_alloc_p2m(unsigned long pfn, bool check_boundary)
 
 	p2m_top[topidx][mididx] = p2m;
 
-	/* For save/restore we need to MFN of the P2M saved */
-
-	mid_mfn_p = p2m_top_mfn_p[topidx];
-	WARN(mid_mfn_p[mididx] != virt_to_mfn(p2m_missing),
-		"P2M_TOP_P[%d][%d] != MFN of p2m_missing!\n",
-		topidx, mididx);
-	mid_mfn_p[mididx] = virt_to_mfn(p2m);
-
 	return true;
 }
 
 static bool __init early_alloc_p2m_middle(unsigned long pfn)
 {
 	unsigned topidx = p2m_top_index(pfn);
-	unsigned long *mid_mfn_p;
 	unsigned long **mid;
 
 	mid = p2m_top[topidx];
-	mid_mfn_p = p2m_top_mfn_p[topidx];
 	if (mid == p2m_mid_missing) {
 		mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
 
 		p2m_mid_init(mid, p2m_missing);
 
 		p2m_top[topidx] = mid;
-
-		BUG_ON(mid_mfn_p != p2m_mid_missing_mfn);
-	}
-	/* And the save/restore P2M tables.. */
-	if (mid_mfn_p == p2m_mid_missing_mfn) {
-		mid_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
-		p2m_mid_mfn_init(mid_mfn_p, p2m_missing);
-
-		p2m_top_mfn_p[topidx] = mid_mfn_p;
-		p2m_top_mfn[topidx] = virt_to_mfn(mid_mfn_p);
-		/* Note: we don't set mid_mfn_p[midix] here,
-		 * look in early_alloc_p2m() */
 	}
 	return true;
 }
@@ -684,14 +655,13 @@ static bool __init early_alloc_p2m_middle(unsigned long pfn)
  * replace the P2M leaf with a p2m_missing or p2m_identity.
  * Stick the old page in the new P2M tree location.
  */
-bool __init early_can_reuse_p2m_middle(unsigned long set_pfn, unsigned long set_mfn)
+static bool __init early_can_reuse_p2m_middle(unsigned long set_pfn)
 {
 	unsigned topidx;
 	unsigned mididx;
 	unsigned ident_pfns;
 	unsigned inv_pfns;
 	unsigned long *p2m;
-	unsigned long *mid_mfn_p;
 	unsigned idx;
 	unsigned long pfn;
 
@@ -737,11 +707,6 @@ bool __init early_can_reuse_p2m_middle(unsigned long set_pfn, unsigned long set_
 found:
 	/* Found one, replace old with p2m_identity or p2m_missing */
 	p2m_top[topidx][mididx] = (ident_pfns ? p2m_identity : p2m_missing);
-	/* And the other for save/restore.. */
-	mid_mfn_p = p2m_top_mfn_p[topidx];
-	/* NOTE: Even if it is a p2m_identity it should still be point to
-	 * a page filled with INVALID_P2M_ENTRY entries. */
-	mid_mfn_p[mididx] = virt_to_mfn(p2m_missing);
 
 	/* Reset where we want to stick the old page in. */
 	topidx = p2m_top_index(set_pfn);
@@ -756,8 +721,6 @@ found:
 
 	p2m_init(p2m);
 	p2m_top[topidx][mididx] = p2m;
-	mid_mfn_p = p2m_top_mfn_p[topidx];
-	mid_mfn_p[mididx] = virt_to_mfn(p2m);
 
 	return true;
 }
@@ -767,7 +730,7 @@ bool __init early_set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 		if (!early_alloc_p2m_middle(pfn))
 			return false;
 
-		if (early_can_reuse_p2m_middle(pfn, mfn))
+		if (early_can_reuse_p2m_middle(pfn))
 			return __set_phys_to_machine(pfn, mfn);
 
 		if (!early_alloc_p2m(pfn, false /* boundary crossover OK!*/))
-- 
1.8.4.5

