Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3EVSTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:19:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55122 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653Ab3EVSTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:19:47 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH 1/4] regulator: Introduce OMAP regulator to control PMIC over VC/VP
Date: Wed, 22 May 2013 13:18:34 -0500
Message-ID: <1369246717-4167-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369246717-4167-1-git-send-email-nm@ti.com>
References: <1369246717-4167-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Texas Instrument's OMAP SoC generations since OMAP3-5 introduced
an TI custom hardware block to better facilitate and standardize
integration of Power Management ICs which communicate over I2C.

In fact, many custom PMICs were designed to be usable over this
interface. On the other hand, generic PMICs which are compatible
to the I2C protocol supported by Voltage controller may also be
used.

In general, the following categories of PMICs exist:

a) PMICs which are completely controlled by voltage controller/voltage
processor pair - this implies even configuration needs to be done
over the same interface. Example: TPS62361 used on PandaBoard-ES and
many OMAP4460 based platforms. Few Maxim and Fairchild PMICs used on
certain products would fall in this category.
- Note: in this case, there may not even exist/needed to support an
"traditional Linux regulator driver"

b) PMICs which provide two views over two I2C interfaces - however,
voltage can only be set only on one of them. Example: TWL4030/5030:
allows us to use Voltage controller once we set up a bit over regular
I2C - This is used in OMAP3. TWO6030/TWL6032 - configuration *has*
to be performed over regular i2c (example smps_offset) and voltage
control *has* to be performed by using voltage controller/processor.
- Note: in this case, there may exist "traditional Linux regulator driver"
however, it may not support in any form SMPS modelling for that part of
the device which is exposed to voltage controller/processor.
c) PMICs which allow voltage and configurations over either i2c
interfaces - TWL6035/TWL6037/Palmas family of TI processor
- Note: in this case, there may exist "traditional Linux regulator driver"
and, it may support in some form SMPS modelling for that part of
the device which is exposed to voltage controller/processor.
d) custom PMICs which are setup so that no configuration is needed to be
performed and they operate with preset register offsets and minimal
conferability using voltage controller/processor.
- Note: in this case, there may not even exist/needed to support an
"traditional Linux regulator driver"

However, no matter the type of PMIC used, the OMAP view of a PMIC is
generic when used over voltage controller/processor. We attempt to
model this generic view of the regulator represented by OMAP SoC.

Alternative to this approach would be to "hack" into the get
voltage/set voltage interfaces of regulator drivers which represent
the rest of the PMIC controlled over regular I2C interface and
re-route the requests to voltage controller/processor. But, by doing
that, we needlessly create additional code which may be abstracted out
into device tree node information.

Since the regulator node representing PMIC, voltage controller,
processors are probed at varied points in time, probe deferral is used
to sequence in the right order. It is expected by the driver to register
omap_pmic_register_controller_ops providing mandatory operations at the
earliest possible opportunity.

Despite the current SoCs implementing the solution based on voltage
controller and voltage processor (which are part of the OMAP SoC modules
which enable Adaptive Voltage Scaling class support), the interfaces are
generic enough to handle future equivalent modules.

[grygorii.strashko@ti.com: co-developer]
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../bindings/regulator/omap-pmic-regulator.txt     |  121 +++++
 drivers/regulator/Kconfig                          |   12 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/omap-pmic-regulator.c            |  554 ++++++++++++++++++++
 include/linux/regulator/omap-pmic-regulator.h      |  147 ++++++
 5 files changed, 835 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/omap-pmic-regulator.txt
 create mode 100644 drivers/regulator/omap-pmic-regulator.c
 create mode 100644 include/linux/regulator/omap-pmic-regulator.h

