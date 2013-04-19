Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968034Ab3DSKsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:48:15 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:21462 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756780Ab3DSKsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:48:13 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zcb8kzc8kzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 01/15] powerpc/85xx: cache operations for Freescale SoCs based on BOOK3E
Date: Fri, 19 Apr 2013 18:47:34 +0800
Message-ID: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These cache operations support Freescale SoCs based on BOOK3E.
Move L1 cache operations to fsl_booke_cache.S in order to maintain
easily. And, add cache operations for backside L2 cache and platform cache.

The backside L2 cache appears on e500mc and e5500 core. The platform cache
supported by this patch is L2 Look-Aside Cache, which appears on SoCs
with e500v1/e500v2 core, such as MPC8572, P1020, etc.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
---
 arch/powerpc/include/asm/cacheflush.h |    8 ++
 arch/powerpc/kernel/Makefile          |    1 +
 arch/powerpc/kernel/fsl_booke_cache.S |  210 +++++++++++++++++++++++++++++++++
 arch/powerpc/kernel/head_fsl_booke.S  |   74 ------------
 4 files changed, 219 insertions(+), 74 deletions(-)
 create mode 100644 arch/powerpc/kernel/fsl_booke_cache.S

diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
index b843e35..bc3f937 100644
--- a/arch/powerpc/include/asm/cacheflush.h
+++ b/arch/powerpc/include/asm/cacheflush.h
@@ -32,6 +32,14 @@ extern void flush_dcache_page(struct page *page);
 
 extern void __flush_disable_L1(void);
 
