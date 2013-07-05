Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886Ab3GEQWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 12:22:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab3GEQWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 12:22:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4/8] ARM: OMAP: build mach-omap code only if needed
Date: Fri,  5 Jul 2013 18:23:33 +0200
Message-Id: <1373041417-217728-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1373041417-217728-1-git-send-email-arnd@arndb.de>
References: <1373041417-217728-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:jK8qqNUYF5Xqc4shB75MMbfW9vPgoERMI4H4lVyU/LS
 CddBKMze01J/5D44UurRe7XqzbxgdisJs3zSQ2jmTY8/PHN4iS
 VloEHlC8eXdDLpWwXco42MT+LKMdWPnOcK0XTNz1lILAWoDyLO
 qiz7RF7JOaHslchotDGtkWKorV665jZMfhATIJczhH0QlHGGDv
 BerEWogvG7MJpqOF10yTjCRD+gGol4mgdNL5+eI3qo0/pUwzAz
 Il3Brj+PZDzAoESxEIL0nm1EA6jverR7q+I4uy2wCDClzXtEvm
 L9vfiwfo0Uo4bWxA6tEOd4dszcE+0QWeuA6AuZhaHE9Oe9DXS8
 7o8U+5zs2c4AlCXGNlROVWZnFUDrxRuLiGZzivh9J
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we build a kernel with CONFIG_ARCH_OMAP2PLUS enabled but all of the
individual SoCs disabled, we run into a large number of link errors
because if incorrect dependencies:

