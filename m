Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbbATJt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:49:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55155 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbbATJr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:47:58 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, Flora Fu <flora.fu@mediatek.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 8/8] regulator: MT6397: Add support for MT6397 regulator
Date: Tue, 20 Jan 2015 10:47:11 +0100
Message-Id: <1421747231-554-9-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
References: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Flora Fu <flora.fu@mediatek.com>

This adds support for the regulators on the MediaTek MT6397
Multifunction device.

Signed-off-by: Flora Fu, MediaTek
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
---
 Documentation/devicetree/bindings/mfd/mt6397.txt   |  41 ++-
 .../bindings/regulator/mt6397-regulator.txt        | 217 ++++++++++++++
 drivers/regulator/Kconfig                          |   9 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/mt6397-regulator.c               | 332 +++++++++++++++++++++
 include/linux/regulator/mt6397-regulator.h         |  49 +++
 6 files changed, 626 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/mt6397-regulator.txt
 create mode 100644 drivers/regulator/mt6397-regulator.c
 create mode 100644 include/linux/regulator/mt6397-regulator.h

diff --git a/Documentation/devicetree/bindings/mfd/mt6397.txt b/Documentation/devicetree/bindings/mfd/mt6397.txt
index 64ef408..25b40a6 100644
--- a/Documentation/devicetree/bindings/mfd/mt6397.txt
+++ b/Documentation/devicetree/bindings/mfd/mt6397.txt
@@ -10,33 +10,34 @@ MT6397 is a multifunction device with the following sub modules:
 It is interfaced to host controller using SPI interface by a proprietary hardware
 called PMIC wrapper or pwrap. MT6397 MFD is a child device of pwrap.
 See the following for pwarp node definitions:
-Documentation/devicetree/bindings/soc/mediatek,mt8135-pwrap.txt
+Documentation/devicetree/bindings/soc/pwrap.txt
 
 This document describes the binding for mfd device and its sub module.
 
 Required properties:
 compatible: "mediatek,mt6397"
 
