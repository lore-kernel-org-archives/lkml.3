Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab3EYE3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 00:29:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:48200 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab3EYE3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 00:29:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,738,1363158000"; 
   d="scan'208";a="342907288"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, lkp@linux.intel.com,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "For 3.9+" <stable@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, mm: fix boot hang regression
Date: Sat, 25 May 2013 12:30:01 +0800
Message-Id: <1369456201-24910-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8d57470d introduced a kernel panic while setting mem=2G at
boot time, and commit c9b3234a6 turns the the kernel panic to hang.

While, the reason is the same: the are accessing a BAD address; I mean
the mapping is broken.

Here is a mem mapping range dumped at boot time:
    [mem 0x00000000-0x000fffff] page 4k  (0)
    [mem 0x7fe00000-0x7fffffff] page 1G  (1)
    [mem 0x7c000000-0x7fdfffff] page 1G  (2)
    [mem 0x00100000-0x001fffff] page 4k  (3)
    [mem 0x00200000-0x7bffffff] page 2M  (4)

Where, we met no problems while setting memory map for region (0) to
(3). But we have set PG_LEVEL_1G mapping for pud index 0x1 at (1).

And pud index comes to 0x1 as well while setting 0x40000000-0x7bf00000
part of (4). What's more, it's PG_LEVEL_2M mapping, which results to a
splitting of PG_LEVEL_1G mapping. This breaks former mapping for (1) and
(2). In the same time, due to "end" setting to 0x7c000000, we missed the
chance to fix it at phys_pmd_init() for code:
	if (address >= end) {
		....
		continue;
	}

Thus, using a extra flag to indicate we are splitting a large PUD(or PMD)
and changing the above if statement to following will make this issue gone:
	if(address >= end && !spliting) {
		...
	}

Reported-by: LKP <lkp@linux.intel.com>
CC: For 3.9+ <stable@vger.kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Bisected-by: "Xie, ChanglongX" <changlongx.xie@intel.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>

---
I reported this panic regression long time ago, and I didn't notic the above
panic->hang change before, which might confuse Yinghai for understanding
what happened from 2 logs I sent before(one is from 8d57470d, another is
from the HEAD commit at that time, which turn to a hang as stated). 
More, it seems that Yinghai can't produce it. And I was busying at
something else. And I finally got a day yesterday(and a good mood ;).

Last, Thanks Changlong's effort for bisecting the 2 above commit.
---
 arch/x86/mm/init_64.c |   51 +++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index bb00c46..e4c7038 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -401,7 +401,7 @@ void __init cleanup_highmap(void)
 
 static unsigned long __meminit
 phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
-	      pgprot_t prot)
+	      pgprot_t prot, bool split_pmd)
 {
 	unsigned long pages = 0, next;
 	unsigned long last_map_addr = end;
@@ -411,7 +411,7 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 
 	for (i = pte_index(addr); i < PTRS_PER_PTE; i++, addr = next, pte++) {
 		next = (addr & PAGE_MASK) + PAGE_SIZE;
-		if (addr >= end) {
+		if (addr >= end && !split_pmd) {
 			if (!after_bootmem &&
 			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RAM) &&
 			    !e820_any_mapped(addr & PAGE_MASK, next, E820_RESERVED_KERN))
@@ -446,7 +446,7 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 
 static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
-	      unsigned long page_size_mask, pgprot_t prot)
+	      unsigned long page_size_mask, pgprot_t prot, bool split_pud)
 {
 	unsigned long pages = 0, next;
 	unsigned long last_map_addr = end;
@@ -457,9 +457,10 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		pmd_t *pmd = pmd_page + pmd_index(address);
 		pte_t *pte;
 		pgprot_t new_prot = prot;
+		bool split_pmd = false;
 
 		next = (address & PMD_MASK) + PMD_SIZE;
-		if (address >= end) {
+		if (address >= end && !split_pud) {
 			if (!after_bootmem &&
 			    !e820_any_mapped(address & PMD_MASK, next, E820_RAM) &&
 			    !e820_any_mapped(address & PMD_MASK, next, E820_RESERVED_KERN))
@@ -472,7 +473,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 				spin_lock(&init_mm.page_table_lock);
 				pte = (pte_t *)pmd_page_vaddr(*pmd);
 				last_map_addr = phys_pte_init(pte, address,
-								end, prot);
+							end, prot, split_pmd);
 				spin_unlock(&init_mm.page_table_lock);
 				continue;
 			}
@@ -495,6 +496,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 				continue;
 			}
 			new_prot = pte_pgprot(pte_clrhuge(*(pte_t *)pmd));
+			split_pmd = true;
 		}
 
 		if (page_size_mask & (1<<PG_LEVEL_2M)) {
@@ -509,7 +511,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		}
 
 		pte = alloc_low_page();
-		last_map_addr = phys_pte_init(pte, address, end, new_prot);
+		last_map_addr = phys_pte_init(pte, address, end,
+					      new_prot, split_pmd);
 
 		spin_lock(&init_mm.page_table_lock);
 		pmd_populate_kernel(&init_mm, pmd, pte);
@@ -531,6 +534,7 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		pud_t *pud = pud_page + pud_index(addr);
 		pmd_t *pmd;
 		pgprot_t prot = PAGE_KERNEL;
+		bool split_pud = false;
 
 		next = (addr & PUD_MASK) + PUD_SIZE;
 		if (addr >= end) {
@@ -545,7 +549,8 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			if (!pud_large(*pud)) {
 				pmd = pmd_offset(pud, 0);
 				last_map_addr = phys_pmd_init(pmd, addr, end,
-							 page_size_mask, prot);
+							 page_size_mask, prot,
+							 split_pud);
 				__flush_tlb_all();
 				continue;
 			}
@@ -568,6 +573,36 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 				continue;
 			}
 			prot = pte_pgprot(pte_clrhuge(*(pte_t *)pud));
+			/*
+			 * We set page table in top-down now, which means we
+			 * might have set a PG_LEVEL_1G mapping for a higher
+			 * address.
+			 *
+			 * And in the meantime, here we meet the same PUD in
+			 * a lower mem region and we are about to split it.
+			 * Setting split_pud to make sure we will re-map
+			 * former mapping as well.  Or, we will just ignore
+			 * it due to
+			 *     if (address >= end) {
+			 *     	       ...
+			 *     	       continue;
+			 *     }
+			 * at phys_pmd_init().
+			 *
+			 * Example: here is one case I met:
+			 *     [mem 0x00000000-0x000fffff] page 4k  (0)
+			 *     [mem 0x7fe00000-0x7fffffff] page 1G  (1)
+			 *     [mem 0x7c000000-0x7fdfffff] page 1G  (2)
+			 *     [mem 0x00100000-0x001fffff] page 4k  (3)
+			 *     [mem 0x00200000-0x7bffffff] page 2M  (4)
+			 *
+			 * Where mem 0x400000000 to mem 0x7fffffff will use same
+			 * PUD, and we have set a PG_LEVEL_1G mapping at (1).
+			 * While handling 0x40000000 - 0x7bf00000 part of (4),
+			 * we will split PUD and break former mapping for (1)
+			 * and (2) as stated above.
+			 */
+			split_pud = true;
 		}
 
 		if (page_size_mask & (1<<PG_LEVEL_1G)) {
@@ -583,7 +618,7 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 
 		pmd = alloc_low_page();
 		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask,
-					      prot);
+					      prot, split_pud);
 
 		spin_lock(&init_mm.page_table_lock);
 		pud_populate(&init_mm, pud, pmd);
-- 
1.7.7.6