+#ifdef CONFIG_FSL_SOC_BOOKE
+void flush_dcache_L1(void);
+void flush_backside_L2_cache(void);
+void disable_backside_L2_cache(void);
+void flush_disable_L2(void);
+void invalidate_enable_L2(void);
+#endif
+
 extern void __flush_icache_range(unsigned long, unsigned long);
 static inline void flush_icache_range(unsigned long start, unsigned long stop)
 {
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index f960a79..4acf739 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -87,6 +87,7 @@ extra-$(CONFIG_8xx)		:= head_8xx.o
 extra-y				+= vmlinux.lds
 
 obj-$(CONFIG_RELOCATABLE_PPC32)	+= reloc_32.o
+obj-$(CONFIG_FSL_SOC_BOOKE)	+= fsl_booke_cache.o
 
 obj-$(CONFIG_PPC32)		+= entry_32.o setup_32.o
 obj-$(CONFIG_PPC64)		+= dma-iommu.o iommu.o
diff --git a/arch/powerpc/kernel/fsl_booke_cache.S b/arch/powerpc/kernel/fsl_booke_cache.S
new file mode 100644
index 0000000..232c47b
--- /dev/null
+++ b/arch/powerpc/kernel/fsl_booke_cache.S
@@ -0,0 +1,210 @@
+/*
+ * Copyright 2009-2013 Freescale Semiconductor, Inc.
+ *	Scott Wood <scottwood@freescale.com>
+ *	Dave Liu <daveliu@freescale.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <asm/reg.h>
+#include <asm/page.h>
+#include <asm/ppc_asm.h>
+#include <asm/asm-offsets.h>
+
+	.section .text
+
+/********    L1 Cache    ********/
+
+/* flush L1 d-cache */
+_GLOBAL(flush_dcache_L1)
+	mfspr	r3,SPRN_L1CFG0
+
+	rlwinm	r5,r3,9,3	/* Extract cache block size */
+	twlgti	r5,1		/* Only 32 and 64 byte cache blocks
+				 * are currently defined.
+				 */
+	li	r4,32
+	subfic	r6,r5,2		/* r6 = log2(1KiB / cache block size) -
+				 *      log2(number of ways)
+				 */
+	slw	r5,r4,r5	/* r5 = cache block size */
+
+	rlwinm	r7,r3,0,0xff	/* Extract number of KiB in the cache */
+	mulli	r7,r7,13	/* An 8-way cache will require 13
+				 * loads per set.
+				 */
+	slw	r7,r7,r6
+
+	/* save off HID0 and set DCFA */
+	mfspr	r8,SPRN_HID0
+	ori	r9,r8,HID0_DCFA@l
+	mtspr	SPRN_HID0,r9
+	isync
+
+	LOAD_REG_IMMEDIATE(r4, KERNELBASE)
+	mtctr	r7
+
+1:	lwz	r3,0(r4)	/* Load... */
+	add	r4,r4,r5
+	bdnz	1b
+
+	msync
+	LOAD_REG_IMMEDIATE(r4, KERNELBASE)
+	mtctr	r7
+
+1:	dcbf	0,r4		/* ...and flush. */
+	add	r4,r4,r5
+	bdnz	1b
+
+	/* restore HID0 */
+	mtspr	SPRN_HID0,r8
+	isync
+
+	blr
+
+/* Flush L1 d-cache, invalidate and disable d-cache and i-cache */
+_GLOBAL(__flush_disable_L1)
+	mflr	r10
+	bl	flush_dcache_L1	/* Flush L1 d-cache */
+	mtlr	r10
+
+	msync
+	mfspr	r4, SPRN_L1CSR0	/* Invalidate and disable d-cache */
+	li	r5, 2
+	rlwimi	r4, r5, 0, 3
+
+	msync
+	isync
+	mtspr	SPRN_L1CSR0, r4
+	isync
+
+	msync
+1:	mfspr	r4, SPRN_L1CSR0	/* Wait for the invalidate to finish */
+	andi.	r4, r4, 2
+	bne	1b
+
+	msync
+	mfspr	r4, SPRN_L1CSR1	/* Invalidate and disable i-cache */
+	li	r5, 2
+	rlwimi	r4, r5, 0, 3
+
+	msync
+	isync
+	mtspr	SPRN_L1CSR1, r4
+	isync
+	msync
+
+	blr
+
+/********    Backside L2 Cache    ********/
+
+#define SVR_P2040	0x821000
+
+need_L2_cache:
+	/* skip L2 cache on P2040/P2040E as they have no L2 cache */
+	mfspr	r3, SPRN_SVR
+	/* shift right by 8 bits and clear E bit of SVR */
+	rlwinm	r4, r3, 24, ~0x800
+
+	lis	r3, SVR_P2040@h
+	ori	r3, r3, SVR_P2040@l
+	cmpw	r4, r3
+	beq	1f
+
+	/* If L2 cache is disabled, skip it */
+	mfspr	r3, SPRN_L2CSR0
+	andis.	r3, r3, L2CSR0_L2E@h
+	beq	1f
+
+	li	r3, 0
+	blr
+1:
+	li	r3, 1
+	blr
+
+/* flush backside L2 cache */
+_GLOBAL(flush_backside_L2_cache)
+	mflr	r10
+	bl	need_L2_cache
+	mtlr	r10
+	cmpwi	r3, 0
+	bne	2f
+
+__flush_backside_L2_cache:
+	/* Flush the L2 cache */
+	mfspr	r3, SPRN_L2CSR0
+	ori	r3, r3, L2CSR0_L2FL@l
+	msync
+	isync
+	mtspr	SPRN_L2CSR0,r3
+	isync
+1:
+	mfspr	r3,SPRN_L2CSR0
+	andi.	r3, r3, L2CSR0_L2FL@l
+	bne	1b
+2:
+	blr
+
+/* flush and disable backside L2 cache */
+_GLOBAL(disable_backside_L2_cache)
+	mflr	r10
+	bl	need_L2_cache
+	mtlr	r10
+	cmpwi	r3, 0
+	bne	1f
+
+	mflr	r10
+	bl	__flush_backside_L2_cache
+	mtlr	r10
+
+	/* disable L2 cache */
+	li	r3, 0
+	msync
+	isync
+	mtspr	SPRN_L2CSR0, r3
+	isync
+1:
+	blr
+
+/********    Platform Cache    ********/
+
+#define L2CTL_L2E	0x80000000
+#define L2CTL_L2I	0x40000000
+
+/* r3 = base address of L2 controller registers */
+_GLOBAL(flush_disable_L2)
+	/* It's a write-through cache, so only invalidation is needed. */
+	mbar
+	isync
+	lwz	r4, 0(r3)
+	li	r5, 1
+	rlwimi	r4, r5, 30, L2CTL_L2E | L2CTL_L2I
+	stw	r4, 0(r3)
+
+	/* Wait for the invalidate to finish */
+1:	lwz	r4, 0(r3)
+	andis.	r4, r4, L2CTL_L2I@h
+	bne	1b
+	mbar
+
+	blr
+
+/* r3 = base address of L2 controller registers */
+_GLOBAL(invalidate_enable_L2)
+	mbar
+	isync
+	lwz	r4, 0(r3)
+	li	r5, 3
+	rlwimi	r4, r5, 30, L2CTL_L2E | L2CTL_L2I
+	stw	r4, 0(r3)
+
+	/* Wait for the invalidate to finish */
+1:	lwz	r4, 0(r3)
+	andis.	r4, r4, L2CTL_L2I@h
+	bne	1b
+	mbar
+
+	blr
diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
index 6f62a73..58925b6 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -987,80 +987,6 @@ _GLOBAL(set_context)
 	isync			/* Force context change */
 	blr
 
-_GLOBAL(flush_dcache_L1)
-	mfspr	r3,SPRN_L1CFG0
-
-	rlwinm	r5,r3,9,3	/* Extract cache block size */
-	twlgti	r5,1		/* Only 32 and 64 byte cache blocks
-				 * are currently defined.
-				 */
-	li	r4,32
-	subfic	r6,r5,2		/* r6 = log2(1KiB / cache block size) -
-				 *      log2(number of ways)
-				 */
-	slw	r5,r4,r5	/* r5 = cache block size */
-
-	rlwinm	r7,r3,0,0xff	/* Extract number of KiB in the cache */
-	mulli	r7,r7,13	/* An 8-way cache will require 13
-				 * loads per set.
-				 */
-	slw	r7,r7,r6
-
-	/* save off HID0 and set DCFA */
-	mfspr	r8,SPRN_HID0
-	ori	r9,r8,HID0_DCFA@l
-	mtspr	SPRN_HID0,r9
-	isync
-
-	lis	r4,KERNELBASE@h
-	mtctr	r7
-
-1:	lwz	r3,0(r4)	/* Load... */
-	add	r4,r4,r5
-	bdnz	1b
-
-	msync
-	lis	r4,KERNELBASE@h
-	mtctr	r7
-
-1:	dcbf	0,r4		/* ...and flush. */
-	add	r4,r4,r5
-	bdnz	1b
-	
-	/* restore HID0 */
-	mtspr	SPRN_HID0,r8
-	isync
-
-	blr
-
-/* Flush L1 d-cache, invalidate and disable d-cache and i-cache */
-_GLOBAL(__flush_disable_L1)
-	mflr	r10
-	bl	flush_dcache_L1	/* Flush L1 d-cache */
-	mtlr	r10
-
-	mfspr	r4, SPRN_L1CSR0	/* Invalidate and disable d-cache */
-	li	r5, 2
-	rlwimi	r4, r5, 0, 3
-
-	msync
-	isync
-	mtspr	SPRN_L1CSR0, r4
-	isync
-
-1:	mfspr	r4, SPRN_L1CSR0	/* Wait for the invalidate to finish */
-	andi.	r4, r4, 2
-	bne	1b
-
-	mfspr	r4, SPRN_L1CSR1	/* Invalidate and disable i-cache */
-	li	r5, 2
-	rlwimi	r4, r5, 0, 3
-
-	mtspr	SPRN_L1CSR1, r4
-	isync
-
-	blr
-
 #ifdef CONFIG_SMP
 /* When we get here, r24 needs to hold the CPU # */
 	.globl __secondary_start
-- 
1.7.3


