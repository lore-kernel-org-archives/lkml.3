Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaLOO4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:56:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38584 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaLOO2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Capper <steve.capper@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Hou Pengyang <houpengyang@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 071/168] ARM: 8108/1: mm: Introduce {pte,pmd}_isset and {pte,pmd}_isclear
Date: Mon, 15 Dec 2014 14:25:25 +0000
Message-Id: <1418653622-21105-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Capper <steve.capper@linaro.org>

commit f2950706871c4b6e8c0f0d7c3f62d35930b8de63 upstream.

Long descriptors on ARM are 64 bits, and some pte functions such as
pte_dirty return a bitwise-and of a flag with the pte value. If the
flag to be tested resides in the upper 32 bits of the pte, then we run
into the danger of the result being dropped if downcast.

For example:
	gather_stats(page, md, pte_dirty(*pte), 1);
where pte_dirty(*pte) is downcast to an int.

This patch introduces a new macro pte_isset which performs the bitwise
and, then performs a double logical invert (where needed) to ensure
predictable downcasting. The logical inverse pte_isclear is also
introduced.

Equivalent pmd functions for Transparent HugePages have also been
added.

Signed-off-by: Steve Capper <steve.capper@linaro.org>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Hou Pengyang <houpengyang@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/include/asm/pgtable-3level.h | 12 ++++++++----
 arch/arm/include/asm/pgtable.h        | 18 +++++++++++-------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index 85c60adc8b60..34f371c4bbb2 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -207,17 +207,21 @@ static inline pmd_t *pmd_offset(pud_t *pud, unsigned long addr)
 #define pte_huge(pte)		(pte_val(pte) && !(pte_val(pte) & PTE_TABLE_BIT))
 #define pte_mkhuge(pte)		(__pte(pte_val(pte) & ~PTE_TABLE_BIT))
 
-#define pmd_young(pmd)		(pmd_val(pmd) & PMD_SECT_AF)
+#define pmd_isset(pmd, val)	((u32)(val) == (val) ? pmd_val(pmd) & (val) \
+						: !!(pmd_val(pmd) & (val)))
+#define pmd_isclear(pmd, val)	(!(pmd_val(pmd) & (val)))
+
+#define pmd_young(pmd)		(pmd_isset((pmd), PMD_SECT_AF))
 
 #define __HAVE_ARCH_PMD_WRITE
-#define pmd_write(pmd)		(!(pmd_val(pmd) & PMD_SECT_RDONLY))
+#define pmd_write(pmd)		(pmd_isclear((pmd), PMD_SECT_RDONLY))
 
 #define pmd_hugewillfault(pmd)	(!pmd_young(pmd) || !pmd_write(pmd))
 #define pmd_thp_or_huge(pmd)	(pmd_huge(pmd) || pmd_trans_huge(pmd))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define pmd_trans_huge(pmd)	(pmd_val(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT))
-#define pmd_trans_splitting(pmd) (pmd_val(pmd) & PMD_SECT_SPLITTING)
+#define pmd_trans_huge(pmd)	(pmd_val(pmd) && !pmd_table(pmd))
+#define pmd_trans_splitting(pmd) (pmd_isset((pmd), PMD_SECT_SPLITTING))
 #endif
 
 #define PMD_BIT_FUNC(fn,op) \
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 5478e5d6ad89..01baef07cd0c 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -214,18 +214,22 @@ static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 
 #define pte_clear(mm,addr,ptep)	set_pte_ext(ptep, __pte(0), 0)
 
+#define pte_isset(pte, val)	((u32)(val) == (val) ? pte_val(pte) & (val) \
+						: !!(pte_val(pte) & (val)))
+#define pte_isclear(pte, val)	(!(pte_val(pte) & (val)))
+
 #define pte_none(pte)		(!pte_val(pte))
-#define pte_present(pte)	(pte_val(pte) & L_PTE_PRESENT)
-#define pte_valid(pte)		(pte_val(pte) & L_PTE_VALID)
+#define pte_present(pte)	(pte_isset((pte), L_PTE_PRESENT))
+#define pte_valid(pte)		(pte_isset((pte), L_PTE_VALID))
 #define pte_accessible(mm, pte)	(mm_tlb_flush_pending(mm) ? pte_present(pte) : pte_valid(pte))
-#define pte_write(pte)		(!(pte_val(pte) & L_PTE_RDONLY))
-#define pte_dirty(pte)		(pte_val(pte) & L_PTE_DIRTY)
-#define pte_young(pte)		(pte_val(pte) & L_PTE_YOUNG)
-#define pte_exec(pte)		(!(pte_val(pte) & L_PTE_XN))
+#define pte_write(pte)		(pte_isclear((pte), L_PTE_RDONLY))
+#define pte_dirty(pte)		(pte_isset((pte), L_PTE_DIRTY))
+#define pte_young(pte)		(pte_isset((pte), L_PTE_YOUNG))
+#define pte_exec(pte)		(pte_isclear((pte), L_PTE_XN))
 #define pte_special(pte)	(0)
 
 #define pte_valid_user(pte)	\
-	(pte_valid(pte) && (pte_val(pte) & L_PTE_USER) && pte_young(pte))
+	(pte_valid(pte) && pte_isset((pte), L_PTE_USER) && pte_young(pte))
 
 #if __LINUX_ARM_ARCH__ < 6
 static inline void __sync_icache_dcache(pte_t pteval)
-- 
2.1.3

