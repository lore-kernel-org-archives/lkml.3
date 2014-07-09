Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbaGIRTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:19:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59063 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbaGIRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:19:11 -0400
X-AuditID: cbfee61a-f79e46d00000134f-0b-53bd798d3e54
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v3 3/4] ARM: EXYNOS: cpuidle: add secure firmware support to
 AFTR mode code
Date: Wed, 09 Jul 2014 19:17:53 +0200
Message-id: <1404926274-18411-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
References: <1404926274-18411-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd2+yr3BBuf2sVlsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PF+hmvWSw2
	fvVw4PW4c20Pm8fmJfUet/89ZvbYcrWdxaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyzv8t
	LZihWrHp7Hm2BsZe+S5GTg4JAROJfR86WSBsMYkL99azdTFycQgJLGKUWPN+BZTTxSTROekq
	K0gVm4CVxMT2VYwgtoiAmkTP4q2MIEXMAnuZJZZ2b2IHSQgLxEpM6GgFK2IRUJW4dmIKE4jN
	K+Ahcf3Abah1ihLdzyYAbeDg4BTwlHi2tRgkLARUcvZZO9MERt4FjAyrGEVTC5ILipPScw31
	ihNzi0vz0vWS83M3MYKD8pnUDsaVDRaHGAU4GJV4eBV49gQLsSaWFVfmHmKU4GBWEuG9VbI3
	WIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAPjnM/h9YzP
	eioz73/lcDx2NNlqgubfLN6tb15eNlq8r/pICfOuHpsNGruat/xIuLdj8tXDUjmdl1tNOEx3
	2dx5dFwqRm/+1PDWHxEJjxhnzTjT0ZgqMX/Gkk+LFid+uDTHSDnZOqWo7sdEL/vcd66Bxpfm
	rey8YCP5vupLmQfHhZXs57h5D5w+qsRSnJFoqMVcVJwIAJJozB9GAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move cp15 registers saving to exynos_save_cp15() helper and add
  additional helper usage to do_idle firmware method.

* Use sysram_ns_base_addr + 0x24/0x20 addresses instead of the default
  ones used by exynos_cpu_set_boot_vector() on boards with secure
  firmware enabled.

* Use do_idle firmware method instead of cpu_do_idle() on boards with
  secure firmware enabled.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v3:
- make exynos_enter_aftr() return a value
- add cp15 registers handling to do_idle firmware method
- set sysram_ns_base_addr + 0x24/0x20 in do_idle firmware method
- move calling of do_idle firmware method from cpuidle-exynos.c
  to pm.c

 arch/arm/mach-exynos/common.h    |  2 +-
 arch/arm/mach-exynos/firmware.c  | 26 ++++++++++++++++++--------
 arch/arm/mach-exynos/pm.c        | 11 +++++++++--
 drivers/cpuidle/cpuidle-exynos.c |  6 +++---
 4 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index a6a200f..0829808 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -170,7 +170,7 @@ extern int  exynos_cpu_power_state(int cpu);
 extern void exynos_cluster_power_down(int cluster);
 extern void exynos_cluster_power_up(int cluster);
 extern int  exynos_cluster_power_state(int cluster);
-extern void exynos_enter_aftr(void);
+extern int  exynos_enter_aftr(void);
 
 extern void s5p_init_cpu(void __iomem *cpuid_addr);
 extern unsigned int samsung_rev(void);
diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 53fbf5c..163f5b9 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -24,13 +24,30 @@
 #include "smc.h"
 
 #define EXYNOS_SLEEP_MAGIC	0x00000bad
+#define EXYNOS_AFTR_MAGIC	0xfcba0d10
 #define EXYNOS_BOOT_ADDR	0x8
 #define EXYNOS_BOOT_FLAG	0xc
 
+/* For Cortex-A9 Diagnostic and Power control register */
+static unsigned int cp15_power;
+static unsigned int cp15_diag;
+
+static void exynos_save_cp15(void)
+{
+	/* Save Power control and Diagnostic registers */
+	asm ("mrc p15, 0, %0, c15, c0, 0\n"
+	     "mrc p15, 0, %1, c15, c0, 1\n"
+		: "=r" (cp15_power), "=r" (cp15_diag) : : "cc");
+}
+
 static int exynos_do_idle(unsigned long mode)
 {
 	switch (mode) {
 	case FW_DO_IDLE_AFTR:
+		exynos_save_cp15();
+		__raw_writel(virt_to_phys(exynos_cpu_resume),
+			     sysram_ns_base_addr + 0x24);
+		__raw_writel(EXYNOS_AFTR_MAGIC, sysram_ns_base_addr + 0x20);
 		exynos_smc(SMC_CMD_CPU0AFTR, 0, 0, 0);
 		break;
 	case FW_DO_IDLE_SLEEP:
@@ -76,10 +93,6 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 	return 0;
 }
 
-/* For Cortex-A9 Diagnostic and Power control register */
-static unsigned int cp15_power;
-static unsigned int cp15_diag;
-
 static int exynos_cpu_suspend(unsigned long arg)
 {
 	flush_cache_all();
@@ -94,10 +107,7 @@ static int exynos_cpu_suspend(unsigned long arg)
 
 static int exynos_suspend(void)
 {
-	/* Save Power control and Diagnostic registers */
-	asm ("mrc p15, 0, %0, c15, c0, 0\n"
-		"mrc p15, 0, %1, c15, c0, 1\n"
-		: "=r" (cp15_power), "=r" (cp15_diag) : : "cc");
+	exynos_save_cp15();
 
 	writel(EXYNOS_SLEEP_MAGIC, sysram_ns_base_addr + EXYNOS_BOOT_FLAG);
 	writel(virt_to_phys(cpu_resume),
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index c722454..af0d4bf 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -201,12 +201,19 @@ static void exynos_cpu_set_boot_vector(long flags)
 	__raw_writel(flags, exynos_boot_vector_flag());
 }
 
-void exynos_enter_aftr(void)
+int exynos_enter_aftr(void)
 {
+	int ret;
+
 	exynos_set_wakeupmask(0x0000ff3e);
-	exynos_cpu_set_boot_vector(S5P_CHECK_AFTR);
 	/* Set value of power down register for aftr mode */
 	exynos_sys_powerdown_conf(SYS_AFTR);
+
+	ret = call_firmware_op(do_idle, FW_DO_IDLE_AFTR);
+	if (ret == -ENOSYS)
+		exynos_cpu_set_boot_vector(S5P_CHECK_AFTR);
+
+	return ret;
 }
 
 /* For Cortex-A9 Diagnostic and Power control register */
diff --git a/drivers/cpuidle/cpuidle-exynos.c b/drivers/cpuidle/cpuidle-exynos.c
index 7c01512..c5b36d3 100644
--- a/drivers/cpuidle/cpuidle-exynos.c
+++ b/drivers/cpuidle/cpuidle-exynos.c
@@ -18,12 +18,12 @@
 #include <asm/suspend.h>
 #include <asm/cpuidle.h>
 
-static void (*exynos_enter_aftr)(void);
+static int (*exynos_enter_aftr)(void);
 
 static int idle_finisher(unsigned long flags)
 {
-	exynos_enter_aftr();
-	cpu_do_idle();
+	if (exynos_enter_aftr() == -ENOSYS)
+		cpu_do_idle();
 
 	return 1;
 }
-- 
1.8.2.3

