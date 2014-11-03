Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaKCTHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:07:44 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:50974 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaKCTGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:06:06 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org
Subject: [PATCH 3/7] pinctrl: pinconf-generic: Allow driver to specify DT params
Date: Mon,  3 Nov 2014 11:05:27 -0800
Message-Id: <1415041531-15520-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additionally to the generic DT parameters, allow drivers to provide
driver-specific DT parameters to be used with the generic parser
infrastructure.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/pinctrl/nomadik/pinctrl-abx500.c |   6 +-
 drivers/pinctrl/pinconf-generic.c        | 171 ++++++++++++++++---------------
 drivers/pinctrl/pinconf.h                |   1 +
 drivers/pinctrl/pinctrl-rockchip.c       |   2 +-
 drivers/pinctrl/pinctrl-tz1090-pdc.c     |   2 +-
 drivers/pinctrl/pinctrl-tz1090.c         |   2 +-
 drivers/pinctrl/sh-pfc/pinctrl.c         |   2 +-
 include/linux/pinctrl/pinconf-generic.h  |  18 ++++
 include/linux/pinctrl/pinctrl.h          |   8 ++
 9 files changed, 125 insertions(+), 87 deletions(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index 228972827132..f0fe6555a557 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -915,13 +915,13 @@ static int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		}
 	}
 
-	ret = pinconf_generic_parse_dt_config(np, &configs, &nconfigs);
+	ret = pinconf_generic_parse_dt_config(np, pctldev, &configs, &nconfigs);
 	if (nconfigs)
 		has_config = 1;
 	np_config = of_parse_phandle(np, "ste,config", 0);
 	if (np_config) {
-		ret = pinconf_generic_parse_dt_config(np_config, &configs,
-				&nconfigs);
+		ret = pinconf_generic_parse_dt_config(np_config, pctldev,
+				&configs, &nconfigs);
 		if (ret)
 			goto exit;
 		has_config |= nconfigs;
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 1e782a0d6e48..23b5359a8c39 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -27,17 +27,6 @@
 #include "pinctrl-utils.h"
 
 #ifdef CONFIG_DEBUG_FS
-
-struct pin_config_item {
-	const enum pin_config_param param;
-	const char * const display;
-	const char * const format;
-	bool has_arg;
-};
-
-#define PCONFDUMP(a, b, c, d) { .param = a, .display = b, .format = c, \
-				.has_arg = d }
-
 static const struct pin_config_item conf_items[] = {
 	PCONFDUMP(PIN_CONFIG_BIAS_DISABLE, "input bias disabled", NULL, false),
 	PCONFDUMP(PIN_CONFIG_BIAS_HIGH_IMPEDANCE, "input bias high impedance", NULL, false),
@@ -60,22 +49,25 @@ static const struct pin_config_item conf_items[] = {
 	PCONFDUMP(PIN_CONFIG_OUTPUT, "pin output", "level", true),
 };
 
-void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
-			      struct seq_file *s, unsigned pin)
+static void _pinconf_generic_dump(struct pinctrl_dev *pctldev,
+				  struct seq_file *s, const char *gname,
+				  unsigned pin,
+				  const struct pin_config_item *items,
+				  int nitems)
 {
-	const struct pinconf_ops *ops = pctldev->desc->confops;
 	int i;
 
-	if (!ops->is_generic)
-		return;
-
-	for (i = 0; i < ARRAY_SIZE(conf_items); i++) {
+	for (i = 0; i < nitems; i++) {
 		unsigned long config;
 		int ret;
 
 		/* We want to check out this parameter */
-		config = pinconf_to_config_packed(conf_items[i].param, 0);
-		ret = pin_config_get_for_pin(pctldev, pin, &config);
+		config = pinconf_to_config_packed(items[i].param, 0);
+		if (gname)
+			ret = pin_config_group_get(dev_name(pctldev->dev),
+						   gname, &config);
+		else
+			ret = pin_config_get_for_pin(pctldev, pin, &config);
 		/* These are legal errors */
 		if (ret == -EINVAL || ret == -ENOTSUPP)
 			continue;
@@ -85,58 +77,50 @@ void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
 		}
 		/* Space between multiple configs */
 		seq_puts(s, " ");
-		seq_puts(s, conf_items[i].display);
+		seq_puts(s, items[i].display);
 		/* Print unit if available */
-		if (conf_items[i].has_arg) {
+		if (items[i].has_arg) {
 			seq_printf(s, " (%u",
 				   pinconf_to_config_argument(config));
-			if (conf_items[i].format)
-				seq_printf(s, " %s)", conf_items[i].format);
+			if (items[i].format)
+				seq_printf(s, " %s)", items[i].format);
 			else
 				seq_puts(s, ")");
 		}
 	}
 }
 
-void pinconf_generic_dump_group(struct pinctrl_dev *pctldev,
-			      struct seq_file *s, const char *gname)
+static void pinconf_generic_dump(struct pinctrl_dev *pctldev,
+				 struct seq_file *s, const char *gname,
+				 unsigned pin)
 {
 	const struct pinconf_ops *ops = pctldev->desc->confops;
-	int i;
 
 	if (!ops->is_generic)
 		return;
 
-	for (i = 0; i < ARRAY_SIZE(conf_items); i++) {
-		unsigned long config;
-		int ret;
-
-		/* We want to check out this parameter */
-		config = pinconf_to_config_packed(conf_items[i].param, 0);
-		ret = pin_config_group_get(dev_name(pctldev->dev), gname,
-					   &config);
-		/* These are legal errors */
-		if (ret == -EINVAL || ret == -ENOTSUPP)
-			continue;
-		if (ret) {
-			seq_printf(s, "ERROR READING CONFIG SETTING %d ", i);
-			continue;
-		}
-		/* Space between multiple configs */
-		seq_puts(s, " ");
-		seq_puts(s, conf_items[i].display);
-		/* Print unit if available */
-		if (conf_items[i].has_arg) {
-			seq_printf(s, " (%u",
-				   pinconf_to_config_argument(config));
-			if (conf_items[i].format)
-				seq_printf(s, " %s)", conf_items[i].format);
-			else
-				seq_puts(s, ")");
-		}
+	_pinconf_generic_dump(pctldev, s, gname, pin,
+			      conf_items, ARRAY_SIZE(conf_items));
+	if (pctldev->desc->num_dt_params) {
+		BUG_ON(!pctldev->desc->conf_items);
+		_pinconf_generic_dump(pctldev, s, gname, pin,
+				      pctldev->desc->conf_items,
+				      pctldev->desc->num_dt_params);
 	}
 }
 
+void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
+			      struct seq_file *s, unsigned pin)
+{
+	pinconf_generic_dump(pctldev, s, NULL, pin);
+}
+
+void pinconf_generic_dump_group(struct pinctrl_dev *pctldev,
+			      struct seq_file *s, const char *gname)
+{
+	pinconf_generic_dump(pctldev, s, gname, 0);
+}
+
 void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
 				 struct seq_file *s, unsigned long config)
 {
@@ -148,17 +132,22 @@ void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
 		seq_printf(s, "%s: 0x%x", conf_items[i].display,
 			   pinconf_to_config_argument(config));
 	}
