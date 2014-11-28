Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaK1K5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:57:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaK1KyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:54:05 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andrew.cooper3@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4 03/10] xen: use common page allocation function in p2m.c
Date: Fri, 28 Nov 2014 11:53:52 +0100
Message-Id: <1417172039-8627-4-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1417172039-8627-1-git-send-email-jgross@suse.com>
References: <1417172039-8627-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/x86/xen/p2m.c three different allocation functions for
obtaining a memory page are used: extend_brk(), alloc_bootmem_align()
or __get_free_page().  Which of those functions is used depends on the
progress of the boot process of the system.

Introduce a common allocation routine selecting the to be called
allocation routine dynamically based on the boot progress. This allows
moving initialization steps without having to care about changing
allocation calls.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/mmu.c |  2 ++
 arch/x86/xen/p2m.c | 57 +++++++++++++++++++++++++++++++++---------------------
 2 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index a8a1a3d..b995b871 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1219,6 +1219,8 @@ static void __init xen_pagetable_init(void)
 	paging_init();
 #ifdef CONFIG_X86_64
 	xen_pagetable_p2m_copy();
+#else
+	xen_revector_p2m_tree();
 #endif
 	/* Allocate and initialize top and mid mfn levels for p2m structure */
 	xen_build_mfn_list_list();
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 2d8b908..fa53dc2 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -164,6 +164,7 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/bootmem.h>
+#include <linux/slab.h>
 
 #include <asm/cache.h>
 #include <asm/setup.h>
@@ -204,6 +205,8 @@ RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER
  */
 RESERVE_BRK(p2m_identity_remap, PAGE_SIZE * 2 * 3 * MAX_REMAP_RANGES);
 
+static int use_brk = 1;
+
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
 	BUG_ON(pfn >= MAX_P2M_PFN);
@@ -268,6 +271,24 @@ static void p2m_init(unsigned long *p2m)
 		p2m[i] = INVALID_P2M_ENTRY;
 }
 
+static void * __ref alloc_p2m_page(void)
+{
+	if (unlikely(use_brk))
+		return extend_brk(PAGE_SIZE, PAGE_SIZE);
+
+	if (unlikely(!slab_is_available()))
+		return alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
+
+	return (void *)__get_free_page(GFP_KERNEL | __GFP_REPEAT);
+}
+
+/* Only to be called in case of a race for a page just allocated! */
+static void free_p2m_page(void *p)
+{
+	BUG_ON(!slab_is_available());
+	free_page((unsigned long)p);
+}
+
 /*
  * Build the parallel p2m_top_mfn and p2m_mid_mfn structures
  *
@@ -287,13 +308,13 @@ void __ref xen_build_mfn_list_list(void)
 
 	/* Pre-initialize p2m_top_mfn to be completely missing */
 	if (p2m_top_mfn == NULL) {
-		p2m_mid_missing_mfn = alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
+		p2m_mid_missing_mfn = alloc_p2m_page();
 		p2m_mid_mfn_init(p2m_mid_missing_mfn, p2m_missing);
 
-		p2m_top_mfn_p = alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
+		p2m_top_mfn_p = alloc_p2m_page();
 		p2m_top_mfn_p_init(p2m_top_mfn_p);
 
-		p2m_top_mfn = alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
+		p2m_top_mfn = alloc_p2m_page();
 		p2m_top_mfn_init(p2m_top_mfn);
 	} else {
 		/* Reinitialise, mfn's all change after migration */
@@ -327,7 +348,7 @@ void __ref xen_build_mfn_list_list(void)
 			 * missing parts of the mfn tree after
 			 * runtime.
 			 */
-			mid_mfn_p = alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
+			mid_mfn_p = alloc_p2m_page();
 			p2m_mid_mfn_init(mid_mfn_p, p2m_missing);
 
 			p2m_top_mfn_p[topidx] = mid_mfn_p;
@@ -364,17 +385,17 @@ void __init xen_build_dynamic_phys_to_machine(void)
 	max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
 	xen_max_p2m_pfn = max_pfn;
 
-	p2m_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_missing = alloc_p2m_page();
 	p2m_init(p2m_missing);
-	p2m_identity = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_identity = alloc_p2m_page();
 	p2m_init(p2m_identity);
 
-	p2m_mid_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_mid_missing = alloc_p2m_page();
 	p2m_mid_init(p2m_mid_missing, p2m_missing);
-	p2m_mid_identity = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_mid_identity = alloc_p2m_page();
 	p2m_mid_init(p2m_mid_identity, p2m_identity);
 
-	p2m_top = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_top = alloc_p2m_page();
 	p2m_top_init(p2m_top);
 
 	/*
@@ -387,7 +408,7 @@ void __init xen_build_dynamic_phys_to_machine(void)
 		unsigned mididx = p2m_mid_index(pfn);
 
 		if (p2m_top[topidx] == p2m_mid_missing) {
-			unsigned long **mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
+			unsigned long **mid = alloc_p2m_page();
 			p2m_mid_init(mid, p2m_missing);
 
 			p2m_top[topidx] = mid;
@@ -420,6 +441,7 @@ unsigned long __init xen_revector_p2m_tree(void)
 	unsigned long *mfn_list = NULL;
 	unsigned long size;
 
+	use_brk = 0;
 	va_start = xen_start_info->mfn_list;
 	/*We copy in increments of P2M_PER_PAGE * sizeof(unsigned long),
 	 * so make sure it is rounded up to that */
@@ -484,6 +506,7 @@ unsigned long __init xen_revector_p2m_tree(void)
 #else
 unsigned long __init xen_revector_p2m_tree(void)
 {
+	use_brk = 0;
 	return 0;
 }
 #endif
@@ -510,16 +533,6 @@ unsigned long get_phys_to_machine(unsigned long pfn)
 }
 EXPORT_SYMBOL_GPL(get_phys_to_machine);
 
-static void *alloc_p2m_page(void)
-{
-	return (void *)__get_free_page(GFP_KERNEL | __GFP_REPEAT);
-}
-
-static void free_p2m_page(void *p)
-{
-	free_page((unsigned long)p);
-}
-
 /*
  * Fully allocate the p2m structure for a given pfn.  We need to check
  * that both the top and mid levels are allocated, and make sure the
@@ -624,7 +637,7 @@ static bool __init early_alloc_p2m(unsigned long pfn, bool check_boundary)
 		return false;
 
 	/* Boundary cross-over for the edges: */
-	p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m = alloc_p2m_page();
 
 	p2m_init(p2m);
 
@@ -640,7 +653,7 @@ static bool __init early_alloc_p2m_middle(unsigned long pfn)
 
 	mid = p2m_top[topidx];
 	if (mid == p2m_mid_missing) {
-		mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
+		mid = alloc_p2m_page();
 
 		p2m_mid_init(mid, p2m_missing);
 
-- 
2.1.2

