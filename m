Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaJ0Gsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 02:48:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaJ0Gsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 02:48:43 -0400
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4 3/3] Support Xen pv-domains using PAT
Date: Mon, 27 Oct 2014 07:48:33 +0100
Message-Id: <1414392513-24645-4-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414392513-24645-1-git-send-email-jgross@suse.com>
References: <1414392513-24645-1-git-send-email-jgross@suse.com>
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
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c | 25 +++++++------------------
 arch/x86/xen/mmu.c       | 47 +----------------------------------------------
 arch/x86/xen/xen-ops.h   |  1 -
 3 files changed, 8 insertions(+), 65 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index fac5e4f..6bf3a13 100644
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
@@ -1561,10 +1555,6 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
 	/* Prevent unwanted bits from being set in PTEs. */
 	__supported_pte_mask &= ~_PAGE_GLOBAL;
-#if 0
-	if (!xen_initial_domain())
-#endif
-		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
 	/*
 	 * Prevent page tables from being allocated in highmem, even
@@ -1618,14 +1608,6 @@ asmlinkage __visible void __init xen_start_kernel(void)
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
@@ -1636,6 +1618,13 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	xen_setup_kernel_pagetable((pgd_t *)xen_start_info->pt_base, xen_start_info->nr_pages);
 
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
index a8a1a3d..9855eb8 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -410,13 +410,7 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
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
 	return pte_mfn_to_pfn(pteval);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_pte_val);
@@ -427,47 +421,8 @@ __visible pgdval_t xen_pgd_val(pgd_t pgd)
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
 	pte = pte_pfn_to_mfn(pte);
 
 	return native_make_pte(pte);
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

