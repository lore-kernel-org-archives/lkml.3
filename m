Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaJIT37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:29:59 -0400
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:45254
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751146AbaJIT3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:29:52 -0400
X-Greylist: delayed 2003 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Oct 2014 15:29:51 EDT
From: John Crispin <blogic@openwrt.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH 1/4] MIPS: ralink: cleanup the soc specific pinmux data
Date: Thu,  9 Oct 2014 04:55:24 +0200
Message-Id: <1412823327-10296-2-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1412823327-10296-1-git-send-email-blogic@openwrt.org>
References: <1412823327-10296-1-git-send-email-blogic@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before we had a pinctrl driver we used a custom OF api. This patch converts the
soc specific pinmux data to a new set of structs. We also add some new pinmux
setings.

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 arch/mips/include/asm/mach-ralink/mt7620.h |   41 +++++--
 arch/mips/include/asm/mach-ralink/pinmux.h |   55 +++++++++
 arch/mips/include/asm/mach-ralink/rt305x.h |   35 +++---
 arch/mips/include/asm/mach-ralink/rt3883.h |   16 +--
 arch/mips/ralink/common.h                  |   19 ---
 arch/mips/ralink/mt7620.c                  |  159 ++++++++-----------------
 arch/mips/ralink/rt288x.c                  |   62 ++++------
 arch/mips/ralink/rt305x.c                  |  153 +++++++++++-------------
 arch/mips/ralink/rt3883.c                  |  173 +++++++---------------------
 9 files changed, 293 insertions(+), 420 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-ralink/pinmux.h

diff --git a/arch/mips/include/asm/mach-ralink/mt7620.h b/arch/mips/include/asm/mach-ralink/mt7620.h
index 7ff9290..a05c14c2 100644
--- a/arch/mips/include/asm/mach-ralink/mt7620.h
+++ b/arch/mips/include/asm/mach-ralink/mt7620.h
@@ -82,7 +82,6 @@
 #define MT7620_DDR2_SIZE_MIN		32
 #define MT7620_DDR2_SIZE_MAX		256
 
-#define MT7620_GPIO_MODE_I2C		BIT(0)
 #define MT7620_GPIO_MODE_UART0_SHIFT	2
 #define MT7620_GPIO_MODE_UART0_MASK	0x7
 #define MT7620_GPIO_MODE_UART0(x)	((x) << MT7620_GPIO_MODE_UART0_SHIFT)
@@ -94,16 +93,36 @@
 #define MT7620_GPIO_MODE_GPIO_UARTF	0x5
 #define MT7620_GPIO_MODE_GPIO_I2S	0x6
 #define MT7620_GPIO_MODE_GPIO		0x7
