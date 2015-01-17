Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbbAQSQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 13:16:38 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:49447 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbbAQSQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 13:16:33 -0500
From: Beniamino Galvani <b.galvani@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, Carlo Caione <carlo@caione.org>
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v4 1/3] pinctrl: add driver for Amlogic Meson SoCs
Date: Sat, 17 Jan 2015 19:15:14 +0100
Message-Id: <1421518516-26976-2-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421518516-26976-1-git-send-email-b.galvani@gmail.com>
References: <1421518516-26976-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver for the pinmux and GPIO controller available in
Amlogic Meson SoCs. It currently supports only Meson8, however the
common code should be generic enough to work also for other SoCs after
having defined the proper set of functions and groups.

GPIO interrupts are not supported at the moment due to lack of
documentation.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 drivers/pinctrl/Kconfig                |    8 +
 drivers/pinctrl/Makefile               |    1 +
 drivers/pinctrl/meson/Makefile         |    2 +
 drivers/pinctrl/meson/pinctrl-meson.c  |  761 ++++++++++++++++++++++
 drivers/pinctrl/meson/pinctrl-meson.h  |  209 ++++++
 drivers/pinctrl/meson/pinctrl-meson8.c | 1089 ++++++++++++++++++++++++++++++++
 include/dt-bindings/gpio/meson8-gpio.h |  157 +++++
 7 files changed, 2227 insertions(+)
 create mode 100644 drivers/pinctrl/meson/Makefile
 create mode 100644 drivers/pinctrl/meson/pinctrl-meson.c
 create mode 100644 drivers/pinctrl/meson/pinctrl-meson.h
 create mode 100644 drivers/pinctrl/meson/pinctrl-meson8.c
 create mode 100644 include/dt-bindings/gpio/meson8-gpio.h

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index e738cca..ee9f44a 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -96,6 +96,14 @@ config PINCTRL_FALCON
 	depends on SOC_FALCON
 	depends on PINCTRL_LANTIQ
 
+config PINCTRL_MESON
+	bool
+	select PINMUX
+	select PINCONF
+	select GENERIC_PINCONF
+	select OF_GPIO
+	select REGMAP_MMIO
+
 config PINCTRL_ROCKCHIP
 	bool
 	select PINMUX
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 6c28bd6..0475206 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_PINCTRL_AT91)	+= pinctrl-at91.o
 obj-$(CONFIG_PINCTRL_BCM2835)	+= pinctrl-bcm2835.o
 obj-$(CONFIG_PINCTRL_BCM281XX)	+= pinctrl-bcm281xx.o
 obj-$(CONFIG_PINCTRL_FALCON)	+= pinctrl-falcon.o
+obj-$(CONFIG_PINCTRL_MESON)	+= meson/
 obj-$(CONFIG_PINCTRL_PALMAS)	+= pinctrl-palmas.o
 obj-$(CONFIG_PINCTRL_ROCKCHIP)	+= pinctrl-rockchip.o
 obj-$(CONFIG_PINCTRL_SINGLE)	+= pinctrl-single.o
