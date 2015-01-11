Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbbAKXte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:49:34 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:40215 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbbAKXtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:49:33 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] pinctrl: pinconf-generic: loose DT dependence
Date: Mon, 12 Jan 2015 00:49:26 +0100
Message-Id: <1421020166-22831-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New pin controllers such as ACPI-based may also have custom properties
to parse, and should be able to use generic pin config. Let's make the
code compile on !OF systems and rename members a bit to underscore it
is custom parameters and not necessarily DT parameters.

This fixes a build regression for x86_64 on the zeroday kernel builds.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinconf-generic.c        | 39 ++++++++++++++++++--------------
 drivers/pinctrl/pinctrl-zynq.c           |  8 +++----
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c |  8 +++----
 include/linux/pinctrl/pinconf-generic.h  |  2 +-
 include/linux/pinctrl/pinctrl.h          | 17 ++++++++------
 5 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index e0886665b70a..4db92f64b4de 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -113,10 +113,11 @@ void pinconf_generic_dump_pins(struct pinctrl_dev *pctldev, struct seq_file *s,
 	pinconf_generic_dump_one(pctldev, s, gname, pin, conf_items,
 				 ARRAY_SIZE(conf_items));
 	/* driver-specific parameters */
-	if (pctldev->desc->num_dt_params && pctldev->desc->conf_items)
+	if (pctldev->desc->num_custom_params &&
+	    pctldev->desc->custom_conf_items)
 		pinconf_generic_dump_one(pctldev, s, gname, pin,
-					 pctldev->desc->conf_items,
-					 pctldev->desc->num_dt_params);
+					 pctldev->desc->custom_conf_items,
+					 pctldev->desc->num_custom_params);
 }
 
 void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
@@ -131,21 +132,24 @@ void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
 			   pinconf_to_config_argument(config));
 	}
 
-	if (!pctldev->desc->num_dt_params || !pctldev->desc->conf_items)
+	if (!pctldev->desc->num_custom_params ||
+	    !pctldev->desc->custom_conf_items)
 		return;
 
-	for (i = 0; i < pctldev->desc->num_dt_params; i++) {
-		if (pinconf_to_config_param(config) != pctldev->desc->conf_items[i].param)
+	for (i = 0; i < pctldev->desc->num_custom_params; i++) {
+		if (pinconf_to_config_param(config) !=
+		    pctldev->desc->custom_conf_items[i].param)
 			continue;
-		seq_printf(s, "%s: 0x%x", pctldev->desc->conf_items[i].display,
-			   pinconf_to_config_argument(config));
+		seq_printf(s, "%s: 0x%x",
+				pctldev->desc->custom_conf_items[i].display,
+				pinconf_to_config_argument(config));
 	}
 }
 EXPORT_SYMBOL_GPL(pinconf_generic_dump_config);
 #endif
 
 #ifdef CONFIG_OF