-#define MT7620_GPIO_MODE_UART1		BIT(5)
-#define MT7620_GPIO_MODE_MDIO		BIT(8)
-#define MT7620_GPIO_MODE_RGMII1		BIT(9)
-#define MT7620_GPIO_MODE_RGMII2		BIT(10)
-#define MT7620_GPIO_MODE_SPI		BIT(11)
-#define MT7620_GPIO_MODE_SPI_REF_CLK	BIT(12)
-#define MT7620_GPIO_MODE_WLED		BIT(13)
-#define MT7620_GPIO_MODE_JTAG		BIT(15)
-#define MT7620_GPIO_MODE_EPHY		BIT(15)
-#define MT7620_GPIO_MODE_WDT		BIT(22)
+
+#define MT7620_GPIO_MODE_NAND		0
+#define MT7620_GPIO_MODE_SD		1
+#define MT7620_GPIO_MODE_ND_SD_GPIO	2
+#define MT7620_GPIO_MODE_ND_SD_MASK	0x3
+#define MT7620_GPIO_MODE_ND_SD_SHIFT	18
+
+#define MT7620_GPIO_MODE_PCIE_RST	0
+#define MT7620_GPIO_MODE_PCIE_REF	1
+#define MT7620_GPIO_MODE_PCIE_GPIO	2
+#define MT7620_GPIO_MODE_PCIE_MASK	0x3
+#define MT7620_GPIO_MODE_PCIE_SHIFT	16
+
+#define MT7620_GPIO_MODE_WDT_RST	0
+#define MT7620_GPIO_MODE_WDT_REF	1
+#define MT7620_GPIO_MODE_WDT_GPIO	2
+#define MT7620_GPIO_MODE_WDT_MASK	0x3
+#define MT7620_GPIO_MODE_WDT_SHIFT	21
+
+#define MT7620_GPIO_MODE_I2C		0
+#define MT7620_GPIO_MODE_UART1		5
+#define MT7620_GPIO_MODE_MDIO		8
+#define MT7620_GPIO_MODE_RGMII1		9
+#define MT7620_GPIO_MODE_RGMII2		10
+#define MT7620_GPIO_MODE_SPI		11
+#define MT7620_GPIO_MODE_SPI_REF_CLK	12
+#define MT7620_GPIO_MODE_WLED		13
+#define MT7620_GPIO_MODE_JTAG		15
+#define MT7620_GPIO_MODE_EPHY		15
+#define MT7620_GPIO_MODE_PA		20
 
 static inline int mt7620_get_eco(void)
 {
diff --git a/arch/mips/include/asm/mach-ralink/pinmux.h b/arch/mips/include/asm/mach-ralink/pinmux.h
new file mode 100644
index 0000000..be106cb
--- /dev/null
+++ b/arch/mips/include/asm/mach-ralink/pinmux.h
@@ -0,0 +1,55 @@
+/*
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ *
+ *  Copyright (C) 2012 John Crispin <blogic@openwrt.org>
+ */
+
+#ifndef _RT288X_PINMUX_H__
+#define _RT288X_PINMUX_H__
+
+#define FUNC(name, value, pin_first, pin_count) \
+	{ name, value, pin_first, pin_count }
+
+#define GRP(_name, _func, _mask, _shift) \
+	{ .name = _name, .mask = _mask, .shift = _shift, \
+	  .func = _func, .gpio = _mask, \
+	  .func_count = ARRAY_SIZE(_func) }
+
+#define GRP_G(_name, _func, _mask, _gpio, _shift) \
+	{ .name = _name, .mask = _mask, .shift = _shift, \
+	  .func = _func, .gpio = _gpio, \
+	  .func_count = ARRAY_SIZE(_func) }
+
+struct rt2880_pmx_group;
+
+struct rt2880_pmx_func {
+	const char *name;
+	const char value;
+
+	int pin_first;
+	int pin_count;
+	int *pins;
+
+	int *groups;
+	int group_count;
+
+	int enabled;
+};
+
+struct rt2880_pmx_group {
+	const char *name;
+	int enabled;
+
+	const u32 shift;
+	const char mask;
+	const char gpio;
+
+	struct rt2880_pmx_func *func;
+	int func_count;
+};
+
+extern struct rt2880_pmx_group *rt2880_pinmux_data;
+
+#endif
diff --git a/arch/mips/include/asm/mach-ralink/rt305x.h b/arch/mips/include/asm/mach-ralink/rt305x.h
index 069bf37..96f731b 100644
--- a/arch/mips/include/asm/mach-ralink/rt305x.h
+++ b/arch/mips/include/asm/mach-ralink/rt305x.h
@@ -125,24 +125,29 @@ static inline int soc_is_rt5350(void)
 #define RT305X_GPIO_GE0_TXD0		40
 #define RT305X_GPIO_GE0_RXCLK		51
 
-#define RT305X_GPIO_MODE_I2C		BIT(0)
-#define RT305X_GPIO_MODE_SPI		BIT(1)
 #define RT305X_GPIO_MODE_UART0_SHIFT	2
 #define RT305X_GPIO_MODE_UART0_MASK	0x7
 #define RT305X_GPIO_MODE_UART0(x)	((x) << RT305X_GPIO_MODE_UART0_SHIFT)
-#define RT305X_GPIO_MODE_UARTF		0x0
-#define RT305X_GPIO_MODE_PCM_UARTF	0x1
-#define RT305X_GPIO_MODE_PCM_I2S	0x2
-#define RT305X_GPIO_MODE_I2S_UARTF	0x3
-#define RT305X_GPIO_MODE_PCM_GPIO	0x4
-#define RT305X_GPIO_MODE_GPIO_UARTF	0x5
-#define RT305X_GPIO_MODE_GPIO_I2S	0x6
-#define RT305X_GPIO_MODE_GPIO		0x7
-#define RT305X_GPIO_MODE_UART1		BIT(5)
-#define RT305X_GPIO_MODE_JTAG		BIT(6)
-#define RT305X_GPIO_MODE_MDIO		BIT(7)
-#define RT305X_GPIO_MODE_SDRAM		BIT(8)
-#define RT305X_GPIO_MODE_RGMII		BIT(9)
+#define RT305X_GPIO_MODE_UARTF		0
+#define RT305X_GPIO_MODE_PCM_UARTF	1
+#define RT305X_GPIO_MODE_PCM_I2S	2
+#define RT305X_GPIO_MODE_I2S_UARTF	3
+#define RT305X_GPIO_MODE_PCM_GPIO	4
+#define RT305X_GPIO_MODE_GPIO_UARTF	5
+#define RT305X_GPIO_MODE_GPIO_I2S	6
+#define RT305X_GPIO_MODE_GPIO		7
+
+#define RT305X_GPIO_MODE_I2C		0
+#define RT305X_GPIO_MODE_SPI		1
+#define RT305X_GPIO_MODE_UART1		5
+#define RT305X_GPIO_MODE_JTAG		6
+#define RT305X_GPIO_MODE_MDIO		7
+#define RT305X_GPIO_MODE_SDRAM		8
+#define RT305X_GPIO_MODE_RGMII		9
+#define RT5350_GPIO_MODE_PHY_LED	14
+#define RT5350_GPIO_MODE_SPI_CS1	21
+#define RT3352_GPIO_MODE_LNA		18
+#define RT3352_GPIO_MODE_PA		20
 
 #define RT3352_SYSC_REG_SYSCFG0		0x010
 #define RT3352_SYSC_REG_SYSCFG1         0x014
diff --git a/arch/mips/include/asm/mach-ralink/rt3883.h b/arch/mips/include/asm/mach-ralink/rt3883.h
index 058382f..0fbe6f9 100644
--- a/arch/mips/include/asm/mach-ralink/rt3883.h
+++ b/arch/mips/include/asm/mach-ralink/rt3883.h
@@ -112,8 +112,6 @@
 #define RT3883_CLKCFG1_PCI_CLK_EN	BIT(19)
 #define RT3883_CLKCFG1_UPHY0_CLK_EN	BIT(18)
 
-#define RT3883_GPIO_MODE_I2C		BIT(0)
-#define RT3883_GPIO_MODE_SPI		BIT(1)
 #define RT3883_GPIO_MODE_UART0_SHIFT	2
 #define RT3883_GPIO_MODE_UART0_MASK	0x7
 #define RT3883_GPIO_MODE_UART0(x)	((x) << RT3883_GPIO_MODE_UART0_SHIFT)
@@ -125,11 +123,15 @@
 #define RT3883_GPIO_MODE_GPIO_UARTF	0x5
 #define RT3883_GPIO_MODE_GPIO_I2S	0x6
 #define RT3883_GPIO_MODE_GPIO		0x7
-#define RT3883_GPIO_MODE_UART1		BIT(5)
-#define RT3883_GPIO_MODE_JTAG		BIT(6)
-#define RT3883_GPIO_MODE_MDIO		BIT(7)
-#define RT3883_GPIO_MODE_GE1		BIT(9)
-#define RT3883_GPIO_MODE_GE2		BIT(10)
+
+#define RT3883_GPIO_MODE_I2C		0
+#define RT3883_GPIO_MODE_SPI		1
+#define RT3883_GPIO_MODE_UART1		5
+#define RT3883_GPIO_MODE_JTAG		6
+#define RT3883_GPIO_MODE_MDIO		7
+#define RT3883_GPIO_MODE_GE1		9
+#define RT3883_GPIO_MODE_GE2		10
+
 #define RT3883_GPIO_MODE_PCI_SHIFT	11
 #define RT3883_GPIO_MODE_PCI_MASK	0x7
 #define RT3883_GPIO_MODE_PCI		(RT3883_GPIO_MODE_PCI_MASK << RT3883_GPIO_MODE_PCI_SHIFT)
diff --git a/arch/mips/ralink/common.h b/arch/mips/ralink/common.h
index 42dfd61..8e7d8e6 100644
--- a/arch/mips/ralink/common.h
+++ b/arch/mips/ralink/common.h
@@ -11,25 +11,6 @@
 
 #define RAMIPS_SYS_TYPE_LEN	32
 
-struct ralink_pinmux_grp {
-	const char *name;
-	u32 mask;
-	int gpio_first;
-	int gpio_last;
-};
-
-struct ralink_pinmux {
-	struct ralink_pinmux_grp *mode;
-	struct ralink_pinmux_grp *uart;
-	int uart_shift;
-	u32 uart_mask;
-	void (*wdt_reset)(void);
-	struct ralink_pinmux_grp *pci;
-	int pci_shift;
-	u32 pci_mask;
-};
-extern struct ralink_pinmux rt_gpio_pinmux;
-
 struct ralink_soc_info {
 	unsigned char sys_type[RAMIPS_SYS_TYPE_LEN];
 	unsigned char *compatible;
diff --git a/arch/mips/ralink/mt7620.c b/arch/mips/ralink/mt7620.c
index 5846817..24fb40a 100644
--- a/arch/mips/ralink/mt7620.c
+++ b/arch/mips/ralink/mt7620.c
@@ -17,6 +17,7 @@
 #include <asm/mipsregs.h>
 #include <asm/mach-ralink/ralink_regs.h>
 #include <asm/mach-ralink/mt7620.h>
+#include <asm/mach-ralink/pinmux.h>
 
 #include "common.h"
 
@@ -39,118 +40,58 @@
 /* does the board have sdram or ddram */
 static int dram_type;
 
-static struct ralink_pinmux_grp mode_mux[] = {
-	{
-		.name = "i2c",
-		.mask = MT7620_GPIO_MODE_I2C,
-		.gpio_first = 1,
-		.gpio_last = 2,
-	}, {
-		.name = "spi",
-		.mask = MT7620_GPIO_MODE_SPI,
-		.gpio_first = 3,
-		.gpio_last = 6,
-	}, {
-		.name = "uartlite",
-		.mask = MT7620_GPIO_MODE_UART1,
-		.gpio_first = 15,
-		.gpio_last = 16,
-	}, {
-		.name = "wdt",
-		.mask = MT7620_GPIO_MODE_WDT,
-		.gpio_first = 17,
-		.gpio_last = 17,
-	}, {
-		.name = "mdio",
-		.mask = MT7620_GPIO_MODE_MDIO,
-		.gpio_first = 22,
-		.gpio_last = 23,
-	}, {
-		.name = "rgmii1",
-		.mask = MT7620_GPIO_MODE_RGMII1,
-		.gpio_first = 24,
-		.gpio_last = 35,
-	}, {
-		.name = "spi refclk",
-		.mask = MT7620_GPIO_MODE_SPI_REF_CLK,
-		.gpio_first = 37,
-		.gpio_last = 39,
-	}, {
-		.name = "jtag",
-		.mask = MT7620_GPIO_MODE_JTAG,
-		.gpio_first = 40,
-		.gpio_last = 44,
-	}, {
-		/* shared lines with jtag */
-		.name = "ephy",
-		.mask = MT7620_GPIO_MODE_EPHY,
-		.gpio_first = 40,
-		.gpio_last = 44,
-	}, {
-		.name = "nand",
-		.mask = MT7620_GPIO_MODE_JTAG,
-		.gpio_first = 45,
-		.gpio_last = 59,
-	}, {
-		.name = "rgmii2",
-		.mask = MT7620_GPIO_MODE_RGMII2,
-		.gpio_first = 60,
-		.gpio_last = 71,
-	}, {
-		.name = "wled",
-		.mask = MT7620_GPIO_MODE_WLED,
-		.gpio_first = 72,
-		.gpio_last = 72,
-	}, {0}
+static struct rt2880_pmx_func i2c_grp[] =  { FUNC("i2c", 0, 1, 2) };
+static struct rt2880_pmx_func spi_grp[] = { FUNC("spi", 0, 3, 4) };
+static struct rt2880_pmx_func uartlite_grp[] = { FUNC("uartlite", 0, 15, 2) };
+static struct rt2880_pmx_func mdio_grp[] = { FUNC("mdio", 0, 22, 2) };
+static struct rt2880_pmx_func rgmii1_grp[] = { FUNC("rgmii1", 0, 24, 12) };
+static struct rt2880_pmx_func refclk_grp[] = { FUNC("spi refclk", 0, 37, 3) };
+static struct rt2880_pmx_func ephy_grp[] = { FUNC("ephy", 0, 40, 5) };
+static struct rt2880_pmx_func rgmii2_grp[] = { FUNC("rgmii2", 0, 60, 12) };
+static struct rt2880_pmx_func wled_grp[] = { FUNC("wled", 0, 72, 1) };
+static struct rt2880_pmx_func pa_grp[] = { FUNC("pa", 0, 18, 4) };
+static struct rt2880_pmx_func uartf_grp[] = {
+	FUNC("uartf", MT7620_GPIO_MODE_UARTF, 7, 8),
+	FUNC("pcm uartf", MT7620_GPIO_MODE_PCM_UARTF, 7, 8),
+	FUNC("pcm i2s", MT7620_GPIO_MODE_PCM_I2S, 7, 8),
+	FUNC("i2s uartf", MT7620_GPIO_MODE_I2S_UARTF, 7, 8),
+	FUNC("pcm gpio", MT7620_GPIO_MODE_PCM_GPIO, 11, 4),
+	FUNC("gpio uartf", MT7620_GPIO_MODE_GPIO_UARTF, 7, 4),
+	FUNC("gpio i2s", MT7620_GPIO_MODE_GPIO_I2S, 7, 4),
 };
-
-static struct ralink_pinmux_grp uart_mux[] = {
-	{
-		.name = "uartf",
-		.mask = MT7620_GPIO_MODE_UARTF,
-		.gpio_first = 7,
-		.gpio_last = 14,
-	}, {
-		.name = "pcm uartf",
-		.mask = MT7620_GPIO_MODE_PCM_UARTF,
-		.gpio_first = 7,
-		.gpio_last = 14,
-	}, {
-		.name = "pcm i2s",
-		.mask = MT7620_GPIO_MODE_PCM_I2S,
-		.gpio_first = 7,
-		.gpio_last = 14,
-	}, {
-		.name = "i2s uartf",
-		.mask = MT7620_GPIO_MODE_I2S_UARTF,
-		.gpio_first = 7,
-		.gpio_last = 14,
-	}, {
-		.name = "pcm gpio",
-		.mask = MT7620_GPIO_MODE_PCM_GPIO,
-		.gpio_first = 11,
-		.gpio_last = 14,
-	}, {
-		.name = "gpio uartf",
-		.mask = MT7620_GPIO_MODE_GPIO_UARTF,
-		.gpio_first = 7,
-		.gpio_last = 10,
-	}, {
-		.name = "gpio i2s",
-		.mask = MT7620_GPIO_MODE_GPIO_I2S,
-		.gpio_first = 7,
-		.gpio_last = 10,
-	}, {
-		.name = "gpio",
-		.mask = MT7620_GPIO_MODE_GPIO,
-	}, {0}
+static struct rt2880_pmx_func wdt_grp[] = {
+	FUNC("wdt rst", 0, 17, 1),
+	FUNC("wdt refclk", 0, 17, 1),
+	};
+static struct rt2880_pmx_func pcie_rst_grp[] = {
+	FUNC("pcie rst", MT7620_GPIO_MODE_PCIE_RST, 36, 1),
+	FUNC("pcie refclk", MT7620_GPIO_MODE_PCIE_REF, 36, 1)
+};
+static struct rt2880_pmx_func nd_sd_grp[] = {
+	FUNC("nand", MT7620_GPIO_MODE_NAND, 45, 15),
+	FUNC("sd", MT7620_GPIO_MODE_SD, 45, 15)
 };
 
-struct ralink_pinmux rt_gpio_pinmux = {
-	.mode = mode_mux,
-	.uart = uart_mux,
-	.uart_shift = MT7620_GPIO_MODE_UART0_SHIFT,
-	.uart_mask = MT7620_GPIO_MODE_UART0_MASK,
+static struct rt2880_pmx_group mt7620a_pinmux_data[] = {
+	GRP("i2c", i2c_grp, 1, MT7620_GPIO_MODE_I2C),
+	GRP("uartf", uartf_grp, MT7620_GPIO_MODE_UART0_MASK,
+		MT7620_GPIO_MODE_UART0_SHIFT),
+	GRP("spi", spi_grp, 1, MT7620_GPIO_MODE_SPI),
+	GRP("uartlite", uartlite_grp, 1, MT7620_GPIO_MODE_UART1),
+	GRP_G("wdt", wdt_grp, MT7620_GPIO_MODE_WDT_MASK,
+		MT7620_GPIO_MODE_WDT_GPIO, MT7620_GPIO_MODE_WDT_SHIFT),
+	GRP("mdio", mdio_grp, 1, MT7620_GPIO_MODE_MDIO),
+	GRP("rgmii1", rgmii1_grp, 1, MT7620_GPIO_MODE_RGMII1),
+	GRP("spi refclk", refclk_grp, 1, MT7620_GPIO_MODE_SPI_REF_CLK),
+	GRP_G("pcie", pcie_rst_grp, MT7620_GPIO_MODE_PCIE_MASK,
+		MT7620_GPIO_MODE_PCIE_GPIO, MT7620_GPIO_MODE_PCIE_SHIFT),
+	GRP_G("nd_sd", nd_sd_grp, MT7620_GPIO_MODE_ND_SD_MASK,
+		MT7620_GPIO_MODE_ND_SD_GPIO, MT7620_GPIO_MODE_ND_SD_SHIFT),
+	GRP("rgmii2", rgmii2_grp, 1, MT7620_GPIO_MODE_RGMII2),
+	GRP("wled", wled_grp, 1, MT7620_GPIO_MODE_WLED),
+	GRP("ephy", ephy_grp, 1, MT7620_GPIO_MODE_EPHY),
+	GRP("pa", pa_grp, 1, MT7620_GPIO_MODE_PA),
+	{ 0 }
 };
 
 static __init u32
diff --git a/arch/mips/ralink/rt288x.c b/arch/mips/ralink/rt288x.c
index 90e8934..738cec8 100644
--- a/arch/mips/ralink/rt288x.c
+++ b/arch/mips/ralink/rt288x.c
@@ -17,46 +17,27 @@
 #include <asm/mipsregs.h>
 #include <asm/mach-ralink/ralink_regs.h>
 #include <asm/mach-ralink/rt288x.h>
+#include <asm/mach-ralink/pinmux.h>
 
 #include "common.h"
 
-static struct ralink_pinmux_grp mode_mux[] = {
-	{
-		.name = "i2c",
-		.mask = RT2880_GPIO_MODE_I2C,
-		.gpio_first = 1,
-		.gpio_last = 2,
-	}, {
-		.name = "spi",
-		.mask = RT2880_GPIO_MODE_SPI,
-		.gpio_first = 3,
-		.gpio_last = 6,
-	}, {
-		.name = "uartlite",
-		.mask = RT2880_GPIO_MODE_UART0,
-		.gpio_first = 7,
-		.gpio_last = 14,
-	}, {
-		.name = "jtag",
-		.mask = RT2880_GPIO_MODE_JTAG,
-		.gpio_first = 17,
-		.gpio_last = 21,
-	}, {
-		.name = "mdio",
-		.mask = RT2880_GPIO_MODE_MDIO,
-		.gpio_first = 22,
-		.gpio_last = 23,
-	}, {
-		.name = "sdram",
-		.mask = RT2880_GPIO_MODE_SDRAM,
-		.gpio_first = 24,
-		.gpio_last = 39,
-	}, {
-		.name = "pci",
-		.mask = RT2880_GPIO_MODE_PCI,
-		.gpio_first = 40,
-		.gpio_last = 71,
-	}, {0}
+static struct rt2880_pmx_func i2c_func[] = { FUNC("i2c", 0, 1, 2) };
+static struct rt2880_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
+static struct rt2880_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 7, 8) };
+static struct rt2880_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
+static struct rt2880_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
+static struct rt2880_pmx_func sdram_func[] = { FUNC("sdram", 0, 24, 16) };
+static struct rt2880_pmx_func pci_func[] = { FUNC("pci", 0, 40, 32) };
+
+static struct rt2880_pmx_group rt2880_pinmux_data_act[] = {
+	GRP("i2c", i2c_func, 1, RT2880_GPIO_MODE_I2C),
+	GRP("spi", spi_func, 1, RT2880_GPIO_MODE_SPI),
+	GRP("uartlite", uartlite_func, 1, RT2880_GPIO_MODE_UART0),
+	GRP("jtag", jtag_func, 1, RT2880_GPIO_MODE_JTAG),
+	GRP("mdio", mdio_func, 1, RT2880_GPIO_MODE_MDIO),
+	GRP("sdram", sdram_func, 1, RT2880_GPIO_MODE_SDRAM),
+	GRP("pci", pci_func, 1, RT2880_GPIO_MODE_PCI),
+	{ 0 }
 };
 
 static void rt288x_wdt_reset(void)
@@ -69,11 +50,6 @@ static void rt288x_wdt_reset(void)
 	rt_sysc_w32(t, SYSC_REG_CLKCFG);
 }
 
-struct ralink_pinmux rt_gpio_pinmux = {
-	.mode = mode_mux,
-	.wdt_reset = rt288x_wdt_reset,
-};
-
 void __init ralink_clk_init(void)
 {
 	unsigned long cpu_rate, wmac_rate = 40000000;
@@ -141,4 +117,6 @@ void prom_soc_init(struct ralink_soc_info *soc_info)
 	soc_info->mem_base = RT2880_SDRAM_BASE;
 	soc_info->mem_size_min = RT2880_MEM_SIZE_MIN;
 	soc_info->mem_size_max = RT2880_MEM_SIZE_MAX;
+
+	rt2880_pinmux_data = rt2880_pinmux_data_act;
 }
diff --git a/arch/mips/ralink/rt305x.c b/arch/mips/ralink/rt305x.c
index bb82a82..c40776a 100644
--- a/arch/mips/ralink/rt305x.c
+++ b/arch/mips/ralink/rt305x.c
@@ -17,90 +17,78 @@
 #include <asm/mipsregs.h>
 #include <asm/mach-ralink/ralink_regs.h>
 #include <asm/mach-ralink/rt305x.h>
+#include <asm/mach-ralink/pinmux.h>
 
 #include "common.h"
 
 enum rt305x_soc_type rt305x_soc;
 
-static struct ralink_pinmux_grp mode_mux[] = {
-	{
-		.name = "i2c",
-		.mask = RT305X_GPIO_MODE_I2C,
-		.gpio_first = RT305X_GPIO_I2C_SD,
-		.gpio_last = RT305X_GPIO_I2C_SCLK,
-	}, {
-		.name = "spi",
-		.mask = RT305X_GPIO_MODE_SPI,
-		.gpio_first = RT305X_GPIO_SPI_EN,
-		.gpio_last = RT305X_GPIO_SPI_CLK,
-	}, {
-		.name = "uartlite",
-		.mask = RT305X_GPIO_MODE_UART1,
-		.gpio_first = RT305X_GPIO_UART1_TXD,
-		.gpio_last = RT305X_GPIO_UART1_RXD,
-	}, {
-		.name = "jtag",
-		.mask = RT305X_GPIO_MODE_JTAG,
-		.gpio_first = RT305X_GPIO_JTAG_TDO,
-		.gpio_last = RT305X_GPIO_JTAG_TDI,
-	}, {
-		.name = "mdio",
-		.mask = RT305X_GPIO_MODE_MDIO,
-		.gpio_first = RT305X_GPIO_MDIO_MDC,
-		.gpio_last = RT305X_GPIO_MDIO_MDIO,
-	}, {
-		.name = "sdram",
-		.mask = RT305X_GPIO_MODE_SDRAM,
-		.gpio_first = RT305X_GPIO_SDRAM_MD16,
-		.gpio_last = RT305X_GPIO_SDRAM_MD31,
-	}, {
-		.name = "rgmii",
-		.mask = RT305X_GPIO_MODE_RGMII,
-		.gpio_first = RT305X_GPIO_GE0_TXD0,
-		.gpio_last = RT305X_GPIO_GE0_RXCLK,
-	}, {0}
+static struct rt2880_pmx_func i2c_func[] =  { FUNC("i2c", 0, 1, 2) };
+static struct rt2880_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
+static struct rt2880_pmx_func uartf_func[] = {
+	FUNC("uartf", RT305X_GPIO_MODE_UARTF, 7, 8),
+	FUNC("pcm uartf", RT305X_GPIO_MODE_PCM_UARTF, 7, 8),
+	FUNC("pcm i2s", RT305X_GPIO_MODE_PCM_I2S, 7, 8),
+	FUNC("i2s uartf", RT305X_GPIO_MODE_I2S_UARTF, 7, 8),
+	FUNC("pcm gpio", RT305X_GPIO_MODE_PCM_GPIO, 11, 4),
+	FUNC("gpio uartf", RT305X_GPIO_MODE_GPIO_UARTF, 7, 4),
+	FUNC("gpio i2s", RT305X_GPIO_MODE_GPIO_I2S, 7, 4),
+};
+static struct rt2880_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 15, 2) };
+static struct rt2880_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
+static struct rt2880_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
+static struct rt2880_pmx_func rt5350_led_func[] = { FUNC("led", 0, 22, 5) };
+static struct rt2880_pmx_func rt5350_cs1_func[] = {
+	FUNC("spi_cs1", 0, 27, 1),
+	FUNC("wdg_cs1", 1, 27, 1),
+};
+static struct rt2880_pmx_func sdram_func[] = { FUNC("sdram", 0, 24, 16) };
+static struct rt2880_pmx_func rt3352_rgmii_func[] = {
+	FUNC("rgmii", 0, 24, 12)
+};
+static struct rt2880_pmx_func rgmii_func[] = { FUNC("rgmii", 0, 40, 12) };
+static struct rt2880_pmx_func rt3352_lna_func[] = { FUNC("lna", 0, 36, 2) };
+static struct rt2880_pmx_func rt3352_pa_func[] = { FUNC("pa", 0, 38, 2) };
+static struct rt2880_pmx_func rt3352_led_func[] = { FUNC("led", 0, 40, 5) };
+
+static struct rt2880_pmx_group rt3050_pinmux_data[] = {
+	GRP("i2c", i2c_func, 1, RT305X_GPIO_MODE_I2C),
+	GRP("spi", spi_func, 1, RT305X_GPIO_MODE_SPI),
+	GRP("uartf", uartf_func, RT305X_GPIO_MODE_UART0_MASK,
+		RT305X_GPIO_MODE_UART0_SHIFT),
+	GRP("uartlite", uartlite_func, 1, RT305X_GPIO_MODE_UART1),
+	GRP("jtag", jtag_func, 1, RT305X_GPIO_MODE_JTAG),
+	GRP("mdio", mdio_func, 1, RT305X_GPIO_MODE_MDIO),
+	GRP("rgmii", rgmii_func, 1, RT305X_GPIO_MODE_RGMII),
+	GRP("sdram", sdram_func, 1, RT305X_GPIO_MODE_SDRAM),
+	{ 0 }
 };
 
-static struct ralink_pinmux_grp uart_mux[] = {
-	{
-		.name = "uartf",
-		.mask = RT305X_GPIO_MODE_UARTF,
-		.gpio_first = RT305X_GPIO_7,
-		.gpio_last = RT305X_GPIO_14,
-	}, {
-		.name = "pcm uartf",
-		.mask = RT305X_GPIO_MODE_PCM_UARTF,
-		.gpio_first = RT305X_GPIO_7,
-		.gpio_last = RT305X_GPIO_14,
-	}, {
-		.name = "pcm i2s",
-		.mask = RT305X_GPIO_MODE_PCM_I2S,
-		.gpio_first = RT305X_GPIO_7,
-		.gpio_last = RT305X_GPIO_14,
-	}, {
-		.name = "i2s uartf",
-		.mask = RT305X_GPIO_MODE_I2S_UARTF,
-		.gpio_first = RT305X_GPIO_7,
-		.gpio_last = RT305X_GPIO_14,
-	}, {
-		.name = "pcm gpio",
-		.mask = RT305X_GPIO_MODE_PCM_GPIO,
-		.gpio_first = RT305X_GPIO_10,
-		.gpio_last = RT305X_GPIO_14,
-	}, {
-		.name = "gpio uartf",
-		.mask = RT305X_GPIO_MODE_GPIO_UARTF,
-		.gpio_first = RT305X_GPIO_7,
-		.gpio_last = RT305X_GPIO_10,
-	}, {
-		.name = "gpio i2s",
-		.mask = RT305X_GPIO_MODE_GPIO_I2S,
-		.gpio_first = RT305X_GPIO_7,
-		.gpio_last = RT305X_GPIO_10,
-	}, {
-		.name = "gpio",
-		.mask = RT305X_GPIO_MODE_GPIO,
-	}, {0}
+static struct rt2880_pmx_group rt3352_pinmux_data[] = {
+	GRP("i2c", i2c_func, 1, RT305X_GPIO_MODE_I2C),
+	GRP("spi", spi_func, 1, RT305X_GPIO_MODE_SPI),
+	GRP("uartf", uartf_func, RT305X_GPIO_MODE_UART0_MASK,
+		RT305X_GPIO_MODE_UART0_SHIFT),
+	GRP("uartlite", uartlite_func, 1, RT305X_GPIO_MODE_UART1),
+	GRP("jtag", jtag_func, 1, RT305X_GPIO_MODE_JTAG),
+	GRP("mdio", mdio_func, 1, RT305X_GPIO_MODE_MDIO),
+	GRP("rgmii", rt3352_rgmii_func, 1, RT305X_GPIO_MODE_RGMII),
+	GRP("lna", rt3352_lna_func, 1, RT3352_GPIO_MODE_LNA),
+	GRP("pa", rt3352_pa_func, 1, RT3352_GPIO_MODE_PA),
+	GRP("led", rt3352_led_func, 1, RT5350_GPIO_MODE_PHY_LED),
+	{ 0 }
+};
+
+static struct rt2880_pmx_group rt5350_pinmux_data[] = {
+	GRP("i2c", i2c_func, 1, RT305X_GPIO_MODE_I2C),
+	GRP("spi", spi_func, 1, RT305X_GPIO_MODE_SPI),
+	GRP("uartf", uartf_func, RT305X_GPIO_MODE_UART0_MASK,
+		RT305X_GPIO_MODE_UART0_SHIFT),
+	GRP("uartlite", uartlite_func, 1, RT305X_GPIO_MODE_UART1),
+	GRP("jtag", jtag_func, 1, RT305X_GPIO_MODE_JTAG),
+	GRP("led", rt5350_led_func, 1, RT5350_GPIO_MODE_PHY_LED),
+	GRP("spi_cs1", rt5350_cs1_func, 2, RT5350_GPIO_MODE_SPI_CS1),
+	{ 0 }
 };
 
 static void rt305x_wdt_reset(void)
@@ -114,14 +102,6 @@ static void rt305x_wdt_reset(void)
 	rt_sysc_w32(t, SYSC_REG_SYSTEM_CONFIG);
 }
 
-struct ralink_pinmux rt_gpio_pinmux = {
-	.mode = mode_mux,
-	.uart = uart_mux,
-	.uart_shift = RT305X_GPIO_MODE_UART0_SHIFT,
-	.uart_mask = RT305X_GPIO_MODE_UART0_MASK,
-	.wdt_reset = rt305x_wdt_reset,
-};
-
 static unsigned long rt5350_get_mem_size(void)
 {
 	void __iomem *sysc = (void __iomem *) KSEG1ADDR(RT305X_SYSC_BASE);
@@ -290,11 +270,14 @@ void prom_soc_init(struct ralink_soc_info *soc_info)
 	soc_info->mem_base = RT305X_SDRAM_BASE;
 	if (soc_is_rt5350()) {
 		soc_info->mem_size = rt5350_get_mem_size();
+		rt2880_pinmux_data = rt5350_pinmux_data;
 	} else if (soc_is_rt305x() || soc_is_rt3350()) {
 		soc_info->mem_size_min = RT305X_MEM_SIZE_MIN;
 		soc_info->mem_size_max = RT305X_MEM_SIZE_MAX;
+		rt2880_pinmux_data = rt3050_pinmux_data;
 	} else if (soc_is_rt3352()) {
 		soc_info->mem_size_min = RT3352_MEM_SIZE_MIN;
 		soc_info->mem_size_max = RT3352_MEM_SIZE_MAX;
+		rt2880_pinmux_data = rt3352_pinmux_data;
 	}
 }
diff --git a/arch/mips/ralink/rt3883.c b/arch/mips/ralink/rt3883.c
index 58b5b9f..86a535c 100644
--- a/arch/mips/ralink/rt3883.c
+++ b/arch/mips/ralink/rt3883.c
@@ -17,132 +17,50 @@
 #include <asm/mipsregs.h>
 #include <asm/mach-ralink/ralink_regs.h>
 #include <asm/mach-ralink/rt3883.h>
+#include <asm/mach-ralink/pinmux.h>
 
 #include "common.h"
 
-static struct ralink_pinmux_grp mode_mux[] = {
-	{
-		.name = "i2c",
-		.mask = RT3883_GPIO_MODE_I2C,
-		.gpio_first = RT3883_GPIO_I2C_SD,
-		.gpio_last = RT3883_GPIO_I2C_SCLK,
-	}, {
-		.name = "spi",
-		.mask = RT3883_GPIO_MODE_SPI,
-		.gpio_first = RT3883_GPIO_SPI_CS0,
-		.gpio_last = RT3883_GPIO_SPI_MISO,
-	}, {
-		.name = "uartlite",
-		.mask = RT3883_GPIO_MODE_UART1,
-		.gpio_first = RT3883_GPIO_UART1_TXD,
-		.gpio_last = RT3883_GPIO_UART1_RXD,
-	}, {
-		.name = "jtag",
-		.mask = RT3883_GPIO_MODE_JTAG,
-		.gpio_first = RT3883_GPIO_JTAG_TDO,
-		.gpio_last = RT3883_GPIO_JTAG_TCLK,
-	}, {
-		.name = "mdio",
-		.mask = RT3883_GPIO_MODE_MDIO,
-		.gpio_first = RT3883_GPIO_MDIO_MDC,
-		.gpio_last = RT3883_GPIO_MDIO_MDIO,
-	}, {
-		.name = "ge1",
-		.mask = RT3883_GPIO_MODE_GE1,
-		.gpio_first = RT3883_GPIO_GE1_TXD0,
-		.gpio_last = RT3883_GPIO_GE1_RXCLK,
-	}, {
-		.name = "ge2",
-		.mask = RT3883_GPIO_MODE_GE2,
-		.gpio_first = RT3883_GPIO_GE2_TXD0,
-		.gpio_last = RT3883_GPIO_GE2_RXCLK,
-	}, {
-		.name = "pci",
-		.mask = RT3883_GPIO_MODE_PCI,
-		.gpio_first = RT3883_GPIO_PCI_AD0,
-		.gpio_last = RT3883_GPIO_PCI_AD31,
-	}, {
-		.name = "lna a",
-		.mask = RT3883_GPIO_MODE_LNA_A,
-		.gpio_first = RT3883_GPIO_LNA_PE_A0,
-		.gpio_last = RT3883_GPIO_LNA_PE_A2,
-	}, {
-		.name = "lna g",
-		.mask = RT3883_GPIO_MODE_LNA_G,
-		.gpio_first = RT3883_GPIO_LNA_PE_G0,
-		.gpio_last = RT3883_GPIO_LNA_PE_G2,
-	}, {0}
+static struct rt2880_pmx_func i2c_func[] =  { FUNC("i2c", 0, 1, 2) };
+static struct rt2880_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
+static struct rt2880_pmx_func uartf_func[] = {
+	FUNC("uartf", RT3883_GPIO_MODE_UARTF, 7, 8),
+	FUNC("pcm uartf", RT3883_GPIO_MODE_PCM_UARTF, 7, 8),
+	FUNC("pcm i2s", RT3883_GPIO_MODE_PCM_I2S, 7, 8),
+	FUNC("i2s uartf", RT3883_GPIO_MODE_I2S_UARTF, 7, 8),
+	FUNC("pcm gpio", RT3883_GPIO_MODE_PCM_GPIO, 11, 4),
+	FUNC("gpio uartf", RT3883_GPIO_MODE_GPIO_UARTF, 7, 4),
+	FUNC("gpio i2s", RT3883_GPIO_MODE_GPIO_I2S, 7, 4),
 };
-
-static struct ralink_pinmux_grp uart_mux[] = {
-	{
-		.name = "uartf",
-		.mask = RT3883_GPIO_MODE_UARTF,
-		.gpio_first = RT3883_GPIO_7,
-		.gpio_last = RT3883_GPIO_14,
-	}, {
-		.name = "pcm uartf",
-		.mask = RT3883_GPIO_MODE_PCM_UARTF,
-		.gpio_first = RT3883_GPIO_7,
-		.gpio_last = RT3883_GPIO_14,
-	}, {
-		.name = "pcm i2s",
-		.mask = RT3883_GPIO_MODE_PCM_I2S,
-		.gpio_first = RT3883_GPIO_7,
-		.gpio_last = RT3883_GPIO_14,
-	}, {
-		.name = "i2s uartf",
-		.mask = RT3883_GPIO_MODE_I2S_UARTF,
-		.gpio_first = RT3883_GPIO_7,
-		.gpio_last = RT3883_GPIO_14,
-	}, {
-		.name = "pcm gpio",
-		.mask = RT3883_GPIO_MODE_PCM_GPIO,
-		.gpio_first = RT3883_GPIO_11,
-		.gpio_last = RT3883_GPIO_14,
-	}, {
-		.name = "gpio uartf",
-		.mask = RT3883_GPIO_MODE_GPIO_UARTF,
-		.gpio_first = RT3883_GPIO_7,
-		.gpio_last = RT3883_GPIO_10,
-	}, {
-		.name = "gpio i2s",
-		.mask = RT3883_GPIO_MODE_GPIO_I2S,
-		.gpio_first = RT3883_GPIO_7,
-		.gpio_last = RT3883_GPIO_10,
-	}, {
-		.name = "gpio",
-		.mask = RT3883_GPIO_MODE_GPIO,
-	}, {0}
+static struct rt2880_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 15, 2) };
+static struct rt2880_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
+static struct rt2880_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
+static struct rt2880_pmx_func lna_a_func[] = { FUNC("lna a", 0, 32, 3) };
+static struct rt2880_pmx_func lna_g_func[] = { FUNC("lna a", 0, 35, 3) };
+static struct rt2880_pmx_func pci_func[] = {
+	FUNC("pci-dev", 0, 40, 32),
+	FUNC("pci-host2", 1, 40, 32),
+	FUNC("pci-host1", 2, 40, 32),
+	FUNC("pci-fnc", 3, 40, 32)
 };
-
-static struct ralink_pinmux_grp pci_mux[] = {
-	{
-		.name = "pci-dev",
-		.mask = 0,
-		.gpio_first = RT3883_GPIO_PCI_AD0,
-		.gpio_last = RT3883_GPIO_PCI_AD31,
-	}, {
-		.name = "pci-host2",
-		.mask = 1,
-		.gpio_first = RT3883_GPIO_PCI_AD0,
-		.gpio_last = RT3883_GPIO_PCI_AD31,
-	}, {
-		.name = "pci-host1",
-		.mask = 2,
-		.gpio_first = RT3883_GPIO_PCI_AD0,
-		.gpio_last = RT3883_GPIO_PCI_AD31,
-	}, {
-		.name = "pci-fnc",
-		.mask = 3,
-		.gpio_first = RT3883_GPIO_PCI_AD0,
-		.gpio_last = RT3883_GPIO_PCI_AD31,
-	}, {
-		.name = "pci-gpio",
-		.mask = 7,
-		.gpio_first = RT3883_GPIO_PCI_AD0,
-		.gpio_last = RT3883_GPIO_PCI_AD31,
-	}, {0}
+static struct rt2880_pmx_func ge1_func[] = { FUNC("ge1", 0, 72, 12) };
+static struct rt2880_pmx_func ge2_func[] = { FUNC("ge1", 0, 84, 12) };
+
+static struct rt2880_pmx_group rt3883_pinmux_data[] = {
+	GRP("i2c", i2c_func, 1, RT3883_GPIO_MODE_I2C),
+	GRP("spi", spi_func, 1, RT3883_GPIO_MODE_SPI),
+	GRP("uartf", uartf_func, RT3883_GPIO_MODE_UART0_MASK,
+		RT3883_GPIO_MODE_UART0_SHIFT),
+	GRP("uartlite", uartlite_func, 1, RT3883_GPIO_MODE_UART1),
+	GRP("jtag", jtag_func, 1, RT3883_GPIO_MODE_JTAG),
+	GRP("mdio", mdio_func, 1, RT3883_GPIO_MODE_MDIO),
+	GRP("lna a", lna_a_func, 1, RT3883_GPIO_MODE_LNA_A),
+	GRP("lna g", lna_g_func, 1, RT3883_GPIO_MODE_LNA_G),
+	GRP("pci", pci_func, RT3883_GPIO_MODE_PCI_MASK,
+		RT3883_GPIO_MODE_PCI_SHIFT),
+	GRP("ge1", ge1_func, 1, RT3883_GPIO_MODE_GE1),
+	GRP("ge2", ge2_func, 1, RT3883_GPIO_MODE_GE2),
+	{ 0 }
 };
 
 static void rt3883_wdt_reset(void)
@@ -155,17 +73,6 @@ static void rt3883_wdt_reset(void)
 	rt_sysc_w32(t, RT3883_SYSC_REG_SYSCFG1);
 }
 
-struct ralink_pinmux rt_gpio_pinmux = {
-	.mode = mode_mux,
-	.uart = uart_mux,
-	.uart_shift = RT3883_GPIO_MODE_UART0_SHIFT,
-	.uart_mask = RT3883_GPIO_MODE_UART0_MASK,
-	.wdt_reset = rt3883_wdt_reset,
-	.pci = pci_mux,
-	.pci_shift = RT3883_GPIO_MODE_PCI_SHIFT,
-	.pci_mask = RT3883_GPIO_MODE_PCI_MASK,
-};
-
 void __init ralink_clk_init(void)
 {
 	unsigned long cpu_rate, sys_rate;
@@ -244,4 +151,6 @@ void prom_soc_init(struct ralink_soc_info *soc_info)
 	soc_info->mem_base = RT3883_SDRAM_BASE;
 	soc_info->mem_size_min = RT3883_MEM_SIZE_MIN;
 	soc_info->mem_size_max = RT3883_MEM_SIZE_MAX;
+
+	rt2880_pinmux_data = rt3883_pinmux_data;
 }
-- 
1.7.10.4

