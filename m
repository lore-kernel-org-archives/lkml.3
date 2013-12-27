Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab3L0E7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 23:59:22 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6273 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3L0E7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 23:59:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Dec 2013 21:00:08 -0800
From: Mark Zhang <markz@nvidia.com>
To: <linux@arm.linux.org.uk>, <steve.capper@linaro.org>, <nico@linaro.org>,
        <ccross@android.com>, <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <lauraa@codeaurora.org>, <akpm@linux-foundation.org>,
        <christoffer.dall@linaro.org>, <viro@zeniv.linux.org.uk>,
        <gregory.clement@free-electrons.com>, <ben-linux@fluff.org>,
        <paul.gortmaker@windriver.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Gary King <gking@nvidia.com>
Subject: [PATCH] arm: mm: add memory type for inner-writeback
Date: Fri, 27 Dec 2013 12:58:48 +0800
Message-ID: <1388120328-17148-1-git-send-email-markz@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

For streaming-style operations (e.g., software rendering of graphics
surfaces shared with non-coherent DMA devices), the cost of performing
L2 cache maintenance can exceed the benefit of having the larger cache
(this is particularly true for OUTER_CACHE configurations like the ARM
PL2x0).

This change uses the currently-unused mapping 5 (TEX[0]=1, C=0, B=1)
in the tex remapping tables as an inner-writeback-write-allocate, outer
non-cacheable memory type, so that this mapping will be available to
clients which will benefit from the reduced L2 maintenance.

Signed-off-by: Gary King <gking@nvidia.com>
---
 arch/arm/include/asm/pgtable-2level.h | 1 +
 arch/arm/include/asm/pgtable.h        | 3 +++
 arch/arm/mm/proc-macros.S             | 2 +-
 arch/arm/mm/proc-v7-2level.S          | 4 ++--
 arch/arm/mm/proc-xsc3.S               | 2 +-
 arch/arm/mm/proc-xscale.S             | 2 +-
 6 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-2level.h b/arch/arm/include/asm/pgtable-2level.h
index dfff709fda3c..528b397b6c91 100644
--- a/arch/arm/include/asm/pgtable-2level.h
+++ b/arch/arm/include/asm/pgtable-2level.h
@@ -141,6 +141,7 @@
 #define L_PTE_MT_DEV_WC		(_AT(pteval_t, 0x09) << 2)	/* 1001 */
 #define L_PTE_MT_DEV_CACHED	(_AT(pteval_t, 0x0b) << 2)	/* 1011 */
 #define L_PTE_MT_MASK		(_AT(pteval_t, 0x0f) << 2)
+#define L_PTE_MT_INNER_WB	(_AT(pteval_t, 0x05) << 2)	/* 0101 (armv6, armv7) */
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 7d59b524f2af..2b0601a9a18e 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -134,6 +134,9 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 	__pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_UNCACHED | L_PTE_XN)
 #endif
 
+#define pgprot_inner_writeback(prot) \
+	__pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_INNER_WB)
+
 #endif /* __ASSEMBLY__ */
 
 /*
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index e3c48a3fe063..fa829840ee16 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -127,7 +127,7 @@
 	.long	PTE_CACHEABLE					@ L_PTE_MT_WRITETHROUGH
 	.long	PTE_CACHEABLE | PTE_BUFFERABLE			@ L_PTE_MT_WRITEBACK
 	.long	PTE_BUFFERABLE					@ L_PTE_MT_DEV_SHARED
-	.long	0x00						@ unused
+	.long	PTE_EXT_TEX(4) | PTE_BUFFERABLE			@ L_PTE_MT_INNER_WB
 	.long	0x00						@ L_PTE_MT_MINICACHE (not present)
 	.long	PTE_EXT_TEX(1) | PTE_CACHEABLE | PTE_BUFFERABLE	@ L_PTE_MT_WRITEALLOC
 	.long	0x00						@ unused
diff --git a/arch/arm/mm/proc-v7-2level.S b/arch/arm/mm/proc-v7-2level.S
index bdd3be4be77a..059a9d7242c2 100644
--- a/arch/arm/mm/proc-v7-2level.S
+++ b/arch/arm/mm/proc-v7-2level.S
@@ -144,8 +144,8 @@ ENDPROC(cpu_v7_set_pte_ext)
 	 *   NS1 = PRRR[19] = 1		- normal shareable property
 	 *   NOS = PRRR[24+n] = 1	- not outer shareable
 	 */
-.equ	PRRR,	0xff0a81a8
-.equ	NMRR,	0x40e040e0
+.equ	PRRR,	0xff0a89a8
+.equ	NMRR,	0x40e044e0
 
 	/*
 	 * Macro for setting up the TTBRx and TTBCR registers.
diff --git a/arch/arm/mm/proc-xsc3.S b/arch/arm/mm/proc-xsc3.S
index dc1645890042..9c374495e778 100644
--- a/arch/arm/mm/proc-xsc3.S
+++ b/arch/arm/mm/proc-xsc3.S
@@ -381,7 +381,7 @@ cpu_xsc3_mt_table:
 	.long	PTE_EXT_TEX(5) | PTE_CACHEABLE			@ L_PTE_MT_WRITETHROUGH
 	.long	PTE_CACHEABLE | PTE_BUFFERABLE			@ L_PTE_MT_WRITEBACK
 	.long	PTE_EXT_TEX(1) | PTE_BUFFERABLE			@ L_PTE_MT_DEV_SHARED
-	.long	0x00						@ unused
+	.long	PTE_EXT_TEX(4) | PTE_BUFFERABLE			@ L_PTE_MT_INNER_WB (not present?)
 	.long	0x00						@ L_PTE_MT_MINICACHE (not present)
 	.long	PTE_EXT_TEX(5) | PTE_CACHEABLE | PTE_BUFFERABLE	@ L_PTE_MT_WRITEALLOC (not present?)
 	.long	0x00						@ unused
diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index d19b1cfcad91..2ac1b88e02ac 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -491,7 +491,7 @@ cpu_xscale_mt_table:
 	.long	PTE_CACHEABLE					@ L_PTE_MT_WRITETHROUGH
 	.long	PTE_CACHEABLE | PTE_BUFFERABLE			@ L_PTE_MT_WRITEBACK
 	.long	PTE_EXT_TEX(1) | PTE_BUFFERABLE			@ L_PTE_MT_DEV_SHARED
-	.long	0x00						@ unused
+	.long	PTE_EXT_TEX(1) | PTE_CACHEABLE | PTE_BUFFERABLE	@ L_PTE_MT_INNER_WB
 	.long	PTE_EXT_TEX(1) | PTE_CACHEABLE			@ L_PTE_MT_MINICACHE
 	.long	PTE_EXT_TEX(1) | PTE_CACHEABLE | PTE_BUFFERABLE	@ L_PTE_MT_WRITEALLOC
 	.long	0x00						@ unused
-- 
1.8.1.5

