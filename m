Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaJGVey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:34:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53624 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbaJGVet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:34:49 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Carlo Caione <carlo@caione.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 1/3] pinctrl: add driver for Amlogic Meson SoCs
Date: Tue,  7 Oct 2014 23:32:54 +0200
Message-Id: <1412717576-19737-2-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
References: <1412717576-19737-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver for the pinmux and GPIO controller available in
Amlogic Meson SoCs. At the moment it only supports Meson8 devices,
however other SoC families like Meson6 and Meson8b (the Cortex-A5
variant) appears to be similar, with just different sets of banks and
registers.

GPIO interrupts are not supported at the moment due to lack of
documentation.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 arch/arm/mach-meson/Kconfig            |   3 +
 drivers/pinctrl/Kconfig                |   8 +
 drivers/pinctrl/Makefile               |   1 +
 drivers/pinctrl/meson/Makefile         |   2 +
 drivers/pinctrl/meson/pinctrl-meson.c  | 823 +++++++++++++++++++++++++++++++++
 drivers/pinctrl/meson/pinctrl-meson.h  | 217 +++++++++
 drivers/pinctrl/meson/pinctrl-meson8.c | 374 +++++++++++++++
 include/dt-bindings/gpio/meson8-gpio.h | 155 +++++++
 8 files changed, 1583 insertions(+)
 create mode 100644 drivers/pinctrl/meson/Makefile
 create mode 100644 drivers/pinctrl/meson/pinctrl-meson.c
 create mode 100644 drivers/pinctrl/meson/pinctrl-meson.h
 create mode 100644 drivers/pinctrl/meson/pinctrl-meson8.c
 create mode 100644 include/dt-bindings/gpio/meson8-gpio.h

diff --git a/arch/arm/mach-meson/Kconfig b/arch/arm/mach-meson/Kconfig
index 18301dc..a09d3f6 100644
--- a/arch/arm/mach-meson/Kconfig
+++ b/arch/arm/mach-meson/Kconfig
@@ -3,6 +3,9 @@ menuconfig ARCH_MESON
 	select GENERIC_IRQ_CHIP
 	select ARM_GIC
 	select CACHE_L2X0
+	select PINCTRL
+	select PINCTRL_MESON
+	select ARCH_REQUIRE_GPIOLIB
 
 if ARCH_MESON
 
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index c6a66de..22b05e1 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -108,6 +108,14 @@ config PINCTRL_FALCON
 	depends on SOC_FALCON
 	depends on PINCTRL_LANTIQ
 
+config PINCTRL_MESON
+	bool "Amlogic Meson pin controller driver"
+	depends on ARCH_MESON
+	select PINMUX
+	select PINCONF
+	select GENERIC_PINCONF
+	select OF_GPIO
+
 config PINCTRL_ROCKCHIP
 	bool
 	select PINMUX
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 51f52d3..7b22f89 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_PINCTRL_BCM2835)	+= pinctrl-bcm2835.o
 obj-$(CONFIG_PINCTRL_BAYTRAIL)	+= pinctrl-baytrail.o
 obj-$(CONFIG_PINCTRL_BCM281XX)	+= pinctrl-bcm281xx.o
 obj-$(CONFIG_PINCTRL_FALCON)	+= pinctrl-falcon.o
+obj-$(CONFIG_PINCTRL_MESON)	+= meson/
 obj-$(CONFIG_PINCTRL_PALMAS)	+= pinctrl-palmas.o
 obj-$(CONFIG_PINCTRL_ROCKCHIP)	+= pinctrl-rockchip.o
 obj-$(CONFIG_PINCTRL_SINGLE)	+= pinctrl-single.o
