Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423046AbaDKQV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:21:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759679AbaDKQJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>, Toshi Kani <toshi.kani@hp.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 3.14 03/23] x86, pageattr: Export page unmapping interface
Date: Fri, 11 Apr 2014 09:11:52 -0700
Message-Id: <20140411161200.707561283@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411161200.236939691@linuxfoundation.org>
References: <20140411161200.236939691@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@suse.de>

commit 42a5477251f0e0f33ad5f6a95c48d685ec03191e upstream.

We will use it in efi so expose it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/pgtable_types.h |    2 +
 arch/x86/mm/pageattr.c               |   44 ++++++++++++++++++++++++-----------
 2 files changed, 33 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -385,6 +385,8 @@ extern pte_t *lookup_address(unsigned lo
 extern phys_addr_t slow_virt_to_phys(void *__address);
 extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags);
+void kernel_unmap_pages_in_pgd(pgd_t *root, unsigned long address,
+			       unsigned numpages);
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_DEFS_H */
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -692,6 +692,18 @@ static bool try_to_free_pmd_page(pmd_t *
 	return true;
 }
 
+static bool try_to_free_pud_page(pud_t *pud)
+{
+	int i;
+
+	for (i = 0; i < PTRS_PER_PUD; i++)
+		if (!pud_none(pud[i]))
+			return false;
+
+	free_page((unsigned long)pud);
+	return true;
+}
+
 static bool unmap_pte_range(pmd_t *pmd, unsigned long start, unsigned long end)
 {
 	pte_t *pte = pte_offset_kernel(pmd, start);
@@ -805,6 +817,16 @@ static void unmap_pud_range(pgd_t *pgd,
 	 */
 }
 
+static void unmap_pgd_range(pgd_t *root, unsigned long addr, unsigned long end)
+{
+	pgd_t *pgd_entry = root + pgd_index(addr);
+
+	unmap_pud_range(pgd_entry, addr, end);
+
+	if (try_to_free_pud_page((pud_t *)pgd_page_vaddr(*pgd_entry)))
+		pgd_clear(pgd_entry);
+}
+
 static int alloc_pte_page(pmd_t *pmd)
 {
 	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
@@ -999,9 +1021,8 @@ static int populate_pud(struct cpa_data
 static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 {
 	pgprot_t pgprot = __pgprot(_KERNPG_TABLE);
-	bool allocd_pgd = false;
-	pgd_t *pgd_entry;
 	pud_t *pud = NULL;	/* shut up gcc */
+	pgd_t *pgd_entry;
 	int ret;
 
 	pgd_entry = cpa->pgd + pgd_index(addr);
@@ -1015,7 +1036,6 @@ static int populate_pgd(struct cpa_data
 			return -1;
 
 		set_pgd(pgd_entry, __pgd(__pa(pud) | _KERNPG_TABLE));
-		allocd_pgd = true;
 	}
 
 	pgprot_val(pgprot) &= ~pgprot_val(cpa->mask_clr);
@@ -1023,19 +1043,11 @@ static int populate_pgd(struct cpa_data
 
 	ret = populate_pud(cpa, addr, pgd_entry, pgprot);
 	if (ret < 0) {
-		unmap_pud_range(pgd_entry, addr,
+		unmap_pgd_range(cpa->pgd, addr,
 				addr + (cpa->numpages << PAGE_SHIFT));
-
-		if (allocd_pgd) {
-			/*
-			 * If I allocated this PUD page, I can just as well
-			 * free it in this error path.
-			 */
-			pgd_clear(pgd_entry);
-			free_page((unsigned long)pud);
-		}
 		return ret;
 	}
+
 	cpa->numpages = ret;
 	return 0;
 }
@@ -1861,6 +1873,12 @@ out:
 	return retval;
 }
 
+void kernel_unmap_pages_in_pgd(pgd_t *root, unsigned long address,
+			       unsigned numpages)
+{
+	unmap_pgd_range(root, address, address + (numpages << PAGE_SHIFT));
+}
+
 /*
  * The testcases use internal knowledge of the implementation that shouldn't
  * be exposed to the rest of the kernel. Include these directly here.


