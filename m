Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab3LMCLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:11:13 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:43164 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3LMCKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:10:46 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        george.dunlap@eu.citrix.com, ian.jackson@eu.citrix.com,
        mukesh.rathor@oracle.com, tim@xen.org, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Alexander Duyck <alexander.h.duyck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH V10 08/14] x86/xen: Use __pa_symbol instead of __pa on C visible symbols
Date: Thu, 12 Dec 2013 21:10:15 -0500
Message-Id: <1386900621-27528-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@intel.com>

This change updates a few of the functions to use __pa_symbol when
translating C visible symbols instead of __pa.  By using __pa_symbol we are
able to drop a few extra lines of code as don't have to test to see if the
virtual pointer is a part of the kernel text or just standard virtual memory.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e334134..1d1fbdb 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1508,7 +1508,8 @@ static int xen_pgd_alloc(struct mm_struct *mm)
 
 		if (user_pgd != NULL) {
 			user_pgd[pgd_index(VSYSCALL_START)] =
-				__pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
+				__pgd(__pa_symbol(level3_user_vsyscall) |
+				      _PAGE_TABLE);
 			ret = 0;
 		}
 
@@ -1971,10 +1972,10 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	 * pgd.
 	 */
 	if (xen_feature(XENFEAT_writable_page_tables)) {
-		native_write_cr3(__pa(init_level4_pgt));
+		native_write_cr3(__pa_symbol(init_level4_pgt));
 	} else {
 		xen_mc_batch();
-		__xen_write_cr3(true, __pa(init_level4_pgt));
+		__xen_write_cr3(true, __pa_symbol(init_level4_pgt));
 		xen_mc_issue(PARAVIRT_LAZY_CPU);
 	}
 	/* We can't that easily rip out L3 and L2, as the Xen pagetables are
@@ -1997,10 +1998,10 @@ static RESERVE_BRK_ARRAY(pmd_t, swapper_kernel_pmd, PTRS_PER_PMD);
 
 static void __init xen_write_cr3_init(unsigned long cr3)
 {
-	unsigned long pfn = PFN_DOWN(__pa(swapper_pg_dir));
+	unsigned long pfn = PFN_DOWN(__pa_symbol(swapper_pg_dir));
 
-	BUG_ON(read_cr3() != __pa(initial_page_table));
-	BUG_ON(cr3 != __pa(swapper_pg_dir));
+	BUG_ON(read_cr3() != __pa_symbol(initial_page_table));
+	BUG_ON(cr3 != __pa_symbol(swapper_pg_dir));
 
 	/*
 	 * We are switching to swapper_pg_dir for the first time (from
@@ -2024,7 +2025,7 @@ static void __init xen_write_cr3_init(unsigned long cr3)
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, pfn);
 
 	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE,
-			  PFN_DOWN(__pa(initial_page_table)));
+			  PFN_DOWN(__pa_symbol(initial_page_table)));
 	set_page_prot(initial_page_table, PAGE_KERNEL);
 	set_page_prot(initial_kernel_pmd, PAGE_KERNEL);
 
@@ -2049,7 +2050,7 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 
 	copy_page(initial_page_table, pgd);
 	initial_page_table[KERNEL_PGD_BOUNDARY] =
-		__pgd(__pa(initial_kernel_pmd) | _PAGE_PRESENT);
+		__pgd(__pa_symbol(initial_kernel_pmd) | _PAGE_PRESENT);
 
 	set_page_prot(initial_kernel_pmd, PAGE_KERNEL_RO);
 	set_page_prot(initial_page_table, PAGE_KERNEL_RO);
@@ -2058,8 +2059,8 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
 	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(pgd)));
 
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE,
-			  PFN_DOWN(__pa(initial_page_table)));
-	xen_write_cr3(__pa(initial_page_table));
+			  PFN_DOWN(__pa_symbol(initial_page_table)));
+	xen_write_cr3(__pa_symbol(initial_page_table));
 
 	memblock_reserve(__pa(xen_start_info->pt_base),
 			 xen_start_info->nr_pt_frames * PAGE_SIZE);
-- 
1.7.7.6

