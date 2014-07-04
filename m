Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbaGDRw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:52:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33588 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759511AbaGDRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:49:03 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-cd-53b6e90b586d
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 12/19] ARM: S5PV210: Untie PM support from legacy code
Date: Fri, 04 Jul 2014 19:48:12 +0200
Message-id: <1404496099-26708-13-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xy7rcL7cFG/x7rW/xd9IxdoupD5+w
	Wfx/9JrVonfBVTaLTY+vsVpc3jWHzWLG+X1MFmuP3GW3OHX9M5vFql1/GB24PH7/msTosXPW
	XXaPTas62Tw2L6n3uHKiidWjb8sqRo/t1+Yxe3zeJBfAEcVlk5Kak1mWWqRvl8CVsXCbeMF8
	64o9N/8wNzC2G3YxcnJICJhIrF5xmhnCFpO4cG89WxcjF4eQwFJGiTvHJoAlhAT6mCQeHVUF
	sdkE1CQ+NzxiA7FFBFQlPrctYO9i5OBgFrjNJNEqDBIWFnCTmLTgIguIzQJU0n76GpjNK+As
	sfjUB0aIXXISvdvegI3nBIpPXHeBCWKVk8Sf//NZJjDyLmBkWMUomlqaXFCclJ5rpFecmFtc
	mpeul5yfu4kREopfdzAuPWZ1iFGAg1GJh7ehZVuwEGtiWXFl7iFGCQ5mJRHeP6uAQrwpiZVV
	qUX58UWlOanFhxiZODilGhi93+WfZRPXvMn0Svrhl2V3Qy/sZ2v8+6t+Zt+Xc3azT0u+/fCN
	Uy4xXN+9tEzDWKKk6X3Ln1mztJber6xkFLgvrNYipNvP3PrItfZy09tdj1nm2mfyr07gLtj6
	Ldz7Q7hlgtFJzf7vK13nxohP7DN8+7N1fuBkB8a1Z8y8j1TbpXr8kNu7IlWJpTgj0VCLuag4
	EQDvfVTEIwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes S5PV210 not rely on legacy suspend helpers in
plat-samsung and implements platform suspend logic locally, similarly to
Exynos.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-s5pv210/Kconfig   |   2 -
 arch/arm/mach-s5pv210/Makefile  |   2 +-
 arch/arm/mach-s5pv210/common.h  |   7 +++
 arch/arm/mach-s5pv210/pm.c      | 101 +++++++++++++++++++++++++++++++++++-----
 arch/arm/mach-s5pv210/s5pv210.c |   8 ++++
 arch/arm/mach-s5pv210/sleep.S   |  36 ++++++++++++++
 6 files changed, 141 insertions(+), 15 deletions(-)
 create mode 100644 arch/arm/mach-s5pv210/sleep.S

diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index d6d0f92..ffc777d 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -14,8 +14,6 @@ config CPU_S5PV210
 	select ARM_AMBA
 	select PL330_DMA if DMADEVICES
 	select S5P_EXT_INT
-	select S5P_PM if PM
-	select S5P_SLEEP if PM
 	help
 	  Enable S5PV210 CPU support
 
diff --git a/arch/arm/mach-s5pv210/Makefile b/arch/arm/mach-s5pv210/Makefile
index 83993fc..5308225 100644
--- a/arch/arm/mach-s5pv210/Makefile
+++ b/arch/arm/mach-s5pv210/Makefile
@@ -12,7 +12,7 @@ obj-				:=
 
 # Core
 
-obj-$(CONFIG_PM)		+= pm.o
+obj-$(CONFIG_PM_SLEEP)		+= pm.o sleep.o
 
 # machine support
 
diff --git a/arch/arm/mach-s5pv210/common.h b/arch/arm/mach-s5pv210/common.h
index 0b694c7..2ad387c 100644
--- a/arch/arm/mach-s5pv210/common.h
+++ b/arch/arm/mach-s5pv210/common.h
@@ -12,5 +12,12 @@
 #ifndef __ARCH_ARM_MACH_S5PV210_COMMON_H
 #define __ARCH_ARM_MACH_S5PV210_COMMON_H
 
