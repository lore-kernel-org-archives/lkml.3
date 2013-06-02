Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3FBXBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 19:01:19 -0400
Received: from gloria.sntech.de ([95.129.55.99]:40179 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029Ab3FBXBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 19:01:13 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 09/10] arm: add debug uarts for rockchip rk29xx and rk3xxx series
Date: Mon, 3 Jun 2013 01:01:03 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
References: <201306030055.15413.heiko@sntech.de>
In-Reply-To: <201306030055.15413.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306030101.04370.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uarts on all recent Rockchip SoCs are Synopsis DesignWare 8250 types.
Only their addresses vary very much.

This patch adds the necessary definitions to use any of the uart ports
for early debug purposes.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/arm/Kconfig.debug            |   34 +++++++++++++++++++++++++++++
 arch/arm/include/debug/rockchip.S |   42 +++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/debug/rockchip.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 29f7623..2060cd5 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -360,6 +360,13 @@ choice
 		  their output to the standard serial port on the RealView
 		  PB1176 platform.
 
+	config DEBUG_ROCKCHIP_UART
+		bool "Kernel low-level debugging messages via Rockchip UART"
+		depends on ARCH_ROCKCHIP
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on Rockchip based platforms.
+
 	config DEBUG_S3C_UART0
 		depends on PLAT_SAMSUNG
 		select DEBUG_EXYNOS_UART if ARCH_EXYNOS
@@ -597,6 +604,32 @@ endchoice
 
 choice
 	prompt "Low-level debug console UART"
+	depends on DEBUG_ROCKCHIP_UART
+
+	config DEBUG_RK29_UART0
+		bool "RK29 UART0"
+
+	config DEBUG_RK29_UART1
+		bool "RK29 UART1"
+
+	config DEBUG_RK29_UART2
+		bool "RK29 UART2"
+
+	config DEBUG_RK3X_UART0
+		bool "RK3X UART0"
+
+	config DEBUG_RK3X_UART1
+		bool "RK3X UART1"
+
+	config DEBUG_RK3X_UART2
+		bool "RK3X UART2"
+
+	config DEBUG_RK3X_UART3
+		bool "RK3X UART3"
+endchoice
+
+choice
+	prompt "Low-level debug console UART"
 	depends on DEBUG_LL && DEBUG_TEGRA_UART
 
 	config TEGRA_DEBUG_UART_AUTO_ODMDATA
@@ -648,6 +681,7 @@ config DEBUG_LL_INCLUDE
 	default "debug/picoxcell.S" if DEBUG_PICOXCELL_UART
 	default "debug/pxa.S" if DEBUG_PXA_UART1 || DEBUG_MMP_UART2 || \
 				 DEBUG_MMP_UART3
+	default "debug/rockchip.S" if DEBUG_ROCKCHIP_UART
 	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
 	default "debug/socfpga.S" if DEBUG_SOCFPGA_UART
 	default "debug/sunxi.S" if DEBUG_SUNXI_UART0 || DEBUG_SUNXI_UART1
diff --git a/arch/arm/include/debug/rockchip.S b/arch/arm/include/debug/rockchip.S
new file mode 100644
index 0000000..2b914dc
--- /dev/null
+++ b/arch/arm/include/debug/rockchip.S
@@ -0,0 +1,42 @@
+/*
+ * Early serial output macro for Rockchip SoCs
+ *
+ * Copyright (C) 2012 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#if defined(CONFIG_DEBUG_RK29_UART0)
+#define ROCKCHIP_UART_DEBUG_PHYS_BASE 0x20060000
+#define ROCKCHIP_UART_DEBUG_VIRT_BASE 0xfe060000
+#elif defined(CONFIG_DEBUG_RK29_UART1)
+#define ROCKCHIP_UART_DEBUG_PHYS_BASE 0x20064000
+#define ROCKCHIP_UART_DEBUG_VIRT_BASE 0xfed64000
+#elif defined(CONFIG_DEBUG_RK29_UART2)
+#define ROCKCHIP_UART_DEBUG_PHYS_BASE 0x20068000
+#define ROCKCHIP_UART_DEBUG_VIRT_BASE 0xfed68000
+#elif defined(CONFIG_DEBUG_RK3X_UART0)
+#define ROCKCHIP_UART_DEBUG_PHYS_BASE 0x10124000
+#define ROCKCHIP_UART_DEBUG_VIRT_BASE 0xfeb24000
+#elif defined(CONFIG_DEBUG_RK3X_UART1)
+#define ROCKCHIP_UART_DEBUG_PHYS_BASE 0x10126000
+#define ROCKCHIP_UART_DEBUG_VIRT_BASE 0xfeb26000
+#elif defined(CONFIG_DEBUG_RK3X_UART2)
+#define ROCKCHIP_UART_DEBUG_PHYS_BASE 0x20064000
+#define ROCKCHIP_UART_DEBUG_VIRT_BASE 0xfed64000
+#elif defined(CONFIG_DEBUG_RK3X_UART3)
+#define ROCKCHIP_UART_DEBUG_PHYS_BASE 0x20068000
+#define ROCKCHIP_UART_DEBUG_VIRT_BASE 0xfed68000
+#endif
+
+	.macro	addruart, rp, rv, tmp
+	ldr	\rp, =ROCKCHIP_UART_DEBUG_PHYS_BASE
+	ldr	\rv, =ROCKCHIP_UART_DEBUG_VIRT_BASE
+	.endm
+
+#define UART_SHIFT	2
+#include <asm/hardware/debug-8250.S>
-- 
1.7.2.3

