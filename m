Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757Ab3DDM4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:56:15 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:50906 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760733Ab3DDM4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:56:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 07/18] cpufreq: s3c24xx: move cpufreq driver to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:15 +0530
Message-Id: <927100d30bf40d4fec477cc7d8d464669a22d167.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of Samsung's ARM based s3c24xx platform to
drivers/cpufreq.

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig                                   | 46 ---------------
 arch/arm/mach-s3c24xx/Kconfig                      | 66 +++++++++-------------
 arch/arm/mach-s3c24xx/Makefile                     |  6 --
 arch/arm/mach-s3c24xx/{ => include/mach}/s3c2412.h |  0
 arch/arm/mach-s3c24xx/iotiming-s3c2412.c           |  2 +-
 arch/arm/plat-samsung/include/plat/cpu-freq-core.h | 10 ++--
 arch/arm/plat-samsung/include/plat/cpu-freq.h      |  6 +-
 drivers/cpufreq/Kconfig.arm                        | 58 +++++++++++++++++++
 drivers/cpufreq/Makefile                           |  5 ++
 .../cpufreq/s3c2410-cpufreq.c                      |  0
 .../cpufreq/s3c2412-cpufreq.c                      |  3 +-
 .../cpufreq/s3c2440-cpufreq.c                      |  0
 .../cpufreq/s3c24xx-cpufreq-debugfs.c              |  0
 .../cpufreq.c => drivers/cpufreq/s3c24xx-cpufreq.c |  0
 14 files changed, 100 insertions(+), 102 deletions(-)
 rename arch/arm/mach-s3c24xx/{ => include/mach}/s3c2412.h (100%)
 rename arch/arm/mach-s3c24xx/cpufreq-s3c2410.c => drivers/cpufreq/s3c2410-cpufreq.c (100%)
 rename arch/arm/mach-s3c24xx/cpufreq-s3c2412.c => drivers/cpufreq/s3c2412-cpufreq.c (99%)
 rename arch/arm/mach-s3c24xx/cpufreq-s3c2440.c => drivers/cpufreq/s3c2440-cpufreq.c (100%)
 rename arch/arm/mach-s3c24xx/cpufreq-debugfs.c => drivers/cpufreq/s3c24xx-cpufreq-debugfs.c (100%)
 rename arch/arm/mach-s3c24xx/cpufreq.c => drivers/cpufreq/s3c24xx-cpufreq.c (100%)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c3563f6..70366b7 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2166,52 +2166,6 @@ config CPU_FREQ_SA1100
 config CPU_FREQ_SA1110
 	bool
 
-config CPU_FREQ_S3C
-	bool
-	help
-	  Internal configuration node for common cpufreq on Samsung SoC
-
-config CPU_FREQ_S3C24XX
-	bool "CPUfreq driver for Samsung S3C24XX series CPUs (EXPERIMENTAL)"
-	depends on ARCH_S3C24XX && CPU_FREQ
-	select CPU_FREQ_S3C
-	help
-	  This enables the CPUfreq driver for the Samsung S3C24XX family
-	  of CPUs.
-
-	  For details, take a look at <file:Documentation/cpu-freq>.
-
-	  If in doubt, say N.
-
-config CPU_FREQ_S3C24XX_PLL
-	bool "Support CPUfreq changing of PLL frequency (EXPERIMENTAL)"
-	depends on CPU_FREQ_S3C24XX
-	help
-	  Compile in support for changing the PLL frequency from the
-	  S3C24XX series CPUfreq driver. The PLL takes time to settle
-	  after a frequency change, so by default it is not enabled.
-
-	  This also means that the PLL tables for the selected CPU(s) will
-	  be built which may increase the size of the kernel image.
-
-config CPU_FREQ_S3C24XX_DEBUG
-	bool "Debug CPUfreq Samsung driver core"
-	depends on CPU_FREQ_S3C24XX
-	help
-	  Enable s3c_freq_dbg for the Samsung S3C CPUfreq core
-
-config CPU_FREQ_S3C24XX_IODEBUG
-	bool "Debug CPUfreq Samsung driver IO timing"
-	depends on CPU_FREQ_S3C24XX
-	help
-	  Enable s3c_freq_iodbg for the Samsung S3C CPUfreq core
-
-config CPU_FREQ_S3C24XX_DEBUGFS
-	bool "Export debugfs for CPUFreq"
-	depends on CPU_FREQ_S3C24XX && DEBUG_FS
-	help
-	  Export status information via debugfs.
-
 endif
 
 source "drivers/cpuidle/Kconfig"
diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index 37f513d..81d2f3c 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -28,7 +28,7 @@ config CPU_S3C2410
 	select CPU_ARM920T
 	select CPU_LLSERIAL_S3C2410
 	select S3C2410_CLOCK
-	select S3C2410_CPUFREQ if CPU_FREQ_S3C24XX
+	select ARM_S3C2410_CPUFREQ if ARM_S3C24XX_CPUFREQ
 	select S3C2410_PM if PM
 	help
 	  Support for S3C2410 and S3C2410A family from the S3C24XX line
@@ -202,27 +202,38 @@ config S3C24XX_GPIO_EXTRA128
 	  Add an extra 128 gpio numbers to the available GPIO pool. This is
 	  available for boards that need extra gpios for external devices.
 
+config S3C24XX_PLL
+	bool "Support CPUfreq changing of PLL frequency (EXPERIMENTAL)"
+	depends on ARM_S3C24XX
+	help
+	  Compile in support for changing the PLL frequency from the
+	  S3C24XX series CPUfreq driver. The PLL takes time to settle
+	  after a frequency change, so by default it is not enabled.
+
+	  This also means that the PLL tables for the selected CPU(s) will
+	  be built which may increase the size of the kernel image.
+
 # cpu frequency items common between s3c2410 and s3c2440/s3c2442
 
 config S3C2410_IOTIMING
 	bool
-	depends on CPU_FREQ_S3C24XX
+	depends on ARM_S3C24XX_CPUFREQ
 	help
 	  Internal node to select io timing code that is common to the s3c2410
 	  and s3c2440/s3c2442 cpu frequency support.
 
 config S3C2410_CPUFREQ_UTILS
-	bool
-	depends on CPU_FREQ_S3C24XX
-	help
-	  Internal node to select timing code that is common to the s3c2410
-	  and s3c2440/s3c244 cpu frequency support.
+       bool
+       depends on ARM_S3C24XX_CPUFREQ
+       help
+         Internal node to select timing code that is common to the s3c2410
+         and s3c2440/s3c244 cpu frequency support.
 
 # cpu frequency support common to s3c2412, s3c2413 and s3c2442
 
 config S3C2412_IOTIMING
 	bool
-	depends on CPU_FREQ_S3C24XX && (CPU_S3C2412 || CPU_S3C2443)
+	depends on ARM_S3C24XX_CPUFREQ && (CPU_S3C2412 || CPU_S3C2443)
 	help
 	  Intel node to select io timing code that is common to the s3c2412
 	  and the s3c2443.
@@ -231,16 +242,9 @@ config S3C2412_IOTIMING
 
 if CPU_S3C2410
 
-config S3C2410_CPUFREQ
-	bool
-	depends on CPU_FREQ_S3C24XX && CPU_S3C2410
-	select S3C2410_CPUFREQ_UTILS
-	help
-	  CPU Frequency scaling support for S3C2410
-
 config S3C2410_PLL
 	bool
-	depends on S3C2410_CPUFREQ && CPU_FREQ_S3C24XX_PLL
+	depends on ARM_S3C2410_CPUFREQ && S3C24XX_PLL
 	default y
 	help
 	  Select the PLL table for the S3C2410
@@ -276,7 +280,7 @@ config ARCH_BAST
 	bool "Simtec Electronics BAST (EB2410ITX)"
 	select ISA
 	select MACH_BAST_IDE
-	select S3C2410_IOTIMING if S3C2410_CPUFREQ
+	select S3C2410_IOTIMING if ARM_S3C2410_CPUFREQ
 	select S3C24XX_DCLK
 	select S3C24XX_SIMTEC_NOR
 	select S3C24XX_SIMTEC_PM if PM
@@ -385,14 +389,6 @@ config CPU_S3C2412_ONLY
 		   !CPU_S3C2443 && CPU_S3C2412
 	default y
 
