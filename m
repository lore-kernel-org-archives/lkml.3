Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbbAZXbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:31:13 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:54947 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbbAZXaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:30:04 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, arnd@arndb.de, linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 5/7] x86, mm: Support huge KVA mappings on x86
Date: Mon, 26 Jan 2015 16:13:27 -0700
Message-Id: <1422314009-31667-6-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
References: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement huge KVA mapping interfaces and select
CONFIG_HAVE_ARCH_HUGE_VMAP on x86.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/Kconfig      |    1 +
 arch/x86/mm/pgtable.c |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0dc9d01..8150038 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -97,6 +97,7 @@ config X86
 	select IRQ_FORCED_THREADING
 	select HAVE_BPF_JIT if X86_64
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	select HAVE_ARCH_HUGE_VMAP
 	select ARCH_HAS_SG_CHAIN
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 6fb6927..e113d69 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -481,3 +481,35 @@ void native_set_fixmap(enum fixed_addresses idx, phys_addr_t phys,
 {
 	__native_set_fixmap(idx, pfn_pte(phys >> PAGE_SHIFT, flags));
 }
+
+void pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
+{
+	set_pte((pte_t *)pud, pfn_pte(
+		(u64)addr >> PAGE_SHIFT,
+		__pgprot(pgprot_val(prot) | _PAGE_PSE)));
+}
+
+void pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
+{
+	set_pte((pte_t *)pmd, pfn_pte(
+		(u64)addr >> PAGE_SHIFT,
+		__pgprot(pgprot_val(prot) | _PAGE_PSE)));
+}
+
+int pud_clear_huge(pud_t *pud)
+{
+	if (pud_large(*pud)) {
+		pud_clear(pud);
+		return 1;
+	}
+	return 0;
+}
+
+int pmd_clear_huge(pmd_t *pmd)
+{
+	if (pmd_large(*pmd)) {
+		pmd_clear(pmd);
+		return 1;
+	}
+	return 0;
+}
