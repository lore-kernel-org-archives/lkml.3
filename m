Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3HXVjk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 17:39:40 -0400
Received: from 3.mo2.mail-out.ovh.net ([46.105.58.226]:36385 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755578Ab3HXVji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 17:39:38 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [RFC PATCH 2/3] pinctrl: at91: add support for generic pinconf
Date: Sat, 24 Aug 2013 23:37:39 +0200
Message-Id: <1377380259-11290-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com>
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 2884274087906015456
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for generic pin configuration to pinctrl-at91 driver.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 .../bindings/pinctrl/atmel,at91-pinctrl.txt        |   43 +++-
 drivers/pinctrl/Kconfig                            |    2 +-
 drivers/pinctrl/pinctrl-at91.c                     |  265 ++++++++++++++++++--
 3 files changed, 289 insertions(+), 21 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
index 7ccae49..7a7c0c4 100644
--- a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
@@ -18,7 +18,9 @@ mode) this pin can work on and the 'config' configures various pad settings
 such as pull-up, multi drive, etc.
 
 Required properties for iomux controller:
-- compatible: "atmel,at91rm9200-pinctrl"
+- compatible: "atmel,at91rm9200-pinctrl" or "atmel,at91sam9x5-pinctrl".
+  Add "generic-pinconf" to the compatible string list to use the generic pin
+  configuration syntax.
 - atmel,mux-mask: array of mask (periph per bank) to describe if a pin can be
   configured in this periph mode. All the periph and bank need to be describe.
 
@@ -83,6 +85,11 @@ Required properties for pin configuration node:
   setting. The format is atmel,pins = <PIN_BANK PIN_BANK_NUM PERIPH CONFIG>.
   The PERIPH 0 means gpio, PERIPH 1 is periph A, PERIPH 2 is periph B...
   PIN_BANK 0 is pioA, PIN_BANK 1 is pioB...
+  Dependending on the presence of the "generic-pinconf" string in the
+  compatible property the 4th cell is:
+   * a phandle referencing a generic pin config node (refer to
+     pinctrl-bindings.txt)
+   * an integer defining the pin config (see the following description)
 
 Bits used for CONFIG:
 PULL_UP		(1 << 0): indicate this pin need a pull up.
@@ -132,6 +139,40 @@ pinctrl@fffff400 {
 	};
 };
 