+#ifdef CONFIG_PM_SLEEP
+u32 exynos_get_eint_wake_mask(void);
+void s5pv210_cpu_resume(void);
+void s5pv210_pm_init(void);
+#else
+static inline void s5pv210_pm_init(void) {}
+#endif
 
 #endif /* __ARCH_ARM_MACH_S5PV210_COMMON_H */
diff --git a/arch/arm/mach-s5pv210/pm.c b/arch/arm/mach-s5pv210/pm.c
index 00d1523..123163d 100644
--- a/arch/arm/mach-s5pv210/pm.c
+++ b/arch/arm/mach-s5pv210/pm.c
@@ -1,6 +1,6 @@
 /* linux/arch/arm/mach-s5pv210/pm.c
  *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2010-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
  * S5PV210 - Power Management support
@@ -19,17 +19,28 @@
 #include <linux/syscore_ops.h>
 #include <linux/io.h>
 
-#include <plat/cpu.h>
-#include <plat/pm.h>
+#include <asm/cacheflush.h>
+#include <asm/suspend.h>
+
+#include <plat/pm-common.h>
 
-#include <mach/regs-irq.h>
 #include <mach/regs-clock.h>
 
+#include "common.h"
+
 static struct sleep_save s5pv210_core_save[] = {
 	/* Clock ETC */
 	SAVE_ITEM(S5P_MDNIE_SEL),
 };
 
