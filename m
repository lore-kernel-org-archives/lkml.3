Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaK1B1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:27:42 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36104 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaK1B1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:27:20 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH v2 7/7] pinctrl: qcom-spmi-gpio: Migrate to pinconf-generic
Date: Thu, 27 Nov 2014 17:26:33 -0800
Message-Id: <1417137993-8337-8-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.3.1.ge241007
In-Reply-To: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of the driver caring about implementation details like device
tree, just provide information about driver specific pinconf parameters
to pinconf-generic which takes care of parsing the DT.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
This is compile tested only. So, it's likely that it needs more tweaking
to make it actually work on HW. But it illustrates the potential
benefits of the pinconf-generic changes in this series.
---
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c | 125 +++----------------------------
 1 file changed, 11 insertions(+), 114 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
index b863b5080890..2db85e53ef73 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -131,14 +131,14 @@ struct pmic_gpio_state {
 	struct gpio_chip chip;
 };
 
-struct pmic_gpio_bindings {
-	const char	*property;
-	unsigned	param;
+static const struct pinconf_generic_dt_params pmic_gpio_bindings[] = {
+	{"qcom,pull-up-strength",	PMIC_GPIO_CONF_PULL_UP,		0},
+	{"qcom,drive-strength",		PMIC_GPIO_CONF_STRENGTH,	0},
 };
 
-static struct pmic_gpio_bindings pmic_gpio_bindings[] = {
-	{"qcom,pull-up-strength",	PMIC_GPIO_CONF_PULL_UP},
-	{"qcom,drive-strength",		PMIC_GPIO_CONF_STRENGTH},
+static const struct pin_config_item pmic_conf_items[] = {
+	PCONFDUMP(PMIC_GPIO_CONF_PULL_UP,  "pull-up-strength", NULL, true),
+	PCONFDUMP(PMIC_GPIO_CONF_STRENGTH, "drive-strength", NULL, true),
 };
 
 static const char *const pmic_gpio_groups[] = {
@@ -209,118 +209,11 @@ static int pmic_gpio_get_group_pins(struct pinctrl_dev *pctldev, unsigned pin,
 	return 0;
 }
 
-static int pmic_gpio_parse_dt_config(struct device_node *np,
-				     struct pinctrl_dev *pctldev,
-				     unsigned long **configs,
-				     unsigned int *nconfs)
-{
-	struct pmic_gpio_bindings *par;
-	unsigned long cfg;
-	int ret, i;
-	u32 val;
-
-	for (i = 0; i < ARRAY_SIZE(pmic_gpio_bindings); i++) {
-		par = &pmic_gpio_bindings[i];
-		ret = of_property_read_u32(np, par->property, &val);
-
-		/* property not found */
-		if (ret == -EINVAL)
-			continue;
-
-		/* use zero as default value */
-		if (ret)
-			val = 0;
-
-		dev_dbg(pctldev->dev, "found %s with value %u\n",
-			par->property, val);
-
-		cfg = pinconf_to_config_packed(par->param, val);
-
-		ret = pinctrl_utils_add_config(pctldev, configs, nconfs, cfg);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-static int pmic_gpio_dt_subnode_to_map(struct pinctrl_dev *pctldev,
-				       struct device_node *np,
-				       struct pinctrl_map **map,
-				       unsigned *reserv, unsigned *nmaps,
-				       enum pinctrl_map_type type)
-{
-	unsigned long *configs = NULL;
-	unsigned nconfs = 0;
-	struct property *prop;
-	const char *group;
-	int ret;
-
-	ret = pmic_gpio_parse_dt_config(np, pctldev, &configs, &nconfs);
-	if (ret < 0)
-		return ret;
-
-	if (!nconfs)
-		return 0;
-
-	ret = of_property_count_strings(np, "pins");
-	if (ret < 0)
-		goto exit;
-
-	ret = pinctrl_utils_reserve_map(pctldev, map, reserv, nmaps, ret);
-	if (ret < 0)
-		goto exit;
-
-	of_property_for_each_string(np, "pins", prop, group) {
-		ret = pinctrl_utils_add_map_configs(pctldev, map,
-						    reserv, nmaps, group,
-						    configs, nconfs, type);
-		if (ret < 0)
-			break;
-	}
-exit:
-	kfree(configs);
-	return ret;
-}
-
-static int pmic_gpio_dt_node_to_map(struct pinctrl_dev *pctldev,
-				    struct device_node *np_config,
-				    struct pinctrl_map **map, unsigned *nmaps)
-{
-	enum pinctrl_map_type type;
-	struct device_node *np;
-	unsigned reserv;
-	int ret;
-
-	ret = 0;
-	*map = NULL;
-	*nmaps = 0;
-	reserv = 0;
-	type = PIN_MAP_TYPE_CONFIGS_GROUP;
-
-	for_each_child_of_node(np_config, np) {
-		ret = pinconf_generic_dt_subnode_to_map(pctldev, np, map,
-							&reserv, nmaps, type);
-		if (ret)
-			break;
-
-		ret = pmic_gpio_dt_subnode_to_map(pctldev, np, map, &reserv,
-						  nmaps, type);
-		if (ret)
-			break;
-	}
-
-	if (ret < 0)
-		pinctrl_utils_dt_free_map(pctldev, *map, *nmaps);
-
-	return ret;
-}
-
 static const struct pinctrl_ops pmic_gpio_pinctrl_ops = {
 	.get_groups_count	= pmic_gpio_get_groups_count,
 	.get_group_name		= pmic_gpio_get_group_name,
 	.get_group_pins		= pmic_gpio_get_group_pins,
-	.dt_node_to_map		= pmic_gpio_dt_node_to_map,
+	.dt_node_to_map		= pinconf_generic_dt_node_to_map_group,
 	.dt_free_map		= pinctrl_utils_dt_free_map,
 };
 
@@ -590,6 +483,7 @@ static void pmic_gpio_config_dbg_show(struct pinctrl_dev *pctldev,
 }
 
 static const struct pinconf_ops pmic_gpio_pinconf_ops = {
+	.is_generic			= true,
 	.pin_config_group_get		= pmic_gpio_config_get,
 	.pin_config_group_set		= pmic_gpio_config_set,
 	.pin_config_group_dbg_show	= pmic_gpio_config_dbg_show,
@@ -848,6 +742,9 @@ static int pmic_gpio_probe(struct platform_device *pdev)
 	pctrldesc->name = dev_name(dev);
 	pctrldesc->pins = pindesc;
 	pctrldesc->npins = npins;
+	pctrldesc->num_dt_params = ARRAY_SIZE(pmic_gpio_bindings);
+	pctrldesc->params = pmic_gpio_bindings;
+	pctrldesc->conf_items = pmic_conf_items;
 
 	for (i = 0; i < npins; i++, pindesc++) {
 		pad = &pads[i];
-- 
2.1.3.1.ge241007

