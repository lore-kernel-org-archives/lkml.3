Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161103Ab3BOCtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 21:49:01 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:53334 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3BOCsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 21:48:51 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] pinctrl: gpio: vt8500: Add pin control driver for Wondermedia SoCs
Date: Fri, 15 Feb 2013 15:48:54 +1300
Message-Id: <1360896534-20637-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360896534-20637-1-git-send-email-linux@prisktech.co.nz>
References: <1360896534-20637-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/Kconfig                   |    4 +-
 arch/arm/boot/dts/wm8850-w70v2.dts |   15 +
 arch/arm/boot/dts/wm8850.dtsi      |    7 +-
 arch/arm/mach-vt8500/Kconfig       |    1 +
 drivers/pinctrl/Kconfig            |   10 +
 drivers/pinctrl/Makefile           |    2 +
 drivers/pinctrl/pinctrl-wm8850.c   |  166 +++++++++++
 drivers/pinctrl/pinctrl-wmt.c      |  565 ++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-wmt.h      |   73 +++++
 9 files changed, 840 insertions(+), 3 deletions(-)
 create mode 100644 drivers/pinctrl/pinctrl-wm8850.c
 create mode 100644 drivers/pinctrl/pinctrl-wmt.c
 create mode 100644 drivers/pinctrl/pinctrl-wmt.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 31fe86d..0240340 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1618,10 +1618,10 @@ config LOCAL_TIMERS
 config ARCH_NR_GPIO
 	int
 	default 1024 if ARCH_SHMOBILE || ARCH_TEGRA
+	default 512 if SOC_OMAP5
 	default 355 if ARCH_U8500
+	default 352 if ARCH_VT8500
 	default 264 if MACH_H4700
-	default 512 if SOC_OMAP5
-	default 288 if ARCH_VT8500
 	default 0
 	help
 	  Maximum number of GPIOs in the system.
diff --git a/arch/arm/boot/dts/wm8850-w70v2.dts b/arch/arm/boot/dts/wm8850-w70v2.dts
index d7d5a1d..64b6c6b 100644
--- a/arch/arm/boot/dts/wm8850-w70v2.dts
+++ b/arch/arm/boot/dts/wm8850-w70v2.dts
@@ -52,3 +52,18 @@
 		keymap = <116>; /* KEY_POWER */
 	};
 };
+
+&pinmux {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2c &sdmmc>;
+
+	i2c: i2c {
+		wm,pins = <168 169 170 171 172 173>;
+		wm,function = <2>; /* alt */
+	};
+
+	sdmmc: sdmmc {
+		wm,pins = <113 114 115 116 117 118 119>;
+		wm,function = <2>; /* alt */
+	};
+};
diff --git a/arch/arm/boot/dts/wm8850.dtsi b/arch/arm/boot/dts/wm8850.dtsi
index ba85056..add9e6f 100644
--- a/arch/arm/boot/dts/wm8850.dtsi
+++ b/arch/arm/boot/dts/wm8850.dtsi
@@ -39,13 +39,18 @@
 			reg = <0xD8150000 0x10000>;
 			interrupts = <56 57 58 59 60 61 62 63>;
 		};