+
+	if (!pctldev->desc->num_dt_params)
+		return;
+
+	BUG_ON(!pctldev->desc->conf_items);
+	for (i = 0; i < pctldev->desc->num_dt_params; i++) {
+		if (pinconf_to_config_param(config) != pctldev->desc->conf_items[i].param)
+			continue;
+		seq_printf(s, "%s: 0x%x", pctldev->desc->conf_items[i].display,
+			   pinconf_to_config_argument(config));
+	}
 }
 EXPORT_SYMBOL_GPL(pinconf_generic_dump_config);
 #endif
 
 #ifdef CONFIG_OF
-struct pinconf_generic_dt_params {
-	const char * const property;
-	enum pin_config_param param;
-	u32 default_value;
-};
-
 static const struct pinconf_generic_dt_params dt_params[] = {
 	{ "bias-disable", PIN_CONFIG_BIAS_DISABLE, 0 },
 	{ "bias-high-impedance", PIN_CONFIG_BIAS_HIGH_IMPEDANCE, 0 },
@@ -183,6 +172,35 @@ static const struct pinconf_generic_dt_params dt_params[] = {
 	{ "slew-rate", PIN_CONFIG_SLEW_RATE, 0},
 };
 
+static void _parse_dt_cfg(struct device_node *np,
+			  const struct pinconf_generic_dt_params *params,
+			  unsigned int count,
+			  unsigned long *cfg,
+			  unsigned int *ncfg)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		u32 val;
+		int ret;
+		const struct pinconf_generic_dt_params *par = &params[i];
+
+		ret = of_property_read_u32(np, par->property, &val);
+
+		/* property not found */
+		if (ret == -EINVAL)
+			continue;
+
+		/* use default value, when no value is specified */
+		if (ret)
+			val = par->default_value;
+
+		pr_debug("found %s with value %u\n", par->property, val);
+		cfg[*ncfg] = pinconf_to_config_packed(par->param, val);
+		(*ncfg)++;
+	}
+}
+
 /**
  * pinconf_generic_parse_dt_config()
  * parse the config properties into generic pinconfig values.
@@ -191,38 +209,30 @@ static const struct pinconf_generic_dt_params dt_params[] = {
  * @nconfigs: umber of configurations
  */
 int pinconf_generic_parse_dt_config(struct device_node *np,
+				    struct pinctrl_dev *pctldev,
 				    unsigned long **configs,
 				    unsigned int *nconfigs)
 {
 	unsigned long *cfg;
-	unsigned int ncfg = 0;
+	unsigned int max_cfg, ncfg = 0;
 	int ret;
-	int i;
-	u32 val;
 
 	if (!np)
 		return -EINVAL;
 
 	/* allocate a temporary array big enough to hold one of each option */
-	cfg = kzalloc(sizeof(*cfg) * ARRAY_SIZE(dt_params), GFP_KERNEL);
+	max_cfg = ARRAY_SIZE(dt_params);
+	if (pctldev)
+		max_cfg += pctldev->desc->num_dt_params;
+	cfg = kcalloc(max_cfg, sizeof(*cfg), GFP_KERNEL);
 	if (!cfg)
 		return -ENOMEM;
 
-	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
-		const struct pinconf_generic_dt_params *par = &dt_params[i];
-		ret = of_property_read_u32(np, par->property, &val);
-
-		/* property not found */
-		if (ret == -EINVAL)
-			continue;
-
-		/* use default value, when no value is specified */
-		if (ret)
-			val = par->default_value;
-
-		pr_debug("found %s with value %u\n", par->property, val);
-		cfg[ncfg] = pinconf_to_config_packed(par->param, val);
-		ncfg++;
+	_parse_dt_cfg(np, dt_params, ARRAY_SIZE(dt_params), cfg, &ncfg);
+	if (pctldev && pctldev->desc->num_dt_params) {
+		BUG_ON(!pctldev->desc->params);
+		_parse_dt_cfg(np, pctldev->desc->params,
+			      pctldev->desc->num_dt_params, cfg, &ncfg);
 	}
 
 	ret = 0;
@@ -274,7 +284,8 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		function = NULL;
 	}
 
