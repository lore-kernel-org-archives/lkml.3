Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaA3ShI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:37:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39489 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaA3ShF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:37:05 -0500
From: Kumar Gala <galak@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Kumar Gala <galak@codeaurora.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] clocksource: qcom: Move clocksource code out of mach-msm
Date: Thu, 30 Jan 2014 12:36:39 -0600
Message-Id: <1391107002-21470-2-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1391107002-21470-1-git-send-email-galak@codeaurora.org>
References: <1391107002-21470-1-git-send-email-galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We intent to share the clocksource code for MSM platforms between legacy
and multiplatform supported qcom SoCs.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig                                   | 13 +++++--------
 arch/arm/mach-msm/Makefile                                  |  1 -
 drivers/clocksource/Kconfig                                 |  4 ++++
 drivers/clocksource/Makefile                                |  1 +
 .../mach-msm/timer.c => drivers/clocksource/qcom-timer.c    |  6 +-----
 5 files changed, 11 insertions(+), 14 deletions(-)
 rename arch/arm/mach-msm/timer.c => drivers/clocksource/qcom-timer.c (98%)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 9625cf3..3c4eca7 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -21,7 +21,7 @@ config ARCH_MSM8X60
 	select CPU_V7
 	select HAVE_SMP
 	select MSM_SCM if SMP
-	select MSM_TIMER
+	select CLKSRC_QCOM
 
 config ARCH_MSM8960
 	bool "Enable support for MSM8960"
@@ -29,7 +29,7 @@ config ARCH_MSM8960
 	select CPU_V7
 	select HAVE_SMP
 	select MSM_SCM if SMP
-	select MSM_TIMER
+	select CLKSRC_QCOM
 
 config ARCH_MSM8974
 	bool "Enable support for MSM8974"
@@ -54,7 +54,7 @@ config ARCH_MSM7X00A
 	select MACH_TROUT if !MACH_HALIBUT
 	select MSM_PROC_COMM
 	select MSM_SMD
-	select MSM_TIMER
+	select CLKSRC_QCOM
 	select MSM_SMD_PKG3
 
 config ARCH_MSM7X30
@@ -66,7 +66,7 @@ config ARCH_MSM7X30
 	select MSM_GPIOMUX
 	select MSM_PROC_COMM
 	select MSM_SMD
-	select MSM_TIMER
+	select CLKSRC_QCOM
 	select MSM_VIC
 
 config ARCH_QSD8X50
@@ -78,7 +78,7 @@ config ARCH_QSD8X50
 	select MSM_GPIOMUX
 	select MSM_PROC_COMM
 	select MSM_SMD
-	select MSM_TIMER
+	select CLKSRC_QCOM
 	select MSM_VIC
 
 endchoice
@@ -153,7 +153,4 @@ config MSM_GPIOMUX
 config MSM_SCM
 	bool
 
-config MSM_TIMER
-	bool
-
 endif
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 721f27f..4baff13 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,4 +1,3 @@
-obj-$(CONFIG_MSM_TIMER) += timer.o
 obj-$(CONFIG_MSM_PROC_COMM) += clock.o
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index cd6950f..81caa16 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -140,3 +140,7 @@ config VF_PIT_TIMER
 	bool
 	help
 	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
+
+config CLKSRC_QCOM
+	bool
+	depends on ARCH_MSM
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index c7ca50a..2e0c0cc 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_CLKSRC_EFM32)	+= time-efm32.o
 obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
 obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
 obj-$(CONFIG_VF_PIT_TIMER)	+= vf_pit_timer.o
+obj-$(CONFIG_CLKSRC_QCOM)	+= qcom-timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
diff --git a/arch/arm/mach-msm/timer.c b/drivers/clocksource/qcom-timer.c
similarity index 98%
rename from arch/arm/mach-msm/timer.c
rename to drivers/clocksource/qcom-timer.c
index fd16449..dca829e 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/drivers/clocksource/qcom-timer.c
@@ -1,7 +1,7 @@
 /*
  *
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2009-2012, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2009-2012,2014, The Linux Foundation. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -26,10 +26,6 @@
 #include <linux/of_irq.h>
 #include <linux/sched_clock.h>
 
-#include <asm/mach/time.h>
-
-#include "common.h"
-
 #define TIMER_MATCH_VAL			0x0000
 #define TIMER_COUNT_VAL			0x0004
 #define TIMER_ENABLE			0x0008
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

