Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbaCEOYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:24:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40716 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbaCEOY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoffer Dall <christoffer.dall@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 006/131] ARM: 7950/1: mm: Fix stage-2 device memory attributes
Date: Wed,  5 Mar 2014 14:22:10 +0000
Message-Id: <1394029455-23128-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Dall <christoffer.dall@linaro.org>

commit 4d9c5b89cf3605bbc39c6e274351ff25f0d83e6a upstream.

The stage-2 memory attributes are distinct from the Hyp memory
attributes and the Stage-1 memory attributes.  We were using the stage-1
memory attributes for stage-2 mappings causing device mappings to be
mapped as normal memory.  Add the S2 equivalent defines for memory
attributes and fix the comments explaining the defines while at it.

Add a prot_pte_s2 field to the mem_type struct and fill out the field
for device mappings accordingly.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/include/asm/pgtable-3level.h | 15 ++++++++++-----
 arch/arm/mm/mm.h                      |  1 +
 arch/arm/mm/mmu.c                     |  7 ++++++-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index 5689c18..d4f7814 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -120,11 +120,16 @@
 /*
  * 2nd stage PTE definitions for LPAE.
  */
-#define L_PTE_S2_MT_UNCACHED	 (_AT(pteval_t, 0x5) << 2) /* MemAttr[3:0] */
-#define L_PTE_S2_MT_WRITETHROUGH (_AT(pteval_t, 0xa) << 2) /* MemAttr[3:0] */
-#define L_PTE_S2_MT_WRITEBACK	 (_AT(pteval_t, 0xf) << 2) /* MemAttr[3:0] */
-#define L_PTE_S2_RDONLY		 (_AT(pteval_t, 1) << 6)   /* HAP[1]   */
-#define L_PTE_S2_RDWR		 (_AT(pteval_t, 3) << 6)   /* HAP[2:1] */
+#define L_PTE_S2_MT_UNCACHED		(_AT(pteval_t, 0x0) << 2) /* strongly ordered */
+#define L_PTE_S2_MT_WRITETHROUGH	(_AT(pteval_t, 0xa) << 2) /* normal inner write-through */
+#define L_PTE_S2_MT_WRITEBACK		(_AT(pteval_t, 0xf) << 2) /* normal inner write-back */
+#define L_PTE_S2_MT_DEV_SHARED		(_AT(pteval_t, 0x1) << 2) /* device */
+#define L_PTE_S2_MT_MASK		(_AT(pteval_t, 0xf) << 2)
+
+#define L_PTE_S2_RDONLY			(_AT(pteval_t, 1) << 6)   /* HAP[1]   */
+#define L_PTE_S2_RDWR			(_AT(pteval_t, 3) << 6)   /* HAP[2:1] */
+
+#define L_PMD_S2_RDWR			(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
 
 /*
  * Hyp-mode PL2 PTE definitions for LPAE.
diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
index d5a4e9a..33eab61 100644
--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -38,6 +38,7 @@ static inline pmd_t *pmd_off_k(unsigned long virt)
 
 struct mem_type {
 	pteval_t prot_pte;
+	pteval_t prot_pte_s2;
 	pmdval_t prot_l1;
 	pmdval_t prot_sect;
 	unsigned int domain;
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 53cdbd3..c3b41f8 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -229,12 +229,16 @@ __setup("noalign", noalign_setup);
 #endif /* ifdef CONFIG_CPU_CP15 / else */
 
 #define PROT_PTE_DEVICE		L_PTE_PRESENT|L_PTE_YOUNG|L_PTE_DIRTY|L_PTE_XN
+#define PROT_PTE_S2_DEVICE	PROT_PTE_DEVICE
 #define PROT_SECT_DEVICE	PMD_TYPE_SECT|PMD_SECT_AP_WRITE
 
 static struct mem_type mem_types[] = {
 	[MT_DEVICE] = {		  /* Strongly ordered / ARMv6 shared device */
 		.prot_pte	= PROT_PTE_DEVICE | L_PTE_MT_DEV_SHARED |
 				  L_PTE_SHARED,
+		.prot_pte_s2	= s2_policy(PROT_PTE_S2_DEVICE) |
+				  s2_policy(L_PTE_S2_MT_DEV_SHARED) |
+				  L_PTE_SHARED,
 		.prot_l1	= PMD_TYPE_TABLE,
 		.prot_sect	= PROT_SECT_DEVICE | PMD_SECT_S,
 		.domain		= DOMAIN_IO,
@@ -456,7 +460,8 @@ static void __init build_mem_type_table(void)
 	cp = &cache_policies[cachepolicy];
 	vecs_pgprot = kern_pgprot = user_pgprot = cp->pte;
 	s2_pgprot = cp->pte_s2;
-	hyp_device_pgprot = s2_device_pgprot = mem_types[MT_DEVICE].prot_pte;
+	hyp_device_pgprot = mem_types[MT_DEVICE].prot_pte;
+	s2_device_pgprot = mem_types[MT_DEVICE].prot_pte_s2;
 
 	/*
 	 * ARMv6 and above have extended page tables.
-- 
1.9.0

