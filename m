Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649Ab3DBEja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 00:39:30 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:63383 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab3DBEjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 00:39:13 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: linux.walleij@linaro.org
Cc: swarren@wwwdotorg.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv4 3/6] pinctrl: gpio: vt8500: Add pincontrol driver for arch-vt8500
Date: Tue,  2 Apr 2013 17:39:07 +1300
Message-Id: <1364877550-25921-4-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364877550-25921-1-git-send-email-linux@prisktech.co.nz>
References: <1364877550-25921-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the GPIO/pinmux controller found on the VIA
VT8500 and Wondermedia WM8xxx-series SoCs.

Each pin within the controller is capable of operating as a GPIO or as
an alternate function. The pins are numbered according to their control
bank/bit so that if new pins are added, the existing numbering is maintained.

All currently supported SoCs are included: VT8500, WM8505, WM8650, WM8750 and
WM8850.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
 .../devicetree/bindings/pinctrl/pinctrl-vt8500.txt |   57 ++
 arch/arm/mach-vt8500/Kconfig                       |    1 +
 drivers/pinctrl/Kconfig                            |    1 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/vt8500/Kconfig                     |   52 ++
 drivers/pinctrl/vt8500/Makefile                    |    8 +
 drivers/pinctrl/vt8500/pinctrl-vt8500.c            |  501 ++++++++++++++++
 drivers/pinctrl/vt8500/pinctrl-wm8505.c            |  532 +++++++++++++++++
 drivers/pinctrl/vt8500/pinctrl-wm8650.c            |  370 ++++++++++++
 drivers/pinctrl/vt8500/pinctrl-wm8750.c            |  409 +++++++++++++
 drivers/pinctrl/vt8500/pinctrl-wm8850.c            |  388 ++++++++++++
 drivers/pinctrl/vt8500/pinctrl-wmt.c               |  620 ++++++++++++++++++++
 drivers/pinctrl/vt8500/pinctrl-wmt.h               |   79 +++
 13 files changed, 3019 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-vt8500.txt
 create mode 100644 drivers/pinctrl/vt8500/Kconfig
 create mode 100644 drivers/pinctrl/vt8500/Makefile
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-vt8500.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8505.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8650.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8750.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wm8850.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wmt.c
 create mode 100644 drivers/pinctrl/vt8500/pinctrl-wmt.h

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-vt8500.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-vt8500.txt
new file mode 100644
index 0000000..b3aa90f
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-vt8500.txt
@@ -0,0 +1,57 @@
+VIA VT8500 and Wondermedia WM8xxx-series pinmux/gpio controller
+
+These SoCs contain a combined Pinmux/GPIO module. Each pin may operate as
+either a GPIO in, GPIO out or as an alternate function (I2C, SPI etc).
+
+Required properties:
+- compatible: "via,vt8500-pinctrl", "wm,wm8505-pinctrl", "wm,wm8650-pinctrl",
+	"wm8750-pinctrl" or "wm,wm8850-pinctrl"
+- reg: Should contain the physical address of the module's registers.
+- interrupt-controller: Marks the device node as an interrupt controller.
+- #interrupt-cells: Should be two.
+- gpio-controller: Marks the device node as a GPIO controller.
+- #gpio-cells : Should be two. The first cell is the pin number and the
+  second cell is used to specify optional parameters.
+	bit 0 - active low
+
+Please refer to ../gpio/gpio.txt for a general description of GPIO bindings.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+Each pin configuration node lists the pin(s) to which it applies, and one or
+more of the mux functions to select on those pin(s), and pull-up/down
+configuration. Each subnode only affects those parameters that are explicitly
+listed. In other words, a subnode that lists only a mux function implies no
+information about any pull configuration. Similarly, a subnode that lists only
+a pull parameter implies no information about the mux function.
+
+Required subnode-properties:
+- wm,pins: An array of cells. Each cell contains the ID of a pin.
+
+Optional subnode-properties:
+- wm,function: Integer, containing the function to mux to the pin(s):
+  0: GPIO in
+  1: GPIO out
+  2: alternate
+
+- wm,pull: Integer, representing the pull-down/up to apply to the pin(s):
+  0: none
+  1: down
+  2: up
+
+Each of wm,function and wm,pull may contain either a single value which
+will be applied to all pins in wm,pins, or one value for each entry in
+wm,pins.
+
+Example:
+
+	pinctrl: pinctrl {
+		compatible = "wm,wm8505-pinctrl";
+		reg = <0xD8110000 0x10000>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
index e3e94b2..9b25293 100644
--- a/arch/arm/mach-vt8500/Kconfig
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -7,6 +7,7 @@ config ARCH_VT8500
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
 	select VT8500_TIMER
+	select PINCTRL
 	help
 	  Support for VIA/WonderMedia VT8500/WM85xx System-on-Chip.
 
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 34f51d2..35e9400 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -229,6 +229,7 @@ config PINCTRL_EXYNOS5440
 source "drivers/pinctrl/mvebu/Kconfig"
 source "drivers/pinctrl/sh-pfc/Kconfig"
 source "drivers/pinctrl/spear/Kconfig"
+source "drivers/pinctrl/vt8500/Kconfig"
 
 config PINCTRL_XWAY
 	bool
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index f82cc5b..a5a52c8 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -52,3 +52,4 @@ obj-$(CONFIG_PLAT_ORION)        += mvebu/
 obj-$(CONFIG_ARCH_SHMOBILE)	+= sh-pfc/
 obj-$(CONFIG_SUPERH)		+= sh-pfc/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
+obj-$(CONFIG_ARCH_VT8500)	+= vt8500/
diff --git a/drivers/pinctrl/vt8500/Kconfig b/drivers/pinctrl/vt8500/Kconfig
new file mode 100644
index 0000000..55724a7
--- /dev/null
+++ b/drivers/pinctrl/vt8500/Kconfig
@@ -0,0 +1,52 @@
+#
+# VIA/Wondermedia PINCTRL drivers
+#
+
+if ARCH_VT8500
+
+config PINCTRL_WMT
+	bool
+	select PINMUX
+	select GENERIC_PINCONF
+
+config PINCTRL_VT8500
+	bool "VIA VT8500 pin controller driver"
+	depends on ARCH_WM8505
+	select PINCTRL_WMT
+	help
+	  Say yes here to support the gpio/pin control module on
+	  VIA VT8500 SoCs.
+
+config PINCTRL_WM8505
+	bool "Wondermedia WM8505 pin controller driver"
+	depends on ARCH_WM8505
+	select PINCTRL_WMT
+	help
+	  Say yes here to support the gpio/pin control module on
+	  Wondermedia WM8505 SoCs.
+
+config PINCTRL_WM8650
+	bool "Wondermedia WM8650 pin controller driver"
+	depends on ARCH_WM8505
+	select PINCTRL_WMT
+	help
+	  Say yes here to support the gpio/pin control module on
+	  Wondermedia WM8650 SoCs.
+
+config PINCTRL_WM8750
+	bool "Wondermedia WM8750 pin controller driver"
+	depends on ARCH_WM8750
+	select PINCTRL_WMT
+	help
+	  Say yes here to support the gpio/pin control module on
+	  Wondermedia WM8750 SoCs.
+
+config PINCTRL_WM8850
+	bool "Wondermedia WM8850 pin controller driver"
+	depends on ARCH_WM8850
+	select PINCTRL_WMT
+	help
+	  Say yes here to support the gpio/pin control module on
+	  Wondermedia WM8850 SoCs.
+
+endif
diff --git a/drivers/pinctrl/vt8500/Makefile b/drivers/pinctrl/vt8500/Makefile
new file mode 100644
index 0000000..24ec45d
--- /dev/null
+++ b/drivers/pinctrl/vt8500/Makefile
@@ -0,0 +1,8 @@
+# VIA/Wondermedia pinctrl support
+
+obj-$(CONFIG_PINCTRL_WMT)	+= pinctrl-wmt.o
+obj-$(CONFIG_PINCTRL_VT8500)	+= pinctrl-vt8500.o
+obj-$(CONFIG_PINCTRL_WM8505)	+= pinctrl-wm8505.o
+obj-$(CONFIG_PINCTRL_WM8650)	+= pinctrl-wm8650.o
+obj-$(CONFIG_PINCTRL_WM8750)	+= pinctrl-wm8750.o
+obj-$(CONFIG_PINCTRL_WM8850)	+= pinctrl-wm8850.o
diff --git a/drivers/pinctrl/vt8500/pinctrl-vt8500.c b/drivers/pinctrl/vt8500/pinctrl-vt8500.c
new file mode 100644
index 0000000..f2fe9f8
--- /dev/null
+++ b/drivers/pinctrl/vt8500/pinctrl-vt8500.c
@@ -0,0 +1,501 @@
+/*
+ * Pinctrl data for VIA VT8500 SoC
+ *
+ * Copyright (c) 2013 Tony Prisk <linux@prisktech.co.nz>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "pinctrl-wmt.h"
+
+/*
+ * Describe the register offsets within the GPIO memory space
+ * The dedicated external GPIO's should always be listed in bank 0
+ * so they are exported in the 0..31 range which is what users
+ * expect.
+ *
+ * Do not reorder these banks as it will change the pin numbering
+ */
+static const struct wmt_pinctrl_bank_registers vt8500_banks[] = {
+	WMT_PINCTRL_BANK(NO_REG, 0x3C, 0x5C, 0x7C, NO_REG, NO_REG),	/* 0 */
+	WMT_PINCTRL_BANK(0x00, 0x20, 0x40, 0x60, NO_REG, NO_REG),	/* 1 */
+	WMT_PINCTRL_BANK(0x04, 0x24, 0x44, 0x64, NO_REG, NO_REG),	/* 2 */
+	WMT_PINCTRL_BANK(0x08, 0x28, 0x48, 0x68, NO_REG, NO_REG),	/* 3 */
+	WMT_PINCTRL_BANK(0x0C, 0x2C, 0x4C, 0x6C, NO_REG, NO_REG),	/* 4 */
+	WMT_PINCTRL_BANK(0x10, 0x30, 0x50, 0x70, NO_REG, NO_REG),	/* 5 */
+	WMT_PINCTRL_BANK(0x14, 0x34, 0x54, 0x74, NO_REG, NO_REG),	/* 6 */
+};
+
+/* Please keep sorted by bank/bit */
+#define WMT_PIN_EXTGPIO0	WMT_PIN(0, 0)
+#define WMT_PIN_EXTGPIO1	WMT_PIN(0, 1)
+#define WMT_PIN_EXTGPIO2	WMT_PIN(0, 2)
+#define WMT_PIN_EXTGPIO3	WMT_PIN(0, 3)
+#define WMT_PIN_EXTGPIO4	WMT_PIN(0, 4)
+#define WMT_PIN_EXTGPIO5	WMT_PIN(0, 5)
+#define WMT_PIN_EXTGPIO6	WMT_PIN(0, 6)
+#define WMT_PIN_EXTGPIO7	WMT_PIN(0, 7)
+#define WMT_PIN_EXTGPIO8	WMT_PIN(0, 8)
+#define WMT_PIN_UART0RTS	WMT_PIN(1, 0)
+#define WMT_PIN_UART0TXD	WMT_PIN(1, 1)
+#define WMT_PIN_UART0CTS	WMT_PIN(1, 2)
+#define WMT_PIN_UART0RXD	WMT_PIN(1, 3)
+#define WMT_PIN_UART1RTS	WMT_PIN(1, 4)
+#define WMT_PIN_UART1TXD	WMT_PIN(1, 5)
+#define WMT_PIN_UART1CTS	WMT_PIN(1, 6)
+#define WMT_PIN_UART1RXD	WMT_PIN(1, 7)
+#define WMT_PIN_SPI0CLK		WMT_PIN(1, 8)
+#define WMT_PIN_SPI0SS		WMT_PIN(1, 9)
+#define WMT_PIN_SPI0MISO	WMT_PIN(1, 10)
+#define WMT_PIN_SPI0MOSI	WMT_PIN(1, 11)
+#define WMT_PIN_SPI1CLK		WMT_PIN(1, 12)
+#define WMT_PIN_SPI1SS		WMT_PIN(1, 13)
+#define WMT_PIN_SPI1MISO	WMT_PIN(1, 14)
+#define WMT_PIN_SPI1MOSI	WMT_PIN(1, 15)
+#define WMT_PIN_SPI2CLK		WMT_PIN(1, 16)
+#define WMT_PIN_SPI2SS		WMT_PIN(1, 17)
+#define WMT_PIN_SPI2MISO	WMT_PIN(1, 18)
+#define WMT_PIN_SPI2MOSI	WMT_PIN(1, 19)
+#define WMT_PIN_SDDATA0		WMT_PIN(2, 0)
+#define WMT_PIN_SDDATA1		WMT_PIN(2, 1)
+#define WMT_PIN_SDDATA2		WMT_PIN(2, 2)
+#define WMT_PIN_SDDATA3		WMT_PIN(2, 3)
+#define WMT_PIN_MMCDATA0	WMT_PIN(2, 4)
+#define WMT_PIN_MMCDATA1	WMT_PIN(2, 5)
+#define WMT_PIN_MMCDATA2	WMT_PIN(2, 6)
+#define WMT_PIN_MMCDATA3	WMT_PIN(2, 7)
+#define WMT_PIN_SDCLK		WMT_PIN(2, 8)
+#define WMT_PIN_SDWP		WMT_PIN(2, 9)
+#define WMT_PIN_SDCMD		WMT_PIN(2, 10)
+#define WMT_PIN_MSDATA0		WMT_PIN(2, 16)
+#define WMT_PIN_MSDATA1		WMT_PIN(2, 17)
+#define WMT_PIN_MSDATA2		WMT_PIN(2, 18)
+#define WMT_PIN_MSDATA3		WMT_PIN(2, 19)
+#define WMT_PIN_MSCLK		WMT_PIN(2, 20)
+#define WMT_PIN_MSBS		WMT_PIN(2, 21)
+#define WMT_PIN_MSINS		WMT_PIN(2, 22)
+#define WMT_PIN_I2C0SCL		WMT_PIN(2, 24)
+#define WMT_PIN_I2C0SDA		WMT_PIN(2, 25)
+#define WMT_PIN_I2C1SCL		WMT_PIN(2, 26)
+#define WMT_PIN_I2C1SDA		WMT_PIN(2, 27)
+#define WMT_PIN_MII0RXD0	WMT_PIN(3, 0)
+#define WMT_PIN_MII0RXD1	WMT_PIN(3, 1)
+#define WMT_PIN_MII0RXD2	WMT_PIN(3, 2)
+#define WMT_PIN_MII0RXD3	WMT_PIN(3, 3)
+#define WMT_PIN_MII0RXCLK	WMT_PIN(3, 4)
+#define WMT_PIN_MII0RXDV	WMT_PIN(3, 5)
+#define WMT_PIN_MII0RXERR	WMT_PIN(3, 6)
+#define WMT_PIN_MII0PHYRST	WMT_PIN(3, 7)
+#define WMT_PIN_MII0TXD0	WMT_PIN(3, 8)
+#define WMT_PIN_MII0TXD1	WMT_PIN(3, 9)
+#define WMT_PIN_MII0TXD2	WMT_PIN(3, 10)
+#define WMT_PIN_MII0TXD3	WMT_PIN(3, 11)
+#define WMT_PIN_MII0TXCLK	WMT_PIN(3, 12)
+#define WMT_PIN_MII0TXEN	WMT_PIN(3, 13)
+#define WMT_PIN_MII0TXERR	WMT_PIN(3, 14)
+#define WMT_PIN_MII0PHYPD	WMT_PIN(3, 15)
+#define WMT_PIN_MII0COL		WMT_PIN(3, 16)
+#define WMT_PIN_MII0CRS		WMT_PIN(3, 17)
+#define WMT_PIN_MII0MDIO	WMT_PIN(3, 18)
+#define WMT_PIN_MII0MDC		WMT_PIN(3, 19)
+#define WMT_PIN_SEECS		WMT_PIN(3, 20)
+#define WMT_PIN_SEECK		WMT_PIN(3, 21)
+#define WMT_PIN_SEEDI		WMT_PIN(3, 22)
+#define WMT_PIN_SEEDO		WMT_PIN(3, 23)
+#define WMT_PIN_IDEDREQ0	WMT_PIN(3, 24)
+#define WMT_PIN_IDEDREQ1	WMT_PIN(3, 25)
+#define WMT_PIN_IDEIOW		WMT_PIN(3, 26)
+#define WMT_PIN_IDEIOR		WMT_PIN(3, 27)
+#define WMT_PIN_IDEDACK		WMT_PIN(3, 28)
+#define WMT_PIN_IDEIORDY	WMT_PIN(3, 29)
+#define WMT_PIN_IDEINTRQ	WMT_PIN(3, 30)
+#define WMT_PIN_VDIN0		WMT_PIN(4, 0)
+#define WMT_PIN_VDIN1		WMT_PIN(4, 1)
+#define WMT_PIN_VDIN2		WMT_PIN(4, 2)
+#define WMT_PIN_VDIN3		WMT_PIN(4, 3)
+#define WMT_PIN_VDIN4		WMT_PIN(4, 4)
+#define WMT_PIN_VDIN5		WMT_PIN(4, 5)
+#define WMT_PIN_VDIN6		WMT_PIN(4, 6)
+#define WMT_PIN_VDIN7		WMT_PIN(4, 7)
+#define WMT_PIN_VDOUT0		WMT_PIN(4, 8)
+#define WMT_PIN_VDOUT1		WMT_PIN(4, 9)
+#define WMT_PIN_VDOUT2		WMT_PIN(4, 10)
+#define WMT_PIN_VDOUT3		WMT_PIN(4, 11)
+#define WMT_PIN_VDOUT4		WMT_PIN(4, 12)
+#define WMT_PIN_VDOUT5		WMT_PIN(4, 13)
+#define WMT_PIN_NANDCLE0	WMT_PIN(4, 14)
+#define WMT_PIN_NANDCLE1	WMT_PIN(4, 15)
+#define WMT_PIN_VDOUT6_7	WMT_PIN(4, 16)
+#define WMT_PIN_VHSYNC		WMT_PIN(4, 17)
+#define WMT_PIN_VVSYNC		WMT_PIN(4, 18)
+#define WMT_PIN_TSDIN0		WMT_PIN(5, 8)
+#define WMT_PIN_TSDIN1		WMT_PIN(5, 9)
+#define WMT_PIN_TSDIN2		WMT_PIN(5, 10)
+#define WMT_PIN_TSDIN3		WMT_PIN(5, 11)
+#define WMT_PIN_TSDIN4		WMT_PIN(5, 12)
+#define WMT_PIN_TSDIN5		WMT_PIN(5, 13)
+#define WMT_PIN_TSDIN6		WMT_PIN(5, 14)
+#define WMT_PIN_TSDIN7		WMT_PIN(5, 15)
+#define WMT_PIN_TSSYNC		WMT_PIN(5, 16)
+#define WMT_PIN_TSVALID		WMT_PIN(5, 17)
+#define WMT_PIN_TSCLK		WMT_PIN(5, 18)
+#define WMT_PIN_LCDD0		WMT_PIN(6, 0)
+#define WMT_PIN_LCDD1		WMT_PIN(6, 1)
+#define WMT_PIN_LCDD2		WMT_PIN(6, 2)
+#define WMT_PIN_LCDD3		WMT_PIN(6, 3)
+#define WMT_PIN_LCDD4		WMT_PIN(6, 4)
+#define WMT_PIN_LCDD5		WMT_PIN(6, 5)
+#define WMT_PIN_LCDD6		WMT_PIN(6, 6)
+#define WMT_PIN_LCDD7		WMT_PIN(6, 7)
+#define WMT_PIN_LCDD8		WMT_PIN(6, 8)
+#define WMT_PIN_LCDD9		WMT_PIN(6, 9)
+#define WMT_PIN_LCDD10		WMT_PIN(6, 10)
+#define WMT_PIN_LCDD11		WMT_PIN(6, 11)
+#define WMT_PIN_LCDD12		WMT_PIN(6, 12)
+#define WMT_PIN_LCDD13		WMT_PIN(6, 13)
+#define WMT_PIN_LCDD14		WMT_PIN(6, 14)
+#define WMT_PIN_LCDD15		WMT_PIN(6, 15)
+#define WMT_PIN_LCDD16		WMT_PIN(6, 16)
+#define WMT_PIN_LCDD17		WMT_PIN(6, 17)
+#define WMT_PIN_LCDCLK		WMT_PIN(6, 18)
+#define WMT_PIN_LCDDEN		WMT_PIN(6, 19)
+#define WMT_PIN_LCDLINE		WMT_PIN(6, 20)
+#define WMT_PIN_LCDFRM		WMT_PIN(6, 21)
+#define WMT_PIN_LCDBIAS		WMT_PIN(6, 22)
+
+static const struct pinctrl_pin_desc vt8500_pins[] = {
+	PINCTRL_PIN(WMT_PIN_EXTGPIO0, "extgpio0"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO1, "extgpio1"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO2, "extgpio2"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO3, "extgpio3"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO4, "extgpio4"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO5, "extgpio5"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO6, "extgpio6"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO7, "extgpio7"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO8, "extgpio8"),
+	PINCTRL_PIN(WMT_PIN_UART0RTS, "uart0_rts"),
+	PINCTRL_PIN(WMT_PIN_UART0TXD, "uart0_txd"),
+	PINCTRL_PIN(WMT_PIN_UART0CTS, "uart0_cts"),
+	PINCTRL_PIN(WMT_PIN_UART0RXD, "uart0_rxd"),
+	PINCTRL_PIN(WMT_PIN_UART1RTS, "uart1_rts"),
+	PINCTRL_PIN(WMT_PIN_UART1TXD, "uart1_txd"),
+	PINCTRL_PIN(WMT_PIN_UART1CTS, "uart1_cts"),
+	PINCTRL_PIN(WMT_PIN_UART1RXD, "uart1_rxd"),
+	PINCTRL_PIN(WMT_PIN_SPI0CLK, "spi0_clk"),
+	PINCTRL_PIN(WMT_PIN_SPI0SS, "spi0_ss"),
+	PINCTRL_PIN(WMT_PIN_SPI0MISO, "spi0_miso"),
+	PINCTRL_PIN(WMT_PIN_SPI0MOSI, "spi0_mosi"),
+	PINCTRL_PIN(WMT_PIN_SPI1CLK, "spi1_clk"),
+	PINCTRL_PIN(WMT_PIN_SPI1SS, "spi1_ss"),
+	PINCTRL_PIN(WMT_PIN_SPI1MISO, "spi1_miso"),
+	PINCTRL_PIN(WMT_PIN_SPI1MOSI, "spi1_mosi"),
+	PINCTRL_PIN(WMT_PIN_SPI2CLK, "spi2_clk"),
+	PINCTRL_PIN(WMT_PIN_SPI2SS, "spi2_ss"),
+	PINCTRL_PIN(WMT_PIN_SPI2MISO, "spi2_miso"),
+	PINCTRL_PIN(WMT_PIN_SPI2MOSI, "spi2_mosi"),
+	PINCTRL_PIN(WMT_PIN_SDDATA0, "sd_data0"),
+	PINCTRL_PIN(WMT_PIN_SDDATA1, "sd_data1"),
+	PINCTRL_PIN(WMT_PIN_SDDATA2, "sd_data2"),
+	PINCTRL_PIN(WMT_PIN_SDDATA3, "sd_data3"),
+	PINCTRL_PIN(WMT_PIN_MMCDATA0, "mmc_data0"),
+	PINCTRL_PIN(WMT_PIN_MMCDATA1, "mmc_data1"),
+	PINCTRL_PIN(WMT_PIN_MMCDATA2, "mmc_data2"),
+	PINCTRL_PIN(WMT_PIN_MMCDATA3, "mmc_data3"),
+	PINCTRL_PIN(WMT_PIN_SDCLK, "sd_clk"),
+	PINCTRL_PIN(WMT_PIN_SDWP, "sd_wp"),
+	PINCTRL_PIN(WMT_PIN_SDCMD, "sd_cmd"),
+	PINCTRL_PIN(WMT_PIN_MSDATA0, "ms_data0"),
+	PINCTRL_PIN(WMT_PIN_MSDATA1, "ms_data1"),
+	PINCTRL_PIN(WMT_PIN_MSDATA2, "ms_data2"),
+	PINCTRL_PIN(WMT_PIN_MSDATA3, "ms_data3"),
+	PINCTRL_PIN(WMT_PIN_MSCLK, "ms_clk"),
+	PINCTRL_PIN(WMT_PIN_MSBS, "ms_bs"),
+	PINCTRL_PIN(WMT_PIN_MSINS, "ms_ins"),
+	PINCTRL_PIN(WMT_PIN_I2C0SCL, "i2c0_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C0SDA, "i2c0_sda"),
+	PINCTRL_PIN(WMT_PIN_I2C1SCL, "i2c1_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C1SDA, "i2c1_sda"),
+	PINCTRL_PIN(WMT_PIN_MII0RXD0, "mii0_rxd0"),
+	PINCTRL_PIN(WMT_PIN_MII0RXD1, "mii0_rxd1"),
+	PINCTRL_PIN(WMT_PIN_MII0RXD2, "mii0_rxd2"),
+	PINCTRL_PIN(WMT_PIN_MII0RXD3, "mii0_rxd3"),
+	PINCTRL_PIN(WMT_PIN_MII0RXCLK, "mii0_rxclk"),
+	PINCTRL_PIN(WMT_PIN_MII0RXDV, "mii0_rxdv"),
+	PINCTRL_PIN(WMT_PIN_MII0RXERR, "mii0_rxerr"),
+	PINCTRL_PIN(WMT_PIN_MII0PHYRST, "mii0_phyrst"),
+	PINCTRL_PIN(WMT_PIN_MII0TXD0, "mii0_txd0"),
+	PINCTRL_PIN(WMT_PIN_MII0TXD1, "mii0_txd1"),
+	PINCTRL_PIN(WMT_PIN_MII0TXD2, "mii0_txd2"),
+	PINCTRL_PIN(WMT_PIN_MII0TXD3, "mii0_txd3"),
+	PINCTRL_PIN(WMT_PIN_MII0TXCLK, "mii0_txclk"),
+	PINCTRL_PIN(WMT_PIN_MII0TXEN, "mii0_txen"),
+	PINCTRL_PIN(WMT_PIN_MII0TXERR, "mii0_txerr"),
+	PINCTRL_PIN(WMT_PIN_MII0PHYPD, "mii0_phypd"),
+	PINCTRL_PIN(WMT_PIN_MII0COL, "mii0_col"),
+	PINCTRL_PIN(WMT_PIN_MII0CRS, "mii0_crs"),
+	PINCTRL_PIN(WMT_PIN_MII0MDIO, "mii0_mdio"),
+	PINCTRL_PIN(WMT_PIN_MII0MDC, "mii0_mdc"),
+	PINCTRL_PIN(WMT_PIN_SEECS, "see_cs"),
+	PINCTRL_PIN(WMT_PIN_SEECK, "see_ck"),
+	PINCTRL_PIN(WMT_PIN_SEEDI, "see_di"),
+	PINCTRL_PIN(WMT_PIN_SEEDO, "see_do"),
+	PINCTRL_PIN(WMT_PIN_IDEDREQ0, "ide_dreq0"),
+	PINCTRL_PIN(WMT_PIN_IDEDREQ1, "ide_dreq1"),
+	PINCTRL_PIN(WMT_PIN_IDEIOW, "ide_iow"),
+	PINCTRL_PIN(WMT_PIN_IDEIOR, "ide_ior"),
+	PINCTRL_PIN(WMT_PIN_IDEDACK, "ide_dack"),
+	PINCTRL_PIN(WMT_PIN_IDEIORDY, "ide_iordy"),
+	PINCTRL_PIN(WMT_PIN_IDEINTRQ, "ide_intrq"),
+	PINCTRL_PIN(WMT_PIN_VDIN0, "vdin0"),
+	PINCTRL_PIN(WMT_PIN_VDIN1, "vdin1"),
+	PINCTRL_PIN(WMT_PIN_VDIN2, "vdin2"),
+	PINCTRL_PIN(WMT_PIN_VDIN3, "vdin3"),
+	PINCTRL_PIN(WMT_PIN_VDIN4, "vdin4"),
+	PINCTRL_PIN(WMT_PIN_VDIN5, "vdin5"),
+	PINCTRL_PIN(WMT_PIN_VDIN6, "vdin6"),
+	PINCTRL_PIN(WMT_PIN_VDIN7, "vdin7"),
+	PINCTRL_PIN(WMT_PIN_VDOUT0, "vdout0"),
+	PINCTRL_PIN(WMT_PIN_VDOUT1, "vdout1"),
+	PINCTRL_PIN(WMT_PIN_VDOUT2, "vdout2"),
+	PINCTRL_PIN(WMT_PIN_VDOUT3, "vdout3"),
+	PINCTRL_PIN(WMT_PIN_VDOUT4, "vdout4"),
+	PINCTRL_PIN(WMT_PIN_VDOUT5, "vdout5"),
+	PINCTRL_PIN(WMT_PIN_NANDCLE0, "nand_cle0"),
+	PINCTRL_PIN(WMT_PIN_NANDCLE1, "nand_cle1"),
+	PINCTRL_PIN(WMT_PIN_VDOUT6_7, "vdout6_7"),
+	PINCTRL_PIN(WMT_PIN_VHSYNC, "vhsync"),
+	PINCTRL_PIN(WMT_PIN_VVSYNC, "vvsync"),
+	PINCTRL_PIN(WMT_PIN_TSDIN0, "tsdin0"),
+	PINCTRL_PIN(WMT_PIN_TSDIN1, "tsdin1"),
+	PINCTRL_PIN(WMT_PIN_TSDIN2, "tsdin2"),
+	PINCTRL_PIN(WMT_PIN_TSDIN3, "tsdin3"),
+	PINCTRL_PIN(WMT_PIN_TSDIN4, "tsdin4"),
+	PINCTRL_PIN(WMT_PIN_TSDIN5, "tsdin5"),
+	PINCTRL_PIN(WMT_PIN_TSDIN6, "tsdin6"),
+	PINCTRL_PIN(WMT_PIN_TSDIN7, "tsdin7"),
+	PINCTRL_PIN(WMT_PIN_TSSYNC, "tssync"),
+	PINCTRL_PIN(WMT_PIN_TSVALID, "tsvalid"),
+	PINCTRL_PIN(WMT_PIN_TSCLK, "tsclk"),
+	PINCTRL_PIN(WMT_PIN_LCDD0, "lcd_d0"),
+	PINCTRL_PIN(WMT_PIN_LCDD1, "lcd_d1"),
+	PINCTRL_PIN(WMT_PIN_LCDD2, "lcd_d2"),
+	PINCTRL_PIN(WMT_PIN_LCDD3, "lcd_d3"),
+	PINCTRL_PIN(WMT_PIN_LCDD4, "lcd_d4"),
+	PINCTRL_PIN(WMT_PIN_LCDD5, "lcd_d5"),
+	PINCTRL_PIN(WMT_PIN_LCDD6, "lcd_d6"),
+	PINCTRL_PIN(WMT_PIN_LCDD7, "lcd_d7"),
+	PINCTRL_PIN(WMT_PIN_LCDD8, "lcd_d8"),
+	PINCTRL_PIN(WMT_PIN_LCDD9, "lcd_d9"),
+	PINCTRL_PIN(WMT_PIN_LCDD10, "lcd_d10"),
+	PINCTRL_PIN(WMT_PIN_LCDD11, "lcd_d11"),
+	PINCTRL_PIN(WMT_PIN_LCDD12, "lcd_d12"),
+	PINCTRL_PIN(WMT_PIN_LCDD13, "lcd_d13"),
+	PINCTRL_PIN(WMT_PIN_LCDD14, "lcd_d14"),
+	PINCTRL_PIN(WMT_PIN_LCDD15, "lcd_d15"),
+	PINCTRL_PIN(WMT_PIN_LCDD16, "lcd_d16"),
+	PINCTRL_PIN(WMT_PIN_LCDD17, "lcd_d17"),
+	PINCTRL_PIN(WMT_PIN_LCDCLK, "lcd_clk"),
+	PINCTRL_PIN(WMT_PIN_LCDDEN, "lcd_den"),
+	PINCTRL_PIN(WMT_PIN_LCDLINE, "lcd_line"),
+	PINCTRL_PIN(WMT_PIN_LCDFRM, "lcd_frm"),
+	PINCTRL_PIN(WMT_PIN_LCDBIAS, "lcd_bias"),
+};
+
+/* Order of these names must match the above list */
+static const char * const vt8500_groups[] = {
+	"extgpio0",
+	"extgpio1",
+	"extgpio2",
+	"extgpio3",
+	"extgpio4",
+	"extgpio5",
+	"extgpio6",
+	"extgpio7",
+	"extgpio8",
+	"uart0_rts",
+	"uart0_txd",
+	"uart0_cts",
+	"uart0_rxd",
+	"uart1_rts",
+	"uart1_txd",
+	"uart1_cts",
+	"uart1_rxd",
+	"spi0_clk",
+	"spi0_ss",
+	"spi0_miso",
+	"spi0_mosi",
+	"spi1_clk",
+	"spi1_ss",
+	"spi1_miso",
+	"spi1_mosi",
+	"spi2_clk",
+	"spi2_ss",
+	"spi2_miso",
+	"spi2_mosi",
+	"sd_data0",
+	"sd_data1",
+	"sd_data2",
+	"sd_data3",
+	"mmc_data0",
+	"mmc_data1",
+	"mmc_data2",
+	"mmc_data3",
+	"sd_clk",
+	"sd_wp",
+	"sd_cmd",
+	"ms_data0",
+	"ms_data1",
+	"ms_data2",
+	"ms_data3",
+	"ms_clk",
+	"ms_bs",
+	"ms_ins",
+	"i2c0_scl",
+	"i2c0_sda",
+	"i2c1_scl",
+	"i2c1_sda",
+	"mii0_rxd0",
+	"mii0_rxd1",
+	"mii0_rxd2",
+	"mii0_rxd3",
+	"mii0_rxclk",
+	"mii0_rxdv",
+	"mii0_rxerr",
+	"mii0_phyrst",
+	"mii0_txd0",
+	"mii0_txd1",
+	"mii0_txd2",
+	"mii0_txd3",
+	"mii0_txclk",
+	"mii0_txen",
+	"mii0_txerr",
+	"mii0_phypd",
+	"mii0_col",
+	"mii0_crs",
+	"mii0_mdio",
+	"mii0_mdc",
+	"see_cs",
+	"see_ck",
+	"see_di",
+	"see_do",
+	"ide_dreq0",
+	"ide_dreq1",
+	"ide_iow",
+	"ide_ior",
+	"ide_dack",
+	"ide_iordy",
+	"ide_intrq",
+	"vdin0",
+	"vdin1",
+	"vdin2",
+	"vdin3",
+	"vdin4",
+	"vdin5",
+	"vdin6",
+	"vdin7",
+	"vdout0",
+	"vdout1",
+	"vdout2",
+	"vdout3",
+	"vdout4",
+	"vdout5",
+	"nand_cle0",
+	"nand_cle1",
+	"vdout6_7",
+	"vhsync",
+	"vvsync",
+	"tsdin0",
+	"tsdin1",
+	"tsdin2",
+	"tsdin3",
+	"tsdin4",
+	"tsdin5",
+	"tsdin6",
+	"tsdin7",
+	"tssync",
+	"tsvalid",
+	"tsclk",
+	"lcd_d0",
+	"lcd_d1",
+	"lcd_d2",
+	"lcd_d3",
+	"lcd_d4",
+	"lcd_d5",
+	"lcd_d6",
+	"lcd_d7",
+	"lcd_d8",
+	"lcd_d9",
+	"lcd_d10",
+	"lcd_d11",
+	"lcd_d12",
+	"lcd_d13",
+	"lcd_d14",
+	"lcd_d15",
+	"lcd_d16",
+	"lcd_d17",
+	"lcd_clk",
+	"lcd_den",
+	"lcd_line",
+	"lcd_frm",
+	"lcd_bias",
+};
+
+static int vt8500_pinctrl_probe(struct platform_device *pdev)
+{
+	struct wmt_pinctrl_data *data;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "failed to allocate data\n");
+		return -ENOMEM;
+	}
+
+	data->banks = vt8500_banks;
+	data->nbanks = ARRAY_SIZE(vt8500_banks);
+	data->pins = vt8500_pins;
+	data->npins = ARRAY_SIZE(vt8500_pins);
+	data->groups = vt8500_groups;
+	data->ngroups = ARRAY_SIZE(vt8500_groups);
+
+	return wmt_pinctrl_probe(pdev, data);
+}
+
+static int vt8500_pinctrl_remove(struct platform_device *pdev)
+{
+	return wmt_pinctrl_remove(pdev);
+}
+
+static struct of_device_id wmt_pinctrl_of_match[] = {
+	{ .compatible = "via,vt8500-pinctrl" },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver wmt_pinctrl_driver = {
+	.probe	= vt8500_pinctrl_probe,
+	.remove	= vt8500_pinctrl_remove,
+	.driver = {
+		.name	= "pinctrl-vt8500",
+		.owner	= THIS_MODULE,
+		.of_match_table	= wmt_pinctrl_of_match,
+	},
+};
+
+module_platform_driver(wmt_pinctrl_driver);
+
+MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
+MODULE_DESCRIPTION("VIA VT8500 Pincontrol driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, wmt_pinctrl_of_match);
diff --git a/drivers/pinctrl/vt8500/pinctrl-wm8505.c b/drivers/pinctrl/vt8500/pinctrl-wm8505.c
new file mode 100644
index 0000000..483ba73
--- /dev/null
+++ b/drivers/pinctrl/vt8500/pinctrl-wm8505.c
@@ -0,0 +1,532 @@
+/*
+ * Pinctrl data for Wondermedia WM8505 SoC
+ *
+ * Copyright (c) 2013 Tony Prisk <linux@prisktech.co.nz>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "pinctrl-wmt.h"
+
+/*
+ * Describe the register offsets within the GPIO memory space
+ * The dedicated external GPIO's should always be listed in bank 0
+ * so they are exported in the 0..31 range which is what users
+ * expect.
+ *
+ * Do not reorder these banks as it will change the pin numbering
+ */
+static const struct wmt_pinctrl_bank_registers wm8505_banks[] = {
+	WMT_PINCTRL_BANK(0x64, 0x8C, 0xB4, 0xDC, NO_REG, NO_REG),	/* 0 */
+	WMT_PINCTRL_BANK(0x40, 0x68, 0x90, 0xB8, NO_REG, NO_REG),	/* 1 */
+	WMT_PINCTRL_BANK(0x44, 0x6C, 0x94, 0xBC, NO_REG, NO_REG),	/* 2 */
+	WMT_PINCTRL_BANK(0x48, 0x70, 0x98, 0xC0, NO_REG, NO_REG),	/* 3 */
+	WMT_PINCTRL_BANK(0x4C, 0x74, 0x9C, 0xC4, NO_REG, NO_REG),	/* 4 */
+	WMT_PINCTRL_BANK(0x50, 0x78, 0xA0, 0xC8, NO_REG, NO_REG),	/* 5 */
+	WMT_PINCTRL_BANK(0x54, 0x7C, 0xA4, 0xD0, NO_REG, NO_REG),	/* 6 */
+	WMT_PINCTRL_BANK(0x58, 0x80, 0xA8, 0xD4, NO_REG, NO_REG),	/* 7 */
+	WMT_PINCTRL_BANK(0x5C, 0x84, 0xAC, 0xD8, NO_REG, NO_REG),	/* 8 */
+	WMT_PINCTRL_BANK(0x60, 0x88, 0xB0, 0xDC, NO_REG, NO_REG),	/* 9 */
+	WMT_PINCTRL_BANK(0x500, 0x504, 0x508, 0x50C, NO_REG, NO_REG),	/* 10 */
+};
+
+/* Please keep sorted by bank/bit */
+#define WMT_PIN_EXTGPIO0	WMT_PIN(0, 0)
+#define WMT_PIN_EXTGPIO1	WMT_PIN(0, 1)
+#define WMT_PIN_EXTGPIO2	WMT_PIN(0, 2)
+#define WMT_PIN_EXTGPIO3	WMT_PIN(0, 3)
+#define WMT_PIN_EXTGPIO4	WMT_PIN(0, 4)
+#define WMT_PIN_EXTGPIO5	WMT_PIN(0, 5)
+#define WMT_PIN_EXTGPIO6	WMT_PIN(0, 6)
+#define WMT_PIN_EXTGPIO7	WMT_PIN(0, 7)
+#define WMT_PIN_WAKEUP0		WMT_PIN(0, 16)
+#define WMT_PIN_WAKEUP1		WMT_PIN(0, 17)
+#define WMT_PIN_WAKEUP2		WMT_PIN(0, 18)
+#define WMT_PIN_WAKEUP3		WMT_PIN(0, 19)
+#define WMT_PIN_SUSGPIO0	WMT_PIN(0, 21)
+#define WMT_PIN_SDDATA0		WMT_PIN(1, 0)
+#define WMT_PIN_SDDATA1		WMT_PIN(1, 1)
+#define WMT_PIN_SDDATA2		WMT_PIN(1, 2)
+#define WMT_PIN_SDDATA3		WMT_PIN(1, 3)
+#define WMT_PIN_MMCDATA0	WMT_PIN(1, 4)
+#define WMT_PIN_MMCDATA1	WMT_PIN(1, 5)
+#define WMT_PIN_MMCDATA2	WMT_PIN(1, 6)
+#define WMT_PIN_MMCDATA3	WMT_PIN(1, 7)
+#define WMT_PIN_VDIN0		WMT_PIN(2, 0)
+#define WMT_PIN_VDIN1		WMT_PIN(2, 1)
+#define WMT_PIN_VDIN2		WMT_PIN(2, 2)
+#define WMT_PIN_VDIN3		WMT_PIN(2, 3)
+#define WMT_PIN_VDIN4		WMT_PIN(2, 4)
+#define WMT_PIN_VDIN5		WMT_PIN(2, 5)
+#define WMT_PIN_VDIN6		WMT_PIN(2, 6)
+#define WMT_PIN_VDIN7		WMT_PIN(2, 7)
+#define WMT_PIN_VDOUT0		WMT_PIN(2, 8)
+#define WMT_PIN_VDOUT1		WMT_PIN(2, 9)
+#define WMT_PIN_VDOUT2		WMT_PIN(2, 10)
+#define WMT_PIN_VDOUT3		WMT_PIN(2, 11)
+#define WMT_PIN_VDOUT4		WMT_PIN(2, 12)
+#define WMT_PIN_VDOUT5		WMT_PIN(2, 13)
+#define WMT_PIN_VDOUT6		WMT_PIN(2, 14)
+#define WMT_PIN_VDOUT7		WMT_PIN(2, 15)
+#define WMT_PIN_VDOUT8		WMT_PIN(2, 16)
+#define WMT_PIN_VDOUT9		WMT_PIN(2, 17)
+#define WMT_PIN_VDOUT10		WMT_PIN(2, 18)
+#define WMT_PIN_VDOUT11		WMT_PIN(2, 19)
+#define WMT_PIN_VDOUT12		WMT_PIN(2, 20)
+#define WMT_PIN_VDOUT13		WMT_PIN(2, 21)
+#define WMT_PIN_VDOUT14		WMT_PIN(2, 22)
+#define WMT_PIN_VDOUT15		WMT_PIN(2, 23)
+#define WMT_PIN_VDOUT16		WMT_PIN(2, 24)
+#define WMT_PIN_VDOUT17		WMT_PIN(2, 25)
+#define WMT_PIN_VDOUT18		WMT_PIN(2, 26)
+#define WMT_PIN_VDOUT19		WMT_PIN(2, 27)
+#define WMT_PIN_VDOUT20		WMT_PIN(2, 28)
+#define WMT_PIN_VDOUT21		WMT_PIN(2, 29)
+#define WMT_PIN_VDOUT22		WMT_PIN(2, 30)
+#define WMT_PIN_VDOUT23		WMT_PIN(2, 31)
+#define WMT_PIN_VHSYNC		WMT_PIN(3, 0)
+#define WMT_PIN_VVSYNC		WMT_PIN(3, 1)
+#define WMT_PIN_VGAHSYNC	WMT_PIN(3, 2)
+#define WMT_PIN_VGAVSYNC	WMT_PIN(3, 3)
+#define WMT_PIN_VDHSYNC		WMT_PIN(3, 4)
+#define WMT_PIN_VDVSYNC		WMT_PIN(3, 5)
+#define WMT_PIN_NORD0		WMT_PIN(4, 0)
+#define WMT_PIN_NORD1		WMT_PIN(4, 1)
+#define WMT_PIN_NORD2		WMT_PIN(4, 2)
+#define WMT_PIN_NORD3		WMT_PIN(4, 3)
+#define WMT_PIN_NORD4		WMT_PIN(4, 4)
+#define WMT_PIN_NORD5		WMT_PIN(4, 5)
+#define WMT_PIN_NORD6		WMT_PIN(4, 6)
+#define WMT_PIN_NORD7		WMT_PIN(4, 7)
+#define WMT_PIN_NORD8		WMT_PIN(4, 8)
+#define WMT_PIN_NORD9		WMT_PIN(4, 9)
+#define WMT_PIN_NORD10		WMT_PIN(4, 10)
+#define WMT_PIN_NORD11		WMT_PIN(4, 11)
+#define WMT_PIN_NORD12		WMT_PIN(4, 12)
+#define WMT_PIN_NORD13		WMT_PIN(4, 13)
+#define WMT_PIN_NORD14		WMT_PIN(4, 14)
+#define WMT_PIN_NORD15		WMT_PIN(4, 15)
+#define WMT_PIN_NORA0		WMT_PIN(5, 0)
+#define WMT_PIN_NORA1		WMT_PIN(5, 1)
+#define WMT_PIN_NORA2		WMT_PIN(5, 2)
+#define WMT_PIN_NORA3		WMT_PIN(5, 3)
+#define WMT_PIN_NORA4		WMT_PIN(5, 4)
+#define WMT_PIN_NORA5		WMT_PIN(5, 5)
+#define WMT_PIN_NORA6		WMT_PIN(5, 6)
+#define WMT_PIN_NORA7		WMT_PIN(5, 7)
+#define WMT_PIN_NORA8		WMT_PIN(5, 8)
+#define WMT_PIN_NORA9		WMT_PIN(5, 9)
+#define WMT_PIN_NORA10		WMT_PIN(5, 10)
+#define WMT_PIN_NORA11		WMT_PIN(5, 11)
+#define WMT_PIN_NORA12		WMT_PIN(5, 12)
+#define WMT_PIN_NORA13		WMT_PIN(5, 13)
+#define WMT_PIN_NORA14		WMT_PIN(5, 14)
+#define WMT_PIN_NORA15		WMT_PIN(5, 15)
+#define WMT_PIN_NORA16		WMT_PIN(5, 16)
+#define WMT_PIN_NORA17		WMT_PIN(5, 17)
+#define WMT_PIN_NORA18		WMT_PIN(5, 18)
+#define WMT_PIN_NORA19		WMT_PIN(5, 19)
+#define WMT_PIN_NORA20		WMT_PIN(5, 20)
+#define WMT_PIN_NORA21		WMT_PIN(5, 21)
+#define WMT_PIN_NORA22		WMT_PIN(5, 22)
+#define WMT_PIN_NORA23		WMT_PIN(5, 23)
+#define WMT_PIN_NORA24		WMT_PIN(5, 24)
+#define WMT_PIN_AC97SDI		WMT_PIN(6, 0)
+#define WMT_PIN_AC97SYNC	WMT_PIN(6, 1)
+#define WMT_PIN_AC97SDO		WMT_PIN(6, 2)
+#define WMT_PIN_AC97BCLK	WMT_PIN(6, 3)
+#define WMT_PIN_AC97RST		WMT_PIN(6, 4)
+#define WMT_PIN_SFDO		WMT_PIN(7, 0)
+#define WMT_PIN_SFCS0		WMT_PIN(7, 1)
+#define WMT_PIN_SFCS1		WMT_PIN(7, 2)
+#define WMT_PIN_SFCLK		WMT_PIN(7, 3)
+#define WMT_PIN_SFDI		WMT_PIN(7, 4)
+#define WMT_PIN_SPI0CLK		WMT_PIN(8, 0)
+#define WMT_PIN_SPI0MISO	WMT_PIN(8, 1)
+#define WMT_PIN_SPI0MOSI	WMT_PIN(8, 2)
+#define WMT_PIN_SPI0SS		WMT_PIN(8, 3)
+#define WMT_PIN_SPI1CLK		WMT_PIN(8, 4)
+#define WMT_PIN_SPI1MISO	WMT_PIN(8, 5)
+#define WMT_PIN_SPI1MOSI	WMT_PIN(8, 6)
+#define WMT_PIN_SPI1SS		WMT_PIN(8, 7)
+#define WMT_PIN_SPI2CLK		WMT_PIN(8, 8)
+#define WMT_PIN_SPI2MISO	WMT_PIN(8, 9)
+#define WMT_PIN_SPI2MOSI	WMT_PIN(8, 10)
+#define WMT_PIN_SPI2SS		WMT_PIN(8, 11)
+#define WMT_PIN_UART0_RTS	WMT_PIN(9, 0)
+#define WMT_PIN_UART0_TXD	WMT_PIN(9, 1)
+#define WMT_PIN_UART0_CTS	WMT_PIN(9, 2)
+#define WMT_PIN_UART0_RXD	WMT_PIN(9, 3)
+#define WMT_PIN_UART1_RTS	WMT_PIN(9, 4)
+#define WMT_PIN_UART1_TXD	WMT_PIN(9, 5)
+#define WMT_PIN_UART1_CTS	WMT_PIN(9, 6)
+#define WMT_PIN_UART1_RXD	WMT_PIN(9, 7)
+#define WMT_PIN_UART2_RTS	WMT_PIN(9, 8)
+#define WMT_PIN_UART2_TXD	WMT_PIN(9, 9)
+#define WMT_PIN_UART2_CTS	WMT_PIN(9, 10)
+#define WMT_PIN_UART2_RXD	WMT_PIN(9, 11)
+#define WMT_PIN_UART3_RTS	WMT_PIN(9, 12)
+#define WMT_PIN_UART3_TXD	WMT_PIN(9, 13)
+#define WMT_PIN_UART3_CTS	WMT_PIN(9, 14)
+#define WMT_PIN_UART3_RXD	WMT_PIN(9, 15)
+#define WMT_PIN_I2C0SCL		WMT_PIN(10, 0)
+#define WMT_PIN_I2C0SDA		WMT_PIN(10, 1)
+#define WMT_PIN_I2C1SCL		WMT_PIN(10, 2)
+#define WMT_PIN_I2C1SDA		WMT_PIN(10, 3)
+#define WMT_PIN_I2C2SCL		WMT_PIN(10, 4)
+#define WMT_PIN_I2C2SDA		WMT_PIN(10, 5)
+
+static const struct pinctrl_pin_desc wm8505_pins[] = {
+	PINCTRL_PIN(WMT_PIN_EXTGPIO0, "extgpio0"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO1, "extgpio1"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO2, "extgpio2"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO3, "extgpio3"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO4, "extgpio4"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO5, "extgpio5"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO6, "extgpio6"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO7, "extgpio7"),
+	PINCTRL_PIN(WMT_PIN_WAKEUP0, "wakeup0"),
+	PINCTRL_PIN(WMT_PIN_WAKEUP1, "wakeup1"),
+	PINCTRL_PIN(WMT_PIN_WAKEUP2, "wakeup2"),
+	PINCTRL_PIN(WMT_PIN_WAKEUP3, "wakeup3"),
+	PINCTRL_PIN(WMT_PIN_SUSGPIO0, "susgpio0"),
+	PINCTRL_PIN(WMT_PIN_SDDATA0, "sd_data0"),
+	PINCTRL_PIN(WMT_PIN_SDDATA1, "sd_data1"),
+	PINCTRL_PIN(WMT_PIN_SDDATA2, "sd_data2"),
+	PINCTRL_PIN(WMT_PIN_SDDATA3, "sd_data3"),
+	PINCTRL_PIN(WMT_PIN_MMCDATA0, "mmc_data0"),
+	PINCTRL_PIN(WMT_PIN_MMCDATA1, "mmc_data1"),
+	PINCTRL_PIN(WMT_PIN_MMCDATA2, "mmc_data2"),
+	PINCTRL_PIN(WMT_PIN_MMCDATA3, "mmc_data3"),
+	PINCTRL_PIN(WMT_PIN_VDIN0, "vdin0"),
+	PINCTRL_PIN(WMT_PIN_VDIN1, "vdin1"),
+	PINCTRL_PIN(WMT_PIN_VDIN2, "vdin2"),
+	PINCTRL_PIN(WMT_PIN_VDIN3, "vdin3"),
+	PINCTRL_PIN(WMT_PIN_VDIN4, "vdin4"),
+	PINCTRL_PIN(WMT_PIN_VDIN5, "vdin5"),
+	PINCTRL_PIN(WMT_PIN_VDIN6, "vdin6"),
+	PINCTRL_PIN(WMT_PIN_VDIN7, "vdin7"),
+	PINCTRL_PIN(WMT_PIN_VDOUT0, "vdout0"),
+	PINCTRL_PIN(WMT_PIN_VDOUT1, "vdout1"),
+	PINCTRL_PIN(WMT_PIN_VDOUT2, "vdout2"),
+	PINCTRL_PIN(WMT_PIN_VDOUT3, "vdout3"),
+	PINCTRL_PIN(WMT_PIN_VDOUT4, "vdout4"),
+	PINCTRL_PIN(WMT_PIN_VDOUT5, "vdout5"),
+	PINCTRL_PIN(WMT_PIN_VDOUT6, "vdout6"),
+	PINCTRL_PIN(WMT_PIN_VDOUT7, "vdout7"),
+	PINCTRL_PIN(WMT_PIN_VDOUT8, "vdout8"),
+	PINCTRL_PIN(WMT_PIN_VDOUT9, "vdout9"),
+	PINCTRL_PIN(WMT_PIN_VDOUT10, "vdout10"),
+	PINCTRL_PIN(WMT_PIN_VDOUT11, "vdout11"),
+	PINCTRL_PIN(WMT_PIN_VDOUT12, "vdout12"),
+	PINCTRL_PIN(WMT_PIN_VDOUT13, "vdout13"),
+	PINCTRL_PIN(WMT_PIN_VDOUT14, "vdout14"),
+	PINCTRL_PIN(WMT_PIN_VDOUT15, "vdout15"),
+	PINCTRL_PIN(WMT_PIN_VDOUT16, "vdout16"),
+	PINCTRL_PIN(WMT_PIN_VDOUT17, "vdout17"),
+	PINCTRL_PIN(WMT_PIN_VDOUT18, "vdout18"),
+	PINCTRL_PIN(WMT_PIN_VDOUT19, "vdout19"),
+	PINCTRL_PIN(WMT_PIN_VDOUT20, "vdout20"),
+	PINCTRL_PIN(WMT_PIN_VDOUT21, "vdout21"),
+	PINCTRL_PIN(WMT_PIN_VDOUT22, "vdout22"),
+	PINCTRL_PIN(WMT_PIN_VDOUT23, "vdout23"),
+	PINCTRL_PIN(WMT_PIN_VHSYNC, "v_hsync"),
+	PINCTRL_PIN(WMT_PIN_VVSYNC, "v_vsync"),
+	PINCTRL_PIN(WMT_PIN_VGAHSYNC, "vga_hsync"),
+	PINCTRL_PIN(WMT_PIN_VGAVSYNC, "vga_vsync"),
+	PINCTRL_PIN(WMT_PIN_VDHSYNC, "vd_hsync"),
+	PINCTRL_PIN(WMT_PIN_VDVSYNC, "vd_vsync"),
+	PINCTRL_PIN(WMT_PIN_NORD0, "nor_d0"),
+	PINCTRL_PIN(WMT_PIN_NORD1, "nor_d1"),
+	PINCTRL_PIN(WMT_PIN_NORD2, "nor_d2"),
+	PINCTRL_PIN(WMT_PIN_NORD3, "nor_d3"),
+	PINCTRL_PIN(WMT_PIN_NORD4, "nor_d4"),
+	PINCTRL_PIN(WMT_PIN_NORD5, "nor_d5"),
+	PINCTRL_PIN(WMT_PIN_NORD6, "nor_d6"),
+	PINCTRL_PIN(WMT_PIN_NORD7, "nor_d7"),
+	PINCTRL_PIN(WMT_PIN_NORD8, "nor_d8"),
+	PINCTRL_PIN(WMT_PIN_NORD9, "nor_d9"),
+	PINCTRL_PIN(WMT_PIN_NORD10, "nor_d10"),
+	PINCTRL_PIN(WMT_PIN_NORD11, "nor_d11"),
+	PINCTRL_PIN(WMT_PIN_NORD12, "nor_d12"),
+	PINCTRL_PIN(WMT_PIN_NORD13, "nor_d13"),
+	PINCTRL_PIN(WMT_PIN_NORD14, "nor_d14"),
+	PINCTRL_PIN(WMT_PIN_NORD15, "nor_d15"),
+	PINCTRL_PIN(WMT_PIN_NORA0, "nor_a0"),
+	PINCTRL_PIN(WMT_PIN_NORA1, "nor_a1"),
+	PINCTRL_PIN(WMT_PIN_NORA2, "nor_a2"),
+	PINCTRL_PIN(WMT_PIN_NORA3, "nor_a3"),
+	PINCTRL_PIN(WMT_PIN_NORA4, "nor_a4"),
+	PINCTRL_PIN(WMT_PIN_NORA5, "nor_a5"),
+	PINCTRL_PIN(WMT_PIN_NORA6, "nor_a6"),
+	PINCTRL_PIN(WMT_PIN_NORA7, "nor_a7"),
+	PINCTRL_PIN(WMT_PIN_NORA8, "nor_a8"),
+	PINCTRL_PIN(WMT_PIN_NORA9, "nor_a9"),
+	PINCTRL_PIN(WMT_PIN_NORA10, "nor_a10"),
+	PINCTRL_PIN(WMT_PIN_NORA11, "nor_a11"),
+	PINCTRL_PIN(WMT_PIN_NORA12, "nor_a12"),
+	PINCTRL_PIN(WMT_PIN_NORA13, "nor_a13"),
+	PINCTRL_PIN(WMT_PIN_NORA14, "nor_a14"),
+	PINCTRL_PIN(WMT_PIN_NORA15, "nor_a15"),
+	PINCTRL_PIN(WMT_PIN_NORA16, "nor_a16"),
+	PINCTRL_PIN(WMT_PIN_NORA17, "nor_a17"),
+	PINCTRL_PIN(WMT_PIN_NORA18, "nor_a18"),
+	PINCTRL_PIN(WMT_PIN_NORA19, "nor_a19"),
+	PINCTRL_PIN(WMT_PIN_NORA20, "nor_a20"),
+	PINCTRL_PIN(WMT_PIN_NORA21, "nor_a21"),
+	PINCTRL_PIN(WMT_PIN_NORA22, "nor_a22"),
+	PINCTRL_PIN(WMT_PIN_NORA23, "nor_a23"),
+	PINCTRL_PIN(WMT_PIN_NORA24, "nor_a24"),
+	PINCTRL_PIN(WMT_PIN_AC97SDI, "ac97_sdi"),
+	PINCTRL_PIN(WMT_PIN_AC97SYNC, "ac97_sync"),
+	PINCTRL_PIN(WMT_PIN_AC97SDO, "ac97_sdo"),
+	PINCTRL_PIN(WMT_PIN_AC97BCLK, "ac97_bclk"),
+	PINCTRL_PIN(WMT_PIN_AC97RST, "ac97_rst"),
+	PINCTRL_PIN(WMT_PIN_SFDO, "sf_do"),
+	PINCTRL_PIN(WMT_PIN_SFCS0, "sf_cs0"),
+	PINCTRL_PIN(WMT_PIN_SFCS1, "sf_cs1"),
+	PINCTRL_PIN(WMT_PIN_SFCLK, "sf_clk"),
+	PINCTRL_PIN(WMT_PIN_SFDI, "sf_di"),
+	PINCTRL_PIN(WMT_PIN_SPI0CLK, "spi0_clk"),
+	PINCTRL_PIN(WMT_PIN_SPI0MISO, "spi0_miso"),
+	PINCTRL_PIN(WMT_PIN_SPI0MOSI, "spi0_mosi"),
+	PINCTRL_PIN(WMT_PIN_SPI0SS, "spi0_ss"),
+	PINCTRL_PIN(WMT_PIN_SPI1CLK, "spi1_clk"),
+	PINCTRL_PIN(WMT_PIN_SPI1MISO, "spi1_miso"),
+	PINCTRL_PIN(WMT_PIN_SPI1MOSI, "spi1_mosi"),
+	PINCTRL_PIN(WMT_PIN_SPI1SS, "spi1_ss"),
+	PINCTRL_PIN(WMT_PIN_SPI2CLK, "spi2_clk"),
+	PINCTRL_PIN(WMT_PIN_SPI2MISO, "spi2_miso"),
+	PINCTRL_PIN(WMT_PIN_SPI2MOSI, "spi2_mosi"),
+	PINCTRL_PIN(WMT_PIN_SPI2SS, "spi2_ss"),
+	PINCTRL_PIN(WMT_PIN_UART0_RTS, "uart0_rts"),
+	PINCTRL_PIN(WMT_PIN_UART0_TXD, "uart0_txd"),
+	PINCTRL_PIN(WMT_PIN_UART0_CTS, "uart0_cts"),
+	PINCTRL_PIN(WMT_PIN_UART0_RXD, "uart0_rxd"),
+	PINCTRL_PIN(WMT_PIN_UART1_RTS, "uart1_rts"),
+	PINCTRL_PIN(WMT_PIN_UART1_TXD, "uart1_txd"),
+	PINCTRL_PIN(WMT_PIN_UART1_CTS, "uart1_cts"),
+	PINCTRL_PIN(WMT_PIN_UART1_RXD, "uart1_rxd"),
+	PINCTRL_PIN(WMT_PIN_UART2_RTS, "uart2_rts"),
+	PINCTRL_PIN(WMT_PIN_UART2_TXD, "uart2_txd"),
+	PINCTRL_PIN(WMT_PIN_UART2_CTS, "uart2_cts"),
+	PINCTRL_PIN(WMT_PIN_UART2_RXD, "uart2_rxd"),
+	PINCTRL_PIN(WMT_PIN_UART3_RTS, "uart3_rts"),
+	PINCTRL_PIN(WMT_PIN_UART3_TXD, "uart3_txd"),
+	PINCTRL_PIN(WMT_PIN_UART3_CTS, "uart3_cts"),
+	PINCTRL_PIN(WMT_PIN_UART3_RXD, "uart3_rxd"),
+	PINCTRL_PIN(WMT_PIN_I2C0SCL, "i2c0_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C0SDA, "i2c0_sda"),
+	PINCTRL_PIN(WMT_PIN_I2C1SCL, "i2c1_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C1SDA, "i2c1_sda"),
+	PINCTRL_PIN(WMT_PIN_I2C2SCL, "i2c2_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C2SDA, "i2c2_sda"),
+};
+
+/* Order of these names must match the above list */
+static const char * const wm8505_groups[] = {
+	"extgpio0",
+	"extgpio1",
+	"extgpio2",
+	"extgpio3",
+	"extgpio4",
+	"extgpio5",
+	"extgpio6",
+	"extgpio7",
+	"wakeup0",
+	"wakeup1",
+	"wakeup2",
+	"wakeup3",
+	"susgpio0",
+	"sd_data0",
+	"sd_data1",
+	"sd_data2",
+	"sd_data3",
+	"mmc_data0",
+	"mmc_data1",
+	"mmc_data2",
+	"mmc_data3",
+	"vdin0",
+	"vdin1",
+	"vdin2",
+	"vdin3",
+	"vdin4",
+	"vdin5",
+	"vdin6",
+	"vdin7",
+	"vdout0",
+	"vdout1",
+	"vdout2",
+	"vdout3",
+	"vdout4",
+	"vdout5",
+	"vdout6",
+	"vdout7",
+	"vdout8",
+	"vdout9",
+	"vdout10",
+	"vdout11",
+	"vdout12",
+	"vdout13",
+	"vdout14",
+	"vdout15",
+	"vdout16",
+	"vdout17",
+	"vdout18",
+	"vdout19",
+	"vdout20",
+	"vdout21",
+	"vdout22",
+	"vdout23",
+	"v_hsync",
+	"v_vsync",
+	"vga_hsync",
+	"vga_vsync",
+	"vd_hsync",
+	"vd_vsync",
+	"nor_d0",
+	"nor_d1",
+	"nor_d2",
+	"nor_d3",
+	"nor_d4",
+	"nor_d5",
+	"nor_d6",
+	"nor_d7",
+	"nor_d8",
+	"nor_d9",
+	"nor_d10",
+	"nor_d11",
+	"nor_d12",
+	"nor_d13",
+	"nor_d14",
+	"nor_d15",
+	"nor_a0",
+	"nor_a1",
+	"nor_a2",
+	"nor_a3",
+	"nor_a4",
+	"nor_a5",
+	"nor_a6",
+	"nor_a7",
+	"nor_a8",
+	"nor_a9",
+	"nor_a10",
+	"nor_a11",
+	"nor_a12",
+	"nor_a13",
+	"nor_a14",
+	"nor_a15",
+	"nor_a16",
+	"nor_a17",
+	"nor_a18",
+	"nor_a19",
+	"nor_a20",
+	"nor_a21",
+	"nor_a22",
+	"nor_a23",
+	"nor_a24",
+	"ac97_sdi",
+	"ac97_sync",
+	"ac97_sdo",
+	"ac97_bclk",
+	"ac97_rst",
+	"sf_do",
+	"sf_cs0",
+	"sf_cs1",
+	"sf_clk",
+	"sf_di",
+	"spi0_clk",
+	"spi0_miso",
+	"spi0_mosi",
+	"spi0_ss",
+	"spi1_clk",
+	"spi1_miso",
+	"spi1_mosi",
+	"spi1_ss",
+	"spi2_clk",
+	"spi2_miso",
+	"spi2_mosi",
+	"spi2_ss",
+	"uart0_rts",
+	"uart0_txd",
+	"uart0_cts",
+	"uart0_rxd",
+	"uart1_rts",
+	"uart1_txd",
+	"uart1_cts",
+	"uart1_rxd",
+	"uart2_rts",
+	"uart2_txd",
+	"uart2_cts",
+	"uart2_rxd",
+	"uart3_rts",
+	"uart3_txd",
+	"uart3_cts",
+	"uart3_rxd",
+	"i2c0_scl",
+	"i2c0_sda",
+	"i2c1_scl",
+	"i2c1_sda",
+	"i2c2_scl",
+	"i2c2_sda",
+};
+
+static int wm8505_pinctrl_probe(struct platform_device *pdev)
+{
+	struct wmt_pinctrl_data *data;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "failed to allocate data\n");
+		return -ENOMEM;
+	}
+
+	data->banks = wm8505_banks;
+	data->nbanks = ARRAY_SIZE(wm8505_banks);
+	data->pins = wm8505_pins;
+	data->npins = ARRAY_SIZE(wm8505_pins);
+	data->groups = wm8505_groups;
+	data->ngroups = ARRAY_SIZE(wm8505_groups);
+
+	return wmt_pinctrl_probe(pdev, data);
+}
+
+static int wm8505_pinctrl_remove(struct platform_device *pdev)
+{
+	return wmt_pinctrl_remove(pdev);
+}
+
+static struct of_device_id wmt_pinctrl_of_match[] = {
+	{ .compatible = "wm,wm8505-pinctrl" },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver wmt_pinctrl_driver = {
+	.probe	= wm8505_pinctrl_probe,
+	.remove	= wm8505_pinctrl_remove,
+	.driver = {
+		.name	= "pinctrl-wm8505",
+		.owner	= THIS_MODULE,
+		.of_match_table	= wmt_pinctrl_of_match,
+	},
+};
+
+module_platform_driver(wmt_pinctrl_driver);
+
+MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
+MODULE_DESCRIPTION("Wondermedia WM8505 Pincontrol driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, wmt_pinctrl_of_match);
diff --git a/drivers/pinctrl/vt8500/pinctrl-wm8650.c b/drivers/pinctrl/vt8500/pinctrl-wm8650.c
new file mode 100644
index 0000000..7de57f0
--- /dev/null
+++ b/drivers/pinctrl/vt8500/pinctrl-wm8650.c
@@ -0,0 +1,370 @@
+/*
+ * Pinctrl data for Wondermedia WM8650 SoC
+ *
+ * Copyright (c) 2013 Tony Prisk <linux@prisktech.co.nz>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "pinctrl-wmt.h"
+
+/*
+ * Describe the register offsets within the GPIO memory space
+ * The dedicated external GPIO's should always be listed in bank 0
+ * so they are exported in the 0..31 range which is what users
+ * expect.
+ *
+ * Do not reorder these banks as it will change the pin numbering
+ */
+static const struct wmt_pinctrl_bank_registers wm8650_banks[] = {
+	WMT_PINCTRL_BANK(0x40, 0x80, 0xC0, 0x00, 0x480, 0x4C0),		/* 0 */
+	WMT_PINCTRL_BANK(0x44, 0x84, 0xC4, 0x04, 0x484, 0x4C4),		/* 1 */
+	WMT_PINCTRL_BANK(0x48, 0x88, 0xC8, 0x08, 0x488, 0x4C8),		/* 2 */
+	WMT_PINCTRL_BANK(0x4C, 0x8C, 0xCC, 0x0C, 0x48C, 0x4CC),		/* 3 */
+	WMT_PINCTRL_BANK(0x50, 0x90, 0xD0, 0x10, 0x490, 0x4D0),		/* 4 */
+	WMT_PINCTRL_BANK(0x54, 0x94, 0xD4, 0x14, 0x494, 0x4D4),		/* 5 */
+	WMT_PINCTRL_BANK(0x58, 0x98, 0xD8, 0x18, 0x498, 0x4D8),		/* 6 */
+	WMT_PINCTRL_BANK(0x5C, 0x9C, 0xDC, 0x1C, 0x49C, 0x4DC),		/* 7 */
+};
+
+/* Please keep sorted by bank/bit */
+#define WMT_PIN_EXTGPIO0	WMT_PIN(0, 0)
+#define WMT_PIN_EXTGPIO1	WMT_PIN(0, 1)
+#define WMT_PIN_EXTGPIO2	WMT_PIN(0, 2)
+#define WMT_PIN_EXTGPIO3	WMT_PIN(0, 3)
+#define WMT_PIN_EXTGPIO4	WMT_PIN(0, 4)
+#define WMT_PIN_EXTGPIO5	WMT_PIN(0, 5)
+#define WMT_PIN_EXTGPIO6	WMT_PIN(0, 6)
+#define WMT_PIN_EXTGPIO7	WMT_PIN(0, 7)
+#define WMT_PIN_WAKEUP0		WMT_PIN(0, 16)
+#define WMT_PIN_WAKEUP1		WMT_PIN(0, 17)
+#define WMT_PIN_SUSGPIO0	WMT_PIN(0, 21)
+#define WMT_PIN_SD0CD		WMT_PIN(0, 28)
+#define WMT_PIN_SD1CD		WMT_PIN(0, 29)
+#define WMT_PIN_VDOUT0		WMT_PIN(1, 0)
+#define WMT_PIN_VDOUT1		WMT_PIN(1, 1)
+#define WMT_PIN_VDOUT2		WMT_PIN(1, 2)
+#define WMT_PIN_VDOUT3		WMT_PIN(1, 3)
+#define WMT_PIN_VDOUT4		WMT_PIN(1, 4)
+#define WMT_PIN_VDOUT5		WMT_PIN(1, 5)
+#define WMT_PIN_VDOUT6		WMT_PIN(1, 6)
+#define WMT_PIN_VDOUT7		WMT_PIN(1, 7)
+#define WMT_PIN_VDOUT8		WMT_PIN(1, 8)
+#define WMT_PIN_VDOUT9		WMT_PIN(1, 9)
+#define WMT_PIN_VDOUT10		WMT_PIN(1, 10)
+#define WMT_PIN_VDOUT11		WMT_PIN(1, 11)
+#define WMT_PIN_VDOUT12		WMT_PIN(1, 12)
+#define WMT_PIN_VDOUT13		WMT_PIN(1, 13)
+#define WMT_PIN_VDOUT14		WMT_PIN(1, 14)
+#define WMT_PIN_VDOUT15		WMT_PIN(1, 15)
+#define WMT_PIN_VDOUT16		WMT_PIN(1, 16)
+#define WMT_PIN_VDOUT17		WMT_PIN(1, 17)
+#define WMT_PIN_VDOUT18		WMT_PIN(1, 18)
+#define WMT_PIN_VDOUT19		WMT_PIN(1, 19)
+#define WMT_PIN_VDOUT20		WMT_PIN(1, 20)
+#define WMT_PIN_VDOUT21		WMT_PIN(1, 21)
+#define WMT_PIN_VDOUT22		WMT_PIN(1, 22)
+#define WMT_PIN_VDOUT23		WMT_PIN(1, 23)
+#define WMT_PIN_VDIN0		WMT_PIN(2, 0)
+#define WMT_PIN_VDIN1		WMT_PIN(2, 1)
+#define WMT_PIN_VDIN2		WMT_PIN(2, 2)
+#define WMT_PIN_VDIN3		WMT_PIN(2, 3)
+#define WMT_PIN_VDIN4		WMT_PIN(2, 4)
+#define WMT_PIN_VDIN5		WMT_PIN(2, 5)
+#define WMT_PIN_VDIN6		WMT_PIN(2, 6)
+#define WMT_PIN_VDIN7		WMT_PIN(2, 7)
+#define WMT_PIN_I2C1SCL		WMT_PIN(2, 12)
+#define WMT_PIN_I2C1SDA		WMT_PIN(2, 13)
+#define WMT_PIN_SPI0MOSI	WMT_PIN(2, 24)
+#define WMT_PIN_SPI0MISO	WMT_PIN(2, 25)
+#define WMT_PIN_SPI0SS0		WMT_PIN(2, 26)
+#define WMT_PIN_SPI0CLK		WMT_PIN(2, 27)
+#define WMT_PIN_SD0DATA0	WMT_PIN(3, 8)
+#define WMT_PIN_SD0DATA1	WMT_PIN(3, 9)
+#define WMT_PIN_SD0DATA2	WMT_PIN(3, 10)
+#define WMT_PIN_SD0DATA3	WMT_PIN(3, 11)
+#define WMT_PIN_SD0CLK		WMT_PIN(3, 12)
+#define WMT_PIN_SD0WP		WMT_PIN(3, 13)
+#define WMT_PIN_SD0CMD		WMT_PIN(3, 14)
+#define WMT_PIN_SD1DATA0	WMT_PIN(3, 24)
+#define WMT_PIN_SD1DATA1	WMT_PIN(3, 25)
+#define WMT_PIN_SD1DATA2	WMT_PIN(3, 26)
+#define WMT_PIN_SD1DATA3	WMT_PIN(3, 27)
+#define WMT_PIN_SD1DATA4	WMT_PIN(3, 28)
+#define WMT_PIN_SD1DATA5	WMT_PIN(3, 29)
+#define WMT_PIN_SD1DATA6	WMT_PIN(3, 30)
+#define WMT_PIN_SD1DATA7	WMT_PIN(3, 31)
+#define WMT_PIN_I2C0SCL		WMT_PIN(5, 8)
+#define WMT_PIN_I2C0SDA		WMT_PIN(5, 9)
+#define WMT_PIN_UART0RTS	WMT_PIN(5, 16)
+#define WMT_PIN_UART0TXD	WMT_PIN(5, 17)
+#define WMT_PIN_UART0CTS	WMT_PIN(5, 18)
+#define WMT_PIN_UART0RXD	WMT_PIN(5, 19)
+#define WMT_PIN_UART1RTS	WMT_PIN(5, 20)
+#define WMT_PIN_UART1TXD	WMT_PIN(5, 21)
+#define WMT_PIN_UART1CTS	WMT_PIN(5, 22)
+#define WMT_PIN_UART1RXD	WMT_PIN(5, 23)
+#define WMT_PIN_UART2RTS	WMT_PIN(5, 24)
+#define WMT_PIN_UART2TXD	WMT_PIN(5, 25)
+#define WMT_PIN_UART2CTS	WMT_PIN(5, 26)
+#define WMT_PIN_UART2RXD	WMT_PIN(5, 27)
+#define WMT_PIN_UART3RTS	WMT_PIN(5, 28)
+#define WMT_PIN_UART3TXD	WMT_PIN(5, 29)
+#define WMT_PIN_UART3CTS	WMT_PIN(5, 30)
+#define WMT_PIN_UART3RXD	WMT_PIN(5, 31)
+#define WMT_PIN_KPADROW0	WMT_PIN(6, 16)
+#define WMT_PIN_KPADROW1	WMT_PIN(6, 17)
+#define WMT_PIN_KPADCOL0	WMT_PIN(6, 18)
+#define WMT_PIN_KPADCOL1	WMT_PIN(6, 19)
+#define WMT_PIN_SD1CLK		WMT_PIN(7, 0)
+#define WMT_PIN_SD1CMD		WMT_PIN(7, 1)
+#define WMT_PIN_SD1WP		WMT_PIN(7, 13)
+
+static const struct pinctrl_pin_desc wm8650_pins[] = {
+	PINCTRL_PIN(WMT_PIN_EXTGPIO0, "extgpio0"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO1, "extgpio1"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO2, "extgpio2"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO3, "extgpio3"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO4, "extgpio4"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO5, "extgpio5"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO6, "extgpio6"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO7, "extgpio7"),
+	PINCTRL_PIN(WMT_PIN_WAKEUP0, "wakeup0"),
+	PINCTRL_PIN(WMT_PIN_WAKEUP1, "wakeup1"),
+	PINCTRL_PIN(WMT_PIN_SUSGPIO0, "susgpio0"),
+	PINCTRL_PIN(WMT_PIN_SD0CD, "sd0_cd"),
+	PINCTRL_PIN(WMT_PIN_SD1CD, "sd1_cd"),
+	PINCTRL_PIN(WMT_PIN_VDOUT0, "vdout0"),
+	PINCTRL_PIN(WMT_PIN_VDOUT1, "vdout1"),
+	PINCTRL_PIN(WMT_PIN_VDOUT2, "vdout2"),
+	PINCTRL_PIN(WMT_PIN_VDOUT3, "vdout3"),
+	PINCTRL_PIN(WMT_PIN_VDOUT4, "vdout4"),
+	PINCTRL_PIN(WMT_PIN_VDOUT5, "vdout5"),
+	PINCTRL_PIN(WMT_PIN_VDOUT6, "vdout6"),
+	PINCTRL_PIN(WMT_PIN_VDOUT7, "vdout7"),
+	PINCTRL_PIN(WMT_PIN_VDOUT8, "vdout8"),
+	PINCTRL_PIN(WMT_PIN_VDOUT9, "vdout9"),
+	PINCTRL_PIN(WMT_PIN_VDOUT10, "vdout10"),
+	PINCTRL_PIN(WMT_PIN_VDOUT11, "vdout11"),
+	PINCTRL_PIN(WMT_PIN_VDOUT12, "vdout12"),
+	PINCTRL_PIN(WMT_PIN_VDOUT13, "vdout13"),
+	PINCTRL_PIN(WMT_PIN_VDOUT14, "vdout14"),
+	PINCTRL_PIN(WMT_PIN_VDOUT15, "vdout15"),
+	PINCTRL_PIN(WMT_PIN_VDOUT16, "vdout16"),
+	PINCTRL_PIN(WMT_PIN_VDOUT17, "vdout17"),
+	PINCTRL_PIN(WMT_PIN_VDOUT18, "vdout18"),
+	PINCTRL_PIN(WMT_PIN_VDOUT19, "vdout19"),
+	PINCTRL_PIN(WMT_PIN_VDOUT20, "vdout20"),
+	PINCTRL_PIN(WMT_PIN_VDOUT21, "vdout21"),
+	PINCTRL_PIN(WMT_PIN_VDOUT22, "vdout22"),
+	PINCTRL_PIN(WMT_PIN_VDOUT23, "vdout23"),
+	PINCTRL_PIN(WMT_PIN_VDIN0, "vdin0"),
+	PINCTRL_PIN(WMT_PIN_VDIN1, "vdin1"),
+	PINCTRL_PIN(WMT_PIN_VDIN2, "vdin2"),
+	PINCTRL_PIN(WMT_PIN_VDIN3, "vdin3"),
+	PINCTRL_PIN(WMT_PIN_VDIN4, "vdin4"),
+	PINCTRL_PIN(WMT_PIN_VDIN5, "vdin5"),
+	PINCTRL_PIN(WMT_PIN_VDIN6, "vdin6"),
+	PINCTRL_PIN(WMT_PIN_VDIN7, "vdin7"),
+	PINCTRL_PIN(WMT_PIN_I2C1SCL, "i2c1_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C1SDA, "i2c1_sda"),
+	PINCTRL_PIN(WMT_PIN_SPI0MOSI, "spi0_mosi"),
+	PINCTRL_PIN(WMT_PIN_SPI0MISO, "spi0_miso"),
+	PINCTRL_PIN(WMT_PIN_SPI0SS0, "spi0_ss0"),
+	PINCTRL_PIN(WMT_PIN_SPI0CLK, "spi0_clk"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA0, "sd0_data0"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA1, "sd0_data1"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA2, "sd0_data2"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA3, "sd0_data3"),
+	PINCTRL_PIN(WMT_PIN_SD0CLK, "sd0_clk"),
+	PINCTRL_PIN(WMT_PIN_SD0WP, "sd0_wp"),
+	PINCTRL_PIN(WMT_PIN_SD0CMD, "sd0_cmd"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA0, "sd1_data0"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA1, "sd1_data1"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA2, "sd1_data2"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA3, "sd1_data3"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA4, "sd1_data4"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA5, "sd1_data5"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA6, "sd1_data6"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA7, "sd1_data7"),
+	PINCTRL_PIN(WMT_PIN_I2C0SCL, "i2c0_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C0SDA, "i2c0_sda"),
+	PINCTRL_PIN(WMT_PIN_UART0RTS, "uart0_rts"),
+	PINCTRL_PIN(WMT_PIN_UART0TXD, "uart0_txd"),
+	PINCTRL_PIN(WMT_PIN_UART0CTS, "uart0_cts"),
+	PINCTRL_PIN(WMT_PIN_UART0RXD, "uart0_rxd"),
+	PINCTRL_PIN(WMT_PIN_UART1RTS, "uart1_rts"),
+	PINCTRL_PIN(WMT_PIN_UART1TXD, "uart1_txd"),
+	PINCTRL_PIN(WMT_PIN_UART1CTS, "uart1_cts"),
+	PINCTRL_PIN(WMT_PIN_UART1RXD, "uart1_rxd"),
+	PINCTRL_PIN(WMT_PIN_UART2RTS, "uart2_rts"),
+	PINCTRL_PIN(WMT_PIN_UART2TXD, "uart2_txd"),
+	PINCTRL_PIN(WMT_PIN_UART2CTS, "uart2_cts"),
+	PINCTRL_PIN(WMT_PIN_UART2RXD, "uart2_rxd"),
+	PINCTRL_PIN(WMT_PIN_UART3RTS, "uart3_rts"),
+	PINCTRL_PIN(WMT_PIN_UART3TXD, "uart3_txd"),
+	PINCTRL_PIN(WMT_PIN_UART3CTS, "uart3_cts"),
+	PINCTRL_PIN(WMT_PIN_UART3RXD, "uart3_rxd"),
+	PINCTRL_PIN(WMT_PIN_KPADROW0, "kpadrow0"),
+	PINCTRL_PIN(WMT_PIN_KPADROW1, "kpadrow1"),
+	PINCTRL_PIN(WMT_PIN_KPADCOL0, "kpadcol0"),
+	PINCTRL_PIN(WMT_PIN_KPADCOL1, "kpadcol1"),
+	PINCTRL_PIN(WMT_PIN_SD1CLK, "sd1_clk"),
+	PINCTRL_PIN(WMT_PIN_SD1CMD, "sd1_cmd"),
+	PINCTRL_PIN(WMT_PIN_SD1WP, "sd1_wp"),
+};
+
+/* Order of these names must match the above list */
+static const char * const wm8650_groups[] = {
+	"extgpio0",
+	"extgpio1",
+	"extgpio2",
+	"extgpio3",
+	"extgpio4",
+	"extgpio5",
+	"extgpio6",
+	"extgpio7",
+	"wakeup0",
+	"wakeup1",
+	"susgpio0",
+	"sd0_cd",
+	"sd1_cd",
+	"vdout0",
+	"vdout1",
+	"vdout2",
+	"vdout3",
+	"vdout4",
+	"vdout5",
+	"vdout6",
+	"vdout7",
+	"vdout8",
+	"vdout9",
+	"vdout10",
+	"vdout11",
+	"vdout12",
+	"vdout13",
+	"vdout14",
+	"vdout15",
+	"vdout16",
+	"vdout17",
+	"vdout18",
+	"vdout19",
+	"vdout20",
+	"vdout21",
+	"vdout22",
+	"vdout23",
+	"vdin0",
+	"vdin1",
+	"vdin2",
+	"vdin3",
+	"vdin4",
+	"vdin5",
+	"vdin6",
+	"vdin7",
+	"i2c1_scl",
+	"i2c1_sda",
+	"spi0_mosi",
+	"spi0_miso",
+	"spi0_ss0",
+	"spi0_clk",
+	"sd0_data0",
+	"sd0_data1",
+	"sd0_data2",
+	"sd0_data3",
+	"sd0_clk",
+	"sd0_wp",
+	"sd0_cmd",
+	"sd1_data0",
+	"sd1_data1",
+	"sd1_data2",
+	"sd1_data3",
+	"sd1_data4",
+	"sd1_data5",
+	"sd1_data6",
+	"sd1_data7",
+	"i2c0_scl",
+	"i2c0_sda",
+	"uart0_rts",
+	"uart0_txd",
+	"uart0_cts",
+	"uart0_rxd",
+	"uart1_rts",
+	"uart1_txd",
+	"uart1_cts",
+	"uart1_rxd",
+	"uart2_rts",
+	"uart2_txd",
+	"uart2_cts",
+	"uart2_rxd",
+	"uart3_rts",
+	"uart3_txd",
+	"uart3_cts",
+	"uart3_rxd",
+	"kpadrow0",
+	"kpadrow1",
+	"kpadcol0",
+	"kpadcol1",
+	"sd1_clk",
+	"sd1_cmd",
+	"sd1_wp",
+};
+
+static int wm8650_pinctrl_probe(struct platform_device *pdev)
+{
+	struct wmt_pinctrl_data *data;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "failed to allocate data\n");
+		return -ENOMEM;
+	}
+
+	data->banks = wm8650_banks;
+	data->nbanks = ARRAY_SIZE(wm8650_banks);
+	data->pins = wm8650_pins;
+	data->npins = ARRAY_SIZE(wm8650_pins);
+	data->groups = wm8650_groups;
+	data->ngroups = ARRAY_SIZE(wm8650_groups);
+
+	return wmt_pinctrl_probe(pdev, data);
+}
+
+static int wm8650_pinctrl_remove(struct platform_device *pdev)
+{
+	return wmt_pinctrl_remove(pdev);
+}
+
+static struct of_device_id wmt_pinctrl_of_match[] = {
+	{ .compatible = "wm,wm8650-pinctrl" },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver wmt_pinctrl_driver = {
+	.probe	= wm8650_pinctrl_probe,
+	.remove	= wm8650_pinctrl_remove,
+	.driver = {
+		.name	= "pinctrl-wm8650",
+		.owner	= THIS_MODULE,
+		.of_match_table	= wmt_pinctrl_of_match,
+	},
+};
+
+module_platform_driver(wmt_pinctrl_driver);
+
+MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
+MODULE_DESCRIPTION("Wondermedia WM8650 Pincontrol driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, wmt_pinctrl_of_match);
diff --git a/drivers/pinctrl/vt8500/pinctrl-wm8750.c b/drivers/pinctrl/vt8500/pinctrl-wm8750.c
new file mode 100644
index 0000000..b964cc5
--- /dev/null
+++ b/drivers/pinctrl/vt8500/pinctrl-wm8750.c
@@ -0,0 +1,409 @@
+/*
+ * Pinctrl data for Wondermedia WM8750 SoC
+ *
+ * Copyright (c) 2013 Tony Prisk <linux@prisktech.co.nz>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "pinctrl-wmt.h"
+
+/*
+ * Describe the register offsets within the GPIO memory space
+ * The dedicated external GPIO's should always be listed in bank 0
+ * so they are exported in the 0..31 range which is what users
+ * expect.
+ *
+ * Do not reorder these banks as it will change the pin numbering
+ */
+static const struct wmt_pinctrl_bank_registers wm8750_banks[] = {
+	WMT_PINCTRL_BANK(0x40, 0x80, 0xC0, 0x00, 0x480, 0x4C0),	/* 0 */
+	WMT_PINCTRL_BANK(0x44, 0x84, 0xC4, 0x04, 0x484, 0x4C4),	/* 1 */
+	WMT_PINCTRL_BANK(0x48, 0x88, 0xC8, 0x08, 0x488, 0x4C8),	/* 2 */
+	WMT_PINCTRL_BANK(0x4C, 0x8C, 0xCC, 0x0C, 0x48C, 0x4CC),	/* 3 */
+	WMT_PINCTRL_BANK(0x50, 0x90, 0xD0, 0x10, 0x490, 0x4D0),	/* 4 */
+	WMT_PINCTRL_BANK(0x54, 0x94, 0xD4, 0x14, 0x494, 0x4D4),	/* 5 */
+	WMT_PINCTRL_BANK(0x58, 0x98, 0xD8, 0x18, 0x498, 0x4D8),	/* 6 */
+	WMT_PINCTRL_BANK(0x5C, 0x9C, 0xDC, 0x1C, 0x49C, 0x4DC),	/* 7 */
+	WMT_PINCTRL_BANK(0x60, 0xA0, 0xE0, 0x20, 0x4A0, 0x4E0),	/* 8 */
+	WMT_PINCTRL_BANK(0x70, 0xB0, 0xF0, 0x30, 0x4B0, 0x4F0),	/* 9 */
+	WMT_PINCTRL_BANK(0x7C, 0xBC, 0xDC, 0x3C, 0x4BC, 0x4FC),	/* 10 */
+};
+
+/* Please keep sorted by bank/bit */
+#define WMT_PIN_EXTGPIO0	WMT_PIN(0, 0)
+#define WMT_PIN_EXTGPIO1	WMT_PIN(0, 1)
+#define WMT_PIN_EXTGPIO2	WMT_PIN(0, 2)
+#define WMT_PIN_EXTGPIO3	WMT_PIN(0, 3)
+#define WMT_PIN_EXTGPIO4	WMT_PIN(0, 4)
+#define WMT_PIN_EXTGPIO5	WMT_PIN(0, 5)
+#define WMT_PIN_EXTGPIO6	WMT_PIN(0, 6)
+#define WMT_PIN_EXTGPIO7	WMT_PIN(0, 7)
+#define WMT_PIN_WAKEUP0		WMT_PIN(0, 16)
+#define WMT_PIN_WAKEUP1		WMT_PIN(0, 16)
+#define WMT_PIN_SD0CD		WMT_PIN(0, 28)
+#define WMT_PIN_VDOUT0		WMT_PIN(1, 0)
+#define WMT_PIN_VDOUT1		WMT_PIN(1, 1)
+#define WMT_PIN_VDOUT2		WMT_PIN(1, 2)
+#define WMT_PIN_VDOUT3		WMT_PIN(1, 3)
+#define WMT_PIN_VDOUT4		WMT_PIN(1, 4)
+#define WMT_PIN_VDOUT5		WMT_PIN(1, 5)
+#define WMT_PIN_VDOUT6		WMT_PIN(1, 6)
+#define WMT_PIN_VDOUT7		WMT_PIN(1, 7)
+#define WMT_PIN_VDOUT8		WMT_PIN(1, 8)
+#define WMT_PIN_VDOUT9		WMT_PIN(1, 9)
+#define WMT_PIN_VDOUT10		WMT_PIN(1, 10)
+#define WMT_PIN_VDOUT11		WMT_PIN(1, 11)
+#define WMT_PIN_VDOUT12		WMT_PIN(1, 12)
+#define WMT_PIN_VDOUT13		WMT_PIN(1, 13)
+#define WMT_PIN_VDOUT14		WMT_PIN(1, 14)
+#define WMT_PIN_VDOUT15		WMT_PIN(1, 15)
+#define WMT_PIN_VDOUT16		WMT_PIN(1, 16)
+#define WMT_PIN_VDOUT17		WMT_PIN(1, 17)
+#define WMT_PIN_VDOUT18		WMT_PIN(1, 18)
+#define WMT_PIN_VDOUT19		WMT_PIN(1, 19)
+#define WMT_PIN_VDOUT20		WMT_PIN(1, 20)
+#define WMT_PIN_VDOUT21		WMT_PIN(1, 21)
+#define WMT_PIN_VDOUT22		WMT_PIN(1, 22)
+#define WMT_PIN_VDOUT23		WMT_PIN(1, 23)
+#define WMT_PIN_VDIN0		WMT_PIN(2, 0)
+#define WMT_PIN_VDIN1		WMT_PIN(2, 1)
+#define WMT_PIN_VDIN2		WMT_PIN(2, 2)
+#define WMT_PIN_VDIN3		WMT_PIN(2, 3)
+#define WMT_PIN_VDIN4		WMT_PIN(2, 4)
+#define WMT_PIN_VDIN5		WMT_PIN(2, 5)
+#define WMT_PIN_VDIN6		WMT_PIN(2, 6)
+#define WMT_PIN_VDIN7		WMT_PIN(2, 7)
+#define WMT_PIN_SPI0_MOSI	WMT_PIN(2, 24)
+#define WMT_PIN_SPI0_MISO	WMT_PIN(2, 25)
+#define WMT_PIN_SPI0_SS		WMT_PIN(2, 26)
+#define WMT_PIN_SPI0_CLK	WMT_PIN(2, 27)
+#define WMT_PIN_SPI0_SSB	WMT_PIN(2, 28)
+#define WMT_PIN_SD0CLK		WMT_PIN(3, 17)
+#define WMT_PIN_SD0CMD		WMT_PIN(3, 18)
+#define WMT_PIN_SD0WP		WMT_PIN(3, 19)
+#define WMT_PIN_SD0DATA0	WMT_PIN(3, 20)
+#define WMT_PIN_SD0DATA1	WMT_PIN(3, 21)
+#define WMT_PIN_SD0DATA2	WMT_PIN(3, 22)
+#define WMT_PIN_SD0DATA3	WMT_PIN(3, 23)
+#define WMT_PIN_SD1DATA0	WMT_PIN(3, 24)
+#define WMT_PIN_SD1DATA1	WMT_PIN(3, 25)
+#define WMT_PIN_SD1DATA2	WMT_PIN(3, 26)
+#define WMT_PIN_SD1DATA3	WMT_PIN(3, 27)
+#define WMT_PIN_SD1DATA4	WMT_PIN(3, 28)
+#define WMT_PIN_SD1DATA5	WMT_PIN(3, 29)
+#define WMT_PIN_SD1DATA6	WMT_PIN(3, 30)
+#define WMT_PIN_SD1DATA7	WMT_PIN(3, 31)
+#define WMT_PIN_I2C0_SCL	WMT_PIN(5, 8)
+#define WMT_PIN_I2C0_SDA	WMT_PIN(5, 9)
+#define WMT_PIN_I2C1_SCL	WMT_PIN(5, 10)
+#define WMT_PIN_I2C1_SDA	WMT_PIN(5, 11)
+#define WMT_PIN_I2C2_SCL	WMT_PIN(5, 12)
+#define WMT_PIN_I2C2_SDA	WMT_PIN(5, 13)
+#define WMT_PIN_UART0_RTS	WMT_PIN(5, 16)
+#define WMT_PIN_UART0_TXD	WMT_PIN(5, 17)
+#define WMT_PIN_UART0_CTS	WMT_PIN(5, 18)
+#define WMT_PIN_UART0_RXD	WMT_PIN(5, 19)
+#define WMT_PIN_UART1_RTS	WMT_PIN(5, 20)
+#define WMT_PIN_UART1_TXD	WMT_PIN(5, 21)
+#define WMT_PIN_UART1_CTS	WMT_PIN(5, 22)
+#define WMT_PIN_UART1_RXD	WMT_PIN(5, 23)
+#define WMT_PIN_UART2_RTS	WMT_PIN(5, 24)
+#define WMT_PIN_UART2_TXD	WMT_PIN(5, 25)
+#define WMT_PIN_UART2_CTS	WMT_PIN(5, 26)
+#define WMT_PIN_UART2_RXD	WMT_PIN(5, 27)
+#define WMT_PIN_UART3_RTS	WMT_PIN(5, 28)
+#define WMT_PIN_UART3_TXD	WMT_PIN(5, 29)
+#define WMT_PIN_UART3_CTS	WMT_PIN(5, 30)
+#define WMT_PIN_UART3_RXD	WMT_PIN(5, 31)
+#define WMT_PIN_SD2CD		WMT_PIN(6, 0)
+#define WMT_PIN_SD2DATA3	WMT_PIN(6, 1)
+#define WMT_PIN_SD2DATA0	WMT_PIN(6, 2)
+#define WMT_PIN_SD2WP		WMT_PIN(6, 3)
+#define WMT_PIN_SD2DATA1	WMT_PIN(6, 4)
+#define WMT_PIN_SD2DATA2	WMT_PIN(6, 5)
+#define WMT_PIN_SD2CMD		WMT_PIN(6, 6)
+#define WMT_PIN_SD2CLK		WMT_PIN(6, 7)
+#define WMT_PIN_SD2PWR		WMT_PIN(6, 9)
+#define WMT_PIN_SD1CLK		WMT_PIN(7, 0)
+#define WMT_PIN_SD1CMD		WMT_PIN(7, 1)
+#define WMT_PIN_SD1PWR		WMT_PIN(7, 10)
+#define WMT_PIN_SD1WP		WMT_PIN(7, 11)
+#define WMT_PIN_SD1CD		WMT_PIN(7, 12)
+#define WMT_PIN_SPI0SS3		WMT_PIN(7, 24)
+#define WMT_PIN_SPI0SS2		WMT_PIN(7, 25)
+#define WMT_PIN_PWMOUT1		WMT_PIN(7, 26)
+#define WMT_PIN_PWMOUT0		WMT_PIN(7, 27)
+
+static const struct pinctrl_pin_desc wm8750_pins[] = {
+	PINCTRL_PIN(WMT_PIN_EXTGPIO0, "extgpio0"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO1, "extgpio1"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO2, "extgpio2"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO3, "extgpio3"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO4, "extgpio4"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO5, "extgpio5"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO6, "extgpio6"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO7, "extgpio7"),
+	PINCTRL_PIN(WMT_PIN_WAKEUP0, "wakeup0"),
+	PINCTRL_PIN(WMT_PIN_WAKEUP1, "wakeup1"),
+	PINCTRL_PIN(WMT_PIN_SD0CD, "sd0_cd"),
+	PINCTRL_PIN(WMT_PIN_VDOUT0, "vdout0"),
+	PINCTRL_PIN(WMT_PIN_VDOUT1, "vdout1"),
+	PINCTRL_PIN(WMT_PIN_VDOUT2, "vdout2"),
+	PINCTRL_PIN(WMT_PIN_VDOUT3, "vdout3"),
+	PINCTRL_PIN(WMT_PIN_VDOUT4, "vdout4"),
+	PINCTRL_PIN(WMT_PIN_VDOUT5, "vdout5"),
+	PINCTRL_PIN(WMT_PIN_VDOUT6, "vdout6"),
+	PINCTRL_PIN(WMT_PIN_VDOUT7, "vdout7"),
+	PINCTRL_PIN(WMT_PIN_VDOUT8, "vdout8"),
+	PINCTRL_PIN(WMT_PIN_VDOUT9, "vdout9"),
+	PINCTRL_PIN(WMT_PIN_VDOUT10, "vdout10"),
+	PINCTRL_PIN(WMT_PIN_VDOUT11, "vdout11"),
+	PINCTRL_PIN(WMT_PIN_VDOUT12, "vdout12"),
+	PINCTRL_PIN(WMT_PIN_VDOUT13, "vdout13"),
+	PINCTRL_PIN(WMT_PIN_VDOUT14, "vdout14"),
+	PINCTRL_PIN(WMT_PIN_VDOUT15, "vdout15"),
+	PINCTRL_PIN(WMT_PIN_VDOUT16, "vdout16"),
+	PINCTRL_PIN(WMT_PIN_VDOUT17, "vdout17"),
+	PINCTRL_PIN(WMT_PIN_VDOUT18, "vdout18"),
+	PINCTRL_PIN(WMT_PIN_VDOUT19, "vdout19"),
+	PINCTRL_PIN(WMT_PIN_VDOUT20, "vdout20"),
+	PINCTRL_PIN(WMT_PIN_VDOUT21, "vdout21"),
+	PINCTRL_PIN(WMT_PIN_VDOUT22, "vdout22"),
+	PINCTRL_PIN(WMT_PIN_VDOUT23, "vdout23"),
+	PINCTRL_PIN(WMT_PIN_VDIN0, "vdin0"),
+	PINCTRL_PIN(WMT_PIN_VDIN1, "vdin1"),
+	PINCTRL_PIN(WMT_PIN_VDIN2, "vdin2"),
+	PINCTRL_PIN(WMT_PIN_VDIN3, "vdin3"),
+	PINCTRL_PIN(WMT_PIN_VDIN4, "vdin4"),
+	PINCTRL_PIN(WMT_PIN_VDIN5, "vdin5"),
+	PINCTRL_PIN(WMT_PIN_VDIN6, "vdin6"),
+	PINCTRL_PIN(WMT_PIN_VDIN7, "vdin7"),
+	PINCTRL_PIN(WMT_PIN_SPI0_MOSI, "spi0_mosi"),
+	PINCTRL_PIN(WMT_PIN_SPI0_MISO, "spi0_miso"),
+	PINCTRL_PIN(WMT_PIN_SPI0_SS, "spi0_ss"),
+	PINCTRL_PIN(WMT_PIN_SPI0_CLK, "spi0_clk"),
+	PINCTRL_PIN(WMT_PIN_SPI0_SSB, "spi0_ssb"),
+	PINCTRL_PIN(WMT_PIN_SD0CLK, "sd0_clk"),
+	PINCTRL_PIN(WMT_PIN_SD0CMD, "sd0_cmd"),
+	PINCTRL_PIN(WMT_PIN_SD0WP, "sd0_wp"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA0, "sd0_data0"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA1, "sd0_data1"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA2, "sd0_data2"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA3, "sd0_data3"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA0, "sd1_data0"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA1, "sd1_data1"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA2, "sd1_data2"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA3, "sd1_data3"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA4, "sd1_data4"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA5, "sd1_data5"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA6, "sd1_data6"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA7, "sd1_data7"),
+	PINCTRL_PIN(WMT_PIN_I2C0_SCL, "i2c0_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C0_SDA, "i2c0_sda"),
+	PINCTRL_PIN(WMT_PIN_I2C1_SCL, "i2c1_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C1_SDA, "i2c1_sda"),
+	PINCTRL_PIN(WMT_PIN_I2C2_SCL, "i2c2_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C2_SDA, "i2c2_sda"),
+	PINCTRL_PIN(WMT_PIN_UART0_RTS, "uart0_rts"),
+	PINCTRL_PIN(WMT_PIN_UART0_TXD, "uart0_txd"),
+	PINCTRL_PIN(WMT_PIN_UART0_CTS, "uart0_cts"),
+	PINCTRL_PIN(WMT_PIN_UART0_RXD, "uart0_rxd"),
+	PINCTRL_PIN(WMT_PIN_UART1_RTS, "uart1_rts"),
+	PINCTRL_PIN(WMT_PIN_UART1_TXD, "uart1_txd"),
+	PINCTRL_PIN(WMT_PIN_UART1_CTS, "uart1_cts"),
+	PINCTRL_PIN(WMT_PIN_UART1_RXD, "uart1_rxd"),
+	PINCTRL_PIN(WMT_PIN_UART2_RTS, "uart2_rts"),
+	PINCTRL_PIN(WMT_PIN_UART2_TXD, "uart2_txd"),
+	PINCTRL_PIN(WMT_PIN_UART2_CTS, "uart2_cts"),
+	PINCTRL_PIN(WMT_PIN_UART2_RXD, "uart2_rxd"),
+	PINCTRL_PIN(WMT_PIN_UART3_RTS, "uart3_rts"),
+	PINCTRL_PIN(WMT_PIN_UART3_TXD, "uart3_txd"),
+	PINCTRL_PIN(WMT_PIN_UART3_CTS, "uart3_cts"),
+	PINCTRL_PIN(WMT_PIN_UART3_RXD, "uart3_rxd"),
+	PINCTRL_PIN(WMT_PIN_SD2CD, "sd2_cd"),
+	PINCTRL_PIN(WMT_PIN_SD2DATA3, "sd2_data3"),
+	PINCTRL_PIN(WMT_PIN_SD2DATA0, "sd2_data0"),
+	PINCTRL_PIN(WMT_PIN_SD2WP, "sd2_wp"),
+	PINCTRL_PIN(WMT_PIN_SD2DATA1, "sd2_data1"),
+	PINCTRL_PIN(WMT_PIN_SD2DATA2, "sd2_data2"),
+	PINCTRL_PIN(WMT_PIN_SD2CMD, "sd2_cmd"),
+	PINCTRL_PIN(WMT_PIN_SD2CLK, "sd2_clk"),
+	PINCTRL_PIN(WMT_PIN_SD2PWR, "sd2_pwr"),
+	PINCTRL_PIN(WMT_PIN_SD1CLK, "sd1_clk"),
+	PINCTRL_PIN(WMT_PIN_SD1CMD, "sd1_cmd"),
+	PINCTRL_PIN(WMT_PIN_SD1PWR, "sd1_pwr"),
+	PINCTRL_PIN(WMT_PIN_SD1WP, "sd1_wp"),
+	PINCTRL_PIN(WMT_PIN_SD1CD, "sd1_cd"),
+	PINCTRL_PIN(WMT_PIN_SPI0SS3, "spi0_ss3"),
+	PINCTRL_PIN(WMT_PIN_SPI0SS2, "spi0_ss2"),
+	PINCTRL_PIN(WMT_PIN_PWMOUT1, "pwmout1"),
+	PINCTRL_PIN(WMT_PIN_PWMOUT0, "pwmout0"),
+};
+
+/* Order of these names must match the above list */
+static const char * const wm8750_groups[] = {
+	"extgpio0",
+	"extgpio1",
+	"extgpio2",
+	"extgpio3",
+	"extgpio4",
+	"extgpio5",
+	"extgpio6",
+	"extgpio7",
+	"wakeup0",
+	"wakeup1",
+	"sd0_cd",
+	"vdout0",
+	"vdout1",
+	"vdout2",
+	"vdout3",
+	"vdout4",
+	"vdout5",
+	"vdout6",
+	"vdout7",
+	"vdout8",
+	"vdout9",
+	"vdout10",
+	"vdout11",
+	"vdout12",
+	"vdout13",
+	"vdout14",
+	"vdout15",
+	"vdout16",
+	"vdout17",
+	"vdout18",
+	"vdout19",
+	"vdout20",
+	"vdout21",
+	"vdout22",
+	"vdout23",
+	"vdin0",
+	"vdin1",
+	"vdin2",
+	"vdin3",
+	"vdin4",
+	"vdin5",
+	"vdin6",
+	"vdin7",
+	"spi0_mosi",
+	"spi0_miso",
+	"spi0_ss",
+	"spi0_clk",
+	"spi0_ssb",
+	"sd0_clk",
+	"sd0_cmd",
+	"sd0_wp",
+	"sd0_data0",
+	"sd0_data1",
+	"sd0_data2",
+	"sd0_data3",
+	"sd1_data0",
+	"sd1_data1",
+	"sd1_data2",
+	"sd1_data3",
+	"sd1_data4",
+	"sd1_data5",
+	"sd1_data6",
+	"sd1_data7",
+	"i2c0_scl",
+	"i2c0_sda",
+	"i2c1_scl",
+	"i2c1_sda",
+	"i2c2_scl",
+	"i2c2_sda",
+	"uart0_rts",
+	"uart0_txd",
+	"uart0_cts",
+	"uart0_rxd",
+	"uart1_rts",
+	"uart1_txd",
+	"uart1_cts",
+	"uart1_rxd",
+	"uart2_rts",
+	"uart2_txd",
+	"uart2_cts",
+	"uart2_rxd",
+	"uart3_rts",
+	"uart3_txd",
+	"uart3_cts",
+	"uart3_rxd",
+	"sd2_cd",
+	"sd2_data3",
+	"sd2_data0",
+	"sd2_wp",
+	"sd2_data1",
+	"sd2_data2",
+	"sd2_cmd",
+	"sd2_clk",
+	"sd2_pwr",
+	"sd1_clk",
+	"sd1_cmd",
+	"sd1_pwr",
+	"sd1_wp",
+	"sd1_cd",
+	"spi0_ss3",
+	"spi0_ss2",
+	"pwmout1",
+	"pwmout0",
+};
+
+static int wm8750_pinctrl_probe(struct platform_device *pdev)
+{
+	struct wmt_pinctrl_data *data;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "failed to allocate data\n");
+		return -ENOMEM;
+	}
+
+	data->banks = wm8750_banks;
+	data->nbanks = ARRAY_SIZE(wm8750_banks);
+	data->pins = wm8750_pins;
+	data->npins = ARRAY_SIZE(wm8750_pins);
+	data->groups = wm8750_groups;
+	data->ngroups = ARRAY_SIZE(wm8750_groups);
+
+	return wmt_pinctrl_probe(pdev, data);
+}
+
+static int wm8750_pinctrl_remove(struct platform_device *pdev)
+{
+	return wmt_pinctrl_remove(pdev);
+}
+
+static struct of_device_id wmt_pinctrl_of_match[] = {
+	{ .compatible = "wm,wm8750-pinctrl" },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver wmt_pinctrl_driver = {
+	.probe	= wm8750_pinctrl_probe,
+	.remove	= wm8750_pinctrl_remove,
+	.driver = {
+		.name	= "pinctrl-wm8750",
+		.owner	= THIS_MODULE,
+		.of_match_table	= wmt_pinctrl_of_match,
+	},
+};
+
+module_platform_driver(wmt_pinctrl_driver);
+
+MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
+MODULE_DESCRIPTION("Wondermedia WM8750 Pincontrol driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, wmt_pinctrl_of_match);
diff --git a/drivers/pinctrl/vt8500/pinctrl-wm8850.c b/drivers/pinctrl/vt8500/pinctrl-wm8850.c
new file mode 100644
index 0000000..ecadce9c
--- /dev/null
+++ b/drivers/pinctrl/vt8500/pinctrl-wm8850.c
@@ -0,0 +1,388 @@
+/*
+ * Pinctrl data for Wondermedia WM8850 SoC
+ *
+ * Copyright (c) 2013 Tony Prisk <linux@prisktech.co.nz>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "pinctrl-wmt.h"
+
+/*
+ * Describe the register offsets within the GPIO memory space
+ * The dedicated external GPIO's should always be listed in bank 0
+ * so they are exported in the 0..31 range which is what users
+ * expect.
+ *
+ * Do not reorder these banks as it will change the pin numbering
+ */
+static const struct wmt_pinctrl_bank_registers wm8850_banks[] = {
+	WMT_PINCTRL_BANK(0x40, 0x80, 0xC0, 0x00, 0x480, 0x4C0),		/* 0 */
+	WMT_PINCTRL_BANK(0x44, 0x84, 0xC4, 0x04, 0x484, 0x4C4),		/* 1 */
+	WMT_PINCTRL_BANK(0x48, 0x88, 0xC8, 0x08, 0x488, 0x4C8),		/* 2 */
+	WMT_PINCTRL_BANK(0x4C, 0x8C, 0xCC, 0x0C, 0x48C, 0x4CC),		/* 3 */
+	WMT_PINCTRL_BANK(0x50, 0x90, 0xD0, 0x10, 0x490, 0x4D0),		/* 4 */
+	WMT_PINCTRL_BANK(0x54, 0x94, 0xD4, 0x14, 0x494, 0x4D4),		/* 5 */
+	WMT_PINCTRL_BANK(0x58, 0x98, 0xD8, 0x18, 0x498, 0x4D8),		/* 6 */
+	WMT_PINCTRL_BANK(0x5C, 0x9C, 0xDC, 0x1C, 0x49C, 0x4DC),		/* 7 */
+	WMT_PINCTRL_BANK(0x60, 0xA0, 0xE0, 0x20, 0x4A0, 0x4E0),		/* 8 */
+	WMT_PINCTRL_BANK(0x70, 0xB0, 0xF0, 0x30, 0x4B0, 0x4F0),		/* 9 */
+	WMT_PINCTRL_BANK(0x7C, 0xBC, 0xDC, 0x3C, 0x4BC, 0x4FC),		/* 10 */
+};
+
+/* Please keep sorted by bank/bit */
+#define WMT_PIN_EXTGPIO0	WMT_PIN(0, 0)
+#define WMT_PIN_EXTGPIO1	WMT_PIN(0, 1)
+#define WMT_PIN_EXTGPIO2	WMT_PIN(0, 2)
+#define WMT_PIN_EXTGPIO3	WMT_PIN(0, 3)
+#define WMT_PIN_EXTGPIO4	WMT_PIN(0, 4)
+#define WMT_PIN_EXTGPIO5	WMT_PIN(0, 5)
+#define WMT_PIN_EXTGPIO6	WMT_PIN(0, 6)
+#define WMT_PIN_EXTGPIO7	WMT_PIN(0, 7)
+#define WMT_PIN_WAKEUP0		WMT_PIN(0, 16)
+#define WMT_PIN_WAKEUP1		WMT_PIN(0, 17)
+#define WMT_PIN_WAKEUP2		WMT_PIN(0, 18)
+#define WMT_PIN_WAKEUP3		WMT_PIN(0, 19)
+#define WMT_PIN_SUSGPIO0	WMT_PIN(0, 21)
+#define WMT_PIN_SUSGPIO1	WMT_PIN(0, 22)
+#define WMT_PIN_SD0CD		WMT_PIN(0, 28)
+#define WMT_PIN_VDOUT0		WMT_PIN(1, 0)
+#define WMT_PIN_VDOUT1		WMT_PIN(1, 1)
+#define WMT_PIN_VDOUT2		WMT_PIN(1, 2)
+#define WMT_PIN_VDOUT3		WMT_PIN(1, 3)
+#define WMT_PIN_VDOUT4		WMT_PIN(1, 4)
+#define WMT_PIN_VDOUT5		WMT_PIN(1, 5)
+#define WMT_PIN_VDOUT6		WMT_PIN(1, 6)
+#define WMT_PIN_VDOUT7		WMT_PIN(1, 7)
+#define WMT_PIN_VDOUT8		WMT_PIN(1, 8)
+#define WMT_PIN_VDOUT9		WMT_PIN(1, 9)
+#define WMT_PIN_VDOUT10		WMT_PIN(1, 10)
+#define WMT_PIN_VDOUT11		WMT_PIN(1, 11)
+#define WMT_PIN_VDOUT12		WMT_PIN(1, 12)
+#define WMT_PIN_VDOUT13		WMT_PIN(1, 13)
+#define WMT_PIN_VDOUT14		WMT_PIN(1, 14)
+#define WMT_PIN_VDOUT15		WMT_PIN(1, 15)
+#define WMT_PIN_VDOUT16		WMT_PIN(1, 16)
+#define WMT_PIN_VDOUT17		WMT_PIN(1, 17)
+#define WMT_PIN_VDOUT18		WMT_PIN(1, 18)
+#define WMT_PIN_VDOUT19		WMT_PIN(1, 19)
+#define WMT_PIN_VDOUT20		WMT_PIN(1, 20)
+#define WMT_PIN_VDOUT21		WMT_PIN(1, 21)
+#define WMT_PIN_VDOUT22		WMT_PIN(1, 22)
+#define WMT_PIN_VDOUT23		WMT_PIN(1, 23)
+#define WMT_PIN_VDIN0		WMT_PIN(2, 0)
+#define WMT_PIN_VDIN1		WMT_PIN(2, 1)
+#define WMT_PIN_VDIN2		WMT_PIN(2, 2)
+#define WMT_PIN_VDIN3		WMT_PIN(2, 3)
+#define WMT_PIN_VDIN4		WMT_PIN(2, 4)
+#define WMT_PIN_VDIN5		WMT_PIN(2, 5)
+#define WMT_PIN_VDIN6		WMT_PIN(2, 6)
+#define WMT_PIN_VDIN7		WMT_PIN(2, 7)
+#define WMT_PIN_SPI0_MOSI	WMT_PIN(2, 24)
+#define WMT_PIN_SPI0_MISO	WMT_PIN(2, 25)
+#define WMT_PIN_SPI0_SS		WMT_PIN(2, 26)
+#define WMT_PIN_SPI0_CLK	WMT_PIN(2, 27)
+#define WMT_PIN_SPI0_SSB	WMT_PIN(2, 28)
+#define WMT_PIN_SD0CLK		WMT_PIN(3, 17)
+#define WMT_PIN_SD0CMD		WMT_PIN(3, 18)
+#define WMT_PIN_SD0WP		WMT_PIN(3, 19)
+#define WMT_PIN_SD0DATA0	WMT_PIN(3, 20)
+#define WMT_PIN_SD0DATA1	WMT_PIN(3, 21)
+#define WMT_PIN_SD0DATA2	WMT_PIN(3, 22)
+#define WMT_PIN_SD0DATA3	WMT_PIN(3, 23)
+#define WMT_PIN_SD1DATA0	WMT_PIN(3, 24)
+#define WMT_PIN_SD1DATA1	WMT_PIN(3, 25)
+#define WMT_PIN_SD1DATA2	WMT_PIN(3, 26)
+#define WMT_PIN_SD1DATA3	WMT_PIN(3, 27)
+#define WMT_PIN_SD1DATA4	WMT_PIN(3, 28)
+#define WMT_PIN_SD1DATA5	WMT_PIN(3, 29)
+#define WMT_PIN_SD1DATA6	WMT_PIN(3, 30)
+#define WMT_PIN_SD1DATA7	WMT_PIN(3, 31)
+#define WMT_PIN_I2C0_SCL	WMT_PIN(5, 8)
+#define WMT_PIN_I2C0_SDA	WMT_PIN(5, 9)
+#define WMT_PIN_I2C1_SCL	WMT_PIN(5, 10)
+#define WMT_PIN_I2C1_SDA	WMT_PIN(5, 11)
+#define WMT_PIN_I2C2_SCL	WMT_PIN(5, 12)
+#define WMT_PIN_I2C2_SDA	WMT_PIN(5, 13)
+#define WMT_PIN_UART0_RTS	WMT_PIN(5, 16)
+#define WMT_PIN_UART0_TXD	WMT_PIN(5, 17)
+#define WMT_PIN_UART0_CTS	WMT_PIN(5, 18)
+#define WMT_PIN_UART0_RXD	WMT_PIN(5, 19)
+#define WMT_PIN_UART1_RTS	WMT_PIN(5, 20)
+#define WMT_PIN_UART1_TXD	WMT_PIN(5, 21)
+#define WMT_PIN_UART1_CTS	WMT_PIN(5, 22)
+#define WMT_PIN_UART1_RXD	WMT_PIN(5, 23)
+#define WMT_PIN_UART2_RTS	WMT_PIN(5, 24)
+#define WMT_PIN_UART2_TXD	WMT_PIN(5, 25)
+#define WMT_PIN_UART2_CTS	WMT_PIN(5, 26)
+#define WMT_PIN_UART2_RXD	WMT_PIN(5, 27)
+#define WMT_PIN_SD2WP		WMT_PIN(6, 3)
+#define WMT_PIN_SD2CMD		WMT_PIN(6, 6)
+#define WMT_PIN_SD2CLK		WMT_PIN(6, 7)
+#define WMT_PIN_SD2PWR		WMT_PIN(6, 9)
+#define WMT_PIN_SD1CLK		WMT_PIN(7, 0)
+#define WMT_PIN_SD1CMD		WMT_PIN(7, 1)
+#define WMT_PIN_SD1PWR		WMT_PIN(7, 10)
+#define WMT_PIN_SD1WP		WMT_PIN(7, 11)
+#define WMT_PIN_SD1CD		WMT_PIN(7, 12)
+#define WMT_PIN_PWMOUT1		WMT_PIN(7, 26)
+#define WMT_PIN_PWMOUT0		WMT_PIN(7, 27)
+
+static const struct pinctrl_pin_desc wm8850_pins[] = {
+	PINCTRL_PIN(WMT_PIN_EXTGPIO0, "extgpio0"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO1, "extgpio1"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO2, "extgpio2"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO3, "extgpio3"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO4, "extgpio4"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO5, "extgpio5"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO6, "extgpio6"),
+	PINCTRL_PIN(WMT_PIN_EXTGPIO7, "extgpio7"),
+	PINCTRL_PIN(WMT_PIN_WAKEUP0, "wakeup0"),
+	PINCTRL_PIN(WMT_PIN_WAKEUP1, "wakeup1"),
+	PINCTRL_PIN(WMT_PIN_WAKEUP2, "wakeup2"),
+	PINCTRL_PIN(WMT_PIN_WAKEUP3, "wakeup3"),
+	PINCTRL_PIN(WMT_PIN_SUSGPIO0, "susgpio0"),
+	PINCTRL_PIN(WMT_PIN_SUSGPIO1, "susgpio1"),
+	PINCTRL_PIN(WMT_PIN_SD0CD, "sd0_cd"),
+	PINCTRL_PIN(WMT_PIN_VDOUT0, "vdout0"),
+	PINCTRL_PIN(WMT_PIN_VDOUT1, "vdout1"),
+	PINCTRL_PIN(WMT_PIN_VDOUT2, "vdout2"),
+	PINCTRL_PIN(WMT_PIN_VDOUT3, "vdout3"),
+	PINCTRL_PIN(WMT_PIN_VDOUT4, "vdout4"),
+	PINCTRL_PIN(WMT_PIN_VDOUT5, "vdout5"),
+	PINCTRL_PIN(WMT_PIN_VDOUT6, "vdout6"),
+	PINCTRL_PIN(WMT_PIN_VDOUT7, "vdout7"),
+	PINCTRL_PIN(WMT_PIN_VDOUT8, "vdout8"),
+	PINCTRL_PIN(WMT_PIN_VDOUT9, "vdout9"),
+	PINCTRL_PIN(WMT_PIN_VDOUT10, "vdout10"),
+	PINCTRL_PIN(WMT_PIN_VDOUT11, "vdout11"),
+	PINCTRL_PIN(WMT_PIN_VDOUT12, "vdout12"),
+	PINCTRL_PIN(WMT_PIN_VDOUT13, "vdout13"),
+	PINCTRL_PIN(WMT_PIN_VDOUT14, "vdout14"),
+	PINCTRL_PIN(WMT_PIN_VDOUT15, "vdout15"),
+	PINCTRL_PIN(WMT_PIN_VDOUT16, "vdout16"),
+	PINCTRL_PIN(WMT_PIN_VDOUT17, "vdout17"),
+	PINCTRL_PIN(WMT_PIN_VDOUT18, "vdout18"),
+	PINCTRL_PIN(WMT_PIN_VDOUT19, "vdout19"),
+	PINCTRL_PIN(WMT_PIN_VDOUT20, "vdout20"),
+	PINCTRL_PIN(WMT_PIN_VDOUT21, "vdout21"),
+	PINCTRL_PIN(WMT_PIN_VDOUT22, "vdout22"),
+	PINCTRL_PIN(WMT_PIN_VDOUT23, "vdout23"),
+	PINCTRL_PIN(WMT_PIN_VDIN0, "vdin0"),
+	PINCTRL_PIN(WMT_PIN_VDIN1, "vdin1"),
+	PINCTRL_PIN(WMT_PIN_VDIN2, "vdin2"),
+	PINCTRL_PIN(WMT_PIN_VDIN3, "vdin3"),
+	PINCTRL_PIN(WMT_PIN_VDIN4, "vdin4"),
+	PINCTRL_PIN(WMT_PIN_VDIN5, "vdin5"),
+	PINCTRL_PIN(WMT_PIN_VDIN6, "vdin6"),
+	PINCTRL_PIN(WMT_PIN_VDIN7, "vdin7"),
+	PINCTRL_PIN(WMT_PIN_SPI0_MOSI, "spi0_mosi"),
+	PINCTRL_PIN(WMT_PIN_SPI0_MISO, "spi0_miso"),
+	PINCTRL_PIN(WMT_PIN_SPI0_SS, "spi0_ss"),
+	PINCTRL_PIN(WMT_PIN_SPI0_CLK, "spi0_clk"),
+	PINCTRL_PIN(WMT_PIN_SPI0_SSB, "spi0_ssb"),
+	PINCTRL_PIN(WMT_PIN_SD0CLK, "sd0_clk"),
+	PINCTRL_PIN(WMT_PIN_SD0CMD, "sd0_cmd"),
+	PINCTRL_PIN(WMT_PIN_SD0WP, "sd0_wp"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA0, "sd0_data0"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA1, "sd0_data1"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA2, "sd0_data2"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA3, "sd0_data3"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA0, "sd1_data0"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA1, "sd1_data1"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA2, "sd1_data2"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA3, "sd1_data3"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA4, "sd1_data4"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA5, "sd1_data5"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA6, "sd1_data6"),
+	PINCTRL_PIN(WMT_PIN_SD1DATA7, "sd1_data7"),
+	PINCTRL_PIN(WMT_PIN_I2C0_SCL, "i2c0_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C0_SDA, "i2c0_sda"),
+	PINCTRL_PIN(WMT_PIN_I2C1_SCL, "i2c1_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C1_SDA, "i2c1_sda"),
+	PINCTRL_PIN(WMT_PIN_I2C2_SCL, "i2c2_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C2_SDA, "i2c2_sda"),
+	PINCTRL_PIN(WMT_PIN_UART0_RTS, "uart0_rts"),
+	PINCTRL_PIN(WMT_PIN_UART0_TXD, "uart0_txd"),
+	PINCTRL_PIN(WMT_PIN_UART0_CTS, "uart0_cts"),
+	PINCTRL_PIN(WMT_PIN_UART0_RXD, "uart0_rxd"),
+	PINCTRL_PIN(WMT_PIN_UART1_RTS, "uart1_rts"),
+	PINCTRL_PIN(WMT_PIN_UART1_TXD, "uart1_txd"),
+	PINCTRL_PIN(WMT_PIN_UART1_CTS, "uart1_cts"),
+	PINCTRL_PIN(WMT_PIN_UART1_RXD, "uart1_rxd"),
+	PINCTRL_PIN(WMT_PIN_UART2_RTS, "uart2_rts"),
+	PINCTRL_PIN(WMT_PIN_UART2_TXD, "uart2_txd"),
+	PINCTRL_PIN(WMT_PIN_UART2_CTS, "uart2_cts"),
+	PINCTRL_PIN(WMT_PIN_UART2_RXD, "uart2_rxd"),
+	PINCTRL_PIN(WMT_PIN_SD2WP, "sd2_wp"),
+	PINCTRL_PIN(WMT_PIN_SD2CMD, "sd2_cmd"),
+	PINCTRL_PIN(WMT_PIN_SD2CLK, "sd2_clk"),
+	PINCTRL_PIN(WMT_PIN_SD2PWR, "sd2_pwr"),
+	PINCTRL_PIN(WMT_PIN_SD1CLK, "sd1_clk"),
+	PINCTRL_PIN(WMT_PIN_SD1CMD, "sd1_cmd"),
+	PINCTRL_PIN(WMT_PIN_SD1PWR, "sd1_pwr"),
+	PINCTRL_PIN(WMT_PIN_SD1WP, "sd1_wp"),
+	PINCTRL_PIN(WMT_PIN_SD1CD, "sd1_cd"),
+	PINCTRL_PIN(WMT_PIN_PWMOUT1, "pwmout1"),
+	PINCTRL_PIN(WMT_PIN_PWMOUT0, "pwmout0"),
+};
+
+/* Order of these names must match the above list */
+static const char * const wm8850_groups[] = {
+	"extgpio0",
+	"extgpio1",
+	"extgpio2",
+	"extgpio3",
+	"extgpio4",
+	"extgpio5",
+	"extgpio6",
+	"extgpio7",
+	"wakeup0",
+	"wakeup1",
+	"wakeup2",
+	"wakeup3",
+	"susgpio0",
+	"susgpio1",
+	"sd0_cd",
+	"vdout0",
+	"vdout1",
+	"vdout2",
+	"vdout3",
+	"vdout4",
+	"vdout5",
+	"vdout6",
+	"vdout7",
+	"vdout8",
+	"vdout9",
+	"vdout10",
+	"vdout11",
+	"vdout12",
+	"vdout13",
+	"vdout14",
+	"vdout15",
+	"vdout16",
+	"vdout17",
+	"vdout18",
+	"vdout19",
+	"vdout20",
+	"vdout21",
+	"vdout22",
+	"vdout23",
+	"vdin0",
+	"vdin1",
+	"vdin2",
+	"vdin3",
+	"vdin4",
+	"vdin5",
+	"vdin6",
+	"vdin7",
+	"spi0_mosi",
+	"spi0_miso",
+	"spi0_ss",
+	"spi0_clk",
+	"spi0_ssb",
+	"sd0_clk",
+	"sd0_cmd",
+	"sd0_wp",
+	"sd0_data0",
+	"sd0_data1",
+	"sd0_data2",
+	"sd0_data3",
+	"sd1_data0",
+	"sd1_data1",
+	"sd1_data2",
+	"sd1_data3",
+	"sd1_data4",
+	"sd1_data5",
+	"sd1_data6",
+	"sd1_data7",
+	"i2c0_scl",
+	"i2c0_sda",
+	"i2c1_scl",
+	"i2c1_sda",
+	"i2c2_scl",
+	"i2c2_sda",
+	"uart0_rts",
+	"uart0_txd",
+	"uart0_cts",
+	"uart0_rxd",
+	"uart1_rts",
+	"uart1_txd",
+	"uart1_cts",
+	"uart1_rxd",
+	"uart2_rts",
+	"uart2_txd",
+	"uart2_cts",
+	"uart2_rxd",
+	"sd2_wp",
+	"sd2_cmd",
+	"sd2_clk",
+	"sd2_pwr",
+	"sd1_clk",
+	"sd1_cmd",
+	"sd1_pwr",
+	"sd1_wp",
+	"sd1_cd",
+	"pwmout1",
+	"pwmout0",
+};
+
+static int wm8850_pinctrl_probe(struct platform_device *pdev)
+{
+	struct wmt_pinctrl_data *data;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "failed to allocate data\n");
+		return -ENOMEM;
+	}
+
+	data->banks = wm8850_banks;
+	data->nbanks = ARRAY_SIZE(wm8850_banks);
+	data->pins = wm8850_pins;
+	data->npins = ARRAY_SIZE(wm8850_pins);
+	data->groups = wm8850_groups;
+	data->ngroups = ARRAY_SIZE(wm8850_groups);
+
+	return wmt_pinctrl_probe(pdev, data);
+}
+
+static int wm8850_pinctrl_remove(struct platform_device *pdev)
+{
+	return wmt_pinctrl_remove(pdev);
+}
+
+static struct of_device_id wmt_pinctrl_of_match[] = {
+	{ .compatible = "wm,wm8850-pinctrl" },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver wmt_pinctrl_driver = {
+	.probe	= wm8850_pinctrl_probe,
+	.remove	= wm8850_pinctrl_remove,
+	.driver = {
+		.name	= "pinctrl-wm8850",
+		.owner	= THIS_MODULE,
+		.of_match_table	= wmt_pinctrl_of_match,
+	},
+};
+
+module_platform_driver(wmt_pinctrl_driver);
+
+MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
+MODULE_DESCRIPTION("Wondermedia WM8850 Pincontrol driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, wmt_pinctrl_of_match);
diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
new file mode 100644
index 0000000..9736d27
--- /dev/null
+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
@@ -0,0 +1,620 @@
+/*
+ * Pinctrl driver for the Wondermedia SoC's
+ *
+ * Copyright (c) 2013 Tony Prisk <linux@prisktech.co.nz>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/pinconf-generic.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "pinctrl-wmt.h"
+
+static inline void wmt_setbits(struct wmt_pinctrl_data *data, u32 reg,
+				 u32 mask)
+{
+	u32 val;
+
+	val = readl_relaxed(data->base + reg);
+	val |= mask;
+	writel_relaxed(val, data->base + reg);
+}
+
+static inline void wmt_clearbits(struct wmt_pinctrl_data *data, u32 reg,
+				   u32 mask)
+{
+	u32 val;
+
+	val = readl_relaxed(data->base + reg);
+	val &= ~mask;
+	writel_relaxed(val, data->base + reg);
+}
+
+enum wmt_func_sel {
+	WMT_FSEL_GPIO_IN = 0,
+	WMT_FSEL_GPIO_OUT = 1,
+	WMT_FSEL_ALT = 2,
+	WMT_FSEL_COUNT = 3,
+};
+
+static const char * const wmt_functions[WMT_FSEL_COUNT] = {
+	[WMT_FSEL_GPIO_IN] = "gpio_in",
+	[WMT_FSEL_GPIO_OUT] = "gpio_out",
+	[WMT_FSEL_ALT] = "alt",
+};
+
+static int wmt_pmx_get_functions_count(struct pinctrl_dev *pctldev)
+{
+	return WMT_FSEL_COUNT;
+}
+
+static const char *wmt_pmx_get_function_name(struct pinctrl_dev *pctldev,
+					     unsigned selector)
+{
+	return wmt_functions[selector];
+}
+
+static int wmt_pmx_get_function_groups(struct pinctrl_dev *pctldev,
+				       unsigned selector,
+				       const char * const **groups,
+				       unsigned * const num_groups)
+{
+	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
+
+	/* every pin does every function */
+	*groups = data->groups;
+	*num_groups = data->ngroups;
+
+	return 0;
+}
+
+static int wmt_set_pinmux(struct wmt_pinctrl_data *data, unsigned func,
+			  unsigned pin)
+{
+	u32 bank = WMT_BANK_FROM_PIN(pin);
+	u32 bit = WMT_BIT_FROM_PIN(pin);
+	u32 reg_en = data->banks[bank].reg_en;
+	u32 reg_dir = data->banks[bank].reg_dir;
+
+	if (reg_dir == NO_REG) {
+		dev_err(data->dev, "pin:%d no direction register defined\n",
+			pin);
+		return -EINVAL;
+	}
+
+	/*
+	 * If reg_en == NO_REG, we assume it is a dedicated GPIO and cannot be
+	 * disabled (as on VT8500) and that no alternate function is available.
+	 */
+	switch (func) {
+	case WMT_FSEL_GPIO_IN:
+		if (reg_en != NO_REG)
+			wmt_setbits(data, reg_en, BIT(bit));
+		wmt_clearbits(data, reg_dir, BIT(bit));
+		break;
+	case WMT_FSEL_GPIO_OUT:
+		if (reg_en != NO_REG)
+			wmt_setbits(data, reg_en, BIT(bit));
+		wmt_setbits(data, reg_dir, BIT(bit));
+		break;
+	case WMT_FSEL_ALT:
+		if (reg_en == NO_REG) {
+			dev_err(data->dev, "pin:%d no alt function available\n",
+				pin);
+			return -EINVAL;
+		}
+		wmt_clearbits(data, reg_en, BIT(bit));
+	}
+
+	return 0;
+}
+
+static int wmt_pmx_enable(struct pinctrl_dev *pctldev,
+			  unsigned func_selector,
+			  unsigned group_selector)
+{
+	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
+	u32 pinnum = data->pins[group_selector].number;
+
+	return wmt_set_pinmux(data, func_selector, pinnum);
+}
+
+static void wmt_pmx_disable(struct pinctrl_dev *pctldev,
+			    unsigned func_selector,
+			    unsigned group_selector)
+{
+	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
+	u32 pinnum = data->pins[group_selector].number;
+
+	/* disable by setting GPIO_IN */
+	wmt_set_pinmux(data, WMT_FSEL_GPIO_IN, pinnum);
+}
+
+static void wmt_pmx_gpio_disable_free(struct pinctrl_dev *pctldev,
+				      struct pinctrl_gpio_range *range,
+				      unsigned offset)
+{
+	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
+
+	/* disable by setting GPIO_IN */
+	wmt_set_pinmux(data, WMT_FSEL_GPIO_IN, offset);
+}
+
+static int wmt_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
+				      struct pinctrl_gpio_range *range,
+				      unsigned offset,
+				      bool input)
+{
+	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
+
+	wmt_set_pinmux(data, (input ? WMT_FSEL_GPIO_IN : WMT_FSEL_GPIO_OUT),
+		       offset);
+
+	return 0;
+}
+
+static struct pinmux_ops wmt_pinmux_ops = {
+	.get_functions_count = wmt_pmx_get_functions_count,
+	.get_function_name = wmt_pmx_get_function_name,
+	.get_function_groups = wmt_pmx_get_function_groups,
+	.enable = wmt_pmx_enable,
+	.disable = wmt_pmx_disable,
+	.gpio_disable_free = wmt_pmx_gpio_disable_free,
+	.gpio_set_direction = wmt_pmx_gpio_set_direction,
+};
+
+static int wmt_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
+
+	return data->ngroups;
+}
+
+static const char *wmt_get_group_name(struct pinctrl_dev *pctldev,
+				      unsigned selector)
+{
+	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
+
+	return data->groups[selector];
+}
+
+static int wmt_get_group_pins(struct pinctrl_dev *pctldev,
+			      unsigned selector,
+			      const unsigned **pins,
+			      unsigned *num_pins)
+{
+	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
+
+	*pins = &data->pins[selector].number;
+	*num_pins = 1;
+
+	return 0;
+}
+
+static int wmt_pctl_find_group_by_pin(struct wmt_pinctrl_data *data, u32 pin)
+{
+	int i;
+
+	for (i = 0; i < data->npins; i++) {
+		if (data->pins[i].number == pin)
+			return i;
+	}
+
+	return -EINVAL;
+}
+
+static int wmt_pctl_dt_node_to_map_func(struct wmt_pinctrl_data *data,
+					struct device_node *np,
+					u32 pin, u32 fnum,
+					struct pinctrl_map **maps)
+{
+	int group;
+	struct pinctrl_map *map = *maps;
+
+	if (fnum >= ARRAY_SIZE(wmt_functions)) {
+		dev_err(data->dev, "invalid wm,function %d\n", fnum);
+		return -EINVAL;
+	}
+
+	group = wmt_pctl_find_group_by_pin(data, pin);
+	if (group < 0) {
+		dev_err(data->dev, "unable to match pin %d to group\n", pin);
+		return group;
+	}
+
+	map->type = PIN_MAP_TYPE_MUX_GROUP;
+	map->data.mux.group = data->groups[group];
+	map->data.mux.function = wmt_functions[fnum];
+	(*maps)++;
+
+	return 0;
+}
+
+static int wmt_pctl_dt_node_to_map_pull(struct wmt_pinctrl_data *data,
+					struct device_node *np,
+					u32 pin, u32 pull,
+					struct pinctrl_map **maps)
+{
+	int group;
+	unsigned long *configs;
+	struct pinctrl_map *map = *maps;
+
+	if (pull > 2) {
+		dev_err(data->dev, "invalid wm,pull %d\n", pull);
+		return -EINVAL;
+	}
+
+	group = wmt_pctl_find_group_by_pin(data, pin);
+	if (group < 0) {
+		dev_err(data->dev, "unable to match pin %d to group\n", pin);
+		return group;
+	}
+
+	configs = devm_kzalloc(data->dev, sizeof(*configs), GFP_KERNEL);
+	if (!configs)
+		return -ENOMEM;
+
+	configs[0] = pull;
+
+	map->type = PIN_MAP_TYPE_CONFIGS_PIN;
+	map->data.configs.group_or_pin = data->groups[group];
+	map->data.configs.configs = configs;
+	map->data.configs.num_configs = 1;
+	(*maps)++;
+
+	return 0;
+}
+
+static int wmt_pctl_dt_node_to_map(struct pinctrl_dev *pctldev,
+				   struct device_node *np,
+				   struct pinctrl_map **map,
+				   unsigned *num_maps)
+{
+	struct pinctrl_map *maps, *cur_map;
+	struct property *pins, *funcs, *pulls;
+	u32 pin, func, pull;
+	int num_pins, num_funcs, num_pulls, maps_per_pin;
+	int i, err;
+	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
+
+	pins = of_find_property(np, "wm,pins", NULL);
+	if (!pins) {
+		dev_err(data->dev, "missing wmt,pins property\n");
+		return -EINVAL;
+	}
+
+	funcs = of_find_property(np, "wm,function", NULL);
+	pulls = of_find_property(np, "wm,pull", NULL);
+
+	if (!funcs && !pulls) {
+		dev_err(data->dev, "neither wm,function nor wm,pull specified\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * The following lines calculate how many values are defined for each
+	 * of the properties.
+	 */
+	num_pins = pins->length / sizeof(u32);
+	num_funcs = funcs ? (funcs->length / sizeof(u32)) : 0;
+	num_pulls = pulls ? (pulls->length / sizeof(u32)) : 0;
+
+	if (num_funcs > 1 && num_funcs != num_pins) {
+		dev_err(data->dev, "wm,function must have 1 or %d entries\n",
+			num_pins);
+		return -EINVAL;
+	}
+
+	if (num_pulls > 1 && num_pulls != num_pins) {
+		dev_err(data->dev, "wm,pull must have 1 or %d entries\n",
+			num_pins);
+		return -EINVAL;
+	}
+
+	maps_per_pin = 0;
+	if (num_funcs)
+		maps_per_pin++;
+	if (num_pulls)
+		maps_per_pin++;
+
+	cur_map = maps = devm_kzalloc(data->dev,
+				      num_pins * maps_per_pin * sizeof(*maps),
+				      GFP_KERNEL);
+	if (!maps)
+		return -ENOMEM;
+
+	for (i = 0; i < num_pins; i++) {
+		err = of_property_read_u32_index(np, "wm,pins", i, &pin);
+		if (err)
+			return err;
+
+		if (pin >= (data->nbanks * 32)) {
+			dev_err(data->dev, "invalid wm,pins value\n");
+			return -EINVAL;
+		}
+
+		if (num_funcs) {
+			err = of_property_read_u32_index(np, "wm,function",
+						(num_funcs > 1 ? i : 0), &func);
+			if (err)
+				return err;
+
+			err = wmt_pctl_dt_node_to_map_func(data, np, pin, func,
+							   &cur_map);
+			if (err)
+				return err;
+		}
+
+		if (num_pulls) {
+			err = of_property_read_u32_index(np, "wm,pull",
+						(num_pulls > 1 ? i : 0), &pull);
+			if (err)
+				return err;
+
+			err = wmt_pctl_dt_node_to_map_pull(data, np, pin, pull,
+							   &cur_map);
+			if (err)
+				return err;
+		}
+	}
+	*map = maps;
+	*num_maps = num_pins * maps_per_pin;
+	return 0;
+}
+
+static void wmt_pctl_dt_free_map(struct pinctrl_dev *pctldev,
+				 struct pinctrl_map *maps,
+				 unsigned num_maps)
+{
+	int i;
+
+	for (i = 0; i < num_maps; i++)
+		if (maps[i].type == PIN_MAP_TYPE_CONFIGS_PIN)
+			kfree(maps[i].data.configs.configs);
+
+	kfree(maps);
+}
+
+static struct pinctrl_ops wmt_pctl_ops = {
+	.get_groups_count = wmt_get_groups_count,
+	.get_group_name	= wmt_get_group_name,
+	.get_group_pins	= wmt_get_group_pins,
+	.dt_node_to_map = wmt_pctl_dt_node_to_map,
+	.dt_free_map = wmt_pctl_dt_free_map,
+};
+
+static int wmt_pinconf_get(struct pinctrl_dev *pctldev, unsigned pin,
+			   unsigned long *config)
+{
+	return -ENOTSUPP;
+}
+
+static int wmt_pinconf_set(struct pinctrl_dev *pctldev, unsigned pin,
+			   unsigned long config)
+{
+	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
+	enum pin_config_param param = pinconf_to_config_param(config);
+	u16 arg = pinconf_to_config_argument(config);
+	u32 bank = WMT_BANK_FROM_PIN(pin);
+	u32 bit = WMT_BIT_FROM_PIN(pin);
+	u32 reg_pull_en = data->banks[bank].reg_pull_en;
+	u32 reg_pull_cfg = data->banks[bank].reg_pull_cfg;
+
+	if ((reg_pull_en == NO_REG) || (reg_pull_cfg == NO_REG)) {
+		dev_err(data->dev, "bias functions not supported on pin %d\n",
+			pin);
+		return -EINVAL;
+	}
+
+	if ((param == PIN_CONFIG_BIAS_PULL_DOWN) ||
+	    (param == PIN_CONFIG_BIAS_PULL_UP)) {
+		if (arg == 0)
+			param = PIN_CONFIG_BIAS_DISABLE;
+	}
+
+	switch (param) {
+	case PIN_CONFIG_BIAS_DISABLE:
+		wmt_clearbits(data, reg_pull_en, BIT(bit));
+		break;
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+		wmt_clearbits(data, reg_pull_cfg, BIT(bit));
+		wmt_setbits(data, reg_pull_en, BIT(bit));
+		break;
+	case PIN_CONFIG_BIAS_PULL_UP:
+		wmt_setbits(data, reg_pull_cfg, BIT(bit));
+		wmt_setbits(data, reg_pull_en, BIT(bit));
+		break;
+	default:
+		dev_err(data->dev, "unknown pinconf param\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct pinconf_ops wmt_pinconf_ops = {
+	.pin_config_get = wmt_pinconf_get,
+	.pin_config_set = wmt_pinconf_set,
+};
+
+static struct pinctrl_desc wmt_desc = {
+	.owner = THIS_MODULE,
+	.name = "pinctrl-wmt",
+	.pctlops = &wmt_pctl_ops,
+	.pmxops = &wmt_pinmux_ops,
+	.confops = &wmt_pinconf_ops,
+};
+
+static int wmt_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_request_gpio(chip->base + offset);
+}
+
+static void wmt_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(chip->base + offset);
+}
+
+static int wmt_gpio_get_direction(struct gpio_chip *chip, unsigned offset)
+{
+	struct wmt_pinctrl_data *data = dev_get_drvdata(chip->dev);
+	u32 bank = WMT_BANK_FROM_PIN(offset);
+	u32 bit = WMT_BIT_FROM_PIN(offset);
+	u32 reg_dir = data->banks[bank].reg_dir;
+	u32 val;
+
+	val = readl_relaxed(data->base + reg_dir);
+	if (val & BIT(bit))
+		return GPIOF_DIR_OUT;
+	else
+		return GPIOF_DIR_IN;
+}
+
+static int wmt_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_gpio_direction_input(chip->base + offset);
+}
+
+static int wmt_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+				     int value)
+{
+	return pinctrl_gpio_direction_output(chip->base + offset);
+}
+
+static int wmt_gpio_get_value(struct gpio_chip *chip, unsigned offset)
+{
+	struct wmt_pinctrl_data *data = dev_get_drvdata(chip->dev);
+	u32 bank = WMT_BANK_FROM_PIN(offset);
+	u32 bit = WMT_BIT_FROM_PIN(offset);
+	u32 reg_data_in = data->banks[bank].reg_data_in;
+
+	if (reg_data_in == NO_REG) {
+		dev_err(data->dev, "no data in register defined\n");
+		return -EINVAL;
+	}
+
+	return !!(readl_relaxed(data->base + reg_data_in) & BIT(bit));
+}
+
+static void wmt_gpio_set_value(struct gpio_chip *chip, unsigned offset,
+			       int val)
+{
+	struct wmt_pinctrl_data *data = dev_get_drvdata(chip->dev);
+	u32 bank = WMT_BANK_FROM_PIN(offset);
+	u32 bit = WMT_BIT_FROM_PIN(offset);
+	u32 reg_data_out = data->banks[bank].reg_data_out;
+
+	if (reg_data_out == NO_REG) {
+		dev_err(data->dev, "no data out register defined\n");
+		return;
+	}
+
+	if (val)
+		wmt_setbits(data, reg_data_out, BIT(bit));
+	else
+		wmt_clearbits(data, reg_data_out, BIT(bit));
+}
+
+static struct gpio_chip wmt_gpio_chip = {
+	.label = "gpio-wmt",
+	.owner = THIS_MODULE,
+	.request = wmt_gpio_request,
+	.free = wmt_gpio_free,
+	.get_direction = wmt_gpio_get_direction,
+	.direction_input = wmt_gpio_direction_input,
+	.direction_output = wmt_gpio_direction_output,
+	.get = wmt_gpio_get_value,
+	.set = wmt_gpio_set_value,
+	.can_sleep = 0,
+};
+
+int wmt_pinctrl_probe(struct platform_device *pdev,
+		      struct wmt_pinctrl_data *data)
+{
+	int err;
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	data->base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!data->base) {
+		dev_err(&pdev->dev, "failed to map memory resource\n");
+		return -EBUSY;
+	}
+
+	wmt_desc.pins = data->pins;
+	wmt_desc.npins = data->npins;
+
+	data->gpio_chip = wmt_gpio_chip;
+	data->gpio_chip.dev = &pdev->dev;
+	data->gpio_chip.of_node = pdev->dev.of_node;
+	data->gpio_chip.ngpio = data->nbanks * 32;
+
+	platform_set_drvdata(pdev, data);
+
+	data->dev = &pdev->dev;
+
+	data->pctl_dev = pinctrl_register(&wmt_desc, &pdev->dev, data);
+	if (IS_ERR(data->pctl_dev)) {
+		dev_err(&pdev->dev, "Failed to register pinctrl\n");
+		return -EINVAL;
+	}
+
+	err = gpiochip_add(&data->gpio_chip);
+	if (err) {
+		dev_err(&pdev->dev, "could not add GPIO chip\n");
+		goto fail_gpio;
+	}
+
+	err = gpiochip_add_pin_range(&data->gpio_chip, dev_name(data->dev),
+				     0, 0, data->nbanks * 32);
+	if (err)
+		goto fail_range;
+
+	dev_info(&pdev->dev, "Pin controller initialized\n");
+
+	return 0;
+
+fail_range:
+	err = gpiochip_remove(&data->gpio_chip);
+	if (err)
+		dev_err(&pdev->dev, "failed to remove gpio chip\n");
+fail_gpio:
+	pinctrl_unregister(data->pctl_dev);
+	return err;
+}
+
+int wmt_pinctrl_remove(struct platform_device *pdev)
+{
+	struct wmt_pinctrl_data *data = platform_get_drvdata(pdev);
+	int err;
+
+	err = gpiochip_remove(&data->gpio_chip);
+	if (err)
+		dev_err(&pdev->dev, "failed to remove gpio chip\n");
+
+	pinctrl_unregister(data->pctl_dev);
+
+	return 0;
+}
diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.h b/drivers/pinctrl/vt8500/pinctrl-wmt.h
new file mode 100644
index 0000000..41f5f2d
--- /dev/null
+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.h
@@ -0,0 +1,79 @@
+/*
+ * Pinctrl driver for the Wondermedia SoC's
+ *
+ * Copyright (c) 2013 Tony Prisk <linux@prisktech.co.nz>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/gpio.h>
+
+/* VT8500 has no enable register in the extgpio bank. */
+#define NO_REG	0xFFFF
+
+#define WMT_PINCTRL_BANK(__en, __dir, __dout, __din, __pen, __pcfg)	\
+{									\
+	.reg_en		= __en,						\
+	.reg_dir	= __dir,					\
+	.reg_data_out	= __dout,					\
+	.reg_data_in	= __din,					\
+	.reg_pull_en	= __pen,					\
+	.reg_pull_cfg	= __pcfg,					\
+}
+
+/* Encode/decode the bank/bit pairs into a pin value */
+#define WMT_PIN(__bank, __offset)	((__bank << 5) | __offset)
+#define WMT_BANK_FROM_PIN(__pin)	(__pin >> 5)
+#define WMT_BIT_FROM_PIN(__pin)		(__pin & 0x1f)
+
+#define WMT_GROUP(__name, __data)		\
+{						\
+	.name = __name,				\
+	.pins = __data,				\
+	.npins = ARRAY_SIZE(__data),		\
+}
+
+struct wmt_pinctrl_bank_registers {
+	u32	reg_en;
+	u32	reg_dir;
+	u32	reg_data_out;
+	u32	reg_data_in;
+
+	u32	reg_pull_en;
+	u32	reg_pull_cfg;
+};
+
+struct wmt_pinctrl_group {
+	const char *name;
+	const unsigned int *pins;
+	const unsigned npins;
+};
+
+struct wmt_pinctrl_data {
+	struct device *dev;
+	struct pinctrl_dev *pctl_dev;
+
+	/* must be initialized before calling wmt_pinctrl_probe */
+	void __iomem *base;
+	const struct wmt_pinctrl_bank_registers *banks;
+	const struct pinctrl_pin_desc *pins;
+	const char * const *groups;
+
+	u32 nbanks;
+	u32 npins;
+	u32 ngroups;
+
+	struct gpio_chip gpio_chip;
+	struct pinctrl_gpio_range gpio_range;
+};
+
+int wmt_pinctrl_probe(struct platform_device *pdev,
+		      struct wmt_pinctrl_data *data);
+int wmt_pinctrl_remove(struct platform_device *pdev);
-- 
1.7.9.5

