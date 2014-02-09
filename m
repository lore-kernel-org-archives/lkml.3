Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaBIWTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:19:08 -0500
Received: from smtp.outflux.net ([198.145.64.163]:42710 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbaBIWTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:19:06 -0500
Date: Sun, 9 Feb 2014 14:18:26 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Steven Capper <steve.capper@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Cyril Chemparathy <cyril@ti.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mm: report both sections from PMD
Message-ID: <20140209221826.GA30556@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2-level page table systems, the PMD has 2 section entries. Report
these, otherwise ARM_PTDUMP will miss reporting permission changes on
odd section boundaries.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/pgtable-3level.h |    4 ----
 arch/arm/include/asm/pgtable.h        |    4 ++++
 arch/arm/mm/dump.c                    |    3 +++
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index 03243f7eeddf..fb3de59ee811 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -138,10 +138,6 @@
 #define pud_none(pud)		(!pud_val(pud))
 #define pud_bad(pud)		(!(pud_val(pud) & 2))
 #define pud_present(pud)	(pud_val(pud))
-#define pmd_table(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
-						 PMD_TYPE_TABLE)
-#define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
-						 PMD_TYPE_SECT)
 #define pmd_large(pmd)		pmd_sect(pmd)
 
 #define pud_clear(pudp)			\
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 7d59b524f2af..934aa5b60c7c 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -183,6 +183,10 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
 #define pmd_none(pmd)		(!pmd_val(pmd))
 #define pmd_present(pmd)	(pmd_val(pmd))
+#define pmd_table(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
+						 PMD_TYPE_TABLE)
+#define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
+						 PMD_TYPE_SECT)
 
 static inline pte_t *pmd_page_vaddr(pmd_t pmd)
 {
diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index 1f7b1e13d945..ff1559f9200c 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -264,6 +264,9 @@ static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start)
 			note_page(st, addr, 3, pmd_val(*pmd));
 		else
 			walk_pte(st, pmd, addr);
+
+		if (SECTION_SIZE < PMD_SIZE && pmd_sect(*pmd))
+			note_page(st, addr + SECTION_SIZE, 3, pmd_val(pmd[1]));
 	}
 }
 
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
