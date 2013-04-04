Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156Ab3DDM5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:57:45 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36973 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761131Ab3DDM5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:57:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 18/18] cpufreq: powerpc/platforms/cell: move cpufreq driver to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:26 +0530
Message-Id: <0f989533f2e47d4d632710029bf0273082bafee3.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of powerpc platforms/cell to drivers/cpufreq.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Compile Tested only.

 arch/powerpc/platforms/cell/Kconfig                | 26 +---------------------
 arch/powerpc/platforms/cell/Makefile               |  3 ---
 drivers/cpufreq/Kconfig.powerpc                    | 18 +++++++++++++++
 drivers/cpufreq/Makefile                           |  3 +++
 .../cpufreq/ppc_cbe_cpufreq.c                      |  2 +-
 .../cpufreq/ppc_cbe_cpufreq_pervasive.c            |  3 +--
 .../cpufreq/ppc_cbe_cpufreq_pmi.c                  |  3 +--
 .../linux/ppc_cbe_cpufreq.h                        |  4 ++--
 8 files changed, 27 insertions(+), 35 deletions(-)
 rename arch/powerpc/platforms/cell/cbe_cpufreq.c => drivers/cpufreq/ppc_cbe_cpufreq.c (99%)
 rename arch/powerpc/platforms/cell/cbe_cpufreq_pervasive.c => drivers/cpufreq/ppc_cbe_cpufreq_pervasive.c (98%)
 rename arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c => drivers/cpufreq/ppc_cbe_cpufreq_pmi.c (99%)
 rename arch/powerpc/platforms/cell/cbe_cpufreq.h => include/linux/ppc_cbe_cpufreq.h (82%)

diff --git a/arch/powerpc/platforms/cell/Kconfig b/arch/powerpc/platforms/cell/Kconfig
index 53aaefe..9978f59 100644
--- a/arch/powerpc/platforms/cell/Kconfig
+++ b/arch/powerpc/platforms/cell/Kconfig
@@ -113,34 +113,10 @@ config CBE_THERM
 	default m
 	depends on CBE_RAS && SPU_BASE
 
-config CBE_CPUFREQ
-	tristate "CBE frequency scaling"
-	depends on CBE_RAS && CPU_FREQ
-	default m
-	help
-	  This adds the cpufreq driver for Cell BE processors.
-	  For details, take a look at <file:Documentation/cpu-freq/>.
-	  If you don't have such processor, say N
-
-config CBE_CPUFREQ_PMI_ENABLE
-	bool "CBE frequency scaling using PMI interface"
-	depends on CBE_CPUFREQ
-	default n
-	help
-	  Select this, if you want to use the PMI interface
-	  to switch frequencies. Using PMI, the
-	  processor will not only be able to run at lower speed,
-	  but also at lower core voltage.
-
-config CBE_CPUFREQ_PMI
-	tristate
-	depends on CBE_CPUFREQ_PMI_ENABLE
-	default CBE_CPUFREQ
-
 config PPC_PMI
 	tristate
 	default y
-	depends on CBE_CPUFREQ_PMI || PPC_IBM_CELL_POWERBUTTON
+	depends on CPU_FREQ_CBE_PMI || PPC_IBM_CELL_POWERBUTTON
 	help
 	  PMI (Platform Management Interrupt) is a way to
 	  communicate with the BMC (Baseboard Management Controller).
diff --git a/arch/powerpc/platforms/cell/Makefile b/arch/powerpc/platforms/cell/Makefile
index a4a8935..fe053e7 100644
--- a/arch/powerpc/platforms/cell/Makefile
+++ b/arch/powerpc/platforms/cell/Makefile
@@ -5,9 +5,6 @@ obj-$(CONFIG_PPC_CELL_NATIVE)		+= iommu.o setup.o spider-pic.o \
 obj-$(CONFIG_CBE_RAS)			+= ras.o
 
 obj-$(CONFIG_CBE_THERM)			+= cbe_thermal.o
-obj-$(CONFIG_CBE_CPUFREQ_PMI)		+= cbe_cpufreq_pmi.o
-obj-$(CONFIG_CBE_CPUFREQ)		+= cbe-cpufreq.o
-cbe-cpufreq-y				+= cbe_cpufreq_pervasive.o cbe_cpufreq.o
 obj-$(CONFIG_CBE_CPUFREQ_SPU_GOVERNOR)	+= cpufreq_spudemand.o
 
 obj-$(CONFIG_PPC_IBM_CELL_POWERBUTTON)	+= cbe_powerbutton.o
