Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbaFYQTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:19:17 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26672 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426AbaFYQTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:19:12 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-80-53aaf67de161
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 2/2] ARM: EXYNOS: Add support for firmware-assisted
 suspend/resume
Date: Wed, 25 Jun 2014 18:18:34 +0200
Message-id: <1403713114-18923-3-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403713114-18923-1-git-send-email-t.figa@samsung.com>
References: <1403713114-18923-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xq7q131YFG5zawmfx/eEpVou/k46x
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LtUfuslucuv6ZzeLG9BZWi/UzXrNYrNr1h9GB
	x6OluYfN4/evSYweO2fdZffYvKTe48qJJlaP3uZ3bB59W1YxenzeJBfAEcVlk5Kak1mWWqRv
	l8CV8frOdZaCZUoVO15pNzCeleli5OCQEDCReL3NuIuRE8gUk7hwbz1bFyMXh5DAUkaJS5uf
	skA4fUwSn5a9ZgapYhNQk/jc8IgNxBYRUJX43LaAHaSIWWA1s8Spr83sIAlhgRCJl8cOgNks
	QEVnup6A2bwCThIT2trYINbJSfRuewM2lFPAWWLfn81gNUJANYv7fjNNYORdwMiwilE0tTS5
	oDgpPddIrzgxt7g0L10vOT93EyMkQL/uYFx6zOoQowAHoxIPbwDPqmAh1sSy4srcQ4wSHMxK
	IrxRz4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGA8dsMiOUdzQb31+xY8JrK6679eey4hgl5i1
	cf8lAV3XFkaLtPta/08uWdf+4ujpZa+DjuhIbs8WZ9u29/aub7V8LVqC5iuWl8zQuLN+Cc+t
	PpOLiusOqqy5lrRlX7rarlX6aywSdjz3fVdlIqLUuzHnzYqLjAcP/2Scumq10GZvQYZ+N5m8
	IGYlluKMREMt5qLiRABMX4RULgIAAA==
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
 arch/arm/mach-exynos/firmware.c | 47 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/pm.c       | 16 +++++++++-----
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index def7bb4..cd554a1 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -14,15 +14,21 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 
+#include <asm/cacheflush.h>
 #include <asm/cputype.h>
 #include <asm/firmware.h>
 #include <asm/hardware/cache-l2x0.h>
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
@@ -66,10 +72,51 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 	return 0;
 }
 
+/* For Cortex-A9 Diagnostic and Power control register */
+static unsigned int cp15_power;
+static unsigned int cp15_diag;
+
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
+	/* Save Power control and Diagnostic registers */
+	asm ("mrc p15, 0, %0, c15, c0, 0\n"
+		"mrc p15, 0, %1, c15, c0, 1\n"
+		: "=r" (cp15_power), "=r" (cp15_diag) : : "cc");
+
+	writel(EXYNOS_SLEEP_MAGIC, sysram_ns_base_addr + EXYNOS_BOOT_FLAG);
+	writel(virt_to_phys(cpu_resume),
+		sysram_ns_base_addr + EXYNOS_BOOT_ADDR);
+
+	return cpu_suspend(0, exynos_cpu_suspend);
+}
+
+static int exynos_resume(void)
+{
+	exynos_smc(SMC_CMD_C15RESUME, cp15_power, cp15_diag, 0);
+	writel(0, sysram_ns_base_addr + EXYNOS_BOOT_FLAG);
+	outer_resume();
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
 
 static void exynos_l2_write_sec(unsigned long val, void __iomem *base,
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index f23cc77..ed20318 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -23,6 +23,7 @@
 #include <linux/clk.h>
 
 #include <asm/cacheflush.h>
+#include <asm/firmware.h>
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/smp_scu.h>
 #include <asm/suspend.h>
@@ -331,12 +332,11 @@ static int exynos_pm_central_resume(void)
 
 static void exynos_pm_resume(void)
 {
+	u32 cpuid = read_cpuid_part_number();
+
 	if (exynos_pm_central_resume())
 		goto early_wakeup;
 
-	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
-		exynos_cpu_restore_register();
-
 	/* For release retention */
 
 	__raw_writel((1 << 28), S5P_PAD_RET_MAUDIO_OPTION);
@@ -353,9 +353,13 @@ static void exynos_pm_resume(void)
 
 	s3c_pm_do_restore_core(exynos_core_save, ARRAY_SIZE(exynos_core_save));
 
-	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
+	if (cpuid == ARM_CPU_PART_CORTEX_A9)
 		scu_enable(S5P_VA_SCU);
 
+	if (call_firmware_op(resume) == -ENOSYS
+	    && cpuid == ARM_CPU_PART_CORTEX_A9)
+		exynos_cpu_restore_register();
+
 early_wakeup:
 
 	/* Clear SLEEP mode set in INFORM1 */
@@ -391,7 +395,9 @@ static int exynos_suspend_enter(suspend_state_t state)
 	flush_cache_all();
 	s3c_pm_check_store();
 
-	ret = cpu_suspend(0, exynos_cpu_suspend);
+	ret = call_firmware_op(suspend);
+	if (ret == -ENOSYS)
+		ret = cpu_suspend(0, exynos_cpu_suspend);
 	if (ret)
 		return ret;
 
-- 
1.9.3