diff --git a/Documentation/devicetree/bindings/regulator/omap-pmic-regulator.txt b/Documentation/devicetree/bindings/regulator/omap-pmic-regulator.txt
new file mode 100644
index 0000000..b87dd3c
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/omap-pmic-regulator.txt
@@ -0,0 +1,121 @@
+Generic Power Management IC(PMIC) Regulator for Texas Instruments OMAP SoCs
+
+Required Properties:
+- compatible: Should be:
+  - "ti,omap-pmic"
+
+- ti,i2c-slave-address - I2C slave address of the PMIC
+- ti,i2c-voltage-register - I2C register address where voltage commands are
+	to be set.
+- ti,i2c-command-register - I2C register address where commands are to be set
+	when OMAP enters low power state. This may be the same as
+	ti,i2c-voltage-register depending on the PMIC.
+- ti,slew-rate-microvolt - worst case slew rate of rise / fall for voltage
+	transition in microvolts per microseconds (uV/uS)
+- step-size-micro-volts - Step size in micovolts as to what one step in voltage
+	selector increment translates to. See example.
+- regulator-min-microvolt - Minimum voltage in microvolts which is supported by
+	the PMIC in ti,step-size-microvolt increments. See example.
+- regulator-max-microvolt - Maximum voltage in microvolts which is supported
+	by the PMIC in ti,step-size-microvolt increments. See example.
+
+Optional Properties:
+- gpios: OF device-tree gpio specification - can be an array, will be setup
+	in the order of definition and set to the flags.
+- pinctrl: OF device-tree pinctrl definitions as needed (usually for the GPIOs)
+- ti,boot-voltage-micro-volts - voltage in microvolts that bootloader is leaving
+	over the PMIC at. This may be 'PMIC data manual configuration' if
+	bootloader does not set an value, or appropritate value.
+- ti,voltage-selector-set-bits - what bits to set permenantly for the PMIC
+	voltage selector - this may have PMIC specific meaning.
+- ti,voltage-selector-mask - what mask to use for the vsel value - this is
+	useful for PMICs where the vsel has to be applied at an offset.
+- ti,voltage-selector-offset - what offset to apply to conversion routine when
+	operating on vsel.
+- ti,non-zero-voltage-selector - Special case handling if 0 value does NOT
+	indicates power-off for PMIC.
+- ti,setup_commands - An array of 2-tuples items, and each item consists
+  of register address and command like <address data>
+	addr: I2C register address to send the command (over Voltage controller)
+	data: What data to send
+
+Example: defining step-size, min/max voltages
+NOTE: OMAP can only handle continous voltages. In a case of an PMIC such as the
+follows:
+	vsel- corresponding voltage
+	0x1 - 500mV
+	0x2 - 800mV
+	0x3 - 810mV
+	0x4 - 820mV
+	..
+	0x14 - 1v
+	0x15 - 1.5v
+OMAP can only suppport voltages for voltage operations when the voltages
+are in equal increments. In the above example, it is 800mV to 1v at 10mV steps
+This corresponds to the following properties:
+step-size-micro-volts  = <10000>;
+regulator-min-microvolt = <800000>;
+regulator-max-microvolt = <1000000>;
+
+Example: Setup PMIC with PFM mode to be enabled for voltage operations
+Lets say that the bit in voltage selector(vsel) is 0x80. in this case,
+ti,voltage-selector-set-bits =<0x80>;
+
+Example: setup PMIC where the vsel bits are set from bits 7:4
+Consider an following example
+0x10 - 800mV
+0xf0 - 1v
+in this case,
+ti,voltage-selector-mask = <0xF0>;
+
+Example: Conversion routine needs an offset
+Consider an PMIC with the following behavior for vsel.
+	0 - OFF voltage
+	1 - 709mV
+	2 - 721.66mV
+	etc..
+	regulator-min-microvolt would be 709, however vsel offsets needs to be
+	accounted for. Hence, we could use
+ti,voltage-selector-offset = <1>;	/* incremental vsel starts at 1 */
+
+On the other hand, when 0 indicates voltage = regulator-min-microvolt, use:
+ti,non-zero-voltage-selector;
+
+Example: Sample PMIC description
+omap_tps62361: tps62361 {
+	compatible = "ti,omap-pmic";
+	ti,non-zero-voltage-selector;
+
+	ti,i2c-slave-address = <0x60>;
+	/* We have only one register to set voltage / low power voltage  to */
+	ti,i2c-voltage-register = <0x01>; /* Set 1 register */
+	ti,i2c-command-register = <0x01>; /* Set 1 register */
+
+	ti,slew-rate-microvolt = <32000>;
+	ti,step-size-microvolt = <10000>;
+	regulator-min-microvolt = <500000>;
+	regulator-max-microvolt = <1770000>;
+
+	ti,voltage-selector-offset = <0x0>;
+	ti,voltage-selector-set-bits =<0x80>; /* PFM mode */
+	ti,non-zero-voltage-selector;
+
+	ti,setup_commands=<
+		/* register_addr value */
+		/* Setup Slew (ramp) rate (0 - 32mV/uS) */
+		0x06	0x0
+		/* Enable thermal shutdown - 0 is enable :( */
+		0x5	0x0
+	>;
+};
+
+/* Board Specific configuration */
+&omap_tps62361 {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+		&tps62361_wkgpio_pins
+	>;
+	gpios = <&gpio1 7 1>;	/* gpio_wk7 */
+
+	ti,boot-voltage-micro-volts=<1200000>;
+};
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 8bb2644..3a2d625 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -472,6 +472,18 @@ config REGULATOR_TWL4030
 	  This driver supports the voltage regulators provided by
 	  this family of companion chips.
 