diff --git a/drivers/pinctrl/meson/Makefile b/drivers/pinctrl/meson/Makefile
new file mode 100644
index 0000000..03a90b4
--- /dev/null
+++ b/drivers/pinctrl/meson/Makefile
@@ -0,0 +1,2 @@
+obj-y	+= pinctrl-meson.o
+obj-y	+= pinctrl-meson8.o
diff --git a/drivers/pinctrl/meson/pinctrl-meson.c b/drivers/pinctrl/meson/pinctrl-meson.c
new file mode 100644
index 0000000..876102d
--- /dev/null
+++ b/drivers/pinctrl/meson/pinctrl-meson.c
@@ -0,0 +1,823 @@
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
+#include <linux/seq_file.h>
+#include <linux/spinlock.h>
+
+#include "../core.h"
+#include "../pinctrl-utils.h"
+#include "pinctrl-meson.h"
+
+static void meson_domain_set_bit(struct meson_domain *domain,
+				 void __iomem *addr, unsigned int bit,
+				 unsigned int value)
+{
+	unsigned long flags;
+	unsigned int data;
+
+	spin_lock_irqsave(&domain->lock, flags);
+	data = readl(addr);
+
+	if (value)
+		data |= BIT(bit);
+	else
+		data &= ~BIT(bit);
+
+	writel(data, addr);
+	spin_unlock_irqrestore(&domain->lock, flags);
+}
+
+static struct meson_domain *meson_pinctrl_get_domain(struct meson_pinctrl *pc,
+						   int pin)
+{
+	struct meson_domain *domain;
+	int i, j;
+
+	for (i = 0; i < pc->num_domains; i++) {
+		domain = &pc->domains[i];
+		for (j = 0; j < domain->data->num_banks; j++) {
+			if (pin >= domain->data->banks[j].first &&
+			    pin < domain->data->banks[j].last)
+				return domain;
+		}
+	}
+
+	return NULL;
+}
+
+static int meson_get_pin_reg_and_bit(struct meson_domain *domain,
+				     unsigned pin, int reg_type,
+				     unsigned int *reg_num, unsigned int *bit)
+{
+	struct meson_bank *bank;
+	int i, found = 0;
+
+	for (i = 0; i < domain->data->num_banks; i++) {
+		bank = &domain->data->banks[i];
+		if (pin >= bank->first && pin <= bank->last) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found)
+		return 1;
+
+	*reg_num = bank->regs[reg_type].reg;
+	*bit = bank->regs[reg_type].bit + pin - bank->first;
+
+	return 0;
+}
+
+static void *meson_get_mux_reg(struct meson_domain *domain,
+			       unsigned int reg_num)
+{
+	if (reg_num < domain->mux_size)
+		return domain->reg_mux + 4 * reg_num;
+
+	return NULL;
+}
+
+static int meson_get_groups_count(struct pinctrl_dev *pcdev)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	return pc->num_groups;
+}
+
+static const char *meson_get_group_name(struct pinctrl_dev *pcdev,
+					unsigned selector)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	return pc->groups[selector].name;
+}
+
+static int meson_get_group_pins(struct pinctrl_dev *pcdev, unsigned selector,
+				const unsigned **pins, unsigned *num_pins)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	*pins = pc->groups[selector].pins;
+	*num_pins = pc->groups[selector].num_pins;
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
+	.dt_node_to_map		= pinconf_generic_dt_node_to_map_group,
+	.dt_free_map		= pinctrl_utils_dt_free_map,
+	.pin_dbg_show		= meson_pin_dbg_show,
+};
+
+static void meson_pmx_disable_other_groups(struct meson_pinctrl *pc,
+					  unsigned int pin, int sel_group)
+{
+	struct meson_pmx_group *group;
+	struct meson_domain *domain;
+	void __iomem *reg;
+	int i, j;
+
+	for (i = 0; i < pc->num_groups; i++) {
+		group = &pc->groups[i];
+
+		if (group->is_gpio || i == sel_group)
+			continue;
+
+		for (j = 0; j < group->num_pins; j++) {
+			if (group->pins[j] == pin) {
+				domain = group->domain;
+				reg = meson_get_mux_reg(domain, group->reg);
+				meson_domain_set_bit(domain, reg,
+						     group->bit, 0);
+				break;
+			}
+		}
+	}
+}
+
+static int meson_pmx_set_mux(struct pinctrl_dev *pcdev, unsigned func_num,
+			     unsigned group_num)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+	struct meson_pmx_func *func = &pc->funcs[func_num];
+	struct meson_pmx_group *group = &pc->groups[group_num];
+	void __iomem *reg;
+	int i;
+
+	dev_dbg(pc->dev, "enable function %s, group %s\n", func->name,
+		group->name);
+
+	reg = meson_get_mux_reg(group->domain, group->reg);
+	if (!reg)
+		return -EINVAL;
+
+	/* Disable other groups using the pin */
+	for (i = 0; i < group->num_pins; i++)
+		meson_pmx_disable_other_groups(pc, group->pins[i], group_num);
+
+	/*
+	 * Function 0 (GPIO) is the default one and doesn't need any
+	 * additional settings
+	 */
+	if (func_num)
+		meson_domain_set_bit(group->domain, reg, group->bit, 1);
+
+	return 0;
+}
+
+static int meson_pmx_request_gpio(struct pinctrl_dev *pcdev,
+				  struct pinctrl_gpio_range *range,
+				  unsigned offset)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	meson_pmx_disable_other_groups(pc, offset, -1);
+
+	return 0;
+}
+
+static int meson_pmx_get_funcs_count(struct pinctrl_dev *pcdev)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	return pc->num_funcs;
+}
+
+static const char *meson_pmx_get_func_name(struct pinctrl_dev *pcdev,
+					   unsigned selector)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	return pc->funcs[selector].name;
+}
+
+static int meson_pmx_get_groups(struct pinctrl_dev *pcdev, unsigned selector,
+				const char * const **groups,
+				unsigned * const num_groups)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+
+	*groups = pc->funcs[selector].groups;
+	*num_groups = pc->funcs[selector].num_groups;
+
+	return 0;
+}
+
+static const struct pinmux_ops meson_pmx_ops = {
+	.get_functions_count = meson_pmx_get_funcs_count,
+	.get_function_name = meson_pmx_get_func_name,
+	.get_function_groups = meson_pmx_get_groups,
+	.gpio_request_enable = meson_pmx_request_gpio,
+	.set_mux = meson_pmx_set_mux,
+};
+
+static int meson_pinctrl_calc_reg_bit(struct meson_domain *domain,
+				      unsigned int pin, int reg_type,
+				      void **reg, unsigned int *bit)
+{
+	unsigned int reg_num;
+	int ret;
+
+	*reg = NULL;
+
+	ret = meson_get_pin_reg_and_bit(domain, pin, reg_type,
+					&reg_num, bit);
+	if (!ret)
+		return -EINVAL;
+
+	if (reg_type == REG_PULLEN) {
+		if (reg_num < domain->pullen_size)
+			*reg = domain->reg_pullen + 4 * reg_num;
+	} else {
+		if (reg_num < domain->pull_size)
+			*reg = domain->reg_pull + 4 * reg_num;
+	}
+
+	return *reg ? 0 : -EINVAL;
+}
+
+static int meson_pinconf_set(struct pinctrl_dev *pcdev, unsigned int pin,
+			     unsigned long *configs, unsigned num_configs)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+	void __iomem *pullen_reg, __iomem *pull_reg;
+	unsigned int pullen_bit, pull_bit;
+	enum pin_config_param param;
+	struct meson_domain *domain;
+	int i, ret;
+	u16 arg;
+
+	domain = meson_pinctrl_get_domain(pc, pin);
+	if (!domain)
+		return -EINVAL;
+
+	ret = meson_pinctrl_calc_reg_bit(domain, pin, REG_PULL,
+					 &pull_reg, &pull_bit);
+	if (ret)
+		return -EINVAL;
+
+	ret = meson_pinctrl_calc_reg_bit(domain, pin, REG_PULLEN,
+					 &pullen_reg, &pullen_bit);
+	if (ret)
+		return -EINVAL;
+
+	for (i = 0; i < num_configs; i++) {
+		param = pinconf_to_config_param(configs[i]);
+		arg = pinconf_to_config_argument(configs[i]);
+
+		switch (param) {
+		case PIN_CONFIG_BIAS_DISABLE:
+			dev_dbg(pc->dev, "pin %d bias-disable\n", pin);
+			meson_domain_set_bit(domain, pullen_reg, pullen_bit, 0);
+			break;
+		case PIN_CONFIG_BIAS_PULL_UP:
+			dev_dbg(pc->dev, "pin %d pull-up\n", pin);
+			meson_domain_set_bit(domain, pullen_reg, pullen_bit, 1);
+			meson_domain_set_bit(domain, pull_reg, pull_bit, 1);
+			break;
+		case PIN_CONFIG_BIAS_PULL_DOWN:
+			dev_dbg(pc->dev, "pin %d pull-down\n", pin);
+			meson_domain_set_bit(domain, pullen_reg, pullen_bit, 1);
+			meson_domain_set_bit(domain, pull_reg, pull_bit, 0);
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
+	unsigned int bit;
+	int ret, conf;
+	void *reg;
+
+	domain = meson_pinctrl_get_domain(pc, pin);
+	if (!domain)
+		return -EINVAL;
+
+	ret = meson_pinctrl_calc_reg_bit(domain, pin, REG_PULLEN, &reg, &bit);
+	if (ret) {
+		dev_err(pc->dev, "can't find register for pin %u\n", pin);
+		return -EINVAL;
+	}
+
+	if (!(readl(reg) & BIT(bit))) {
+		conf = PIN_CONFIG_BIAS_DISABLE;
+	} else {
+		ret = meson_pinctrl_calc_reg_bit(domain, pin, REG_PULL,
+						 &reg, &bit);
+		if (ret) {
+			dev_err(pc->dev, "can't find register for pin %u\n",
+				pin);
+			return -EINVAL;
+		}
+
+		if (!(readl(reg) & BIT(bit)))
+			conf = PIN_CONFIG_BIAS_PULL_DOWN;
+		else
+			conf = PIN_CONFIG_BIAS_PULL_UP;
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
+
+	return 0;
+}
+
+static int meson_pinconf_group_set(struct pinctrl_dev *pcdev,
+				   unsigned int num_group,
+				   unsigned long *configs, unsigned num_configs)
+{
+	struct meson_pinctrl *pc = pinctrl_dev_get_drvdata(pcdev);
+	struct meson_pmx_group *group = &pc->groups[num_group];
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
+	pinctrl_free_gpio(chip->base + gpio);
+}
+
+static int meson_gpio_calc_reg_and_bit(struct meson_domain *domain,
+				       unsigned gpio, int reg_type,
+				       void **reg, unsigned int *bit)
+{
+	unsigned int reg_num;
+	int ret;
+
+	ret = meson_get_pin_reg_and_bit(domain, gpio, reg_type, &reg_num, bit);
+
+	if (ret)
+		return -EINVAL;
+
+	if (reg_num >= domain->gpio_size)
+		return -EINVAL;
+
+	*reg = domain->reg_gpio + 4 * reg_num;
+
+	return 0;
+}
+
+static int meson_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
+{
+	struct meson_domain *domain = to_meson_domain(chip);
+	void __iomem *addr;
+	unsigned int bit;
+	int ret;
+
+	ret = meson_gpio_calc_reg_and_bit(domain, chip->base + gpio, REG_DIR,
+					  &addr, &bit);
+	if (ret)
+		return ret;
+
+	meson_domain_set_bit(domain, addr, bit, 1);
+
+	return 0;
+}
+
+static int meson_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
+				       int value)
+{
+	struct meson_domain *domain = to_meson_domain(chip);
+	void __iomem *addr;
+	unsigned int bit;
+	int ret;
+
+	ret = meson_gpio_calc_reg_and_bit(domain, chip->base + gpio, REG_DIR,
+					  &addr, &bit);
+	if (ret)
+		return ret;
+
+	meson_domain_set_bit(domain, addr, bit, 0);
+
+	return 0;
+}
+
+static void meson_gpio_set(struct gpio_chip *chip, unsigned gpio, int value)
+{
+	struct meson_domain *domain = to_meson_domain(chip);
+	void __iomem *addr;
+	unsigned int bit;
+
+	if (meson_gpio_calc_reg_and_bit(domain, chip->base + gpio, REG_OUT,
+					&addr, &bit))
+		return;
+
+	meson_domain_set_bit(domain, addr, bit, value);
+}
+
+static int meson_gpio_get(struct gpio_chip *chip, unsigned gpio)
+{
+	struct meson_domain *domain = to_meson_domain(chip);
+	void __iomem *addr;
+	unsigned int bit;
+
+	if (meson_gpio_calc_reg_and_bit(domain, chip->base + gpio, REG_IN,
+					&addr, &bit))
+		return 0;
+
+	return (readl(addr) >> bit) & 1;
+}
+
+static const struct of_device_id meson_pinctrl_dt_match[] = {
+	{
+		.compatible = "amlogic,meson8-pinctrl",
+		.data = meson8_domain_data,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, meson_pinctrl_dt_match);
+
+static int meson_gpio_of_xlate(struct gpio_chip *chip,
+			       const struct of_phandle_args *gpiospec,
+			       u32 *flags)
+{
+	unsigned gpio = gpiospec->args[0];
+
+	if (gpio < chip->base || gpio >= chip->base + chip->ngpio)
+		return -EINVAL;
+
+	if (flags)
+		*flags = gpiospec->args[1];
+
+	return gpio - chip->base;
+}
+
+static struct meson_domain_data *get_domain_data(struct device_node *node,
+					      struct meson_domain_data *data)
+{
+	while (data->name) {
+		if (!strcmp(node->name, data->name))
+			return data;
+		data++;
+	}
+
+	return NULL;
+}
+
+static int meson_pinctrl_init_data(struct meson_pinctrl *pc)
+{
+	struct meson_domain_data *data;
+	int i, j, pin = 0, func = 0, group = 0;
+
+	/* Copy pin definitions from domains to pinctrl */
+	pc->pins = devm_kzalloc(pc->dev, pc->num_pins *
+				sizeof(struct pinctrl_pin_desc), GFP_KERNEL);
+	if (!pc->pins)
+		return -ENOMEM;
+
+	for (i = 0, j = 0; i < pc->num_domains; i++) {
+		data = pc->domains[i].data;
+		for (j = 0; j < data->num_pins; j++) {
+			pc->pins[pin].number = pin;
+			pc->pins[pin++].name = data->pin_names[j];
+		}
+	}
+
+	pc->num_groups = 0;
+	pc->num_funcs = 0;
+
+	for (i = 0; i < pc->num_domains; i++) {
+		data = pc->domains[i].data;
+		pc->num_groups += data->num_groups;
+		pc->num_funcs += data->num_funcs;
+	}
+
+	/* Copy group and function definitions from domains to pinctrl */
+	pc->groups = devm_kzalloc(pc->dev, pc->num_groups *
+				  sizeof(struct meson_pmx_group), GFP_KERNEL);
+	pc->funcs = devm_kzalloc(pc->dev, pc->num_funcs *
+				  sizeof(struct meson_pmx_func), GFP_KERNEL);
+	if (!pc->groups || !pc->funcs)
+		return -ENOMEM;
+
+	for (i = 0; i < pc->num_domains; i++) {
+		data = pc->domains[i].data;
+
+		for (j = 0; j < data->num_groups; j++) {
+			memcpy(&pc->groups[group], &data->groups[j],
+			       sizeof(struct meson_pmx_group));
+			pc->groups[group++].domain = &pc->domains[i];
+		}
+
+		for (j = 0; j < data->num_funcs; j++) {
+			memcpy(&pc->funcs[func++], &data->funcs[j],
+			       sizeof(struct meson_pmx_func));
+		}
+	}
+
+	/* Count pins in groups */
+	for (i = 0; i < pc->num_groups; i++) {
+		for (j = 0; ; j++) {
+			if (pc->groups[i].pins[j] == PINS_END) {
+				pc->groups[i].num_pins = j;
+				break;
+			}
+		}
+	}
+
+	/* Count groups in functions */
+	for (i = 0; i < pc->num_funcs; i++) {
+		for (j = 0; ; j++) {
+			if (!pc->funcs[i].groups[j]) {
+				pc->funcs[i].num_groups = j;
+				break;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static void __iomem *meson_map_resource(struct meson_pinctrl *pc,
+					struct device_node *node,
+					char *name, unsigned int *size)
+{
+	struct resource res;
+	int i;
+
+	i = of_property_match_string(node, "reg-names", name);
+	if (of_address_to_resource(node, i, &res))
+		return NULL;
+
+	*size = resource_size(&res) / 4;
+	return devm_ioremap_resource(pc->dev, &res);
+}
+
+static int meson_pinctrl_parse_dt(struct meson_pinctrl *pc,
+				  struct device_node *node,
+				  struct meson_domain_data *data)
+{
+	struct device_node *np;
+	struct meson_domain *domain;
+	int i;
+
+	for_each_child_of_node(node, np) {
+		if (!of_find_property(np, "gpio-controller", NULL))
+			continue;
+		pc->num_domains++;
+	}
+
+	pc->domains = devm_kzalloc(pc->dev, pc->num_domains *
+				       sizeof(struct meson_domain),
+				       GFP_KERNEL);
+	if (!pc->domains)
+		return -ENOMEM;
+
+	i = 0;
+	for_each_child_of_node(node, np) {
+		if (!of_find_property(np, "gpio-controller", NULL))
+			continue;
+
+		domain = &pc->domains[i];
+
+		domain->reg_mux = meson_map_resource(pc, np, "mux",
+						   &domain->mux_size);
+		if (!domain->reg_mux) {
+			dev_err(pc->dev, "mux registers not found\n");
+			return -ENODEV;
+		}
+
+		domain->reg_pull = meson_map_resource(pc, np, "pull",
+						     &domain->pull_size);
+		if (!domain->reg_pull) {
+			dev_err(pc->dev, "pull registers not found\n");
+			return -ENODEV;
+		}
+
+		domain->reg_pullen = meson_map_resource(pc, np, "pull-enable",
+						       &domain->pullen_size);
+		if (!domain->reg_pullen) {
+			/* Use pull region if pull-enable is not present */
+			domain->reg_pullen = domain->reg_pull;
+			domain->pullen_size = domain->pull_size;
+		}
+
+
+		domain->reg_gpio = meson_map_resource(pc, np, "gpio",
+						     &domain->gpio_size);
+		if (!domain->reg_gpio) {
+			dev_err(pc->dev, "gpio registers not found\n");
+			return -ENODEV;
+		}
+
+		domain->data = get_domain_data(np, data);
+		if (!domain->data) {
+			dev_err(pc->dev, "domain not found\n");
+			return -ENODEV;
+		}
+
+		domain->of_node = np;
+		pc->num_pins += domain->data->num_pins;
+		i++;
+	}
+
+	return 0;
+}
+
+static int meson_gpiolib_register(struct meson_pinctrl *pc)
+{
+	struct meson_domain *domain;
+	unsigned int base = 0;
+	int i, ret;
+
+	for (i = 0; i < pc->num_domains; i++) {
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
+		domain->chip.base = base;
+		domain->chip.ngpio = domain->data->num_pins;
+		domain->chip.names = domain->data->pin_names;
+		domain->chip.can_sleep = false;
+		domain->chip.of_node = domain->of_node;
+		domain->chip.of_gpio_n_cells = 2;
+		domain->chip.of_xlate = meson_gpio_of_xlate;
+
+		ret = gpiochip_add(&domain->chip);
+		if (ret < 0) {
+			dev_err(pc->dev, "can't add gpio chip %s\n",
+				domain->data->name);
+			goto fail;
+		}
+
+		domain->gpio_range.name = domain->data->name;
+		domain->gpio_range.id = i;
+		domain->gpio_range.base = base;
+		domain->gpio_range.pin_base = base;
+		domain->gpio_range.npins = domain->data->num_pins;
+		domain->gpio_range.gc = &domain->chip;
+		pinctrl_add_gpio_range(pc->pcdev, &domain->gpio_range);
+
+		base += domain->data->num_pins;
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
+static int meson_pinctrl_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	struct device *dev = &pdev->dev;
+	struct meson_domain_data *data;
+	struct meson_pinctrl *pc;
+	int ret;
+
+	pc = devm_kzalloc(dev, sizeof(struct meson_pinctrl), GFP_KERNEL);
+	if (!pc)
+		return -ENOMEM;
+
+	match = of_match_node(meson_pinctrl_dt_match, pdev->dev.of_node);
+	data = (struct meson_domain_data *)match->data;
+	pc->dev = dev;
+
+	ret = meson_pinctrl_parse_dt(pc, pdev->dev.of_node, data);
+	if (ret)
+		return ret;
+
+	ret = meson_pinctrl_init_data(pc);
+	if (ret)
+		return ret;
+
+	pc->desc.name		= "pinctrl-meson";
+	pc->desc.owner		= THIS_MODULE;
+	pc->desc.pctlops	= &meson_pctrl_ops;
+	pc->desc.pmxops		= &meson_pmx_ops;
+	pc->desc.confops	= &meson_pinconf_ops;
+	pc->desc.pins		= pc->pins;
+	pc->desc.npins		= pc->num_pins;
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
+
+static int __init meson_pinctrl_drv_register(void)
+{
+	return platform_driver_register(&meson_pinctrl_driver);
+}
+postcore_initcall(meson_pinctrl_drv_register);
+
+MODULE_AUTHOR("Beniamino Galvani <b.galvani@gmail.com>");
+MODULE_DESCRIPTION("Amlogic Meson pinctrl driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/meson/pinctrl-meson.h b/drivers/pinctrl/meson/pinctrl-meson.h
new file mode 100644
index 0000000..992b62d
--- /dev/null
+++ b/drivers/pinctrl/meson/pinctrl-meson.h
@@ -0,0 +1,217 @@
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
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+/**
+ * struct meson_pmx_group - a pinmux group
+ *
+ * @name:	group name
+ * @pins:	pins in the group
+ * @num_pins:	number of pins in the group
+ * @is_gpio:	flag set when the group is a single GPIO group
+ * @reg:	register offset for the group in the domain mux registers
+ * @bit		bit index enabling the group
+ * @domain:	pin domain this group belongs to
+ */
+struct meson_pmx_group {
+	const char *name;
+	const unsigned int *pins;
+	unsigned int num_pins;
+	bool is_gpio;
+	unsigned int reg;
+	unsigned int bit;
+	struct meson_domain *domain;
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
+	const char **groups;
+	unsigned int num_groups;
+};
+
+/**
+ * struct meson_reg_offset
+ *
+ * @reg:	register offset
+ * @bit:	bit index
+ */
+struct meson_reg_offset {
+	unsigned int reg;
+	unsigned int bit;
+};
+
+enum {
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
+ * @regs:	couples of <reg offset, bit index> controlling the
+ *		functionalities of the bank pins (pull, direction, value)
+ *
+ * A bank represents a set of pins controlled by a contiguous set of
+ * bits in the domain registers.
+ */
+struct meson_bank {
+	const char *name;
+	unsigned int first;
+	unsigned int last;
+	struct meson_reg_offset regs[NUM_REG];
+};
+
+/**
+ * struct meson_domain_data - domain platform data
+ *
+ * @name:	label for the domain
+ * @pin_names:	names of the pins in the domain
+ * @banks:	set of banks belonging to the domain
+ * @funcs:	available pinmux functions
+ * @groups:	available pinmux groups
+ * @num_pins:	number of pins in the domain
+ * @num_banks:	number of banks in the domain
+ * @num_funcs:	number of available pinmux functions
+ * @num_groups:	number of available pinmux groups
+ *
+ */
+struct meson_domain_data {
+	const char *name;
+	const char **pin_names;
+	struct meson_bank *banks;
+	struct meson_pmx_func *funcs;
+	struct meson_pmx_group *groups;
+	unsigned int num_pins;
+	unsigned int num_banks;
+	unsigned int num_funcs;
+	unsigned int num_groups;
+};
+
+/**
+ * struct meson_domain
+ *
+ * @reg_mux:	registers for mux settings
+ * @reg_pullen:	registers for pull-enable settings
+ * @reg_pull:	registers for pull settings
+ * @reg_gpio:	registers for gpio settings
+ * @mux_size:	size of mux register range (in words)
+ * @pullen_size:size of pull-enable register range
+ * @pull_size:	size of pull register range
+ * @gpio_size:	size of gpio register range
+ * @chip:	gpio chip associated with the domain
+ * @data;	platform data for the domain
+ * @node:	device tree node for the domain
+ * @gpio_range:	gpio range that maps domain gpios to the pin controller
+ * @lock:	spinlock for accessing domain registers
+ *
+ * A domain represents a set of banks controlled by the same set of
+ * registers. Typically there is a domain for the normal banks and
+ * another one for the Always-On bus.
+ */
+struct meson_domain {
+	void __iomem *reg_mux;
+	void __iomem *reg_pullen;
+	void __iomem *reg_pull;
+	void __iomem *reg_gpio;
+
+	unsigned int mux_size;
+	unsigned int pullen_size;
+	unsigned int pull_size;
+	unsigned int gpio_size;
+
+	struct gpio_chip chip;
+	struct meson_domain_data *data;
+	struct device_node *of_node;
+	struct pinctrl_gpio_range gpio_range;
+
+	spinlock_t lock;
+};
+
+struct meson_pinctrl {
+	struct device *dev;
+	struct pinctrl_dev *pcdev;
+	struct pinctrl_desc desc;
+
+	struct pinctrl_pin_desc *pins;
+	struct meson_domain *domains;
+	struct meson_pmx_func *funcs;
+	struct meson_pmx_group *groups;
+
+	unsigned int num_pins;
+	unsigned int num_domains;
+	unsigned int num_funcs;
+	unsigned int num_groups;
+};
+
+#define PINS_END	0xffff
+
+#define GROUP(_name, _reg, _bit, _pins...)				\
+	{								\
+		.name = #_name,						\
+		.pins = (const unsigned int[]) { _pins, PINS_END },	\
+		.num_pins = 0,						\
+		.is_gpio = false,					\
+		.reg = _reg,						\
+		.bit = _bit,						\
+	}
+
+#define GPIO_GROUP(_gpio)						\
+	{								\
+		.name = #_gpio,						\
+		.pins = (const unsigned int[]){ _gpio, PINS_END },	\
+		.num_pins = 0,						\
+		.is_gpio = true,					\
+	}
+
+#define FUNCTION(_name, _groups...)					\
+	{								\
+		.name = _name,						\
+		.groups = (const char *[]) { _groups, NULL },		\
+		.num_groups = 0,					\
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
+#define MESON_PIN(x) PINCTRL_PIN(x, #x)
+
+extern struct meson_domain_data meson8_domain_data[];
diff --git a/drivers/pinctrl/meson/pinctrl-meson8.c b/drivers/pinctrl/meson/pinctrl-meson8.c
new file mode 100644
index 0000000..4b16cc5
--- /dev/null
+++ b/drivers/pinctrl/meson/pinctrl-meson8.c
@@ -0,0 +1,374 @@
+/*
+ * Pin controller and GPIO data for Amlogic Meson8
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
+
+#include "pinctrl-meson.h"
+
+const char *meson8_pin_names[] = {
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
+};
+
+const char *meson8_ao_pin_names[] = {
+	"GPIOAO_0", "GPIOAO_1", "GPIOAO_2", "GPIOAO_3",
+	"GPIOAO_4", "GPIOAO_5", "GPIOAO_6", "GPIOAO_7",
+	"GPIOAO_8", "GPIOAO_9", "GPIOAO_10", "GPIOAO_11",
+	"GPIOAO_12", "GPIOAO_13", "GPIO_BSD_EN", "GPIO_TEST_N",
+};
+
+struct meson_pmx_group meson8_groups[] = {
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
+	/* SD A */
+	GROUP(sd_d0_a,		8,	5,	GPIOX_0),
+	GROUP(sd_d1_a,		8,	4,	GPIOX_1),
+	GROUP(sd_d2_a,		8,	3,	GPIOX_2),
+	GROUP(sd_d3_a,		8,	2,	GPIOX_3),
+	GROUP(sd_clk_a,		8,	1,	GPIOX_8),
+	GROUP(sd_cmd_a,		8,	0,	GPIOX_9),
+	/* SD B */
+	GROUP(sd_d1_b,		2,	14,	CARD_0),
+	GROUP(sd_d0_b,		2,	15,	CARD_1),
+	GROUP(sd_clk_b,		2,	11,	CARD_2),
+	GROUP(sd_cmd_b,		2,	10,	CARD_3),
+	GROUP(sd_d3_b,		2,	12,	CARD_4),
+	GROUP(sd_d2_b,		2,	13,	CARD_5),
+	/* SDXC A */
+	GROUP(sdxc_d0_a,	5,	14,	GPIOX_0),
+	GROUP(sdxc_d13_a,	5,	13,	GPIOX_1, GPIOX_2, GPIOX_3),
+	GROUP(sdxc_d47_a,	5,	12,	GPIOX_4, GPIOX_5, GPIOX_6, GPIOX_7),
+	GROUP(sdxc_clk_a,	5,	11,	GPIOX_8),
+	GROUP(sdxc_cmd_a,	5,	10,	GPIOX_9),
+	/* PCM A */
+	GROUP(pcm_out_a,	3,	30,	GPIOX_4),
+	GROUP(pcm_in_a,		3,	29,	GPIOX_5),
+	GROUP(pcm_fs_a,		3,	28,	GPIOX_6),
+	GROUP(pcm_clk_a,	3,	27,	GPIOX_7),
+	/* UART A */
+	GROUP(uart_tx_a0,	4,	17,	GPIOX_4),
+	GROUP(uart_rx_a0,	4,	16,	GPIOX_5),
+	GROUP(uart_cts_a0,	4,	15,	GPIOX_6),
+	GROUP(uart_rts_a0,	4,	14,	GPIOX_7),
+	GROUP(uart_tx_a1,	4,	13,	GPIOX_12),
+	GROUP(uart_rx_a1,	4,	12,	GPIOX_13),
+	GROUP(uart_cts_a1,	4,	11,	GPIOX_14),
+	GROUP(uart_rts_a1,	4,	10,	GPIOX_15),
+	/* XTAL */
+	GROUP(xtal_32k_out,	3,	22,	GPIOX_10),
+	GROUP(xtal_24m_out,	3,	23,	GPIOX_11),
+	/* UART B */
+	GROUP(uart_tx_b0,	4,	9,	GPIOX_16),
+	GROUP(uart_rx_b0,	4,	8,	GPIOX_17),
+	GROUP(uart_cts_b0,	4,	7,	GPIOX_18),
+	GROUP(uart_rts_b0,	4,	6,	GPIOX_19),
+	GROUP(uart_tx_b1,	6,	23,	GPIODV_24),
+	GROUP(uart_rx_b1,	6,	22,	GPIODV_25),
+	GROUP(uart_cts_b1,	6,	21,	GPIODV_26),
+	GROUP(uart_rts_b1,	6,	20,	GPIODV_27),
+	/* UART C */
+	GROUP(uart_tx_c,	1,	19,	GPIOY_0),
+	GROUP(uart_rx_c,	1,	18,	GPIOY_1),
+	GROUP(uart_cts_c,	1,	17,	GPIOY_2),
+	GROUP(uart_rts_c,	1,	16,	GPIOY_3),
+	/* ETHERNET */
+	GROUP(eth_tx_clk_50m,	6,	15,	GPIOZ_4),
+	GROUP(eth_tx_en,	6,	14,	GPIOZ_5),
+	GROUP(eth_txd1,		6,	13,	GPIOZ_6),
+	GROUP(eth_txd0,		6,	12,	GPIOZ_7),
+	GROUP(eth_rx_clk_in,	6,	10,	GPIOZ_8),
+	GROUP(eth_rx_dv,	6,	11,	GPIOZ_9),
+	GROUP(eth_rxd1,		6,	8,	GPIOZ_10),
+	GROUP(eth_rxd0,		6,	7,	GPIOZ_11),
+	GROUP(eth_mdio,		6,	6,	GPIOZ_12),
+	GROUP(eth_mdc,		6,	5,	GPIOZ_13),
+	/* NAND */
+	GROUP(nand_io,		2,	26,	BOOT_0, BOOT_1, BOOT_2, BOOT_3,
+						BOOT_4, BOOT_5, BOOT_6, BOOT_7),
+	GROUP(nand_io_ce0,	2,	25,	BOOT_8),
+	GROUP(nand_io_ce1,	2,	24,	BOOT_9),
+	GROUP(nand_io_rb0,	2,	17,	BOOT_10),
+	GROUP(nand_ale,		2,	21,	BOOT_11),
+	GROUP(nand_cle,		2,	20,	BOOT_12),
+	GROUP(nand_wen_clk,	2,	19,	BOOT_13),
+	GROUP(nand_ren_clk,	2,	18,	BOOT_14),
+	GROUP(nand_dqs,		2,	27,	BOOT_15),
+	GROUP(nand_ce2,		2,	23,	BOOT_16),
+	GROUP(nand_ce3,		2,	22,	BOOT_17),
+	/* SPI */
+	GROUP(spi_ss0_0,	9,	13,	GPIOH_3),
+	GROUP(spi_miso_0,	9,	12,	GPIOH_4),
+	GROUP(spi_mosi_0,	9,	11,	GPIOH_5),
+	GROUP(spi_sclk_0,	9,	10,	GPIOH_6),
+	GROUP(spi_ss0_1,	8,	16,	GPIOZ_9),
+	GROUP(spi_ss1_1,	8,	12,	GPIOZ_10),
+	GROUP(spi_sclk_1,	8,	15,	GPIOZ_11),
+	GROUP(spi_mosi_1,	8,	14,	GPIOZ_12),
+	GROUP(spi_miso_1,	8,	13,	GPIOZ_13),
+	GROUP(spi_ss2_1,	8,	17,	GPIOZ_14),
+};
+
+struct meson_pmx_group meson8_ao_groups[] = {
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
+	/* UART AO A */
+	GROUP(uart_tx_ao_a,	0,	12,	GPIOAO_0),
+	GROUP(uart_rx_ao_a,	0,	11,	GPIOAO_1),
+	GROUP(uart_cts_ao_a,	0,	10,	GPIOAO_2),
+	GROUP(uart_rts_ao_a,	0,	9,	GPIOAO_3),
+	/* UART AO B */
+	GROUP(uart_tx_ao_b0,	0,	26,	GPIOAO_0),
+	GROUP(uart_rx_ao_b0,	0,	25,	GPIOAO_1),
+	GROUP(uart_tx_ao_b1,	0,	24,	GPIOAO_4),
+	GROUP(uart_rx_ao_b1,	0,	23,	GPIOAO_5),
+	/* I2C master AO */
+	GROUP(i2c_mst_sck_ao,	0,	6,	GPIOAO_4),
+	GROUP(i2c_mst_sda_ao,	0,	5,	GPIOAO_5),
+};
+
+struct meson_pmx_func meson8_functions[] = {
+	{
+		.name = "gpio",
+		.groups = meson8_pin_names,
+		.num_groups = ARRAY_SIZE(meson8_pin_names),
+	},
+	FUNCTION("sd_a",	"sd_d0_a", "sd_d1_a", "sd_d2_a", "sd_d3_a",
+				"sd_clk_a", "sd_cmd_a"),
+
+	FUNCTION("sd_b",	"sd_d1_b", "sd_d0_b", "sd_clk_b", "sd_cmd_b",
+				"sd_d3_b", "sd_d2_b"),
+
+	FUNCTION("sdxc_a",	"sdxc_d0_a", "sdxc_d13_a", "sdxc_d47_a",
+				"sdxc_clk_a", "sdxc_cmd_a"),
+
+	FUNCTION("pcm_a",	"pcm_out_a", "pcm_in_a", "pcm_fs_a", "pcm_clk_a"),
+
+	FUNCTION("uart_a",	"uart_tx_a0", "uart_rx_a0", "uart_cts_a0", "uart_rts_a0",
+				"uart_tx_a1", "uart_rx_a1", "uart_cts_a1", "uart_rts_a1"),
+
+	FUNCTION("xtal",	"xtal_32k_out", "xtal_24m_out"),
+
+	FUNCTION("uart_b",	"uart_tx_b0", "uart_rx_b0", "uart_cts_b0", "uart_rts_b0",
+				"uart_tx_b1", "uart_rx_b1", "uart_cts_b1", "uart_rts_b1"),
+
+	FUNCTION("uart_c",	"uart_tx_c", "uart_rx_c", "uart_cts_c", "uart_rts_c"),
+
+	FUNCTION("ethernet",	"eth_tx_clk_50m", "eth_tx_en", "eth_txd1",
+				"eth_txd0", "eth_rx_clk_in", "eth_rx_dv",
+				"eth_rxd1", "eth_rxd0", "eth_mdio", "eth_mdc"),
+
+	FUNCTION("nand",	"nand_io", "nand_io_ce0", "nand_io_ce1",
+				"nand_io_rb0", "nand_ale", "nand_cle",
+				"nand_wen_clk", "nand_ren_clk", "nand_dqs",
+				"nand_ce2", "nand_ce3"),
+
+	FUNCTION("spi",		"spi_ss0_0", "spi_miso_0", "spi_mosi_0", "spi_sclk_0",
+				"spi_ss0_1", "spi_ss1_1", "spi_sclk_1", "spi_mosi_1",
+				"spi_miso_1", "spi_ss2_1"),
+};
+
+struct meson_pmx_func meson8_ao_functions[] = {
+	{
+		.name = "gpio",
+		.groups = meson8_ao_pin_names,
+		.num_groups = ARRAY_SIZE(meson8_ao_pin_names),
+	},
+	FUNCTION("uart_ao",	"uart_tx_ao_a", "uart_rx_ao_a",
+				"uart_cts_ao_a", "uart_rts_ao_a"),
+
+	FUNCTION("uart_ao_b",	"uart_tx_ao_b0", "uart_rx_ao_b0",
+				"uart_tx_ao_b1", "uart_rx_ao_b1"),
+
+	FUNCTION("i2c_mst_ao",	"i2c_mst_sck_ao", "i2c_mst_sda_ao"),
+};
+
+
+struct meson_bank meson8_banks[] = {
+	/*   name    first     last         pullen  pull     dir     out     in  */
+	BANK("X",    GPIOX_0,  GPIOX_21,    4,  0,  4,  0,  0,  0,  1,  0,  2,  0),
+	BANK("Y",    GPIOY_0,  GPIOY_16,    3,  0,  3,  0,  3,  0,  4,  0,  5,  0),
+	BANK("DV",   GPIODV_0, GPIODV_29,   0,  0,  0,  0,  7,  0,  8,  0,  9,  0),
+	BANK("H",    GPIOH_0,  GPIOH_9,     1, 16,  1, 16,  9, 19, 10, 19, 11, 19),
+	BANK("Z",    GPIOZ_0,  GPIOZ_14,    1,  0,  1,  0,  3, 17,  4, 17,  5, 17),
+	BANK("CARD", CARD_0,   CARD_6,      2, 20,  2, 20,  0, 22,  1, 22,  2, 22),
+	BANK("BOOT", BOOT_0,   BOOT_18,     2,  0,  2,  0,  9,  0, 10,  0, 11,  0),
+};
+
+struct meson_bank meson8_ao_banks[] = {
+	/*   name    first     last        pullen  pull     dir     out     in  */
+	BANK("AO",   GPIOAO_0, GPIO_TEST_N, 0,  0,  0, 16,  0,  0,  0, 16,  1,  0),
+};
+
+struct meson_domain_data meson8_domain_data[] = {
+	{
+		.name		= "banks",
+		.banks		= meson8_banks,
+		.pin_names	= meson8_pin_names,
+		.funcs		= meson8_functions,
+		.groups		= meson8_groups,
+		.num_pins	= ARRAY_SIZE(meson8_pin_names),
+		.num_banks	= ARRAY_SIZE(meson8_banks),
+		.num_funcs	= ARRAY_SIZE(meson8_functions),
+		.num_groups	= ARRAY_SIZE(meson8_groups),
+	},
+	{
+		.name		= "ao-bank",
+		.banks		= meson8_ao_banks,
+		.pin_names	= meson8_ao_pin_names,
+		.funcs		= meson8_ao_functions,
+		.groups		= meson8_ao_groups,
+		.num_pins	= ARRAY_SIZE(meson8_ao_pin_names),
+		.num_banks	= ARRAY_SIZE(meson8_ao_banks),
+		.num_funcs	= ARRAY_SIZE(meson8_ao_functions),
+		.num_groups	= ARRAY_SIZE(meson8_ao_groups),
+	},
+	{ },
+};
+
diff --git a/include/dt-bindings/gpio/meson8-gpio.h b/include/dt-bindings/gpio/meson8-gpio.h
new file mode 100644
index 0000000..584dd92
--- /dev/null
+++ b/include/dt-bindings/gpio/meson8-gpio.h
@@ -0,0 +1,155 @@
+/*
+ * GPIO definitions for Amlogic Meson8
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
+#define GPIOAO_0	120
+#define GPIOAO_1	121
+#define GPIOAO_2	122
+#define GPIOAO_3	123
+#define GPIOAO_4	124
+#define GPIOAO_5	125
+#define GPIOAO_6	126
+#define GPIOAO_7	127
+#define GPIOAO_8	128
+#define GPIOAO_9	129
+#define GPIOAO_10	130
+#define GPIOAO_11	131
+#define GPIOAO_12	132
+#define GPIOAO_13	133
+#define GPIO_BSD_EN	134
+#define GPIO_TEST_N	135
+
+#endif /* _DT_BINDINGS_MESON8_GPIO_H */
-- 
1.9.1