+or
+
+pinctrl@fffff400 {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+	compatible = "atmel,at91rm9200-pinctrl", "generic-pinconf", "simple-bus";
+	reg = <0xfffff400 0x600>;
+
+	atmel,mux-mask = <
+	      /*    A         B     */
+	       0xffffffff 0xffc00c3b  /* pioA */
+	       0xffffffff 0x7fff3ccf  /* pioB */
+	       0xffffffff 0x007fffff  /* pioC */
+	      >;
+
+	pcfg_none: pcfg_none {
+		bias-disable;
+	};
+
+	pcfg_pull_up: pcfg_pull_up {
+		bias-pullup;
+	};
+
+	/* shared pinctrl settings */
+	dbgu {
+		pinctrl_dbgu: dbgu-0 {
+			atmel,pins =
+				<1 14 0x1 &pcfg_none		/* PB14 periph A */
+				 1 15 0x1 &pcfg_pull_up>;	/* PB15 periph A with pullup */
+		};
+	};
+};
+
 dbgu: serial@fffff200 {
 	compatible = "atmel,at91sam9260-usart";
 	reg = <0xfffff200 0x200>;
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index bdb1a87..55a4f2c 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -54,7 +54,7 @@ config PINCTRL_AT91
 	depends on OF
 	depends on ARCH_AT91
 	select PINMUX
-	select PINCONF
+	select GENERIC_PINCONF
 	help
 	  Say Y here to enable the at91 pinctrl driver
 
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 7cce066..1994dd2 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -23,6 +23,7 @@
 #include <linux/gpio.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/pinconf-generic.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
 /* Since we request GPIOs from ourself */
@@ -32,6 +33,7 @@
 #include <mach/at91_pio.h>
 
 #include "core.h"
+#include "pinconf.h"
 
 #define MAX_NB_GPIO_PER_BANK	32
 
@@ -85,6 +87,21 @@ enum at91_mux {
 	AT91_MUX_PERIPH_D = 4,
 };
 
+struct at91_generic_pinconf {
+	unsigned long	*configs;
+	unsigned int	nconfigs;
+};
+
+enum at91_pinconf_type {
+	AT91_PINCONF_NATIVE,
+	AT91_PINCONF_GENERIC,
+};
+
+union at91_pinconf {
+	unsigned long			native;
+	struct at91_generic_pinconf	generic;
+};
+
 /**
  * struct at91_pmx_pin - describes an At91 pin mux
  * @bank: the bank of the pin
@@ -93,10 +110,11 @@ enum at91_mux {
  * @conf: the configuration of the pin: PULL_UP, MULTIDRIVE etc...
  */
 struct at91_pmx_pin {
-	uint32_t	bank;
-	uint32_t	pin;
-	enum at91_mux	mux;
-	unsigned long	conf;
+	uint32_t		bank;
+	uint32_t		pin;
+	enum at91_mux		mux;
+	enum at91_pinconf_type	conftype;
+	union at91_pinconf	conf;
 };
 
 /**
@@ -278,8 +296,16 @@ static int at91_dt_node_to_map(struct pinctrl_dev *pctldev,
 		new_map[i].type = PIN_MAP_TYPE_CONFIGS_PIN;
 		new_map[i].data.configs.group_or_pin =
 				pin_get_name(pctldev, grp->pins[i]);
-		new_map[i].data.configs.configs = &grp->pins_conf[i].conf;
-		new_map[i].data.configs.num_configs = 1;
+		if (!pctldev->desc->confops->is_generic) {
+			new_map[i].data.configs.configs =
+				&grp->pins_conf[i].conf.native;
+			new_map[i].data.configs.num_configs = 1;
+		} else {
+			new_map[i].data.configs.configs =
+				grp->pins_conf[i].conf.generic.configs;
+			new_map[i].data.configs.num_configs =
+				grp->pins_conf[i].conf.generic.nconfigs;
+		}
 	}
 
 	dev_dbg(pctldev->dev, "maps: function %s group %s num %d\n",
@@ -325,7 +351,7 @@ static void at91_mux_disable_interrupt(void __iomem *pio, unsigned mask)
 
 static unsigned at91_mux_get_pullup(void __iomem *pio, unsigned pin)
 {
-	return (readl_relaxed(pio + PIO_PUSR) >> pin) & 0x1;
+	return !((readl_relaxed(pio + PIO_PUSR) >> pin) & 0x1);
 }
 
 static void at91_mux_set_pullup(void __iomem *pio, unsigned mask, bool on)
@@ -407,6 +433,16 @@ static enum at91_mux at91_mux_get_periph(void __iomem *pio, unsigned mask)
 	return select + 1;
 }
 
+static bool at91_mux_get_output(void __iomem *pio, unsigned pin)
+{
+	return (readl_relaxed(pio + PIO_OSR) >> pin) & 0x1;
+}
+
+static void at91_mux_set_output(void __iomem *pio, unsigned mask, bool is_on)
+{
+	__raw_writel(mask, pio + (is_on ? PIO_OER : PIO_ODR));
+}
+
 static bool at91_mux_get_deglitch(void __iomem *pio, unsigned pin)
 {
 	return (__raw_readl(pio + PIO_IFSR) >> pin) & 0x1;
@@ -445,7 +481,7 @@ static void at91_mux_pio3_set_debounce(void __iomem *pio, unsigned mask,
 
 static bool at91_mux_pio3_get_pulldown(void __iomem *pio, unsigned pin)
 {
-	return (__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1;
+	return !((__raw_readl(pio + PIO_PPDSR) >> pin) & 0x1);
 }
 
 static void at91_mux_pio3_set_pulldown(void __iomem *pio, unsigned mask, bool is_on)
@@ -492,12 +528,17 @@ static struct at91_pinctrl_mux_ops at91sam9x5_ops = {
 static void at91_pin_dbg(const struct device *dev, const struct at91_pmx_pin *pin)
 {
 	if (pin->mux) {
-		dev_dbg(dev, "pio%c%d configured as periph%c with conf = 0x%lu\n",
-			pin->bank + 'A', pin->pin, pin->mux - 1 + 'A', pin->conf);
+		dev_dbg(dev, "pio%c%d configured as periph%c",
+			pin->bank + 'A', pin->pin, pin->mux - 1 + 'A');
 	} else {
-		dev_dbg(dev, "pio%c%d configured as gpio with conf = 0x%lu\n",
-			pin->bank + 'A', pin->pin, pin->conf);
+		dev_dbg(dev, "pio%c%d configured as gpio",
+			pin->bank + 'A', pin->pin);
 	}
+
+	if (pin->conftype == AT91_PINCONF_NATIVE)
+		dev_dbg(dev, " with conf = 0x%lu\n", pin->conf.native);
+	else
+		dev_dbg(dev, "\n");
 }
 
 static int pin_check_config(struct at91_pinctrl *info, const char *name,
@@ -782,6 +823,157 @@ static const struct pinconf_ops at91_pinconf_ops = {
 	.pin_config_group_dbg_show	= at91_pinconf_group_dbg_show,
 };
 
+static int at91_generic_pinconf_get(struct pinctrl_dev *pctldev,
+				    unsigned pin_id, unsigned long *config)
+{
+	struct at91_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	enum pin_config_param param = pinconf_to_config_param(*config);
+	void __iomem *pio = pin_to_controller(info, pin_to_bank(pin_id));
+	unsigned pin = pin_id % MAX_NB_GPIO_PER_BANK;
+	int div;
+
+	switch (param) {
+	case PIN_CONFIG_BIAS_DISABLE:
+		if (at91_mux_get_pullup(pio, pin) &&
+		    (info->ops->get_pulldown ||
+		     !info->ops->get_pulldown(pio, pin)))
+			return -EINVAL;
+
+		*config = 0;
+		break;
+	case PIN_CONFIG_BIAS_PULL_UP:
+		if (!at91_mux_get_pullup(pio, pin))
+			return -EINVAL;
+
+		*config = 0;
+		break;
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+		if (!info->ops->get_pulldown)
+			return -ENOTSUPP;
+		if (!info->ops->get_pulldown(pio, pin))
+			return -EINVAL;
+
+		*config = 0;
+		break;
+	case PIN_CONFIG_DRIVE_OPEN_DRAIN:
+		if (!at91_mux_get_multidrive(pio, pin))
+			return -EINVAL;
+
+		*config = 0;
+		break;
+	case PIN_CONFIG_INPUT_SCHMITT_ENABLE:
+		if (!info->ops->get_schmitt_trig)
+			return -ENOTSUPP;
+
+		if (!(info->ops->get_schmitt_trig(pio, pin)))
+			*config = 1;
+		else
+			*config = 0;
+		break;
+	case PIN_CONFIG_INPUT_DEBOUNCE:
+		if (!info->ops->get_debounce)
+			return -ENOTSUPP;
+
+		if (info->ops->get_debounce(pio, pin, &div)) {
+			/* TODO: replace 32768 with clk_get_rate(slck) return */
+			*config = ((div + 1) * 2) * 1000000 / 32768;
+			if (*config > 0xffff)
+				*config = 0xffff;
+		} else
+			*config = 0;
+		break;
+	case PIN_CONFIG_INPUT_DEGLITCH:
+		if (!info->ops->get_deglitch)
+			return -ENOTSUPP;
+
+		*config = info->ops->get_deglitch(pio, pin);
+		break;
+	case PIN_CONFIG_OUTPUT:
+		if (info->ops->get_periph(pio, pin) != AT91_MUX_GPIO)
+			return -EINVAL;
+
+		*config = at91_mux_get_output(pio, pin);
+		break;
+	default:
+		return -ENOTSUPP;
+		break;
+	}
+
+	return 0;
+}
+
+static int at91_generic_pinconf_set(struct pinctrl_dev *pctldev,
+				    unsigned pin_id, unsigned long config)
+{
+	struct at91_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	enum pin_config_param param = pinconf_to_config_param(config);
+	u16 arg = pinconf_to_config_argument(config);
+	u32 div = 0;
+	unsigned pin = pin_id % MAX_NB_GPIO_PER_BANK;
+	unsigned mask = pin_to_mask(pin);
+	void __iomem *pio = pin_to_controller(info, pin_to_bank(pin_id));
+
+	switch (param) {
+	case PIN_CONFIG_BIAS_DISABLE:
+		at91_mux_set_pullup(pio, mask, 0);
+		if (info->ops->set_pulldown)
+			info->ops->set_pulldown(pio, mask, 0);
+		break;
+	case PIN_CONFIG_BIAS_PULL_UP:
+		at91_mux_set_pullup(pio, mask, arg);
+		break;
+	case PIN_CONFIG_BIAS_PULL_DOWN:
+		if (!info->ops->set_pulldown)
+			return -ENOTSUPP;
+		info->ops->set_pulldown(pio, mask, arg);
+		break;
+	case PIN_CONFIG_DRIVE_OPEN_DRAIN:
+		at91_mux_set_multidrive(pio, mask, 1);
+		break;
+	case PIN_CONFIG_INPUT_SCHMITT_ENABLE:
+		if (!info->ops->disable_schmitt_trig)
+			return -ENOTSUPP;
+		if (arg)
+			mask = ~mask;
+		info->ops->disable_schmitt_trig(pio, mask);
+		break;
+	case PIN_CONFIG_INPUT_DEBOUNCE:
+		if (!info->ops->set_debounce)
+			return -ENOTSUPP;
+
+		/* TODO: replace 32768 with clk_get_rate(slck) return */
+		if (arg) {
+			div = (arg * 32768 / (2 * 1000000));
+			if (div)
+				div--;
+		}
+		info->ops->set_debounce(pio, mask, arg ? 1 : 0, div);
+		break;
+	case PIN_CONFIG_INPUT_DEGLITCH:
+		if (!info->ops->set_deglitch)
+			return -ENOTSUPP;
+
+		info->ops->set_deglitch(pio, mask, arg ? 1 : 0);
+		break;
+	case PIN_CONFIG_OUTPUT:
+		if (info->ops->get_periph(pio, pin) != AT91_MUX_GPIO)
+			return -EINVAL;
+		at91_mux_set_output(pio, mask, arg);
+		break;
+	default:
+		return -ENOTSUPP;
+		break;
+	}
+
+	return 0;
+}
+
+static const struct pinconf_ops at91_generic_pinconf_ops = {
+	.is_generic			= true,
+	.pin_config_get			= at91_generic_pinconf_get,
+	.pin_config_set			= at91_generic_pinconf_set,
+};
+
 static struct pinctrl_desc at91_pinctrl_desc = {
 	.pctlops	= &at91_pctrl_ops,
 	.pmxops		= &at91_pmx_ops,
@@ -847,6 +1039,7 @@ static int at91_pinctrl_parse_groups(struct device_node *np,
 	int size;
 	const __be32 *list;
 	int i, j;
+	int err;
 
 	dev_dbg(info->dev, "group(%d): %s\n", index, np->name);
 
@@ -870,21 +1063,48 @@ static int at91_pinctrl_parse_groups(struct device_node *np,
 				GFP_KERNEL);
 	grp->pins = devm_kzalloc(info->dev, grp->npins * sizeof(unsigned int),
 				GFP_KERNEL);
-	if (!grp->pins_conf || !grp->pins)
-		return -ENOMEM;
+	if (!grp->pins_conf || !grp->pins) {
+		err = -ENOMEM;
+		goto out_err;
+	}
 
 	for (i = 0, j = 0; i < size; i += 4, j++) {
 		pin->bank = be32_to_cpu(*list++);
 		pin->pin = be32_to_cpu(*list++);
 		grp->pins[j] = pin->bank * MAX_NB_GPIO_PER_BANK + pin->pin;
 		pin->mux = be32_to_cpu(*list++);
-		pin->conf = be32_to_cpu(*list++);
+		if (at91_pinctrl_desc.confops->is_generic) {
+			struct device_node *np_config;
+			const __be32 *phandle =	list++;
+
+			if (!phandle) {
+				err = -EINVAL;
+				goto out_err;
+			}
+			np_config =
+				of_find_node_by_phandle(be32_to_cpup(phandle));
+			pin->conftype = AT91_PINCONF_GENERIC;
+			err = pinconf_generic_parse_dt_config(np_config,
+						&pin->conf.generic.configs,
+						&pin->conf.generic.nconfigs);
+			if (err)
+				goto out_err;
+
+		} else {
+			pin->conftype = AT91_PINCONF_NATIVE;
+			pin->conf.native = be32_to_cpu(*list++);
+		}
 
 		at91_pin_dbg(info->dev, pin);
 		pin++;
 	}
 
 	return 0;
+
+out_err:
+	kfree(grp->pins_conf);
+	kfree(grp->pins);
+	return err;
 }
 
 static int at91_pinctrl_parse_functions(struct device_node *np,
@@ -904,10 +1124,10 @@ static int at91_pinctrl_parse_functions(struct device_node *np,
 	/* Initialise function */
 	func->name = np->name;
 	func->ngroups = of_get_child_count(np);
-	if (func->ngroups <= 0) {
-		dev_err(info->dev, "no groups defined\n");
-		return -EINVAL;
-	}
+	/* This node might be a generic config definition: silently ignore it */
+	if (func->ngroups <= 0)
+		return 0;
+
 	func->groups = devm_kzalloc(info->dev,
 			func->ngroups * sizeof(char *), GFP_KERNEL);
 	if (!func->groups)
@@ -930,6 +1150,11 @@ static struct of_device_id at91_pinctrl_of_match[] = {
 	{ /* sentinel */ }
 };
 
+static struct of_device_id at91_pinconf_of_match[] = {
+	{ .compatible = "generic-pinconf" },
+	{ /* sentinel */ }
+};
+
 static int at91_pinctrl_probe_dt(struct platform_device *pdev,
 				 struct at91_pinctrl *info)
 {
@@ -945,6 +1170,8 @@ static int at91_pinctrl_probe_dt(struct platform_device *pdev,
 	info->dev = &pdev->dev;
 	info->ops = (struct at91_pinctrl_mux_ops *)
 		of_match_device(at91_pinctrl_of_match, &pdev->dev)->data;
+	if (of_match_device(at91_pinconf_of_match, &pdev->dev))
+		at91_pinctrl_desc.confops = &at91_generic_pinconf_ops;
 	at91_pinctrl_child_count(info, np);
 
 	if (info->nbanks < 1) {
-- 
1.7.9.5

