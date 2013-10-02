Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab3JBP07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:26:59 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6190 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab3JBP0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:26:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 02 Oct 2013 08:26:52 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <broonie@kernel.org>,
        <linus.walleij@linaro.org>, <akpm@linux-foundation.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <rob@landley.net>, <ijc+devicetree@hellion.org.uk>,
        <grant.likely@linaro.org>, Laxman Dewangan <ldewangan@nvidia.com>,
        Florian Lobmaier <florian.lobmaier@ams.com>
Subject: [PATCH V4 1/3] mfd: add support for ams AS3722 PMIC
Date: Wed, 2 Oct 2013 21:20:28 +0530
Message-ID: <1380729030-25896-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1380729030-25896-1-git-send-email-ldewangan@nvidia.com>
References: <1380729030-25896-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ams AS3722 is a compact system PMU suitable for mobile phones,
tablets etc. It has 4 DC/DC step-down regulators, 3 DC/DC step-down
controller, 11 LDOs, RTC, automatic battery, temperature and
over-current monitoring, 8 GPIOs, ADC and a watchdog.

Add MFD core driver for the AS3722 to support core functionality.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>
---
Changes from V1:
- Remove compatible string from DT for subnode.
- Nit cleanups in driver and use module_i2c_driver
        
Changes from V2:
- Change DT file to reflect the changes in gpio/pincntrl driver.
  Now there is no extra subnode.

Changes from V3:
- Combine DT of pincontrol and regulator to mfd.
- Nits cleanups.
- AMS to ams.

 Documentation/devicetree/bindings/mfd/as3722.txt |  174 +++++++++
 drivers/mfd/Kconfig                              |   12 +
 drivers/mfd/Makefile                             |    1 +
 drivers/mfd/as3722.c                             |  449 ++++++++++++++++++++++
 include/linux/mfd/as3722.h                       |  423 ++++++++++++++++++++
 5 files changed, 1059 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/as3722.txt
 create mode 100644 drivers/mfd/as3722.c
 create mode 100644 include/linux/mfd/as3722.h

diff --git a/Documentation/devicetree/bindings/mfd/as3722.txt b/Documentation/devicetree/bindings/mfd/as3722.txt
new file mode 100644
index 0000000..885ca4c
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/as3722.txt
@@ -0,0 +1,174 @@
+* ams AS3722 Power management IC.
+
+Required properties:
+-------------------
+- compatible: Must be "ams,as3722".
+- reg: I2C device address.
+- interrupt-controller: AS3722 has internal interrupt controller which takes the
+  interrupt request from  internal sub-blocks like RTC, regulators, GPIOs as well
+  as external input.
+- #interrupt-cells: Should be set to 2 for IRQ number and flags.
+  The first cell is the IRQ number.
+  The second cell is the flags, encoded as the trigger masks from binding document
+	interrupts.txt, using dt-bindings/irq.
+
+Optional submodule and their properties:
+---------------------------------------
+
+Pinmux and GPIO:
+---------------
+Device has 8 GPIO pins which can be configured as GPIO as well as the special IO
+functions.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+Following are properties which is needed if GPIO and pinmux functionality
+is required:
+- gpio-controller: Marks the device node as a GPIO controller.
+- #gpio-cells: Number of GPIO cells. Refer to binding document gpio/gpio.txt
+- pinctrl-names: A pinctrl state named "default" must be defined, using the
+		bindings in pinctrl/pinctrl-binding.txt.
+- pinctrl[0...n]: Nodes for pin control to represents state 0 to state n.
+	Each of these nodes contains different subnodes to represents
+	some desired configuration for a list of pins. This configuration can
+	include the mux function to select on those pin(s), and various pin
+	configuration parameters, such as pull-up, open drain.
+
+Each subnode have following properties:
+Required properties:
+	pins: List of pins. Valid options for pins properties are
+		gpio0, gpio1, gpio2, gpio3, gpio4, gpio5, gpio6, gpio7
+
+Optional properties:
+	Optional properties are
+		function, bias-disable, bias-pull-up, bias-pull-down,
+		bias-high-impedance, drive-open-drain.
+
+		Valid options for funtion properties are:
+		gpio, interrupt-out, gpio-in-interrupt,
+		vsup-vbat-low-undebounce-out, vsup-vbat-low-debounce-out,
+		voltage-in-standby, oc-pg-sd0, oc-pg-sd6, powergood-out,
+		pwm-in, pwm-out, clk32k-out, watchdog-in, soft-reset-in
+
+Regulators:
+-----------
+Device has multiple DCDC and LDOs. The node "regulators" is require if regulator
+functionality is needed.
+
+Following are properties of regulator subnode.
+
+Optional properties:
+-------------------
+The input supply of regulators are the optional properties on the
+regulator node. The input supply of these regulators are provided
+through following properties:
+vsup-sd2-supply: Input supply for SD2.
+vsup-sd3-supply: Input supply for SD3.
+vsup-sd4-supply: Input supply for SD4.
+vsup-sd5-supply: Input supply for SD5.
+vin-ldo0-supply: Input supply for LDO0.
+vin-ldo1-6-supply: Input supply for LDO1 and LDO6.
+vin-ldo2-5-7-supply: Input supply for LDO2, LDO5 and LDO7.
+vin-ldo3-4-supply: Input supply for LDO3 and LDO4.
+vin-ldo9-10-supply: Input supply for LDO9 and LDO10.
+vin-ldo11-supply: Input supply for LDO11.
+
+Optional sub nodes:
+-----------------
+	The subnodes name is the name of regulator and it must be one of:
+	sd[0-6], ldo[0-7], ldo[9-11]
+
+	Each sub-node should contain the constraints and initialization
+	information for that regulator. See regulator.txt for a description
+	of standard properties for these sub-nodes.
+	Additional custom properties  are listed below.
+		ams,ext-control: External control of the rail. The option of
+			this properties will tell which external input is
+			controlling this rail. Valid values are 0, 1, 2 ad 3.
+			0: There is no external control of this rail.
+			1: Rail is controlled by ENABLE1 input pin.
+			2: Rail is controlled by ENABLE2 input pin.
+			3: Rail is controlled by ENABLE3 input pin.
+		ams,enable-tracking: Enable tracking with SD1, only supported
+			by LDO3.
+
+Example:
+--------
+ams3722 {
+	compatible = "ams,as3722";
+	reg = <0x48>;
+
+	interrupt-parent = <&intc>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+
+	gpio-controller;
+	#gpio-cells = <2>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&as3722_default>;
+
+	as3722_default: pinmux {
+			gpio0 {
+				pins = "gpio0";
+				function = "gpio";
+				bias-pull-down;
+			};
+
+			gpio1_2_4_7 {
+				pins = "gpio1", "gpio2", "gpio4", "gpio7";
+				function = "gpio";
+				bias-pull-up;
+			};
+
+			gpio5 {
+				pins = "gpio5";
+				function = "clk32k_out";
+			};
+	}
+
+	regulators {
+			vsup-sd2-supply = <...>;
+			...
+
+			sd0 {
+				regulator-name = "vdd_cpu";
+				regulator-min-microvolt = <700000>;
+				regulator-max-microvolt = <1400000>;
+				regulator-always-on;
+				ams,ext-control = <2>;
+			};
+
+			sd1 {
+				regulator-name = "vdd_core";
+				regulator-min-microvolt = <700000>;
+				regulator-max-microvolt = <1400000>;
+				regulator-always-on;
+				ams,ext-control = <1>;
+			};
+
+			sd2 {
+				regulator-name = "vddio_ddr";
+				regulator-min-microvolt = <1350000>;
+				regulator-max-microvolt = <1350000>;
+				regulator-always-on;
+			};
+
+			sd4 {
+				regulator-name = "avdd-hdmi-pex";
+				regulator-min-microvolt = <1050000>;
+				regulator-max-microvolt = <1050000>;
+				regulator-always-on;
+			};
+
+			sd5 {
+				regulator-name = "vdd-1v8";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+			};
+			....
+	};
+};
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d078fe4..b7c74a7 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -27,6 +27,18 @@ config MFD_AS3711
 	help
 	  Support for the AS3711 PMIC from AMS
 