arch/arm/mach-omap2/built-in.o: In function `_add_initiator_dep':
arch/arm/mach-omap2/omap_hwmod.c:691: undefined reference to `clkdm_add_sleepdep' arch/arm/mach-omap2/built-in.o: In function `_del_initiator_dep':
arch/arm/mach-omap2/omap_hwmod.c:720: undefined reference to `clkdm_del_sleepdep' arch/arm/mach-omap2/built-in.o: In function `_enable':
arch/arm/mach-omap2/omap_hwmod.c:2145: undefined reference to `clkdm_in_hwsup'
arch/arm/mach-omap2/omap_hwmod.c:2147: undefined reference to `clkdm_hwmod_enable'
arch/arm/mach-omap2/omap_hwmod.c:2191: undefined reference to `clkdm_hwmod_disable'
arch/arm/mach-omap2/omap_hwmod.c:2146: undefined reference to `clkdm_missing_idle_reporting' arch/arm/mach-omap2/built-in.o: In function `_idle':
arch/arm/mach-omap2/omap_hwmod.c:2235: undefined reference to `clkdm_hwmod_disable' arch/arm/mach-omap2/built-in.o: In function `_shutdown':
arch/arm/mach-omap2/omap_hwmod.c:2338: undefined reference to `clkdm_hwmod_disable' arch/arm/mach-omap2/built-in.o: In function `omap_hwmod_get_context_loss_count':
arch/arm/mach-omap2/omap_hwmod.c:4071: undefined reference to `pwrdm_get_context_loss_count' arch/arm/mach-omap2/built-in.o: In function `omap_pm_clkdms_setup':
arch/arm/mach-omap2/pm.c:114: undefined reference to `clkdm_allow_idle'
arch/arm/mach-omap2/pm.c:117: undefined reference to `clkdm_sleep' arch/arm/mach-omap2/built-in.o: In function `omap2_common_pm_late_init':
arch/arm/mach-omap2/pm.c:294: undefined reference to `omap_voltage_late_init' arch/arm/mach-omap2/built-in.o: In function `omap2_gpio_dev_init':
arch/arm/mach-omap2/gpio.c:133: undefined reference to `pwrdm_can_ever_lose_context'

We can avoid this if we make CONFIG_ARCH_OMAP2PLUS a silent option that
gets enabled any time that one of the SoC versions is enabled.

Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/configs/omap2plus_defconfig |   4 +
 arch/arm/mach-omap2/Kconfig          | 148 +++++++++++++++++------------------
 2 files changed, 78 insertions(+), 74 deletions(-)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 2ac0ffb..f9b7fcc 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -22,6 +22,10 @@ CONFIG_MODULE_SRCVERSION_ALL=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_ARCH_MULTI_V6=y
 CONFIG_ARCH_OMAP2PLUS=y
+CONFIG_ARCH_OMAP2=y
+CONFIG_ARCH_OMAP3=y
+CONFIG_ARCH_OMAP4=y
+CONFIG_SOC_AM33XX=y
 CONFIG_OMAP_RESET_CLOCKS=y
 CONFIG_OMAP_MUX_DEBUG=y
 CONFIG_ARCH_VEXPRESS_CA9X4=y
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 1f8127a..5c14051 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -1,62 +1,10 @@
 config ARCH_OMAP
 	bool
 
-config ARCH_OMAP2PLUS
-	bool "TI OMAP2/3/4/5 SoCs with device tree support" if (ARCH_MULTI_V6 || ARCH_MULTI_V7)
-	select ARCH_HAS_CPUFREQ
-	select ARCH_HAS_HOLES_MEMORYMODEL
-	select ARCH_OMAP
-	select ARCH_REQUIRE_GPIOLIB
-	select CLKDEV_LOOKUP
-	select CLKSRC_MMIO
-	select GENERIC_CLOCKEVENTS
-	select GENERIC_IRQ_CHIP
-	select HAVE_CLK
-	select OMAP_DM_TIMER
-	select PINCTRL
-	select PROC_DEVICETREE if PROC_FS
-	select SOC_BUS
-	select SPARSE_IRQ
-	select TI_PRIV_EDMA
-	select USE_OF
-	help
-	  Systems based on OMAP2, OMAP3, OMAP4 or OMAP5
-
-
-if ARCH_OMAP2PLUS
-
-menu "TI OMAP2/3/4 Specific Features"
-
-config ARCH_OMAP2PLUS_TYPICAL
-	bool "Typical OMAP configuration"
-	default y
-	select AEABI
-	select HIGHMEM
-	select I2C
-	select I2C_OMAP
-	select MENELAUS if ARCH_OMAP2
-	select NEON if ARCH_OMAP3 || ARCH_OMAP4 || SOC_OMAP5
-	select PM_RUNTIME
-	select REGULATOR
-	select TWL4030_CORE if ARCH_OMAP3 || ARCH_OMAP4
-	select TWL4030_POWER if ARCH_OMAP3 || ARCH_OMAP4
-	select VFP
-	help
-	  Compile a kernel suitable for booting most boards
-
-config SOC_HAS_OMAP2_SDRC
-	bool "OMAP2 SDRAM Controller support"
-
-config SOC_HAS_REALTIME_COUNTER
-	bool "Real time free running counter"
-	depends on SOC_OMAP5
-	default y
-
 config ARCH_OMAP2
 	bool "TI OMAP2"
-	depends on ARCH_OMAP2PLUS
 	depends on ARCH_MULTI_V6
-	default y
+	select ARCH_OMAP2PLUS
 	select CPU_V6
 	select MULTI_IRQ_HANDLER
 	select SOC_HAS_OMAP2_SDRC
@@ -64,9 +12,8 @@ config ARCH_OMAP2
 
 config ARCH_OMAP3
 	bool "TI OMAP3"
-	depends on ARCH_OMAP2PLUS
 	depends on ARCH_MULTI_V7
-	default y
+	select ARCH_OMAP2PLUS
 	select ARCH_HAS_OPP
 	select ARM_CPU_SUSPEND if PM
 	select CPU_V7
@@ -80,9 +27,8 @@ config ARCH_OMAP3
 
 config ARCH_OMAP4
 	bool "TI OMAP4"
-	default y
-	depends on ARCH_OMAP2PLUS
 	depends on ARCH_MULTI_V7
+	select ARCH_OMAP2PLUS
 	select ARCH_HAS_OPP
 	select ARCH_NEEDS_CPU_IDLE_COUPLED if SMP
 	select ARM_CPU_SUSPEND if PM
@@ -107,6 +53,7 @@ config ARCH_OMAP4
 config SOC_OMAP5
 	bool "TI OMAP5"
 	depends on ARCH_MULTI_V7
+	select ARCH_OMAP2PLUS
 	select ARM_CPU_SUSPEND if PM
 	select ARM_GIC
 	select CPU_V7
@@ -116,6 +63,76 @@ config SOC_OMAP5
 	select COMMON_CLK
 	select HAVE_ARM_ARCH_TIMER
 
+config SOC_AM33XX
+	bool "AM33XX support"
+	depends on ARCH_MULTI_V7
+	select ARCH_OMAP2PLUS
+	select ARM_CPU_SUSPEND if PM
+	select CPU_V7
+	select MULTI_IRQ_HANDLER
+	select COMMON_CLK
+
+config SOC_AM43XX
+	bool "TI AM43x"
+	depends on ARCH_MULTI_V7
+	select CPU_V7
+	select ARCH_OMAP2PLUS
+	select MULTI_IRQ_HANDLER
+	select ARM_GIC
+	select COMMON_CLK
+	select MACH_OMAP_GENERIC
+
+config ARCH_OMAP2PLUS
+	bool
+	select ARCH_HAS_BANDGAP
+	select ARCH_HAS_CPUFREQ
+	select ARCH_HAS_HOLES_MEMORYMODEL
+	select ARCH_OMAP
+	select ARCH_REQUIRE_GPIOLIB
+	select CLKDEV_LOOKUP
+	select CLKSRC_MMIO
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_IRQ_CHIP
+	select HAVE_CLK
+	select OMAP_DM_TIMER
+	select PINCTRL
+	select PROC_DEVICETREE if PROC_FS
+	select SOC_BUS
+	select SPARSE_IRQ
+	select USE_OF
+	help
+	  Systems based on OMAP2, OMAP3, OMAP4 or OMAP5
+
+
+if ARCH_OMAP2PLUS
+
+menu "TI OMAP2/3/4 Specific Features"
+
+config ARCH_OMAP2PLUS_TYPICAL
+	bool "Typical OMAP configuration"
+	default y
+	select AEABI
+	select HIGHMEM
+	select I2C
+	select I2C_OMAP
+	select MENELAUS if ARCH_OMAP2
+	select NEON if ARCH_OMAP3 || ARCH_OMAP4 || SOC_OMAP5
+	select PM_RUNTIME
+	select REGULATOR
+	select TWL4030_CORE if ARCH_OMAP3 || ARCH_OMAP4
+	select TWL4030_POWER if ARCH_OMAP3 || ARCH_OMAP4
+	select VFP
+	help
+	  Compile a kernel suitable for booting most boards
+
+config SOC_HAS_OMAP2_SDRC
+	bool "OMAP2 SDRAM Controller support"
+
+config SOC_HAS_REALTIME_COUNTER
+	bool "Real time free running counter"
+	depends on SOC_OMAP5
+	default y
+
 comment "OMAP Core Type"
 	depends on ARCH_OMAP2
 
@@ -143,23 +160,6 @@ config SOC_TI81XX
 	depends on ARCH_OMAP3
 	default y
 
-config SOC_AM33XX
-	bool "AM33XX support"
-	depends on ARCH_MULTI_V7
-	default y
-	select ARM_CPU_SUSPEND if PM
-	select CPU_V7
-	select MULTI_IRQ_HANDLER
-	select COMMON_CLK
-
-config SOC_AM43XX
-	bool "TI AM43x"
-	select CPU_V7
-	select MULTI_IRQ_HANDLER
-	select ARM_GIC
-	select COMMON_CLK
-	select MACH_OMAP_GENERIC
-
 config OMAP_PACKAGE_ZAF
        bool
 
-- 
1.8.3.1

