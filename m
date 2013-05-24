Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3EXQWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:22:54 -0400
Received: from multi.imgtec.com ([194.200.65.239]:59976 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab3EXQW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:22:26 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, "Rob Landley" <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 8/9] pinctrl-tz1090-pdc: add TZ1090 PDC pinctrl driver
Date: Fri, 24 May 2013 17:21:15 +0100
Message-ID: <1369412476-14245-9-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_24_17_22_18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pin control driver for the TZ1090's low power pins via the
powerdown controller SOC_GPIO_CONTROL registers.

These pins have individually controlled pull-up, and group controlled
schmitt, slew-rate, drive-strength, and power-on-start (pos).

The pdc_gpio0 and pdc_gpio1 pins can also be muxed onto the
ir_mod_stable_out and ir_mod_power_out functions respectively. If no
function is set they remain in GPIO mode. These muxes can be overridden
by requesting them as GPIOs.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-doc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
---
Changes in v2:
 - pinctrl-tz1090-pdc: switched to generic pinconf (a previous patch
   adds the BIAS_BUS_HOLD generic pinconf)
 - pinctrl-tz1090-pdc: changed device tree bindings to more closely
   match generic pinconf (separate tristate, pull-up, pull-down,
   bus-hold flags instead of pull=<X>, drive-strength measured in mA)
 - pinctrl-tz1090-pdc: make use of BIT() from linux/bitops.h
 - pinctrl-tz1090-pdc: add a whole bunch of comments

 .../bindings/pinctrl/img,tz1090-pdc-pinctrl.txt    |  128 +++
 arch/metag/Kconfig.soc                             |    1 +
 arch/metag/boot/dts/tz1090.dtsi                    |    6 +
 drivers/pinctrl/Kconfig                            |    6 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-tz1090-pdc.c               | 1105 ++++++++++++++++++++
 6 files changed, 1247 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-tz1090-pdc.c

diff --git a/Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt
new file mode 100644
index 0000000..b899b1f
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt
@@ -0,0 +1,128 @@
+ImgTec TZ1090 PDC pin controller
+
+Required properties:
+- compatible: "img,tz1090-pdc-pinctrl"
+- reg: Should contain the register physical address and length of the
+  SOC_GPIO_CONTROL registers in the PDC register region.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+TZ1090-PDC's pin configuration nodes act as a container for an abitrary number
+of subnodes. Each of these subnodes represents some desired configuration for a
+pin, a group, or a list of pins or groups. This configuration can include the
+mux function to select on those pin(s)/group(s), and various pin configuration
+parameters, such as pull-up, drive strength, etc.
+
+The name of each subnode is not important; all subnodes should be enumerated
+and processed purely based on their content.
+
+Each subnode only affects those parameters that are explicitly listed. In
+other words, a subnode that lists a mux function but no pin configuration
+parameters implies no information about any pin configuration parameters.
+Similarly, a pin subnode that describes a pullup parameter implies no
+information about e.g. the mux function. For this reason, even seemingly boolean
+values are actually tristates in this binding: unspecified, off, or on.
+Unspecified is represented as an absent property, and off/on are represented as
+integer values 0 and 1.
+
+Required subnode-properties:
+- pins : An array of strings. Each string contains the name of a pin or group.
+    Valid values for these names are listed below.
+
+Optional subnode-properties:
+- function: A string containing the name of the function to mux to the pin or
+  group. Valid values for function names are listed below, including which
+  pingroups can be muxed to them.
+- tristate: Flag, put pin into high impedance state.
+- pull-up: Flag, pull pin high.
+- pull-down: Flag: pull pin low.
+- bus-hold: Flag, weak latch last value on tristate bus.
+- schmitt: Integer, enable or disable Schmitt trigger mode for the pins.
+    0: no hysteresis
+    1: schmitt trigger
+- slew-rate: Integer, control slew rate of pins.
+    0: slow (half frequency)
+    1: fast
+- drive-strength: Integer, control drive strength of pins in mA.
+    2:  2mA
+    4:  4mA
+    8:  8mA
+    12: 12mA
+- power-on-start: Integer, power on start value of pins
+    0: weak pull-down disabled
+    1: weak pull-down for invalid power
+
+Note that many of these properties are only valid for certain specific pins
+or groups. See the TZ1090 TRM for complete details regarding which groups
+support which functionality. The Linux pinctrl driver may also be a useful
+reference.
+
+Valid values for pin and group names are:
+
+  pins:
+
+    These all support tristate, pull-up, pull-down, and bus-hold (which can also
+    be provided to any of the groups below to set it for all gpio pins in that
+    group).
+
+    gpio0, gpio1, sys_wake0, sys_wake1, sys_wake2, ir_data, ext_power.
+
+  mux groups:
+
+    These all support function.
+
+    gpio0
+        pins:       gpio0.
+        function:   ir_mod_stable_out.
+    gpio1
+        pins:       gpio1.
+        function:   ir_mod_power_out.
+
+  drive groups:
+
+    These support schmitt, slew-rate, drive-strength, and power-on-start.
+
+    pdc
+        pins:   gpio0, gpio1, sys_wake0, sys_wake1, sys_wake2, ir_data,
+                ext_power.
+
+Example:
+
+	pinctrl_pdc: pinctrl@02006500 {
+		#gpio-range-cells = <3>;
+		compatible = "img,tz1090-pdc-pinctrl";
+		reg = <0x02006500 0x100>;
+	};
+
+Example board file extracts:
+
+	&pinctrl_pdc {
+		pinctrl-names = "default";
+		pinctrl-0 = <&syswake_default>;
+
+		syswake_default: syswakes {
+			syswake_cfg {
+				pins =	"sys_wake0",
+					"sys_wake1",
+					"sys_wake2";
+				pull-up;
+			};
+		};
+		irmod_default: irmod {
+			gpio0_cfg {
+				pins =	"gpio0";
+				function = "ir_mod_stable_out";
+			};
+			gpio1_cfg {
+				pins =	"gpio1";
+				function = "ir_mod_power_out";
+			};
+		};
+	};
+
+	ir: ir@02006200 {
+		pinctrl-names = "default";
+		pinctrl-0 = <&irmod_default>;
+	};
diff --git a/arch/metag/Kconfig.soc b/arch/metag/Kconfig.soc
index d61d687..973640f 100644
--- a/arch/metag/Kconfig.soc
+++ b/arch/metag/Kconfig.soc
@@ -23,6 +23,7 @@ config SOC_TZ1090
 	select METAG_SMP_WRITE_REORDERING
 	select PINCTRL
 	select PINCTRL_TZ1090
