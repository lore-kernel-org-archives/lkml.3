Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaLIH1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:27:07 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56928 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaLIH1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:27:04 -0500
From: zhichang.yuan@linaro.org
To: Catalin.Marinas@arm.com, will.deacon@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, liguozhu@huawei.com, dsaxena@linaro.org,
        "zhichang.yuan" <zhichang.yuan@linaro.org>
Subject: [PATCHv2] arm64:mm: free the useless initial page table
Date: Tue,  9 Dec 2014 15:26:47 +0800
Message-Id: <1418110007-13270-1-git-send-email-zhichang.yuan@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhichang.yuan" <zhichang.yuan@linaro.org>

For 64K page system, after mapping a PMD section, the corresponding initial
page table is not needed any more. That page can be freed.

Changes since v1:

* make consistent code between alloc_init_pmd and alloc_init_pud;
* flush the TLB before the unused page table is freed;

Signed-off-by: Zhichang Yuan <zhichang.yuan@linaro.org>
---
 arch/arm64/include/asm/pgtable.h |    3 +++
 arch/arm64/mm/mmu.c              |   15 ++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 41a43bf..8a135b6 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -337,9 +337,12 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 
 #ifdef CONFIG_ARM64_64K_PAGES
 #define pud_sect(pud)		(0)
+#define pud_table(pud)		(1)
 #else
 #define pud_sect(pud)		((pud_val(pud) & PUD_TYPE_MASK) == \
 				 PUD_TYPE_SECT)
+#define pud_table(pud)		((pud_val(pud) & PUD_TYPE_MASK) == \
+					PUD_TYPE_TABLE)
 #endif
 
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index f4f8b50..515f75b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -191,8 +191,14 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 			 * Check for previous table entries created during
 			 * boot (__create_page_tables) and flush them.
 			 */
-			if (!pmd_none(old_pmd))
+			if (!pmd_none(old_pmd)) {
 				flush_tlb_all();
+				if (pmd_table(old_pmd)) {
+					phys_addr_t table = __pa(pte_offset_map(&old_pmd, 0));
+
+					memblock_free(table, PAGE_SIZE);
+				}
+			}
 		} else {
 			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys),
 				       prot_pte);
@@ -234,9 +240,12 @@ static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
 			 * Look up the old pmd table and free it.
 			 */
 			if (!pud_none(old_pud)) {
-				phys_addr_t table = __pa(pmd_offset(&old_pud, 0));
-				memblock_free(table, PAGE_SIZE);
 				flush_tlb_all();
+				if (pud_table(old_pud)) {
+					phys_addr_t table = __pa(pmd_offset(&old_pud, 0));
+
+					memblock_free(table, PAGE_SIZE);
+				}
 			}
 		} else {
 			alloc_init_pmd(pud, addr, next, phys, map_io);
-- 
1.7.9.5

