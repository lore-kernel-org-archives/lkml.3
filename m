Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3EPQAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:00:32 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:48926 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab3EPQAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:00:30 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, v-stehle@ti.com
Subject: [RFC PATCH v2] ARM: OMAP4+: protect SCU code compilation
Date: Thu, 16 May 2013 18:00:12 +0200
Message-Id: <1368720012-21064-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <51938169.4060109@ti.com>
References: <51938169.4060109@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Stehlé <v-stehle@ti.com>

This fixes the following link error when compiling only for OMAP5:

  arch/arm/mach-omap2/built-in.o: In function `scu_gp_set':
  arch/arm/mach-omap2/sleep44xx.S:132: undefined reference to `scu_power_mode'
  arch/arm/mach-omap2/built-in.o: In function `scu_gp_clear':
  arch/arm/mach-omap2/sleep44xx.S:229: undefined reference to `scu_power_mode'
  arch/arm/mach-omap2/built-in.o: In function `omap4_smp_prepare_cpus':
  arch/arm/mach-omap2/omap-smp.c:211: undefined reference to `scu_enable'
  arch/arm/mach-omap2/built-in.o: In function `omap4_smp_init_cpus':
  arch/arm/mach-omap2/omap-smp.c:185: undefined reference to `scu_get_core_count'

Signed-off-by: Vincent Stehlé <v-stehle@ti.com>
---


Hi Santosh,

Here is a try at "gating" all SCU references from OMAP4/5 common code. That
does build and run for me on OMAP4 and 5. On OMAP4, System.map files are even
identical with and without the patch.

How would you like this, please?

Best regards,

V.


 arch/arm/mach-omap2/omap-smp.c  |   10 ++++++++++
 arch/arm/mach-omap2/sleep44xx.S |   10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index 2a551f9..45c8b5d 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -21,7 +21,9 @@
 #include <linux/io.h>
 #include <linux/irqchip/arm-gic.h>
 
+#ifdef CONFIG_HAVE_ARM_SCU
 #include <asm/smp_scu.h>
+#endif
 
 #include "omap-secure.h"
 #include "omap-wakeupgen.h"
@@ -41,15 +43,19 @@
 
 u16 pm44xx_errata;
 
+#ifdef CONFIG_HAVE_ARM_SCU
 /* SCU base address */
 static void __iomem *scu_base;
+#endif
 
 static DEFINE_SPINLOCK(boot_lock);
 
+#ifdef CONFIG_HAVE_ARM_SCU
 void __iomem *omap4_get_scu_base(void)
 {
 	return scu_base;
 }
+#endif
 
 static void __cpuinit omap4_secondary_init(unsigned int cpu)
 {
@@ -176,6 +182,7 @@ static void __init omap4_smp_init_cpus(void)
 	/* Use ARM cpuid check here, as SoC detection will not work so early */
 	cpu_id = read_cpuid_id() & CPU_MASK;
 	if (cpu_id == CPU_CORTEX_A9) {
+#ifdef CONFIG_HAVE_ARM_SCU
 		/*
 		 * Currently we can't call ioremap here because
 		 * SoC detection won't work until after init_early.
@@ -183,6 +190,7 @@ static void __init omap4_smp_init_cpus(void)
 		scu_base =  OMAP2_L4_IO_ADDRESS(scu_a9_get_base());
 		BUG_ON(!scu_base);
 		ncores = scu_get_core_count(scu_base);
+#endif
 	} else if (cpu_id == CPU_CORTEX_A15) {
 		ncores = OMAP5_CORE_COUNT;
 	}
@@ -203,12 +211,14 @@ static void __init omap4_smp_prepare_cpus(unsigned int max_cpus)
 	void *startup_addr = omap_secondary_startup;
 	void __iomem *base = omap_get_wakeupgen_base();
 
+#ifdef CONFIG_HAVE_ARM_SCU
 	/*
 	 * Initialise the SCU and wake up the secondary core using
 	 * wakeup_secondary().
 	 */
 	if (scu_base)
 		scu_enable(scu_base);
+#endif
 
 	if (cpu_is_omap446x()) {
 		startup_addr = omap_secondary_startup_4460;
diff --git a/arch/arm/mach-omap2/sleep44xx.S b/arch/arm/mach-omap2/sleep44xx.S
index 88ff83a..3e73a32 100644
--- a/arch/arm/mach-omap2/sleep44xx.S
+++ b/arch/arm/mach-omap2/sleep44xx.S
@@ -10,7 +10,11 @@
  */
 
 #include <linux/linkage.h>
+
+#ifdef CONFIG_HAVE_ARM_SCU
 #include <asm/smp_scu.h>
+#endif
+
 #include <asm/memory.h>
 #include <asm/hardware/cache-l2x0.h>
 
@@ -70,6 +74,7 @@ ENTRY(omap4_finish_suspend)
 	 * Flush all data from the L1 data cache before disabling
 	 * SCTLR.C bit.
 	 */
+#ifdef CONFIG_HAVE_ARM_SCU
 	bl	omap4_get_sar_ram_base
 	ldr	r9, [r0, #OMAP_TYPE_OFFSET]
 	cmp	r9, #0x1			@ Check for HS device
@@ -81,6 +86,7 @@ ENTRY(omap4_finish_suspend)
 	DO_SMC
 	ldmfd   r13!, {r4-r12, r14}
 skip_secure_l1_clean:
+#endif
 	bl	v7_flush_dcache_all
 
 	/*
@@ -108,6 +114,7 @@ skip_secure_l1_clean:
 	 * preventing the CPU from receiving cache, TLB, or BTB
 	 * maintenance operations broadcast by other CPUs in the cluster.
 	 */
+#ifdef CONFIG_HAVE_ARM_SCU
 	bl	omap4_get_sar_ram_base
 	mov	r8, r0
 	ldr	r9, [r8, #OMAP_TYPE_OFFSET]
@@ -131,6 +138,7 @@ scu_gp_set:
 	bl	omap4_get_scu_base
 	bl	scu_power_mode
 skip_scu_gp_set:
+#endif
 	mrc	p15, 0, r0, c1, c1, 2		@ Read NSACR data
 	tst	r0, #(1 << 18)
 	mrcne	p15, 0, r0, c1, c0, 1
@@ -211,6 +219,7 @@ do_WFI:
 	orreq	r0, r0, #(1 << 6)
 	mcreq	p15, 0, r0, c1, c0, 1
 	isb
+#ifdef CONFIG_HAVE_ARM_SCU
 	bl	omap4_get_sar_ram_base
 	mov	r8, r0
 	ldr	r9, [r8, #OMAP_TYPE_OFFSET]
@@ -228,6 +237,7 @@ scu_gp_clear:
 	mov	r1, #SCU_PM_NORMAL
 	bl	scu_power_mode
 skip_scu_gp_clear:
+#endif
 	isb
 	dsb
 	ldmfd	sp!, {r4-r12, pc}
-- 
1.7.10.4