-config S3C2412_CPUFREQ
-	bool
-	depends on CPU_FREQ_S3C24XX && CPU_S3C2412
-	default y
-	select S3C2412_IOTIMING
-	help
-	  CPU Frequency scaling support for S3C2412 and S3C2413 SoC CPUs.
-
 config S3C2412_DMA
 	bool
 	help
@@ -493,14 +489,6 @@ endif	# CPU_S3C2416
 
 if CPU_S3C2440
 
-config S3C2440_CPUFREQ
-	bool "S3C2440/S3C2442 CPU Frequency scaling support"
-	depends on CPU_FREQ_S3C24XX && (CPU_S3C2440 || CPU_S3C2442)
-	default y
-	select S3C2410_CPUFREQ_UTILS
-	help
-	  CPU Frequency scaling support for S3C2440 and S3C2442 SoC CPUs.
-
 config S3C2440_DMA
 	bool
 	help
@@ -520,15 +508,15 @@ config S3C2440_XTAL_16934400
 
 config S3C2440_PLL_12000000
 	bool
-	depends on S3C2440_CPUFREQ && S3C2440_XTAL_12000000
-	default y if CPU_FREQ_S3C24XX_PLL
+	depends on ARM_S3C2440_CPUFREQ && S3C2440_XTAL_12000000
+	default y if S3C24XX_PLL
 	help
 	  PLL tables for S3C2440 or S3C2442 CPUs with 12MHz crystals.
 
 config S3C2440_PLL_16934400
 	bool
-	depends on S3C2440_CPUFREQ && S3C2440_XTAL_16934400
-	default y if CPU_FREQ_S3C24XX_PLL
+	depends on ARM_S3C2440_CPUFREQ && S3C2440_XTAL_16934400
+	default y if S3C24XX_PLL
 	help
 	  PLL tables for S3C2440 or S3C2442 CPUs with 16.934MHz crystals.
 
@@ -582,7 +570,7 @@ config MACH_NEXCODER_2440
 
 config MACH_OSIRIS
 	bool "Simtec IM2440D20 (OSIRIS) module"
-	select S3C2410_IOTIMING if S3C2440_CPUFREQ
+	select S3C2410_IOTIMING if ARM_S3C2440_CPUFREQ
 	select S3C2440_XTAL_12000000
 	select S3C24XX_DCLK
 	select S3C24XX_GPIO_EXTRA128
@@ -655,7 +643,7 @@ config MACH_RX1950
 	bool "HP iPAQ rx1950"
 	select I2C
 	select PM_H1940 if PM
-	select S3C2410_IOTIMING if S3C2440_CPUFREQ
+	select S3C2410_IOTIMING if ARM_S3C2440_CPUFREQ
 	select S3C2440_XTAL_16934400
 	select S3C24XX_DCLK
 	select S3C24XX_PWM
diff --git a/arch/arm/mach-s3c24xx/Makefile b/arch/arm/mach-s3c24xx/Makefile
index af53d27..15ce13c 100644
--- a/arch/arm/mach-s3c24xx/Makefile
+++ b/arch/arm/mach-s3c24xx/Makefile
@@ -17,13 +17,11 @@ obj-				:=
 obj-y				+= common.o irq.o
 
 obj-$(CONFIG_CPU_S3C2410)	+= s3c2410.o
-obj-$(CONFIG_S3C2410_CPUFREQ)	+= cpufreq-s3c2410.o
 obj-$(CONFIG_S3C2410_DMA)	+= dma-s3c2410.o
 obj-$(CONFIG_S3C2410_PLL)	+= pll-s3c2410.o
 obj-$(CONFIG_S3C2410_PM)	+= pm-s3c2410.o sleep-s3c2410.o
 
 obj-$(CONFIG_CPU_S3C2412)	+= s3c2412.o irq-s3c2412.o clock-s3c2412.o
-obj-$(CONFIG_S3C2412_CPUFREQ)	+= cpufreq-s3c2412.o
 obj-$(CONFIG_S3C2412_DMA)	+= dma-s3c2412.o
 obj-$(CONFIG_S3C2412_PM)	+= pm-s3c2412.o
 obj-$(CONFIG_S3C2412_PM_SLEEP)	+= sleep-s3c2412.o
