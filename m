Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbaHZGQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:16:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245AbaHZGQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:16:29 -0400
From: Juergen Gross <jgross@suse.com>
To: stefan.bader@canonical.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, ville.syrjala@linux.intel.com, hpa@zytor.com,
        x86@kernel.org
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 3/3] Support Xen pv-domains using PAT
Date: Tue, 26 Aug 2014 08:16:23 +0200
Message-Id: <1409033783-12136-4-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409033783-12136-1-git-send-email-jgross@suse.com>
References: <1409033783-12136-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the dynamical mapping between cache modes and pgprot values it is now
possible to use all cache modes via the Xen hypervisor PAT settings in a
pv domain.

All to be done is to read the PAT configuration MSR and set up the translation
tables accordingly.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/enlighten.c | 11 ++++++----
 arch/x86/xen/mmu.c       | 52 ++++++++++++------------------------------------
 arch/x86/xen/xen-ops.h   |  1 +
 3 files changed, 21 insertions(+), 43 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c0cb11f..113c01c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1552,12 +1552,15 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
 	xen_init_mmu_ops();
 
+	/*
+	 * Modify the cache mode translation tables to match Xen's PAT
+	 * configuration.
+	 */
+
+	xen_init_cache_types();
+
 	/* Prevent unwanted bits from being set in PTEs. */
 	__supported_pte_mask &= ~_PAGE_GLOBAL;
-#if 0
-	if (!xen_initial_domain())
-#endif
-		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
 	__supported_pte_mask |= _PAGE_IOMAP;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e8a1201..4d1c736 100644
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
 
@@ -455,47 +449,27 @@ __visible pgdval_t xen_pgd_val(pgd_t pgd)
 PV_CALLEE_SAVE_REGS_THUNK(xen_pgd_val);
 
 /*
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
+ * Xen's PAT setup is part of its ABI.
+ * We don't care what Linux wants to use, just fall back to the Xen PAT
+ * configuration. All we have to do in case of a Linux's PAT configuration
+ * is to overwrite the cache mode translation tables with the correct
+ * values for the Xen configuration.
  */
 
+void xen_init_cache_types(void)
+{
+	pat_init_cache_modes();
+}
+
 void xen_set_pat(u64 pat)
 {
-	/* We expect Linux to use a PAT setting of
-	 * UC UC- WC WB (ignoring the PAT flag) */
-	WARN_ON(pat != 0x0007010600070106ull);
+	xen_init_cache_types();
 }
 
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
index 28c7e0b..348e68aa 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -34,6 +34,7 @@ extern unsigned long xen_max_p2m_pfn;
 void xen_mm_pin_all(void);
 void xen_mm_unpin_all(void);
 void xen_set_pat(u64);
+void xen_init_cache_types(void);
 
 char * __init xen_memory_setup(void);
 char * xen_auto_xlated_memory_setup(void);
-- 
1.8.4.5

