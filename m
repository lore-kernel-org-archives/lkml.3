Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbaIENwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:52:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35529 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559AbaIENw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:52:29 -0400
X-AuditID: cbfee61a-f79e46d00000134f-f0-5409c01b06ad
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v6 3/5] ARM: EXYNOS: cpuidle: add secure firmware support to
 AFTR mode code
Date: Fri, 05 Sep 2014 15:51:26 +0200
Message-id: <1409925088-4705-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
References: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jAV3pA5whBodma1hsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PFxq8eDjwe
	d67tYfPYvKTe4/a/x8weW662s3j0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXRt+6d8wFM2Qr
	Nl9Zy9rAOEmii5GTQ0LAROJC03tmCFtM4sK99WxdjFwcQgKLGCXOrXzLDuF0MUnM3PiVDaSK
	TcBKYmL7KkYQW0RATaJn8VZGkCJmgdnMEq8ePmABSQgLxEqsuPYbrIFFQFVi6ay77CA2r4C7
	xLe9e6HWKUp0P5sAVsMp4CEx5cEXsLgQUM3O7pssExh5FzAyrGIUTS1ILihOSs811CtOzC0u
	zUvXS87P3cQIDsdnUjsYVzZYHGIU4GBU4uFd8JkjRIg1say4MvcQowQHs5IIr+1uzhAh3pTE
	yqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjEcals12Mlm49lWL
	ktC8CO8iJbe/ntu33VELCzzvv23XY57Ji+/pNy5xnO54oUY0Y8rj5hXcJsu8t+7rzn6nn58j
	vVJWx/ZPvM69gwU7J7+ocF3bUa8k9edK6eytH3Mf7SpsyJdznHOI4+zVq4wLeGLCHETecTcG
	N1czCwZXamww9Yqt9dP5osRSnJFoqMVcVJwIAEBjMGBDAgAA
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
v6:
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
index 78e50ed..e0b6885 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -209,11 +209,19 @@ static void exynos_cpu_set_boot_vector(long flags)
 
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
@@ -223,14 +231,13 @@ void exynos_enter_aftr(void)
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