+	select PINCTRL_TZ1090_PDC
 	help
 	  This is a Toumaz Technology Xenif TZ1090 (A.K.A. Comet) SoC containing
 	  a 2-threaded HTP.
diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index fdd382d..e2e61a8 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -48,6 +48,12 @@
 			reg = <0x02005800 0xe4>;
 		};
 
+		pdc_pinctrl: pinctrl@02006500 {
+			#gpio-range-cells = <3>;
+			compatible = "img,tz1090-pdc-pinctrl";
+			reg = <0x02006500 0x100>;
+		};
+
 		gpios: gpios@02005800 {
 			#address-cells = <1>;
 			#size-cells = <0>;
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index d9ae8e8..f1b9d27 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -192,6 +192,12 @@ config PINCTRL_TZ1090
 	select PINMUX
 	select GENERIC_PINCONF
 
+config PINCTRL_TZ1090_PDC
+	bool "Toumaz Xenif TZ1090 PDC pin control driver"
+	depends on SOC_TZ1090
+	select PINMUX
+	select PINCONF
+
 config PINCTRL_U300
 	bool "U300 pin controller driver"
 	depends on ARCH_U300
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 7514305..8aae378 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_PINCTRL_TEGRA20)	+= pinctrl-tegra20.o
 obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
 obj-$(CONFIG_PINCTRL_TEGRA114)	+= pinctrl-tegra114.o
 obj-$(CONFIG_PINCTRL_TZ1090)	+= pinctrl-tz1090.o
+obj-$(CONFIG_PINCTRL_TZ1090_PDC)	+= pinctrl-tz1090-pdc.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
 obj-$(CONFIG_PINCTRL_SAMSUNG)	+= pinctrl-samsung.o
