Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaILKfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:35:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbaILKfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:35:24 -0400
From: Juergen Gross <jgross@suse.com>
To: stefan.bader@canonical.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, ville.syrjala@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, david.vrabel@citrix.com, jbeulich@suse.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V3 3/3] Support Xen pv-domains using PAT
Date: Fri, 12 Sep 2014 12:35:12 +0200
Message-Id: <1410518112-2625-4-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1410518112-2625-1-git-send-email-jgross@suse.com>
References: <1410518112-2625-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the dynamical mapping between cache modes and pgprot values it is
now possible to use all cache modes via the Xen hypervisor PAT settings
in a pv domain.

All to be done is to read the PAT configuration MSR and set up the
translation tables accordingly.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/enlighten.c | 25 +++++++------------------
 arch/x86/xen/mmu.c       | 48 ++----------------------------------------------
 arch/x86/xen/xen-ops.h   |  1 -
 3 files changed, 9 insertions(+), 65 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c0cb11f..75ac572 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1100,12 +1100,6 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 		/* Fast syscall setup is all done in hypercalls, so
 		   these are all ignored.  Stub them out here to stop
 		   Xen console noise. */
-		break;
-
-	case MSR_IA32_CR_PAT:
-		if (smp_processor_id() == 0)
-			xen_set_pat(((u64)high << 32) | low);
-		break;
 
 	default:
 		ret = native_write_msr_safe(msr, low, high);
@@ -1554,10 +1548,6 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
 	/* Prevent unwanted bits from being set in PTEs. */
 	__supported_pte_mask &= ~_PAGE_GLOBAL;
-#if 0
-	if (!xen_initial_domain())
-#endif
-		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
 	__supported_pte_mask |= _PAGE_IOMAP;
 
@@ -1613,14 +1603,6 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	 */
 	acpi_numa = -1;
 #endif
-#ifdef CONFIG_X86_PAT
-	/*
-	 * For right now disable the PAT. We should remove this once
-	 * git commit 8eaffa67b43e99ae581622c5133e20b0f48bcef1
-	 * (xen/pat: Disable PAT support for now) is reverted.
-	 */
-	pat_enabled = 0;
-#endif
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
@@ -1634,6 +1616,13 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	/* Allocate and initialize top and mid mfn levels for p2m structure */
 	xen_build_mfn_list_list();
 
+	/*
+	 * Modify the cache mode translation tables to match Xen's PAT
+	 * configuration.
+	 */
+
+	pat_init_cache_modes();
+
 	/* keep using Xen gdt for now; no urgent need to change it */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e8a1201..70702e9 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -434,13 +434,7 @@ static pteval_t iomap_pte(pteval_t val)
 __visible pteval_t xen_pte_val(pte_t pte)
 {
 	pteval_t pteval = pte.pte;
-#if 0
-	/* If this is a WC pte, convert back from Xen WC to Linux WC */
-	if ((pteval & (_PAGE_PAT | _PAGE_PCD | _PAGE_PWT)) == _PAGE_PAT) {
-		WARN_ON(!pat_enabled);
-		pteval = (pteval & ~_PAGE_PAT) | _PAGE_PWT;
-	}
-#endif
+
 	if (xen_initial_domain() && (pteval & _PAGE_IOMAP))
 		return pteval;
 
@@ -454,48 +448,10 @@ __visible pgdval_t xen_pgd_val(pgd_t pgd)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_pgd_val);
 
-/*
- * Xen's PAT setup is part of its ABI, though I assume entries 6 & 7
- * are reserved for now, to correspond to the Intel-reserved PAT
- * types.
- *
- * We expect Linux's PAT set as follows:
- *
- * Idx  PTE flags        Linux    Xen    Default
- * 0                     WB       WB     WB
- * 1            PWT      WC       WT     WT
- * 2        PCD          UC-      UC-    UC-
- * 3        PCD PWT      UC       UC     UC
- * 4    PAT              WB       WC     WB
- * 5    PAT     PWT      WC       WP     WT
- * 6    PAT PCD          UC-      rsv    UC-
- * 7    PAT PCD PWT      UC       rsv    UC
- */
-
-void xen_set_pat(u64 pat)
-{
-	/* We expect Linux to use a PAT setting of
-	 * UC UC- WC WB (ignoring the PAT flag) */
-	WARN_ON(pat != 0x0007010600070106ull);
-}
-
 __visible pte_t xen_make_pte(pteval_t pte)
 {
 	phys_addr_t addr = (pte & PTE_PFN_MASK);
-#if 0
-	/* If Linux is trying to set a WC pte, then map to the Xen WC.
-	 * If _PAGE_PAT is set, then it probably means it is really
-	 * _PAGE_PSE, so avoid fiddling with the PAT mapping and hope
-	 * things work out OK...
-	 *
-	 * (We should never see kernel mappings with _PAGE_PSE set,
-	 * but we could see hugetlbfs mappings, I think.).
-	 */
-	if (pat_enabled && !WARN_ON(pte & _PAGE_PAT)) {
-		if ((pte & (_PAGE_PCD | _PAGE_PWT)) == _PAGE_PWT)
-			pte = (pte & ~(_PAGE_PCD | _PAGE_PWT)) | _PAGE_PAT;
-	}
-#endif
+
 	/*
 	 * Unprivileged domains are allowed to do IOMAPpings for
 	 * PCI passthrough, but not map ISA space.  The ISA
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 28c7e0b..4ab9298 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -33,7 +33,6 @@ extern unsigned long xen_max_p2m_pfn;
 
 void xen_mm_pin_all(void);
 void xen_mm_unpin_all(void);
-void xen_set_pat(u64);
 
 char * __init xen_memory_setup(void);
 char * xen_auto_xlated_memory_setup(void);
-- 
1.8.4.5