+config REGULATOR_TI_OMAP_PMIC
+	tristate "TI Generic regulator for Voltage Processor / Controller"
+	depends on ARCH_OMAP
+	help
+	  Select this option to support PMICs over Texas Instruments'
+	  custom Voltage Processor + Voltage Controller data interface
+	  used in OMAP SoCs. This is a specific "write-only" interface
+	  designed to interface with I2C based PMICs.
+
+	  This option enables the regulator driver representing the PMIC
+	  on the OMAP VC/VP hardware.
+
 config REGULATOR_VEXPRESS
 	tristate "Versatile Express regulators"
 	depends on VEXPRESS_CONFIG
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 47a34ff..32c882e 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 obj-$(CONFIG_REGULATOR_TPS65912) += tps65912-regulator.o
 obj-$(CONFIG_REGULATOR_TPS80031) += tps80031-regulator.o
 obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
+obj-$(CONFIG_REGULATOR_TI_OMAP_PMIC) += omap-pmic-regulator.o
 obj-$(CONFIG_REGULATOR_VEXPRESS) += vexpress.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-isink.o
diff --git a/drivers/regulator/omap-pmic-regulator.c b/drivers/regulator/omap-pmic-regulator.c
new file mode 100644
index 0000000..31ac186
--- /dev/null
+++ b/drivers/regulator/omap-pmic-regulator.c
@@ -0,0 +1,554 @@
+/*
+ * OMAP Generic PMIC Regulator
+ *
+ * Idea based on arch/arm/mach-omap2/omap_twl.c
+ * Copyright (C) 2010 Texas Instruments Incorporated.
+ * Thara Gopinath
+ * Copyright (C) 2009 Texas Instruments Incorporated.
+ * Nishanth Menon
+ * Copyright (C) 2009 Nokia Corporation
+ * Paul Walmsley
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated
+ * Grygorii Strashko
+ * Nishanth Menon
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
+
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/regulator/omap-pmic-regulator.h>
+
+#define DRIVER_NAME	"omap-pmic"
+
+static DEFINE_MUTEX(omap_pmic_cops_mutex);
+static struct omap_pmic_controller_ops *pmic_cops;
+
+/**
+ * omap_pmic_register_controller_ops() - Register voltage operations
+ * @cops:	voltage operations
+ *
+ * It is expected that appropriate controller register it's functions
+ * with this driver using this interface, If this is not done, the probe
+ * for the corresponding device will defer till it fails.
+ *
+ * Return: -EBUSY if already registered, else returns 0
+ */
+int omap_pmic_register_controller_ops(struct omap_pmic_controller_ops *cops)
+{
+	int ret = 0;
+
+	mutex_lock(&omap_pmic_cops_mutex);
+	if (pmic_cops) {
+		pr_err("Controller operations already registered\n");
+		ret = -EBUSY;
+		goto out;
+	}
+	if (!cops->devm_pmic_register || !cops->voltage_set ||
+	    !cops->voltage_get || !cops->voltage_get_range) {
+		pr_err("Missing operations!\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	pmic_cops = cops;
+out:
+	mutex_unlock(&omap_pmic_cops_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(omap_pmic_register_controller_ops);
+
+/**
+ * omap_pmic_vsel_to_uv() - Convert voltage selector(vsel) to microvolts
+ * @pmic:	pointer to pmic struct
+ * @vsel:	voltage selector(vsel)
+ * @uv:		If conversion is successful, returns the voltage in micro volts
+ *
+ * Return: 0 if conversion is successful and *uv has proper value, else
+ * appropriate error value for failure.
+ */
+static int omap_pmic_vsel_to_uv(struct omap_pmic *pmic, u8 vsel, u32 *uv)
+{
+	u32 tmp = vsel;
+
+	if (!pmic || !uv) {
+		pr_err("Bad parameters pmic=%p uv=%p!\n", pmic, uv);
+		return -EINVAL;
+	}
+
+	if (pmic->voltage_selector_mask) {
+		tmp &= pmic->voltage_selector_mask;
+		tmp >>= __ffs(pmic->voltage_selector_mask);
+	}
+
+	if (!tmp && pmic->voltage_selector_zero)
+		goto out;
+
+	tmp -= pmic->voltage_selector_offset;
+	tmp *= pmic->step_size_uV;
+	tmp += pmic->min_uV;
+
+	if (tmp < pmic->min_uV || tmp > pmic->max_uV) {
+		dev_dbg(pmic->dev, "%s: Out of range 0x%02x[%d] (%d <-> %d)\n",
+			__func__, vsel, tmp, pmic->min_uV, pmic->max_uV);
+		return -ERANGE;
+	}
+
+out:
+	*uv = tmp;
+	dev_dbg(pmic->dev, "%s: uv=%d vsel=0x%02x\n", __func__, *uv, vsel);
+
+	return 0;
+}
+
+/**
+ * omap_pmic_uv_to_vsel() - Convert microvolts to voltage selector(vsel)
+ * @pmic:	pointer to pmic struct
+ * @uv:		voltage in micro volts
+ * @vsel:	If conversion is successful, voltage selector(vsel)
+ *
+ * Return: 0 if conversion is successful and *vsel has proper value, else
+ * appropriate error value for failure.
+ */
+static int omap_pmic_uv_to_vsel(struct omap_pmic *pmic, u32 uv, u8 *vsel)
+{
+	u32 tmp = uv;
+
+	if (!pmic || !vsel) {
+		pr_err("Bad parameters pmic=%p vsel=%p!\n", pmic, vsel);
+		return -EINVAL;
+	}
+
+	if (!tmp && pmic->voltage_selector_zero)
+		goto skip_convert;
+
+	if (tmp > pmic->max_uV)
+		goto skip_convert;
+
+	tmp -= pmic->min_uV;
+	tmp = DIV_ROUND_UP(tmp, pmic->step_size_uV);
+
+	tmp += pmic->voltage_selector_offset;
+
+skip_convert:
+	if (tmp > 0xFF) {
+		dev_dbg(pmic->dev, "%s: Out of range 0x%04x[%d] (%d - %d)\n",
+			__func__, tmp, uv, pmic->min_uV, pmic->max_uV);
+		return -ERANGE;
+	}
+	if (pmic->voltage_selector_mask) {
+		tmp <<= __ffs(pmic->voltage_selector_mask);
+		if (tmp > 0xFF) {
+			dev_warn(pmic->dev, "%s: Out of range 0x%04x[%d]\n",
+				 __func__, tmp, uv);
+			return -ERANGE;
+		}
+		tmp &= pmic->voltage_selector_mask;
+	}
+
+	tmp |= pmic->voltage_selector_setbits;
+
+	*vsel = tmp;
+	dev_dbg(pmic->dev, "%s: uv=%d vsel=0x%02x\n", __func__, uv, *vsel);
+
+	return 0;
+}
+
+/**
+ * omap_pmic_of_read_setup_commands() - read setup commands from OF
+ * @dev:	device to pick up setup commands from
+ * @pmic:	pointer to pmic structure
+ */
+static int omap_pmic_of_read_setup_commands(struct device *dev,
+					    struct omap_pmic *pmic)
+{
+	char *pname = "ti,setup_commands";
+	const struct property *prop;
+	const __be32 *v;
+	struct omap_pmic_setup_commands *setup;
+	const u8 num_values = 2;
+	u32 num_entries;
+	int i;
+
+	prop = of_find_property(dev->of_node, pname, NULL);
+	if (!prop)
+		return 0;
+
+	if (!prop->value) {
+		dev_err(dev, "Empty '%s' property?\n", pname);
+		return -ENODATA;
+	}
+
+	/* Each setup command is a tuple consisting of reg_addr, value */
+	num_entries = prop->length / sizeof(u32);
+	if (!num_entries || (num_entries % num_values)) {
+		dev_err(dev, "All '%s' list entries need %d vals\n", pname,
+			num_values);
+		return -EINVAL;
+	}
+	num_entries /= num_values;
+
+	setup = devm_kzalloc(dev, sizeof(*setup) * num_entries, GFP_KERNEL);
+	if (!setup) {
+		dev_err(dev, "Can't allocate info table for '%s' property\n",
+			pname);
+		return -ENOMEM;
+	}
+
+	pmic->setup_command_list = setup;
+	pmic->setup_num_commands = num_entries;
+
+	v = prop->value;
+	for (i = 0; i < num_entries; i++, setup++) {
+		u32 reg, cmd_val;
+
+		/* NOTE: num_values should equal to entries picked up here */
+		reg = be32_to_cpup(v++);
+		cmd_val = be32_to_cpup(v++);
+
+		/* Setup commands and registers are 8 bit wide. */
+		if (reg > 0xFF || cmd_val > 0xFF) {
+			dev_err(dev, "Bad entries in '%s' property idx=%d\n",
+				pname, i);
+			return -EINVAL;
+		}
+
+		setup->reg = reg;
+		setup->cmd_val = cmd_val;
+		dev_dbg(dev, "[setup cmd %d] reg=0x%02x val=0x%02x\n", i,
+			setup->reg, setup->cmd_val);
+	}
+
+	return 0;
+}
+
+/**
+ * omap_pmic_of_setup_gpios() - Setup GPIO array if needed.
+ * @dev:	device to pick up the gpios from
+ */
+static int omap_pmic_of_setup_gpios(struct device *dev)
+{
+	struct device_node *node = dev->of_node;
+	int num_gpios, i, ret;
+
+	num_gpios = of_gpio_count(node);
+	if (num_gpios < 0)
+		return 0;
+
+	for (i = 0; i < num_gpios; i++) {
+		int gpio;
+		enum of_gpio_flags flags;
+
+		gpio = of_get_gpio_flags(node, i, &flags);
+		if (!gpio_is_valid(gpio)) {
+			dev_err(dev, "Invalid GPIO[%d]: %d\n", i, gpio);
+			return -EINVAL;
+		}
+
+		ret = devm_gpio_request(dev, gpio, dev_name(dev));
+		if (ret) {
+			dev_err(dev, "Unable to get GPIO %d (%d)\n", gpio, ret);
+			return ret;
+		}
+		ret = gpio_direction_output(gpio,
+					    !!(flags & OF_GPIO_ACTIVE_LOW));
+		if (ret) {
+			dev_err(dev, "Failed to set GPIO %d (%d)\n", gpio, ret);
+			return ret;
+		}
+		dev_dbg(dev, "GPIO=%d set_to=%d\n", gpio,
+			!!(flags & OF_GPIO_ACTIVE_LOW));
+	}
+
+	return 0;
+}
+
+/**
+ * omap_pmic_set_voltage() - regulator interface to set voltage
+ * @rdev:	regulator device
+ * @min_uV:	min voltage in micro-volts
+ * @max_uV:	max voltage in micro-volts
+ * @unused:	unused.. we dont use sel
+ *
+ * Return: -ERANGE for out of range values, appropriate error code if conversion
+ * fails, else returns 0.
+ */
+static int omap_pmic_set_voltage(struct regulator_dev *rdev, int min_uV,
+				 int max_uV, unsigned *unused)
+{
+	struct omap_pmic *pmic = rdev_get_drvdata(rdev);
+
+	return pmic_cops->voltage_set(pmic->v_dev, min_uV);
+}
+
+/**
+ * omap_pmic_get_voltage() - regulator interface to get voltage
+ * @rdev: regulator device
+ *
+ * Return: current voltage set on PMIC OR appropriate error value
+ */
+static int omap_pmic_get_voltage(struct regulator_dev *rdev)
+{
+	struct omap_pmic *pmic = rdev_get_drvdata(rdev);
+	int ret;
+	u32 uv;
+
+	ret = pmic_cops->voltage_get(pmic->v_dev, &uv);
+	if (ret)
+		return ret;
+
+	return uv;
+}
+
+static struct omap_pmic_ops omap_generic_pmic_ops = {
+	.vsel_to_uv = omap_pmic_vsel_to_uv,
+	.uv_to_vsel = omap_pmic_uv_to_vsel,
+};
+
+static struct regulator_ops omap_pmic_reg_ops = {
+	.list_voltage = regulator_list_voltage_linear,
+
+	.set_voltage = omap_pmic_set_voltage,
+	.get_voltage = omap_pmic_get_voltage,
+};
+
+/**
+ * omap_pmic_parse_of() - Do DT OF node parsing
+ * @pmic:	pointer to PMIC
+ */
+static int omap_pmic_parse_of(struct omap_pmic *pmic)
+{
+	struct device *dev = pmic->dev;
+	struct device_node *node = dev->of_node;
+	u32 val = 0;
+	char *pname;
+	int ret;
+
+	pname = "ti,i2c-slave-address";
+	ret = of_property_read_u32(node, pname, &val);
+	/* Only 7 bit addressing allowed for slave address */
+	if (ret || val >= 0x80)
+		goto invalid_of_property;
+	pmic->slave_addr = val;
+
+	pname = "ti,i2c-voltage-register";
+	ret = of_property_read_u32(node, pname, &val);
+	if (ret || val >= 0xFF)
+		goto invalid_of_property;
+	pmic->voltage_reg_addr = val;
+
+	pname = "ti,i2c-command-register";
+	ret = of_property_read_u32(node, pname, &val);
+	if (ret || val >= 0xFF)
+		goto invalid_of_property;
+	pmic->cmd_reg_addr = val;
+
+	pname = "ti,slew-rate-microvolt";
+	ret = of_property_read_u32(node, pname, &val);
+	if (ret || !val)
+		goto invalid_of_property;
+	pmic->slew_rate_uV = val;
+
+	pname = "ti,step-size-microvolt";
+	ret = of_property_read_u32(node, pname, &val);
+	if (ret || !val)
+		goto invalid_of_property;
+	pmic->step_size_uV = val;
+
+	/* Optional parameters */
+	pmic->voltage_selector_zero =
+	    !of_property_read_bool(node, "ti,non-zero-voltage-selector");
+
+	pname = "ti,boot-voltage-micro-volts";
+	ret = of_property_read_u32(node, pname, &val);
+	if (!ret) {
+		if (!val)
+			goto invalid_of_property;
+		pmic->boot_voltage_uV = val;
+	}
+
+	ret = of_property_read_u32(node, "ti,i2c-timeout-microsecond",
+				   &pmic->i2c_timeout_us);
+	/* If we dont have custom parameter, use arbitary un-realistic value */
+	if (ret)
+		pmic->i2c_timeout_us = 200;
+
+	pname = "ti,voltage-selector-offset";
+	ret = of_property_read_u32(node, pname, &val);
+	if (!ret) {
+		if (val > 0xFF)
+			goto invalid_of_property;
+		pmic->voltage_selector_offset = val;
+	}
+	pname = "ti,voltage-selector-mask";
+	ret = of_property_read_u32(node, pname, &val);
+	if (!ret) {
+		if (val > 0xFF)
+			goto invalid_of_property;
+		pmic->voltage_selector_mask = val;
+	}
+	pname = "ti,voltage-selector-set-bits";
+	ret = of_property_read_u32(node, pname, &val);
+	if (!ret) {
+		if (val > 0xFF)
+			goto invalid_of_property;
+		pmic->voltage_selector_setbits = val;
+	}
+
+	ret = omap_pmic_of_read_setup_commands(dev, pmic);
+
+	return ret;
+
+invalid_of_property:
+	if (!ret) {
+		dev_err(dev, "Invalid value 0x%x[%d] in '%s' property.\n",
+			val, val, pname);
+		ret = -EINVAL;
+	} else {
+		dev_err(dev, "Missing/Invalid '%s' property - error(%d)\n",
+			pname, ret);
+	}
+	return ret;
+}
+
+static int omap_pmic_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct omap_pmic *pmic;
+	struct regulator_desc *desc;
+	struct regulation_constraints *c;
+	struct regulator_config config = { };
+	struct regulator_init_data *initdata = NULL;
+	struct regulator_dev *rdev = NULL;
+	int ret = 0;
+	bool ops_ready;
+
+	if (!node) {
+		dev_err(dev, "%s: missing device tree nodes?\n", __func__);
+		return -EINVAL;
+	}
+
+	mutex_lock(&omap_pmic_cops_mutex);
+	ops_ready = pmic_cops ? true : false;
+	mutex_unlock(&omap_pmic_cops_mutex);
+	if (!ops_ready) {
+		dev_dbg(dev, "Voltage Operations not ready yet..\n");
+		return -EPROBE_DEFER;
+	}
+
+	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
+	if (!desc) {
+		dev_err(dev, "%s: unable to allocate desc\n", __func__);
+		return -ENOMEM;
+	}
+
+	pmic = devm_kzalloc(dev, sizeof(*pmic), GFP_KERNEL);
+	if (!pmic) {
+		dev_err(dev, "%s: unable to allocate pmic\n", __func__);
+		return -ENOMEM;
+	}
+
+	/* Read mandatory OF parameters */
+	pmic->dev = dev;
+	pmic->ops = &omap_generic_pmic_ops;
+
+	initdata = of_get_regulator_init_data(dev, node);
+	if (!initdata) {
+		dev_err(dev, "%s: Unable to alloc regulator init data\n",
+			__func__);
+		return -ENOMEM;
+	}
+	c = &initdata->constraints;
+	if (!c->max_uV) {
+		dev_err(dev, "regulator-max-microvolt is set as 0?\n");
+		return -EINVAL;
+	}
+
+	pmic->min_uV = c->min_uV;
+	pmic->max_uV = c->max_uV;
+
+	ret = omap_pmic_parse_of(pmic);
+	if (ret)
+		return ret;
+
+	ret = omap_pmic_of_setup_gpios(dev);
+	if (ret)
+		return ret;
+
+	pmic->v_dev = pmic_cops->devm_pmic_register(dev, pmic);
+	if (IS_ERR(pmic->v_dev)) {
+		dev_dbg(dev, "Registration of pmic failed (%d)\n", ret);
+		ret = PTR_ERR(pmic->v_dev);
+		return ret;
+	}
+	desc->name = dev_name(dev);
+	desc->owner = THIS_MODULE;
+	desc->type = REGULATOR_VOLTAGE;
+	desc->ops = &omap_pmic_reg_ops;
+	desc->uV_step = pmic->step_size_uV;
+	desc->ramp_delay = pmic->slew_rate_uV;
+
+	c->valid_ops_mask |= REGULATOR_CHANGE_VOLTAGE;
+	c->always_on = true;
+	ret = pmic_cops->voltage_get_range(pmic->v_dev, &c->min_uV, &c->max_uV);
+	if (ret) {
+		dev_err(dev, "Voltage Range get failed (%d)\n", ret);
+		return ret;
+	}
+
+	config.dev = dev;
+	config.init_data = initdata;
+	config.driver_data = pmic;
+	config.of_node = node;
+
+	rdev = regulator_register(desc, &config);
+	if (IS_ERR(rdev)) {
+		ret = PTR_ERR(rdev);
+		dev_err(dev, "%s: failed to register regulator(%d)\n",
+			__func__, ret);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, rdev);
+
+	return ret;
+}
+
+static const struct of_device_id omap_pmic_of_match_tbl[] = {
+	{.compatible = "ti,omap-pmic",},
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_pmic_of_match_tbl);
+
+static struct platform_driver omap_pmic_driver = {
+	.driver = {
+		   .name = DRIVER_NAME,
+		   .owner = THIS_MODULE,
+		   .of_match_table = of_match_ptr(omap_pmic_of_match_tbl),
+		   },
+	.probe = omap_pmic_probe,
+};
+module_platform_driver(omap_pmic_driver);
+
+MODULE_DESCRIPTION("OMAP Generic PMIC Regulator");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
+MODULE_AUTHOR("Texas Instruments Inc.");
diff --git a/include/linux/regulator/omap-pmic-regulator.h b/include/linux/regulator/omap-pmic-regulator.h
new file mode 100644
index 0000000..97e7697
--- /dev/null
+++ b/include/linux/regulator/omap-pmic-regulator.h
@@ -0,0 +1,147 @@
+/*
+ * OMAP Generic PMIC Regulator interfaces
+ *
+ * Idea based on arch/arm/mach-omap2/omap_twl.c and
+ * arch/arm/mach-omap2/voltage.h
+ * Copyright (C) 2010 Texas Instruments Incorporated.
+ * Thara Gopinath
+ * Copyright (C) 2009 Texas Instruments Incorporated.
+ * Nishanth Menon
+ * Copyright (C) 2009 Nokia Corporation
+ * Paul Walmsley
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated.
+ * Grygorii Strashko
+ * Nishanth Menon
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __POWER_OMAP_PMIC_H
+#define __POWER_OMAP_PMIC_H
+
+struct omap_pmic;
+
+/**
+ * struct omap_pmic_setup_commands - setup commands over voltage controller
+ * @reg:	device's i2c register address
+ * @cmd_val:	command to send.
+ */
+struct omap_pmic_setup_commands {
+	u8 reg;
+	u8 cmd_val;
+};
+
+/**
+ * struct omap_pmic_ops - Conversion routines for voltage controller/processor
+ * @vsel_to_uv: convert voltage selector to micro-volts
+ * @uv_to_vsel: convert micro-volts to voltage selector
+ *
+ * voltage controller/processor drivers SHOULD NOT do modifications on vsel or
+ * make any assumptions about vsel. Instead, they may operate on micro-volts
+ * and request vsel conversion once they are ready to do hardware operations.
+ *
+ * This is provided over the omap_pmic structure.
+ */
+struct omap_pmic_ops {
+	int (*vsel_to_uv) (struct omap_pmic *pmic, u8 vsel, u32 *uv);
+	int (*uv_to_vsel) (struct omap_pmic *pmic, u32 uv, u8 *vsel);
+};
+
+/**
+ * struct omap_pmic_controller_ops - regulator operations implemented
+ * @devm_pmic_register: managed registration of an PMIC device with a specific
+ *			voltage processor. Voltage processor provides an device
+ *			handle which is remaining operations.
+ *			NOTE:
+ *			- This will be first interface to be invoked by
+ *			omap_pmic regulator.
+ *			- if the underlying layers are not ready, this is
+ *			expected to return -EPROBE_DEFER
+ *			- if failure, appropriate error code is expected.
+ *			- This is expected to be a managed device to avoid
+ *			explicit cleanup operations
+ *			- Once this succeeds, this returns the pointer to
+ *			the controller device and all other operations are
+ *			expected to be ready for functionality.
+ * @voltage_set:	set the voltage - expected to be synchronous.
+ * @voltage_get:	get the current voltage in micro-volts set on PMIC.
+ * @voltage_get_range:	Get minimum and maxium permissible operational voltage
+ *			range for the device - used to set initial regulator
+ *			constraints.
+ *
+ * These voltage processor interfaces are registered by voltage processor driver
+ * using omap_pmic_register_controller_ops. This allows the omap_pmic driver to
+ * operate with a specific voltage processor driver.
+ */
+struct omap_pmic_controller_ops {
+	struct device *(*devm_pmic_register) (struct device *dev,
+					      struct omap_pmic *pmic);
+	int (*voltage_set) (struct device *control_dev, u32 uv);
+	int (*voltage_get) (struct device *control_dev, u32 *uv);
+	int (*voltage_get_range) (struct device *control_dev, u32 *min_uv,
+				  u32 *max_uv);
+};
+
+/**
+ * struct omap_pmic - represents the OMAP PMIC device.
+ * @slave_addr:		7 bit address representing I2C slave address.
+ * @voltage_reg_addr:	I2C register address for setting voltage
+ * @cmd_reg_addr:	I2C register address for low power transition commands
+ * @i2c_timeout_us:	worst case latency for I2C operations for the device
+ * @slew_rate_uV:	Slew rate in uV/uSeconds for voltage transitions
+ * @step_size_uV:	Step size in uV for one vsel increment.
+ * @min_uV:		represents the minimum step_sized incremental voltage
+ * @max_uV:		represents the maximum step_sized incremental voltage
+ * @boot_voltage_uV:	voltage for the PMIC handed over to Linux kernel
+ * @setup_command_list:	array of setup commands for PMIC to operate
+ * @setup_num_commands:	number of setup commands for PMIC to operate
+ * @ops:		PMIC conversion operations.
+ *
+ * NOTE: the fields marked Private are meant for PMIC driver.
+ */
+struct omap_pmic {
+	u8 slave_addr;
+	u8 voltage_reg_addr;
+	u8 cmd_reg_addr;
+	u32 i2c_timeout_us;
+
+	u32 boot_voltage_uV;
+	u32 slew_rate_uV;
+	u32 step_size_uV;
+	u32 min_uV;
+	u32 max_uV;
+
+	struct omap_pmic_setup_commands *setup_command_list;
+	u8 setup_num_commands;
+
+	struct omap_pmic_ops *ops;
+
+	/* Private */
+	u8 voltage_selector_offset;
+	u8 voltage_selector_mask;
+	u8 voltage_selector_setbits;
+	bool voltage_selector_zero;
+	struct device *dev;
+	struct device *v_dev;
+};
+
+#if IS_ENABLED(CONFIG_REGULATOR_TI_OMAP_PMIC)
+int omap_pmic_register_controller_ops(struct omap_pmic_controller_ops *cops);
+#else
+static inline int omap_pmic_register_controller_ops(struct
+						    omap_pmic_controller_ops
+						    *cops)
+{
+	return -EINVAL;
+}
+#endif
+
+#endif				/* __POWER_OMAP_PMIC_H */
-- 
1.7.9.5

