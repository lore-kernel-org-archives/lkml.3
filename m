Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330AbaGQP5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:57:02 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63136 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933901AbaGQP46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:56:58 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-63-53c7f246a45d
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        swarren@nvidia.com, acourbot@nvidia.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        drake@endlessm.com, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 2/2] ARM: EXYNOS: Add support for firmware-assisted
 suspend/resume
Date: Thu, 17 Jul 2014 17:56:11 +0200
Message-id: <1405612571-32598-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1405612571-32598-1-git-send-email-t.figa@samsung.com>
References: <1405612571-32598-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsVy+t/xK7pun44HG0zYw23x/eEpVou/k46x
	Wzya/5jZonfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81qsPXKX3eLU9c9sFjemt7BarJ/xmsVi
	1a4/jA68Hi3NPWwev39NYvRY9D3LY+esu+wem5fUe1w50cTq0dv8js2jb8sqRo/Pm+QCOKO4
	bFJSczLLUov07RK4Mjb9Os1ccMysYs+Zw2wNjMd0uxg5OCQETCQunZDrYuQEMsUkLtxbz9bF
	yMUhJLCUUeL+p8usEE4fk8SdQ/sYQarYBNQkPjc8YgOxRQRUJT63LWAHKWIWmMUs8W3OBrCE
	sEC4RMvDBiYQmwWoaMIsCJtXwEliVs8pVoh1chK9294wg9icAs4Sl261gtUIAdVcPXWDfQIj
	7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIUH7ZQfj4mNWhxgFOBiVeHg7Px8LFmJN
	LCuuzD3EKMHBrCTCm33/eLAQb0piZVVqUX58UWlOavEhRiYOTqkGxllFJ6bx/f/AdcTIVnXj
	ignaiSVdH3d/33WAvd/XQCpGNKtnrvuKBxztGVoiOeu2Sebc8Nbmf9jdrzBD9Oj0NpZbpSdD
	J11cq+3yIlzwVWjoTrN9ljvD+JV7pp8qiTvVE/Td78fVZq+Vh5/fuMag+szNbjk359z3f/RO
	5HvOXTZ73v8810svjZVYijMSDbWYi4oTAd/SIBk4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a numer of Exynos-based boards Linux kernel is running in non-secure
mode under a secure firmware. This means that certain operations need to
be handled in special way, with firmware assistance. System-wide
suspend/resume is an example of such operations.

This patch adds support for firmware-assisted suspend/resume by
leveraging recently introduced suspend and resume firmware operations
and modifying existing suspend/resume paths to account for presence of
secure firmware.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/Makefile   |  1 +
 arch/arm/mach-exynos/common.h   |  4 ++++
 arch/arm/mach-exynos/firmware.c | 45 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/pm.c       | 16 ++++++++++-----
 arch/arm/mach-exynos/sleep.S    | 28 +++++++++++++++++++++++++
 arch/arm/mach-exynos/smc.h      |  4 ++++
 6 files changed, 93 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 788f26d..e7d1774 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -26,6 +26,7 @@ CFLAGS_hotplug.o		+= -march=armv7-a
 
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_exynos-smc.o		:=-Wa,-march=armv7-a$(plus_sec)
+AFLAGS_sleep.o			:=-Wa,-march=armv7-a$(plus_sec)
 
 obj-$(CONFIG_EXYNOS5420_MCPM)	+= mcpm-exynos.o
 CFLAGS_mcpm-exynos.o		+= -march=armv7-a
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index f8daa9c..a3f3061 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -111,6 +111,9 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
 #define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5410() || \
 			  soc_is_exynos5420() || soc_is_exynos5800())
 
+extern u32 cp15_save_diag;
+extern u32 cp15_save_power;
+
 extern void __iomem *sysram_ns_base_addr;
 extern void __iomem *sysram_base_addr;
 extern void __iomem *pmu_base_addr;
@@ -127,6 +130,7 @@ static inline void exynos_pm_init(void) {}
 #endif
 
 extern void exynos_cpu_resume(void);
+extern void exynos_cpu_resume_ns(void);
 
 extern struct smp_operations exynos_smp_ops;
 
diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index e8797bb..f5e626d 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -14,13 +14,20 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 
+#include <asm/cacheflush.h>
+#include <asm/cputype.h>
 #include <asm/firmware.h>
+#include <asm/suspend.h>
 
 #include <mach/map.h>
 
 #include "common.h"
 #include "smc.h"
 
+#define EXYNOS_SLEEP_MAGIC	0x00000bad
+#define EXYNOS_BOOT_ADDR	0x8
+#define EXYNOS_BOOT_FLAG	0xc
+
 static int exynos_do_idle(void)
 {
 	exynos_smc(SMC_CMD_SLEEP, 0, 0, 0);
@@ -69,10 +76,48 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 	return 0;
 }
 
