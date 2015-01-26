Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbbAZXaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:30:06 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57120 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbbAZXaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:30:02 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, arnd@arndb.de, linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 3/7] mm: Change ioremap to set up huge I/O mappings
Date: Mon, 26 Jan 2015 16:13:25 -0700
Message-Id: <1422314009-31667-4-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
References: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change ioremap_pud_range() and ioremap_pmd_range() to set up
huge I/O mappings when their capability is enabled and their
conditions are met in a given request -- both virtual & physical
addresses are aligned and its range fufills the mapping size.

These changes are only enabled when both CONFIG_HUGE_IOMAP
and CONFIG_HAVE_ARCH_HUGE_VMAP are defined.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/Kconfig                  |    3 +++
 include/asm-generic/pgtable.h |    8 ++++++++
 lib/ioremap.c                 |   16 ++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 05d7a8a..55c4440 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -446,6 +446,9 @@ config HAVE_IRQ_TIME_ACCOUNTING
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	bool
 
+config HAVE_ARCH_HUGE_VMAP
+	bool
+
 config HAVE_ARCH_SOFT_DIRTY
 	bool
 
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 177d597..7dc3838 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -847,4 +847,12 @@ static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
 #define io_remap_pfn_range remap_pfn_range
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
+void pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot);
+void pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot);
+#else	/* !CONFIG_HAVE_ARCH_HUGE_VMAP */
+static inline void pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot) { }
+static inline void pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot) { }
+#endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
+
 #endif /* _ASM_GENERIC_PGTABLE_H */
diff --git a/lib/ioremap.c b/lib/ioremap.c
index 0a1ecb6..01b70aa 100644
--- a/lib/ioremap.c
+++ b/lib/ioremap.c
@@ -81,6 +81,14 @@ static inline int ioremap_pmd_range(pud_t *pud, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
+
+		if (ioremap_pmd_enabled() &&
+		    ((next - addr) == PMD_SIZE) &&
+		    !((phys_addr + addr) & (PMD_SIZE-1))) {
+			pmd_set_huge(pmd, phys_addr + addr, prot);
+			continue;
+		}
+
 		if (ioremap_pte_range(pmd, addr, next, phys_addr + addr, prot))
 			return -ENOMEM;
 	} while (pmd++, addr = next, addr != end);
@@ -99,6 +107,14 @@ static inline int ioremap_pud_range(pgd_t *pgd, unsigned long addr,
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
+
+		if (ioremap_pud_enabled() &&
+		    ((next - addr) == PUD_SIZE) &&
+		    !((phys_addr + addr) & (PUD_SIZE-1))) {
+			pud_set_huge(pud, phys_addr + addr, prot);
+			continue;
+		}
+
 		if (ioremap_pmd_range(pud, addr, next, phys_addr + addr, prot))
 			return -ENOMEM;
 	} while (pud++, addr = next, addr != end);