diff --git a/drivers/pinctrl/meson/Makefile b/drivers/pinctrl/meson/Makefile
new file mode 100644
index 0000000..eafc216
--- /dev/null
+++ b/drivers/pinctrl/meson/Makefile
@@ -0,0 +1,2 @@
+obj-y	+= pinctrl-meson8.o
+obj-y	+= pinctrl-meson.o
diff --git a/drivers/pinctrl/meson/pinctrl-meson.c b/drivers/pinctrl/meson/pinctrl-meson.c
new file mode 100644
index 0000000..a2bf49c
--- /dev/null
+++ b/drivers/pinctrl/meson/pinctrl-meson.c
@@ -0,0 +1,761 @@
+/*
+ * Pin controller and GPIO driver for Amlogic Meson SoCs
+ *
+ * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+/*
+ * The available pins are organized in banks (A,B,C,D,E,X,Y,Z,AO,
+ * BOOT,CARD for meson6 and X,Y,DV,H,Z,AO,BOOT,CARD for meson8) and
+ * each bank has a variable number of pins.
+ *
+ * The AO bank is special because it belongs to the Always-On power
+ * domain which can't be powered off; the bank also uses a set of
+ * registers different from the other banks.
+ *
+ * For each of the two power domains (regular and always-on) there are
+ * 4 different register ranges that control the following properties
+ * of the pins:
+ *  1) pin muxing
+ *  2) pull enable/disable
+ *  3) pull up/down
+ *  4) GPIO direction, output value, input value
+ *
+ * In some cases the register ranges for pull enable and pull
+ * direction are the same and thus there are only 3 register ranges.
+ *
+ * Every pinmux group can be enabled by a specific bit in the first
+ * register range of the domain; when all groups for a given pin are
+ * disabled the pin acts as a GPIO.
+ *
+ * For the pull and GPIO configuration every bank uses a contiguous
+ * set of bits in the register sets described above; the same register
+ * can be shared by more banks with different offsets.
+ *
+ * In addition to this there are some registers shared between all
+ * banks that control the IRQ functionality. This feature is not
+ * supported at the moment by the driver.
+ */
+
+#include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/pinctrl/pinconf-generic.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/seq_file.h>
+
+#include "../core.h"
+#include "../pinctrl-utils.h"
+#include "pinctrl-meson.h"
+
+/**
+ * meson_get_bank() - find the bank containing a given pin
+ *
+ * @domain:	the domain containing the pin
+ * @pin:	the pin number
+ * @bank:	the found bank
+ *
+ * Return:	0 on success, a negative value on error
+ */
+static int meson_get_bank(struct meson_domain *domain, unsigned int pin,
+			  struct meson_bank **bank)
+{
+	int i;
+
+	for (i = 0; i < domain->data->num_banks; i++) {
+		if (pin >= domain->data->banks[i].first &&
+		    pin <= domain->data->banks[i].last) {
+			*bank = &domain->data->banks[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+/**
+ * meson_get_domain_and_bank() - find domain and bank containing a given pin
+ *
+ * @pc:		Meson pin controller device
+ * @pin:	the pin number
+ * @domain:	the found domain
+ * @bank:	the found bank
+ *
+ * Return:	0 on success, a negative value on error
+ */
+static int meson_get_domain_and_bank(struct meson_pinctrl *pc, unsigned int pin,
+				     struct meson_domain **domain,
+				     struct meson_bank **bank)
+{
+	struct meson_domain *d;
+	int i;
+
+	for (i = 0; i < pc->data->num_domains; i++) {
+		d = &pc->domains[i];
+		if (pin >= d->data->pin_base &&
+		    pin < d->data->pin_base + d->data->num_pins) {
+			*domain = d;
+			return meson_get_bank(d, pin, bank);
+		}
+	}
+
+	return -EINVAL;
+}
+
+/**
+ * meson_calc_reg_and_bit() - calculate register and bit for a pin
+ *
+ * @bank:	the bank containing the pin
+ * @pin:	the pin number
+ * @reg_type:	the type of register needed (pull-enable, pull, etc...)
+ * @reg:	the computed register offset
+ * @bit:	the computed bit
+ */
+static void meson_calc_reg_and_bit(struct meson_bank *bank, unsigned int pin,
+				   enum meson_reg_type reg_type,
+				   unsigned int *reg, unsigned int *bit)
+{
+	struct meson_reg_desc *desc = &bank->regs[reg_type];
+
+	*reg = desc->reg * 4;
+	*bit = desc->bit + pin - bank->first;
+}
+
+static int meson_get_groups_count(struct pinctrl_dev *pcdev)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	return pc->data->num_groups;
+}
+
+static const char *meson_get_group_name(struct pinctrl_dev *pcdev,
+					unsigned selector)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	return pc->data->groups[selector].name;
+}
+
+static int meson_get_group_pins(struct pinctrl_dev *pcdev, unsigned selector,
+				const unsigned **pins, unsigned *num_pins)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	*pins = pc->data->groups[selector].pins;
+	*num_pins = pc->data->groups[selector].num_pins;
+
+	return 0;
+}
+
+static void meson_pin_dbg_show(struct pinctrl_dev *pcdev, struct seq_file *s,
+			       unsigned offset)
+{
+	seq_printf(s, " %s", dev_name(pcdev->dev));
+}
+
+static const struct pinctrl_ops meson_pctrl_ops = {
+	.get_groups_count	= meson_get_groups_count,
+	.get_group_name		= meson_get_group_name,
+	.get_group_pins		= meson_get_group_pins,
+	.dt_node_to_map		= pinconf_generic_dt_node_to_map_all,
+	.dt_free_map		= pinctrl_utils_dt_free_map,
+	.pin_dbg_show		= meson_pin_dbg_show,
+};
+
+/**
+ * meson_pmx_disable_other_groups() - disable other groups using a given pin
+ *
+ * @pc:		meson pin controller device
+ * @pin:	number of the pin
+ * @sel_group:	index of the selected group, or -1 if none
+ *
+ * The function disables all pinmux groups using a pin except the
+ * selected one. If @sel_group is -1 all groups are disabled, leaving
+ * the pin in GPIO mode.
+ */
+static void meson_pmx_disable_other_groups(struct meson_pinctrl *pc,
+					   unsigned int pin, int sel_group)
+{
+	struct meson_pmx_group *group;
+	struct meson_domain *domain;
+	int i, j;
+
+	for (i = 0; i < pc->data->num_groups; i++) {
+		group = &pc->data->groups[i];
+		if (group->is_gpio || i == sel_group)
+			continue;
+
+		for (j = 0; j < group->num_pins; j++) {
+			if (group->pins[j] == pin) {
+				/* We have found a group using the pin */
+				domain = &pc->domains[group->domain];
+				regmap_update_bits(domain->reg_mux,
+						   group->reg * 4,
+						   BIT(group->bit), 0);
+			}
+		}
+	}
+}
+
+static int meson_pmx_set_mux(struct pinctrl_dev *pcdev, unsigned func_num,
+			     unsigned group_num)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+	struct meson_pmx_func *func = &pc->data->funcs[func_num];
+	struct meson_pmx_group *group = &pc->data->groups[group_num];
+	struct meson_domain *domain = &pc->domains[group->domain];
+	int i, ret = 0;
+
+	dev_dbg(pc->dev, "enable function %s, group %s\n", func->name,
+		group->name);
+
+	/*
+	 * Disable groups using the same pin.
+	 * The selected group is not disabled to avoid glitches.
+	 */
+	for (i = 0; i < group->num_pins; i++)
+		meson_pmx_disable_other_groups(pc, group->pins[i], group_num);
+
+	/* Function 0 (GPIO) doesn't need any additional setting */
+	if (func_num)
+		ret = regmap_update_bits(domain->reg_mux, group->reg * 4,
+					 BIT(group->bit), BIT(group->bit));
+
+	return ret;
+}
+
+static int meson_pmx_request_gpio(struct pinctrl_dev *pcdev,
+				  struct pinctrl_gpio_range *range,
+				  unsigned offset)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	meson_pmx_disable_other_groups(pc, range->pin_base + offset, -1);
+
+	return 0;
+}
+
+static int meson_pmx_get_funcs_count(struct pinctrl_dev *pcdev)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	return pc->data->num_funcs;
+}
+
+static const char *meson_pmx_get_func_name(struct pinctrl_dev *pcdev,
+					   unsigned selector)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	return pc->data->funcs[selector].name;
+}
+
+static int meson_pmx_get_groups(struct pinctrl_dev *pcdev, unsigned selector,
+				const char * const **groups,
+				unsigned * const num_groups)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	*groups = pc->data->funcs[selector].groups;
+	*num_groups = pc->data->funcs[selector].num_groups;
+
+	return 0;
+}
+
+static const struct pinmux_ops meson_pmx_ops = {
+	.set_mux = meson_pmx_set_mux,
+	.get_functions_count = meson_pmx_get_funcs_count,
+	.get_function_name = meson_pmx_get_func_name,
+	.get_function_groups = meson_pmx_get_groups,
+	.gpio_request_enable = meson_pmx_request_gpio,
+};
+
+static int meson_pinconf_set(struct pinctrl_dev *pcdev, unsigned int pin,
+			     unsigned long *configs, unsigned num_configs)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+	struct meson_domain *domain;
+	struct meson_bank *bank;
+	enum pin_config_param param;
+	unsigned int reg, bit;
+	int i, ret;
+	u16 arg;
+
+	ret = meson_get_domain_and_bank(pc, pin, &domain, &bank);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < num_configs; i++) {
+		param = pinconf_to_config_param(configs[i]);
+		arg = pinconf_to_config_argument(configs[i]);
+
+		switch (param) {
+		case PIN_CONFIG_BIAS_DISABLE:
+			dev_dbg(pc->dev, "pin %u: disable bias\n", pin);
+
+			meson_calc_reg_and_bit(bank, pin, REG_PULL, &reg, &bit);
+			ret = regmap_update_bits(domain->reg_pull, reg,
+						 BIT(bit), 0);
+			if (ret)
+				return ret;
+			break;
+		case PIN_CONFIG_BIAS_PULL_UP:
+			dev_dbg(pc->dev, "pin %u: enable pull-up\n", pin);
+
+			meson_calc_reg_and_bit(bank, pin, REG_PULLEN,
+					       &reg, &bit);
+			ret = regmap_update_bits(domain->reg_pullen, reg,
+						 BIT(bit), BIT(bit));
+			if (ret)
+				return ret;
+
+			meson_calc_reg_and_bit(bank, pin, REG_PULL, &reg, &bit);
+			ret = regmap_update_bits(domain->reg_pull, reg,
+						 BIT(bit), BIT(bit));
+			if (ret)
+				return ret;
+			break;
+		case PIN_CONFIG_BIAS_PULL_DOWN:
+			dev_dbg(pc->dev, "pin %u: enable pull-down\n", pin);
+
+			meson_calc_reg_and_bit(bank, pin, REG_PULLEN,
+					       &reg, &bit);
+			ret = regmap_update_bits(domain->reg_pullen, reg,
+						 BIT(bit), BIT(bit));
+			if (ret)
+				return ret;
+
+			meson_calc_reg_and_bit(bank, pin, REG_PULL, &reg, &bit);
+			ret = regmap_update_bits(domain->reg_pull, reg,
+						 BIT(bit), 0);
+			if (ret)
+				return ret;
+			break;
+		default:
+			return -ENOTSUPP;
+		}
+	}
+
+	return 0;
+}
+
+static int meson_pinconf_get_pull(struct meson_pinctrl *pc, unsigned int pin)
+{
+	struct meson_domain *domain;
+	struct meson_bank *bank;
+	unsigned int reg, bit, val;
+	int ret, conf;
+
+	ret = meson_get_domain_and_bank(pc, pin, &domain, &bank);
+	if (ret)
+		return ret;
+
+	meson_calc_reg_and_bit(bank, pin, REG_PULLEN, &reg, &bit);
+
+	ret = regmap_read(domain->reg_pullen, reg, &val);
+	if (ret)
+		return ret;
+
+	if (!(val & BIT(bit))) {
+		conf = PIN_CONFIG_BIAS_DISABLE;
+	} else {
+		meson_calc_reg_and_bit(bank, pin, REG_PULL, &reg, &bit);
+
+		ret = regmap_read(domain->reg_pull, reg, &val);
+		if (ret)
+			return ret;
+
+		if (val & BIT(bit))
+			conf = PIN_CONFIG_BIAS_PULL_UP;
+		else
+			conf = PIN_CONFIG_BIAS_PULL_DOWN;
+	}
+
+	return conf;
+}
+
+static int meson_pinconf_get(struct pinctrl_dev *pcdev, unsigned int pin,
+			     unsigned long *config)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+	enum pin_config_param param = pinconf_to_config_param(*config);
+	u16 arg;
+
+	switch (param) {
+	case PIN_CONFIG_BIAS_DISABLE:
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+	case PIN_CONFIG_BIAS_PULL_UP:
+		if (meson_pinconf_get_pull(pc, pin) == param)
+			arg = 1;
+		else
+			return -EINVAL;
+		break;
+	default:
+		return -ENOTSUPP;
+	}
+
+	*config = pinconf_to_config_packed(param, arg);
+	dev_dbg(pc->dev, "pinconf for pin %u is %lu\n", pin, *config);
+
+	return 0;
+}
+
+static int meson_pinconf_group_set(struct pinctrl_dev *pcdev,
+				   unsigned int num_group,
+				   unsigned long *configs, unsigned num_configs)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+	struct meson_pmx_group *group = &pc->data->groups[num_group];
+	int i;
+
+	dev_dbg(pc->dev, "set pinconf for group %s\n", group->name);
+
+	for (i = 0; i < group->num_pins; i++) {
+		meson_pinconf_set(pcdev, group->pins[i], configs,
+				  num_configs);
+	}
+
+	return 0;
+}
+
+static int meson_pinconf_group_get(struct pinctrl_dev *pcdev,
+				   unsigned int group, unsigned long *config)
+{
+	return -ENOSYS;
+}
+
+static const struct pinconf_ops meson_pinconf_ops = {
+	.pin_config_get		= meson_pinconf_get,
+	.pin_config_set		= meson_pinconf_set,
+	.pin_config_group_get	= meson_pinconf_group_get,
+	.pin_config_group_set	= meson_pinconf_group_set,
+	.is_generic		= true,
+};
+
+static inline struct meson_domain *to_meson_domain(struct gpio_chip *chip)
+{
+	return container_of(chip, struct meson_domain, chip);
+}
+
+static int meson_gpio_request(struct gpio_chip *chip, unsigned gpio)
+{
+	return pinctrl_request_gpio(chip->base + gpio);
+}
+
+static void meson_gpio_free(struct gpio_chip *chip, unsigned gpio)
+{
+	struct meson_domain *domain = to_meson_domain(chip);
+
+	pinctrl_free_gpio(domain->data->pin_base + gpio);
+}
+
+static int meson_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
+{
+	struct meson_domain *domain = to_meson_domain(chip);
+	unsigned int reg, bit, pin;
+	struct meson_bank *bank;
+	int ret;
+
+	pin = domain->data->pin_base + gpio;
+	ret = meson_get_bank(domain, pin, &bank);
+	if (ret)
+		return ret;
+
+	meson_calc_reg_and_bit(bank, pin, REG_DIR, &reg, &bit);
+
+	return regmap_update_bits(domain->reg_gpio, reg, BIT(bit), BIT(bit));
+}
+
+static int meson_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
+				       int value)
+{
+	struct meson_domain *domain = to_meson_domain(chip);
+	unsigned int reg, bit, pin;
+	struct meson_bank *bank;
+	int ret;
+
+	pin = domain->data->pin_base + gpio;
+	ret = meson_get_bank(domain, pin, &bank);
+	if (ret)
+		return ret;
+
+	meson_calc_reg_and_bit(bank, pin, REG_DIR, &reg, &bit);
+	ret = regmap_update_bits(domain->reg_gpio, reg, BIT(bit), 0);
+	if (ret)
+		return ret;
+
+	meson_calc_reg_and_bit(bank, pin, REG_OUT, &reg, &bit);
+	return regmap_update_bits(domain->reg_gpio, reg, BIT(bit),
+				  value ? BIT(bit) : 0);
+}
+
+static void meson_gpio_set(struct gpio_chip *chip, unsigned gpio, int value)
+{
+	struct meson_domain *domain = to_meson_domain(chip);
+	unsigned int reg, bit, pin;
+	struct meson_bank *bank;
+	int ret;
+
+	pin = domain->data->pin_base + gpio;
+	ret = meson_get_bank(domain, pin, &bank);
+	if (ret)
+		return;
+
+	meson_calc_reg_and_bit(bank, pin, REG_OUT, &reg, &bit);
+	regmap_update_bits(domain->reg_gpio, reg, BIT(bit),
+			   value ? BIT(bit) : 0);
+}
+
+static int meson_gpio_get(struct gpio_chip *chip, unsigned gpio)
+{
+	struct meson_domain *domain = to_meson_domain(chip);
+	unsigned int reg, bit, val, pin;
+	struct meson_bank *bank;
+	int ret;
+
+	pin = domain->data->pin_base + gpio;
+	ret = meson_get_bank(domain, pin, &bank);
+	if (ret)
+		return ret;
+
+	meson_calc_reg_and_bit(bank, pin, REG_IN, &reg, &bit);
+	regmap_read(domain->reg_gpio, reg, &val);
+
+	return !!(val & BIT(bit));
+}
+
+static const struct of_device_id meson_pinctrl_dt_match[] = {
+	{
+		.compatible = "amlogic,meson8-pinctrl",
+		.data = &meson8_pinctrl_data,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, meson_pinctrl_dt_match);
+
+static int meson_gpiolib_register(struct meson_pinctrl *pc)
+{
+	struct meson_domain *domain;
+	int i, ret;
+
+	for (i = 0; i < pc->data->num_domains; i++) {
+		domain = &pc->domains[i];
+
+		domain->chip.label = domain->data->name;
+		domain->chip.dev = pc->dev;
+		domain->chip.request = meson_gpio_request;
+		domain->chip.free = meson_gpio_free;
+		domain->chip.direction_input = meson_gpio_direction_input;
+		domain->chip.direction_output = meson_gpio_direction_output;
+		domain->chip.get = meson_gpio_get;
+		domain->chip.set = meson_gpio_set;
+		domain->chip.base = -1;
+		domain->chip.ngpio = domain->data->num_pins;
+		domain->chip.can_sleep = false;
+		domain->chip.of_node = domain->of_node;
+		domain->chip.of_gpio_n_cells = 2;
+
+		ret = gpiochip_add(&domain->chip);
+		if (ret) {
+			dev_err(pc->dev, "can't add gpio chip %s\n",
+				domain->data->name);
+			goto fail;
+		}
+
+		ret = gpiochip_add_pin_range(&domain->chip, dev_name(pc->dev),
+					     0, domain->data->pin_base,
+					     domain->chip.ngpio);
+		if (ret) {
+			dev_err(pc->dev, "can't add pin range\n");
+			goto fail;
+		}
+	}
+
+	return 0;
+fail:
+	for (i--; i >= 0; i--)
+		gpiochip_remove(&pc->domains[i].chip);
+
+	return ret;
+}
+
+static struct meson_domain_data *meson_get_domain_data(struct meson_pinctrl *pc,
+						       struct device_node *np)
+{
+	int i;
+
+	for (i = 0; i < pc->data->num_domains; i++) {
+		if (!strcmp(np->name, pc->data->domain_data[i].name))
+			return &pc->data->domain_data[i];
+	}
+
+	return NULL;
+}
+
+static struct regmap_config meson_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+};
+
+static struct regmap *meson_map_resource(struct meson_pinctrl *pc,
+					 struct device_node *node, char *name)
+{
+	struct resource res;
+	void __iomem *base;
+	int i;
+
+	i = of_property_match_string(node, "reg-names", name);
+	if (of_address_to_resource(node, i, &res))
+		return ERR_PTR(-ENOENT);
+
+	base = devm_ioremap_resource(pc->dev, &res);
+	if (IS_ERR(base))
+		return ERR_CAST(base);
+
+	meson_regmap_config.max_register = resource_size(&res) - 4;
+	meson_regmap_config.name = devm_kasprintf(pc->dev, GFP_KERNEL,
+						  "%s-%s", node->name,
+						  name);
+	if (!meson_regmap_config.name)
+		return ERR_PTR(-ENOMEM);
+
+	return devm_regmap_init_mmio(pc->dev, base, &meson_regmap_config);
+}
+
+static int meson_pinctrl_parse_dt(struct meson_pinctrl *pc,
+				  struct device_node *node)
+{
+	struct device_node *np;
+	struct meson_domain *domain;
+	int i = 0, num_domains = 0;
+
+	for_each_child_of_node(node, np) {
+		if (!of_find_property(np, "gpio-controller", NULL))
+			continue;
+		num_domains++;
+	}
+
+	if (num_domains != pc->data->num_domains) {
+		dev_err(pc->dev, "wrong number of subnodes\n");
+		return -EINVAL;
+	}
+
+	pc->domains = devm_kzalloc(pc->dev, num_domains *
+				   sizeof(struct meson_domain), GFP_KERNEL);
+	if (!pc->domains)
+		return -ENOMEM;
+
+	for_each_child_of_node(node, np) {
+		if (!of_find_property(np, "gpio-controller", NULL))
+			continue;
+
+		domain = &pc->domains[i];
+
+		domain->data = meson_get_domain_data(pc, np);
+		if (!domain->data) {
+			dev_err(pc->dev, "domain data not found for node %s\n",
+				np->name);
+			return -ENODEV;
+		}
+
+		domain->of_node = np;
+
+		domain->reg_mux = meson_map_resource(pc, np, "mux");
+		if (IS_ERR(domain->reg_mux)) {
+			dev_err(pc->dev, "mux registers not found\n");
+			return PTR_ERR(domain->reg_mux);
+		}
+
+		domain->reg_pull = meson_map_resource(pc, np, "pull");
+		if (IS_ERR(domain->reg_pull)) {
+			dev_err(pc->dev, "pull registers not found\n");
+			return PTR_ERR(domain->reg_pull);
+		}
+
+		domain->reg_pullen = meson_map_resource(pc, np, "pull-enable");
+		/* Use pull region if pull-enable one is not present */
+		if (IS_ERR(domain->reg_pullen))
+			domain->reg_pullen = domain->reg_pull;
+
+		domain->reg_gpio = meson_map_resource(pc, np, "gpio");
+		if (IS_ERR(domain->reg_gpio)) {
+			dev_err(pc->dev, "gpio registers not found\n");
+			return PTR_ERR(domain->reg_gpio);
+		}
+
+		i++;
+	}
+
+	return 0;
+}
+
+static int meson_pinctrl_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	struct device *dev = &pdev->dev;
+	struct meson_pinctrl *pc;
+	int ret;
+
+	pc = devm_kzalloc(dev, sizeof(struct meson_pinctrl), GFP_KERNEL);
+	if (!pc)
+		return -ENOMEM;
+
+	pc->dev = dev;
+	match = of_match_node(meson_pinctrl_dt_match, pdev->dev.of_node);
+	pc->data = (struct meson_pinctrl_data *)match->data;
+
+	ret = meson_pinctrl_parse_dt(pc, pdev->dev.of_node);
+	if (ret)
+		return ret;
+
+	pc->desc.name		= "pinctrl-meson";
+	pc->desc.owner		= THIS_MODULE;
+	pc->desc.pctlops	= &meson_pctrl_ops;
+	pc->desc.pmxops		= &meson_pmx_ops;
+	pc->desc.confops	= &meson_pinconf_ops;
+	pc->desc.pins		= pc->data->pins;
+	pc->desc.npins		= pc->data->num_pins;
+
+	pc->pcdev = pinctrl_register(&pc->desc, pc->dev, pc);
+	if (!pc->pcdev) {
+		dev_err(pc->dev, "can't register pinctrl device");
+		return -EINVAL;
+	}
+
+	ret = meson_gpiolib_register(pc);
+	if (ret) {
+		pinctrl_unregister(pc->pcdev);
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct platform_driver meson_pinctrl_driver = {
+	.probe		= meson_pinctrl_probe,
+	.driver = {
+		.name	= "meson-pinctrl",
+		.of_match_table = meson_pinctrl_dt_match,
+	},
+};
+module_platform_driver(meson_pinctrl_driver);
+
+MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
+MODULE_DESCRIPTION("Amlogic Meson pinctrl driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/meson/pinctrl-meson.h b/drivers/pinctrl/meson/pinctrl-meson.h
new file mode 100644
index 0000000..bfea8ad
--- /dev/null
+++ b/drivers/pinctrl/meson/pinctrl-meson.h
@@ -0,0 +1,209 @@
+/*
+ * Pin controller and GPIO driver for Amlogic Meson SoCs
+ *
+ * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/gpio.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/regmap.h>
+#include <linux/types.h>
+
+/**
+ * struct meson_pmx_group - a pinmux group
+ *
+ * @name:	group name
+ * @pins:	pins in the group
+ * @num_pins:	number of pins in the group
+ * @is_gpio:	whether the group is a single GPIO group
+ * @reg:	register offset for the group in the domain mux registers
+ * @bit		bit index enabling the group
+ * @domain:	index of the domain this group belongs to
+ */
+struct meson_pmx_group {
+	const char *name;
+	const unsigned int *pins;
+	unsigned int num_pins;
+	bool is_gpio;
+	unsigned int reg;
+	unsigned int bit;
+	unsigned int domain;
+};
+
+/**
+ * struct meson_pmx_func - a pinmux function
+ *
+ * @name:	function name
+ * @groups:	groups in the function
+ * @num_groups:	number of groups in the function
+ */
+struct meson_pmx_func {
+	const char *name;
+	const char * const *groups;
+	unsigned int num_groups;
+};
+
+/**
+ * struct meson_reg_desc - a register descriptor
+ *
+ * @reg:	register offset in the regmap
+ * @bit:	bit index in register
+ *
+ * The structure describes the information needed to control pull,
+ * pull-enable, direction, etc. for a single pin
+ */
+struct meson_reg_desc {
+	unsigned int reg;
+	unsigned int bit;
+};
+
+/**
+ * enum meson_reg_type - type of registers encoded in @meson_reg_desc
+ */
+enum meson_reg_type {
+	REG_PULLEN,
+	REG_PULL,
+	REG_DIR,
+	REG_OUT,
+	REG_IN,
+	NUM_REG,
+};
+
+/**
+ * struct meson bank
+ *
+ * @name:	bank name
+ * @first:	first pin of the bank
+ * @last:	last pin of the bank
+ * @regs:	array of register descriptors
+ *
+ * A bank represents a set of pins controlled by a contiguous set of
+ * bits in the domain registers. The structure specifies which bits in
+ * the regmap control the different functionalities. Each member of
+ * the @regs array refers to the first pin of the bank.
+ */
+struct meson_bank {
+	const char *name;
+	unsigned int first;
+	unsigned int last;
+	struct meson_reg_desc regs[NUM_REG];
+};
+
+/**
+ * struct meson_domain_data - domain platform data
+ *
+ * @name:	name of the domain
+ * @banks:	set of banks belonging to the domain
+ * @num_banks:	number of banks in the domain
+ */
+struct meson_domain_data {
+	const char *name;
+	struct meson_bank *banks;
+	unsigned int num_banks;
+	unsigned int pin_base;
+	unsigned int num_pins;
+};
+
+/**
+ * struct meson_domain
+ *
+ * @reg_mux:	registers for mux settings
+ * @reg_pullen:	registers for pull-enable settings
+ * @reg_pull:	registers for pull settings
+ * @reg_gpio:	registers for gpio settings
+ * @chip:	gpio chip associated with the domain
+ * @data;	platform data for the domain
+ * @node:	device tree node for the domain
+ *
+ * A domain represents a set of banks controlled by the same set of
+ * registers.
+ */
+struct meson_domain {
+	struct regmap *reg_mux;
+	struct regmap *reg_pullen;
+	struct regmap *reg_pull;
+	struct regmap *reg_gpio;
+
+	struct gpio_chip chip;
+	struct meson_domain_data *data;
+	struct device_node *of_node;
+};
+
+struct meson_pinctrl_data {
+	const struct pinctrl_pin_desc *pins;
+	struct meson_pmx_group *groups;
+	struct meson_pmx_func *funcs;
+	struct meson_domain_data *domain_data;
+	unsigned int num_pins;
+	unsigned int num_groups;
+	unsigned int num_funcs;
+	unsigned int num_domains;
+};
+
+struct meson_pinctrl {
+	struct device *dev;
+	struct pinctrl_dev *pcdev;
+	struct pinctrl_desc desc;
+	struct meson_pinctrl_data *data;
+	struct meson_domain *domains;
+};
+
+#define GROUP(grp, r, b)						\
+	{								\
+		.name = #grp,						\
+		.pins = grp ## _pins,					\
+		.num_pins = ARRAY_SIZE(grp ## _pins),			\
+		.reg = r,						\
+		.bit = b,						\
+		.domain = 0,						\
+	 }
+
+#define GPIO_GROUP(gpio)						\
+	{								\
+		.name = #gpio,						\
+		.pins = (const unsigned int[]){ PIN_ ## gpio},		\
+		.num_pins = 1,						\
+		.is_gpio = true,					\
+	 }
+
+#define GROUP_AO(grp, r, b)						\
+	{								\
+		.name = #grp,						\
+		.pins = grp ## _pins,					\
+		.num_pins = ARRAY_SIZE(grp ## _pins),			\
+		.reg = r,						\
+		.bit = b,						\
+		.domain = 1,						\
+	 }
+
+#define FUNCTION(fn)							\
+	{								\
+		.name = #fn,						\
+		.groups = fn ## _groups,				\
+		.num_groups = ARRAY_SIZE(fn ## _groups),		\
+	}
+
+#define BANK(n, f, l, per, peb, pr, pb, dr, db, or, ob, ir, ib)		\
+	{								\
+		.name	= n,						\
+		.first	= f,						\
+		.last	= l,						\
+		.regs	= {						\
+			[REG_PULLEN]	= { per, peb },			\
+			[REG_PULL]	= { pr, pb },			\
+			[REG_DIR]	= { dr, db },			\
+			[REG_OUT]	= { or, ob },			\
+			[REG_IN]	= { ir, ib },			\
+		},							\
+	 }
+
+#define MESON_PIN(x) PINCTRL_PIN(PIN_ ## x, #x)
+
+extern struct meson_pinctrl_data meson8_pinctrl_data;
diff --git a/drivers/pinctrl/meson/pinctrl-meson8.c b/drivers/pinctrl/meson/pinctrl-meson8.c
new file mode 100644
index 0000000..f8aa3a2
--- /dev/null
+++ b/drivers/pinctrl/meson/pinctrl-meson8.c
@@ -0,0 +1,1089 @@
+/*
+ * Pin controller and GPIO driver for Amlogic Meson8.
+ *
+ * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <dt-bindings/gpio/meson8-gpio.h>
+#include "pinctrl-meson.h"
+
+#define AO_OFFSET	120
+
+#define PIN_GPIOX_0	GPIOX_0
+#define PIN_GPIOX_1	GPIOX_1
+#define PIN_GPIOX_2	GPIOX_2
+#define PIN_GPIOX_3	GPIOX_3
+#define PIN_GPIOX_4	GPIOX_4
+#define PIN_GPIOX_5	GPIOX_5
+#define PIN_GPIOX_6	GPIOX_6
+#define PIN_GPIOX_7	GPIOX_7
+#define PIN_GPIOX_8	GPIOX_8
+#define PIN_GPIOX_9	GPIOX_9
+#define PIN_GPIOX_10	GPIOX_10
+#define PIN_GPIOX_11	GPIOX_11
+#define PIN_GPIOX_12	GPIOX_12
+#define PIN_GPIOX_13	GPIOX_13
+#define PIN_GPIOX_14	GPIOX_14
+#define PIN_GPIOX_15	GPIOX_15
+#define PIN_GPIOX_16	GPIOX_16
+#define PIN_GPIOX_17	GPIOX_17
+#define PIN_GPIOX_18	GPIOX_18
+#define PIN_GPIOX_19	GPIOX_19
+#define PIN_GPIOX_20	GPIOX_20
+#define PIN_GPIOX_21	GPIOX_21
+#define PIN_GPIOY_0	GPIOY_0
+#define PIN_GPIOY_1	GPIOY_1
+#define PIN_GPIOY_2	GPIOY_2
+#define PIN_GPIOY_3	GPIOY_3
+#define PIN_GPIOY_4	GPIOY_4
+#define PIN_GPIOY_5	GPIOY_5
+#define PIN_GPIOY_6	GPIOY_6
+#define PIN_GPIOY_7	GPIOY_7
+#define PIN_GPIOY_8	GPIOY_8
+#define PIN_GPIOY_9	GPIOY_9
+#define PIN_GPIOY_10	GPIOY_10
+#define PIN_GPIOY_11	GPIOY_11
+#define PIN_GPIOY_12	GPIOY_12
+#define PIN_GPIOY_13	GPIOY_13
+#define PIN_GPIOY_14	GPIOY_14
+#define PIN_GPIOY_15	GPIOY_15
+#define PIN_GPIOY_16	GPIOY_16
+#define PIN_GPIODV_0	GPIODV_0
+#define PIN_GPIODV_1	GPIODV_1
+#define PIN_GPIODV_2	GPIODV_2
+#define PIN_GPIODV_3	GPIODV_3
+#define PIN_GPIODV_4	GPIODV_4
+#define PIN_GPIODV_5	GPIODV_5
+#define PIN_GPIODV_6	GPIODV_6
+#define PIN_GPIODV_7	GPIODV_7
+#define PIN_GPIODV_8	GPIODV_8
+#define PIN_GPIODV_9	GPIODV_9
+#define PIN_GPIODV_10	GPIODV_10
+#define PIN_GPIODV_11	GPIODV_11
+#define PIN_GPIODV_12	GPIODV_12
+#define PIN_GPIODV_13	GPIODV_13
+#define PIN_GPIODV_14	GPIODV_14
+#define PIN_GPIODV_15	GPIODV_15
+#define PIN_GPIODV_16	GPIODV_16
+#define PIN_GPIODV_17	GPIODV_17
+#define PIN_GPIODV_18	GPIODV_18
+#define PIN_GPIODV_19	GPIODV_19
+#define PIN_GPIODV_20	GPIODV_20
+#define PIN_GPIODV_21	GPIODV_21
+#define PIN_GPIODV_22	GPIODV_22
+#define PIN_GPIODV_23	GPIODV_23
+#define PIN_GPIODV_24	GPIODV_24
+#define PIN_GPIODV_25	GPIODV_25
+#define PIN_GPIODV_26	GPIODV_26
+#define PIN_GPIODV_27	GPIODV_27
+#define PIN_GPIODV_28	GPIODV_28
+#define PIN_GPIODV_29	GPIODV_29
+#define PIN_GPIOH_0	GPIOH_0
+#define PIN_GPIOH_1	GPIOH_1
+#define PIN_GPIOH_2	GPIOH_2
+#define PIN_GPIOH_3	GPIOH_3
+#define PIN_GPIOH_4	GPIOH_4
+#define PIN_GPIOH_5	GPIOH_5
+#define PIN_GPIOH_6	GPIOH_6
+#define PIN_GPIOH_7	GPIOH_7
+#define PIN_GPIOH_8	GPIOH_8
+#define PIN_GPIOH_9	GPIOH_9
+#define PIN_GPIOZ_0	GPIOZ_0
+#define PIN_GPIOZ_1	GPIOZ_1
+#define PIN_GPIOZ_2	GPIOZ_2
+#define PIN_GPIOZ_3	GPIOZ_3
+#define PIN_GPIOZ_4	GPIOZ_4
+#define PIN_GPIOZ_5	GPIOZ_5
+#define PIN_GPIOZ_6	GPIOZ_6
+#define PIN_GPIOZ_7	GPIOZ_7
+#define PIN_GPIOZ_8	GPIOZ_8
+#define PIN_GPIOZ_9	GPIOZ_9
+#define PIN_GPIOZ_10	GPIOZ_10
+#define PIN_GPIOZ_11	GPIOZ_11
+#define PIN_GPIOZ_12	GPIOZ_12
+#define PIN_GPIOZ_13	GPIOZ_13
+#define PIN_GPIOZ_14	GPIOZ_14
+#define PIN_CARD_0	CARD_0
+#define PIN_CARD_1	CARD_1
+#define PIN_CARD_2	CARD_2
+#define PIN_CARD_3	CARD_3
+#define PIN_CARD_4	CARD_4
+#define PIN_CARD_5	CARD_5
+#define PIN_CARD_6	CARD_6
+#define PIN_BOOT_0	BOOT_0
+#define PIN_BOOT_1	BOOT_1
+#define PIN_BOOT_2	BOOT_2
+#define PIN_BOOT_3	BOOT_3
+#define PIN_BOOT_4	BOOT_4
+#define PIN_BOOT_5	BOOT_5
+#define PIN_BOOT_6	BOOT_6
+#define PIN_BOOT_7	BOOT_7
+#define PIN_BOOT_8	BOOT_8
+#define PIN_BOOT_9	BOOT_9
+#define PIN_BOOT_10	BOOT_10
+#define PIN_BOOT_11	BOOT_11
+#define PIN_BOOT_12	BOOT_12
+#define PIN_BOOT_13	BOOT_13
+#define PIN_BOOT_14	BOOT_14
+#define PIN_BOOT_15	BOOT_15
+#define PIN_BOOT_16	BOOT_16
+#define PIN_BOOT_17	BOOT_17
+#define PIN_BOOT_18	BOOT_18
+
+#define PIN_GPIOAO_0	(AO_OFFSET + GPIOAO_0)
+#define PIN_GPIOAO_1	(AO_OFFSET + GPIOAO_1)
+#define PIN_GPIOAO_2	(AO_OFFSET + GPIOAO_2)
+#define PIN_GPIOAO_3	(AO_OFFSET + GPIOAO_3)
+#define PIN_GPIOAO_4	(AO_OFFSET + GPIOAO_4)
+#define PIN_GPIOAO_5	(AO_OFFSET + GPIOAO_5)
+#define PIN_GPIOAO_6	(AO_OFFSET + GPIOAO_6)
+#define PIN_GPIOAO_7	(AO_OFFSET + GPIOAO_7)
+#define PIN_GPIOAO_8	(AO_OFFSET + GPIOAO_8)
+#define PIN_GPIOAO_9	(AO_OFFSET + GPIOAO_9)
+#define PIN_GPIOAO_10	(AO_OFFSET + GPIOAO_10)
+#define PIN_GPIOAO_11	(AO_OFFSET + GPIOAO_11)
+#define PIN_GPIOAO_12	(AO_OFFSET + GPIOAO_12)
+#define PIN_GPIOAO_13	(AO_OFFSET + GPIOAO_13)
+#define PIN_GPIO_BSD_EN	(AO_OFFSET + GPIO_BSD_EN)
+#define PIN_GPIO_TEST_N	(AO_OFFSET + GPIO_TEST_N)
+
+static const struct pinctrl_pin_desc meson8_pins[] = {
+	MESON_PIN(GPIOX_0),
+	MESON_PIN(GPIOX_1),
+	MESON_PIN(GPIOX_2),
+	MESON_PIN(GPIOX_3),
+	MESON_PIN(GPIOX_4),
+	MESON_PIN(GPIOX_5),
+	MESON_PIN(GPIOX_6),
+	MESON_PIN(GPIOX_7),
+	MESON_PIN(GPIOX_8),
+	MESON_PIN(GPIOX_9),
+	MESON_PIN(GPIOX_10),
+	MESON_PIN(GPIOX_11),
+	MESON_PIN(GPIOX_12),
+	MESON_PIN(GPIOX_13),
+	MESON_PIN(GPIOX_14),
+	MESON_PIN(GPIOX_15),
+	MESON_PIN(GPIOX_16),
+	MESON_PIN(GPIOX_17),
+	MESON_PIN(GPIOX_18),
+	MESON_PIN(GPIOX_19),
+	MESON_PIN(GPIOX_20),
+	MESON_PIN(GPIOX_21),
+	MESON_PIN(GPIOY_0),
+	MESON_PIN(GPIOY_1),
+	MESON_PIN(GPIOY_2),
+	MESON_PIN(GPIOY_3),
+	MESON_PIN(GPIOY_4),
+	MESON_PIN(GPIOY_5),
+	MESON_PIN(GPIOY_6),
+	MESON_PIN(GPIOY_7),
+	MESON_PIN(GPIOY_8),
+	MESON_PIN(GPIOY_9),
+	MESON_PIN(GPIOY_10),
+	MESON_PIN(GPIOY_11),
+	MESON_PIN(GPIOY_12),
+	MESON_PIN(GPIOY_13),
+	MESON_PIN(GPIOY_14),
+	MESON_PIN(GPIOY_15),
+	MESON_PIN(GPIOY_16),
+	MESON_PIN(GPIODV_0),
+	MESON_PIN(GPIODV_1),
+	MESON_PIN(GPIODV_2),
+	MESON_PIN(GPIODV_3),
+	MESON_PIN(GPIODV_4),
+	MESON_PIN(GPIODV_5),
+	MESON_PIN(GPIODV_6),
+	MESON_PIN(GPIODV_7),
+	MESON_PIN(GPIODV_8),
+	MESON_PIN(GPIODV_9),
+	MESON_PIN(GPIODV_10),
+	MESON_PIN(GPIODV_11),
+	MESON_PIN(GPIODV_12),
+	MESON_PIN(GPIODV_13),
+	MESON_PIN(GPIODV_14),
+	MESON_PIN(GPIODV_15),
+	MESON_PIN(GPIODV_16),
+	MESON_PIN(GPIODV_17),
+	MESON_PIN(GPIODV_18),
+	MESON_PIN(GPIODV_19),
+	MESON_PIN(GPIODV_20),
+	MESON_PIN(GPIODV_21),
+	MESON_PIN(GPIODV_22),
+	MESON_PIN(GPIODV_23),
+	MESON_PIN(GPIODV_24),
+	MESON_PIN(GPIODV_25),
+	MESON_PIN(GPIODV_26),
+	MESON_PIN(GPIODV_27),
+	MESON_PIN(GPIODV_28),
+	MESON_PIN(GPIODV_29),
+	MESON_PIN(GPIOH_0),
+	MESON_PIN(GPIOH_1),
+	MESON_PIN(GPIOH_2),
+	MESON_PIN(GPIOH_3),
+	MESON_PIN(GPIOH_4),
+	MESON_PIN(GPIOH_5),
+	MESON_PIN(GPIOH_6),
+	MESON_PIN(GPIOH_7),
+	MESON_PIN(GPIOH_8),
+	MESON_PIN(GPIOH_9),
+	MESON_PIN(GPIOZ_0),
+	MESON_PIN(GPIOZ_1),
+	MESON_PIN(GPIOZ_2),
+	MESON_PIN(GPIOZ_3),
+	MESON_PIN(GPIOZ_4),
+	MESON_PIN(GPIOZ_5),
+	MESON_PIN(GPIOZ_6),
+	MESON_PIN(GPIOZ_7),
+	MESON_PIN(GPIOZ_8),
+	MESON_PIN(GPIOZ_9),
+	MESON_PIN(GPIOZ_10),
+	MESON_PIN(GPIOZ_11),
+	MESON_PIN(GPIOZ_12),
+	MESON_PIN(GPIOZ_13),
+	MESON_PIN(GPIOZ_14),
+	MESON_PIN(CARD_0),
+	MESON_PIN(CARD_1),
+	MESON_PIN(CARD_2),
+	MESON_PIN(CARD_3),
+	MESON_PIN(CARD_4),
+	MESON_PIN(CARD_5),
+	MESON_PIN(CARD_6),
+	MESON_PIN(BOOT_0),
+	MESON_PIN(BOOT_1),
+	MESON_PIN(BOOT_2),
+	MESON_PIN(BOOT_3),
+	MESON_PIN(BOOT_4),
+	MESON_PIN(BOOT_5),
+	MESON_PIN(BOOT_6),
+	MESON_PIN(BOOT_7),
+	MESON_PIN(BOOT_8),
+	MESON_PIN(BOOT_9),
+	MESON_PIN(BOOT_10),
+	MESON_PIN(BOOT_11),
+	MESON_PIN(BOOT_12),
+	MESON_PIN(BOOT_13),
+	MESON_PIN(BOOT_14),
+	MESON_PIN(BOOT_15),
+	MESON_PIN(BOOT_16),
+	MESON_PIN(BOOT_17),
+	MESON_PIN(BOOT_18),
+	MESON_PIN(GPIOAO_0),
+	MESON_PIN(GPIOAO_1),
+	MESON_PIN(GPIOAO_2),
+	MESON_PIN(GPIOAO_3),
+	MESON_PIN(GPIOAO_4),
+	MESON_PIN(GPIOAO_5),
+	MESON_PIN(GPIOAO_6),
+	MESON_PIN(GPIOAO_7),
+	MESON_PIN(GPIOAO_8),
+	MESON_PIN(GPIOAO_9),
+	MESON_PIN(GPIOAO_10),
+	MESON_PIN(GPIOAO_11),
+	MESON_PIN(GPIOAO_12),
+	MESON_PIN(GPIOAO_13),
+	MESON_PIN(GPIO_BSD_EN),
+	MESON_PIN(GPIO_TEST_N),
+};
+
+/* bank X */
+static const unsigned int sd_d0_a_pins[] = { PIN_GPIOX_0 };
+static const unsigned int sd_d1_a_pins[] = { PIN_GPIOX_1 };
+static const unsigned int sd_d2_a_pins[] = { PIN_GPIOX_2 };
+static const unsigned int sd_d3_a_pins[] = { PIN_GPIOX_3 };
+static const unsigned int sd_clk_a_pins[] = { PIN_GPIOX_8 };
+static const unsigned int sd_cmd_a_pins[] = { PIN_GPIOX_9 };
+
+static const unsigned int sdxc_d0_a_pins[] = { PIN_GPIOX_0 };
+static const unsigned int sdxc_d13_a_pins[] = { PIN_GPIOX_1, PIN_GPIOX_2,
+						PIN_GPIOX_3 };
+static const unsigned int sdxc_d47_a_pins[] = { PIN_GPIOX_4, PIN_GPIOX_5,
+						PIN_GPIOX_6, PIN_GPIOX_7 };
+static const unsigned int sdxc_clk_a_pins[] = { PIN_GPIOX_8 };
+static const unsigned int sdxc_cmd_a_pins[] = { PIN_GPIOX_9 };
+
+static const unsigned int pcm_out_a_pins[] = { PIN_GPIOX_4 };
+static const unsigned int pcm_in_a_pins[] = { PIN_GPIOX_5 };
+static const unsigned int pcm_fs_a_pins[] = { PIN_GPIOX_6 };
+static const unsigned int pcm_clk_a_pins[] = { PIN_GPIOX_7 };
+
+static const unsigned int uart_tx_a0_pins[] = { PIN_GPIOX_4 };
+static const unsigned int uart_rx_a0_pins[] = { PIN_GPIOX_5 };
+static const unsigned int uart_cts_a0_pins[] = { PIN_GPIOX_6 };
+static const unsigned int uart_rts_a0_pins[] = { PIN_GPIOX_7 };
+
+static const unsigned int uart_tx_a1_pins[] = { PIN_GPIOX_12 };
+static const unsigned int uart_rx_a1_pins[] = { PIN_GPIOX_13 };
+static const unsigned int uart_cts_a1_pins[] = { PIN_GPIOX_14 };
+static const unsigned int uart_rts_a1_pins[] = { PIN_GPIOX_15 };
+
+static const unsigned int uart_tx_b0_pins[] = { PIN_GPIOX_16 };
+static const unsigned int uart_rx_b0_pins[] = { PIN_GPIOX_17 };
+static const unsigned int uart_cts_b0_pins[] = { PIN_GPIOX_18 };
+static const unsigned int uart_rts_b0_pins[] = { PIN_GPIOX_19 };
+
+static const unsigned int iso7816_det_pins[] = { PIN_GPIOX_16 };
+static const unsigned int iso7816_reset_pins[] = { PIN_GPIOX_17 };
+static const unsigned int iso7816_clk_pins[] = { PIN_GPIOX_18 };
+static const unsigned int iso7816_data_pins[] = { PIN_GPIOX_19 };
+
+static const unsigned int i2c_sda_d0_pins[] = { PIN_GPIOX_16 };
+static const unsigned int i2c_sck_d0_pins[] = { PIN_GPIOX_17 };
+
+static const unsigned int xtal_32k_out_pins[] = { PIN_GPIOX_10 };
+static const unsigned int xtal_24m_out_pins[] = { PIN_GPIOX_11 };
+
+/* bank Y */
+static const unsigned int uart_tx_c_pins[] = { PIN_GPIOY_0 };
+static const unsigned int uart_rx_c_pins[] = { PIN_GPIOY_1 };
+static const unsigned int uart_cts_c_pins[] = { PIN_GPIOY_2 };
+static const unsigned int uart_rts_c_pins[] = { PIN_GPIOY_3 };
+
+static const unsigned int pcm_out_b_pins[] = { PIN_GPIOY_4 };
+static const unsigned int pcm_in_b_pins[] = { PIN_GPIOY_5 };
+static const unsigned int pcm_fs_b_pins[] = { PIN_GPIOY_6 };
+static const unsigned int pcm_clk_b_pins[] = { PIN_GPIOY_7 };
+
+static const unsigned int i2c_sda_c0_pins[] = { PIN_GPIOY_0 };
+static const unsigned int i2c_sck_c0_pins[] = { PIN_GPIOY_1 };
+
+/* bank DV */
+static const unsigned int dvin_rgb_pins[] = { PIN_GPIODV_0, PIN_GPIODV_1,
+					      PIN_GPIODV_2, PIN_GPIODV_3,
+					      PIN_GPIODV_4, PIN_GPIODV_5,
+					      PIN_GPIODV_6, PIN_GPIODV_7,
+					      PIN_GPIODV_8, PIN_GPIODV_9,
+					      PIN_GPIODV_10, PIN_GPIODV_11,
+					      PIN_GPIODV_12, PIN_GPIODV_13,
+					      PIN_GPIODV_14, PIN_GPIODV_15,
+					      PIN_GPIODV_16, PIN_GPIODV_17,
+					      PIN_GPIODV_18, PIN_GPIODV_19,
+					      PIN_GPIODV_20, PIN_GPIODV_21,
+					      PIN_GPIODV_22, PIN_GPIODV_23 };
+static const unsigned int dvin_vs_pins[] = { PIN_GPIODV_24 };
+static const unsigned int dvin_hs_pins[] = { PIN_GPIODV_25 };
+static const unsigned int dvin_clk_pins[] = { PIN_GPIODV_26 };
+static const unsigned int dvin_de_pins[] = { PIN_GPIODV_27 };
+
+static const unsigned int enc_0_pins[] = { PIN_GPIODV_0 };
+static const unsigned int enc_1_pins[] = { PIN_GPIODV_1 };
+static const unsigned int enc_2_pins[] = { PIN_GPIODV_2 };
+static const unsigned int enc_3_pins[] = { PIN_GPIODV_3 };
+static const unsigned int enc_4_pins[] = { PIN_GPIODV_4 };
+static const unsigned int enc_5_pins[] = { PIN_GPIODV_5 };
+static const unsigned int enc_6_pins[] = { PIN_GPIODV_6 };
+static const unsigned int enc_7_pins[] = { PIN_GPIODV_7 };
+static const unsigned int enc_8_pins[] = { PIN_GPIODV_8 };
+static const unsigned int enc_9_pins[] = { PIN_GPIODV_9 };
+static const unsigned int enc_10_pins[] = { PIN_GPIODV_10 };
+static const unsigned int enc_11_pins[] = { PIN_GPIODV_11 };
+static const unsigned int enc_12_pins[] = { PIN_GPIODV_12 };
+static const unsigned int enc_13_pins[] = { PIN_GPIODV_13 };
+static const unsigned int enc_14_pins[] = { PIN_GPIODV_14 };
+static const unsigned int enc_15_pins[] = { PIN_GPIODV_15 };
+static const unsigned int enc_16_pins[] = { PIN_GPIODV_16 };
+static const unsigned int enc_17_pins[] = { PIN_GPIODV_17 };
+
+static const unsigned int uart_tx_b1_pins[] = { PIN_GPIODV_24 };
+static const unsigned int uart_rx_b1_pins[] = { PIN_GPIODV_25 };
+static const unsigned int uart_cts_b1_pins[] = { PIN_GPIODV_26 };
+static const unsigned int uart_rts_b1_pins[] = { PIN_GPIODV_27 };
+
+static const unsigned int vga_vs_pins[] = { PIN_GPIODV_24 };
+static const unsigned int vga_hs_pins[] = { PIN_GPIODV_25 };
+
+/* bank H */
+static const unsigned int hdmi_hpd_pins[] = { PIN_GPIOH_0 };
+static const unsigned int hdmi_sda_pins[] = { PIN_GPIOH_1 };
+static const unsigned int hdmi_scl_pins[] = { PIN_GPIOH_2 };
+static const unsigned int hdmi_cec_pins[] = { PIN_GPIOH_3 };
+
+static const unsigned int spi_ss0_0_pins[] = { PIN_GPIOH_3 };
+static const unsigned int spi_miso_0_pins[] = { PIN_GPIOH_4 };
+static const unsigned int spi_mosi_0_pins[] = { PIN_GPIOH_5 };
+static const unsigned int spi_sclk_0_pins[] = { PIN_GPIOH_6 };
+
+static const unsigned int i2c_sda_d1_pins[] = { PIN_GPIOH_7 };
+static const unsigned int i2c_sck_d1_pins[] = { PIN_GPIOH_8 };
+
+/* bank Z */
+static const unsigned int spi_ss0_1_pins[] = { PIN_GPIOZ_9 };
+static const unsigned int spi_ss1_1_pins[] = { PIN_GPIOZ_10 };
+static const unsigned int spi_sclk_1_pins[] = { PIN_GPIOZ_11 };
+static const unsigned int spi_mosi_1_pins[] = { PIN_GPIOZ_12 };
+static const unsigned int spi_miso_1_pins[] = { PIN_GPIOZ_13 };
+static const unsigned int spi_ss2_1_pins[] = { PIN_GPIOZ_14 };
+
+static const unsigned int eth_tx_clk_50m_pins[] = { PIN_GPIOZ_4 };
+static const unsigned int eth_tx_en_pins[] = { PIN_GPIOZ_5 };
+static const unsigned int eth_txd1_pins[] = { PIN_GPIOZ_6 };
+static const unsigned int eth_txd0_pins[] = { PIN_GPIOZ_7 };
+static const unsigned int eth_rx_clk_in_pins[] = { PIN_GPIOZ_8 };
+static const unsigned int eth_rx_dv_pins[] = { PIN_GPIOZ_9 };
+static const unsigned int eth_rxd1_pins[] = { PIN_GPIOZ_10 };
+static const unsigned int eth_rxd0_pins[] = { PIN_GPIOZ_11 };
+static const unsigned int eth_mdio_pins[] = { PIN_GPIOZ_12 };
+static const unsigned int eth_mdc_pins[] = { PIN_GPIOZ_13 };
+
+static const unsigned int i2c_sda_a0_pins[] = { PIN_GPIOZ_0 };
+static const unsigned int i2c_sck_a0_pins[] = { PIN_GPIOZ_1 };
+
+static const unsigned int i2c_sda_b_pins[] = { PIN_GPIOZ_2 };
+static const unsigned int i2c_sck_b_pins[] = { PIN_GPIOZ_3 };
+
+static const unsigned int i2c_sda_c1_pins[] = { PIN_GPIOZ_4 };
+static const unsigned int i2c_sck_c1_pins[] = { PIN_GPIOZ_5 };
+
+static const unsigned int i2c_sda_a1_pins[] = { PIN_GPIOZ_0 };
+static const unsigned int i2c_sck_a1_pins[] = { PIN_GPIOZ_1 };
+
+static const unsigned int i2c_sda_a2_pins[] = { PIN_GPIOZ_0 };
+static const unsigned int i2c_sck_a2_pins[] = { PIN_GPIOZ_1 };
+
+/* bank BOOT */
+static const unsigned int sd_d0_c_pins[] = { PIN_BOOT_0 };
+static const unsigned int sd_d1_c_pins[] = { PIN_BOOT_1 };
+static const unsigned int sd_d2_c_pins[] = { PIN_BOOT_2 };
+static const unsigned int sd_d3_c_pins[] = { PIN_BOOT_3 };
+static const unsigned int sd_cmd_c_pins[] = { PIN_BOOT_16 };
+static const unsigned int sd_clk_c_pins[] = { PIN_BOOT_17 };
+
+static const unsigned int sdxc_d0_c_pins[] = { PIN_BOOT_0};
+static const unsigned int sdxc_d13_c_pins[] = { PIN_BOOT_1, PIN_BOOT_2,
+						PIN_BOOT_3 };
+static const unsigned int sdxc_d47_c_pins[] = { PIN_BOOT_4, PIN_BOOT_5,
+						PIN_BOOT_6, PIN_BOOT_7 };
+static const unsigned int sdxc_cmd_c_pins[] = { PIN_BOOT_16 };
+static const unsigned int sdxc_clk_c_pins[] = { PIN_BOOT_17 };
+
+static const unsigned int nand_io_pins[] = { PIN_BOOT_0, PIN_BOOT_1,
+					     PIN_BOOT_2, PIN_BOOT_3,
+					     PIN_BOOT_4, PIN_BOOT_5,
+					     PIN_BOOT_6, PIN_BOOT_7 };
+static const unsigned int nand_io_ce0_pins[] = { PIN_BOOT_8 };
+static const unsigned int nand_io_ce1_pins[] = { PIN_BOOT_9 };
+static const unsigned int nand_io_rb0_pins[] = { PIN_BOOT_10 };
+static const unsigned int nand_ale_pins[] = { PIN_BOOT_11 };
+static const unsigned int nand_cle_pins[] = { PIN_BOOT_12 };
+static const unsigned int nand_wen_clk_pins[] = { PIN_BOOT_13 };
+static const unsigned int nand_ren_clk_pins[] = { PIN_BOOT_14 };
+static const unsigned int nand_dqs_pins[] = { PIN_BOOT_15 };
+static const unsigned int nand_ce2_pins[] = { PIN_BOOT_16 };
+static const unsigned int nand_ce3_pins[] = { PIN_BOOT_17 };
+
+static const unsigned int nor_d_pins[] = { PIN_BOOT_11 };
+static const unsigned int nor_q_pins[] = { PIN_BOOT_12 };
+static const unsigned int nor_c_pins[] = { PIN_BOOT_13 };
+static const unsigned int nor_cs_pins[] = { PIN_BOOT_18 };
+
+/* bank CARD */
+static const unsigned int sd_d1_b_pins[] = { PIN_CARD_0 };
+static const unsigned int sd_d0_b_pins[] = { PIN_CARD_1 };
+static const unsigned int sd_clk_b_pins[] = { PIN_CARD_2 };
+static const unsigned int sd_cmd_b_pins[] = { PIN_CARD_3 };
+static const unsigned int sd_d3_b_pins[] = { PIN_CARD_4 };
+static const unsigned int sd_d2_b_pins[] = { PIN_CARD_5 };
+
+static const unsigned int sdxc_d13_b_pins[] = { PIN_CARD_0, PIN_CARD_4,
+						PIN_CARD_5 };
+static const unsigned int sdxc_d0_b_pins[] = { PIN_CARD_1 };
+static const unsigned int sdxc_clk_b_pins[] = { PIN_CARD_2 };
+static const unsigned int sdxc_cmd_b_pins[] = { PIN_CARD_3 };
+
+/* bank AO */
+static const unsigned int uart_tx_ao_a_pins[] = { PIN_GPIOAO_0 };
+static const unsigned int uart_rx_ao_a_pins[] = { PIN_GPIOAO_1 };
+static const unsigned int uart_cts_ao_a_pins[] = { PIN_GPIOAO_2 };
+static const unsigned int uart_rts_ao_a_pins[] = { PIN_GPIOAO_3 };
+
+static const unsigned int remote_input_pins[] = { PIN_GPIOAO_7 };
+
+static const unsigned int i2c_slave_sck_ao_pins[] = { PIN_GPIOAO_4 };
+static const unsigned int i2c_slave_sda_ao_pins[] = { PIN_GPIOAO_5 };
+
+static const unsigned int uart_tx_ao_b0_pins[] = { PIN_GPIOAO_0 };
+static const unsigned int uart_rx_ao_b0_pins[] = { PIN_GPIOAO_1 };
+
+static const unsigned int uart_tx_ao_b1_pins[] = { PIN_GPIOAO_4 };
+static const unsigned int uart_rx_ao_b1_pins[] = { PIN_GPIOAO_5 };
+
+static const unsigned int i2c_mst_sck_ao_pins[] = { PIN_GPIOAO_4 };
+static const unsigned int i2c_mst_sda_ao_pins[] = { PIN_GPIOAO_5 };
+
+static struct meson_pmx_group meson8_groups[] = {
+	GPIO_GROUP(GPIOX_0),
+	GPIO_GROUP(GPIOX_1),
+	GPIO_GROUP(GPIOX_2),
+	GPIO_GROUP(GPIOX_3),
+	GPIO_GROUP(GPIOX_4),
+	GPIO_GROUP(GPIOX_5),
+	GPIO_GROUP(GPIOX_6),
+	GPIO_GROUP(GPIOX_7),
+	GPIO_GROUP(GPIOX_8),
+	GPIO_GROUP(GPIOX_9),
+	GPIO_GROUP(GPIOX_10),
+	GPIO_GROUP(GPIOX_11),
+	GPIO_GROUP(GPIOX_12),
+	GPIO_GROUP(GPIOX_13),
+	GPIO_GROUP(GPIOX_14),
+	GPIO_GROUP(GPIOX_15),
+	GPIO_GROUP(GPIOX_16),
+	GPIO_GROUP(GPIOX_17),
+	GPIO_GROUP(GPIOX_18),
+	GPIO_GROUP(GPIOX_19),
+	GPIO_GROUP(GPIOX_20),
+	GPIO_GROUP(GPIOX_21),
+	GPIO_GROUP(GPIOY_0),
+	GPIO_GROUP(GPIOY_1),
+	GPIO_GROUP(GPIOY_2),
+	GPIO_GROUP(GPIOY_3),
+	GPIO_GROUP(GPIOY_4),
+	GPIO_GROUP(GPIOY_5),
+	GPIO_GROUP(GPIOY_6),
+	GPIO_GROUP(GPIOY_7),
+	GPIO_GROUP(GPIOY_8),
+	GPIO_GROUP(GPIOY_9),
+	GPIO_GROUP(GPIOY_10),
+	GPIO_GROUP(GPIOY_11),
+	GPIO_GROUP(GPIOY_12),
+	GPIO_GROUP(GPIOY_13),
+	GPIO_GROUP(GPIOY_14),
+	GPIO_GROUP(GPIOY_15),
+	GPIO_GROUP(GPIOY_16),
+	GPIO_GROUP(GPIODV_0),
+	GPIO_GROUP(GPIODV_1),
+	GPIO_GROUP(GPIODV_2),
+	GPIO_GROUP(GPIODV_3),
+	GPIO_GROUP(GPIODV_4),
+	GPIO_GROUP(GPIODV_5),
+	GPIO_GROUP(GPIODV_6),
+	GPIO_GROUP(GPIODV_7),
+	GPIO_GROUP(GPIODV_8),
+	GPIO_GROUP(GPIODV_9),
+	GPIO_GROUP(GPIODV_10),
+	GPIO_GROUP(GPIODV_11),
+	GPIO_GROUP(GPIODV_12),
+	GPIO_GROUP(GPIODV_13),
+	GPIO_GROUP(GPIODV_14),
+	GPIO_GROUP(GPIODV_15),
+	GPIO_GROUP(GPIODV_16),
+	GPIO_GROUP(GPIODV_17),
+	GPIO_GROUP(GPIODV_18),
+	GPIO_GROUP(GPIODV_19),
+	GPIO_GROUP(GPIODV_20),
+	GPIO_GROUP(GPIODV_21),
+	GPIO_GROUP(GPIODV_22),
+	GPIO_GROUP(GPIODV_23),
+	GPIO_GROUP(GPIODV_24),
+	GPIO_GROUP(GPIODV_25),
+	GPIO_GROUP(GPIODV_26),
+	GPIO_GROUP(GPIODV_27),
+	GPIO_GROUP(GPIODV_28),
+	GPIO_GROUP(GPIODV_29),
+	GPIO_GROUP(GPIOH_0),
+	GPIO_GROUP(GPIOH_1),
+	GPIO_GROUP(GPIOH_2),
+	GPIO_GROUP(GPIOH_3),
+	GPIO_GROUP(GPIOH_4),
+	GPIO_GROUP(GPIOH_5),
+	GPIO_GROUP(GPIOH_6),
+	GPIO_GROUP(GPIOH_7),
+	GPIO_GROUP(GPIOH_8),
+	GPIO_GROUP(GPIOH_9),
+	GPIO_GROUP(GPIOZ_0),
+	GPIO_GROUP(GPIOZ_1),
+	GPIO_GROUP(GPIOZ_2),
+	GPIO_GROUP(GPIOZ_3),
+	GPIO_GROUP(GPIOZ_4),
+	GPIO_GROUP(GPIOZ_5),
+	GPIO_GROUP(GPIOZ_6),
+	GPIO_GROUP(GPIOZ_7),
+	GPIO_GROUP(GPIOZ_8),
+	GPIO_GROUP(GPIOZ_9),
+	GPIO_GROUP(GPIOZ_10),
+	GPIO_GROUP(GPIOZ_11),
+	GPIO_GROUP(GPIOZ_12),
+	GPIO_GROUP(GPIOZ_13),
+	GPIO_GROUP(GPIOZ_14),
+	GPIO_GROUP(GPIOAO_0),
+	GPIO_GROUP(GPIOAO_1),
+	GPIO_GROUP(GPIOAO_2),
+	GPIO_GROUP(GPIOAO_3),
+	GPIO_GROUP(GPIOAO_4),
+	GPIO_GROUP(GPIOAO_5),
+	GPIO_GROUP(GPIOAO_6),
+	GPIO_GROUP(GPIOAO_7),
+	GPIO_GROUP(GPIOAO_8),
+	GPIO_GROUP(GPIOAO_9),
+	GPIO_GROUP(GPIOAO_10),
+	GPIO_GROUP(GPIOAO_11),
+	GPIO_GROUP(GPIOAO_12),
+	GPIO_GROUP(GPIOAO_13),
+	GPIO_GROUP(GPIO_BSD_EN),
+	GPIO_GROUP(GPIO_TEST_N),
+
+	/* bank X */
+	GROUP(sd_d0_a,		8,	5),
+	GROUP(sd_d1_a,		8,	4),
+	GROUP(sd_d2_a,		8,	3),
+	GROUP(sd_d3_a,		8,	2),
+	GROUP(sd_clk_a,		8,	1),
+	GROUP(sd_cmd_a,		8,	0),
+
+	GROUP(sdxc_d0_a,	5,	14),
+	GROUP(sdxc_d13_a,	5,	13),
+	GROUP(sdxc_d47_a,	5,	12),
+	GROUP(sdxc_clk_a,	5,	11),
+	GROUP(sdxc_cmd_a,	5,	10),
+
+	GROUP(pcm_out_a,	3,	30),
+	GROUP(pcm_in_a,		3,	29),
+	GROUP(pcm_fs_a,		3,	28),
+	GROUP(pcm_clk_a,	3,	27),
+
+	GROUP(uart_tx_a0,	4,	17),
+	GROUP(uart_rx_a0,	4,	16),
+	GROUP(uart_cts_a0,	4,	15),
+	GROUP(uart_rts_a0,	4,	14),
+
+	GROUP(uart_tx_a1,	4,	13),
+	GROUP(uart_rx_a1,	4,	12),
+	GROUP(uart_cts_a1,	4,	11),
+	GROUP(uart_rts_a1,	4,	10),
+
+	GROUP(uart_tx_b0,	4,	9),
+	GROUP(uart_rx_b0,	4,	8),
+	GROUP(uart_cts_b0,	4,	7),
+	GROUP(uart_rts_b0,	4,	6),
+
+	GROUP(iso7816_det,	4,	21),
+	GROUP(iso7816_reset,	4,	20),
+	GROUP(iso7816_clk,	4,	19),
+	GROUP(iso7816_data,	4,	18),
+
+	GROUP(i2c_sda_d0,	4,	5),
+	GROUP(i2c_sck_d0,	4,	4),
+
+	GROUP(xtal_32k_out,	3,	22),
+	GROUP(xtal_24m_out,	3,	23),
+
+	/* bank Y */
+	GROUP(uart_tx_c,	1,	19),
+	GROUP(uart_rx_c,	1,	18),
+	GROUP(uart_cts_c,	1,	17),
+	GROUP(uart_rts_c,	1,	16),
+
+	GROUP(pcm_out_b,	4,	25),
+	GROUP(pcm_in_b,		4,	24),
+	GROUP(pcm_fs_b,		4,	23),
+	GROUP(pcm_clk_b,	4,	22),
+
+	GROUP(i2c_sda_c0,	1,	15),
+	GROUP(i2c_sck_c0,	1,	14),
+
+	/* bank DV */
+	GROUP(dvin_rgb,		0,	6),
+	GROUP(dvin_vs,		0,	9),
+	GROUP(dvin_hs,		0,	8),
+	GROUP(dvin_clk,		0,	7),
+	GROUP(dvin_de,		0,	10),
+
+	GROUP(enc_0,		7,	0),
+	GROUP(enc_1,		7,	1),
+	GROUP(enc_2,		7,	2),
+	GROUP(enc_3,		7,	3),
+	GROUP(enc_4,		7,	4),
+	GROUP(enc_5,		7,	5),
+	GROUP(enc_6,		7,	6),
+	GROUP(enc_7,		7,	7),
+	GROUP(enc_8,		7,	8),
+	GROUP(enc_9,		7,	9),
+	GROUP(enc_10,		7,	10),
+	GROUP(enc_11,		7,	11),
+	GROUP(enc_12,		7,	12),
+	GROUP(enc_13,		7,	13),
+	GROUP(enc_14,		7,	14),
+	GROUP(enc_15,		7,	15),
+	GROUP(enc_16,		7,	16),
+	GROUP(enc_17,		7,	17),
+
+	GROUP(uart_tx_b1,	6,	23),
+	GROUP(uart_rx_b1,	6,	22),
+	GROUP(uart_cts_b1,	6,	21),
+	GROUP(uart_rts_b1,	6,	20),
+
+	GROUP(vga_vs,		0,	21),
+	GROUP(vga_hs,		0,	20),
+
+	/* bank H */
+	GROUP(hdmi_hpd,		1,	26),
+	GROUP(hdmi_sda,		1,	25),
+	GROUP(hdmi_scl,		1,	24),
+	GROUP(hdmi_cec,		1,	23),
+
+	GROUP(spi_ss0_0,	9,	13),
+	GROUP(spi_miso_0,	9,	12),
+	GROUP(spi_mosi_0,	9,	11),
+	GROUP(spi_sclk_0,	9,	10),
+
+	GROUP(i2c_sda_d1,	4,	3),
+	GROUP(i2c_sck_d1,	4,	2),
+
+	/* bank Z */
+	GROUP(spi_ss0_1,	8,	16),
+	GROUP(spi_ss1_1,	8,	12),
+	GROUP(spi_sclk_1,	8,	15),
+	GROUP(spi_mosi_1,	8,	14),
+	GROUP(spi_miso_1,	8,	13),
+	GROUP(spi_ss2_1,	8,	17),
+
+	GROUP(eth_tx_clk_50m,	6,	15),
+	GROUP(eth_tx_en,	6,	14),
+	GROUP(eth_txd1,		6,	13),
+	GROUP(eth_txd0,		6,	12),
+	GROUP(eth_rx_clk_in,	6,	10),
+	GROUP(eth_rx_dv,	6,	11),
+	GROUP(eth_rxd1,		6,	8),
+	GROUP(eth_rxd0,		6,	7),
+	GROUP(eth_mdio,		6,	6),
+	GROUP(eth_mdc,		6,	5),
+
+	GROUP(i2c_sda_a0,	5,	31),
+	GROUP(i2c_sck_a0,	5,	30),
+
+	GROUP(i2c_sda_b,	5,	27),
+	GROUP(i2c_sck_b,	5,	26),
+
+	GROUP(i2c_sda_c1,	5,	25),
+	GROUP(i2c_sck_c1,	5,	24),
+
+	GROUP(i2c_sda_a1,	5,	9),
+	GROUP(i2c_sck_a1,	5,	8),
+
+	GROUP(i2c_sda_a2,	5,	7),
+	GROUP(i2c_sck_a2,	5,	6),
+
+	/* bank BOOT */
+	GROUP(sd_d0_c,		6,	29),
+	GROUP(sd_d1_c,		6,	28),
+	GROUP(sd_d2_c,		6,	27),
+	GROUP(sd_d3_c,		6,	26),
+	GROUP(sd_cmd_c,		6,	25),
+	GROUP(sd_clk_c,		6,	24),
+
+	GROUP(sdxc_d0_c,	4,	30),
+	GROUP(sdxc_d13_c,	4,	29),
+	GROUP(sdxc_d47_c,	4,	28),
+	GROUP(sdxc_cmd_c,	4,	27),
+	GROUP(sdxc_clk_c,	4,	26),
+
+	GROUP(nand_io,		2,	26),
+	GROUP(nand_io_ce0,	2,	25),
+	GROUP(nand_io_ce1,	2,	24),
+	GROUP(nand_io_rb0,	2,	17),
+	GROUP(nand_ale,		2,	21),
+	GROUP(nand_cle,		2,	20),
+	GROUP(nand_wen_clk,	2,	19),
+	GROUP(nand_ren_clk,	2,	18),
+	GROUP(nand_dqs,		2,	27),
+	GROUP(nand_ce2,		2,	23),
+	GROUP(nand_ce3,		2,	22),
+
+	GROUP(nor_d,		5,	1),
+	GROUP(nor_q,		5,	3),
+	GROUP(nor_c,		5,	2),
+	GROUP(nor_cs,		5,	0),
+
+	/* bank CARD */
+	GROUP(sd_d1_b,		2,	14),
+	GROUP(sd_d0_b,		2,	15),
+	GROUP(sd_clk_b,		2,	11),
+	GROUP(sd_cmd_b,		2,	10),
+	GROUP(sd_d3_b,		2,	12),
+	GROUP(sd_d2_b,		2,	13),
+
+	GROUP(sdxc_d13_b,	2,	6),
+	GROUP(sdxc_d0_b,	2,	7),
+	GROUP(sdxc_clk_b,	2,	5),
+	GROUP(sdxc_cmd_b,	2,	4),
+
+	/* bank AO */
+	GROUP_AO(uart_tx_ao_a,		0,	12),
+	GROUP_AO(uart_rx_ao_a,		0,	11),
+	GROUP_AO(uart_cts_ao_a,		0,	10),
+	GROUP_AO(uart_rts_ao_a,		0,	9),
+
+	GROUP_AO(remote_input,		0,	0),
+
+	GROUP_AO(i2c_slave_sck_ao,	0,	2),
+	GROUP_AO(i2c_slave_sda_ao,	0,	1),
+
+	GROUP_AO(uart_tx_ao_b0,		0,	26),
+	GROUP_AO(uart_rx_ao_b0,		0,	25),
+
+	GROUP_AO(uart_tx_ao_b1,		0,	24),
+	GROUP_AO(uart_rx_ao_b1,		0,	23),
+
+	GROUP_AO(i2c_mst_sck_ao,	0,	6),
+	GROUP_AO(i2c_mst_sda_ao,	0,	5),
+};
+
+static const char * const gpio_groups[] = {
+	"GPIOX_0", "GPIOX_1", "GPIOX_2", "GPIOX_3", "GPIOX_4",
+	"GPIOX_5", "GPIOX_6", "GPIOX_7", "GPIOX_8", "GPIOX_9",
+	"GPIOX_10", "GPIOX_11", "GPIOX_12", "GPIOX_13", "GPIOX_14",
+	"GPIOX_15", "GPIOX_16", "GPIOX_17", "GPIOX_18", "GPIOX_19",
+	"GPIOX_20", "GPIOX_21",
+
+	"GPIOY_0", "GPIOY_1", "GPIOY_2", "GPIOY_3", "GPIOY_4",
+	"GPIOY_5", "GPIOY_6", "GPIOY_7", "GPIOY_8", "GPIOY_9",
+	"GPIOY_10", "GPIOY_11", "GPIOY_12", "GPIOY_13", "GPIOY_14",
+	"GPIOY_15", "GPIOY_16",
+
+	"GPIODV_0", "GPIODV_1", "GPIODV_2", "GPIODV_3", "GPIODV_4",
+	"GPIODV_5", "GPIODV_6", "GPIODV_7", "GPIODV_8", "GPIODV_9",
+	"GPIODV_10", "GPIODV_11", "GPIODV_12", "GPIODV_13", "GPIODV_14",
+	"GPIODV_15", "GPIODV_16", "GPIODV_17", "GPIODV_18", "GPIODV_19",
+	"GPIODV_20", "GPIODV_21", "GPIODV_22", "GPIODV_23", "GPIODV_24",
+	"GPIODV_25", "GPIODV_26", "GPIODV_27", "GPIODV_28", "GPIODV_29",
+
+	"GPIOH_0", "GPIOH_1", "GPIOH_2", "GPIOH_3", "GPIOH_4",
+	"GPIOH_5", "GPIOH_6", "GPIOH_7", "GPIOH_8", "GPIOH_9",
+
+	"GPIOZ_0", "GPIOZ_1", "GPIOZ_2", "GPIOZ_3", "GPIOZ_4",
+	"GPIOZ_5", "GPIOZ_6", "GPIOZ_7", "GPIOZ_8", "GPIOZ_9",
+	"GPIOZ_10", "GPIOZ_11", "GPIOZ_12", "GPIOZ_13", "GPIOZ_14",
+
+	"CARD_0", "CARD_1", "CARD_2", "CARD_3", "CARD_4",
+	"CARD_5", "CARD_6",
+
+	"BOOT_0", "BOOT_1", "BOOT_2", "BOOT_3", "BOOT_4",
+	"BOOT_5", "BOOT_6", "BOOT_7", "BOOT_8", "BOOT_9",
+	"BOOT_10", "BOOT_11", "BOOT_12", "BOOT_13", "BOOT_14",
+	"BOOT_15", "BOOT_16", "BOOT_17", "BOOT_18",
+
+	"GPIOAO_0", "GPIOAO_1", "GPIOAO_2", "GPIOAO_3",
+	"GPIOAO_4", "GPIOAO_5", "GPIOAO_6", "GPIOAO_7",
+	"GPIOAO_8", "GPIOAO_9", "GPIOAO_10", "GPIOAO_11",
+	"GPIOAO_12", "GPIOAO_13", "GPIO_BSD_EN", "GPIO_TEST_N"
+};
+
+static const char * const sd_a_groups[] = {
+	"sd_d0_a", "sd_d1_a", "sd_d2_a", "sd_d3_a", "sd_clk_a", "sd_cmd_a"
+};
+
+static const char * const sdxc_a_groups[] = {
+	"sdxc_d0_a", "sdxc_d13_a", "sdxc_d47_a", "sdxc_clk_a", "sdxc_cmd_a"
+};
+
+static const char * const pcm_a_groups[] = {
+	"pcm_out_a", "pcm_in_a", "pcm_fs_a", "pcm_clk_a"
+};
+
+static const char * const uart_a_groups[] = {
+	"uart_tx_a0", "uart_rx_a0", "uart_cts_a0", "uart_rts_a0",
+	"uart_tx_a1", "uart_rx_a1", "uart_cts_a1", "uart_rts_a1"
+};
+
+static const char * const uart_b_groups[] = {
+	"uart_tx_b0", "uart_rx_b0", "uart_cts_b0", "uart_rts_b0",
+	"uart_tx_b1", "uart_rx_b1", "uart_cts_b1", "uart_rts_b1"
+};
+
+static const char * const iso7816_groups[] = {
+	"iso7816_det", "iso7816_reset", "iso7816_clk", "iso7816_data"
+};
+
+static const char * const i2c_d_groups[] = {
+	"i2c_sda_d0", "i2c_sck_d0", "i2c_sda_d1", "i2c_sck_d1"
+};
+
+static const char * const xtal_groups[] = {
+	"xtal_32k_out", "xtal_24m_out"
+};
+
+static const char * const uart_c_groups[] = {
+	"uart_tx_c", "uart_rx_c", "uart_cts_c", "uart_rts_c"
+};
+
+static const char * const pcm_b_groups[] = {
+	"pcm_out_b", "pcm_in_b", "pcm_fs_b", "pcm_clk_b"
+};
+
+static const char * const i2c_c_groups[] = {
+	"i2c_sda_c0", "i2c_sck_c0", "i2c_sda_c1", "i2c_sck_c1"
+};
+
+static const char * const dvin_groups[] = {
+	"dvin_rgb", "dvin_vs", "dvin_hs", "dvin_clk", "dvin_de"
+};
+
+static const char * const enc_groups[] = {
+	"enc_0", "enc_1", "enc_2", "enc_3", "enc_4", "enc_5",
+	"enc_6", "enc_7", "enc_8", "enc_9", "enc_10", "enc_11",
+	"enc_12", "enc_13", "enc_14", "enc_15", "enc_16", "enc_17"
+};
+
+static const char * const vga_groups[] = {
+	"vga_vs", "vga_hs"
+};
+
+static const char * const hdmi_groups[] = {
+	"hdmi_hpd", "hdmi_sda", "hdmi_scl", "hdmi_cec"
+};
+
+static const char * const spi_groups[] = {
+	"spi_ss0_0", "spi_miso_0", "spi_mosi_0", "spi_sclk_0",
+	"spi_ss0_1", "spi_ss1_1", "spi_sclk_1", "spi_mosi_1",
+	"spi_miso_1", "spi_ss2_1"
+};
+
+static const char * const ethernet_groups[] = {
+	"eth_tx_clk_50m", "eth_tx_en", "eth_txd1",
+	"eth_txd0", "eth_rx_clk_in", "eth_rx_dv",
+	"eth_rxd1", "eth_rxd0", "eth_mdio", "eth_mdc"
+};
+
+static const char * const i2c_a_groups[] = {
+	"i2c_sda_a0", "i2c_sck_a0", "i2c_sda_a1", "i2c_sck_a1",
+	"i2c_sda_a2", "i2c_sck_a2"
+};
+
+static const char * const i2c_b_groups[] = {
+	"i2c_sda_b", "i2c_sck_b"
+};
+
+static const char * const sd_c_groups[] = {
+	"sd_d0_c", "sd_d1_c", "sd_d2_c", "sd_d3_c",
+	"sd_cmd_c", "sd_clk_c"
+};
+
+static const char * const sdxc_c_groups[] = {
+	"sdxc_d0_c", "sdxc_d13_c", "sdxc_d47_c", "sdxc_cmd_c",
+	"sdxc_clk_c"
+};
+
+static const char * const nand_groups[] = {
+	"nand_io", "nand_io_ce0", "nand_io_ce1",
+	"nand_io_rb0", "nand_ale", "nand_cle",
+	"nand_wen_clk", "nand_ren_clk", "nand_dqs",
+	"nand_ce2", "nand_ce3"
+};
+
+static const char * const nor_groups[] = {
+	"nor_d", "nor_q", "nor_c", "nor_cs"
+};
+
+static const char * const sd_b_groups[] = {
+	"sd_d1_b", "sd_d0_b", "sd_clk_b", "sd_cmd_b",
+	"sd_d3_b", "sd_d2_b"
+};
+
+static const char * const sdxc_b_groups[] = {
+	"sdxc_d13_b", "sdxc_d0_b", "sdxc_clk_b", "sdxc_cmd_b"
+};
+
+static const char * const uart_ao_groups[] = {
+	"uart_tx_ao_a", "uart_rx_ao_a", "uart_cts_ao_a", "uart_rts_ao_a"
+};
+
+static const char * const remote_groups[] = {
+	"remote_input"
+};
+
+static const char * const i2c_slave_ao_groups[] = {
+	"i2c_slave_sck_ao", "i2c_slave_sda_ao"
+};
+
+static const char * const uart_ao_b_groups[] = {
+	"uart_tx_ao_b0", "uart_rx_ao_b0", "uart_tx_ao_b1", "uart_rx_ao_b1"
+};
+
+static const char * const i2c_mst_ao_groups[] = {
+	"i2c_mst_sck_ao", "i2c_mst_sda_ao"
+};
+
+static struct meson_pmx_func meson8_functions[] = {
+	FUNCTION(gpio),
+	FUNCTION(sd_a),
+	FUNCTION(sdxc_a),
+	FUNCTION(pcm_a),
+	FUNCTION(uart_a),
+	FUNCTION(uart_b),
+	FUNCTION(iso7816),
+	FUNCTION(i2c_d),
+	FUNCTION(xtal),
+	FUNCTION(uart_c),
+	FUNCTION(pcm_b),
+	FUNCTION(i2c_c),
+	FUNCTION(dvin),
+	FUNCTION(enc),
+	FUNCTION(vga),
+	FUNCTION(hdmi),
+	FUNCTION(spi),
+	FUNCTION(ethernet),
+	FUNCTION(i2c_a),
+	FUNCTION(i2c_b),
+	FUNCTION(sd_c),
+	FUNCTION(sdxc_c),
+	FUNCTION(nand),
+	FUNCTION(nor),
+	FUNCTION(sd_b),
+	FUNCTION(sdxc_b),
+	FUNCTION(uart_ao),
+	FUNCTION(remote),
+	FUNCTION(i2c_slave_ao),
+	FUNCTION(uart_ao_b),
+	FUNCTION(i2c_mst_ao),
+};
+
+static struct meson_bank meson8_banks[] = {
+	/*   name    first         last             pullen  pull     dir     out     in  */
+	BANK("X",    PIN_GPIOX_0,  PIN_GPIOX_21,    4,  0,  4,  0,  0,  0,  1,  0,  2,  0),
+	BANK("Y",    PIN_GPIOY_0,  PIN_GPIOY_16,    3,  0,  3,  0,  3,  0,  4,  0,  5,  0),
+	BANK("DV",   PIN_GPIODV_0, PIN_GPIODV_29,   0,  0,  0,  0,  7,  0,  8,  0,  9,  0),
+	BANK("H",    PIN_GPIOH_0,  PIN_GPIOH_9,     1, 16,  1, 16,  9, 19, 10, 19, 11, 19),
+	BANK("Z",    PIN_GPIOZ_0,  PIN_GPIOZ_14,    1,  0,  1,  0,  3, 17,  4, 17,  5, 17),
+	BANK("CARD", PIN_CARD_0,   PIN_CARD_6,      2, 20,  2, 20,  0, 22,  1, 22,  2, 22),
+	BANK("BOOT", PIN_BOOT_0,   PIN_BOOT_18,     2,  0,  2,  0,  9,  0, 10,  0, 11,  0),
+};
+
+static struct meson_bank meson8_ao_banks[] = {
+	/*   name    first         last             pullen  pull     dir     out     in  */
+	BANK("AO",   PIN_GPIOAO_0, PIN_GPIO_TEST_N, 0,  0,  0, 16,  0,  0,  0, 16,  1,  0),
+};
+
+static struct meson_domain_data meson8_domain_data[] = {
+	{
+		.name		= "banks",
+		.banks		= meson8_banks,
+		.num_banks	= ARRAY_SIZE(meson8_banks),
+		.pin_base	= 0,
+		.num_pins	= 120,
+	},
+	{
+		.name		= "ao-bank",
+		.banks		= meson8_ao_banks,
+		.num_banks	= ARRAY_SIZE(meson8_ao_banks),
+		.pin_base	= 120,
+		.num_pins	= 16,
+	},
+};
+
+struct meson_pinctrl_data meson8_pinctrl_data = {
+	.pins		= meson8_pins,
+	.groups		= meson8_groups,
+	.funcs		= meson8_functions,
+	.domain_data	= meson8_domain_data,
+	.num_pins	= ARRAY_SIZE(meson8_pins),
+	.num_groups	= ARRAY_SIZE(meson8_groups),
+	.num_funcs	= ARRAY_SIZE(meson8_functions),
+	.num_domains	= ARRAY_SIZE(meson8_domain_data),
+};
diff --git a/include/dt-bindings/gpio/meson8-gpio.h b/include/dt-bindings/gpio/meson8-gpio.h
new file mode 100644
index 0000000..fdaeb5c
--- /dev/null
+++ b/include/dt-bindings/gpio/meson8-gpio.h
@@ -0,0 +1,157 @@
+/*
+ * GPIO definitions for Amlogic Meson8 SoCs
+ *
+ * Copyright (C) 2014 Beniamino Galvani <b.galvani@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _DT_BINDINGS_MESON8_GPIO_H
+#define _DT_BINDINGS_MESON8_GPIO_H
+
+/* First GPIO chip */
+#define GPIOX_0		0
+#define GPIOX_1		1
+#define GPIOX_2		2
+#define GPIOX_3		3
+#define GPIOX_4		4
+#define GPIOX_5		5
+#define GPIOX_6		6
+#define GPIOX_7		7
+#define GPIOX_8		8
+#define GPIOX_9		9
+#define GPIOX_10	10
+#define GPIOX_11	11
+#define GPIOX_12	12
+#define GPIOX_13	13
+#define GPIOX_14	14
+#define GPIOX_15	15
+#define GPIOX_16	16
+#define GPIOX_17	17
+#define GPIOX_18	18
+#define GPIOX_19	19
+#define GPIOX_20	20
+#define GPIOX_21	21
+#define GPIOY_0		22
+#define GPIOY_1		23
+#define GPIOY_2		24
+#define GPIOY_3		25
+#define GPIOY_4		26
+#define GPIOY_5		27
+#define GPIOY_6		28
+#define GPIOY_7		29
+#define GPIOY_8		30
+#define GPIOY_9		31
+#define GPIOY_10	32
+#define GPIOY_11	33
+#define GPIOY_12	34
+#define GPIOY_13	35
+#define GPIOY_14	36
+#define GPIOY_15	37
+#define GPIOY_16	38
+#define GPIODV_0	39
+#define GPIODV_1	40
+#define GPIODV_2	41
+#define GPIODV_3	42
+#define GPIODV_4	43
+#define GPIODV_5	44
+#define GPIODV_6	45
+#define GPIODV_7	46
+#define GPIODV_8	47
+#define GPIODV_9	48
+#define GPIODV_10	49
+#define GPIODV_11	50
+#define GPIODV_12	51
+#define GPIODV_13	52
+#define GPIODV_14	53
+#define GPIODV_15	54
+#define GPIODV_16	55
+#define GPIODV_17	56
+#define GPIODV_18	57
+#define GPIODV_19	58
+#define GPIODV_20	59
+#define GPIODV_21	60
+#define GPIODV_22	61
+#define GPIODV_23	62
+#define GPIODV_24	63
+#define GPIODV_25	64
+#define GPIODV_26	65
+#define GPIODV_27	66
+#define GPIODV_28	67
+#define GPIODV_29	68
+#define GPIOH_0		69
+#define GPIOH_1		70
+#define GPIOH_2		71
+#define GPIOH_3		72
+#define GPIOH_4		73
+#define GPIOH_5		74
+#define GPIOH_6		75
+#define GPIOH_7		76
+#define GPIOH_8		77
+#define GPIOH_9		78
+#define GPIOZ_0		79
+#define GPIOZ_1		80
+#define GPIOZ_2		81
+#define GPIOZ_3		82
+#define GPIOZ_4		83
+#define GPIOZ_5		84
+#define GPIOZ_6		85
+#define GPIOZ_7		86
+#define GPIOZ_8		87
+#define GPIOZ_9		88
+#define GPIOZ_10	89
+#define GPIOZ_11	90
+#define GPIOZ_12	91
+#define GPIOZ_13	92
+#define GPIOZ_14	93
+#define CARD_0		94
+#define CARD_1		95
+#define CARD_2		96
+#define CARD_3		97
+#define CARD_4		98
+#define CARD_5		99
+#define CARD_6		100
+#define BOOT_0		101
+#define BOOT_1		102
+#define BOOT_2		103
+#define BOOT_3		104
+#define BOOT_4		105
+#define BOOT_5		106
+#define BOOT_6		107
+#define BOOT_7		108
+#define BOOT_8		109
+#define BOOT_9		110
+#define BOOT_10		111
+#define BOOT_11		112
+#define BOOT_12		113
+#define BOOT_13		114
+#define BOOT_14		115
+#define BOOT_15		116
+#define BOOT_16		117
+#define BOOT_17		118
+#define BOOT_18		119
+
+/* Second GPIO chip */
+#define GPIOAO_0	0
+#define GPIOAO_1	1
+#define GPIOAO_2	2
+#define GPIOAO_3	3
+#define GPIOAO_4	4
+#define GPIOAO_5	5
+#define GPIOAO_6	6
+#define GPIOAO_7	7
+#define GPIOAO_8	8
+#define GPIOAO_9	9
+#define GPIOAO_10	10
+#define GPIOAO_11	11
+#define GPIOAO_12	12
+#define GPIOAO_13	13
+#define GPIO_BSD_EN	14
+#define GPIO_TEST_N	15
+
+#endif /* _DT_BINDINGS_MESON8_GPIO_H */
-- 
2.1.4