-Optional properties:
-- codec: Audio codec
-- pinctrl: GPIO in mt6397
-- rtc: RTC
-- clock: clocks in mt6397
-- regulators: regulators in mt6397
+Optional subnodes:
+
+- rtc:
+	Required properties:
+		- compatible: "mediatek,mt6397-rtc",
+- regulators
+	Required properties:
+		- compatible: "mediatek,mt6397-regulator",
+	see Documentation/devicetree/bindings/regulator/mt6397-regulator.txt
+- codec
+	Required properties:
+		- compatible: "mediatek,mt6397-codec",
+- clk
+	Required properties:
+		- compatible: "mediatek,mt6397-clk",
 
 Example:
 	pwrap: pwrap@1000f000 {
 		compatible = "mediatek,mt8135-pwrap";
-		reg = <0 0x1000f000 0 0x1000>,
-			<0 0x11017000 0 0x1000>;
-		reg-names = "pwrap-base", "pwrap-bridge-base";
-		interrupts = <GIC_SPI 128 IRQ_TYPE_LEVEL_HIGH>;
-		resets = <&infrarst MT8135_INFRA_PMIC_WRAP_RST>,
-				<&perirst MT8135_PERI_PWRAP_BRIDGE_SW_RST>;
-		reset-names = "infra-pwrap-rst",
-				"peri-pwrap-bridge-rst";
-		clocks = <&pmicspi_sel>, <&clk26m>;
-		clock-names = "pmicspi-sel", "pmicspi-parent";
+
+		...
 
 		pmic {
 			compatible = "mediatek,mt6397";
@@ -45,12 +46,6 @@ Example:
 				compatible = "mediatek,mt6397-codec";
 			};
 
-			pinctrl@0x0000C000 {
-				compatible = "mediatek,mt6397-pinctrl";
-				reg = <0 0x0000C000 0 0x0108>;
-				gpio-controller;
-			};
-
 			mt6397regulator: mt6397regulator {
 				compatible = "mediatek,mt6397-regulator";
 
diff --git a/Documentation/devicetree/bindings/regulator/mt6397-regulator.txt b/Documentation/devicetree/bindings/regulator/mt6397-regulator.txt
new file mode 100644
index 0000000..a42b1d6
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/mt6397-regulator.txt
@@ -0,0 +1,217 @@
+Mediatek MT6397 Regulator Driver
+
+Required properties:
+- compatible: "mediatek,mt6397-regulator"
+- mt6397regulator: List of regulators provided by this controller. It is named
+  according to its regulator type, buck_<name> and ldo_<name>.
+  The definition for each of these nodes is defined using the standard binding
+  for regulators at Documentation/devicetree/bindings/regulator/regulator.txt.
+
+The valid names for regulators are::
+BUCK:
+  buck_vpca15, buck_vpca7, buck_vsramca15, buck_vsramca7, buck_vcore, buck_vgpu,
+  buck_vdrm, buck_vio18
+LDO:
+  ldo_vtcxo, ldo_va28, ldo_vcama, ldo_vio28, ldo_vusb, ldo_vmc, ldo_vmch,
+  ldo_vemc3v3, ldo_vgp1, ldo_vgp2, ldo_vgp3, ldo_vgp4, ldo_vgp5, ldo_vgp6,
+  ldo_vibr
+
+Example:
+	pmic {
+		compatible = "mediatek,mt6397";
+
+		mt6397regulator: mt6397regulator {
+			compatible = "mediatek,mt6397-regulator";
+
+			mt6397_vpca15_reg: buck_vpca15 {
+				regulator-compatible = "buck_vpca15";
+				regulator-name = "vpca15";
+				regulator-min-microvolt = < 850000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-ramp-delay = <12500>;
+				regulator-enable-ramp-delay = <200>;
+			};
+
+			mt6397_vpca7_reg: buck_vpca7 {
+				regulator-compatible = "buck_vpca7";
+				regulator-name = "vpca7";
+				regulator-min-microvolt = < 850000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-ramp-delay = <12500>;
+				regulator-enable-ramp-delay = <115>;
+			};
+
+			mt6397_vsramca15_reg: buck_vsramca15 {
+				regulator-compatible = "buck_vsramca15";
+				regulator-name = "vsramca15";
+				regulator-min-microvolt = < 850000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-ramp-delay = <12500>;
+				regulator-enable-ramp-delay = <115>;
+
+			};
+
+			mt6397_vsramca7_reg: buck_vsramca7 {
+				regulator-compatible = "buck_vsramca7";
+				regulator-name = "vsramca7";
+				regulator-min-microvolt = < 850000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-ramp-delay = <12500>;
+				regulator-enable-ramp-delay = <115>;
+
+			};
+
+			mt6397_vcore_reg: buck_vcore {
+				regulator-compatible = "buck_vcore";
+				regulator-name = "vcore";
+				regulator-min-microvolt = < 850000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-ramp-delay = <12500>;
+				regulator-enable-ramp-delay = <115>;
+			};
+
+			mt6397_vgpu_reg: buck_vgpu {
+				regulator-compatible = "buck_vgpu";
+				regulator-name = "vgpu";
+				regulator-min-microvolt = < 700000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-ramp-delay = <12500>;
+				regulator-enable-ramp-delay = <115>;
+			};
+
+			mt6397_vdrm_reg: buck_vdrm {
+				regulator-compatible = "buck_vdrm";
+				regulator-name = "vdrm";
+				regulator-min-microvolt = < 800000>;
+				regulator-max-microvolt = <1400000>;
+				regulator-ramp-delay = <12500>;
+				regulator-enable-ramp-delay = <500>;
+			};
+
+			mt6397_vio18_reg: buck_vio18 {
+				regulator-compatible = "buck_vio18";
+				regulator-name = "vio18";
+				regulator-min-microvolt = <1500000>;
+				regulator-max-microvolt = <2120000>;
+				regulator-ramp-delay = <12500>;
+				regulator-enable-ramp-delay = <500>;
+			};
+
+			mt6397_vtcxo_reg: ldo_vtcxo {
+				regulator-compatible = "ldo_vtcxo";
+				regulator-name = "vtcxo";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-enable-ramp-delay = <90>;
+			};
+
+			mt6397_va28_reg: ldo_va28 {
+				regulator-compatible = "ldo_va28";
+				regulator-name = "va28";
+				/* fixed output 2.8 V */
+				regulator-enable-ramp-delay = <218>;
+			};
+
+			mt6397_vcama_reg: ldo_vcama {
+				regulator-compatible = "ldo_vcama";
+				regulator-name = "vcama";
+				regulator-min-microvolt = <1500000>;
+				regulator-max-microvolt = <2800000>;
+				regulator-enable-ramp-delay = <218>;
+			};
+
+			mt6397_vio28_reg: ldo_vio28 {
+				regulator-compatible = "ldo_vio28";
+				regulator-name = "vio28";
+				/* fixed output 2.8 V */
+				regulator-enable-ramp-delay = <240>;
+			};
+
+			mt6397_usb_reg: ldo_vusb {
+				regulator-compatible = "ldo_vusb";
+				regulator-name = "vusb";
+				/* fixed output 3.3 V */
+				regulator-enable-ramp-delay = <218>;
+			};
+
+			mt6397_vmc_reg: ldo_vmc {
+				regulator-compatible = "ldo_vmc";
+				regulator-name = "vmc";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-enable-ramp-delay = <218>;
+			};
+
+			mt6397_vmch_reg: ldo_vmch {
+				regulator-compatible = "ldo_vmch";
+				regulator-name = "vmch";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-enable-ramp-delay = <218>;
+			};
+
+			mt6397_vemc_3v3_reg: ldo_vemc3v3 {
+				regulator-compatible = "ldo_vemc3v3";
+				regulator-name = "vemc_3v3";
+				regulator-min-microvolt = <3000000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-enable-ramp-delay = <218>;
+			};
+
+			mt6397_vgp1_reg: ldo_vgp1 {
+				regulator-compatible = "ldo_vgp1";
+				regulator-name = "vcamd";
+				regulator-min-microvolt = <1220000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-enable-ramp-delay = <240>;
+			};
+
+			mt6397_vgp2_reg: ldo_vgp2 {
+				egulator-compatible = "ldo_vgp2";
+				regulator-name = "vcamio";
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-enable-ramp-delay = <218>;
+			};
+
+			mt6397_vgp3_reg: ldo_vgp3 {
+				regulator-compatible = "ldo_vgp3";
+				regulator-name = "vcamaf";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-enable-ramp-delay = <218>;
+			};
+
+			mt6397_vgp4_reg: ldo_vgp4 {
+				regulator-compatible = "ldo_vgp4";
+				regulator-name = "vgp4";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-enable-ramp-delay = <218>;
+			};
+
+			mt6397_vgp5_reg: ldo_vgp5 {
+				regulator-compatible = "ldo_vgp5";
+				regulator-name = "vgp5";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3000000>;
+				regulator-enable-ramp-delay = <218>;
+			};
+
+			mt6397_vgp6_reg: ldo_vgp6 {
+				regulator-compatible = "ldo_vgp6";
+				regulator-name = "vgp6";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-enable-ramp-delay = <218>;
+			};
+
+			mt6397_vibr_reg: ldo_vibr {
+				regulator-compatible = "ldo_vibr";
+				regulator-name = "vibr";
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-enable-ramp-delay = <218>;
+			};
+		};
+	};
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index c3a60b5..f622d06 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -433,6 +433,15 @@ config REGULATOR_MC13892
 	  Say y here to support the regulators found on the Freescale MC13892
 	  PMIC.
 
+config REGULATOR_MT6397
+	tristate "MediaTek MT6397 PMIC"
+	depends on MFD_MT6397
+	help
+	  Say y here to select this option to enable the power regulator of
+	  MediaTek MT6397 PMIC.
+	  This driver supports the control of different power rails of device
+	  through regulator interface.
+
 config REGULATOR_PALMAS
 	tristate "TI Palmas PMIC Regulators"
 	depends on MFD_PALMAS
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 1f28ebf..1a0fbc3 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_REGULATOR_MAX77802) += max77802.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
+obj-$(CONFIG_REGULATOR_MT6397)	+= mt6397-regulator.o
 obj-$(CONFIG_REGULATOR_QCOM_RPM) += qcom_rpm-regulator.o
 obj-$(CONFIG_REGULATOR_PALMAS) += palmas-regulator.o
 obj-$(CONFIG_REGULATOR_PFUZE100) += pfuze100-regulator.o
diff --git a/drivers/regulator/mt6397-regulator.c b/drivers/regulator/mt6397-regulator.c
new file mode 100644
index 0000000..a5b2f47
--- /dev/null
+++ b/drivers/regulator/mt6397-regulator.c
@@ -0,0 +1,332 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Flora Fu <flora.fu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/mfd/mt6397/core.h>
+#include <linux/mfd/mt6397/registers.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/mt6397-regulator.h>
+#include <linux/regulator/of_regulator.h>
+
+/*
+ * MT6397 regulators' information
+ *
+ * @desc: standard fields of regulator description.
+ * @qi: Mask for query enable signal status of regulators
+ * @vselon_reg: Register sections for hardware control mode of bucks
+ * @vselctrl_reg: Register for controlling the buck control mode.
+ * @vselctrl_mask: Mask for query buck's voltage control mode.
+ */
+struct mt6397_regulator_info {
+	struct regulator_desc desc;
+	u32 qi;
+	u32 vselon_reg;
+	u32 vselctrl_reg;
+	u32 vselctrl_mask;
+};
+
+#define MT6397_BUCK(match, vreg, min, max, step, volt_ranges, enreg,	\
+		vosel, vosel_mask, voselon, vosel_ctrl)			\
+[MT6397_ID_##vreg] = {							\
+	.desc = {							\
+		.name = #vreg,						\
+		.of_match = of_match_ptr(match),			\
+		.ops = &mt6397_volt_range_ops,				\
+		.type = REGULATOR_VOLTAGE,				\
+		.id = MT6397_ID_##vreg,					\
+		.owner = THIS_MODULE,					\
+		.n_voltages = (max - min)/step + 1,			\
+		.linear_ranges = volt_ranges,				\
+		.n_linear_ranges = ARRAY_SIZE(volt_ranges),		\
+		.vsel_reg = vosel,					\
+		.vsel_mask = vosel_mask,				\
+		.enable_reg = enreg,					\
+		.enable_mask = BIT(0),					\
+	},								\
+	.qi = BIT(13),							\
+	.vselon_reg = voselon,						\
+	.vselctrl_reg = vosel_ctrl,					\
+	.vselctrl_mask = BIT(1),					\
+}
+
+#define MT6397_LDO(match, vreg, ldo_volt_table, enreg, enbit, vosel,	\
+		vosel_mask)						\
+[MT6397_ID_##vreg] = {							\
+	.desc = {							\
+		.name = #vreg,						\
+		.of_match = of_match_ptr(match),			\
+		.ops = &mt6397_volt_table_ops,				\
+		.type = REGULATOR_VOLTAGE,				\
+		.id = MT6397_ID_##vreg,					\
+		.owner = THIS_MODULE,					\
+		.n_voltages = ARRAY_SIZE(ldo_volt_table),		\
+		.volt_table = ldo_volt_table,				\
+		.vsel_reg = vosel,					\
+		.vsel_mask = vosel_mask,				\
+		.enable_reg = enreg,					\
+		.enable_mask = BIT(enbit),				\
+	},								\
+	.qi = BIT(15),							\
+}
+
+#define MT6397_REG_FIXED(match, vreg, enreg, enbit, volt)		\
+[MT6397_ID_##vreg] = {							\
+	.desc = {							\
+		.name = #vreg,						\
+		.of_match = of_match_ptr(match),			\
+		.ops = &mt6397_volt_fixed_ops,				\
+		.type = REGULATOR_VOLTAGE,				\
+		.id = MT6397_ID_##vreg,					\
+		.owner = THIS_MODULE,					\
+		.n_voltages = 1,					\
+		.enable_reg = enreg,					\
+		.enable_mask = BIT(enbit),				\
+		.min_uV = volt,						\
+	},								\
+	.qi = BIT(15),							\
+}
+
+static const struct regulator_linear_range buck_volt_range1[] = {
+	REGULATOR_LINEAR_RANGE(700000, 0, 0x7f, 6250),
+};
+
+static const struct regulator_linear_range buck_volt_range2[] = {
+	REGULATOR_LINEAR_RANGE(800000, 0, 0x7f, 6250),
+};
+
+static const struct regulator_linear_range buck_volt_range3[] = {
+	REGULATOR_LINEAR_RANGE(1500000, 0, 0x1f, 20000),
+};
+
+static const u32 ldo_volt_table1[] = {
+	1500000, 1800000, 2500000, 2800000,
+};
+
+static const u32 ldo_volt_table2[] = {
+	1800000, 3300000,
+};
+
+static const u32 ldo_volt_table3[] = {
+	3000000, 3300000,
+};
+
+static const u32 ldo_volt_table4[] = {
+	1220000, 1300000, 1500000, 1800000, 2500000, 2800000, 3000000, 3300000,
+};
+
+static const u32 ldo_volt_table5[] = {
+	1200000, 1300000, 1500000, 1800000, 2500000, 2800000, 3000000, 3300000,
+};
+
+static const u32 ldo_volt_table5_v2[] = {
+	1200000, 1000000, 1500000, 1800000, 2500000, 2800000, 3000000, 3300000,
+};
+
+static const u32 ldo_volt_table6[] = {
+	1200000, 1300000, 1500000, 1800000, 2500000, 2800000, 3000000, 2000000,
+};
+
+static const u32 ldo_volt_table7[] = {
+	1300000, 1500000, 1800000, 2000000, 2500000, 2800000, 3000000, 3300000,
+};
+
+static int mt6397_get_status(struct regulator_dev *rdev)
+{
+	int ret;
+	u32 regval;
+	struct mt6397_regulator_info *info = rdev_get_drvdata(rdev);
+
+	ret = regmap_read(rdev->regmap, info->desc.enable_reg, &regval);
+	if (ret != 0) {
+		dev_err(&rdev->dev, "Failed to get enable reg: %d\n", ret);
+		return ret;
+	}
+
+	return (regval & info->qi) ? REGULATOR_STATUS_ON : REGULATOR_STATUS_OFF;
+}
+
+static struct regulator_ops mt6397_volt_range_ops = {
+	.list_voltage = regulator_list_voltage_linear_range,
+	.map_voltage = regulator_map_voltage_linear_range,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_time_sel = regulator_set_voltage_time_sel,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+	.get_status = mt6397_get_status,
+};
+
+static struct regulator_ops mt6397_volt_table_ops = {
+	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_iterate,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_time_sel = regulator_set_voltage_time_sel,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+	.get_status = mt6397_get_status,
+};
+
+static struct regulator_ops mt6397_volt_fixed_ops = {
+	.list_voltage = regulator_list_voltage_linear,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+	.get_status = mt6397_get_status,
+};
+
+/* The array is indexed by id(MT6397_ID_XXX) */
+static struct mt6397_regulator_info mt6397_regulators[] = {
+	MT6397_BUCK("buck_vpca15", VPCA15, 700000, 1493750, 6250,
+		buck_volt_range1, MT6397_VCA15_CON7, MT6397_VCA15_CON9, 0x7f,
+		MT6397_VCA15_CON10, MT6397_VCA15_CON5),
+	MT6397_BUCK("buck_vpca7", VPCA7, 700000, 1493750, 6250,
+		buck_volt_range1, MT6397_VPCA7_CON7, MT6397_VPCA7_CON9, 0x7f,
+		MT6397_VPCA7_CON10, MT6397_VPCA7_CON5),
+	MT6397_BUCK("buck_vsramca15", VSRAMCA15, 700000, 1493750, 6250,
+		buck_volt_range1, MT6397_VSRMCA15_CON7, MT6397_VSRMCA15_CON9,
+		0x7f, MT6397_VSRMCA15_CON10, MT6397_VSRMCA15_CON5),
+	MT6397_BUCK("buck_vsramca7", VSRAMCA7, 700000, 1493750, 6250,
+		buck_volt_range1, MT6397_VSRMCA7_CON7, MT6397_VSRMCA7_CON9,
+		0x7f, MT6397_VSRMCA7_CON10, MT6397_VSRMCA7_CON5),
+	MT6397_BUCK("buck_vcore", VCORE, 700000, 1493750, 6250,
+		buck_volt_range1, MT6397_VCORE_CON7, MT6397_VCORE_CON9, 0x7f,
+		MT6397_VCORE_CON10, MT6397_VCORE_CON5),
+	MT6397_BUCK("buck_vgpu", VGPU, 700000, 1493750, 6250, buck_volt_range1,
+		MT6397_VGPU_CON7, MT6397_VGPU_CON9, 0x7f,
+		MT6397_VGPU_CON10, MT6397_VGPU_CON5),
+	MT6397_BUCK("buck_vdrm", VDRM, 800000, 1593750, 6250, buck_volt_range2,
+		MT6397_VDRM_CON7, MT6397_VDRM_CON9, 0x7f,
+		MT6397_VDRM_CON10, MT6397_VDRM_CON5),
+	MT6397_BUCK("buck_vio18", VIO18, 1500000, 2120000, 20000,
+		buck_volt_range3, MT6397_VIO18_CON7, MT6397_VIO18_CON9, 0x1f,
+		MT6397_VIO18_CON10, MT6397_VIO18_CON5),
+	MT6397_REG_FIXED("ldo_vtcxo", VTCXO, MT6397_ANALDO_CON0, 10, 2800000),
+	MT6397_REG_FIXED("ldo_va28", VA28, MT6397_ANALDO_CON1, 14, 2800000),
+	MT6397_LDO("ldo_vcama", VCAMA, ldo_volt_table1,
+		MT6397_ANALDO_CON2, 15, MT6397_ANALDO_CON6, 0xC0),
+	MT6397_REG_FIXED("ldo_vio28", VIO28, MT6397_DIGLDO_CON0, 14, 2800000),
+	MT6397_REG_FIXED("ldo_vusb", VUSB, MT6397_DIGLDO_CON1, 14, 3300000),
+	MT6397_LDO("ldo_vmc", VMC, ldo_volt_table2,
+		MT6397_DIGLDO_CON2, 12, MT6397_DIGLDO_CON29, 0x10),
+	MT6397_LDO("ldo_vmch", VMCH, ldo_volt_table3,
+		MT6397_DIGLDO_CON3, 14, MT6397_DIGLDO_CON17, 0x80),
+	MT6397_LDO("ldo_vemc3v3", VEMC3V3, ldo_volt_table3,
+		MT6397_DIGLDO_CON4, 14, MT6397_DIGLDO_CON18, 0x10),
+	MT6397_LDO("ldo_vgp1", VGP1, ldo_volt_table4,
+		MT6397_DIGLDO_CON5, 15, MT6397_DIGLDO_CON19, 0xE0),
+	MT6397_LDO("ldo_vgp2", VGP2, ldo_volt_table5,
+		MT6397_DIGLDO_CON6, 15, MT6397_DIGLDO_CON20, 0xE0),
+	MT6397_LDO("ldo_vgp3", VGP3, ldo_volt_table5,
+		MT6397_DIGLDO_CON7, 15, MT6397_DIGLDO_CON21, 0xE0),
+	MT6397_LDO("ldo_vgp4", VGP4, ldo_volt_table5,
+		MT6397_DIGLDO_CON8, 15, MT6397_DIGLDO_CON22, 0xE0),
+	MT6397_LDO("ldo_vgp5", VGP5, ldo_volt_table6,
+		MT6397_DIGLDO_CON9, 15, MT6397_DIGLDO_CON23, 0xE0),
+	MT6397_LDO("ldo_vgp6", VGP6, ldo_volt_table5,
+		MT6397_DIGLDO_CON10, 15, MT6397_DIGLDO_CON33, 0xE0),
+	MT6397_LDO("ldo_vibr", VIBR, ldo_volt_table7,
+		MT6397_DIGLDO_CON24, 15, MT6397_DIGLDO_CON25, 0xE00),
+};
+
+static int mt6397_set_buck_vosel_reg(struct platform_device *pdev)
+{
+	struct mt6397_chip *mt6397 = dev_get_drvdata(pdev->dev.parent);
+	int i;
+	u32 regval;
+
+	for (i = 0; i < MT6397_MAX_REGULATOR; i++) {
+		if (mt6397_regulators[i].vselctrl_reg) {
+			if (regmap_read(mt6397->regmap,
+				mt6397_regulators[i].vselctrl_reg,
+				&regval) < 0) {
+				dev_err(&pdev->dev,
+					"Failed to read buck ctrl\n");
+				return -EIO;
+			}
+
+			if (regval & mt6397_regulators[i].vselctrl_mask) {
+				mt6397_regulators[i].desc.vsel_reg =
+				mt6397_regulators[i].vselon_reg;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int mt6397_regulator_probe(struct platform_device *pdev)
+{
+	struct mt6397_chip *mt6397 = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_config config = {};
+	struct regulator_dev *rdev;
+	int i;
+	u32 reg_value, version;
+
+	/* Query buck controller to select activated voltage register part */
+	if (mt6397_set_buck_vosel_reg(pdev))
+		return -EIO;
+
+	/* Read PMIC chip revision to update constraints and voltage table */
+	if (regmap_read(mt6397->regmap, MT6397_CID, &reg_value) < 0) {
+		dev_err(&pdev->dev, "Failed to read Chip ID\n");
+		return -EIO;
+	}
+	dev_info(&pdev->dev, "Chip ID = 0x%x\n", reg_value);
+
+	version = (reg_value & 0xFF);
+	switch (version) {
+	case MT6397_REGULATOR_ID91:
+		mt6397_regulators[MT6397_ID_VGP2].desc.volt_table =
+		ldo_volt_table5_v2;
+		break;
+	default:
+		break;
+	}
+
+	for (i = 0; i < MT6397_MAX_REGULATOR; i++) {
+		config.dev = &pdev->dev;
+		config.driver_data = &mt6397_regulators[i];
+		config.regmap = mt6397->regmap;
+		rdev = devm_regulator_register(&pdev->dev,
+				&mt6397_regulators[i].desc, &config);
+		if (IS_ERR(rdev)) {
+			dev_err(&pdev->dev, "failed to register %s\n",
+				mt6397_regulators[i].desc.name);
+			return PTR_ERR(rdev);
+		}
+	}
+
+	return 0;
+}
+
+static struct platform_driver mt6397_regulator_driver = {
+	.driver = {
+		.name = "mt6397-regulator",
+	},
+	.probe = mt6397_regulator_probe,
+};
+
+module_platform_driver(mt6397_regulator_driver);
+
+MODULE_AUTHOR("Flora Fu <flora.fu@mediatek.com>");
+MODULE_DESCRIPTION("Regulator Driver for MediaTek MT6397 PMIC");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:mt6397-regulator");
diff --git a/include/linux/regulator/mt6397-regulator.h b/include/linux/regulator/mt6397-regulator.h
new file mode 100644
index 0000000..30cc596
--- /dev/null
+++ b/include/linux/regulator/mt6397-regulator.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Flora Fu <flora.fu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __LINUX_REGULATOR_MT6397_H
+#define __LINUX_REGULATOR_MT6397_H
+
+enum {
+	MT6397_ID_VPCA15 = 0,
+	MT6397_ID_VPCA7,
+	MT6397_ID_VSRAMCA15,
+	MT6397_ID_VSRAMCA7,
+	MT6397_ID_VCORE,
+	MT6397_ID_VGPU,
+	MT6397_ID_VDRM,
+	MT6397_ID_VIO18 = 7,
+	MT6397_ID_VTCXO,
+	MT6397_ID_VA28,
+	MT6397_ID_VCAMA,
+	MT6397_ID_VIO28,
+	MT6397_ID_VUSB,
+	MT6397_ID_VMC,
+	MT6397_ID_VMCH,
+	MT6397_ID_VEMC3V3,
+	MT6397_ID_VGP1,
+	MT6397_ID_VGP2,
+	MT6397_ID_VGP3,
+	MT6397_ID_VGP4,
+	MT6397_ID_VGP5,
+	MT6397_ID_VGP6,
+	MT6397_ID_VIBR,
+	MT6397_ID_RG_MAX,
+};
+
+#define MT6397_MAX_REGULATOR	MT6397_ID_RG_MAX
+#define MT6397_REGULATOR_ID97	0x97
+#define MT6397_REGULATOR_ID91	0x91
+
+#endif /* __LINUX_REGULATOR_MT6397_H */
-- 
2.1.4

