Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3FBXjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 19:39:44 -0400
Received: from gloria.sntech.de ([95.129.55.99]:40437 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab3FBXje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 19:39:34 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 07/10] pinctrl: add pinctrl driver for Rockchip SoCs
Date: Mon, 3 Jun 2013 00:59:47 +0200
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
Message-Id: <201306030059.47611.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support the Cortex-A9 based SoCs from Rockchip,
so at least the RK2928, RK3066 (a and b) and RK3188.
Earlier Rockchip SoCs seem to use similar mechanics for gpio
handling so should be supportable with relative small changes.
Pull handling on the rk3188 is currently a stub, due to it being
a bit different to the earlier SoCs.

Pinmuxing as well as gpio (and interrupt-) handling tested on
a rk3066a based machine.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../bindings/pinctrl/rockchip-pinctrl.txt          |  100 ++
 drivers/pinctrl/Kconfig                            |    6 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-rockchip.c                 | 1319 ++++++++++++++++++++
 include/dt-bindings/pinctrl/rockchip.h             |   37 +
 5 files changed, 1463 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/rockchip-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-rockchip.c
 create mode 100644 include/dt-bindings/pinctrl/rockchip.h

diff --git a/Documentation/devicetree/bindings/pinctrl/rockchip-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/rockchip-pinctrl.txt
new file mode 100644
index 0000000..b939192
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/rockchip-pinctrl.txt
@@ -0,0 +1,100 @@
+* Rockchip Pinmux Controller
+
+The Rockchip Pinmux Controller, enables the IC
+to share one PAD to several functional blocks. The sharing is done by
+multiplexing the PAD input/output signals. For each PAD there are up to
+4 muxing options with option 0 being the use as a GPIO.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+The Rockchip pin configuration node is a node of a group of pins which can be
+used for a specific device or function. This node represents both mux and
+config of the pins in that group. The 'pins' selects the function mode(also
+named pin mode) this pin can work on and the 'config' configures various pad
+settings such as pull-up, etc.
+
+The pins are grouped into up to 5 individual pin banks which need to be
+defined as gpio sub-nodes of the pinmux controller.
+
+Required properties for iomux controller:
+  - compatible: one of "rockchip,rk2928-pinctrl", "rockchip,rk3066a-pinctrl"
+		       "rockchip,rk3066b-pinctrl", "rockchip,rk3188-pinctrl"
+
+Required properties for gpio sub nodes:
+  - compatible: "rockchip,gpio-bank"
+  - reg: register of the gpio bank (different than the iomux registerset)
+  - interrupts: base interrupt of the gpio bank in the interrupt controller
+  - clocks: clock that drives this bank
+  - gpio-controller: identifies the node as a gpio controller and pin bank.
+  - #gpio-cells: number of cells in GPIO specifier. Since the generic GPIO
+    binding is used, the amount of cells must be specified as 2. See generic
+    GPIO binding documentation for description of particular cells.
+  - interrupt-controller: identifies the controller node as interrupt-parent.
+  - #interrupt-cells: the value of this property should be 2.
+     - First Cell: represents the external gpio interrupt number local to the
+       external gpio interrupt space of the controller.
+     - Second Cell: flags to identify the type of the interrupt
+       - 1 = rising edge triggered
+       - 2 = falling edge triggered
+       - 3 = rising and falling edge triggered
+       - 4 = high level triggered
+       - 8 = low level triggered
+
+
+Required properties for pin configuration node:
+  - rockchip,pins: 4 integers array, represents a group of pins mux and config
+    setting. The format is rockchip,pins = <PIN_BANK PIN_BANK_NUM MUX CONFIG>.
+    The MUX 0 means gpio and MUX 1 to 3 mean the specific device function
+
+Bits used for CONFIG:
+PULL_AUTO	(1 << 0): indicate this pin needs a pull setting for SoCs
+			  that determine the pull up or down themselfs
+PULL_UP		(1 << 1): indicate this pin needs a pull up
+PULL_DOWN	(1 << 2): indicate this pin needs a pull down
+
+Examples:
+
+pinctrl@20008000 {
+	compatible = "rockchip,rk3066a-pinctrl";
+	reg = <0x20008000 0x150>;
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+
+	gpio0: gpio0@20034000 {
+		compatible = "rockchip,gpio-bank";
+		reg = <0x20034000 0x100>;
+		interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&clk_gates8 9>;
+
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		interrupt-controller;
+		#interrupt-cells = <2>;
+	};
+
+	...
+
+	uart2 {
+		uart2_xfer: uart2-xfer {
+			rockchip,pins = <RK_GPIO1 8 1 RK_PINCTRL_PULL_AUTO>,
+					<RK_GPIO1 9 1 RK_PINCTRL_PULL_AUTO>;
+		};
+	};
+};
+
+uart2: serial@20064000 {
+	compatible = "snps,dw-apb-uart";
+	reg = <0x20064000 0x400>;
+	interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>;
+	reg-shift = <2>;
+	reg-io-width = <1>;
+	clocks = <&mux_uart2>;
+	status = "okay";
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart2_xfer>;
+};
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 5259d40..3e8cf8d 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -158,6 +158,12 @@ config PINCTRL_DB8540
 	bool "DB8540 pin controller driver"
 	depends on PINCTRL_NOMADIK && ARCH_U8500
 
+config PINCTRL_ROCKCHIP
+	bool
+	select PINMUX
+	select PINCONF
+	select GENERIC_IRQ_CHIP
+
 config PINCTRL_SINGLE
 	tristate "One-register-per-pin type device tree based pinctrl driver"
 	depends on OF
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 3b26e3c..16c3f8bc 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_PINCTRL_NOMADIK)	+= pinctrl-nomadik.o
 obj-$(CONFIG_PINCTRL_STN8815)	+= pinctrl-nomadik-stn8815.o
 obj-$(CONFIG_PINCTRL_DB8500)	+= pinctrl-nomadik-db8500.o
 obj-$(CONFIG_PINCTRL_DB8540)	+= pinctrl-nomadik-db8540.o