diff --git a/drivers/pinctrl/pinctrl-tz1090-pdc.c b/drivers/pinctrl/pinctrl-tz1090-pdc.c
new file mode 100644
index 0000000..7fc74b9
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-tz1090-pdc.c
@@ -0,0 +1,1105 @@
+/*
+ * Pinctrl driver for the Toumaz Xenif TZ1090 PowerDown Controller pins
+ *
+ * Copyright (c) 2013, Imagination Technologies Ltd.
+ *
+ * Derived from Tegra code:
+ * Copyright (c) 2011-2012, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Derived from code:
+ * Copyright (C) 2010 Google, Inc.
+ * Copyright (C) 2010 NVIDIA Corporation
+ * Copyright (C) 2009-2011 ST-Ericsson AB
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
+#include <linux/bitops.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/pinctrl/pinconf-generic.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/slab.h>
+
+/*
+ * The registers may be shared with other threads/cores, so we need to use the
+ * metag global lock2 for atomicity.
+ */
+#include <asm/global_lock.h>
+
+#include "core.h"
+
+/* Register offsets from bank base address */
+#define REG_GPIO_CONTROL0	0x00
+#define REG_GPIO_CONTROL2	0x08
+
+/* Register field information */
+#define REG_GPIO_CONTROL2_PU_PD_S	16
+#define REG_GPIO_CONTROL2_PDC_POS_S	 4
+#define REG_GPIO_CONTROL2_PDC_DR_S	 2
+#define REG_GPIO_CONTROL2_PDC_SR_S	 1
+#define REG_GPIO_CONTROL2_PDC_SCHMITT_S	 0
+
+/* PU_PD field values */
+#define REG_PU_PD_TRISTATE	0
+#define REG_PU_PD_UP		1
+#define REG_PU_PD_DOWN		2
+#define REG_PU_PD_REPEATER	3
+
+/* DR field values */
+#define REG_DR_2mA		0
+#define REG_DR_4mA		1
+#define REG_DR_8mA		2
+#define REG_DR_12mA		3
+
+/**
+ * struct tz1090_pdc_function - TZ1090 PDC pinctrl mux function
+ * @name:	The name of the function, exported to pinctrl core.
+ * @groups:	An array of pin groups that may select this function.
+ * @ngroups:	The number of entries in @groups.
+ */
+struct tz1090_pdc_function {
+	const char		*name;
+	const char * const	*groups;
+	unsigned		ngroups;
+};
+
+/**
+ * struct tz1090_pdc_pingroup - TZ1090 PDC pin group
+ * @name:	Name of pin group.
+ * @pins:	Array of pin numbers in this pin group.
+ * @npins:	Number of pins in this pin group.
+ * @func:	Function enabled by the mux.
+ * @reg:	Mux register offset.
+ * @bit:	Mux register bit.
+ * @drv:	Drive control supported, otherwise it's a mux.
+ *		This means Schmitt, Slew, and Drive strength.
+ *
+ * A representation of a group of pins (possibly just one pin) in the TZ1090
+ * PDC pin controller. Each group allows some parameter or parameters to be
+ * configured. The most common is mux function selection.
+ */
+struct tz1090_pdc_pingroup {
+	const char		*name;
+	const unsigned int	*pins;
+	unsigned int		npins;
+	int			func;
+	u16			reg;
+	u8			bit;
+	bool			drv;
+};
+
+/*
+ * All PDC pins can be GPIOs. Define these first to match how the GPIO driver
+ * names/numbers its pins.
+ */
+
+enum tz1090_pdc_pin {
+	TZ1090_PDC_PIN_GPIO0,
+	TZ1090_PDC_PIN_GPIO1,
+	TZ1090_PDC_PIN_SYS_WAKE0,
+	TZ1090_PDC_PIN_SYS_WAKE1,
+	TZ1090_PDC_PIN_SYS_WAKE2,
+	TZ1090_PDC_PIN_IR_DATA,
+	TZ1090_PDC_PIN_EXT_POWER,
+};
+
+/* Pin names */
+
+static const struct pinctrl_pin_desc tz1090_pdc_pins[] = {
+	/* PDC GPIOs */
+	PINCTRL_PIN(TZ1090_PDC_PIN_GPIO0,	"gpio0"),
+	PINCTRL_PIN(TZ1090_PDC_PIN_GPIO1,	"gpio1"),
+	PINCTRL_PIN(TZ1090_PDC_PIN_SYS_WAKE0,	"sys_wake0"),
+	PINCTRL_PIN(TZ1090_PDC_PIN_SYS_WAKE1,	"sys_wake1"),
+	PINCTRL_PIN(TZ1090_PDC_PIN_SYS_WAKE2,	"sys_wake2"),
+	PINCTRL_PIN(TZ1090_PDC_PIN_IR_DATA,	"ir_data"),
+	PINCTRL_PIN(TZ1090_PDC_PIN_EXT_POWER,	"ext_power"),
+};
+
+/* Pin group pins */
+
+static const unsigned gpio0_pins[] = {
+	TZ1090_PDC_PIN_GPIO0,
+};
+
+static const unsigned gpio1_pins[] = {
+	TZ1090_PDC_PIN_GPIO1,
+};
+
+static const unsigned pdc_pins[] = {
+	TZ1090_PDC_PIN_GPIO0,
+	TZ1090_PDC_PIN_GPIO1,
+	TZ1090_PDC_PIN_SYS_WAKE0,
+	TZ1090_PDC_PIN_SYS_WAKE1,
+	TZ1090_PDC_PIN_SYS_WAKE2,
+	TZ1090_PDC_PIN_IR_DATA,
+	TZ1090_PDC_PIN_EXT_POWER,
+};
+
+/* Mux functions */
+
+enum tz1090_pdc_mux {
+	/* PDC_GPIO0 mux */
+	TZ1090_PDC_MUX_IR_MOD_STABLE_OUT,
+	/* PDC_GPIO1 mux */
+	TZ1090_PDC_MUX_IR_MOD_POWER_OUT,
+};
+
+/* Pin groups a function can be muxed to */
+
+static const char * const gpio0_groups[] = {
+	"gpio0",
+};
+
+static const char * const gpio1_groups[] = {
+	"gpio1",
+};
+
+#define FUNCTION(mux, fname, group)			\
+	[(TZ1090_PDC_MUX_ ## mux)] = {			\
+		.name = #fname,				\
+		.groups = group##_groups,		\
+		.ngroups = ARRAY_SIZE(group##_groups),	\
+	}
+
+/* Must correlate with enum tz1090_pdc_mux */
+static const struct tz1090_pdc_function tz1090_pdc_functions[] = {
+	/*	 MUX			fn			pingroups */
+	FUNCTION(IR_MOD_STABLE_OUT,	ir_mod_stable_out,	gpio0),
+	FUNCTION(IR_MOD_POWER_OUT,	ir_mod_power_out,	gpio1),
+};
+
+/**
+ * MUX_PG() - Initialise a pin group with mux control
+ * @pg_name:	Pin group name (stringified, _pins appended to get pins array)
+ * @f0:		Function 0 (TZ1090_PDC_MUX_ is prepended)
+ * @mux_r:	Mux register (REG_PINCTRL_ is prepended)
+ * @mux_b:	Bit number in register of mux field
+ */
+#define MUX_PG(pg_name, f0, mux_r, mux_b)			\
+	{							\
+		.name = #pg_name,				\
+		.pins = pg_name##_pins,				\
+		.npins = ARRAY_SIZE(pg_name##_pins),		\
+		.func = TZ1090_PDC_MUX_ ## f0,			\
+		.reg = (REG_ ## mux_r),				\
+		.bit = (mux_b),					\
+	}
+
+/**
+ * DRV_PG() - Initialise a pin group with drive control
+ * @pg_name:	Pin group name (stringified, _pins appended to get pins array)
+ */
+#define DRV_PG(pg_name)				\
+	{							\
+		.name = #pg_name,				\
+		.pins = pg_name##_pins,				\
+		.npins = ARRAY_SIZE(pg_name##_pins),		\
+		.drv = true,					\
+	}
+
+static const struct tz1090_pdc_pingroup tz1090_pdc_groups[] = {
+	/* Muxing pin groups */
+	/*     pg_name, f0,                 mux register,  mux bit */
+	MUX_PG(gpio0,   IR_MOD_STABLE_OUT,  GPIO_CONTROL0, 7),
+	MUX_PG(gpio1,   IR_MOD_POWER_OUT,   GPIO_CONTROL0, 6),
+
+	/* Drive pin groups */
+	/*     pg_name */
+	DRV_PG(pdc),
+};
+
+/**
+ * struct tz1090_pdc_pmx - Private pinctrl data
+ * @dev:	Platform device
+ * @pctl:	Pin control device
+ * @regs:	Register region
+ * @lock:	Lock protecting coherency of mux_en and gpio_en
+ * @mux_en:	Muxes that have been enabled
+ * @gpio_en:	Muxable GPIOs that have been enabled
+ */
+struct tz1090_pdc_pmx {
+	struct device		*dev;
+	struct pinctrl_dev	*pctl;
+	void __iomem		*regs;
+	spinlock_t		lock;
+	u32			mux_en;
+	u32			gpio_en;
+};
+
+static inline u32 pmx_read(struct tz1090_pdc_pmx *pmx, u32 reg)
+{
+	return ioread32(pmx->regs + reg);
+}
+
+static inline void pmx_write(struct tz1090_pdc_pmx *pmx, u32 val, u32 reg)
+{
+	iowrite32(val, pmx->regs + reg);
+}
+
+/*
+ * Pin control operations
+ */
+
+static int tz1090_pdc_pinctrl_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	return ARRAY_SIZE(tz1090_pdc_groups);
+}
+
+static const char *tz1090_pdc_pinctrl_get_group_name(struct pinctrl_dev *pctl,
+						     unsigned group)
+{
+	return tz1090_pdc_groups[group].name;
+}
+
+static int tz1090_pdc_pinctrl_get_group_pins(struct pinctrl_dev *pctldev,
+					     unsigned group,
+					     const unsigned **pins,
+					     unsigned *num_pins)
+{
+	*pins = tz1090_pdc_groups[group].pins;
+	*num_pins = tz1090_pdc_groups[group].npins;
+
+	return 0;
+}
+
+#ifdef CONFIG_DEBUG_FS
+static void tz1090_pdc_pinctrl_pin_dbg_show(struct pinctrl_dev *pctldev,
+					    struct seq_file *s,
+					    unsigned offset)
+{
+	seq_printf(s, " %s", dev_name(pctldev->dev));
+}
+#endif
+
+static int reserve_map(struct device *dev, struct pinctrl_map **map,
+		       unsigned *reserved_maps, unsigned *num_maps,
+		       unsigned reserve)
+{
+	unsigned old_num = *reserved_maps;
+	unsigned new_num = *num_maps + reserve;
+	struct pinctrl_map *new_map;
+
+	if (old_num >= new_num)
+		return 0;
+
+	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
+	if (!new_map) {
+		dev_err(dev, "krealloc(map) failed\n");
+		return -ENOMEM;
+	}
+
+	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
+
+	*map = new_map;
+	*reserved_maps = new_num;
+
+	return 0;
+}
+
+static int add_map_mux(struct pinctrl_map **map, unsigned *reserved_maps,
+		       unsigned *num_maps, const char *group,
+		       const char *function)
+{
+	if (WARN_ON(*num_maps == *reserved_maps))
+		return -ENOSPC;
+
+	(*map)[*num_maps].type = PIN_MAP_TYPE_MUX_GROUP;
+	(*map)[*num_maps].data.mux.group = group;
+	(*map)[*num_maps].data.mux.function = function;
+	(*num_maps)++;
+
+	return 0;
+}
+
+/**
+ * get_group_selector() - returns the group selector for a group
+ * @pin_group: the pin group to look up
+ *
+ * This is the same as pinctrl_get_group_selector except it doesn't produce an
+ * error message if the group isn't found or debug messages.
+ */
+static int get_group_selector(const char *pin_group)
+{
+	unsigned int group;
+
+	for (group = 0; group < ARRAY_SIZE(tz1090_pdc_groups); ++group)
+		if (!strcmp(tz1090_pdc_groups[group].name, pin_group))
+			return group;
+
+	return -EINVAL;
+}
+
+static int add_map_configs(struct device *dev,
+			   struct pinctrl_map **map,
+			   unsigned *reserved_maps, unsigned *num_maps,
+			   const char *group, unsigned long *configs,
+			   unsigned num_configs)
+{
+	unsigned long *dup_configs;
+	enum pinctrl_map_type type;
+
+	if (WARN_ON(*num_maps == *reserved_maps))
+		return -ENOSPC;
+
+	dup_configs = kmemdup(configs, num_configs * sizeof(*dup_configs),
+			      GFP_KERNEL);
+	if (!dup_configs) {
+		dev_err(dev, "kmemdup(configs) failed\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * We support both pins and pin groups, but we need to figure out which
+	 * one we have.
+	 */
+	if (get_group_selector(group) >= 0)
+		type = PIN_MAP_TYPE_CONFIGS_GROUP;
+	else
+		type = PIN_MAP_TYPE_CONFIGS_PIN;
+	(*map)[*num_maps].type = type;
+	(*map)[*num_maps].data.configs.group_or_pin = group;
+	(*map)[*num_maps].data.configs.configs = dup_configs;
+	(*map)[*num_maps].data.configs.num_configs = num_configs;
+	(*num_maps)++;
+
+	return 0;
+}
+
+static int add_config(struct device *dev, unsigned long **configs,
+		      unsigned *num_configs, unsigned long config)
+{
+	unsigned old_num = *num_configs;
+	unsigned new_num = old_num + 1;
+	unsigned long *new_configs;
+
+	new_configs = krealloc(*configs, sizeof(*new_configs) * new_num,
+			       GFP_KERNEL);
+	if (!new_configs) {
+		dev_err(dev, "krealloc(configs) failed\n");
+		return -ENOMEM;
+	}
+
+	new_configs[old_num] = config;
+
+	*configs = new_configs;
+	*num_configs = new_num;
+
+	return 0;
+}
+
+void tz1090_pdc_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
+				    struct pinctrl_map *map, unsigned num_maps)
+{
+	int i;
+
+	for (i = 0; i < num_maps; i++)
+		if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
+			kfree(map[i].data.configs.configs);
+
+	kfree(map);
+}
+
+/* Describes pinconf properties/flags available from device tree */
+static const struct cfg_param {
+	const char *property;
+	enum pin_config_param param;
+	bool flag;
+} cfg_params[] = {
+	{"tristate",		PIN_CONFIG_BIAS_HIGH_IMPEDANCE,		true},
+	{"pull-up",		PIN_CONFIG_BIAS_PULL_UP,		true},
+	{"pull-down",		PIN_CONFIG_BIAS_PULL_DOWN,		true},
+	{"bus-hold",		PIN_CONFIG_BIAS_BUS_HOLD,		true},
+	{"power-on-start",	PIN_CONFIG_LOW_POWER_MODE,		true},
+	{"schmitt",		PIN_CONFIG_INPUT_SCHMITT_ENABLE,	true},
+	{"slew-rate",		PIN_CONFIG_SLEW_RATE,			false},
+	{"drive-strength",	PIN_CONFIG_DRIVE_STRENGTH,		false},
+
+};
+
+int tz1090_pdc_pinctrl_dt_subnode_to_map(struct device *dev,
+					 struct device_node *np,
+					 struct pinctrl_map **map,
+					 unsigned *reserved_maps,
+					 unsigned *num_maps)
+{
+	int ret, i;
+	const char *function;
+	u32 val;
+	unsigned long config;
+	unsigned long *configs = NULL;
+	unsigned num_configs = 0;
+	unsigned reserve;
+	struct property *prop;
+	const char *group;
+
+	ret = of_property_read_string(np, "function", &function);
+	if (ret < 0) {
+		/* EINVAL=missing, which is fine since it's optional */
+		if (ret != -EINVAL)
+			dev_err(dev,
+				"could not parse property function\n");
+		function = NULL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
+		ret = of_property_read_u32(np, cfg_params[i].property, &val);
+		/* flags don't have to have a value */
+		if (ret == -EOVERFLOW && cfg_params[i].flag) {
+			val = 1;
+			ret = 0;
+		}
+		if (!ret) {
+			config = pinconf_to_config_packed(cfg_params[i].param,
+							  val);
+			ret = add_config(dev, &configs, &num_configs, config);
+			if (ret < 0)
+				goto exit;
+		/* EINVAL=missing, which is fine since it's optional */
+		} else if (ret != -EINVAL) {
+			dev_err(dev, "could not parse property %s\n",
+				cfg_params[i].property);
+		}
+	}
+
+	reserve = 0;
+	if (function != NULL)
+		reserve++;
+	if (num_configs)
+		reserve++;
+	ret = of_property_count_strings(np, "pins");
+	if (ret < 0) {
+		dev_err(dev, "could not parse property pins\n");
+		goto exit;
+	}
+	reserve *= ret;
+
+	ret = reserve_map(dev, map, reserved_maps, num_maps, reserve);
+	if (ret < 0)
+		goto exit;
+
+	of_property_for_each_string(np, "pins", prop, group) {
+		if (function) {
+			ret = add_map_mux(map, reserved_maps, num_maps,
+					  group, function);
+			if (ret < 0)
+				goto exit;
+		}
+
+		if (num_configs) {
+			ret = add_map_configs(dev, map, reserved_maps,
+					      num_maps, group, configs,
+					      num_configs);
+			if (ret < 0)
+				goto exit;
+		}
+	}
+
+	ret = 0;
+
+exit:
+	kfree(configs);
+	return ret;
+}
+
+int tz1090_pdc_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
+				      struct device_node *np_config,
+				      struct pinctrl_map **map,
+				      unsigned *num_maps)
+{
+	unsigned reserved_maps;
+	struct device_node *np;
+	int ret;
+
+	reserved_maps = 0;
+	*map = NULL;
+	*num_maps = 0;
+
+	for_each_child_of_node(np_config, np) {
+		ret = tz1090_pdc_pinctrl_dt_subnode_to_map(pctldev->dev, np,
+							   map, &reserved_maps,
+							   num_maps);
+		if (ret < 0) {
+			tz1090_pdc_pinctrl_dt_free_map(pctldev, *map,
+						       *num_maps);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static struct pinctrl_ops tz1090_pdc_pinctrl_ops = {
+	.get_groups_count	= tz1090_pdc_pinctrl_get_groups_count,
+	.get_group_name		= tz1090_pdc_pinctrl_get_group_name,
+	.get_group_pins		= tz1090_pdc_pinctrl_get_group_pins,
+#ifdef CONFIG_DEBUG_FS
+	.pin_dbg_show		= tz1090_pdc_pinctrl_pin_dbg_show,
+#endif
+	.dt_node_to_map		= tz1090_pdc_pinctrl_dt_node_to_map,
+	.dt_free_map		= tz1090_pdc_pinctrl_dt_free_map,
+};
+
+/*
+ * Pin mux operations
+ */
+
+static int tz1090_pdc_pinctrl_get_funcs_count(struct pinctrl_dev *pctldev)
+{
+	return ARRAY_SIZE(tz1090_pdc_functions);
+}
+
+static const char *tz1090_pdc_pinctrl_get_func_name(struct pinctrl_dev *pctldev,
+						    unsigned function)
+{
+	return tz1090_pdc_functions[function].name;
+}
+
+static int tz1090_pdc_pinctrl_get_func_groups(struct pinctrl_dev *pctldev,
+					      unsigned function,
+					      const char * const **groups,
+					      unsigned * const num_groups)
+{
+	*groups = tz1090_pdc_functions[function].groups;
+	*num_groups = tz1090_pdc_functions[function].ngroups;
+
+	return 0;
+}
+
+/**
+ * tz1090_pdc_pinctrl_mux() - update mux bit
+ * @pmx:		Pinmux data
+ * @grp:		Pin mux group
+ */
+static void tz1090_pdc_pinctrl_mux(struct tz1090_pdc_pmx *pmx,
+				   const struct tz1090_pdc_pingroup *grp)
+{
+	u32 reg, select;
+	unsigned int pin_shift = grp->pins[0];
+	unsigned long flags;
+
+	/* select = mux && !gpio */
+	select = ((pmx->mux_en & ~pmx->gpio_en) >> pin_shift) & 1;
+
+	/* set up the mux */
+	__global_lock2(flags);
+	reg = pmx_read(pmx, grp->reg);
+	reg &= ~BIT(grp->bit);
+	reg |= select << grp->bit;
+	pmx_write(pmx, reg, grp->reg);
+	__global_unlock2(flags);
+}
+
+static int tz1090_pdc_pinctrl_enable(struct pinctrl_dev *pctldev,
+				     unsigned function, unsigned group)
+{
+	struct tz1090_pdc_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tz1090_pdc_pingroup *grp = &tz1090_pdc_groups[group];
+
+	dev_dbg(pctldev->dev, "%s(func=%u (%s), group=%u (%s))\n",
+		__func__,
+		function, tz1090_pdc_functions[function].name,
+		group, tz1090_pdc_groups[group].name);
+
+	/* is it even a mux? */
+	if (grp->drv)
+		return -EINVAL;
+
+	/* does this group even control the function? */
+	if (function != grp->func)
+		return -EINVAL;
+
+	/* record the pin being muxed and update mux bit */
+	spin_lock(&pmx->lock);
+	pmx->mux_en |= BIT(grp->pins[0]);
+	tz1090_pdc_pinctrl_mux(pmx, grp);
+	spin_unlock(&pmx->lock);
+	return 0;
+}
+
+static void tz1090_pdc_pinctrl_disable(struct pinctrl_dev *pctldev,
+				       unsigned function, unsigned group)
+{
+	struct tz1090_pdc_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tz1090_pdc_pingroup *grp = &tz1090_pdc_groups[group];
+
+	dev_dbg(pctldev->dev, "%s(func=%u (%s), group=%u (%s))\n",
+		__func__,
+		function, tz1090_pdc_functions[function].name,
+		group, tz1090_pdc_groups[group].name);
+
+	/* is it even a mux? */
+	if (grp->drv)
+		return;
+
+	/* does this group even control the function? */
+	if (function != grp->func)
+		return;
+
+	/* record the pin being unmuxed and update mux bit */
+	spin_lock(&pmx->lock);
+	pmx->mux_en &= ~BIT(grp->pins[0]);
+	tz1090_pdc_pinctrl_mux(pmx, grp);
+	spin_unlock(&pmx->lock);
+}
+
+static const struct tz1090_pdc_pingroup *find_mux_group(
+						struct tz1090_pdc_pmx *pmx,
+						unsigned int pin)
+{
+	const struct tz1090_pdc_pingroup *grp;
+	unsigned int group;
+
+	grp = tz1090_pdc_groups;
+	for (group = 0; group < ARRAY_SIZE(tz1090_pdc_groups); ++group, ++grp) {
+		/* only match muxes */
+		if (grp->drv)
+			continue;
+
+		/* with a matching pin */
+		if (grp->pins[0] == pin)
+			return grp;
+	}
+
+	return NULL;
+}
+
+static int tz1090_pdc_pinctrl_gpio_request_enable(
+					struct pinctrl_dev *pctldev,
+					struct pinctrl_gpio_range *range,
+					unsigned int pin)
+{
+	struct tz1090_pdc_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tz1090_pdc_pingroup *grp = find_mux_group(pmx, pin);
+
+	if (grp) {
+		/* record the pin in GPIO use and update mux bit */
+		spin_lock(&pmx->lock);
+		pmx->gpio_en |= BIT(pin);
+		tz1090_pdc_pinctrl_mux(pmx, grp);
+		spin_unlock(&pmx->lock);
+	}
+	return 0;
+}
+
+static void tz1090_pdc_pinctrl_gpio_disable_free(
+					struct pinctrl_dev *pctldev,
+					struct pinctrl_gpio_range *range,
+					unsigned int pin)
+{
+	struct tz1090_pdc_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tz1090_pdc_pingroup *grp = find_mux_group(pmx, pin);
+
+	if (grp) {
+		/* record the pin not in GPIO use and update mux bit */
+		spin_lock(&pmx->lock);
+		pmx->gpio_en &= ~BIT(pin);
+		tz1090_pdc_pinctrl_mux(pmx, grp);
+		spin_unlock(&pmx->lock);
+	}
+}
+
+static struct pinmux_ops tz1090_pdc_pinmux_ops = {
+	.get_functions_count	= tz1090_pdc_pinctrl_get_funcs_count,
+	.get_function_name	= tz1090_pdc_pinctrl_get_func_name,
+	.get_function_groups	= tz1090_pdc_pinctrl_get_func_groups,
+	.enable			= tz1090_pdc_pinctrl_enable,
+	.disable		= tz1090_pdc_pinctrl_disable,
+	.gpio_request_enable	= tz1090_pdc_pinctrl_gpio_request_enable,
+	.gpio_disable_free	= tz1090_pdc_pinctrl_gpio_disable_free,
+};
+
+/*
+ * Pin config operations
+ */
+
+static int tz1090_pdc_pinconf_reg(struct pinctrl_dev *pctldev,
+				  unsigned int pin,
+				  enum pin_config_param param,
+				  bool report_err,
+				  u32 *reg, u32 *width, u32 *mask, u32 *shift,
+				  u32 *val)
+{
+	/* Find information about parameter's register */
+	switch (param) {
+	case PIN_CONFIG_BIAS_DISABLE:
+	case PIN_CONFIG_BIAS_HIGH_IMPEDANCE:
+		*val = REG_PU_PD_TRISTATE;
+		break;
+	case PIN_CONFIG_BIAS_PULL_UP:
+		*val = REG_PU_PD_UP;
+		break;
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+		*val = REG_PU_PD_DOWN;
+		break;
+	case PIN_CONFIG_BIAS_BUS_HOLD:
+		*val = REG_PU_PD_REPEATER;
+		break;
+	default:
+		return -ENOTSUPP;
+	};
+
+	/* Only input bias parameters supported */
+	*reg = REG_GPIO_CONTROL2;
+	*shift = REG_GPIO_CONTROL2_PU_PD_S + pin*2;
+	*width = 2;
+
+	/* Calculate field information */
+	*mask = (BIT(*width) - 1) << *shift;
+
+	return 0;
+}
+
+static int tz1090_pdc_pinconf_get(struct pinctrl_dev *pctldev,
+				  unsigned pin, unsigned long *config)
+{
+	struct tz1090_pdc_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	enum pin_config_param param = pinconf_to_config_param(*config);
+	int ret;
+	u32 reg, width, mask, shift, val, tmp, arg;
+
+	/* Get register information */
+	ret = tz1090_pdc_pinconf_reg(pctldev, pin, param, true,
+				     &reg, &width, &mask, &shift, &val);
+	if (ret < 0)
+		return ret;
+
+	/* Extract field from register */
+	tmp = pmx_read(pmx, reg);
+	arg = ((tmp & mask) >> shift) == val;
+
+	/* Config not active */
+	if (!arg)
+		return -EINVAL;
+
+	/* And pack config */
+	*config = pinconf_to_config_packed(param, arg);
+
+	return 0;
+}
+
+static int tz1090_pdc_pinconf_set(struct pinctrl_dev *pctldev,
+				  unsigned pin, unsigned long config)
+{
+	struct tz1090_pdc_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	enum pin_config_param param = pinconf_to_config_param(config);
+	unsigned int arg = pinconf_to_config_argument(config);
+	int ret;
+	u32 reg, width, mask, shift, val, tmp;
+	unsigned long flags;
+
+	dev_dbg(pctldev->dev, "%s(pin=%s, config=%#lx)\n",
+		__func__, tz1090_pdc_pins[pin].name, config);
+
+	/* Get register information */
+	ret = tz1090_pdc_pinconf_reg(pctldev, pin, param, true,
+				     &reg, &width, &mask, &shift, &val);
+	if (ret < 0)
+		return ret;
+
+	/* Unpack argument and range check it */
+	if (arg > 1) {
+		dev_dbg(pctldev->dev, "%s: arg %u out of range\n",
+			__func__, arg);
+		return -EINVAL;
+	}
+
+	/* Write register field */
+	__global_lock2(flags);
+	tmp = pmx_read(pmx, reg);
+	tmp &= ~mask;
+	if (arg)
+		tmp |= val << shift;
+	pmx_write(pmx, tmp, reg);
+	__global_unlock2(flags);
+
+	return 0;
+}
+
+static const int tz1090_pdc_boolean_map[] = {
+	[0]		= -EINVAL,
+	[1]		= 1,
+};
+
+static const int tz1090_pdc_dr_map[] = {
+	[REG_DR_2mA]	= 2,
+	[REG_DR_4mA]	= 4,
+	[REG_DR_8mA]	= 8,
+	[REG_DR_12mA]	= 12,
+};
+
+static int tz1090_pdc_pinconf_group_reg(struct pinctrl_dev *pctldev,
+					const struct tz1090_pdc_pingroup *g,
+					enum pin_config_param param,
+					bool report_err, u32 *reg, u32 *width,
+					u32 *mask, u32 *shift, const int **map)
+{
+	/* Drive configuration applies in groups, but not to all groups. */
+	if (!g->drv) {
+		if (report_err)
+			dev_dbg(pctldev->dev,
+				"%s: group %s has no drive control\n",
+				__func__, g->name);
+		return -ENOTSUPP;
+	}
+
+	/* Find information about drive parameter's register */
+	*reg = REG_GPIO_CONTROL2;
+	switch (param) {
+	case PIN_CONFIG_INPUT_SCHMITT_ENABLE:
+		*shift = REG_GPIO_CONTROL2_PDC_SCHMITT_S;
+		*width = 1;
+		*map = tz1090_pdc_boolean_map;
+		break;
+	case PIN_CONFIG_SLEW_RATE:
+		*shift = REG_GPIO_CONTROL2_PDC_SR_S;
+		*width = 1;
+		*map = tz1090_pdc_boolean_map;
+		break;
+	case PIN_CONFIG_DRIVE_STRENGTH:
+		*shift = REG_GPIO_CONTROL2_PDC_DR_S;
+		*width = 2;
+		*map = tz1090_pdc_dr_map;
+		break;
+	case PIN_CONFIG_LOW_POWER_MODE:
+		*shift = REG_GPIO_CONTROL2_PDC_POS_S;
+		*width = 1;
+		*map = tz1090_pdc_boolean_map;
+		break;
+	default:
+		return -ENOTSUPP;
+	};
+
+	/* Calculate field information */
+	*mask = (BIT(*width) - 1) << *shift;
+
+	return 0;
+}
+
+static int tz1090_pdc_pinconf_group_get(struct pinctrl_dev *pctldev,
+					unsigned group,
+					unsigned long *config)
+{
+	struct tz1090_pdc_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tz1090_pdc_pingroup *g = &tz1090_pdc_groups[group];
+	enum pin_config_param param = pinconf_to_config_param(*config);
+	int ret, arg;
+	u32 reg, width, mask, shift, val;
+	const int *map;
+
+	/* Get register information */
+	ret = tz1090_pdc_pinconf_group_reg(pctldev, g, param, true,
+					   &reg, &width, &mask, &shift, &map);
+	if (ret < 0)
+		return ret;
+
+	/* Extract field from register */
+	val = pmx_read(pmx, reg);
+	arg = map[(val & mask) >> shift];
+	if (arg < 0)
+		return arg;
+
+	/* And pack config */
+	*config = pinconf_to_config_packed(param, arg);
+
+	return 0;
+}
+
+static int tz1090_pdc_pinconf_group_set(struct pinctrl_dev *pctldev,
+					unsigned group, unsigned long config)
+{
+	struct tz1090_pdc_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tz1090_pdc_pingroup *g = &tz1090_pdc_groups[group];
+	enum pin_config_param param = pinconf_to_config_param(config);
+	const unsigned int *pit;
+	unsigned int i;
+	int ret, arg;
+	u32 reg, width, mask, shift, val;
+	unsigned long flags;
+	const int *map;
+
+	dev_dbg(pctldev->dev, "%s(group=%s, config=%#lx)\n",
+		__func__, g->name, config);
+
+	/* Get register information */
+	ret = tz1090_pdc_pinconf_group_reg(pctldev, g, param, true,
+					   &reg, &width, &mask, &shift, &map);
+	if (ret < 0) {
+		/*
+		 * Maybe we're trying to set a per-pin configuration of a group,
+		 * so do the pins one by one. This is mainly as a convenience.
+		 */
+		for (i = 0, pit = g->pins; i < g->npins; ++i, ++pit) {
+			ret = tz1090_pdc_pinconf_set(pctldev, *pit, config);
+			if (ret)
+				return ret;
+		}
+		return 0;
+	}
+
+	/* Unpack argument and map it to register value */
+	arg = pinconf_to_config_argument(config);
+	for (i = 0; i < BIT(width); ++i) {
+		if (map[i] == arg || (map[i] == -EINVAL && !arg)) {
+			/* Write register field */
+			__global_lock2(flags);
+			val = pmx_read(pmx, reg);
+			val &= ~mask;
+			val |= i << shift;
+			pmx_write(pmx, val, reg);
+			__global_unlock2(flags);
+			return 0;
+		}
+	}
+
+	dev_dbg(pctldev->dev, "%s: arg %u not supported\n",
+		__func__, arg);
+	return 0;
+}
+
+#ifdef CONFIG_DEBUG_FS
+static void tz1090_pdc_pinconf_config_dbg_show(struct pinctrl_dev *pctldev,
+					       struct seq_file *s,
+					       unsigned long config)
+{
+	enum pin_config_param param = pinconf_to_config_param(config);
+	u16 arg = pinconf_to_config_argument(config);
+	const char *pname = "unknown";
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
+		if (cfg_params[i].param == param) {
+			pname = cfg_params[i].property;
+			break;
+		}
+	}
+
+	seq_printf(s, "%s=%d", pname, arg);
+}
+#endif
+
+struct pinconf_ops tz1090_pdc_pinconf_ops = {
+	.is_generic		= true,
+	.pin_config_get		= tz1090_pdc_pinconf_get,
+	.pin_config_set		= tz1090_pdc_pinconf_set,
+	.pin_config_group_get	= tz1090_pdc_pinconf_group_get,
+	.pin_config_group_set	= tz1090_pdc_pinconf_group_set,
+#ifdef CONFIG_DEBUG_FS
+	.pin_config_config_dbg_show	= tz1090_pdc_pinconf_config_dbg_show,
+#endif
+};
+
+/*
+ * Pin control driver setup
+ */
+
+static struct pinctrl_desc tz1090_pdc_pinctrl_desc = {
+	.pctlops	= &tz1090_pdc_pinctrl_ops,
+	.pmxops		= &tz1090_pdc_pinmux_ops,
+	.confops	= &tz1090_pdc_pinconf_ops,
+	.owner		= THIS_MODULE,
+};
+
+static int tz1090_pdc_pinctrl_probe(struct platform_device *pdev)
+{
+	struct tz1090_pdc_pmx *pmx;
+	struct resource *res;
+
+	pmx = devm_kzalloc(&pdev->dev, sizeof(*pmx), GFP_KERNEL);
+	if (!pmx) {
+		dev_err(&pdev->dev, "Can't alloc tz1090_pdc_pmx\n");
+		return -ENOMEM;
+	}
+	pmx->dev = &pdev->dev;
+	spin_lock_init(&pmx->lock);
+
+	tz1090_pdc_pinctrl_desc.name = dev_name(&pdev->dev);
+	tz1090_pdc_pinctrl_desc.pins = tz1090_pdc_pins;
+	tz1090_pdc_pinctrl_desc.npins = ARRAY_SIZE(tz1090_pdc_pins);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Missing MEM resource\n");
+		return -ENODEV;
+	}
+
+	if (!devm_request_mem_region(&pdev->dev, res->start,
+				     resource_size(res),
+				     dev_name(&pdev->dev))) {
+		dev_err(&pdev->dev,
+			"Couldn't request MEM resource\n");
+		return -ENODEV;
+	}
+
+	pmx->regs = devm_ioremap(&pdev->dev, res->start,
+				 resource_size(res));
+	if (!pmx->regs) {
+		dev_err(&pdev->dev, "Couldn't ioremap regs\n");
+		return -ENODEV;
+	}
+
+	pmx->pctl = pinctrl_register(&tz1090_pdc_pinctrl_desc, &pdev->dev, pmx);
+	if (!pmx->pctl) {
+		dev_err(&pdev->dev, "Couldn't register pinctrl driver\n");
+		return -ENODEV;
+	}
+
+	platform_set_drvdata(pdev, pmx);
+
+	dev_info(&pdev->dev, "TZ1090 PDC pinctrl driver initialised\n");
+
+	return 0;
+}
+
+static int tz1090_pdc_pinctrl_remove(struct platform_device *pdev)
+{
+	struct tz1090_pdc_pmx *pmx = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(pmx->pctl);
+
+	return 0;
+}
+
+static struct of_device_id tz1090_pdc_pinctrl_of_match[] = {
+	{ .compatible = "img,tz1090-pdc-pinctrl", },
+	{ },
+};
+
+static struct platform_driver tz1090_pdc_pinctrl_driver = {
+	.driver = {
+		.name		= "tz1090-pdc-pinctrl",
+		.owner		= THIS_MODULE,
+		.of_match_table	= tz1090_pdc_pinctrl_of_match,
+	},
+	.probe	= tz1090_pdc_pinctrl_probe,
+	.remove	= tz1090_pdc_pinctrl_remove,
+};
+
+static int __init tz1090_pdc_pinctrl_init(void)
+{
+	return platform_driver_register(&tz1090_pdc_pinctrl_driver);
+}
+postcore_initcall(tz1090_pdc_pinctrl_init);
+
+static void __exit tz1090_pdc_pinctrl_exit(void)
+{
+	platform_driver_unregister(&tz1090_pdc_pinctrl_driver);
+}
+module_exit(tz1090_pdc_pinctrl_exit);
+
+MODULE_AUTHOR("Imagination Technologies Ltd.");
+MODULE_DESCRIPTION("Toumaz Xenif TZ1090 PDC pinctrl driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, tz1090_pdc_pinctrl_of_match);
-- 
1.8.1.2


