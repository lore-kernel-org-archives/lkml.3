Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaHDRqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:46:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36691 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaHDRqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:46:13 -0400
X-AuditID: cbfee61a-f79e46d00000134f-44-53dfc6e382d7
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
Subject: [PATCH v4 3/5] ARM: EXYNOS: cpuidle: add secure firmware support to
 AFTR mode code
Date: Mon, 04 Aug 2014 19:45:43 +0200
Message-id: <1407174345-31213-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1407174345-31213-1-git-send-email-b.zolnierkie@samsung.com>
References: <1407174345-31213-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jAd3Hx+4HG3w/LWyxccZ6Vot5n2Ut
	ehdcZbM42/SG3eL9oWfMFpseX2O1uLxrDpvF594jjBYzzu9jsjhz+hKrxck/vYwW62e8ZrHY
	+NXDgdfjzrU9bB6bl9R73P73mNljy9V2Fo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DK+PFP
	r+ChTEVvVwNTA+Nr8S5GTg4JAROJN6ufMUPYYhIX7q1n62Lk4hASWMQocWjLaSYIp4tJYnXL
	a1aQKjYBK4mJ7asYQWwRATWJnsVbGUGKmAX2Mkss7d7EDpIQFoiV2HL9EtBYDg4WAVWJwzdz
	QUxeAQ+JvxszIJYpSnQ/m8AGYnMKeEr8OPILzBYCKuk+tJxxAiPvAkaGVYyiqQXJBcVJ6bmG
	esWJucWleel6yfm5mxjBIflMagfjygaLQ4wCHIxKPLwCaveDhVgTy4orcw8xSnAwK4nw1h0A
	CvGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBaBJNl4uCUamBM/XE4+Gdj
	085TnjJiM9oufbqbVv/34IXEjwzlhfP93BJD1I0PJmsHMMUm62Sf/2bA+cyPd123l5Hovg0N
	puyfT8Rb9arEVei+TuTvmawcofqPvaPw2i2roM/WB+I2TZ0ak1wl/2cRU2ql97e9PZxuJ05d
	nqStLP409K+QqpJOh/ubbTm8z5RYijMSDbWYi4oTAf6xHQRFAgAA
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
 arch/arm/mach-exynos/firmware.c | 23 ++++++++++++++++-------
 arch/arm/mach-exynos/pm.c       | 17 ++++++++++++-----
 2 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index e57b7c3..b51b258 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -25,13 +25,27 @@
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
+		exynos_save_cp15();
+		__raw_writel(virt_to_phys(exynos_cpu_resume_ns),
+			     sysram_ns_base_addr + 0x24);
+		__raw_writel(EXYNOS_AFTR_MAGIC, sysram_ns_base_addr + 0x20);
 		exynos_smc(SMC_CMD_CPU0AFTR, 0, 0, 0);
 		break;
 	case FW_DO_IDLE_SLEEP:
@@ -96,13 +110,8 @@ static int exynos_cpu_suspend(unsigned long arg)
 
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
index eeef8c4..a61b85c 100644
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
+		if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
+			exynos_cpu_save_register();
+		exynos_cpu_set_boot_vector(S5P_CHECK_AFTR);
+		cpu_do_idle();
+	}
 
 	return 1;
 }
@@ -223,14 +231,13 @@ void exynos_enter_aftr(void)
 	cpu_pm_enter();
 
 	exynos_pm_central_suspend();
-	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
-		exynos_cpu_save_register();
 
 	cpu_suspend(0, exynos_aftr_finisher);
 
 	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9) {
 		scu_enable(S5P_VA_SCU);
-		exynos_cpu_restore_register();
+		if (call_firmware_op(resume) == -ENOSYS)
+			exynos_cpu_restore_register();
 	}
 
 	exynos_pm_central_resume();
-- 
1.8.2.3

