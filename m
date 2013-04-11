Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937642Ab3DKAK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:10:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937474Ab3DKAG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 30/30] ARM: exynos: enable multiplatform support
Date: Thu, 11 Apr 2013 02:05:12 +0200
Message-Id: <1365638712-1028578-31-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:1lMcoAc3+3a5OOR09qPMyk/Umt04Xc+Q07t5wbZt5Rt
 w3Umoa3qokUoKIDCqbH1Kh4lqR053RuyEW9NxoihjpXFywOm+O
 uLZdrIgJ1a0LuHt3vGB+Zkn717Lj+oolbAXWDxmBu1IKj92PBu
 irCeoVfbpdxERC+rPgaBUykYNf60G5EB14+mlZJfHdxU3Gvxlt
 msLTc48YgYrH0nAhymMY1VDSsWZbTIV74DqdzC6Es1cDixLVwp
 7aMOemK8air4K8A67WlQRCl075vLTdsuzFoK9z/XJrZqGY06I+
 5BXARbNg8ZHG8Rzo6/OXWJHGhKM8jG6MtoGXsfFUklbED5ZvqY
 MWwDV/LD3p0JFTux/PCA6WT3/z31IyEKH/yPKJr5GrN7ZH/ei6
 ar/UKC1itDe9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to enable the exynos platform as part of a
multiplatform kernel, in addition to keeping the single-platform
exynos support.

The multiplatform variant has a number of limitations at the moment:

* It only supports DT-enabled machines. This is not a problem in
  the long run, as non-DT machines for exynos are going away.
  The main problem here is that the gpio code and the exynos_eint
  irqchip are not multiplatform capable but still required for
  ATAGS based boot.
* The watchdog driver is still missing a conversion.
* sparsemem and memory_holes are currently not supported in
  multiplatform.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig                        | 10 +---------
 arch/arm/configs/exynos4_defconfig      |  2 +-
 arch/arm/mach-exynos/Kconfig            | 25 +++++++++++++++++++++----
 arch/arm/mach-exynos/Makefile           |  5 +++--
 arch/arm/mach-exynos/common.c           |  6 ++++++
 arch/arm/plat-samsung/Kconfig           |  7 ++++++-
 arch/arm/plat-samsung/Makefile          |  8 ++++++--
 arch/arm/plat-samsung/include/plat/pm.h |  5 +++++
 drivers/gpio/Makefile                   |  2 +-
 9 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c451112..81185a5 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -775,19 +775,11 @@ config ARCH_S5PV210
 	help
 	  Samsung S5PV210/S5PC110 series based systems
 
-config ARCH_EXYNOS
+config ARCH_EXYNOS_SINGLE
 	bool "Samsung EXYNOS"
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_SPARSEMEM_ENABLE
-	select CLKDEV_LOOKUP
-	select COMMON_CLK
-	select CPU_V7
-	select GENERIC_CLOCKEVENTS
-	select HAVE_CLK
-	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
-	select HAVE_S3C_RTC if RTC_CLASS
 	select NEED_MACH_GPIO_H
 	select NEED_MACH_MEMORY_H
 	help
diff --git a/arch/arm/configs/exynos4_defconfig b/arch/arm/configs/exynos4_defconfig
index bffe68e..ae90a0f 100644
--- a/arch/arm/configs/exynos4_defconfig
+++ b/arch/arm/configs/exynos4_defconfig
@@ -4,7 +4,7 @@ CONFIG_KALLSYMS_ALL=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
-CONFIG_ARCH_EXYNOS=y
+CONFIG_ARCH_EXYNOS_SINGLE=y
 CONFIG_S3C_LOWLEVEL_UART_PORT=1
 CONFIG_MACH_SMDKC210=y
 CONFIG_MACH_ARMLEX4210=y
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index e815057..f19cf65 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -7,6 +7,20 @@
 
 # Configuration options for the EXYNOS4
 
+config ARCH_EXYNOS
+	bool "Samsung EXYNOS" if ARCH_MULTI_V7
+	default ARCH_EXYNOS_SINGLE
+	select ARCH_HAS_CPUFREQ
+	select CLKDEV_LOOKUP
+	select COMMON_CLK
+	select CPU_V7
+	select GENERIC_CLOCKEVENTS
+	select HAVE_CLK
+	select HAVE_S3C2410_I2C if I2C
+	select HAVE_S3C_RTC if RTC_CLASS
+	help
+	  Support for SAMSUNG's EXYNOS SoCs (EXYNOS4/5)
+
 if ARCH_EXYNOS
 
 menu "SAMSUNG EXYNOS SoCs Support"
@@ -20,6 +34,9 @@ config ARCH_EXYNOS4
 	help
 	  Samsung EXYNOS4 SoCs based systems
 