+/*
+ * VIC wake-up support (TODO)
+ */
+static u32 s5pv210_irqwake_intmask = 0xffffffff;
+
+/*
+ * Suspend helpers.
+ */
 static int s5pv210_cpu_suspend(unsigned long arg)
 {
 	unsigned long tmp;
@@ -54,8 +65,12 @@ static void s5pv210_pm_prepare(void)
 {
 	unsigned int tmp;
 
+	/* Set wake-up mask registers */
+	__raw_writel(exynos_get_eint_wake_mask(), S5P_EINT_WAKEUP_MASK);
+	__raw_writel(s5pv210_irqwake_intmask, S5P_WAKEUP_MASK);
+
 	/* ensure at least INFORM0 has the resume address */
-	__raw_writel(virt_to_phys(s3c_cpu_resume), S5P_INFORM0);
+	__raw_writel(virt_to_phys(s5pv210_cpu_resume), S5P_INFORM0);
 
 	tmp = __raw_readl(S5P_SLEEP_CFG);
 	tmp &= ~(S5P_SLEEP_CFG_OSC_EN | S5P_SLEEP_CFG_USBOSC_EN);
@@ -75,6 +90,70 @@ static void s5pv210_pm_prepare(void)
 	s3c_pm_do_save(s5pv210_core_save, ARRAY_SIZE(s5pv210_core_save));
 }
 
+/*
+ * Suspend operations.
+ */
+static int s5pv210_suspend_enter(suspend_state_t state)
+{
+	int ret;
+
+	s3c_pm_debug_init();
+
+	S3C_PMDBG("%s: suspending the system...\n", __func__);
+
+	S3C_PMDBG("%s: wakeup masks: %08x,%08x\n", __func__,
+			s5pv210_irqwake_intmask, exynos_get_eint_wake_mask());
+
+	if (s5pv210_irqwake_intmask == -1U
+	    && exynos_get_eint_wake_mask() == -1U) {
+		pr_err("%s: No wake-up sources!\n", __func__);
+		pr_err("%s: Aborting sleep\n", __func__);
+		return -EINVAL;
+	}
+
+	s3c_pm_save_uarts();
+	s5pv210_pm_prepare();
+	flush_cache_all();
+	s3c_pm_check_store();
+
+	ret = cpu_suspend(0, s5pv210_cpu_suspend);
+	if (ret)
+		return ret;
+
+	s3c_pm_restore_uarts();
+
+	S3C_PMDBG("%s: wakeup stat: %08x\n", __func__,
+			__raw_readl(S5P_WAKEUP_STAT));
+
+	s3c_pm_check_restore();
+
+	S3C_PMDBG("%s: resuming the system...\n", __func__);
+
+	return 0;
+}
+
+static int s5pv210_suspend_prepare(void)
+{
+	s3c_pm_check_prepare();
+
+	return 0;
+}
+
+static void s5pv210_suspend_finish(void)
+{
+	s3c_pm_check_cleanup();
+}
+
+static const struct platform_suspend_ops s5pv210_suspend_ops = {
+	.enter		= s5pv210_suspend_enter,
+	.prepare	= s5pv210_suspend_prepare,
+	.finish		= s5pv210_suspend_finish,
+	.valid		= suspend_valid_only_mem,
+};
+
+/*
+ * Syscore operations used to delay restore of certain registers.
+ */
 static void s5pv210_pm_resume(void)
 {
 	u32 tmp;
@@ -91,13 +170,11 @@ static struct syscore_ops s5pv210_pm_syscore_ops = {
 	.resume		= s5pv210_pm_resume,
 };
 
-static __init int s5pv210_pm_syscore_init(void)
+/*
+ * Initialization entry point.
+ */
+void __init s5pv210_pm_init(void)
 {
 	register_syscore_ops(&s5pv210_pm_syscore_ops);
-
-	pm_cpu_prep = s5pv210_pm_prepare;
-	pm_cpu_sleep = s5pv210_cpu_suspend;
-
-	return 0;
+	suspend_set_ops(&s5pv210_suspend_ops);
 }
-arch_initcall(s5pv210_pm_syscore_init);
diff --git a/arch/arm/mach-s5pv210/s5pv210.c b/arch/arm/mach-s5pv210/s5pv210.c
index c244ccb..35db1ce 100644
--- a/arch/arm/mach-s5pv210/s5pv210.c
+++ b/arch/arm/mach-s5pv210/s5pv210.c
@@ -20,6 +20,8 @@
 #include <plat/map-base.h>
 #include <mach/regs-clock.h>
 
+#include "common.h"
+
 static int __init s5pv210_fdt_map_sys(unsigned long node, const char *uname,
 					int depth, void *data)
 {
@@ -55,6 +57,11 @@ static void s5pv210_dt_restart(enum reboot_mode mode, const char *cmd)
 	__raw_writel(0x1, S5P_SWRESET);
 }
 
+static void __init s5pv210_dt_init_late(void)
+{
+	s5pv210_pm_init();
+}
+
 static char const *s5pv210_dt_compat[] __initconst = {
 	"samsung,s5pc110",
 	"samsung,s5pv210",
@@ -65,4 +72,5 @@ DT_MACHINE_START(S5PV210_DT, "Samsung S5PC110/S5PV210-based board")
 	.dt_compat = s5pv210_dt_compat,
 	.map_io = s5pv210_dt_map_io,
 	.restart = s5pv210_dt_restart,
+	.init_late = s5pv210_dt_init_late,
 MACHINE_END
diff --git a/arch/arm/mach-s5pv210/sleep.S b/arch/arm/mach-s5pv210/sleep.S
new file mode 100644
index 0000000..7c43ddd
--- /dev/null
+++ b/arch/arm/mach-s5pv210/sleep.S
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * S5PV210 Sleep Code
+ * Based on S3C64XX sleep code by:
+ *	Ben Dooks, (c) 2008 Simtec Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/linkage.h>
+
+	.data
+	.align
+
+	/*
+	 * sleep magic, to allow the bootloader to check for an valid
+	 * image to resume to. Must be the first word before the
+	 * s3c_cpu_resume entry.
+	 */
+
+	.word	0x2bedf00d
+
+	/*
+	 * s3c_cpu_resume
+	 *
+	 * resume code entry for bootloader to call
+	 */
+
+ENTRY(s5pv210_cpu_resume)
+	b	cpu_resume
+ENDPROC(s5pv210_cpu_resume)
-- 
1.9.3