+config MFD_AS3722
+	bool "ams AS3722 Power Management IC"
+	select MFD_CORE
+	select REGMAP_I2C
+	select REGMAP_IRQ
+	depends on I2C && OF
+	help
+	  The ams AS3722 is a compact system PMU suitable for mobile phones,
+	  tablets etc. It has 4 DC/DC step-down regulators, 3 DC/DC step-down
+	  controllers, 11 LDOs, RTC, automatic battery, temperature and
+	  over current monitoring, GPIOs, ADC and a watchdog.
+
 config PMIC_ADP5520
 	bool "Analog Devices ADP5520/01 MFD PMIC Core Support"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 656cec9..8a28dc9 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -162,4 +162,5 @@ obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o vexpress-sysreg.o
 obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
 obj-$(CONFIG_MFD_AS3711)	+= as3711.o
+obj-$(CONFIG_MFD_AS3722)	+= as3722.o
 obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
diff --git a/drivers/mfd/as3722.c b/drivers/mfd/as3722.c
new file mode 100644
index 0000000..cd8ee59
--- /dev/null
+++ b/drivers/mfd/as3722.c
@@ -0,0 +1,449 @@
+/*
+ * Core driver for ams AS3722 PMICs
+ *
+ * Copyright (C) 2013 AMS AG
+ * Copyright (c) 2013, NVIDIA Corporation. All rights reserved.
+ *
+ * Author: Florian Lobmaier <florian.lobmaier@ams.com>
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/as3722.h>
+#include <linux/of.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+#define AS3722_DEVICE_ID	0x0C
+
+static const struct resource as3722_rtc_resource[] = {
+	{
+		.name = "as3722-rtc-alarm",
+		.start = AS3722_IRQ_RTC_ALARM,
+		.end = AS3722_IRQ_RTC_ALARM,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static const struct resource as3722_adc_resource[] = {
+	{
+		.name = "as3722-adc",
+		.start = AS3722_IRQ_ADC,
+		.end = AS3722_IRQ_ADC,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell as3722_devs[] = {
+	{
+		.name = "as3722-pinctrl",
+	},
+	{
+		.name = "as3722-regulator",
+	},
+	{
+		.name = "as3722-rtc",
+		.num_resources = ARRAY_SIZE(as3722_rtc_resource),
+		.resources = as3722_rtc_resource,
+	},
+	{
+		.name = "as3722-adc",
+		.num_resources = ARRAY_SIZE(as3722_adc_resource),
+		.resources = as3722_adc_resource,
+	},
+	{
+		.name = "as3722-power-off",
+	},
+};
+
+static const struct regmap_irq as3722_irqs[] = {
+	/* INT1 IRQs */
+	[AS3722_IRQ_LID] = {
+		.mask = AS3722_INTERRUPT_MASK1_LID,
+	},
+	[AS3722_IRQ_ACOK] = {
+		.mask = AS3722_INTERRUPT_MASK1_ACOK,
+	},
+	[AS3722_IRQ_ENABLE1] = {
+		.mask = AS3722_INTERRUPT_MASK1_ENABLE1,
+	},
+	[AS3722_IRQ_OCCUR_ALARM_SD0] = {
+		.mask = AS3722_INTERRUPT_MASK1_OCURR_ALARM_SD0,
+	},
+	[AS3722_IRQ_ONKEY_LONG_PRESS] = {
+		.mask = AS3722_INTERRUPT_MASK1_ONKEY_LONG,
+	},
+	[AS3722_IRQ_ONKEY] = {
+		.mask = AS3722_INTERRUPT_MASK1_ONKEY,
+	},
+	[AS3722_IRQ_OVTMP] = {
+		.mask = AS3722_INTERRUPT_MASK1_OVTMP,
+	},
+	[AS3722_IRQ_LOWBAT] = {
+		.mask = AS3722_INTERRUPT_MASK1_LOWBAT,
+	},
+
+	/* INT2 IRQs */
+	[AS3722_IRQ_SD0_LV] = {
+		.mask = AS3722_INTERRUPT_MASK2_SD0_LV,
+		.reg_offset = 1,
+	},
+	[AS3722_IRQ_SD1_LV] = {
+		.mask = AS3722_INTERRUPT_MASK2_SD1_LV,
+		.reg_offset = 1,
+	},
+	[AS3722_IRQ_SD2_LV] = {
+		.mask = AS3722_INTERRUPT_MASK2_SD2345_LV,
+		.reg_offset = 1,
+	},
+	[AS3722_IRQ_PWM1_OV_PROT] = {
+		.mask = AS3722_INTERRUPT_MASK2_PWM1_OV_PROT,
+		.reg_offset = 1,
+	},
+	[AS3722_IRQ_PWM2_OV_PROT] = {
+		.mask = AS3722_INTERRUPT_MASK2_PWM2_OV_PROT,
+		.reg_offset = 1,
+	},
+	[AS3722_IRQ_ENABLE2] = {
+		.mask = AS3722_INTERRUPT_MASK2_ENABLE2,
+		.reg_offset = 1,
+	},
+	[AS3722_IRQ_SD6_LV] = {
+		.mask = AS3722_INTERRUPT_MASK2_SD6_LV,
+		.reg_offset = 1,
+	},
+	[AS3722_IRQ_RTC_REP] = {
+		.mask = AS3722_INTERRUPT_MASK2_RTC_REP,
+		.reg_offset = 1,
+	},
+
+	/* INT3 IRQs */
+	[AS3722_IRQ_RTC_ALARM] = {
+		.mask = AS3722_INTERRUPT_MASK3_RTC_ALARM,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_GPIO1] = {
+		.mask = AS3722_INTERRUPT_MASK3_GPIO1,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_GPIO2] = {
+		.mask = AS3722_INTERRUPT_MASK3_GPIO2,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_GPIO3] = {
+		.mask = AS3722_INTERRUPT_MASK3_GPIO3,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_GPIO4] = {
+		.mask = AS3722_INTERRUPT_MASK3_GPIO4,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_GPIO5] = {
+		.mask = AS3722_INTERRUPT_MASK3_GPIO5,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_WATCHDOG] = {
+		.mask = AS3722_INTERRUPT_MASK3_WATCHDOG,
+		.reg_offset = 2,
+	},
+	[AS3722_IRQ_ENABLE3] = {
+		.mask = AS3722_INTERRUPT_MASK3_ENABLE3,
+		.reg_offset = 2,
+	},
+
+	/* INT4 IRQs */
+	[AS3722_IRQ_TEMP_SD0_SHUTDOWN] = {
+		.mask = AS3722_INTERRUPT_MASK4_TEMP_SD0_SHUTDOWN,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_TEMP_SD1_SHUTDOWN] = {
+		.mask = AS3722_INTERRUPT_MASK4_TEMP_SD1_SHUTDOWN,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_TEMP_SD2_SHUTDOWN] = {
+		.mask = AS3722_INTERRUPT_MASK4_TEMP_SD6_SHUTDOWN,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_TEMP_SD0_ALARM] = {
+		.mask = AS3722_INTERRUPT_MASK4_TEMP_SD0_ALARM,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_TEMP_SD1_ALARM] = {
+		.mask = AS3722_INTERRUPT_MASK4_TEMP_SD1_ALARM,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_TEMP_SD6_ALARM] = {
+		.mask = AS3722_INTERRUPT_MASK4_TEMP_SD6_ALARM,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_OCCUR_ALARM_SD6] = {
+		.mask = AS3722_INTERRUPT_MASK4_OCCUR_ALARM_SD6,
+		.reg_offset = 3,
+	},
+	[AS3722_IRQ_ADC] = {
+		.mask = AS3722_INTERRUPT_MASK4_ADC,
+		.reg_offset = 3,
+	},
+};
+
+static const struct regmap_irq_chip as3722_irq_chip = {
+	.name = "as3722",
+	.irqs = as3722_irqs,
+	.num_irqs = ARRAY_SIZE(as3722_irqs),
+	.num_regs = 4,
+	.status_base = AS3722_INTERRUPT_STATUS1_REG,
+	.mask_base = AS3722_INTERRUPT_MASK1_REG,
+};
+
+static int as3722_check_device_id(struct as3722 *as3722)
+{
+	u32 val;
+	int ret;
+
+	/* Check that this is actually a AS3722 */
+	ret = as3722_read(as3722, AS3722_ASIC_ID1_REG, &val);
+	if (ret < 0) {
+		dev_err(as3722->dev, "ASIC_ID1 read failed: %d\n", ret);
+		return ret;
+	}
+
+	if (val != AS3722_DEVICE_ID) {
+		dev_err(as3722->dev, "Device is not AS3722, ID is 0x%x\n", val);
+		return -ENODEV;
+	}
+
+	ret = as3722_read(as3722, AS3722_ASIC_ID2_REG, &val);
+	if (ret < 0) {
+		dev_err(as3722->dev, "ASIC_ID2 read failed: %d\n", ret);
+		return ret;
+	}
+
+	dev_info(as3722->dev, "AS3722 with revision 0x%x found\n", val);
+	return 0;
+}
+
+static int as3722_configure_pullups(struct as3722 *as3722)
+{
+	int ret;
+	u32 val = 0;
+
+	if (as3722->en_intern_int_pullup)
+		val |= AS3722_INT_PULL_UP;
+	if (as3722->en_intern_i2c_pullup)
+		val |= AS3722_I2C_PULL_UP;
+
+	ret = as3722_update_bits(as3722, AS3722_IOVOLTAGE_REG,
+			AS3722_INT_PULL_UP | AS3722_I2C_PULL_UP, val);
+	if (ret < 0)
+		dev_err(as3722->dev, "IOVOLTAGE_REG update failed: %d\n", ret);
+	return ret;
+}
+
+static const struct regmap_range as3722_readable_ranges[] = {
+	regmap_reg_range(AS3722_SD0_VOLTAGE_REG, AS3722_SD6_VOLTAGE_REG),
+	regmap_reg_range(AS3722_GPIO0_CONTROL_REG, AS3722_LDO7_VOLTAGE_REG),
+	regmap_reg_range(AS3722_LDO9_VOLTAGE_REG, AS3722_REG_SEQU_MOD3_REG),
+	regmap_reg_range(AS3722_SD_PHSW_CTRL_REG, AS3722_PWM_CONTROL_H_REG),
+	regmap_reg_range(AS3722_WATCHDOG_TIMER_REG, AS3722_WATCHDOG_TIMER_REG),
+	regmap_reg_range(AS3722_WATCHDOG_SOFTWARE_SIGNAL_REG,
+					AS3722_BATTERY_VOLTAGE_MONITOR2_REG),
+	regmap_reg_range(AS3722_SD_CONTROL_REG, AS3722_PWM_VCONTROL4_REG),
+	regmap_reg_range(AS3722_BB_CHARGER_REG, AS3722_SRAM_REG),
+	regmap_reg_range(AS3722_RTC_ACCESS_REG, AS3722_RTC_ACCESS_REG),
+	regmap_reg_range(AS3722_RTC_STATUS_REG, AS3722_TEMP_STATUS_REG),
+	regmap_reg_range(AS3722_ADC0_CONTROL_REG, AS3722_ADC_CONFIGURATION_REG),
+	regmap_reg_range(AS3722_ASIC_ID1_REG, AS3722_ASIC_ID2_REG),
+	regmap_reg_range(AS3722_LOCK_REG, AS3722_LOCK_REG),
+};
+
+static const struct regmap_access_table as3722_readable_table = {
+	.yes_ranges = as3722_readable_ranges,
+	.n_yes_ranges = ARRAY_SIZE(as3722_readable_ranges),
+};
+
+static const struct regmap_range as3722_writable_ranges[] = {
+	regmap_reg_range(AS3722_SD0_VOLTAGE_REG, AS3722_SD6_VOLTAGE_REG),
+	regmap_reg_range(AS3722_GPIO0_CONTROL_REG, AS3722_LDO7_VOLTAGE_REG),
+	regmap_reg_range(AS3722_LDO9_VOLTAGE_REG, AS3722_GPIO_SIGNAL_OUT_REG),
+	regmap_reg_range(AS3722_REG_SEQU_MOD1_REG, AS3722_REG_SEQU_MOD3_REG),
+	regmap_reg_range(AS3722_SD_PHSW_CTRL_REG, AS3722_PWM_CONTROL_H_REG),
+	regmap_reg_range(AS3722_WATCHDOG_TIMER_REG, AS3722_WATCHDOG_TIMER_REG),
+	regmap_reg_range(AS3722_WATCHDOG_SOFTWARE_SIGNAL_REG,
+					AS3722_BATTERY_VOLTAGE_MONITOR2_REG),
+	regmap_reg_range(AS3722_SD_CONTROL_REG, AS3722_PWM_VCONTROL4_REG),
+	regmap_reg_range(AS3722_BB_CHARGER_REG, AS3722_SRAM_REG),
+	regmap_reg_range(AS3722_INTERRUPT_MASK1_REG, AS3722_TEMP_STATUS_REG),
+	regmap_reg_range(AS3722_ADC0_CONTROL_REG, AS3722_ADC1_CONTROL_REG),
+	regmap_reg_range(AS3722_ADC1_THRESHOLD_HI_MSB_REG,
+					AS3722_ADC_CONFIGURATION_REG),
+	regmap_reg_range(AS3722_LOCK_REG, AS3722_LOCK_REG),
+};
+
+static const struct regmap_access_table as3722_writable_table = {
+	.yes_ranges = as3722_writable_ranges,
+	.n_yes_ranges = ARRAY_SIZE(as3722_writable_ranges),
+};
+
+static const struct regmap_range as3722_cacheable_ranges[] = {
+	regmap_reg_range(AS3722_SD0_VOLTAGE_REG, AS3722_LDO11_VOLTAGE_REG),
+	regmap_reg_range(AS3722_SD_CONTROL_REG, AS3722_LDOCONTROL1_REG),
+};
+
+static const struct regmap_access_table as3722_volatile_table = {
+	.no_ranges = as3722_cacheable_ranges,
+	.n_no_ranges = ARRAY_SIZE(as3722_cacheable_ranges),
+};
+
+const struct regmap_config as3722_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = AS3722_MAX_REGISTER,
+	.cache_type = REGCACHE_RBTREE,
+	.rd_table = &as3722_readable_table,
+	.wr_table = &as3722_writable_table,
+	.volatile_table = &as3722_volatile_table,
+};
+
+static int as3722_i2c_of_probe(struct i2c_client *i2c,
+			struct as3722 *as3722)
+{
+	struct device_node *np = i2c->dev.of_node;
+	struct irq_data *irq_data;
+
+	if (!np) {
+		dev_err(&i2c->dev, "Device Tree not found\n");
+		return -EINVAL;
+	}
+
+	irq_data = irq_get_irq_data(i2c->irq);
+	if (!irq_data) {
+		dev_err(&i2c->dev, "Invalid IRQ: %d\n", i2c->irq);
+		return -EINVAL;
+	}
+
+	as3722->en_intern_int_pullup = of_property_read_bool(np,
+					"ams,enable-internal-int-pullup");
+	as3722->en_intern_i2c_pullup = of_property_read_bool(np,
+					"ams,enable-internal-i2c-pullup");
+	as3722->irq_flags = irqd_get_trigger_type(irq_data);
+	dev_dbg(&i2c->dev, "IRQ flags are 0x%08lx\n", as3722->irq_flags);
+	return 0;
+}
+
+static int as3722_i2c_probe(struct i2c_client *i2c,
+			const struct i2c_device_id *id)
+{
+	struct as3722 *as3722;
+	unsigned long irq_flags;
+	int ret;
+
+	as3722 = devm_kzalloc(&i2c->dev, sizeof(struct as3722), GFP_KERNEL);
+	if (!as3722)
+		return -ENOMEM;
+
+	as3722->dev = &i2c->dev;
+	as3722->chip_irq = i2c->irq;
+	i2c_set_clientdata(i2c, as3722);
+
+	ret = as3722_i2c_of_probe(i2c, as3722);
+	if (ret < 0)
+		return ret;
+
+	as3722->regmap = devm_regmap_init_i2c(i2c, &as3722_regmap_config);
+	if (IS_ERR(as3722->regmap)) {
+		ret = PTR_ERR(as3722->regmap);
+		dev_err(&i2c->dev, "regmap init failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = as3722_check_device_id(as3722);
+	if (ret < 0)
+		return ret;
+
+	irq_flags = as3722->irq_flags | IRQF_ONESHOT;
+	ret = regmap_add_irq_chip(as3722->regmap, as3722->chip_irq,
+			irq_flags, -1, &as3722_irq_chip,
+			&as3722->irq_data);
+	if (ret < 0) {
+		dev_err(as3722->dev, "Failed to add regmap irq: %d\n", ret);
+		return ret;
+	}
+
+	ret = as3722_configure_pullups(as3722);
+	if (ret < 0)
+		goto scrub;
+
+	ret = mfd_add_devices(&i2c->dev, -1, as3722_devs,
+			ARRAY_SIZE(as3722_devs), NULL, 0,
+			regmap_irq_get_domain(as3722->irq_data));
+	if (ret) {
+		dev_err(as3722->dev, "Failed to add MFD devices: %d\n", ret);
+		goto scrub;
+	}
+
+	dev_dbg(as3722->dev, "AS3722 core driver initialized successfully\n");
+	return 0;
+
+scrub:
+	regmap_del_irq_chip(as3722->chip_irq, as3722->irq_data);
+	return ret;
+}
+
+static int as3722_i2c_remove(struct i2c_client *i2c)
+{
+	struct as3722 *as3722 = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(as3722->dev);
+	regmap_del_irq_chip(as3722->chip_irq, as3722->irq_data);
+	return 0;
+}
+
+static const struct of_device_id as3722_of_match[] = {
+	{ .compatible = "ams,as3722", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, as3722_of_match);
+
+static const struct i2c_device_id as3722_i2c_id[] = {
+	{ "as3722", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, as3722_i2c_id);
+
+static struct i2c_driver as3722_i2c_driver = {
+	.driver = {
+		.name = "as3722",
+		.owner = THIS_MODULE,
+		.of_match_table = as3722_of_match,
+	},
+	.probe = as3722_i2c_probe,
+	.remove = as3722_i2c_remove,
+	.id_table = as3722_i2c_id,
+};
+
+module_i2c_driver(as3722_i2c_driver);
+
+MODULE_DESCRIPTION("I2C support for AS3722 PMICs");
+MODULE_AUTHOR("Florian Lobmaier <florian.lobmaier@ams.com>");
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/as3722.h b/include/linux/mfd/as3722.h
new file mode 100644
index 0000000..16bf8a0
--- /dev/null
+++ b/include/linux/mfd/as3722.h
@@ -0,0 +1,423 @@
+/*
+ * as3722 definitions
+ *
+ * Copyright (C) 2013 ams
+ * Copyright (c) 2013, NVIDIA Corporation. All rights reserved.
+ *
+ * Author: Florian Lobmaier <florian.lobmaier@ams.com>
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
+
+#ifndef __LINUX_MFD_AS3722_H__
+#define __LINUX_MFD_AS3722_H__
+
+#include <linux/regmap.h>
+
+/* AS3722 registers */
+#define AS3722_SD0_VOLTAGE_REG				0x00
+#define AS3722_SD1_VOLTAGE_REG				0x01
+#define AS3722_SD2_VOLTAGE_REG				0x02
+#define AS3722_SD3_VOLTAGE_REG				0x03
+#define AS3722_SD4_VOLTAGE_REG				0x04
+#define AS3722_SD5_VOLTAGE_REG				0x05
+#define AS3722_SD6_VOLTAGE_REG				0x06
+#define AS3722_GPIO0_CONTROL_REG			0x08
+#define AS3722_GPIO1_CONTROL_REG			0x09
+#define AS3722_GPIO2_CONTROL_REG			0x0A
+#define AS3722_GPIO3_CONTROL_REG			0x0B
+#define AS3722_GPIO4_CONTROL_REG			0x0C
+#define AS3722_GPIO5_CONTROL_REG			0x0D
+#define AS3722_GPIO6_CONTROL_REG			0x0E
+#define AS3722_GPIO7_CONTROL_REG			0x0F
+#define AS3722_LDO0_VOLTAGE_REG				0x10
+#define AS3722_LDO1_VOLTAGE_REG				0x11
+#define AS3722_LDO2_VOLTAGE_REG				0x12
+#define AS3722_LDO3_VOLTAGE_REG				0x13
+#define AS3722_LDO4_VOLTAGE_REG				0x14
+#define AS3722_LDO5_VOLTAGE_REG				0x15
+#define AS3722_LDO6_VOLTAGE_REG				0x16
+#define AS3722_LDO7_VOLTAGE_REG				0x17
+#define AS3722_LDO9_VOLTAGE_REG				0x19
+#define AS3722_LDO10_VOLTAGE_REG			0x1A
+#define AS3722_LDO11_VOLTAGE_REG			0x1B
+#define AS3722_GPIO_DEB1_REG				0x1E
+#define AS3722_GPIO_DEB2_REG				0x1F
+#define AS3722_GPIO_SIGNAL_OUT_REG			0x20
+#define AS3722_GPIO_SIGNAL_IN_REG			0x21
+#define AS3722_REG_SEQU_MOD1_REG			0x22
+#define AS3722_REG_SEQU_MOD2_REG			0x23
+#define AS3722_REG_SEQU_MOD3_REG			0x24
+#define AS3722_SD_PHSW_CTRL_REG				0x27
+#define AS3722_SD_PHSW_STATUS				0x28
+#define AS3722_SD0_CONTROL_REG				0x29
+#define AS3722_SD1_CONTROL_REG				0x2A
+#define AS3722_SDmph_CONTROL_REG			0x2B
+#define AS3722_SD23_CONTROL_REG				0x2C
+#define AS3722_SD4_CONTROL_REG				0x2D
+#define AS3722_SD5_CONTROL_REG				0x2E
+#define AS3722_SD6_CONTROL_REG				0x2F
+#define AS3722_SD_DVM_REG				0x30
+#define AS3722_RESET_REASON_REG				0x31
+#define AS3722_BATTERY_VOLTAGE_MONITOR_REG		0x32
+#define AS3722_STARTUP_CONTROL_REG			0x33
+#define AS3722_RESET_TIMER_REG				0x34
+#define AS3722_REFERENCE_CONTROL_REG			0x35
+#define AS3722_RESET_CONTROL_REG			0x36
+#define AS3722_OVER_TEMP_CONTROL_REG			0x37
+#define AS3722_WATCHDOG_CONTROL_REG			0x38
+#define AS3722_REG_STANDBY_MOD1_REG			0x39
+#define AS3722_REG_STANDBY_MOD2_REG			0x3A
+#define AS3722_REG_STANDBY_MOD3_REG			0x3B
+#define AS3722_ENABLE_CTRL1_REG				0x3C
+#define AS3722_ENABLE_CTRL2_REG				0x3D
+#define AS3722_ENABLE_CTRL3_REG				0x3E
+#define AS3722_ENABLE_CTRL4_REG				0x3F
+#define AS3722_ENABLE_CTRL5_REG				0x40
+#define AS3722_PWM_CONTROL_L_REG			0x41
+#define AS3722_PWM_CONTROL_H_REG			0x42
+#define AS3722_WATCHDOG_TIMER_REG			0x46
+#define AS3722_WATCHDOG_SOFTWARE_SIGNAL_REG		0x48
+#define AS3722_IOVOLTAGE_REG				0x49
+#define AS3722_BATTERY_VOLTAGE_MONITOR2_REG		0x4A
+#define AS3722_SD_CONTROL_REG				0x4D
+#define AS3722_LDOCONTROL0_REG				0x4E
+#define AS3722_LDOCONTROL1_REG				0x4F
+#define AS3722_SD0_PROTECT_REG				0x50
+#define AS3722_SD6_PROTECT_REG				0x51
+#define AS3722_PWM_VCONTROL1_REG			0x52
+#define AS3722_PWM_VCONTROL2_REG			0x53
+#define AS3722_PWM_VCONTROL3_REG			0x54
+#define AS3722_PWM_VCONTROL4_REG			0x55
+#define AS3722_BB_CHARGER_REG				0x57
+#define AS3722_CTRL_SEQU1_REG				0x58
+#define AS3722_CTRL_SEQU2_REG				0x59
+#define AS3722_OVCURRENT_REG				0x5A
+#define AS3722_OVCURRENT_DEB_REG			0x5B
+#define AS3722_SDLV_DEB_REG				0x5C
+#define AS3722_OC_PG_CTRL_REG				0x5D
+#define AS3722_OC_PG_CTRL2_REG				0x5E
+#define AS3722_CTRL_STATUS				0x5F
+#define AS3722_RTC_CONTROL_REG				0x60
+#define AS3722_RTC_SECOND_REG				0x61
+#define AS3722_RTC_MINUTE_REG				0x62
+#define AS3722_RTC_HOUR_REG				0x63
+#define AS3722_RTC_DAY_REG				0x64
+#define AS3722_RTC_MONTH_REG				0x65
+#define AS3722_RTC_YEAR_REG				0x66
+#define AS3722_RTC_ALARM_SECOND_REG			0x67
+#define AS3722_RTC_ALARM_MINUTE_REG			0x68
+#define AS3722_RTC_ALARM_HOUR_REG			0x69
+#define AS3722_RTC_ALARM_DAY_REG			0x6A
+#define AS3722_RTC_ALARM_MONTH_REG			0x6B
+#define AS3722_RTC_ALARM_YEAR_REG			0x6C
+#define AS3722_SRAM_REG					0x6D
+#define AS3722_RTC_ACCESS_REG				0x6F
+#define AS3722_RTC_STATUS_REG				0x73
+#define AS3722_INTERRUPT_MASK1_REG			0x74
+#define AS3722_INTERRUPT_MASK2_REG			0x75
+#define AS3722_INTERRUPT_MASK3_REG			0x76
+#define AS3722_INTERRUPT_MASK4_REG			0x77
+#define AS3722_INTERRUPT_STATUS1_REG			0x78
+#define AS3722_INTERRUPT_STATUS2_REG			0x79
+#define AS3722_INTERRUPT_STATUS3_REG			0x7A
+#define AS3722_INTERRUPT_STATUS4_REG			0x7B
+#define AS3722_TEMP_STATUS_REG				0x7D
+#define AS3722_ADC0_CONTROL_REG				0x80
+#define AS3722_ADC1_CONTROL_REG				0x81
+#define AS3722_ADC0_MSB_RESULT_REG			0x82
+#define AS3722_ADC0_LSB_RESULT_REG			0x83
+#define AS3722_ADC1_MSB_RESULT_REG			0x84
+#define AS3722_ADC1_LSB_RESULT_REG			0x85
+#define AS3722_ADC1_THRESHOLD_HI_MSB_REG		0x86
+#define AS3722_ADC1_THRESHOLD_HI_LSB_REG		0x87
+#define AS3722_ADC1_THRESHOLD_LO_MSB_REG		0x88
+#define AS3722_ADC1_THRESHOLD_LO_LSB_REG		0x89
+#define AS3722_ADC_CONFIGURATION_REG			0x8A
+#define AS3722_ASIC_ID1_REG				0x90
+#define AS3722_ASIC_ID2_REG				0x91
+#define AS3722_LOCK_REG					0x9E
+#define AS3722_MAX_REGISTER				0xF4
+
+#define AS3722_SD0_EXT_ENABLE_MASK			0x03
+#define AS3722_SD1_EXT_ENABLE_MASK			0x0C
+#define AS3722_SD2_EXT_ENABLE_MASK			0x30
+#define AS3722_SD3_EXT_ENABLE_MASK			0xC0
+#define AS3722_SD4_EXT_ENABLE_MASK			0x03
+#define AS3722_SD5_EXT_ENABLE_MASK			0x0C
+#define AS3722_SD6_EXT_ENABLE_MASK			0x30
+#define AS3722_LDO0_EXT_ENABLE_MASK			0x03
+#define AS3722_LDO1_EXT_ENABLE_MASK			0x0C
+#define AS3722_LDO2_EXT_ENABLE_MASK			0x30
+#define AS3722_LDO3_EXT_ENABLE_MASK			0xC0
+#define AS3722_LDO4_EXT_ENABLE_MASK			0x03
+#define AS3722_LDO5_EXT_ENABLE_MASK			0x0C
+#define AS3722_LDO6_EXT_ENABLE_MASK			0x30
+#define AS3722_LDO7_EXT_ENABLE_MASK			0xC0
+#define AS3722_LDO9_EXT_ENABLE_MASK			0x0C
+#define AS3722_LDO10_EXT_ENABLE_MASK			0x30
+#define AS3722_LDO11_EXT_ENABLE_MASK			0xC0
+
+#define AS3722_OVCURRENT_SD0_ALARM_MASK			0x07
+#define AS3722_OVCURRENT_SD0_ALARM_SHIFT		0x01
+#define AS3722_OVCURRENT_SD0_TRIP_MASK			0x18
+#define AS3722_OVCURRENT_SD0_TRIP_SHIFT			0x03
+#define AS3722_OVCURRENT_SD1_TRIP_MASK			0x60
+#define AS3722_OVCURRENT_SD1_TRIP_SHIFT			0x05
+
+#define AS3722_OVCURRENT_SD6_ALARM_MASK			0x07
+#define AS3722_OVCURRENT_SD6_ALARM_SHIFT		0x01
+#define AS3722_OVCURRENT_SD6_TRIP_MASK			0x18
+#define AS3722_OVCURRENT_SD6_TRIP_SHIFT			0x03
+
+/* AS3722 register bits and bit masks */
+#define AS3722_LDO_ILIMIT_MASK				BIT(7)
+#define AS3722_LDO_ILIMIT_BIT				BIT(7)
+#define AS3722_LDO0_VSEL_MASK				0x1F
+#define AS3722_LDO0_VSEL_MIN				0x01
+#define AS3722_LDO0_VSEL_MAX				0x12
+#define AS3722_LDO0_NUM_VOLT				0x12
+#define AS3722_LDO3_VSEL_MASK				0x3F
+#define AS3722_LDO3_VSEL_MIN				0x01
+#define AS3722_LDO3_VSEL_MAX				0x2D
+#define AS3722_LDO3_NUM_VOLT				0x2D
+#define AS3722_LDO_VSEL_MASK				0x7F
+#define AS3722_LDO_VSEL_MIN				0x01
+#define AS3722_LDO_VSEL_MAX				0x7F
+#define AS3722_LDO_VSEL_DNU_MIN				0x25
+#define AS3722_LDO_VSEL_DNU_MAX				0x3F
+#define AS3722_LDO_NUM_VOLT				0x80
+
+#define AS3722_LDO0_CTRL				BIT(0)
+#define AS3722_LDO1_CTRL				BIT(1)
+#define AS3722_LDO2_CTRL				BIT(2)
+#define AS3722_LDO3_CTRL				BIT(3)
+#define AS3722_LDO4_CTRL				BIT(4)
+#define AS3722_LDO5_CTRL				BIT(5)
+#define AS3722_LDO6_CTRL				BIT(6)
+#define AS3722_LDO7_CTRL				BIT(7)
+#define AS3722_LDO9_CTRL				BIT(1)
+#define AS3722_LDO10_CTRL				BIT(2)
+#define AS3722_LDO11_CTRL				BIT(3)
+
+#define AS3722_LDO3_MODE_MASK				(3 << 6)
+#define AS3722_LDO3_MODE_VAL(n)				(((n) & 0x3) << 6)
+#define AS3722_LDO3_MODE_PMOS				AS3722_LDO3_MODE_VAL(0)
+#define AS3722_LDO3_MODE_PMOS_TRACKING			AS3722_LDO3_MODE_VAL(1)
+#define AS3722_LDO3_MODE_NMOS				AS3722_LDO3_MODE_VAL(2)
+#define AS3722_LDO3_MODE_SWITCH				AS3722_LDO3_MODE_VAL(3)
+
+#define AS3722_SD_VSEL_MASK				0x7F
+#define AS3722_SD0_VSEL_MIN				0x01
+#define AS3722_SD0_VSEL_MAX				0x5A
+#define AS3722_SD2_VSEL_MIN				0x01
+#define AS3722_SD2_VSEL_MAX				0x7F
+
+#define AS3722_SDn_CTRL(n)				BIT(n)
+
+#define AS3722_SD0_MODE_FAST				BIT(4)
+#define AS3722_SD1_MODE_FAST				BIT(4)
+#define AS3722_SD2_MODE_FAST				BIT(2)
+#define AS3722_SD3_MODE_FAST				BIT(6)
+#define AS3722_SD4_MODE_FAST				BIT(2)
+#define AS3722_SD5_MODE_FAST				BIT(2)
+#define AS3722_SD6_MODE_FAST				BIT(4)
+
+#define AS3722_POWER_OFF				BIT(1)
+
+#define AS3722_INTERRUPT_MASK1_LID			BIT(0)
+#define AS3722_INTERRUPT_MASK1_ACOK			BIT(1)
+#define AS3722_INTERRUPT_MASK1_ENABLE1			BIT(2)
+#define AS3722_INTERRUPT_MASK1_OCURR_ALARM_SD0		BIT(3)
+#define AS3722_INTERRUPT_MASK1_ONKEY_LONG		BIT(4)
+#define AS3722_INTERRUPT_MASK1_ONKEY			BIT(5)
+#define AS3722_INTERRUPT_MASK1_OVTMP			BIT(6)
+#define AS3722_INTERRUPT_MASK1_LOWBAT			BIT(7)
+
+#define AS3722_INTERRUPT_MASK2_SD0_LV			BIT(0)
+#define AS3722_INTERRUPT_MASK2_SD1_LV			BIT(1)
+#define AS3722_INTERRUPT_MASK2_SD2345_LV		BIT(2)
+#define AS3722_INTERRUPT_MASK2_PWM1_OV_PROT		BIT(3)
+#define AS3722_INTERRUPT_MASK2_PWM2_OV_PROT		BIT(4)
+#define AS3722_INTERRUPT_MASK2_ENABLE2			BIT(5)
+#define AS3722_INTERRUPT_MASK2_SD6_LV			BIT(6)
+#define AS3722_INTERRUPT_MASK2_RTC_REP			BIT(7)
+
+#define AS3722_INTERRUPT_MASK3_RTC_ALARM		BIT(0)
+#define AS3722_INTERRUPT_MASK3_GPIO1			BIT(1)
+#define AS3722_INTERRUPT_MASK3_GPIO2			BIT(2)
+#define AS3722_INTERRUPT_MASK3_GPIO3			BIT(3)
+#define AS3722_INTERRUPT_MASK3_GPIO4			BIT(4)
+#define AS3722_INTERRUPT_MASK3_GPIO5			BIT(5)
+#define AS3722_INTERRUPT_MASK3_WATCHDOG			BIT(6)
+#define AS3722_INTERRUPT_MASK3_ENABLE3			BIT(7)
+
+#define AS3722_INTERRUPT_MASK4_TEMP_SD0_SHUTDOWN	BIT(0)
+#define AS3722_INTERRUPT_MASK4_TEMP_SD1_SHUTDOWN	BIT(1)
+#define AS3722_INTERRUPT_MASK4_TEMP_SD6_SHUTDOWN	BIT(2)
+#define AS3722_INTERRUPT_MASK4_TEMP_SD0_ALARM		BIT(3)
+#define AS3722_INTERRUPT_MASK4_TEMP_SD1_ALARM		BIT(4)
+#define AS3722_INTERRUPT_MASK4_TEMP_SD6_ALARM		BIT(5)
+#define AS3722_INTERRUPT_MASK4_OCCUR_ALARM_SD6		BIT(6)
+#define AS3722_INTERRUPT_MASK4_ADC			BIT(7)
+
+#define AS3722_ADC1_INTERVAL_TIME			BIT(0)
+#define AS3722_ADC1_INT_MODE_ON				BIT(1)
+#define AS3722_ADC_BUF_ON				BIT(2)
+#define AS3722_ADC1_LOW_VOLTAGE_RANGE			BIT(5)
+#define AS3722_ADC1_INTEVAL_SCAN			BIT(6)
+#define AS3722_ADC1_INT_MASK				BIT(7)
+
+#define AS3722_ADC_MSB_VAL_MASK				0x7F
+#define AS3722_ADC_LSB_VAL_MASK				0x07
+
+#define AS3722_ADC0_CONV_START				BIT(7)
+#define AS3722_ADC0_CONV_NOTREADY			BIT(7)
+#define AS3722_ADC0_SOURCE_SELECT_MASK			0x1F
+
+#define AS3722_ADC1_CONV_START				BIT(7)
+#define AS3722_ADC1_CONV_NOTREADY			BIT(7)
+#define AS3722_ADC1_SOURCE_SELECT_MASK			0x1F
+
+/* GPIO modes */
+#define AS3722_GPIO_MODE_MASK				0x07
+#define AS3722_GPIO_MODE_INPUT				0x00
+#define AS3722_GPIO_MODE_OUTPUT_VDDH			0x01
+#define AS3722_GPIO_MODE_IO_OPEN_DRAIN			0x02
+#define AS3722_GPIO_MODE_ADC_IN				0x03
+#define AS3722_GPIO_MODE_INPUT_PULL_UP			0x04
+#define AS3722_GPIO_MODE_INPUT_PULL_DOWN		0x05
+#define AS3722_GPIO_MODE_IO_OPEN_DRAIN_PULL_UP		0x06
+#define AS3722_GPIO_MODE_OUTPUT_VDDL			0x07
+#define AS3722_GPIO_MODE_VAL(n)			((n) & AS3722_GPIO_MODE_MASK)
+
+#define AS3722_GPIO_INV					BIT(7)
+#define AS3722_GPIO_IOSF_MASK				0x78
+#define AS3722_GPIO_IOSF_VAL(n)				(((n) & 0xF) << 3)
+#define AS3722_GPIO_IOSF_NORMAL				AS3722_GPIO_IOSF_VAL(0)
+#define AS3722_GPIO_IOSF_INTERRUPT_OUT			AS3722_GPIO_IOSF_VAL(1)
+#define AS3722_GPIO_IOSF_VSUP_LOW_OUT			AS3722_GPIO_IOSF_VAL(2)
+#define AS3722_GPIO_IOSF_GPIO_INTERRUPT_IN		AS3722_GPIO_IOSF_VAL(3)
+#define AS3722_GPIO_IOSF_ISINK_PWM_IN			AS3722_GPIO_IOSF_VAL(4)
+#define AS3722_GPIO_IOSF_VOLTAGE_STBY			AS3722_GPIO_IOSF_VAL(5)
+#define AS3722_GPIO_IOSF_PWR_GOOD_OUT			AS3722_GPIO_IOSF_VAL(7)
+#define AS3722_GPIO_IOSF_Q32K_OUT			AS3722_GPIO_IOSF_VAL(8)
+#define AS3722_GPIO_IOSF_WATCHDOG_IN			AS3722_GPIO_IOSF_VAL(9)
+#define AS3722_GPIO_IOSF_SOFT_RESET_IN			AS3722_GPIO_IOSF_VAL(11)
+#define AS3722_GPIO_IOSF_PWM_OUT			AS3722_GPIO_IOSF_VAL(12)
+#define AS3722_GPIO_IOSF_VSUP_LOW_DEB_OUT		AS3722_GPIO_IOSF_VAL(13)
+#define AS3722_GPIO_IOSF_SD6_LOW_VOLT_LOW		AS3722_GPIO_IOSF_VAL(14)
+
+#define AS3722_GPIOn_SIGNAL(n)				BIT(n)
+#define AS3722_GPIOn_CONTROL_REG(n)		(AS3722_GPIO0_CONTROL_REG + n)
+#define AS3722_I2C_PULL_UP				BIT(4)
+#define AS3722_INT_PULL_UP				BIT(5)
+
+#define AS3722_RTC_REP_WAKEUP_EN			BIT(0)
+#define AS3722_RTC_ALARM_WAKEUP_EN			BIT(1)
+#define AS3722_RTC_ON					BIT(2)
+#define AS3722_RTC_IRQMODE				BIT(3)
+#define AS3722_RTC_CLK32K_OUT_EN			BIT(5)
+
+#define AS3722_WATCHDOG_TIMER_MAX			0x7F
+#define AS3722_WATCHDOG_ON				BIT(0)
+#define AS3722_WATCHDOG_SW_SIG				BIT(0)
+
+#define AS3722_EXT_CONTROL_ENABLE1			0x1
+#define AS3722_EXT_CONTROL_ENABLE2			0x2
+#define AS3722_EXT_CONTROL_ENABLE3			0x3
+
+/* Interrupt IDs */
+enum as3722_irq {
+	AS3722_IRQ_LID,
+	AS3722_IRQ_ACOK,
+	AS3722_IRQ_ENABLE1,
+	AS3722_IRQ_OCCUR_ALARM_SD0,
+	AS3722_IRQ_ONKEY_LONG_PRESS,
+	AS3722_IRQ_ONKEY,
+	AS3722_IRQ_OVTMP,
+	AS3722_IRQ_LOWBAT,
+	AS3722_IRQ_SD0_LV,
+	AS3722_IRQ_SD1_LV,
+	AS3722_IRQ_SD2_LV,
+	AS3722_IRQ_PWM1_OV_PROT,
+	AS3722_IRQ_PWM2_OV_PROT,
+	AS3722_IRQ_ENABLE2,
+	AS3722_IRQ_SD6_LV,
+	AS3722_IRQ_RTC_REP,
+	AS3722_IRQ_RTC_ALARM,
+	AS3722_IRQ_GPIO1,
+	AS3722_IRQ_GPIO2,
+	AS3722_IRQ_GPIO3,
+	AS3722_IRQ_GPIO4,
+	AS3722_IRQ_GPIO5,
+	AS3722_IRQ_WATCHDOG,
+	AS3722_IRQ_ENABLE3,
+	AS3722_IRQ_TEMP_SD0_SHUTDOWN,
+	AS3722_IRQ_TEMP_SD1_SHUTDOWN,
+	AS3722_IRQ_TEMP_SD2_SHUTDOWN,
+	AS3722_IRQ_TEMP_SD0_ALARM,
+	AS3722_IRQ_TEMP_SD1_ALARM,
+	AS3722_IRQ_TEMP_SD6_ALARM,
+	AS3722_IRQ_OCCUR_ALARM_SD6,
+	AS3722_IRQ_ADC,
+	AS3722_IRQ_MAX,
+};
+
+struct as3722 {
+	struct device *dev;
+	struct regmap *regmap;
+	int chip_irq;
+	unsigned long irq_flags;
+	bool en_intern_int_pullup;
+	bool en_intern_i2c_pullup;
+	struct regmap_irq_chip_data *irq_data;
+};
+
+static inline int as3722_read(struct as3722 *as3722, u32 reg, u32 *dest)
+{
+	return regmap_read(as3722->regmap, reg, dest);
+}
+
+static inline int as3722_write(struct as3722 *as3722, u32 reg, u32 value)
+{
+	return regmap_write(as3722->regmap, reg, value);
+}
+
+static inline int as3722_block_read(struct as3722 *as3722, u32 reg,
+		int count, u8 *buf)
+{
+	return regmap_bulk_read(as3722->regmap, reg, buf, count);
+}
+
+static inline int as3722_block_write(struct as3722 *as3722, u32 reg,
+		int count, u8 *data)
+{
+	return regmap_bulk_write(as3722->regmap, reg, data, count);
+}
+
+static inline int as3722_update_bits(struct as3722 *as3722, u32 reg,
+		u32 mask, u8 val)
+{
+	return regmap_update_bits(as3722->regmap, reg, mask, val);
+}
+
+static inline int as3722_irq_get_virq(struct as3722 *as3722, int irq)
+{
+	return regmap_irq_get_virq(as3722->irq_data, irq);
+}
+#endif /* __LINUX_MFD_AS3722_H__ */
-- 
1.7.1.1