+config ARCH_EXYNOS4_SINGLE
+	def_bool ARCH_EXYNOS4 && ARCH_EXYNOS_SINGLE
+
 config ARCH_EXYNOS5
 	bool "SAMSUNG EXYNOS5"
 	select HAVE_ARM_SCU if SMP
@@ -37,7 +54,7 @@ config CPU_EXYNOS4210
 	select PM_GENERIC_DOMAINS
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
-	select SAMSUNG_DMADEV
+	select SAMSUNG_DMADEV if ARCH_EXYNOS_SINGLE
 	help
 	  Enable EXYNOS4210 CPU support
 
@@ -47,7 +64,7 @@ config SOC_EXYNOS4212
 	depends on ARCH_EXYNOS4
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
-	select SAMSUNG_DMADEV
+	select SAMSUNG_DMADEV if ARCH_EXYNOS_SINGLE
 	help
 	  Enable EXYNOS4212 SoC support
 
@@ -55,7 +72,7 @@ config SOC_EXYNOS4412
 	bool "SAMSUNG EXYNOS4412"
 	default y
 	depends on ARCH_EXYNOS4
-	select SAMSUNG_DMADEV
+	select SAMSUNG_DMADEV if ARCH_EXYNOS_SINGLE
 	help
 	  Enable EXYNOS4412 SoC support
 
@@ -67,7 +84,7 @@ config SOC_EXYNOS5250
 	select S5P_PM if PM
 	select S5P_SLEEP if PM
 	select S5P_DEV_MFC
-	select SAMSUNG_DMADEV
+	select SAMSUNG_DMADEV if ARCH_EXYNOS_SINGLE
 	help
 	  Enable EXYNOS5250 SoC support
 
diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index b09b027..ef6860b 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -4,6 +4,7 @@
 #		http://www.samsung.com/
 #
 # Licensed under GPLv2
+ccflags-$(CONFIG_ARCH_MULTIPLATFORM) += -I$(srctree)/$(src)/include -I$(srctree)/arch/arm/plat-samsung/include
 
 obj-y				:=
 obj-m				:=
@@ -48,12 +49,12 @@ obj-$(CONFIG_MACH_EXYNOS5_DT)		+= mach-exynos5-dt.o
 # device support
 
 obj-y					+= dev-uart.o
-obj-$(CONFIG_ARCH_EXYNOS4)		+= dev-audio.o
+obj-$(CONFIG_ARCH_EXYNOS4_SINGLE)	+= dev-audio.o
 obj-$(CONFIG_EXYNOS4_DEV_AHCI)		+= dev-ahci.o
 obj-$(CONFIG_EXYNOS_DEV_DMA)		+= dma.o
 obj-$(CONFIG_EXYNOS4_DEV_USB_OHCI)	+= dev-ohci.o
 
-obj-$(CONFIG_ARCH_EXYNOS)		+= setup-i2c0.o
+obj-$(CONFIG_ARCH_EXYNOS_SINGLE)	+= setup-i2c0.o
 obj-$(CONFIG_EXYNOS4_SETUP_FIMC)	+= setup-fimc.o
 obj-$(CONFIG_EXYNOS4_SETUP_FIMD0)	+= setup-fimd0.o
 obj-$(CONFIG_EXYNOS4_SETUP_I2C1)	+= setup-i2c1.o
diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 0634f99..8419190 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -393,6 +393,9 @@ static void __init exynos4_map_io(void)
 	if (soc_is_exynos4212() || soc_is_exynos4412())
 		iotable_init(exynos4x12_iodesc, ARRAY_SIZE(exynos4x12_iodesc));
 
+	if (!IS_ENABLED(CONFIG_EXYNOS_ATAGS))
+		return
+
 	/* initialize device information early */
 	exynos4_default_sdhci0();
 	exynos4_default_sdhci1();
@@ -597,6 +600,8 @@ static void __init exynos4_init_uarts(struct s3c2410_uartcfg *cfg, int no)
 	s3c24xx_init_uartdevs("exynos4210-uart", exynos4_uart_resources, cfg, no);
 }
 
+
+#ifdef CONFIG_EXYNOS_ATAGS
 static void __iomem *exynos_eint_base;
 
 static DEFINE_SPINLOCK(eint_lock);
@@ -903,6 +908,7 @@ static int __init exynos_init_irq_eint(void)
 	return 0;
 }
 arch_initcall(exynos_init_irq_eint);