@@ -34,7 +32,6 @@ obj-$(CONFIG_S3C2416_PM)	+= pm-s3c2416.o
 obj-$(CONFIG_CPU_S3C2440)	+= s3c2440.o irq-s3c2440.o clock-s3c2440.o
 obj-$(CONFIG_CPU_S3C2442)	+= s3c2442.o
 obj-$(CONFIG_CPU_S3C244X)	+= s3c244x.o irq-s3c244x.o clock-s3c244x.o
-obj-$(CONFIG_S3C2440_CPUFREQ)	+= cpufreq-s3c2440.o
 obj-$(CONFIG_S3C2440_DMA)	+= dma-s3c2440.o
 obj-$(CONFIG_S3C2440_PLL_12000000) += pll-s3c2440-12000000.o
 obj-$(CONFIG_S3C2440_PLL_16934400) += pll-s3c2440-16934400.o
@@ -59,9 +56,6 @@ obj-$(CONFIG_S3C2412_IOTIMING)	+= iotiming-s3c2412.o
 obj-$(CONFIG_S3C2443_COMMON)	+= common-s3c2443.o
 obj-$(CONFIG_S3C2443_DMA)	+= dma-s3c2443.o
 
-obj-$(CONFIG_CPU_FREQ_S3C24XX)	+= cpufreq.o
-obj-$(CONFIG_CPU_FREQ_S3C24XX_DEBUGFS) += cpufreq-debugfs.o
-
 #
 # machine support
 # following is ordered alphabetically by option text.
diff --git a/arch/arm/mach-s3c24xx/s3c2412.h b/arch/arm/mach-s3c24xx/include/mach/s3c2412.h
similarity index 100%
rename from arch/arm/mach-s3c24xx/s3c2412.h
rename to arch/arm/mach-s3c24xx/include/mach/s3c2412.h
diff --git a/arch/arm/mach-s3c24xx/iotiming-s3c2412.c b/arch/arm/mach-s3c24xx/iotiming-s3c2412.c
index 663436d..bd064c0 100644
--- a/arch/arm/mach-s3c24xx/iotiming-s3c2412.c
+++ b/arch/arm/mach-s3c24xx/iotiming-s3c2412.c
@@ -31,7 +31,7 @@
 #include <plat/cpu-freq-core.h>
 #include <plat/clock.h>
 
-#include "s3c2412.h"
+#include <mach/s3c2412.h>
 
 #define print_ns(x) ((x) / 10), ((x) % 10)
 