-static const struct pinconf_generic_dt_params dt_params[] = {
+static const struct pinconf_generic_params dt_params[] = {
 	{ "bias-disable", PIN_CONFIG_BIAS_DISABLE, 0 },
 	{ "bias-high-impedance", PIN_CONFIG_BIAS_HIGH_IMPEDANCE, 0 },
 	{ "bias-bus-hold", PIN_CONFIG_BIAS_BUS_HOLD, 0 },
@@ -170,9 +174,9 @@ static const struct pinconf_generic_dt_params dt_params[] = {
 };
 
 /**
- * parse_dt_cfg - Parse DT pinconf parameters
+ * parse_dt_cfg() - Parse DT pinconf parameters
  * @np:	DT node
- * @params:	Array of describing DT parameters
+ * @params:	Array of describing generic parameters
  * @count:	Number of entries in @params
  * @cfg:	Array of parsed config options
  * @ncfg:	Number of entries in @cfg
@@ -183,7 +187,7 @@ static const struct pinconf_generic_dt_params dt_params[] = {
  * needs to have enough memory allocated to hold all possible entries.
  */
 static void parse_dt_cfg(struct device_node *np,
-			 const struct pinconf_generic_dt_params *params,
+			 const struct pinconf_generic_params *params,
 			 unsigned int count, unsigned long *cfg,
 			 unsigned int *ncfg)
 {
@@ -192,7 +196,7 @@ static void parse_dt_cfg(struct device_node *np,
 	for (i = 0; i < count; i++) {
 		u32 val;
 		int ret;
-		const struct pinconf_generic_dt_params *par = &params[i];
+		const struct pinconf_generic_params *par = &params[i];
 
 		ret = of_property_read_u32(np, par->property, &val);
 
@@ -232,15 +236,16 @@ int pinconf_generic_parse_dt_config(struct device_node *np,
 	/* allocate a temporary array big enough to hold one of each option */
 	max_cfg = ARRAY_SIZE(dt_params);
 	if (pctldev)
-		max_cfg += pctldev->desc->num_dt_params;
+		max_cfg += pctldev->desc->num_custom_params;
 	cfg = kcalloc(max_cfg, sizeof(*cfg), GFP_KERNEL);
 	if (!cfg)
 		return -ENOMEM;
 
 	parse_dt_cfg(np, dt_params, ARRAY_SIZE(dt_params), cfg, &ncfg);
-	if (pctldev && pctldev->desc->num_dt_params && pctldev->desc->params)
-		parse_dt_cfg(np, pctldev->desc->params,
-			      pctldev->desc->num_dt_params, cfg, &ncfg);
+	if (pctldev && pctldev->desc->num_custom_params &&
+		pctldev->desc->custom_params)
+		parse_dt_cfg(np, pctldev->desc->custom_params,
+			     pctldev->desc->num_custom_params, cfg, &ncfg);
 
 	ret = 0;
 
diff --git a/drivers/pinctrl/pinctrl-zynq.c b/drivers/pinctrl/pinctrl-zynq.c
index 62534234da78..8aa05e2eb705 100644
--- a/drivers/pinctrl/pinctrl-zynq.c
+++ b/drivers/pinctrl/pinctrl-zynq.c
@@ -920,7 +920,7 @@ enum zynq_pin_config_param {
 	PIN_CONFIG_IOSTANDARD = PIN_CONFIG_END + 1,
 };
 
-static const struct pinconf_generic_dt_params zynq_dt_params[] = {
+static const struct pinconf_generic_params zynq_dt_params[] = {
 	{"io-standard", PIN_CONFIG_IOSTANDARD, zynq_iostd_lvcmos18},
 };
 
@@ -1099,9 +1099,9 @@ static struct pinctrl_desc zynq_desc = {
 	.pctlops = &zynq_pctrl_ops,
 	.pmxops = &zynq_pinmux_ops,
 	.confops = &zynq_pinconf_ops,
-	.num_dt_params = ARRAY_SIZE(zynq_dt_params),
-	.params = zynq_dt_params,
-	.conf_items = zynq_conf_items,
+	.num_custom_params = ARRAY_SIZE(zynq_dt_params),
+	.custom_params = zynq_dt_params,
+	.custom_conf_items = zynq_conf_items,
 	.owner = THIS_MODULE,
 };
 
diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
index 17f811c9c2c0..bbf99a715b63 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -131,7 +131,7 @@ struct pmic_gpio_state {
 	struct gpio_chip chip;
 };
 
-static const struct pinconf_generic_dt_params pmic_gpio_bindings[] = {
+static const struct pinconf_generic_params pmic_gpio_bindings[] = {
 	{"qcom,pull-up-strength",	PMIC_GPIO_CONF_PULL_UP,		0},
 	{"qcom,drive-strength",		PMIC_GPIO_CONF_STRENGTH,	0},
 };
@@ -742,9 +742,9 @@ static int pmic_gpio_probe(struct platform_device *pdev)
 	pctrldesc->name = dev_name(dev);
 	pctrldesc->pins = pindesc;
 	pctrldesc->npins = npins;
-	pctrldesc->num_dt_params = ARRAY_SIZE(pmic_gpio_bindings);
-	pctrldesc->params = pmic_gpio_bindings;
-	pctrldesc->conf_items = pmic_conf_items;
+	pctrldesc->num_custom_params = ARRAY_SIZE(pmic_gpio_bindings);
+	pctrldesc->custom_params = pmic_gpio_bindings;
+	pctrldesc->custom_conf_items = pmic_conf_items;
 
 	for (i = 0; i < npins; i++, pindesc++) {
 		pad = &pads[i];
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index 342409f7f3ec..fe65962b264f 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -162,7 +162,7 @@ static inline unsigned long pinconf_to_config_packed(enum pin_config_param param
 struct pinctrl_dev;
 struct pinctrl_map;
 
-struct pinconf_generic_dt_params {
+struct pinconf_generic_params {
 	const char * const property;
 	enum pin_config_param param;
 	u32 default_value;
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index c58b3e11ba8e..66e4697516de 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -118,9 +118,12 @@ struct pinctrl_ops {
  * @confops: pin config operations vtable, if you support pin configuration in
  *	your driver
  * @owner: module providing the pin controller, used for refcounting
- * @num_dt_params: Number of driver-specific DT parameters
- * @params: List of DT parameters
- * @conf_items: Information how to print @params in debugfs
+ * @num_custom_params: Number of driver-specific custom parameters to be parsed
+ *	from the hardware description
+ * @custom_params: List of driver_specific custom parameters to be parsed from
+ *	the hardware description
+ * @custom_conf_items: Information how to print @params in debugfs, must be
+ *	the same size as the @custom_params, i.e. @num_custom_params
  */
 struct pinctrl_desc {
 	const char *name;
@@ -130,10 +133,10 @@ struct pinctrl_desc {
 	const struct pinmux_ops *pmxops;
 	const struct pinconf_ops *confops;
 	struct module *owner;
-#if defined(CONFIG_GENERIC_PINCONF) && defined(CONFIG_OF)
-	unsigned int num_dt_params;
-	const struct pinconf_generic_dt_params *params;
-	const struct pin_config_item *conf_items;
+#ifdef CONFIG_GENERIC_PINCONF
+	unsigned int num_custom_params;
+	const struct pinconf_generic_params *custom_params;
+	const struct pin_config_item *custom_conf_items;
 #endif
 };
 
-- 
1.9.3

