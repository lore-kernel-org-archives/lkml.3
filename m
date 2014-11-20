Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbaKTPMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:12:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35668 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106AbaKTPMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:12:19 -0500
X-AuditID: cbfee61a-f79c06d000004e71-3a-546e04d192e1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>, Kukjin Kim <kgene@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/4] ARM: EXYNOS: fix CPU1 hotplug for AFTR mode on Exynos3250
Date: Thu, 20 Nov 2014 16:11:46 +0100
Message-id: <1416496309-27602-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1416496309-27602-1-git-send-email-b.zolnierkie@samsung.com>
References: <1416496309-27602-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t9jQd2LLHkhBpsW81tsnLGe1eL6l+es
	FvM+y1q8fmFo0bvgKptF/+PXzBZnm96wW2x6fI3V4vKuOWwWn3uPMFrMOL+PyWLVrj+MDjwe
	O2fdZffYtKqTzePOtT1sHpuX1Hv0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxsEli9gL/ohW
	nL73gamB8ZZQFyMnh4SAiUTr1+dsELaYxIV764FsLg4hgemMEjNefGYFSQgJdDFJbLtcAGKz
	CVhJTGxfxQhiiwi4Ssy5MokRpIFZ4BeTxJWrj8EahAX8JBpeHgWzWQRUJbobFjKD2LwCHhIT
	ZzWwQGxTlOh+NgFoGwcHp4CnxO1NORC7PCSeNy1hnMDIu4CRYRWjaGpBckFxUnquoV5xYm5x
	aV66XnJ+7iZGcCg+k9rBuLLB4hCjAAejEg9vgkVuiBBrYllxZe4hRgkOZiUR3oXvgUK8KYmV
	ValF+fFFpTmpxYcYpTlYlMR5b9wESgmkJ5akZqemFqQWwWSZODilGhhD/Xw5JixLOu14/Op5
	P9NjS/S33DJW45E8VngqOo7zzIfbes2JPcdWZGS8FLi2/4DSxyLF2c6yPAUVRq0ORxpSV2vN
	2H5NomGu1JsDl/9Ns7p70jTs26EJjlN32M57pde7q+xR3IpGnpnfar2XOS9SlAl8u/pkjGqK
	u/Yv66T3WT9yVnfO2P5AiaU4I9FQi7moOBEAy2rpF0ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU1 hotplug may hang when AFTR is used.  Fix it by:
- setting AUTOWAKEUP_EN bit in ARM_COREx_CONFIGURATION register in
  exynos_cpu_power_up()
- not clearing reserved bits of ARM_COREx_CONFIGURATION register in
  exynos_cpu_power_down()
- waiting while an undocumented register 0x0908 becomes non-zero in
  exynos_core_restart()

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/platsmp.c  | 19 +++++++++++++++++--
 arch/arm/mach-exynos/regs-pmu.h |  1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 7a1ebfe..9f9d7cd 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -126,6 +126,8 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
  */
 void exynos_cpu_power_down(int cpu)
 {
+	u32 core_conf;
+
 	if (cpu == 0 && (of_machine_is_compatible("samsung,exynos5420") ||
 		of_machine_is_compatible("samsung,exynos5800"))) {
 		/*
@@ -138,7 +140,10 @@ void exynos_cpu_power_down(int cpu)
 		if (!(val & S5P_CORE_LOCAL_PWR_EN))
 			return;
 	}
-	pmu_raw_writel(0, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
+
+	core_conf = pmu_raw_readl(EXYNOS_ARM_CORE_CONFIGURATION(cpu));
+	core_conf &= ~S5P_CORE_LOCAL_PWR_EN;
+	pmu_raw_writel(core_conf, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
 }
 
 /**
@@ -149,7 +154,12 @@ void exynos_cpu_power_down(int cpu)
  */
 void exynos_cpu_power_up(int cpu)
 {
-	pmu_raw_writel(S5P_CORE_LOCAL_PWR_EN,
+	u32 core_conf = S5P_CORE_LOCAL_PWR_EN;
+
+	if (soc_is_exynos3250())
+		core_conf |= S5P_CORE_AUTOWAKEUP_EN;
+
+	pmu_raw_writel(core_conf,
 			EXYNOS_ARM_CORE_CONFIGURATION(cpu));
 }
 
@@ -227,6 +237,11 @@ static void exynos_core_restart(u32 core_id)
 	if (!of_machine_is_compatible("samsung,exynos3250"))
 		return;
 
+	/* 0x0908 is an undocumented register */
+	while (!pmu_raw_readl(0x0908))
+		udelay(10);
+	udelay(10);
+
 	val = pmu_raw_readl(EXYNOS_ARM_CORE_STATUS(core_id));
 	val |= S5P_CORE_WAKEUP_FROM_LOCAL_CFG;
 	pmu_raw_writel(val, EXYNOS_ARM_CORE_STATUS(core_id));
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index b5f4406..77defeb 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -180,6 +180,7 @@
 
 #define S5P_CORE_LOCAL_PWR_EN			0x3
 #define S5P_CORE_WAKEUP_FROM_LOCAL_CFG		(0x3 << 8)
+#define S5P_CORE_AUTOWAKEUP_EN			(1 << 31)
 
 /* Only for EXYNOS4210 */
 #define S5P_CMU_CLKSTOP_LCD1_LOWPWR	0x1154
-- 
1.8.2.3