diff --git a/arch/arm/plat-samsung/include/plat/cpu-freq-core.h b/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
index 95509d8..d7e1715 100644
--- a/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
+++ b/arch/arm/plat-samsung/include/plat/cpu-freq-core.h
@@ -202,7 +202,7 @@ extern int s3c_plltab_register(struct cpufreq_frequency_table *plls,
 extern struct s3c_cpufreq_config *s3c_cpufreq_getconfig(void);
 extern struct s3c_iotimings *s3c_cpufreq_getiotimings(void);
 
-#ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
+#ifdef CONFIG_ARM_S3C24XX_CPUFREQ_DEBUGFS
 #define s3c_cpufreq_debugfs_call(x) x
 #else
 #define s3c_cpufreq_debugfs_call(x) NULL
@@ -259,17 +259,17 @@ extern void s3c2412_iotiming_set(struct s3c_cpufreq_config *cfg,
 #define s3c2412_iotiming_set NULL
 #endif /* CONFIG_S3C2412_IOTIMING */
 
-#ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUG
+#ifdef CONFIG_ARM_S3C24XX_CPUFREQ_DEBUG
 #define s3c_freq_dbg(x...) printk(KERN_INFO x)
 #else
 #define s3c_freq_dbg(x...) do { if (0) printk(x); } while (0)
-#endif /* CONFIG_CPU_FREQ_S3C24XX_DEBUG */
+#endif /* CONFIG_ARM_S3C24XX_CPUFREQ_DEBUG */
 
-#ifdef CONFIG_CPU_FREQ_S3C24XX_IODEBUG
+#ifdef CONFIG_ARM_S3C24XX_CPUFREQ_IODEBUG
 #define s3c_freq_iodbg(x...) printk(KERN_INFO x)
 #else
 #define s3c_freq_iodbg(x...) do { if (0) printk(x); } while (0)
-#endif /* CONFIG_CPU_FREQ_S3C24XX_IODEBUG */
+#endif /* CONFIG_ARM_S3C24XX_CPUFREQ_IODEBUG */
 
 static inline int s3c_cpufreq_addfreq(struct cpufreq_frequency_table *table,
 				      int index, size_t table_size,
diff --git a/arch/arm/plat-samsung/include/plat/cpu-freq.h b/arch/arm/plat-samsung/include/plat/cpu-freq.h
index 80c4a80..85517ab 100644
--- a/arch/arm/plat-samsung/include/plat/cpu-freq.h
+++ b/arch/arm/plat-samsung/include/plat/cpu-freq.h
@@ -126,7 +126,7 @@ struct s3c_cpufreq_board {
 };
 
 /* Things depending on frequency scaling. */
-#ifdef CONFIG_CPU_FREQ_S3C
+#ifdef CONFIG_ARM_S3C_CPUFREQ
 #define __init_or_cpufreq
 #else
 #define __init_or_cpufreq __init
@@ -134,7 +134,7 @@ struct s3c_cpufreq_board {
 
 /* Board functions */
 
-#ifdef CONFIG_CPU_FREQ_S3C
+#ifdef CONFIG_ARM_S3C_CPUFREQ
 extern int s3c_cpufreq_setboard(struct s3c_cpufreq_board *board);
 #else
 
@@ -142,4 +142,4 @@ static inline int s3c_cpufreq_setboard(struct s3c_cpufreq_board *board)
 {
 	return 0;
 }
-#endif  /* CONFIG_CPU_FREQ_S3C */
+#endif  /* CONFIG_ARM_S3C_CPUFREQ */
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 97f208d..1ce61ba 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -86,6 +86,56 @@ config ARM_OMAP2PLUS_CPUFREQ
 	default ARCH_OMAP2PLUS
 	select CPU_FREQ_TABLE
 
+config ARM_S3C_CPUFREQ
+	bool
+	help
+	  Internal configuration node for common cpufreq on Samsung SoC
+
+config ARM_S3C24XX_CPUFREQ
+	bool "CPUfreq driver for Samsung S3C24XX series CPUs (EXPERIMENTAL)"
+	depends on ARCH_S3C24XX
+	select ARM_S3C_CPUFREQ
+	help
+	  This enables the CPUfreq driver for the Samsung S3C24XX family
+	  of CPUs.
+
+	  For details, take a look at <file:Documentation/cpu-freq>.
+
+	  If in doubt, say N.
+
+config ARM_S3C24XX_CPUFREQ_DEBUG
+	bool "Debug CPUfreq Samsung driver core"
+	depends on ARM_S3C24XX_CPUFREQ
+	help
+	  Enable s3c_freq_dbg for the Samsung S3C CPUfreq core
+
+config ARM_S3C24XX_CPUFREQ_IODEBUG
+	bool "Debug CPUfreq Samsung driver IO timing"
+	depends on ARM_S3C24XX_CPUFREQ
+	help
+	  Enable s3c_freq_iodbg for the Samsung S3C CPUfreq core
+
+config ARM_S3C24XX_CPUFREQ_DEBUGFS
+	bool "Export debugfs for CPUFreq"
+	depends on ARM_S3C24XX_CPUFREQ && DEBUG_FS
+	help
+	  Export status information via debugfs.
+
+config ARM_S3C2410_CPUFREQ
+	bool
+	depends on ARM_S3C24XX_CPUFREQ && CPU_S3C2410
+	select S3C2410_CPUFREQ_UTILS
+	help
+	  CPU Frequency scaling support for S3C2410
+
+config ARM_S3C2412_CPUFREQ
+	bool
+	depends on ARM_S3C24XX_CPUFREQ && CPU_S3C2412
+	default y
+	select S3C2412_IOTIMING
+	help
+	  CPU Frequency scaling support for S3C2412 and S3C2413 SoC CPUs.
+
 config ARM_S3C2416_CPUFREQ
 	bool "S3C2416 CPU Frequency scaling support"
 	depends on CPU_S3C2416
@@ -108,6 +158,14 @@ config ARM_S3C2416_CPUFREQ_VCORESCALE
 
 	  If in doubt, say N.
 
+config ARM_S3C2440_CPUFREQ
+	bool "S3C2440/S3C2442 CPU Frequency scaling support"
+	depends on ARM_S3C24XX_CPUFREQ && (CPU_S3C2440 || CPU_S3C2442)
+	select S3C2410_CPUFREQ_UTILS
+	default y
+	help
+	  CPU Frequency scaling support for S3C2440 and S3C2442 SoC CPUs.
+
 config ARM_S3C64XX_CPUFREQ
 	bool "Samsung S3C64XX"
 	depends on CPU_S3C6410
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 8d58016..a55e3e8 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -63,7 +63,12 @@ obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)	+= omap-cpufreq.o
 obj-$(CONFIG_PXA25x)			+= pxa2xx-cpufreq.o
 obj-$(CONFIG_PXA27x)			+= pxa2xx-cpufreq.o
 obj-$(CONFIG_PXA3xx)			+= pxa3xx-cpufreq.o
+obj-$(CONFIG_ARM_S3C24XX_CPUFREQ)	+= s3c24xx-cpufreq.o
+obj-$(CONFIG_ARM_S3C24XX_CPUFREQ_DEBUGFS) += s3c24xx-cpufreq-debugfs.o
+obj-$(CONFIG_ARM_S3C2410_CPUFREQ)	+= s3c2410-cpufreq.o
+obj-$(CONFIG_ARM_S3C2412_CPUFREQ)	+= s3c2412-cpufreq.o
 obj-$(CONFIG_ARM_S3C2416_CPUFREQ)	+= s3c2416-cpufreq.o
+obj-$(CONFIG_ARM_S3C2440_CPUFREQ)	+= s3c2440-cpufreq.o
 obj-$(CONFIG_ARM_S3C64XX_CPUFREQ)	+= s3c64xx-cpufreq.o
 obj-$(CONFIG_ARM_S5PV210_CPUFREQ)	+= s5pv210-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
diff --git a/arch/arm/mach-s3c24xx/cpufreq-s3c2410.c b/drivers/cpufreq/s3c2410-cpufreq.c
similarity index 100%
rename from arch/arm/mach-s3c24xx/cpufreq-s3c2410.c
rename to drivers/cpufreq/s3c2410-cpufreq.c
diff --git a/arch/arm/mach-s3c24xx/cpufreq-s3c2412.c b/drivers/cpufreq/s3c2412-cpufreq.c
similarity index 99%
rename from arch/arm/mach-s3c24xx/cpufreq-s3c2412.c
rename to drivers/cpufreq/s3c2412-cpufreq.c
index 8bf0f3a..4645b48 100644
--- a/arch/arm/mach-s3c24xx/cpufreq-s3c2412.c
+++ b/drivers/cpufreq/s3c2412-cpufreq.c
@@ -25,13 +25,12 @@
 #include <asm/mach/map.h>
 
 #include <mach/regs-clock.h>
+#include <mach/s3c2412.h>
 
 #include <plat/cpu.h>
 #include <plat/clock.h>
 #include <plat/cpu-freq-core.h>
 
-#include "s3c2412.h"
-
 /* our clock resources. */
 static struct clk *xtal;
 static struct clk *fclk;
diff --git a/arch/arm/mach-s3c24xx/cpufreq-s3c2440.c b/drivers/cpufreq/s3c2440-cpufreq.c
similarity index 100%
rename from arch/arm/mach-s3c24xx/cpufreq-s3c2440.c
rename to drivers/cpufreq/s3c2440-cpufreq.c
diff --git a/arch/arm/mach-s3c24xx/cpufreq-debugfs.c b/drivers/cpufreq/s3c24xx-cpufreq-debugfs.c
similarity index 100%
rename from arch/arm/mach-s3c24xx/cpufreq-debugfs.c
rename to drivers/cpufreq/s3c24xx-cpufreq-debugfs.c
diff --git a/arch/arm/mach-s3c24xx/cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
similarity index 100%
rename from arch/arm/mach-s3c24xx/cpufreq.c
rename to drivers/cpufreq/s3c24xx-cpufreq.c
-- 
1.7.12.rc2.18.g61b472e

