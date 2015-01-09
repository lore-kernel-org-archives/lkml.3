Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbbAIPoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:44:32 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36719 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163AbbAIPo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:44:26 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org
Subject: [PATCH v4 7/7] pinctrl: qcom-spmi-gpio: Migrate to pinconf-generic
Date: Fri,  9 Jan 2015 07:43:51 -0800
Message-Id: <1420818231-13451-8-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.2.1.1.gb42cc81
In-Reply-To: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of the driver caring about implementation details like device
tree, just provide information about driver specific pinconf parameters
to pinconf-generic which takes care of parsing the DT.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Changes since v2:
 - remove hyphens in 'pull-up-strength' debugfs representation.
 - driver-specific DT properties are passed to the core in two arrays,
   one for the actual DT parsing one for the debugfs representation.
   Issue a compiler warning when the number of entries is not the same
   for both arrays.

This is compile tested only. So, it's likely that it needs more tweaking
to make it actually work on HW. But it illustrates the potential
benefits of the pinconf-generic changes in this series.
---
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c | 125 +++----------------------------
 1 file changed, 11 insertions(+), 114 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
index b863b5080890..17f811c9c2c0 100644
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
+static const struct pin_config_item pmic_conf_items[ARRAY_SIZE(pmic_gpio_bindings)] = {
+	PCONFDUMP(PMIC_GPIO_CONF_PULL_UP,  "pull up strength", NULL, true),
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
2.2.1.1.gb42cc81

