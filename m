Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaCDNOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:14:38 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:58374 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757065AbaCDNOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:14:33 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 03/13] x86/mm/pageattr: Always dump the right page table in an oops
Date: Tue,  4 Mar 2014 13:14:11 +0000
Message-Id: <1393938861-16797-4-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Now that we have EFI-specific page tables we need to lookup the pgd when
dumping those page tables, rather than assuming that swapper_pgdir is
the current pgdir.

Remove the double underscore prefix, which is usually reserved for
static functions.

Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/include/asm/pgtable_types.h |  2 ++
 arch/x86/mm/fault.c                  |  7 ++++++-
 arch/x86/mm/pageattr.c               | 12 ++++++++----
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 765a4f52d6cd..4384c560499e 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -381,6 +381,8 @@ static inline void update_page_count(int level, unsigned long pages) { }
  * as a pte too.
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
+extern pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
+				    unsigned int *level);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9d591c895803..b8d278f66095 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -584,8 +584,13 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 
 	if (error_code & PF_INSTR) {
 		unsigned int level;
+		pgd_t *pgd;
+		pte_t *pte;
 
-		pte_t *pte = lookup_address(address, &level);
+		pgd = __va(read_cr3() & PHYSICAL_PAGE_MASK);
+		pgd += pgd_index(address);
+
+		pte = lookup_address_in_pgd(pgd, address, &level);
 
 		if (pte && pte_present(*pte) && !pte_exec(*pte))
 			printk(nx_warning, from_kuid(&init_user_ns, current_uid()));
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a3488689e301..1585da3b9b85 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -323,8 +323,12 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	return prot;
 }
 
-static pte_t *__lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
-				      unsigned int *level)
+/*
+ * Lookup the page table entry for a virtual address in a specific pgd.
+ * Return a pointer to the entry and the level of the mapping.
+ */
+pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
+			     unsigned int *level)
 {
 	pud_t *pud;
 	pmd_t *pmd;
@@ -365,7 +369,7 @@ static pte_t *__lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
  */
 pte_t *lookup_address(unsigned long address, unsigned int *level)
 {
-        return __lookup_address_in_pgd(pgd_offset_k(address), address, level);
+        return lookup_address_in_pgd(pgd_offset_k(address), address, level);
 }
 EXPORT_SYMBOL_GPL(lookup_address);
 
@@ -373,7 +377,7 @@ static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
 				  unsigned int *level)
 {
         if (cpa->pgd)
-		return __lookup_address_in_pgd(cpa->pgd + pgd_index(address),
+		return lookup_address_in_pgd(cpa->pgd + pgd_index(address),
 					       address, level);
 
         return lookup_address(address, level);
-- 
1.8.5.3

