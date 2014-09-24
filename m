Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaIXMZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:25:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12840 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaIXMZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:25:33 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-a4-5422b83a2f15
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v7 3/5] ARM: EXYNOS: cpuidle: add secure firmware support to
 AFTR mode code
Date: Wed, 24 Sep 2014 14:24:46 +0200
Message-id: <1411561488-1739-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411561488-1739-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411561488-1739-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t9jQV2rHUohBrOmG1hsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLDq/zGKzuH2Z1+LM6UusFif/
	9DJavDrYxmLxc9c8FotVu/4wWmz86uEg6NHS3MPmsXPWXXaPO9f2sHlsXlLvcfvfY2aPLVfb
	WTz6tqxi9Pi8Sc5j49zQAM4oLpuU1JzMstQifbsErozbr5rZC2bIVjy/tJmxgXGSRBcjJ4eE
	gInE3/mLmCBsMYkL99azdTFycQgJTGeU+L57NjuE08Uk8fheKztIFZuAlcTE9lWMILaIgJpE
	z+KtYDazwG0WiYbrESC2sECsxINlB1hBbBYBVYn3vY/AenkF3CUWPfjDArFNUaL72QQ2EJtT
	wEPixf0esBohoJpjJ6+wTmDkXcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOLCfSe9g
	XNVgcYhRgINRiYe3Y5lSiBBrYllxZe4hRgkOZiURXqttQCHelMTKqtSi/Pii0pzU4kOM0hws
	SuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2MusrdWxRPr47sLxdkuXWCx2Omlar6vDVSdVw5
	ijW3GzQmrFD7F7dkxcfS9qAsfvPkk/X9Rq1XDYUK39X+sI18Ou3PZxWOu0sa673M0jfET35S
	NcGB92jXx5y589cuCj/svnWXxxPfDQ/Dps2oWPOw9faO9Zfl+VP+MVi3t0jetPJI/8/4jXWr
	EktxRqKhFnNRcSIArz0/RmgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move cp15 registers saving to exynos_save_cp15() helper and add
  additional helper usage to do_idle firmware method.

* Use resume firmware method instead of exynos_cpu_restore_register()
  and skip exynos_cpu_save_register() on boards with secure firmware
  enabled.

* Use sysram_ns_base_addr + 0x24/0x20 addresses instead of the default
  ones used by exynos_cpu_set_boot_vector() on boards with secure
  firmware enabled.

* Use do_idle firmware method instead of cpu_do_idle() on boards with
  secure firmware enabled.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v7:
- no changes

 arch/arm/mach-exynos/firmware.c | 24 +++++++++++++++++-------
 arch/arm/mach-exynos/pm.c       | 17 ++++++++++++-----
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index e57b7c3..2c5bc6b 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -25,13 +25,28 @@
 #include "smc.h"
 
 #define EXYNOS_SLEEP_MAGIC	0x00000bad
+#define EXYNOS_AFTR_MAGIC	0xfcba0d10
 #define EXYNOS_BOOT_ADDR	0x8
 #define EXYNOS_BOOT_FLAG	0xc
 
+static void exynos_save_cp15(void)
+{
+	/* Save Power control and Diagnostic registers */
+	asm ("mrc p15, 0, %0, c15, c0, 0\n"
+	     "mrc p15, 0, %1, c15, c0, 1\n"
+	     : "=r" (cp15_save_power), "=r" (cp15_save_diag)
+	     : : "cc");
+}
+
 static int exynos_do_idle(unsigned long mode)
 {
 	switch (mode) {
 	case FW_DO_IDLE_AFTR:
+		if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
+			exynos_save_cp15();
+		__raw_writel(virt_to_phys(exynos_cpu_resume_ns),
+			     sysram_ns_base_addr + 0x24);
+		__raw_writel(EXYNOS_AFTR_MAGIC, sysram_ns_base_addr + 0x20);
 		exynos_smc(SMC_CMD_CPU0AFTR, 0, 0, 0);
 		break;
 	case FW_DO_IDLE_SLEEP:
@@ -96,13 +111,8 @@ static int exynos_cpu_suspend(unsigned long arg)
 
 static int exynos_suspend(void)
 {
-	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
-		/* Save Power control and Diagnostic registers */
-		asm ("mrc p15, 0, %0, c15, c0, 0\n"
-			"mrc p15, 0, %1, c15, c0, 1\n"
-			: "=r" (cp15_save_power), "=r" (cp15_save_diag)
-			: : "cc");
-	}
+	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
+		exynos_save_cp15();
 
 	writel(EXYNOS_SLEEP_MAGIC, sysram_ns_base_addr + EXYNOS_BOOT_FLAG);
 	writel(virt_to_phys(exynos_cpu_resume_ns),
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 3407fc1..6796fce 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -236,11 +236,19 @@ static void exynos_cpu_set_boot_vector(long flags)
 
 static int exynos_aftr_finisher(unsigned long flags)
 {
+	int ret;
+
 	exynos_set_wakeupmask(0x0000ff3e);
-	exynos_cpu_set_boot_vector(S5P_CHECK_AFTR);
 	/* Set value of power down register for aftr mode */
 	exynos_sys_powerdown_conf(SYS_AFTR);
-	cpu_do_idle();
+
+	ret = call_firmware_op(do_idle, FW_DO_IDLE_AFTR);
+	if (ret == -ENOSYS) {
+		if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
+			exynos_cpu_save_register();
+		exynos_cpu_set_boot_vector(S5P_CHECK_AFTR);
+		cpu_do_idle();
+	}
 
 	return 1;
 }
@@ -250,14 +258,13 @@ void exynos_enter_aftr(void)
 	cpu_pm_enter();
 
 	exynos_pm_central_suspend();
-	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
-		exynos_cpu_save_register();
 
 	cpu_suspend(0, exynos_aftr_finisher);
 
 	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
 		scu_enable(S5P_VA_SCU);
-		exynos_cpu_restore_register();
+		if (call_firmware_op(resume) == -ENOSYS)
+			exynos_cpu_restore_register();
 	}
 
 	exynos_pm_central_resume();
-- 
1.8.2.3