diff --git a/drivers/cpufreq/Kconfig.powerpc b/drivers/cpufreq/Kconfig.powerpc
index 2e5a007..9e1ae94 100644
--- a/drivers/cpufreq/Kconfig.powerpc
+++ b/drivers/cpufreq/Kconfig.powerpc
@@ -1,3 +1,21 @@
+config CPU_FREQ_CBE
+	tristate "CBE frequency scaling"
+	depends on CBE_RAS && PPC_CELL
+	default m
+	help
+	  This adds the cpufreq driver for Cell BE processors.
+	  For details, take a look at <file:Documentation/cpu-freq/>.
+	  If you don't have such processor, say N
+
+config CPU_FREQ_CBE_PMI
+	bool "CBE frequency scaling using PMI interface"
+	depends on CPU_FREQ_CBE
+	default n
+	help
+	  Select this, if you want to use the PMI interface to switch
+	  frequencies. Using PMI, the processor will not only be able to run at
+	  lower speed, but also at lower core voltage.
+
 config CPU_FREQ_MAPLE
 	bool "Support for Maple 970FX Evaluation Board"
 	depends on PPC_MAPLE
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 7b16092f..bfefa22 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -78,6 +78,9 @@ obj-$(CONFIG_ARCH_TEGRA)		+= tegra-cpufreq.o
 
 ##################################################################################
 # PowerPC platform drivers
+obj-$(CONFIG_CPU_FREQ_CBE)		+= ppc-cbe-cpufreq.o
+ppc-cbe-cpufreq-y			+= ppc_cbe_cpufreq_pervasive.o ppc_cbe_cpufreq.o
+obj-$(CONFIG_CPU_FREQ_CBE_PMI)		+= ppc_cbe_cpufreq_pmi.o
 obj-$(CONFIG_CPU_FREQ_MAPLE)		+= maple-cpufreq.o
 obj-$(CONFIG_CPU_FREQ_PMAC)		+= pmac32-cpufreq.o
 obj-$(CONFIG_CPU_FREQ_PMAC64)		+= pmac64-cpufreq.o
diff --git a/arch/powerpc/platforms/cell/cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
similarity index 99%
rename from arch/powerpc/platforms/cell/cbe_cpufreq.c
rename to drivers/cpufreq/ppc_cbe_cpufreq.c
index 718c6a3..6d7a51d 100644
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -23,11 +23,11 @@
 #include <linux/cpufreq.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
+#include <linux/ppc_cbe_cpufreq.h>
 
 #include <asm/machdep.h>
 #include <asm/prom.h>
 #include <asm/cell-regs.h>
-#include "cbe_cpufreq.h"
 
 static DEFINE_MUTEX(cbe_switch_mutex);
 
diff --git a/arch/powerpc/platforms/cell/cbe_cpufreq_pervasive.c b/drivers/cpufreq/ppc_cbe_cpufreq_pervasive.c
similarity index 98%
rename from arch/powerpc/platforms/cell/cbe_cpufreq_pervasive.c
rename to drivers/cpufreq/ppc_cbe_cpufreq_pervasive.c
index 20472e4..6708710 100644
--- a/arch/powerpc/platforms/cell/cbe_cpufreq_pervasive.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq_pervasive.c
@@ -25,13 +25,12 @@
 
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/ppc_cbe_cpufreq.h>
 #include <linux/time.h>
 #include <asm/machdep.h>
 #include <asm/hw_irq.h>
 #include <asm/cell-regs.h>
 
-#include "cbe_cpufreq.h"
-
 /* to write to MIC register */
 static u64 MIC_Slow_Fast_Timer_table[] = {
 	[0 ... 7] = 0x007fc00000000000ull,
diff --git a/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c b/drivers/cpufreq/ppc_cbe_cpufreq_pmi.c
similarity index 99%
rename from arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
rename to drivers/cpufreq/ppc_cbe_cpufreq_pmi.c
index 60a07a4..448b888 100644
--- a/arch/powerpc/platforms/cell/cbe_cpufreq_pmi.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq_pmi.c
@@ -25,6 +25,7 @@
 #include <linux/timer.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
+#include <linux/ppc_cbe_cpufreq.h>
 
 #include <asm/processor.h>
 #include <asm/prom.h>
@@ -35,8 +36,6 @@
 #include <asm/time.h>
 #endif
 
-#include "cbe_cpufreq.h"
-
 static u8 pmi_slow_mode_limit[MAX_CBE];
 
 bool cbe_cpufreq_has_pmi = false;
diff --git a/arch/powerpc/platforms/cell/cbe_cpufreq.h b/include/linux/ppc_cbe_cpufreq.h
similarity index 82%
rename from arch/powerpc/platforms/cell/cbe_cpufreq.h
rename to include/linux/ppc_cbe_cpufreq.h
index c1d86bf..b4c00a5 100644
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.h
+++ b/include/linux/ppc_cbe_cpufreq.h
@@ -1,5 +1,5 @@
 /*
- * cbe_cpufreq.h
+ * ppc_cbe_cpufreq.h
  *
  * This file contains the definitions used by the cbe_cpufreq driver.
  *
@@ -17,7 +17,7 @@ int cbe_cpufreq_get_pmode(int cpu);
 
 int cbe_cpufreq_set_pmode_pmi(int cpu, unsigned int pmode);
 
-#if defined(CONFIG_CBE_CPUFREQ_PMI) || defined(CONFIG_CBE_CPUFREQ_PMI_MODULE)
+#if defined(CONFIG_CPU_FREQ_CBE_PMI) || defined(CONFIG_CPU_FREQ_CBE_PMI_MODULE)
 extern bool cbe_cpufreq_has_pmi;
 #else
 #define cbe_cpufreq_has_pmi (0)
-- 
1.7.12.rc2.18.g61b472e

