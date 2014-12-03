Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbaLCAOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:14:55 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:33483 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483AbaLCAM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:12:26 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH 10/12] ARM: vf610m4: add new machine and SoC for Vybrid on Cortex-M4
Date: Wed,  3 Dec 2014 01:12:09 +0100
Message-Id: <1417565531-4507-11-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417565531-4507-1-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new machine MACH_MXCM4 which requires !MMU and
!MULTIARCH and is meant as machine for the hetregenous multi-core
Vybrid/i.MX SoC's to run Linux on the Cortex-M4.

The first SoC supported is Vybrid on Cortex-M4 (SOC_VF610M4).

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/Kconfig                  | 12 ++++++++++++
 arch/arm/Kconfig.debug            |  4 ++--
 arch/arm/Makefile                 |  1 +
 arch/arm/mach-imx/Kconfig         | 29 ++++++++++++++++++++++++++---
 arch/arm/mach-imx/Makefile        |  1 +
 arch/arm/mach-imx/Makefile.boot   |  0
 arch/arm/mach-imx/mach-vf610m4.c  | 31 +++++++++++++++++++++++++++++++
 drivers/mmc/host/Kconfig          |  2 +-
 drivers/pinctrl/freescale/Kconfig |  2 +-
 9 files changed, 75 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm/mach-imx/Makefile.boot
 create mode 100644 arch/arm/mach-imx/mach-vf610m4.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 89c4b5c..fdebe18 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -459,6 +459,18 @@ config ARCH_FOOTBRIDGE
 	  Support for systems based on the DC21285 companion chip
 	  ("FootBridge"), such as the Simtec CATS and the Rebel NetWinder.
 
+menuconfig ARCH_MXCM4
+	bool "Freescale Vybrid/i.MX family on Cortex-M4" if !MMU
+	select ARCH_REQUIRE_GPIOLIB
+	select ARM_CPU_SUSPEND if PM
+	select CLKSRC_MMIO
+	select GENERIC_IRQ_CHIP
+	select PINCTRL
+	select PM_OPP if PM
+	select SOC_BUS
+	help
+	  Support for Freescale Vybrid/iMX-based family of processors on Cortex-M4
+
 config ARCH_NETX
 	bool "Hilscher NetX based"
 	select ARM_VIC
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 03dc4c1..f479727 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -459,7 +459,7 @@ choice
 
 	config DEBUG_VF_UART
 		bool "Vybrid UART"
-		depends on SOC_VF610
+		depends on SOC_VF610 || SOC_VF610M4
 		help
 		  Say Y here if you want kernel low-level debugging support
 		  on Vybrid based platforms.
@@ -1026,7 +1026,7 @@ config DEBUG_VF_UART_PORT
 	int "Vybrid Debug UART Port Selection" if DEBUG_VF_UART
 	default 1
 	range 0 3
-	depends on SOC_VF610
+	depends on SOC_VF610 || SOC_VF610M4
 	help
 	  Choose UART port on which kernel low-level debug messages
 	  should be output.
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 034a949..0b84168 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -174,6 +174,7 @@ machine-$(CONFIG_ARCH_MSM)		+= msm
 machine-$(CONFIG_ARCH_MV78XX0)		+= mv78xx0
 machine-$(CONFIG_ARCH_MVEBU)		+= mvebu
 machine-$(CONFIG_ARCH_MXC)		+= imx
+machine-$(CONFIG_ARCH_MXCM4)		+= imx
 machine-$(CONFIG_ARCH_MEDIATEK)		+= mediatek
 machine-$(CONFIG_ARCH_MXS)		+= mxs
 machine-$(CONFIG_ARCH_NETX)		+= netx
diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 2935972..56635d5 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -1,3 +1,6 @@
+config HAVE_VF610_MSCM
+	bool
+
 menuconfig ARCH_MXC
 	bool "Freescale i.MX family" if ARCH_MULTI_V4_V5 || ARCH_MULTI_V6_V7
 	select ARCH_REQUIRE_GPIOLIB
