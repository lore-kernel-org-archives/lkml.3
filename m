Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbaDXJdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:33:00 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50130 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbaDXJbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:31:50 -0400
From: Leela Krishna Amudala <leela.krishna@linaro.org>
To: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: daniel.lezcano@linaro.org, nicolas.pitre@linaro.org, kgene.kim@samsung.com,
        amit.kucheria@linaro.org
Subject: [PATCH 1/2] ARM: EXYNOS: Add generic cpu power control functions for all exynos based SoCs
Date: Thu, 24 Apr 2014 15:01:58 +0530
Message-Id: <1398331919-28321-2-git-send-email-leela.krishna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398331919-28321-1-git-send-email-leela.krishna@linaro.org>
References: <1398331919-28321-1-git-send-email-leela.krishna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic cpu power control functions for exynos based SoCS
for cpu power up/down and to know the cpu status.

Signed-off-by: Leela Krishna Amudala <leela.krishna@linaro.org>
---
 arch/arm/mach-exynos/common.h   |    3 +++
 arch/arm/mach-exynos/pm.c       |   36 ++++++++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/regs-pmu.h |    6 ++++++
 3 files changed, 45 insertions(+)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 9ef3f83..566f222 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -62,5 +62,8 @@ struct exynos_pmu_conf {
 };
 
 extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
+extern void exynos_cpu_powerdown(int cpu);
+extern void exynos_cpu_powerup(int cpu);
+extern int  exynos_cpu_power_state(int cpu);
 
 #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 15af0ce..6651028 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -100,6 +100,42 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
 	return -ENOENT;
 }
 
+/**
+ * exynos_cpu_powerdown : power down the specified cpu
+ * @cpu : the cpu to power down
+ *
+ * Power downs the specified cpu. The sequence must be finished by a
+ * call to cpu_do_idle()
+ *
+ */
+void exynos_cpu_powerdown(int cpu)
+{
+	__raw_writel(0, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
+}
+
+/**
+ * exynos_cpu_powerup : power up the specified cpu
+ * @cpu : the cpu to power up
+ *
+ * Power up the specified cpu
+ */
+void exynos_cpu_powerup(int cpu)
+{
+	__raw_writel(S5P_CORE_LOCAL_PWR_EN,
+		     EXYNOS_ARM_CORE_CONFIGURATION(cpu));
+}
+
+/**
+ * exynos_cpu_power_state : returns the power state of the cpu
+ * @cpu : the cpu to retrieve the power state from
+ *
+ */
+int exynos_cpu_power_state(int cpu)
+{
+	return (__raw_readl(EXYNOS_ARM_CORE_STATUS(cpu)) &
+			S5P_CORE_LOCAL_PWR_EN);
+}
+
 /* For Cortex-A9 Diagnostic and Power control register */
 static unsigned int save_arm_register[2];
 
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 4f6a256..0bdfcbc 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -121,6 +121,12 @@
 
 #define S5P_CHECK_SLEEP				0x00000BAD
 
+#define EXYNOS_ARM_CORE0_CONFIGURATION		S5P_PMUREG(0x2000)
+#define EXYNOS_ARM_CORE_CONFIGURATION(_nr)	\
+			(EXYNOS_ARM_CORE0_CONFIGURATION + (0x80 * (_nr)))
+#define EXYNOS_ARM_CORE_STATUS(_nr)		\
+			(EXYNOS_ARM_CORE_CONFIGURATION(_nr) + 0x4)
+
 /* Only for EXYNOS4210 */
 #define S5P_CMU_CLKSTOP_LCD1_LOWPWR	S5P_PMUREG(0x1154)
 #define S5P_CMU_RESET_LCD1_LOWPWR	S5P_PMUREG(0x1174)
-- 
1.7.9.5

