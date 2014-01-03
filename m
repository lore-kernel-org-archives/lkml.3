Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaACUaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:30:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21964 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaACU36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:29:58 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        david.vrabel@citrix.com
Cc: hpa@zytor.com, Mukesh Rathor <mukesh.rathor@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v13 07/19] xen/pvh: MMU changes for PVH (v2)
Date: Fri,  3 Jan 2014 14:38:24 -0500
Message-Id: <1388777916-1328-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mukesh Rathor <mukesh.rathor@oracle.com>

.. which are surprinsingly small compared to the amount for PV code.

PVH uses mostly native mmu ops, we leave the generic (native_*) for
the majority and just overwrite the baremetal with the ones we need.

At startup, we are running with pre-allocated page-tables
courtesy of the tool-stack. But we still need to graft them
in the Linux initial pagetables. However there is no need to
unpin/pin and change them to R/O or R/W.

Note that the xen_pagetable_init due to 7836fec9d0994cc9c9150c5a33f0eb0eb08a335a
"xen/mmu/p2m: Refactor the xen_pagetable_init code." does not
need any changes - we just need to make sure that xen_post_allocator_init
does not alter the pvops from the default native one.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/mmu.c | 81 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 35 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 9d74249..490ddb3 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1757,6 +1757,10 @@ static void set_page_prot_flags(void *addr, pgprot_t prot, unsigned long flags)
 	unsigned long pfn = __pa(addr) >> PAGE_SHIFT;
 	pte_t pte = pfn_pte(pfn, prot);
 
+	/* For PVH no need to set R/O or R/W to pin them or unpin them. */
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
 	if (HYPERVISOR_update_va_mapping((unsigned long)addr, pte, flags))
 		BUG();
 }
@@ -1867,6 +1871,7 @@ static void __init check_pt_base(unsigned long *pt_base, unsigned long *pt_end,
  * but that's enough to get __va working.  We need to fill in the rest
  * of the physical mapping once some sort of allocator has been set
  * up.
+ * NOTE: for PVH, the page tables are native.
  */
 void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 {
@@ -1888,17 +1893,18 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	/* Zap identity mapping */
 	init_level4_pgt[0] = __pgd(0);
 
-	/* Pre-constructed entries are in pfn, so convert to mfn */
-	/* L4[272] -> level3_ident_pgt
-	 * L4[511] -> level3_kernel_pgt */
-	convert_pfn_mfn(init_level4_pgt);
-
-	/* L3_i[0] -> level2_ident_pgt */
-	convert_pfn_mfn(level3_ident_pgt);
-	/* L3_k[510] -> level2_kernel_pgt
-	 * L3_i[511] -> level2_fixmap_pgt */
-	convert_pfn_mfn(level3_kernel_pgt);
-
+	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
+		/* Pre-constructed entries are in pfn, so convert to mfn */
+		/* L4[272] -> level3_ident_pgt
+		 * L4[511] -> level3_kernel_pgt */
+		convert_pfn_mfn(init_level4_pgt);
+
+		/* L3_i[0] -> level2_ident_pgt */
+		convert_pfn_mfn(level3_ident_pgt);
+		/* L3_k[510] -> level2_kernel_pgt
+		 * L3_i[511] -> level2_fixmap_pgt */
+		convert_pfn_mfn(level3_kernel_pgt);
+	}
 	/* We get [511][511] and have Xen's version of level2_kernel_pgt */
 	l3 = m2v(pgd[pgd_index(__START_KERNEL_map)].pgd);
 	l2 = m2v(l3[pud_index(__START_KERNEL_map)].pud);
@@ -1922,31 +1928,33 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	copy_page(level2_fixmap_pgt, l2);
 	/* Note that we don't do anything with level1_fixmap_pgt which
 	 * we don't need. */
+	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
+		/* Make pagetable pieces RO */
+		set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
+		set_page_prot(level3_ident_pgt, PAGE_KERNEL_RO);
+		set_page_prot(level3_kernel_pgt, PAGE_KERNEL_RO);
+		set_page_prot(level3_user_vsyscall, PAGE_KERNEL_RO);
+		set_page_prot(level2_ident_pgt, PAGE_KERNEL_RO);
+		set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
+		set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
+
+		/* Pin down new L4 */
+		pin_pagetable_pfn(MMUEXT_PIN_L4_TABLE,
+				  PFN_DOWN(__pa_symbol(init_level4_pgt)));
+
+		/* Unpin Xen-provided one */
+		pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
 
-	/* Make pagetable pieces RO */
-	set_page_prot(init_level4_pgt, PAGE_KERNEL_RO);
-	set_page_prot(level3_ident_pgt, PAGE_KERNEL_RO);
-	set_page_prot(level3_kernel_pgt, PAGE_KERNEL_RO);
-	set_page_prot(level3_user_vsyscall, PAGE_KERNEL_RO);
-	set_page_prot(level2_ident_pgt, PAGE_KERNEL_RO);
-	set_page_prot(level2_kernel_pgt, PAGE_KERNEL_RO);
-	set_page_prot(level2_fixmap_pgt, PAGE_KERNEL_RO);
-
-	/* Pin down new L4 */
-	pin_pagetable_pfn(MMUEXT_PIN_L4_TABLE,
-			  PFN_DOWN(__pa_symbol(init_level4_pgt)));
-
-	/* Unpin Xen-provided one */
-	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
-
-	/*
-	 * At this stage there can be no user pgd, and no page
-	 * structure to attach it to, so make sure we just set kernel
-	 * pgd.
-	 */
-	xen_mc_batch();
-	__xen_write_cr3(true, __pa(init_level4_pgt));
-	xen_mc_issue(PARAVIRT_LAZY_CPU);
+		/*
+		 * At this stage there can be no user pgd, and no page
+		 * structure to attach it to, so make sure we just set kernel
+		 * pgd.
+		 */
+		xen_mc_batch();
+		__xen_write_cr3(true, __pa(init_level4_pgt));
+		xen_mc_issue(PARAVIRT_LAZY_CPU);
+	} else
+		native_write_cr3(__pa(init_level4_pgt));
 
 	/* We can't that easily rip out L3 and L2, as the Xen pagetables are
 	 * set out this way: [L4], [L1], [L2], [L3], [L1], [L1] ...  for
@@ -2107,6 +2115,9 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 
 static void __init xen_post_allocator_init(void)
 {
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
 	pv_mmu_ops.set_pte = xen_set_pte;
 	pv_mmu_ops.set_pmd = xen_set_pmd;
 	pv_mmu_ops.set_pud = xen_set_pud;
-- 
1.8.3.1