-	ret = pinconf_generic_parse_dt_config(np, &configs, &num_configs);
+	ret = pinconf_generic_parse_dt_config(np, pctldev, &configs,
+					      &num_configs);
 	if (ret < 0) {
 		dev_err(dev, "could not parse node property\n");
 		return ret;
diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
index a4a5417e1413..6a6c55864672 100644
--- a/drivers/pinctrl/pinconf.h
+++ b/drivers/pinctrl/pinconf.h
@@ -126,6 +126,7 @@ static inline void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
 
 #if defined(CONFIG_GENERIC_PINCONF) && defined(CONFIG_OF)
 int pinconf_generic_parse_dt_config(struct device_node *np,
+				    struct pinctrl_dev *pctldev,
 				    unsigned long **configs,
 				    unsigned int *nconfigs);
 #endif
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 016f4578e494..0e05febe80ba 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1126,7 +1126,7 @@ static int rockchip_pinctrl_parse_groups(struct device_node *np,
 			return -EINVAL;
 
 		np_config = of_find_node_by_phandle(be32_to_cpup(phandle));
-		ret = pinconf_generic_parse_dt_config(np_config,
+		ret = pinconf_generic_parse_dt_config(np_config, NULL,
 				&grp->data[j].configs, &grp->data[j].nconfigs);
 		if (ret)
 			return ret;
diff --git a/drivers/pinctrl/pinctrl-tz1090-pdc.c b/drivers/pinctrl/pinctrl-tz1090-pdc.c
index 3bb6a3b78864..0e3576ba1a7c 100644
--- a/drivers/pinctrl/pinctrl-tz1090-pdc.c
+++ b/drivers/pinctrl/pinctrl-tz1090-pdc.c
@@ -415,7 +415,7 @@ static int tz1090_pdc_pinctrl_dt_subnode_to_map(struct device *dev,
 		function = NULL;
 	}
 
-	ret = pinconf_generic_parse_dt_config(np, &configs, &num_configs);
+	ret = pinconf_generic_parse_dt_config(np, NULL, &configs, &num_configs);
 	if (ret)
 		return ret;
 
diff --git a/drivers/pinctrl/pinctrl-tz1090.c b/drivers/pinctrl/pinctrl-tz1090.c
index 48d36413b99f..0b36566db451 100644
--- a/drivers/pinctrl/pinctrl-tz1090.c
+++ b/drivers/pinctrl/pinctrl-tz1090.c
@@ -1131,7 +1131,7 @@ static int tz1090_pinctrl_dt_subnode_to_map(struct device *dev,
 		function = NULL;
 	}
 
-	ret = pinconf_generic_parse_dt_config(np, &configs, &num_configs);
+	ret = pinconf_generic_parse_dt_config(np, NULL, &configs, &num_configs);
 	if (ret)
 		return ret;
 
diff --git a/drivers/pinctrl/sh-pfc/pinctrl.c b/drivers/pinctrl/sh-pfc/pinctrl.c
index 910deaefa0ac..072e7c62cab7 100644
--- a/drivers/pinctrl/sh-pfc/pinctrl.c
+++ b/drivers/pinctrl/sh-pfc/pinctrl.c
@@ -122,7 +122,7 @@ static int sh_pfc_dt_subnode_to_map(struct device *dev, struct device_node *np,
 		return ret;
 	}
 
-	ret = pinconf_generic_parse_dt_config(np, &configs, &num_configs);
+	ret = pinconf_generic_parse_dt_config(np, NULL, &configs, &num_configs);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
index b6dedfbfce69..5731703b27c2 100644
--- a/include/linux/pinctrl/pinconf-generic.h
+++ b/include/linux/pinctrl/pinconf-generic.h
@@ -115,6 +115,18 @@ enum pin_config_param {
 	PIN_CONFIG_END = 0x7FFF,
 };
 
+#ifdef CONFIG_DEBUG_FS
+#define PCONFDUMP(a, b, c, d) { .param = a, .display = b, .format = c, \
+				.has_arg = d }
+
+struct pin_config_item {
+	const enum pin_config_param param;
+	const char * const display;
+	const char * const format;
+	bool has_arg;
+};
+#endif /* CONFIG_DEBUG_FS */
+
 /*
  * Helpful configuration macro to be used in tables etc.
  */
@@ -150,6 +162,12 @@ static inline unsigned long pinconf_to_config_packed(enum pin_config_param param
 struct pinctrl_dev;
 struct pinctrl_map;
 
+struct pinconf_generic_dt_params {
+	const char * const property;
+	enum pin_config_param param;
+	u32 default_value;
+};
+
 int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		struct device_node *np, struct pinctrl_map **map,
 		unsigned *reserved_maps, unsigned *num_maps,
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index cc8e1aff0e28..36f749775342 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -24,6 +24,7 @@ struct pinctrl_dev;
 struct pinctrl_map;
 struct pinmux_ops;
 struct pinconf_ops;
+struct pin_config_item;
 struct gpio_chip;
 struct device_node;
 
@@ -117,6 +118,8 @@ struct pinctrl_ops {
  * @confops: pin config operations vtable, if you support pin configuration in
  *	your driver
  * @owner: module providing the pin controller, used for refcounting
+ * @num_dt_params: Number of driver-specifid DT parameters
+ * @params: List of DT parameters
  */
 struct pinctrl_desc {
 	const char *name;
@@ -126,6 +129,11 @@ struct pinctrl_desc {
 	const struct pinmux_ops *pmxops;
 	const struct pinconf_ops *confops;
 	struct module *owner;
+#if defined(CONFIG_GENERIC_PINCONF) && defined(CONFIG_OF)
+	unsigned int num_dt_params;
+	const struct pinconf_generic_dt_params *params;
+	const struct pin_config_item *conf_items;
+#endif
 };
 
 /* External interface to pin controller */
-- 
1.9.1

