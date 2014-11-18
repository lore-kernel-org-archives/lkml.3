Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbaKRQxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:53:18 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33968 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbaKRQxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:53:16 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-5b-546b797a1f1f
Subject: [PATCH RFC 1/3] ARM: LPAE: rework TTBR0/TTBR1 split
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 18 Nov 2014 19:53:13 +0400
Message-id: <20141118165313.9958.1242.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42I5/e/4Vd2qyuwQg+sdUhY/dvayWmx6fI3V
	4vKuOWwWty/zOrB4tDT3sHlsXlLv0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBkTp5xjL2gw
	qthx7Q5jA+NjjS5GDg4JAROJGdcduhg5gUwxiQv31rN1MXJxCAksZZT4dG8PE4TTyCRx7PRF
	NpAqYQEbifnbTrOA2GwCZhLb9t1mBLFFBPIlvh7YA1bDIqAqcfPDdnYQm1fAUGJ/5xsmEFtU
	QE5i5eUWVoi4oMSPyfdYQI5gFlCXmDIlFyTMLCAvsXnNW+YJjLyzkFTNQqiahaRqASPzKkbR
	1NLkguKk9FxDveLE3OLSvHS95PzcTYyQYPuyg3HxMatDjAIcjEo8vA0bs0KEWBPLiitzDzFK
	cDArifCe6wYK8aYkVlalFuXHF5XmpBYfYmTi4JRqYOQoZ3duXlTbKNp/fM3tn8sne71Q+V0z
	WTzVU7249PXVS78tnt2YsMP2pvO3/i1bw3UWZ15RuzNh6fVmTTYh+fjTFilLxaX9JI022Zid
	TVDbNvXUEX/vFZ+8njjMlNWNW3fO703XNL/qrXYN+22jWDkvelfX8OTsUtHeVvdg/t9A+adu
	Qi06q5RYijMSDbWYi4oTAYomkREUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves enabling TTBRx split from __v7_setup (v7_ttb_setup)
into cpu_init() which is called in init_mm context after leaving idmap.
Also it disables split in setup_mm_for_reboot() before switching mm to idmap.
After that idmap and VM split never meet, thus they no longer conflict.

Callback keystone_smp_secondary_initmem isn't required, all setup is
done in cpu_init() which is called right before smp_ops.smp_secondary_init.

Also this patch prepares code for enabling split in non-LPAE mode.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 arch/arm/include/asm/pgtable-2level-hwdef.h |    2 ++
 arch/arm/include/asm/pgtable-3level-hwdef.h |   12 +++++-------
 arch/arm/include/asm/proc-fns.h             |   13 +++++++++++++
 arch/arm/kernel/setup.c                     |   11 +++++++++++
 arch/arm/mach-keystone/platsmp.c            |   13 -------------
 arch/arm/mm/idmap.c                         |    6 ++++++
 arch/arm/mm/proc-v7-3level.S                |   13 -------------
 7 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-2level-hwdef.h b/arch/arm/include/asm/pgtable-2level-hwdef.h
index 5cfba15..c2ed1fa 100644
--- a/arch/arm/include/asm/pgtable-2level-hwdef.h
+++ b/arch/arm/include/asm/pgtable-2level-hwdef.h
@@ -90,4 +90,6 @@
 
 #define PHYS_MASK		(~0UL)
 
+#define TTBR1_SIZE	0
+
 #endif
diff --git a/arch/arm/include/asm/pgtable-3level-hwdef.h b/arch/arm/include/asm/pgtable-3level-hwdef.h
index 9fd61c7..8bb32a0 100644
--- a/arch/arm/include/asm/pgtable-3level-hwdef.h
+++ b/arch/arm/include/asm/pgtable-3level-hwdef.h
@@ -89,19 +89,17 @@
  *   0x40000000: T0SZ = 2, T1SZ = 0 (not used)
  *   0x80000000: T0SZ = 0, T1SZ = 1
  *   0xc0000000: T0SZ = 0, T1SZ = 2
- *
- * Only use this feature if PHYS_OFFSET <= PAGE_OFFSET, otherwise
- * booting secondary CPUs would end up using TTBR1 for the identity
- * mapping set up in TTBR0.
  */
 #if defined CONFIG_VMSPLIT_2G
 #define TTBR1_OFFSET	16			/* skip two L1 entries */
+#define TTBR1_SIZE	(1<<16)
 #elif defined CONFIG_VMSPLIT_3G
 #define TTBR1_OFFSET	(4096 * (1 + 3))	/* only L2, skip pgd + 3*pmd */
+#define TTBR1_SIZE	(2<<16)
 #else
-#define TTBR1_OFFSET	0
+#define TTBR1_OFFSET	8			/* skip one L1 entry */
+/* Not implemented. In this mode TTBR0 points to first pmd instead of pgd. */
+#define TTBR1_SIZE	0
 #endif
 
-#define TTBR1_SIZE	(((PAGE_OFFSET >> 30) - 1) << 16)
-
 #endif
diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index 5324c11..8353eb4 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -149,6 +149,19 @@ extern void cpu_resume(void);
 	})
 #endif
 
