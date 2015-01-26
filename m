Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbbAZXaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:30:09 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:54945 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390AbbAZXaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:30:03 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, arnd@arndb.de, linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 4/7] mm: Change vunmap to tear down huge KVA mappings
Date: Mon, 26 Jan 2015 16:13:26 -0700
Message-Id: <1422314009-31667-5-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
References: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change vunmap_pmd_range() and vunmap_pud_range() to tear down
huge KVA mappings when they are set.

These changes are only enabled when CONFIG_HAVE_ARCH_HUGE_VMAP
is defined.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 include/asm-generic/pgtable.h |    4 ++++
 mm/vmalloc.c                  |    4 ++++
 2 files changed, 8 insertions(+)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 7dc3838..1204ea6 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -850,9 +850,13 @@ static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
 void pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot);
 void pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot);
+int pud_clear_huge(pud_t *pud);
+int pmd_clear_huge(pmd_t *pmd);
 #else	/* !CONFIG_HAVE_ARCH_HUGE_VMAP */
 static inline void pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot) { }
 static inline void pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot) { }
+static inline int pud_clear_huge(pud_t *pud) { return 0; }
+static inline int pmd_clear_huge(pmd_t *pmd) { return 0; }
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMAP */
 
 #endif /* _ASM_GENERIC_PGTABLE_H */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 830a4be..c9490fe 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -75,6 +75,8 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end)
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
+		if (pmd_clear_huge(pmd))
+			continue;
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		vunmap_pte_range(pmd, addr, next);
@@ -89,6 +91,8 @@ static void vunmap_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end)
 	pud = pud_offset(pgd, addr);
 	do {
 		next = pud_addr_end(addr, end);
+		if (pud_clear_huge(pud))
+			continue;
 		if (pud_none_or_clear_bad(pud))
 			continue;
 		vunmap_pmd_range(pud, addr, next);