+static int exynos_cpu_suspend(unsigned long arg)
+{
+	flush_cache_all();
+	outer_flush_all();
+
+	exynos_smc(SMC_CMD_SLEEP, 0, 0, 0);
+
+	pr_info("Failed to suspend the system\n");
+	writel(0, sysram_ns_base_addr + EXYNOS_BOOT_FLAG);
+	return 1;
+}
+
+static int exynos_suspend(void)
+{
+	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
+		/* Save Power control and Diagnostic registers */
+		asm ("mrc p15, 0, %0, c15, c0, 0\n"
+			"mrc p15, 0, %1, c15, c0, 1\n"
+			: "=r" (cp15_save_power), "=r" (cp15_save_diag)
+			: : "cc");
+	}
+
+	writel(EXYNOS_SLEEP_MAGIC, sysram_ns_base_addr + EXYNOS_BOOT_FLAG);
+	writel(virt_to_phys(exynos_cpu_resume_ns),
+		sysram_ns_base_addr + EXYNOS_BOOT_ADDR);
+
+	return cpu_suspend(0, exynos_cpu_suspend);
+}
+
+static int exynos_resume(void)
+{
+	writel(0, sysram_ns_base_addr + EXYNOS_BOOT_FLAG);
+
+	return 0;
+}
+
 static const struct firmware_ops exynos_firmware_ops = {
 	.do_idle		= exynos_do_idle,
 	.set_cpu_boot_addr	= exynos_set_cpu_boot_addr,
 	.cpu_boot		= exynos_cpu_boot,
+	.suspend		= exynos_suspend,
+	.resume			= exynos_resume,
 };
 
 void __init exynos_firmware_init(void)
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 63a1d6b..681e894 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -23,6 +23,7 @@
 #include <linux/clk.h>
 
 #include <asm/cacheflush.h>
+#include <asm/firmware.h>
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/smp_scu.h>
 #include <asm/suspend.h>
@@ -354,12 +355,11 @@ static int exynos_pm_suspend(void)
 
 static void exynos_pm_resume(void)
 {
+	u32 cpuid = read_cpuid_part();
+
 	if (exynos_pm_central_resume())
 		goto early_wakeup;
 
-	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
-		exynos_cpu_restore_register();
-
 	/* For release retention */
 
 	__raw_writel((1 << 28), S5P_PAD_RET_MAUDIO_OPTION);
@@ -376,9 +376,13 @@ static void exynos_pm_resume(void)
 
 	s3c_pm_do_restore_core(exynos_core_save, ARRAY_SIZE(exynos_core_save));
 
-	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
+	if (cpuid == ARM_CPU_PART_CORTEX_A9)
 		scu_enable(S5P_VA_SCU);
 
+	if (call_firmware_op(resume) == -ENOSYS
+	    && cpuid == ARM_CPU_PART_CORTEX_A9)
+		exynos_cpu_restore_register();
+
 early_wakeup:
 
 	/* Clear SLEEP mode set in INFORM1 */
@@ -419,7 +423,9 @@ static int exynos_suspend_enter(suspend_state_t state)
 	flush_cache_all();
 	s3c_pm_check_store();
 
-	ret = cpu_suspend(0, exynos_cpu_suspend);
+	ret = call_firmware_op(suspend);
+	if (ret == -ENOSYS)
+		ret = cpu_suspend(0, exynos_cpu_suspend);
 	if (ret)
 		return ret;
 
diff --git a/arch/arm/mach-exynos/sleep.S b/arch/arm/mach-exynos/sleep.S
index 108a45f..e3c3730 100644
--- a/arch/arm/mach-exynos/sleep.S
+++ b/arch/arm/mach-exynos/sleep.S
@@ -16,6 +16,7 @@
  */
 
 #include <linux/linkage.h>
+#include "smc.h"
 
 #define CPU_MASK	0xff0ffff0
 #define CPU_CORTEX_A9	0x410fc090
@@ -55,3 +56,30 @@ ENTRY(exynos_cpu_resume)
 #endif
 	b	cpu_resume
 ENDPROC(exynos_cpu_resume)
+
+	.align
+
+ENTRY(exynos_cpu_resume_ns)
+	mrc	p15, 0, r0, c0, c0, 0
+	ldr	r1, =CPU_MASK
+	and	r0, r0, r1
+	ldr	r1, =CPU_CORTEX_A9
+	cmp	r0, r1
+	bne	skip_cp15
+
+	adr	r0, cp15_save_power
+	ldr	r1, [r0]
+	adr	r0, cp15_save_diag
+	ldr	r2, [r0]
+	mov	r0, #SMC_CMD_C15RESUME
+	dsb
+	smc	#0
+skip_cp15:
+	b	cpu_resume
+ENDPROC(exynos_cpu_resume_ns)
+	.globl cp15_save_diag
+cp15_save_diag:
+	.long	0	@ cp15 diagnostic
+	.globl cp15_save_power
+cp15_save_power:
+	.long	0	@ cp15 power control
diff --git a/arch/arm/mach-exynos/smc.h b/arch/arm/mach-exynos/smc.h
index 13a1dc8..f7b82f9 100644
--- a/arch/arm/mach-exynos/smc.h
+++ b/arch/arm/mach-exynos/smc.h
@@ -26,6 +26,10 @@
 #define SMC_CMD_L2X0INVALL	(-24)
 #define SMC_CMD_L2X0DEBUG	(-25)
 
+#ifndef __ASSEMBLY__
+
 extern void exynos_smc(u32 cmd, u32 arg1, u32 arg2, u32 arg3);
 
+#endif /* __ASSEMBLY__ */
+
 #endif
-- 
1.9.3

