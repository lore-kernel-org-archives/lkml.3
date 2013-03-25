Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3CYKPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:15:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52837 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab3CYKMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:12:03 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH 4/9] cpufreq: imx: move cpufreq driver to drivers/cpufreq
Date: Mon, 25 Mar 2013 15:41:35 +0530
Message-Id: <6c0d4611de3586b12d5df9beaa5d21e4703dd38b.1364205812.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 25 Mar 2013 10:12:00.0344 (UTC) FILETIME=[307D1580:01CE2941]
X-MC-Unique: 113032510120134301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2PAFqWw026849

This patch moves cpufreq driver of ARM based imx platform to drivers/cpufreq.

Cc: Sascha Hauer <kernel@pengutronix.de>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/Kconfig                                             |  7 -------
 arch/arm/mach-imx/Makefile                                   |  1 -
 arch/arm/mach-imx/mxc.h                                      |  6 +-----
 drivers/cpufreq/Kconfig.arm                                  |  7 +++++++
 drivers/cpufreq/Makefile                                     |  1 +
 arch/arm/mach-imx/cpufreq.c => drivers/cpufreq/imx-cpufreq.c |  7 +++----
 include/linux/cpufreq/imx.h                                  | 10 ++++++++++
 7 files changed, 22 insertions(+), 17 deletions(-)
 rename arch/arm/mach-imx/cpufreq.c => drivers/cpufreq/imx-cpufreq.c (99%)
 create mode 100644 include/linux/cpufreq/imx.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2c3bdce..0295a08 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2156,13 +2156,6 @@ if ARCH_HAS_CPUFREQ
 
 source "drivers/cpufreq/Kconfig"
 
-config CPU_FREQ_IMX
-	tristate "CPUfreq driver for i.MX CPUs"
-	depends on ARCH_MXC && CPU_FREQ
-	select CPU_FREQ_TABLE
-	help
-	  This enables the CPUfreq driver for i.MX CPUs.
-
 config CPU_FREQ_SA1100
 	bool
 
diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index c4ce090..e313433 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -27,7 +27,6 @@ obj-$(CONFIG_IRAM_ALLOC) += iram_alloc.o
 obj-$(CONFIG_MXC_ULPI) += ulpi.o
 obj-$(CONFIG_MXC_USE_EPIT) += epit.o
 obj-$(CONFIG_MXC_DEBUG_BOARD) += 3ds_debugboard.o
-obj-$(CONFIG_CPU_FREQ_IMX)    += cpufreq.o
 
 ifeq ($(CONFIG_CPU_IDLE),y)
 obj-y += cpuidle.o
diff --git a/arch/arm/mach-imx/mxc.h b/arch/arm/mach-imx/mxc.h
index 7dce17a..ec8d752 100644
--- a/arch/arm/mach-imx/mxc.h
+++ b/arch/arm/mach-imx/mxc.h
@@ -151,13 +151,9 @@ extern unsigned int __mxc_cpu_type;
 
 #ifndef __ASSEMBLY__
 
-struct cpu_op {
-	u32 cpu_rate;
-};
+#include <linux/cpufreq/imx.h>
 
 int tzic_enable_wake(void);
-
-extern struct cpu_op *(*get_cpu_op)(int *op);
 #endif
 
 #define cpu_is_mx3()	(cpu_is_mx31() || cpu_is_mx35())
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index b72a2b3..3d83bc5 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -45,6 +45,13 @@ config ARM_HIGHBANK_CPUFREQ
 
 	  If in doubt, say N.
 
+config ARM_IMX_CPUFREQ
+	tristate "CPUfreq driver for i.MX CPUs"
+	depends on ARCH_MXC
+	select CPU_FREQ_TABLE
+	help
+	  This enables the CPUfreq driver for i.MX CPUs.
+
 config ARM_IMX6Q_CPUFREQ
 	tristate "Freescale i.MX6Q cpufreq support"
 	depends on SOC_IMX6Q
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index efce6c7..2759192 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)	+= exynos4210-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS4X12_CPUFREQ)	+= exynos4x12-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS5250_CPUFREQ)	+= exynos5250-cpufreq.o
 obj-$(CONFIG_ARM_HIGHBANK_CPUFREQ)	+= highbank-cpufreq.o
+obj-$(CONFIG_ARM_IMX_CPUFREQ)		+= imx-cpufreq.o
 obj-$(CONFIG_ARM_IMX6Q_CPUFREQ)		+= imx6q-cpufreq.o
 obj-$(CONFIG_ARM_KIRKWOOD_CPUFREQ)	+= kirkwood-cpufreq.o
 obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)	+= omap-cpufreq.o
diff --git a/arch/arm/mach-imx/cpufreq.c b/drivers/cpufreq/imx-cpufreq.c
similarity index 99%
rename from arch/arm/mach-imx/cpufreq.c
rename to drivers/cpufreq/imx-cpufreq.c
index cfce5e3..3b856e0 100644
--- a/arch/arm/mach-imx/cpufreq.c
+++ b/drivers/cpufreq/imx-cpufreq.c
@@ -17,14 +17,13 @@
  * the CPU clock speed on the fly.
  */
 
-#include <linux/module.h>
-#include <linux/cpufreq.h>
 #include <linux/clk.h>
+#include <linux/cpufreq.h>
+#include <linux/cpufreq/imx.h>
 #include <linux/err.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 
-#include "hardware.h"
-
 #define CLK32_FREQ	32768
 #define NANOSECOND	(1000 * 1000 * 1000)
 
diff --git a/include/linux/cpufreq/imx.h b/include/linux/cpufreq/imx.h
new file mode 100644
index 0000000..dd2cc49
--- /dev/null
+++ b/include/linux/cpufreq/imx.h
@@ -0,0 +1,10 @@
+#ifndef CPUFREQ_IMX_H
+#define CPUFREQ_IMX_H
+
+struct cpu_op {
+	u32 cpu_rate;
+};
+
+extern struct cpu_op *(*get_cpu_op)(int *op);
+
+#endif
-- 
1.7.12.rc2.18.g61b472e