+static inline u32 cpu_get_ttbcr(void)
+{
+	u32 val;
+
+	__asm__("mrc p15, 0, %0, c2, c0, 2" : "=r" (val));
+	return val;
+}
+
+static inline void cpu_set_ttbcr(u32 val)
+{
+	__asm__("mcr p15, 0, %0, c2, c0, 2" : : "r" (val));
+}
+
 #else	/*!CONFIG_MMU */
 
 #define cpu_switch_mm(pgd,mm)	{ }
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index c031063..6a54a82 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -488,6 +488,17 @@ void notrace cpu_init(void)
 	      PLC (PSR_F_BIT | PSR_I_BIT | SVC_MODE)
 	    : "r14");
 #endif
+
+#ifdef CONFIG_ARM_LPAE
+	/* For short mode TTBR1 already loaded by macro v7_ttb_setup */
+	cpu_set_ttbr(1, __pa(init_mm.pgd) + TTBR1_OFFSET);
+#endif
+
+#if defined(CONFIG_MMU) && TTBR1_SIZE
+	/* Enable TTBR0/TTBR1 split */
+	cpu_set_ttbcr(cpu_get_ttbcr() | TTBR1_SIZE);
+	local_flush_tlb_all();
+#endif
 }
 
 u32 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = MPIDR_INVALID };
diff --git a/arch/arm/mach-keystone/platsmp.c b/arch/arm/mach-keystone/platsmp.c
index 5f46a7c..4bbb184 100644
--- a/arch/arm/mach-keystone/platsmp.c
+++ b/arch/arm/mach-keystone/platsmp.c
@@ -39,19 +39,6 @@ static int keystone_smp_boot_secondary(unsigned int cpu,
 	return error;
 }
 
-#ifdef CONFIG_ARM_LPAE
-static void __cpuinit keystone_smp_secondary_initmem(unsigned int cpu)
-{
-	pgd_t *pgd0 = pgd_offset_k(0);
-	cpu_set_ttbr(1, __pa(pgd0) + TTBR1_OFFSET);
-	local_flush_tlb_all();
-}
-#else
-static inline void __cpuinit keystone_smp_secondary_initmem(unsigned int cpu)
-{}
-#endif
-
 struct smp_operations keystone_smp_ops __initdata = {
 	.smp_boot_secondary	= keystone_smp_boot_secondary,
-	.smp_secondary_init     = keystone_smp_secondary_initmem,
 };
diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index e7a81ceb..cc51b40 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -123,6 +123,12 @@ void setup_mm_for_reboot(void)
 {
 	/* Switch to the identity mapping. */
 	cpu_switch_mm(idmap_pgd, &init_mm);
+
+#if TTBR1_SIZE
+	/* Disable TTBR0/TTBR1 split, idmap might collide with TTRB1 range */
+	cpu_set_ttbcr(cpu_get_ttbcr() | ~TTBR1_SIZE);
+#endif
+
 	local_flush_bp_all();
 
 #ifdef CONFIG_CPU_HAS_ASID
diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
index d3daed0..b8173cf 100644
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -127,26 +127,13 @@ ENDPROC(cpu_v7_set_pte_ext)
 	 * - \ttbr1 updated.
 	 */
 	.macro	v7_ttb_setup, zero, ttbr0, ttbr1, tmp
-	ldr	\tmp, =swapper_pg_dir		@ swapper_pg_dir virtual address
-	mov	\tmp, \tmp, lsr #ARCH_PGD_SHIFT
-	cmp	\ttbr1, \tmp			@ PHYS_OFFSET > PAGE_OFFSET?
 	mrc	p15, 0, \tmp, c2, c0, 2		@ TTB control register
 	orr	\tmp, \tmp, #TTB_EAE
 	ALT_SMP(orr	\tmp, \tmp, #TTB_FLAGS_SMP)
 	ALT_UP(orr	\tmp, \tmp, #TTB_FLAGS_UP)
 	ALT_SMP(orr	\tmp, \tmp, #TTB_FLAGS_SMP << 16)
 	ALT_UP(orr	\tmp, \tmp, #TTB_FLAGS_UP << 16)
-	/*
-	 * Only use split TTBRs if PHYS_OFFSET <= PAGE_OFFSET (cmp above),
-	 * otherwise booting secondary CPUs would end up using TTBR1 for the
-	 * identity mapping set up in TTBR0.
-	 */
-	orrls	\tmp, \tmp, #TTBR1_SIZE				@ TTBCR.T1SZ
 	mcr	p15, 0, \tmp, c2, c0, 2				@ TTBCR
-	mov	\tmp, \ttbr1, lsr #(32 - ARCH_PGD_SHIFT)	@ upper bits
-	mov	\ttbr1, \ttbr1, lsl #ARCH_PGD_SHIFT		@ lower bits
-	addls	\ttbr1, \ttbr1, #TTBR1_OFFSET
-	mcrr	p15, 1, \ttbr1, \tmp, c2			@ load TTBR1
 	mov	\tmp, \ttbr0, lsr #(32 - ARCH_PGD_SHIFT)	@ upper bits
 	mov	\ttbr0, \ttbr0, lsl #ARCH_PGD_SHIFT		@ lower bits
 	mcrr	p15, 0, \ttbr0, \tmp, c2			@ load TTBR0

