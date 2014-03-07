Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaCGE6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:58:31 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:25020
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbaCGE60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:58:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Subject: [PATCH 2/9] powerpc/cache: add cache flush operation for various e500
Date: Fri, 7 Mar 2014 12:57:58 +0800
Message-ID: <1394168285-32275-2-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various e500 core have different cache architecture, so they
need different cache flush operations. Therefore, add a callback
function cpu_flush_caches to the struct cpu_spec. The cache flush
operation for the specific kind of e500 is selected at init time.
The callback function will flush all caches in the current cpu.

Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
---
 arch/powerpc/include/asm/cacheflush.h     |    2 -
 arch/powerpc/include/asm/cputable.h       |   11 +++
 arch/powerpc/kernel/asm-offsets.c         |    3 +
 arch/powerpc/kernel/cpu_setup_fsl_booke.S |  114 ++++++++++++++++++++++++++++-
 arch/powerpc/kernel/cputable.c            |    4 +
 arch/powerpc/kernel/head_fsl_booke.S      |   74 -------------------
 arch/powerpc/platforms/85xx/smp.c         |    4 +-
 7 files changed, 134 insertions(+), 78 deletions(-)

diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
index 5b93122..039753e 100644
--- a/arch/powerpc/include/asm/cacheflush.h
+++ b/arch/powerpc/include/asm/cacheflush.h
@@ -30,8 +30,6 @@ extern void flush_dcache_page(struct page *page);
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 
-extern void __flush_disable_L1(void);
-
 extern void flush_icache_range(unsigned long, unsigned long);
 extern void flush_icache_user_range(struct vm_area_struct *vma,
 				    struct page *page, unsigned long addr,
diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index 617cc76..2c497a2 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -43,6 +43,13 @@ extern int machine_check_e500(struct pt_regs *regs);
 extern int machine_check_e200(struct pt_regs *regs);
 extern int machine_check_47x(struct pt_regs *regs);
 
+#if defined(CONFIG_E500) || defined(CONFIG_PPC_E500MC)
+extern void __flush_caches_e500v2(void);
+extern void __flush_caches_e500mc(void);
+extern void __flush_caches_e5500(void);
+extern void __flush_caches_e6500(void);
+#endif
+
 /* NOTE WELL: Update identify_cpu() if fields are added or removed! */
 struct cpu_spec {
 	/* CPU is matched via (PVR & pvr_mask) == pvr_value */
@@ -59,6 +66,10 @@ struct cpu_spec {
 	unsigned int	icache_bsize;
 	unsigned int	dcache_bsize;
 
+#if defined(CONFIG_E500) || defined(CONFIG_PPC_E500MC)
+	/* flush caches of the cpu which is running the function */
+	void (*cpu_flush_caches)(void);
+#endif
 	/* number of performance monitor counters */
 	unsigned int	num_pmcs;
 	enum powerpc_pmc_type pmc_type;
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 8d1d94d..5157fb4 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -372,6 +372,9 @@ int main(void)
 	DEFINE(CPU_SPEC_FEATURES, offsetof(struct cpu_spec, cpu_features));
 	DEFINE(CPU_SPEC_SETUP, offsetof(struct cpu_spec, cpu_setup));
 	DEFINE(CPU_SPEC_RESTORE, offsetof(struct cpu_spec, cpu_restore));
+#if defined(CONFIG_E500) || defined(CONFIG_PPC_E500MC)
+	DEFINE(CPU_FLUSH_CACHES, offsetof(struct cpu_spec, cpu_flush_caches));
+#endif
 
 	DEFINE(pbe_address, offsetof(struct pbe, address));
 	DEFINE(pbe_orig_address, offsetof(struct pbe, orig_address));
diff --git a/arch/powerpc/kernel/cpu_setup_fsl_booke.S b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
index cc2d896..e59d6de 100644
--- a/arch/powerpc/kernel/cpu_setup_fsl_booke.S
+++ b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
@@ -1,7 +1,7 @@
 /*
  * This file contains low level CPU setup functions.
  * Kumar Gala <galak@kernel.crashing.org>
- * Copyright 2009 Freescale Semiconductor, Inc.
+ * Copyright 2009, 2014 Freescale Semiconductor, Inc.
  *
  * Based on cpu_setup_6xx code by
  * Benjamin Herrenschmidt <benh@kernel.crashing.org>
@@ -13,11 +13,13 @@
  *
  */
 
+#include <asm/page.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/ppc_asm.h>
 #include <asm/mmu-book3e.h>
 #include <asm/asm-offsets.h>
+#include <asm/mpc85xx.h>
 
 _GLOBAL(__e500_icache_setup)
 	mfspr	r0, SPRN_L1CSR1
@@ -223,3 +225,113 @@ _GLOBAL(__setup_cpu_e5500)
 	mtlr	r5
 	blr
 #endif
+
+/* flush L1 date cache, it can apply to e500v2, e500mc and e5500 */
+_GLOBAL(flush_dcache_L1)
+	mfmsr	r10
+	wrteei	0
+
+	mfspr	r3,SPRN_L1CFG0
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
+	LOAD_REG_IMMEDIATE(r6, KERNELBASE)
+	mr	r4, r6
+	mtctr	r7
+
+1:	lwz	r3,0(r4)	/* Load... */
+	add	r4,r4,r5
+	bdnz	1b
+
+	msync
+	mr	r4, r6
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
+	wrtee r10
+
+	blr
+
+has_L2_cache:
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
+	li	r3, 1
+	blr
+1:
+	li	r3, 0
+	blr
+
+/* flush backside L2 cache */
+flush_backside_L2_cache:
+	mflr	r10
+	bl	has_L2_cache
+	mtlr	r10
+	cmpwi	r3, 0
+	beq	2f
+
+	/* Flush the L2 cache */
+	mfspr	r3, SPRN_L2CSR0
+	ori	r3, r3, L2CSR0_L2FL@l
+	msync
+	isync
+	mtspr	SPRN_L2CSR0,r3
+	isync
+
+	/* check if it is complete */
+1:	mfspr	r3,SPRN_L2CSR0
+	andi.	r3, r3, L2CSR0_L2FL@l
+	bne	1b
+2:
+	blr
+
+_GLOBAL(__flush_caches_e500v2)
+	mflr r0
+	bl	flush_dcache_L1
+	mtlr r0
+	blr
+
+_GLOBAL(__flush_caches_e500mc)
+_GLOBAL(__flush_caches_e5500)
+	mflr r0
+	bl	flush_dcache_L1
+	bl	flush_backside_L2_cache
+	mtlr r0
+	blr
+
+/* L1 Data Cache of e6500 contains no modified data, no flush is required */
+_GLOBAL(__flush_caches_e6500)
+	blr
diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index 6c8dd5d..8e70aa7 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -2068,6 +2068,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.cpu_setup		= __setup_cpu_e500v2,
 		.machine_check		= machine_check_e500,
 		.platform		= "ppc8548",
+		.cpu_flush_caches	= __flush_caches_e500v2,
 	},
 	{	/* e500mc */
 		.pvr_mask		= 0xffff0000,
@@ -2086,6 +2087,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.cpu_setup		= __setup_cpu_e500mc,
 		.machine_check		= machine_check_e500mc,
 		.platform		= "ppce500mc",
+		.cpu_flush_caches	= __flush_caches_e500mc,
 	},
 #endif /* CONFIG_PPC32 */
 	{	/* e5500 */
@@ -2108,6 +2110,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 #endif
 		.machine_check		= machine_check_e500mc,
 		.platform		= "ppce5500",
+		.cpu_flush_caches	= __flush_caches_e5500,
 	},
 	{	/* e6500 */
 		.pvr_mask		= 0xffff0000,
@@ -2130,6 +2133,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 #endif
 		.machine_check		= machine_check_e500mc,
 		.platform		= "ppce6500",
+		.cpu_flush_caches	= __flush_caches_e6500,
 	},
 #ifdef CONFIG_PPC32
 	{	/* default match */
diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
index b497188..20204fe 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -1067,80 +1067,6 @@ _GLOBAL(set_context)
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
diff --git a/arch/powerpc/platforms/85xx/smp.c b/arch/powerpc/platforms/85xx/smp.c
index 6382098..2e5911e 100644
--- a/arch/powerpc/platforms/85xx/smp.c
+++ b/arch/powerpc/platforms/85xx/smp.c
@@ -137,7 +137,9 @@ static void smp_85xx_mach_cpu_die(void)
 
 	mtspr(SPRN_TCR, 0);
 
-	__flush_disable_L1();
+	if (cur_cpu_spec && cur_cpu_spec->cpu_flush_caches)
+		cur_cpu_spec->cpu_flush_caches();
+
 	tmp = (mfspr(SPRN_HID0) & ~(HID0_DOZE|HID0_SLEEP)) | HID0_NAP;
 	mtspr(SPRN_HID0, tmp);
 	isync();
-- 
1.7.3