-
+/*
 		gpio: gpio-controller@d8110000 {
 			compatible = "wm,wm8650-gpio";
 			gpio-controller;
 			reg = <0xd8110000 0x10000>;
 			#gpio-cells = <3>;
 		};
+*/
+		pinmux: pinmux@d8110000 {
+			compatible = "wm,wm8850-gpio";
+			reg = <0xd8110000 0x10000>;
+		};
 
 		pmc@d8130000 {
 			compatible = "via,vt8500-pmc";
diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
index 747aa14..06ee9a3 100644
--- a/arch/arm/mach-vt8500/Kconfig
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -29,5 +29,6 @@ config ARCH_WM8850
 	depends on ARCH_MULTI_V7
 	select ARCH_VT8500
 	select CPU_V7
+	select PINCTRL
 	help
 	  Support for WonderMedia WM8850 System-on-Chip.
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index a5f3c8c..7ad3669 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -170,6 +170,16 @@ config PINCTRL_U300
 	select PINMUX
 	select GENERIC_PINCONF
 
+config PINCTRL_WMT
+	bool
+	select PINMUX
+	select PINCONF
+
+config PINCTRL_WM8850
+	bool "Wondermedia WM8850 pin controller driver"
+	depends on ARCH_VT8500
+	select PINCTRL_WMT
+
 config PINCTRL_COH901
 	bool "ST-Ericsson U300 COH 901 335/571 GPIO"
 	depends on GPIOLIB && ARCH_U300 && PINCTRL_U300
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 6e87e52..a983ba4 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -34,6 +34,8 @@ obj-$(CONFIG_PINCTRL_TEGRA)	+= pinctrl-tegra.o
 obj-$(CONFIG_PINCTRL_TEGRA20)	+= pinctrl-tegra20.o
 obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
+obj-$(CONFIG_PINCTRL_WMT)	+= pinctrl-wmt.o
+obj-$(CONFIG_PINCTRL_WM8850)	+= pinctrl-wm8850.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
 obj-$(CONFIG_PINCTRL_SAMSUNG)	+= pinctrl-samsung.o
 obj-$(CONFIG_PINCTRL_EXYNOS)	+= pinctrl-exynos.o
diff --git a/drivers/pinctrl/pinctrl-wm8850.c b/drivers/pinctrl/pinctrl-wm8850.c
new file mode 100644
index 0000000..eec3277
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-wm8850.c
@@ -0,0 +1,166 @@
+/*
+ * Pinctrl data for WM8850 SoC
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
+#define WMT_PIN_SD0CLK		WMT_PIN(3, 17)
+#define WMT_PIN_SD0CMD		WMT_PIN(3, 18)
+#define WMT_PIN_SD0WP		WMT_PIN(3, 19)
+#define WMT_PIN_SD0DATA0	WMT_PIN(3, 20)
+#define WMT_PIN_SD0DATA1	WMT_PIN(3, 21)
+#define WMT_PIN_SD0DATA2	WMT_PIN(3, 22)
+#define WMT_PIN_SD0DATA3	WMT_PIN(3, 23)
+#define WMT_PIN_I2C0_SCL	WMT_PIN(5, 8)
+#define WMT_PIN_I2C0_SDA	WMT_PIN(5, 9)
+#define WMT_PIN_I2C1_SCL	WMT_PIN(5, 10)
+#define WMT_PIN_I2C1_SDA	WMT_PIN(5, 11)
+#define WMT_PIN_I2C2_SCL	WMT_PIN(5, 12)
+#define WMT_PIN_I2C2_SDA	WMT_PIN(5, 13)
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
+	PINCTRL_PIN(WMT_PIN_SD0CLK, "sd0_clk"),
+	PINCTRL_PIN(WMT_PIN_SD0CMD, "sd0_cmd"),
+	PINCTRL_PIN(WMT_PIN_SD0WP, "sd0_wp"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA0, "sd0_data0"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA1, "sd0_data1"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA2, "sd0_data2"),
+	PINCTRL_PIN(WMT_PIN_SD0DATA3, "sd0_data3"),
+	PINCTRL_PIN(WMT_PIN_I2C0_SCL, "i2c0_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C0_SDA, "i2c0_sda"),
+	PINCTRL_PIN(WMT_PIN_I2C1_SCL, "i2c1_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C1_SDA, "i2c1_sda"),
+	PINCTRL_PIN(WMT_PIN_I2C2_SCL, "i2c2_scl"),
+	PINCTRL_PIN(WMT_PIN_I2C2_SDA, "i2c2_sda"),
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
+	"sd0_clk",
+	"sd0_cmd",
+	"sd0_wp",
+	"sd0_data0",
+	"sd0_data1",
+	"sd0_data2",
+	"sd0_data3",
+	"i2c0_scl",
+	"i2c0_sda",
+	"i2c1_scl",
+	"i2c1_sda",
+	"i2c2_scl",
+	"i2c2_sda",
+};
+
+static int wm8850_pinctrl_probe(struct platform_device *pdev)
+{
+	struct wmt_pinctrl_data *data;
+	struct resource *res;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&pdev->dev, "failed to allocate data\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	data->base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!data->base) {
+		dev_err(&pdev->dev, "failed to map memory resource\n");
+		return -EBUSY;
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
+	{ .compatible = "wm,wm8850-gpio" },
+	{ /* sentinel */ },
+};
+
+static struct platform_driver wmt_pinctrl_driver = {
+	.probe	= wm8850_pinctrl_probe,
+	.remove	= wm8850_pinctrl_remove,
+	.driver = {
+		.name	= "gpio-wm8850",
+		.owner	= THIS_MODULE,
+		.of_match_table	= wmt_pinctrl_of_match,
+	},
+};
+
+module_platform_driver(wmt_pinctrl_driver);
diff --git a/drivers/pinctrl/pinctrl-wmt.c b/drivers/pinctrl/pinctrl-wmt.c
new file mode 100644
index 0000000..398ff98
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-wmt.c
@@ -0,0 +1,565 @@
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
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "pinctrl-wmt.h"
+
+static void wmt_setbits(struct wmt_pinctrl_data *data, u32 reg, u32 mask)
+{
+	u32 val;
+
+	val = readl(data->base + reg);
+	val |= mask;
+	writel(val, data->base + reg);
+}
+
+static void wmt_clearbits(struct wmt_pinctrl_data *data, u32 reg, u32 mask)
+{
+	u32 val;
+
+	val = readl(data->base + reg);
+	val &= ~mask;
+	writel(val, data->base + reg);
+}
+
+enum wmt_func_sel {
+	WMT_FSEL_GPIO_IN = 0,
+	WMT_FSEL_GPIO_OUT = 1,
+	WMT_FSEL_ALT = 2,
+	WMT_FSEL_COUNT = 3,
+};
+
+enum wmt_pinconf_param {
+	WMT_PINCONF_PARAM_PULL,
+};
+
+enum wmt_pinconf_pull {
+	WMT_PINCONFIG_PULL_NONE,
+	WMT_PINCONFIG_PULL_DOWN,
+	WMT_PINCONFIG_PULL_UP,
+};
+
+#define WMT_PINCONF_PACK(__param, __arg)	((__param << 16) | __arg)
+#define WMT_PINCONF_UNPACK_PARAM(__conf)	(__conf >> 16)
+#define WMT_PINCONF_UNPACK_ARG(__conf)		(__conf & 0xffff)
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
+	u32 bank = pin >> 5;
+	u32 bit = pin & 0x1F;
+	u32 reg_en = data->banks[bank].reg_en;
+	u32 reg_dir = data->banks[bank].reg_dir;
+
+	switch (func) {
+	case WMT_FSEL_GPIO_IN:
+		wmt_setbits(data, reg_en, BIT(bit));
+		wmt_clearbits(data, reg_dir, BIT(bit));
+		break;
+	case WMT_FSEL_GPIO_OUT:
+		wmt_setbits(data, reg_en, BIT(bit));
+		wmt_setbits(data, reg_dir, BIT(bit));
+		break;
+	case WMT_FSEL_ALT:
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
+#include <linux/pinctrl/consumer.h>
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
+					 unsigned selector)
+{
+	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
+
+	return data->groups[selector];
+}
+
+static int wmt_get_group_pins(struct pinctrl_dev *pctldev,
+			         unsigned selector,
+				 const unsigned **pins,
+				 unsigned *num_pins)
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
+	return -1;
+}
+
+static int wmt_pctl_dt_node_to_map_func(struct wmt_pinctrl_data *data,
+					struct device_node *np,
+					u32 pin, u32 fnum,
+					struct pinctrl_map **maps)
+{
+	u32 group;
+	struct pinctrl_map *map = *maps;
+
+	if (fnum >= ARRAY_SIZE(wmt_functions)) {
+		dev_err(data->dev, "invalid wm,function %d\n", fnum);
+		return -EINVAL;
+	}
+
+	group = wmt_pctl_find_group_by_pin(data, pin);
+	if (group == -1) {
+		dev_err(data->dev, "unable to match pin %d to group\n", pin);
+		return -EINVAL;
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
+	u32 group;
+	unsigned long *configs;
+	struct pinctrl_map *map = *maps;
+
+
+	if (pull > 2) {
+		dev_err(data->dev, "invalid wm,pull %d\n", pull);
+		return -EINVAL;
+	}
+
+	group = wmt_pctl_find_group_by_pin(data, pin);
+	if (group == -1) {
+		dev_err(data->dev, "unable to match pin %d to group\n", pin);
+		return -EINVAL;
+	}
+
+	configs = kzalloc(sizeof(*configs), GFP_KERNEL);
+	if (!configs)
+		return -ENOMEM;
+
+	configs[0] = 0;
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
+static inline u32 prop_u32(struct property *p, int i)
+{
+	return be32_to_cpup(((__be32 *)p->value) + i);
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
+	num_pins = pins->length / 4;
+	num_funcs = funcs ? (funcs->length / 4) : 0;
+	num_pulls = pulls ? (pulls->length / 4) : 0;
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
+	cur_map = maps = kzalloc(num_pins * maps_per_pin * sizeof(*maps),
+				 GFP_KERNEL);
+	if (!maps)
+		return -ENOMEM;
+
+	for (i = 0; i < num_pins; i++) {
+		pin = prop_u32(pins, i);
+
+		if (pin >= (data->nbanks * 32)) {
+			dev_err(data->dev, "invalid wm,pins value\n");
+			err = -EINVAL;
+			goto fail;
+		}
+
+		if (num_funcs) {
+			func = prop_u32(funcs, (num_funcs > 1) ? i : 0);
+			err = wmt_pctl_dt_node_to_map_func(data, np, pin, func,
+							   &cur_map);
+			if (err)
+				goto fail;
+		}
+
+		if (num_pulls) {
+			pull = prop_u32(pulls, (num_pulls > 1) ? i : 0);
+			err = wmt_pctl_dt_node_to_map_pull(data, np, pin, pull,
+							   &cur_map);
+			if (err)
+				goto fail;
+		}
+	}
+
+	*map = maps;
+	*num_maps = num_pins * maps_per_pin;
+
+	return 0;
+fail:
+	kfree(maps);
+	return err;
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
+	enum wmt_pinconf_param param = WMT_PINCONF_UNPACK_PARAM(config);
+	u16 arg = WMT_PINCONF_UNPACK_ARG(config);
+	u32 bank = pin >> 5;
+	u32 bit = pin & 0x1f;
+	u32 reg_pull_en = data->banks[bank].reg_pull_en;
+	u32 reg_pull_cfg = data->banks[bank].reg_pull_cfg;
+
+	if (param != WMT_PINCONF_PARAM_PULL)
+		return -EINVAL;
+
+	switch (arg) {
+	case WMT_PINCONFIG_PULL_NONE:
+		wmt_clearbits(data, reg_pull_en, BIT(bit));
+		break;
+	case WMT_PINCONFIG_PULL_DOWN:
+		wmt_clearbits(data, reg_pull_cfg, BIT(bit));
+		wmt_setbits(data, reg_pull_en, BIT(bit));
+		break;
+	case WMT_PINCONFIG_PULL_UP:
+		wmt_setbits(data, reg_pull_cfg, BIT(bit));
+		wmt_setbits(data, reg_pull_en, BIT(bit));
+		break;
+	default:
+		dev_err(data->dev, "unknown pinconf argument\n");
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
+	.name = "wmt-pinctrl",
+	.pctlops = &wmt_pctl_ops,
+	.pmxops = &wmt_pinmux_ops,
+	.confops = &wmt_pinconf_ops,
+};
+
+static struct pinctrl_gpio_range wmt_pinctrl_gpio_range = {
+	.name = "wmt-gpio",
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
+	u32 bank = offset >> 5;
+	u32 bit = offset & 0x1f;
+	u32 reg_data_in = data->banks[bank].reg_data_in;
+
+	return (readl(data->base + reg_data_in) >> bit) & 1;
+}
+
+static void wmt_gpio_set_value(struct gpio_chip *chip, unsigned offset,
+			      int value)
+{
+	struct wmt_pinctrl_data *data = dev_get_drvdata(chip->dev);
+	u32 bank = offset >> 5;
+	u32 bit = offset & 0x1f;
+	u32 reg_data_out = data->banks[bank].reg_data_out;
+
+	if (value)
+		wmt_setbits(data, reg_data_out, BIT(bit));
+	else
+		wmt_clearbits(data, reg_data_out, BIT(bit));
+}
+
+static struct gpio_chip wmt_gpio_chip = {
+	.label = "wmt-gpio",
+	.owner = THIS_MODULE,
+	.request = wmt_gpio_request,
+	.free = wmt_gpio_free,
+	.direction_input = wmt_gpio_direction_input,
+	.direction_output = wmt_gpio_direction_output,
+	.get = wmt_gpio_get_value,
+	.set = wmt_gpio_set_value,
+	.base = -1,
+	.can_sleep = 0,
+};
+
+int wmt_pinctrl_probe(struct platform_device *pdev,
+		      struct wmt_pinctrl_data *data)
+{
+	int err;
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
+	data->pctl_dev = pinctrl_register(&wmt_desc, &pdev->dev, data);
+	if (IS_ERR(data->pctl_dev)) {
+		dev_err(&pdev->dev, "Failed to register pinctrl\n");
+		return -EINVAL;
+	}
+
+	err = gpiochip_add(&data->gpio_chip);
+	if (err) {
+		dev_err(&pdev->dev, "could not add GPIO chip\n");
+		return err;
+	}
+
+	data->gpio_range = wmt_pinctrl_gpio_range;
+
+	data->gpio_range.gc = &data->gpio_chip;
+	data->gpio_range.base = data->gpio_chip.base;
+	data->gpio_range.npins = data->nbanks * 32;
+	pinctrl_add_gpio_range(data->pctl_dev, &data->gpio_range);
+
+	dev_info(&pdev->dev, "Pin controller initialized\n");
+
+	return 0;
+}
+
+int wmt_pinctrl_remove(struct platform_device *pdev)
+{
+	struct wmt_pinctrl_data *data = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(data->pctl_dev);
+
+	return 0;
+}
+
+MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
+MODULE_DESCRIPTION("Wondermedia Pincontrol driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, wmt_pinctrl_of_match);
diff --git a/drivers/pinctrl/pinctrl-wmt.h b/drivers/pinctrl/pinctrl-wmt.h
new file mode 100644
index 0000000..95c4dff
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-wmt.h
@@ -0,0 +1,73 @@
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
+#define WMT_PIN(__bank, __offset)	((__bank << 5) | __offset)
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