@@ -58,9 +61,6 @@ config HAVE_IMX_SRC
 	def_bool y if SMP
 	select ARCH_HAS_RESET_CONTROLLER
 
-config HAVE_VF610_MSCM
-	bool
-
 config IMX_HAVE_IOMUX_V1
 	bool
 
@@ -677,3 +677,26 @@ endif
 source "arch/arm/mach-imx/devices/Kconfig"
 
 endif
+
+if !MMU && ARCH_MXCM4
+
+config SOC_VF610M4
+	bool "Vybrid Family VF610 support for Cortex-M4"
+	select HAVE_VF610_MSCM
+	select ARCH_REQUIRE_GPIOLIB
+	select PINCTRL_VF610
+	select PINCTRL_IMX
+	select ARM_NVIC
+	select AUTO_ZRELADDR
+	select CPU_V7M
+	select COMMON_CLK
+	select GENERIC_CLOCKEVENTS
+	select NO_DMA
+	select NO_IOPORT_MAP
+	select SPARSE_IRQ
+	select USE_OF
+	select VF_PIT_TIMER
+	help
+	  Support for Vybrid Familiy VF610's Cortex-M4
+
+endif
diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index 82b1159..21fb423 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_SOC_IMX53) += mach-imx53.o
 
 obj-$(CONFIG_HAVE_VF610_MSCM) += mscm-vf610.o
 obj-$(CONFIG_SOC_VF610) += clk-vf610.o mach-vf610.o
+obj-$(CONFIG_SOC_VF610M4) += clk-vf610.o mach-vf610m4.o
 
 obj-$(CONFIG_SOC_LS1021A) += mach-ls1021a.o
 
diff --git a/arch/arm/mach-imx/Makefile.boot b/arch/arm/mach-imx/Makefile.boot
new file mode 100644
index 0000000..e69de29
diff --git a/arch/arm/mach-imx/mach-vf610m4.c b/arch/arm/mach-imx/mach-vf610m4.c
new file mode 100644
index 0000000..245788f
--- /dev/null
+++ b/arch/arm/mach-imx/mach-vf610m4.c
@@ -0,0 +1,31 @@
+/*
+ * Copyright 2014 Stefan Agner
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/irqchip.h>
+#include <linux/kernel.h>
+#include <asm/v7m.h>
+#include <asm/mach/arch.h>
+#include "common.h"
+
+static void __init vf610m4_init_irq(void)
+{
+	vf610_mscm_init();
+	irqchip_init();
+}
+
+static const char *const vf610m4_compat[] __initconst = {
+	"fsl,vf610m4",
+	NULL
+};
+
+DT_MACHINE_START(VF610M4DT, "VF610 on Cortex-M4 (Device Tree Support)")
+	.dt_compat = vf610m4_compat,
+	.init_irq = vf610m4_init_irq,
+	.restart = armv7m_restart,
+MACHINE_END
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 1386065..bfbec2d 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -166,7 +166,7 @@ config MMC_SDHCI_CNS3XXX
 
 config MMC_SDHCI_ESDHC_IMX
 	tristate "SDHCI support for the Freescale eSDHC/uSDHC i.MX controller"
-	depends on ARCH_MXC
+	depends on ARCH_MXC || ARCH_MXCM4
 	depends on MMC_SDHCI_PLTFM
 	select MMC_SDHCI_IO_ACCESSORS
 	help
diff --git a/drivers/pinctrl/freescale/Kconfig b/drivers/pinctrl/freescale/Kconfig
index 16aac38..5271ca2 100644
--- a/drivers/pinctrl/freescale/Kconfig
+++ b/drivers/pinctrl/freescale/Kconfig
@@ -89,7 +89,7 @@ config PINCTRL_IMX6SX
 
 config PINCTRL_VF610
 	bool "Freescale Vybrid VF610 pinctrl driver"
-	depends on SOC_VF610
+	depends on SOC_VF610 || SOC_VF610M4
 	select PINCTRL_IMX
 	help
 	  Say Y here to enable the Freescale Vybrid VF610 pinctrl driver
-- 
2.1.3