+#endif
 
 static struct resource exynos4_pmu_resource[] = {
 	DEFINE_RES_IRQ(EXYNOS4_IRQ_PMU),
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 54d1861..53e7eeb 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -13,6 +13,10 @@ config PLAT_SAMSUNG
 	help
 	  Base platform code for all Samsung SoC based systems
 
+config PLAT_SAMSUNG_SINGLE
+	def_bool PLAT_SAMSUNG && !ARCH_MULTIPLATFORM
+	
+
 config PLAT_S5P
 	bool
 	depends on (ARCH_S5P64X0 || ARCH_S5PC100 || ARCH_S5PV210 || ARCH_EXYNOS)
@@ -23,7 +27,7 @@ config PLAT_S5P
 	select GIC_NON_BANKED if ARCH_EXYNOS4
 	select NO_IOPORT
 	select PLAT_SAMSUNG
-	select S3C_GPIO_TRACK
+	select S3C_GPIO_TRACK if PLAT_SAMSUNG_SINGLE
 	select S5P_GPIO_DRVSTR
 	select SAMSUNG_CLKSRC if !COMMON_CLK
 	select SAMSUNG_GPIOLIB_4BIT
@@ -164,6 +168,7 @@ config S5P_DEV_UART
 
 config S3C_ADC
 	bool "ADC common driver support"
+	depends on PLAT_SAMSUNG_SINGLE
 	help
 	  Core support for the ADC block found in the Samsung SoC systems
 	  for drivers such as the touchscreen and hwmon to use to share
diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
index a23c460..f38ce84 100644
--- a/arch/arm/plat-samsung/Makefile
+++ b/arch/arm/plat-samsung/Makefile
@@ -4,6 +4,9 @@
 #
 # Licensed under GPLv2
 
+ccflags-$(CONFIG_ARCH_MULTI_V7) += -I$(srctree)/$(src)/include
+ccflags-$(CONFIG_ARCH_EXYNOS)	+= -I$(srctree)/arch/arm/mach-exynos/include
+
 obj-y				:=
 obj-m				:=
 obj-n				:= dummy.o
@@ -33,7 +36,7 @@ obj-$(CONFIG_S3C_ADC)	+= adc.o
 
 obj-y				+= platformdata.o
 
-obj-y				+= devs.o
+obj-$(CONFIG_PLAT_SAMSUNG_SINGLE)	+= devs.o
 obj-y				+= dev-uart.o
 obj-$(CONFIG_S5P_DEV_MFC)	+= s5p-dev-mfc.o
 obj-$(CONFIG_S5P_DEV_UART)	+= s5p-dev-uart.o
@@ -50,9 +53,10 @@ obj-$(CONFIG_S3C_DMA)		+= dma.o s3c-dma-ops.o
 obj-$(CONFIG_SAMSUNG_DMADEV)	+= dma-ops.o
 
 # PM support
-
 obj-$(CONFIG_PM)		+= pm.o
+ifdef CONFIG_PLAT_SAMSUNG_SINGLE
 obj-$(CONFIG_PM)		+= pm-gpio.o
+endif
 obj-$(CONFIG_SAMSUNG_PM_CHECK)	+= pm-check.o
 
 obj-$(CONFIG_SAMSUNG_WAKEMASK)	+= wakeup-mask.o
diff --git a/arch/arm/plat-samsung/include/plat/pm.h b/arch/arm/plat-samsung/include/plat/pm.h
index f6fcade..266a4e3 100644
--- a/arch/arm/plat-samsung/include/plat/pm.h
+++ b/arch/arm/plat-samsung/include/plat/pm.h
@@ -166,6 +166,7 @@ extern void s3c_pm_check_store(void);
  */
 extern void s3c_pm_configure_extint(void);
 
+#ifdef CONFIG_PLAT_SAMSUNG_SINGLE
 /**
  * samsung_pm_restore_gpios() - restore the state of the gpios after sleep.
  *
@@ -181,6 +182,10 @@ extern void samsung_pm_restore_gpios(void);
  * Save the GPIO states for resotration on resume. See samsung_pm_restore_gpios().
  */
 extern void samsung_pm_save_gpios(void);
+#else
+#define samsung_pm_restore_gpios()	do { } while(0)
+#define samsung_pm_save_gpios()		do { } while(0)
+#endif
 
 extern void s3c_pm_save_core(void);
 extern void s3c_pm_restore_core(void);
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index e005ad5..3faff2c 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -58,7 +58,7 @@ obj-$(CONFIG_GPIO_PXA)		+= gpio-pxa.o
 obj-$(CONFIG_GPIO_RC5T583)	+= gpio-rc5t583.o
 obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
 obj-$(CONFIG_GPIO_RCAR)		+= gpio-rcar.o
-obj-$(CONFIG_PLAT_SAMSUNG)	+= gpio-samsung.o
+obj-$(CONFIG_PLAT_SAMSUNG_SINGLE)	+= gpio-samsung.o
 obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
 obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
 obj-$(CONFIG_GPIO_SODAVILLE)	+= gpio-sodaville.o
-- 
1.8.1.2