+obj-$(CONFIG_PINCTRL_ROCKCHIP)	+= pinctrl-rockchip.o
 obj-$(CONFIG_PINCTRL_SINGLE)	+= pinctrl-single.o
 obj-$(CONFIG_PINCTRL_SIRF)	+= sirf/
 obj-$(CONFIG_PINCTRL_SUNXI)	+= pinctrl-sunxi.o
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
new file mode 100644
index 0000000..9dba424
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -0,0 +1,1319 @@
+/*
+ * Pinctrl driver for Rockchip SoCs
+ *
+ * Copyright (c) 2013 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
+ *
+ * With some ideas taken from pinctrl-samsung:
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ * Copyright (c) 2012 Linaro Ltd
+ *		http://www.linaro.org
+ *
+ * and pinctrl-at91:
+ * Copyright (C) 2011-2012 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/irqchip/chained_irq.h>
+#include <linux/clk-provider.h>
+#include <dt-bindings/pinctrl/rockchip.h>
+
+#include "core.h"
+
+/* GPIO control registers */
+#define GPIO_SWPORT_DR		0x00
+#define GPIO_SWPORT_DDR		0x04
+#define GPIO_INTEN		0x30
+#define GPIO_INTMASK		0x34
+#define GPIO_INTTYPE_LEVEL	0x38
+#define GPIO_INT_POLARITY	0x3c
+#define GPIO_INT_STATUS		0x40
+#define GPIO_INT_RAWSTATUS	0x44
+#define GPIO_DEBOUNCE		0x48
+#define GPIO_PORTS_EOI		0x4c
+#define GPIO_EXT_PORT		0x50
+#define GPIO_LS_SYNC		0x60
+
+/**
+ * @reg_base: register base of the gpio bank
+ * @clk: clock of the gpio bank
+ * @irq: interrupt of the gpio bank
+ * @pin_base: first pin number
+ * @nr_pins: number of pins in this bank
+ * @name: name of the bank
+ * @bank_num: number of the bank, to account for holes
+ * @valid: are all necessary informations present
+ * @of_node: dt node of this bank
+ * @drvdata: common pinctrl basedata
+ * @domain: irqdomain of the gpio bank
+ * @gpio_chip: gpiolib chip
+ * @grange: gpio range
+ * @slock: spinlock for the gpio bank
+ */
+struct rockchip_pin_bank {
+	void __iomem			*reg_base;
+	struct clk			*clk;
+	int				irq;
+	u32				pin_base;
+	u8				nr_pins;
+	char				*name;
+	u8				bank_num;
+	bool				valid;
+	struct device_node		*of_node;
+	struct rockchip_pinctrl		*drvdata;
+	struct irq_domain		*domain;
+	struct gpio_chip		gpio_chip;
+	struct pinctrl_gpio_range	grange;
+	spinlock_t			slock;
+
+};
+
+#define PIN_BANK(id, pins, label)			\
+	{						\
+		.bank_num	= id,			\
+		.nr_pins	= pins,			\
+		.name		= label,		\
+	}
+
+/**
+ * @pull_auto: some SoCs don't allow pulls to be specified as up or down, but
+ *	       instead decide this automatically based on the pad-type.
+ */
+struct rockchip_pin_ctrl {
+	struct rockchip_pin_bank	*pin_banks;
+	u32				nr_banks;
+	u32				nr_pins;
+	char				*label;
+	int				mux_offset;
+	int				pull_offset;
+	bool				pull_auto;
+};
+
+/**
+ * struct rockchip_pin_group: represent group of pins of a pinmux function.
+ * @name: name of the pin group, used to lookup the group.
+ * @pins: the pins included in this group.
+ * @num_pins: number of pins included in this group.
+ * @mux: the mux function number to be programmed when selected.
+ */
+struct rockchip_pin_group {
+	const char		*name;
+	unsigned int		*pins;
+	unsigned int		npins;
+	unsigned int		*func;
+	unsigned long		*configs;
+};
+
+/**
+ * struct rockchip_pmx_func: represent a pin function.
+ * @name: name of the pin function, used to lookup the function.
+ * @groups: one or more names of pin groups that provide this function.
+ * @num_groups: number of groups included in @groups.
+ */
+struct rockchip_pmx_func {
+	const char		*name;
+	const char		**groups;
+	u8			ngroups;
+};
+
+struct rockchip_pinctrl {
+	void __iomem			*reg_base;
+	struct device			*dev;
+	struct rockchip_pin_ctrl	*ctrl;
+	struct pinctrl_desc		pctl;
+	struct pinctrl_dev		*pctl_dev;
+	struct rockchip_pin_group	*groups;
+	unsigned int			ngroups;
+	struct rockchip_pmx_func	*functions;
+	unsigned int			nfunctions;
+};
+
+static inline struct rockchip_pin_bank *gc_to_pin_bank(struct gpio_chip *gc)
+{
+	return container_of(gc, struct rockchip_pin_bank, gpio_chip);
+}
+
+static const inline struct rockchip_pin_group *pinctrl_name_to_group(
+					const struct rockchip_pinctrl *info,
+					const char *name)
+{
+	const struct rockchip_pin_group *grp = NULL;
+	int i;
+
+	for (i = 0; i < info->ngroups; i++) {
+		if (strcmp(info->groups[i].name, name))
+			continue;
+
+		grp = &info->groups[i];
+		break;
+	}
+
+	return grp;
+}
+
+/*
+ * given a pin number that is local to a pin controller, find out the pin bank
+ * and the register base of the pin bank.
+ */
+static struct rockchip_pin_bank *pin_to_bank(struct rockchip_pinctrl *info,
+								unsigned pin)
+{
+	struct rockchip_pin_bank *b = info->ctrl->pin_banks;
+
+	while ((pin >= b->pin_base) &&
+			((b->pin_base + b->nr_pins - 1) < pin))
+		b++;
+
+	return b;
+}
+
+static struct rockchip_pin_bank *bank_num_to_bank(
+					struct rockchip_pinctrl *info,
+					unsigned num)
+{
+	struct rockchip_pin_bank *b = info->ctrl->pin_banks;
+	int i;
+
+	for (i = 0; i < info->ctrl->nr_banks; i++) {
+		if (b->bank_num == num)
+			break;
+
+		b++;
+	}
+
+	if (b->bank_num != num)
+		return ERR_PTR(-EINVAL);
+
+	return b;
+}
+
+/*
+ * Pinctrl_ops handling
+ */
+
+static int rockchip_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+
+	return info->ngroups;
+}
+
+static const char *rockchip_get_group_name(struct pinctrl_dev *pctldev,
+							unsigned selector)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+
+	return info->groups[selector].name;
+}
+
+static int rockchip_get_group_pins(struct pinctrl_dev *pctldev,
+				      unsigned selector, const unsigned **pins,
+				      unsigned *npins)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+
+	if (selector >= info->ngroups)
+		return -EINVAL;
+
+	*pins = info->groups[selector].pins;
+	*npins = info->groups[selector].npins;
+
+	return 0;
+}
+
+static void rockchip_pin_dbg_show(struct pinctrl_dev *pctldev,
+					struct seq_file *s, unsigned offset)
+{
+	seq_printf(s, "%s", dev_name(pctldev->dev));
+}
+
+static int rockchip_dt_node_to_map(struct pinctrl_dev *pctldev,
+				 struct device_node *np,
+				 struct pinctrl_map **map, unsigned *num_maps)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	const struct rockchip_pin_group *grp;
+	struct pinctrl_map *new_map;
+	struct device_node *parent;
+	int map_num = 1;
+	int i;
+
+	/*
+	 * first find the group of this node and check if we need to create
+	 * config maps for pins
+	 */
+	grp = pinctrl_name_to_group(info, np->name);
+	if (!grp) {
+		dev_err(info->dev, "unable to find group for node %s\n",
+			np->name);
+		return -EINVAL;
+	}
+
+	map_num += grp->npins;
+	new_map = devm_kzalloc(pctldev->dev, sizeof(*new_map) * map_num,
+								GFP_KERNEL);
+	if (!new_map)
+		return -ENOMEM;
+
+	*map = new_map;
+	*num_maps = map_num;
+
+	/* create mux map */
+	parent = of_get_parent(np);
+	if (!parent) {
+		devm_kfree(pctldev->dev, new_map);
+		return -EINVAL;
+	}
+	new_map[0].type = PIN_MAP_TYPE_MUX_GROUP;
+	new_map[0].data.mux.function = parent->name;
+	new_map[0].data.mux.group = np->name;
+	of_node_put(parent);
+
+	/* create config map */
+	new_map++;
+	for (i = 0; i < grp->npins; i++) {
+		new_map[i].type = PIN_MAP_TYPE_CONFIGS_PIN;
+		new_map[i].data.configs.group_or_pin =
+				pin_get_name(pctldev, grp->pins[i]);
+		new_map[i].data.configs.configs = &grp->configs[i];
+		new_map[i].data.configs.num_configs = 1;
+	}
+
+	dev_dbg(pctldev->dev, "maps: function %s group %s num %d\n",
+		(*map)->data.mux.function, (*map)->data.mux.group, map_num);
+
+	return 0;
+}
+
+static void rockchip_dt_free_map(struct pinctrl_dev *pctldev,
+				    struct pinctrl_map *map, unsigned num_maps)
+{
+}
+
+static const struct pinctrl_ops rockchip_pctrl_ops = {
+	.get_groups_count	= rockchip_get_groups_count,
+	.get_group_name		= rockchip_get_group_name,
+	.get_group_pins		= rockchip_get_group_pins,
+	.pin_dbg_show		= rockchip_pin_dbg_show,
+	.dt_node_to_map		= rockchip_dt_node_to_map,
+	.dt_free_map		= rockchip_dt_free_map,
+};
+
+/*
+ * Hardware access
+ */
+
+/*
+ * Set a new mux function for a pin.
+ *
+ * The register is divided into the upper and lower 16 bit. When changing
+ * a value, the previous register value is not read and changed. Instead
+ * it seems the changed bits are marked in the upper 16 bit, while the
+ * changed value gets set in the same offset in the lower 16 bit.
+ * All pin settings seem to be 2 bit wide in both the upper and lower
+ * parts.
+ * @bank: pin bank to change
+ * @pin: pin to change
+ * @mux: new mux function to set
+ */
+static void rockchip_set_mux(struct rockchip_pin_bank *bank, int pin, int mux)
+{
+	struct rockchip_pinctrl *info = bank->drvdata;
+	void __iomem *reg = info->reg_base + info->ctrl->mux_offset;
+	unsigned long flags;
+	int bit;
+	u32 data;
+
+	dev_dbg(info->dev, "setting mux of GPIO%d-%d to %d\n",
+						bank->bank_num, pin, mux);
+
+	/* get basic quadrupel of mux registers and the correct reg inside */
+	reg += bank->bank_num * 0x10;
+	reg += (pin / 8) * 4;
+	bit = (pin % 8) * 2;
+
+	spin_lock_irqsave(&bank->slock, flags);
+
+	data = (3 << (bit + 16));
+	data |= (mux & 3) << bit;
+	writel(data, reg);
+
+	spin_unlock_irqrestore(&bank->slock, flags);
+}
+
+static int rockchip_get_pull(struct rockchip_pin_bank *bank, int pin_num)
+{
+	struct rockchip_pinctrl *info = bank->drvdata;
+	void __iomem *reg;
+	int bit;
+	u32 data;
+
+	/* rk3066b does support any pulls */
+	if (!info->ctrl->pull_offset)
+		return 0;
+
+	reg = info->reg_base + info->ctrl->pull_offset;
+
+	if (info->ctrl->pull_auto) {
+		reg += bank->bank_num * 8;
+		reg += (pin_num / 16) * 4;
+		bit = pin_num % 16;
+
+		data = readl_relaxed(reg);
+		data >>= bit;
+		data &= 1;
+
+		return !data;
+	} else {
+		dev_err(info->dev, "pull support for rk31xx not implemented\n");
+		return -EIO;
+	}
+}
+
+static int rockchip_set_pull(struct rockchip_pin_bank *bank,
+					int pin_num, int pull)
+{
+	struct rockchip_pinctrl *info = bank->drvdata;
+	void __iomem *reg;
+	unsigned long flags;
+	int bit;
+	u32 data;
+
+	dev_dbg(info->dev, "setting pull of GPIO%d-%d to %d\n",
+		 bank->bank_num, pin_num, pull);
+
+	/* rk3066b does support any pulls */
+	if (!info->ctrl->pull_offset)
+		return pull ? -EINVAL : 0;
+
+	reg = info->reg_base + info->ctrl->pull_offset;
+
+	if (info->ctrl->pull_auto) {
+		if (pull > RK_PINCTRL_PULL_AUTO) {
+			dev_err(info->dev, "only PULL_AUTO allowed\n");
+			return -EINVAL;
+		}
+
+		reg += bank->bank_num * 8;
+		reg += (pin_num / 16) * 4;
+		bit = pin_num % 16;
+
+		spin_lock_irqsave(&bank->slock, flags);
+
+		data = (1 << (bit + 16));
+		if (!pull)
+			data |= (1 << bit);
+		writel(data, reg);
+
+		spin_unlock_irqrestore(&bank->slock, flags);
+	} else {
+		if (pull == RK_PINCTRL_PULL_AUTO) {
+			dev_err(info->dev, "pull direction (up/down) needs to be specified\n");
+			return -EINVAL;
+		}
+
+		dev_err(info->dev, "pull support for rk31xx not implemented\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/*
+ * Pinmux_ops handling
+ */
+
+static int rockchip_pmx_get_funcs_count(struct pinctrl_dev *pctldev)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+
+	return info->nfunctions;
+}
+
+static const char *rockchip_pmx_get_func_name(struct pinctrl_dev *pctldev,
+					  unsigned selector)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+
+	return info->functions[selector].name;
+}
+
+static int rockchip_pmx_get_groups(struct pinctrl_dev *pctldev,
+				unsigned selector, const char * const **groups,
+				unsigned * const num_groups)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+
+	*groups = info->functions[selector].groups;
+	*num_groups = info->functions[selector].ngroups;
+
+	return 0;
+}
+
+static int rockchip_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
+							    unsigned group)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	const unsigned int *pins = info->groups[group].pins;
+	struct rockchip_pin_bank *bank;
+	int cnt;
+
+	dev_dbg(info->dev, "enable function %s group %s\n",
+		info->functions[selector].name, info->groups[group].name);
+
+	/*
+	 * for each pin in the pin group selected, program the correspoding pin
+	 * pin function number in the config register.
+	 */
+	for (cnt = 0; cnt < info->groups[group].npins; cnt++) {
+		bank = pin_to_bank(info, pins[cnt]);
+		rockchip_set_mux(bank, pins[cnt] - bank->pin_base,
+				 info->groups[group].func[cnt]);
+	}
+
+	return 0;
+}
+
+static void rockchip_pmx_disable(struct pinctrl_dev *pctldev,
+					unsigned selector, unsigned group)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	const unsigned int *pins = info->groups[group].pins;
+	struct rockchip_pin_bank *bank;
+	int cnt;
+
+	dev_dbg(info->dev, "disable function %s group %s\n",
+		info->functions[selector].name, info->groups[group].name);
+
+	for (cnt = 0; cnt < info->groups[group].npins; cnt++) {
+		bank = pin_to_bank(info, pins[cnt]);
+		rockchip_set_mux(bank, pins[cnt] - bank->pin_base, 0);
+	}
+}
+
+/*
+ * The calls to gpio_direction_output() and gpio_direction_input()
+ * leads to this function call (via the pinctrl_gpio_direction_{input|output}()
+ * function called from the gpiolib interface).
+ */
+static int rockchip_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
+					      struct pinctrl_gpio_range *range,
+					      unsigned offset, bool input)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	struct rockchip_pin_bank *bank;
+	struct gpio_chip *chip;
+	int pin;
+	u32 data;
+
+	chip = range->gc;
+	bank = gc_to_pin_bank(chip);
+	pin = offset - chip->base;
+
+	dev_dbg(info->dev, "gpio_direction for pin %u as %s-%d to %s\n",
+		 offset, range->name, pin, input ? "input" : "output");
+
+	rockchip_set_mux(bank, pin, RK_FUNC_GPIO);
+
+	data = readl_relaxed(bank->reg_base + GPIO_SWPORT_DDR);
+	/* set bit to 1 for output, 0 for input */
+	if (!input)
+		data |= (1 << pin);
+	else
+		data &= ~(1 << pin);
+	writel_relaxed(data, bank->reg_base + GPIO_SWPORT_DDR);
+
+	return 0;
+}
+
+static const struct pinmux_ops rockchip_pmx_ops = {
+	.get_functions_count	= rockchip_pmx_get_funcs_count,
+	.get_function_name	= rockchip_pmx_get_func_name,
+	.get_function_groups	= rockchip_pmx_get_groups,
+	.enable			= rockchip_pmx_enable,
+	.disable		= rockchip_pmx_disable,
+	.gpio_set_direction	= rockchip_pmx_gpio_set_direction,
+};
+
+/*
+ * Pinconf_ops handling
+ */
+
+/* set the pin config settings for a specified pin */
+static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
+							unsigned long config)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	struct rockchip_pin_bank *bank = pin_to_bank(info, pin);
+	int val;
+
+	val = config & (RK_PINCTRL_PULL_AUTO | RK_PINCTRL_PULL_UP |
+			RK_PINCTRL_PULL_DOWN);
+	return rockchip_set_pull(bank, pin - bank->pin_base, val);
+
+	return 0;
+}
+
+/* get the pin config settings for a specified pin */
+static int rockchip_pinconf_get(struct pinctrl_dev *pctldev, unsigned int pin,
+							unsigned long *config)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	struct rockchip_pin_bank *bank = pin_to_bank(info, pin);
+
+	*config |= rockchip_get_pull(bank, pin - bank->pin_base);
+
+	return 0;
+}
+
+static const struct pinconf_ops rockchip_pinconf_ops = {
+	.pin_config_get			= rockchip_pinconf_get,
+	.pin_config_set			= rockchip_pinconf_set,
+};
+
+static const char *gpio_compat = "rockchip,gpio-bank";
+
+static void rockchip_pinctrl_child_count(struct rockchip_pinctrl *info,
+						struct device_node *np)
+{
+	struct device_node *child;
+
+	for_each_child_of_node(np, child) {
+		if (of_device_is_compatible(child, gpio_compat))
+			continue;
+
+		info->nfunctions++;
+		info->ngroups += of_get_child_count(child);
+	}
+}
+
+static int rockchip_pinctrl_parse_groups(struct device_node *np,
+					      struct rockchip_pin_group *grp,
+					      struct rockchip_pinctrl *info,
+					      u32 index)
+{
+	struct rockchip_pin_bank *bank;
+	int size;
+	const __be32 *list;
+	int num;
+	int i, j;
+	int pin;
+
+	dev_dbg(info->dev, "group(%d): %s\n", index, np->name);
+
+	/* Initialise group */
+	grp->name = np->name;
+
+	/*
+	 * the binding format is rockchip,pins = <bank pin mux CONFIG>,
+	 * do sanity check and calculate pins number
+	 */
+	list = of_get_property(np, "rockchip,pins", &size);
+	/* we do not check return since it's safe node passed down */
+	size /= sizeof(*list);
+	if (!size || size % 4) {
+		dev_err(info->dev, "wrong pins number or pins and configs should be by 4\n");
+		return -EINVAL;
+	}
+
+	grp->npins = size / 4;
+
+	grp->configs = devm_kzalloc(info->dev, grp->npins *
+							sizeof(unsigned long),
+						GFP_KERNEL);
+	grp->pins = devm_kzalloc(info->dev, grp->npins * sizeof(unsigned int),
+						GFP_KERNEL);
+	grp->func = devm_kzalloc(info->dev, grp->npins * sizeof(unsigned int),
+						GFP_KERNEL);
+	if (!grp->configs || !grp->pins)
+		return -ENOMEM;
+
+	for (i = 0, j = 0; i < size; i += 4, j++) {
+		num = be32_to_cpu(*list++);
+		bank = bank_num_to_bank(info, num);
+		if (IS_ERR(bank))
+			return PTR_ERR(bank);
+
+		pin = be32_to_cpu(*list++);
+		grp->pins[j] = bank->pin_base + pin;
+		grp->func[j] = be32_to_cpu(*list++);
+		grp->configs[j] = be32_to_cpu(*list++);
+	}
+
+	return 0;
+}
+
+static int rockchip_pinctrl_parse_functions(struct device_node *np,
+						struct rockchip_pinctrl *info,
+						u32 index)
+{
+	struct device_node *child;
+	struct rockchip_pmx_func *func;
+	struct rockchip_pin_group *grp;
+	int ret;
+	static u32 grp_index;
+	u32 i = 0;
+
+	dev_dbg(info->dev, "parse function(%d): %s\n", index, np->name);
+
+	func = &info->functions[index];
+
+	/* Initialise function */
+	func->name = np->name;
+	func->ngroups = of_get_child_count(np);
+	if (func->ngroups <= 0) {
+		dev_err(info->dev, "no groups defined for %s\n", np->name);
+		return -EINVAL;
+	}
+	func->groups = devm_kzalloc(info->dev,
+			func->ngroups * sizeof(char *), GFP_KERNEL);
+	if (!func->groups)
+		return -ENOMEM;
+
+	for_each_child_of_node(np, child) {
+		func->groups[i] = child->name;
+		grp = &info->groups[grp_index++];
+		ret = rockchip_pinctrl_parse_groups(child, grp, info, i++);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int rockchip_pinctrl_parse_dt(struct platform_device *pdev,
+					      struct rockchip_pinctrl *info)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct device_node *child;
+	int ret;
+	int i;
+
+	rockchip_pinctrl_child_count(info, np);
+
+	dev_dbg(&pdev->dev, "nfunctions = %d\n", info->nfunctions);
+	dev_dbg(&pdev->dev, "ngroups = %d\n", info->ngroups);
+
+	info->functions = devm_kzalloc(dev, info->nfunctions *
+					      sizeof(struct rockchip_pmx_func),
+					      GFP_KERNEL);
+	if (!info->functions) {
+		dev_err(dev, "failed to allocate memory for function list\n");
+		return -EINVAL;
+	}
+
+	info->groups = devm_kzalloc(dev, info->ngroups *
+					    sizeof(struct rockchip_pin_group),
+					    GFP_KERNEL);
+	if (!info->groups) {
+		dev_err(dev, "failed allocate memory for ping group list\n");
+		return -EINVAL;
+	}
+
+	i = 0;
+
+	for_each_child_of_node(np, child) {
+		if (of_device_is_compatible(child, gpio_compat))
+			continue;
+		ret = rockchip_pinctrl_parse_functions(child, info, i++);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to parse function\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int rockchip_pinctrl_register(struct platform_device *pdev,
+					struct rockchip_pinctrl *info)
+{
+	struct pinctrl_desc *ctrldesc = &info->pctl;
+	struct pinctrl_pin_desc *pindesc, *pdesc;
+	struct rockchip_pin_bank *pin_bank;
+	int pin, bank, ret;
+	int k;
+
+	ctrldesc->name = "rockchip-pinctrl";
+	ctrldesc->owner = THIS_MODULE;
+	ctrldesc->pctlops = &rockchip_pctrl_ops;
+	ctrldesc->pmxops = &rockchip_pmx_ops;
+	ctrldesc->confops = &rockchip_pinconf_ops;
+
+	pindesc = devm_kzalloc(&pdev->dev, sizeof(*pindesc) *
+			info->ctrl->nr_pins, GFP_KERNEL);
+	if (!pindesc) {
+		dev_err(&pdev->dev, "mem alloc for pin descriptors failed\n");
+		return -ENOMEM;
+	}
+	ctrldesc->pins = pindesc;
+	ctrldesc->npins = info->ctrl->nr_pins;
+
+	pdesc = pindesc;
+	for (bank = 0 , k = 0; bank < info->ctrl->nr_banks; bank++) {
+		pin_bank = &info->ctrl->pin_banks[bank];
+		for (pin = 0; pin < pin_bank->nr_pins; pin++, k++) {
+			pdesc->number = k;
+			pdesc->name = kasprintf(GFP_KERNEL, "%s-%d",
+						pin_bank->name, pin);
+			pdesc++;
+		}
+	}
+
+	info->pctl_dev = pinctrl_register(ctrldesc, &pdev->dev, info);
+	if (!info->pctl_dev) {
+		dev_err(&pdev->dev, "could not register pinctrl driver\n");
+		return -EINVAL;
+	}
+
+	for (bank = 0; bank < info->ctrl->nr_banks; ++bank) {
+		pin_bank = &info->ctrl->pin_banks[bank];
+		pin_bank->grange.name = pin_bank->name;
+		pin_bank->grange.id = bank;
+		pin_bank->grange.pin_base = pin_bank->pin_base;
+		pin_bank->grange.base = pin_bank->gpio_chip.base;
+		pin_bank->grange.npins = pin_bank->gpio_chip.ngpio;
+		pin_bank->grange.gc = &pin_bank->gpio_chip;
+		pinctrl_add_gpio_range(info->pctl_dev, &pin_bank->grange);
+	}
+
+	ret = rockchip_pinctrl_parse_dt(pdev, info);
+	if (ret) {
+		pinctrl_unregister(info->pctl_dev);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * GPIO handling
+ */
+
+static void rockchip_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
+{
+	struct rockchip_pin_bank *bank = gc_to_pin_bank(gc);
+	void __iomem *reg = bank->reg_base + GPIO_SWPORT_DR;
+	unsigned long flags;
+	u32 data;
+
+	spin_lock_irqsave(&bank->slock, flags);
+
+	data = readl(reg);
+	data &= ~(1 << offset);
+	if (value)
+		data |= 1 << offset;
+	writel(data, reg);
+
+	spin_unlock_irqrestore(&bank->slock, flags);
+}
+
+/*
+ * Returns the level of the pin for input direction and setting of the DR
+ * register for output gpios.
+ */
+static int rockchip_gpio_get(struct gpio_chip *gc, unsigned offset)
+{
+	struct rockchip_pin_bank *bank = gc_to_pin_bank(gc);
+	u32 data;
+
+	data = readl(bank->reg_base + GPIO_EXT_PORT);
+	data >>= offset;
+	data &= 1;
+	return data;
+}
+
+/*
+ * gpiolib gpio_direction_input callback function. The setting of the pin
+ * mux function as 'gpio input' will be handled by the pinctrl susbsystem
+ * interface.
+ */
+static int rockchip_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
+{
+	return pinctrl_gpio_direction_input(gc->base + offset);
+}
+
+/*
+ * gpiolib gpio_direction_output callback function. The setting of the pin
+ * mux function as 'gpio output' will be handled by the pinctrl susbsystem
+ * interface.
+ */
+static int rockchip_gpio_direction_output(struct gpio_chip *gc,
+					  unsigned offset, int value)
+{
+	rockchip_gpio_set(gc, offset, value);
+	return pinctrl_gpio_direction_output(gc->base + offset);
+}
+
+/*
+ * gpiolib gpio_to_irq callback function. Creates a mapping between a GPIO pin
+ * and a virtual IRQ, if not already present.
+ */
+static int rockchip_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct rockchip_pin_bank *bank = gc_to_pin_bank(gc);
+	unsigned int virq;
+
+	if (!bank->domain)
+		return -ENXIO;
+
+	virq = irq_create_mapping(bank->domain, offset);
+
+	return (virq) ? : -ENXIO;
+}
+
+static const struct gpio_chip rockchip_gpiolib_chip = {
+	.set = rockchip_gpio_set,
+	.get = rockchip_gpio_get,
+	.direction_input = rockchip_gpio_direction_input,
+	.direction_output = rockchip_gpio_direction_output,
+	.to_irq = rockchip_gpio_to_irq,
+	.owner = THIS_MODULE,
+};
+
+/*
+ * Interrupt handling
+ */
+
+static void rockchip_irq_demux(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_chip *chip = irq_get_chip(irq);
+	struct rockchip_pin_bank *bank = irq_get_handler_data(irq);
+	u32 pend;
+
+	dev_dbg(bank->drvdata->dev, "got irq for bank %s\n", bank->name);
+
+	chained_irq_enter(chip, desc);
+
+	pend = readl_relaxed(bank->reg_base + GPIO_INT_STATUS);
+
+	while (pend) {
+		unsigned int virq;
+
+		irq = __ffs(pend);
+		pend &= ~(1 << irq);
+		virq = irq_linear_revmap(bank->domain, irq);
+
+		if (!virq) {
+			dev_err(bank->drvdata->dev, "unmapped irq %d\n", irq);
+			continue;
+		}
+
+		dev_dbg(bank->drvdata->dev, "handling irq %d\n", irq);
+
+		generic_handle_irq(virq);
+	}
+
+	chained_irq_exit(chip, desc);
+}
+
+static int rockchip_irq_set_type(struct irq_data *d, unsigned int type)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct rockchip_pin_bank *bank = gc->private;
+	u32 bit = (1 << d->hwirq);
+	u32 polarity;
+	u32 level;
+	u32 data;
+
+	if (type & IRQ_TYPE_EDGE_BOTH)
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
+	else
+		__irq_set_handler_locked(d->irq, handle_level_irq);
+
+	irq_gc_lock(gc);
+
+	level = readl_relaxed(gc->reg_base + GPIO_INTTYPE_LEVEL);
+	polarity = readl_relaxed(gc->reg_base + GPIO_INT_POLARITY);
+
+	switch (type) {
+	case IRQ_TYPE_EDGE_RISING:
+		level |= bit;
+		polarity |= bit;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		level |= bit;
+		polarity &= ~bit;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		level &= ~bit;
+		polarity |= bit;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		level &= ~bit;
+		polarity &= ~bit;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	writel_relaxed(level, gc->reg_base + GPIO_INTTYPE_LEVEL);
+	writel_relaxed(polarity, gc->reg_base + GPIO_INT_POLARITY);
+
+	irq_gc_unlock(gc);
+
+	/* make sure the pin is configured as gpio input */
+	rockchip_set_mux(bank, d->hwirq, RK_FUNC_GPIO);
+	data = readl_relaxed(bank->reg_base + GPIO_SWPORT_DDR);
+	data &= ~bit;
+	writel_relaxed(data, bank->reg_base + GPIO_SWPORT_DDR);
+
+	return 0;
+}
+
+static int rockchip_interrupts_register(struct platform_device *pdev,
+						struct rockchip_pinctrl *info)
+{
+	struct rockchip_pin_ctrl *ctrl = info->ctrl;
+	struct rockchip_pin_bank *bank = ctrl->pin_banks;
+	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	struct irq_chip_generic *gc;
+	int ret;
+	int i;
+
+	for (i = 0; i < ctrl->nr_banks; ++i, ++bank) {
+		if (!bank->valid) {
+			dev_warn(&pdev->dev, "bank %s is not valid\n",
+				 bank->name);
+			continue;
+		}
+
+		bank->domain = irq_domain_add_linear(bank->of_node, 32,
+						&irq_generic_chip_ops, NULL);
+		if (!bank->domain) {
+			dev_warn(&pdev->dev, "could not initialize irq domain for bank %s\n",
+				 bank->name);
+			continue;
+		}
+
+		ret = irq_alloc_domain_generic_chips(bank->domain, 32, 1,
+					 "rockchip_gpio_irq", handle_level_irq,
+					 clr, 0, IRQ_GC_INIT_MASK_CACHE);
+		if (ret) {
+			dev_err(&pdev->dev, "could not alloc generic chips for bank %s\n",
+				bank->name);
+			irq_domain_remove(bank->domain);
+			continue;
+		}
+
+		gc = irq_get_domain_generic_chip(bank->domain, 0);
+		gc->reg_base = bank->reg_base;
+		gc->private = bank;
+		gc->chip_types[0].regs.mask = GPIO_INTEN;
+		gc->chip_types[0].regs.ack = GPIO_PORTS_EOI;
+		gc->chip_types[0].chip.irq_ack = irq_gc_ack_set_bit;
+		gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
+		gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
+		gc->chip_types[0].chip.irq_set_wake = irq_gc_set_wake;
+		gc->chip_types[0].chip.irq_set_type = rockchip_irq_set_type;
+
+		irq_set_handler_data(bank->irq, bank);
+		irq_set_chained_handler(bank->irq, rockchip_irq_demux);
+	}
+
+	return 0;
+}
+
+static int rockchip_gpiolib_register(struct platform_device *pdev,
+						struct rockchip_pinctrl *info)
+{
+	struct rockchip_pin_ctrl *ctrl = info->ctrl;
+	struct rockchip_pin_bank *bank = ctrl->pin_banks;
+	struct gpio_chip *gc;
+	int ret;
+	int i;
+
+	for (i = 0; i < ctrl->nr_banks; ++i, ++bank) {
+		if (!bank->valid) {
+			dev_warn(&pdev->dev, "bank %s is not valid\n",
+				 bank->name);
+			continue;
+		}
+
+		bank->gpio_chip = rockchip_gpiolib_chip;
+
+		gc = &bank->gpio_chip;
+		gc->base = bank->pin_base;
+		gc->ngpio = bank->nr_pins;
+		gc->dev = &pdev->dev;
+		gc->of_node = bank->of_node;
+		gc->label = bank->name;
+
+		ret = gpiochip_add(gc);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to register gpio_chip %s, error code: %d\n",
+							gc->label, ret);
+			goto fail;
+		}
+	}
+
+	rockchip_interrupts_register(pdev, info);
+
+	return 0;
+
+fail:
+	for (--i, --bank; i >= 0; --i, --bank) {
+		if (!bank->valid)
+			continue;
+
+		if (gpiochip_remove(&bank->gpio_chip))
+			dev_err(&pdev->dev, "gpio chip %s remove failed\n",
+							bank->gpio_chip.label);
+	}
+	return ret;
+}
+
+static int rockchip_gpiolib_unregister(struct platform_device *pdev,
+						struct rockchip_pinctrl *info)
+{
+	struct rockchip_pin_ctrl *ctrl = info->ctrl;
+	struct rockchip_pin_bank *bank = ctrl->pin_banks;
+	int ret = 0;
+	int i;
+
+	for (i = 0; !ret && i < ctrl->nr_banks; ++i, ++bank) {
+		if (!bank->valid)
+			continue;
+
+		ret = gpiochip_remove(&bank->gpio_chip);
+	}
+
+	if (ret)
+		dev_err(&pdev->dev, "gpio chip remove failed\n");
+
+	return ret;
+}
+
+static int rockchip_get_bank_data(struct rockchip_pin_bank *bank,
+				  struct device *dev)
+{
+	struct resource res;
+
+	if (of_address_to_resource(bank->of_node, 0, &res)) {
+		dev_err(dev, "cannot find IO resource for bank\n");
+		return -ENOENT;
+	}
+
+	bank->reg_base = devm_ioremap_resource(dev, &res);
+	if (IS_ERR(bank->reg_base))
+		return PTR_ERR(bank->reg_base);
+
+	bank->irq = irq_of_parse_and_map(bank->of_node, 0);
+
+	bank->clk = of_clk_get(bank->of_node, 0);
+	if (IS_ERR(bank->clk))
+		return PTR_ERR(bank->clk);
+
+	return clk_prepare_enable(bank->clk);
+}
+
+static const struct of_device_id rockchip_pinctrl_dt_match[];
+
+/* retrieve the soc specific data */
+static struct rockchip_pin_ctrl *rockchip_pinctrl_get_soc_data(
+						struct rockchip_pinctrl *d,
+						struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	struct device_node *node = pdev->dev.of_node;
+	struct device_node *np;
+	struct rockchip_pin_ctrl *ctrl;
+	struct rockchip_pin_bank *bank;
+	int i;
+
+	match = of_match_node(rockchip_pinctrl_dt_match, node);
+	ctrl = (struct rockchip_pin_ctrl *)match->data;
+
+	for_each_child_of_node(node, np) {
+		if (!of_find_property(np, "gpio-controller", NULL))
+			continue;
+
+		bank = ctrl->pin_banks;
+		for (i = 0; i < ctrl->nr_banks; ++i, ++bank) {
+			if (!strcmp(bank->name, np->name)) {
+				bank->of_node = np;
+
+				if (!rockchip_get_bank_data(bank, &pdev->dev))
+					bank->valid = true;
+
+				break;
+			}
+		}
+	}
+
+	bank = ctrl->pin_banks;
+	for (i = 0; i < ctrl->nr_banks; ++i, ++bank) {
+		spin_lock_init(&bank->slock);
+		bank->drvdata = d;
+		bank->pin_base = ctrl->nr_pins;
+		ctrl->nr_pins += bank->nr_pins;
+	}
+
+	return ctrl;
+}
+
+static int rockchip_pinctrl_probe(struct platform_device *pdev)
+{
+	struct rockchip_pinctrl *info;
+	struct device *dev = &pdev->dev;
+	struct rockchip_pin_ctrl *ctrl;
+	struct resource *res;
+	int ret;
+
+	if (!dev->of_node) {
+		dev_err(dev, "device tree node not found\n");
+		return -ENODEV;
+	}
+
+	info = devm_kzalloc(dev, sizeof(struct rockchip_pinctrl), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	ctrl = rockchip_pinctrl_get_soc_data(info, pdev);
+	if (!ctrl) {
+		dev_err(dev, "driver data not available\n");
+		return -EINVAL;
+	}
+	info->ctrl = ctrl;
+	info->dev = dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "cannot find IO resource\n");
+		return -ENOENT;
+	}
+
+	info->reg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(info->reg_base))
+		return PTR_ERR(info->reg_base);
+
+	ret = rockchip_gpiolib_register(pdev, info);
+	if (ret)
+		return ret;
+
+	ret = rockchip_pinctrl_register(pdev, info);
+	if (ret) {
+		rockchip_gpiolib_unregister(pdev, info);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, info);
+
+	return 0;
+}
+
+static struct rockchip_pin_bank rk2928_pin_banks[] = {
+	PIN_BANK(0, 32, "gpio0"),
+	PIN_BANK(1, 32, "gpio1"),
+	PIN_BANK(2, 32, "gpio2"),
+	PIN_BANK(3, 32, "gpio3"),
+};
+
+static struct rockchip_pin_ctrl rk2928_pin_ctrl = {
+		.pin_banks	= rk2928_pin_banks,
+		.nr_banks	= ARRAY_SIZE(rk2928_pin_banks),
+		.label		= "RK2928-GPIO",
+		.mux_offset	= 0xa8,
+		.pull_offset	= 0x118,
+		.pull_auto	= 1,
+};
+
+static struct rockchip_pin_bank rk3066a_pin_banks[] = {
+	PIN_BANK(0, 32, "gpio0"),
+	PIN_BANK(1, 32, "gpio1"),
+	PIN_BANK(2, 32, "gpio2"),
+	PIN_BANK(3, 32, "gpio3"),
+	PIN_BANK(4, 32, "gpio4"),
+	PIN_BANK(6, 16, "gpio6"),
+};
+
+static struct rockchip_pin_ctrl rk3066a_pin_ctrl = {
+		.pin_banks	= rk3066a_pin_banks,
+		.nr_banks	= ARRAY_SIZE(rk3066a_pin_banks),
+		.label		= "RK3066a-GPIO",
+		.mux_offset	= 0xa8,
+		.pull_offset	= 0x118,
+		.pull_auto	= 1,
+};
+
+static struct rockchip_pin_bank rk3066b_pin_banks[] = {
+	PIN_BANK(0, 32, "gpio0"),
+	PIN_BANK(1, 32, "gpio1"),
+	PIN_BANK(2, 32, "gpio2"),
+	PIN_BANK(3, 32, "gpio3"),
+};
+
+static struct rockchip_pin_ctrl rk3066b_pin_ctrl = {
+		.pin_banks	= rk3066b_pin_banks,
+		.nr_banks	= ARRAY_SIZE(rk3066b_pin_banks),
+		.label		= "RK3066b-GPIO",
+		.mux_offset	= 0x60,
+		.pull_offset	= -EINVAL,
+};
+
+static struct rockchip_pin_bank rk3188_pin_banks[] = {
+	PIN_BANK(0, 32, "gpio0"),
+	PIN_BANK(1, 32, "gpio1"),
+	PIN_BANK(2, 32, "gpio2"),
+	PIN_BANK(3, 32, "gpio3"),
+};
+
+static struct rockchip_pin_ctrl rk3188_pin_ctrl = {
+		.pin_banks	= rk3188_pin_banks,
+		.nr_banks	= ARRAY_SIZE(rk3188_pin_banks),
+		.label		= "RK3188-GPIO",
+		.mux_offset	= 0x68,
+		.pull_offset	= 0x164,
+};
+
+static const struct of_device_id rockchip_pinctrl_dt_match[] = {
+	{ .compatible = "rockchip,rk2928-pinctrl",
+		.data = (void *)&rk2928_pin_ctrl },
+	{ .compatible = "rockchip,rk3066a-pinctrl",
+		.data = (void *)&rk3066a_pin_ctrl },
+	{ .compatible = "rockchip,rk3066b-pinctrl",
+		.data = (void *)&rk3066b_pin_ctrl },
+	{ .compatible = "rockchip,rk3188-pinctrl",
+		.data = (void *)&rk3188_pin_ctrl },
+	{},
+};
+MODULE_DEVICE_TABLE(of, rockchip_pinctrl_dt_match);
+
+static struct platform_driver rockchip_pinctrl_driver = {
+	.probe		= rockchip_pinctrl_probe,
+	.driver = {
+		.name	= "rockchip-pinctrl",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(rockchip_pinctrl_dt_match),
+	},
+};
+
+static int __init rockchip_pinctrl_drv_register(void)
+{
+	return platform_driver_register(&rockchip_pinctrl_driver);
+}
+postcore_initcall(rockchip_pinctrl_drv_register);
+
+MODULE_AUTHOR("Heiko Stuebner <heiko@sntech.de>");
+MODULE_DESCRIPTION("Rockchip pinctrl driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/dt-bindings/pinctrl/rockchip.h b/include/dt-bindings/pinctrl/rockchip.h
new file mode 100644
index 0000000..8721db2
--- /dev/null
+++ b/include/dt-bindings/pinctrl/rockchip.h
@@ -0,0 +1,37 @@
+/*
+ * Header providing constants for Rockchip pinctrl bindings.
+ *
+ * Copyright (c) 2013 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __DT_BINDINGS_ROCKCHIP_PINCTRL_H__
+#define __DT_BINDINGS_ROCKCHIP_PINCTRL_H__
+
+#define RK_GPIO0	0
+#define RK_GPIO1	1
+#define RK_GPIO2	2
+#define RK_GPIO3	3
+#define RK_GPIO4	4
+#define RK_GPIO6	6
+
+#define RK_FUNC_GPIO	0
+#define RK_FUNC_1	1
+#define RK_FUNC_2	2
+
+#define RK_PINCTRL_NONE		0
+#define RK_PINCTRL_PULL_AUTO	(1 << 0)
+#define RK_PINCTRL_PULL_UP	(1 << 1)
+#define RK_PINCTRL_PULL_DOWN	(1 << 2)
+
+#endif
-- 
1.7.2.3

