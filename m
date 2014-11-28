Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaK1B1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:27:16 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:64341 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaK1B1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:27:10 -0500
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
Subject: [PATCH v2 2/7] pinctrl: pinconf-generic: Allow driver to specify DT params
Date: Thu, 27 Nov 2014 17:26:28 -0800
Message-Id: <1417137993-8337-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.3.1.ge241007
In-Reply-To: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additionally to the generic DT parameters, allow drivers to provide
driver-specific DT parameters to be used with the generic parser
infrastructure.

To achieve this 'struct pinctrl_desc' is extended to pass custom pinconf
option to the core. In order to pass this kind of information, the
related data structures - 'struct pinconf_generic_dt_params',
'pin_config_item' - are moved from pinconf internals to the
pinconf-generic header.

Additionally pinconfg-generic is refactored to not only iterate over the
generic pinconf parameters but also take the parameters into account
that are provided through the driver's 'struct pinctrl_desc'.
In particular 'pinconf_generic_parse_dt_config()' and
'pinconf_generic_dump' helpers are split into two parts each. In order
to have a more generic helper that can be used to process the generic
parameters as well as the driver-specific ones.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Tested-by: Andreas Färber <afaerber@suse.de>
---
v2:
 - fix typo
 - add missing documentation for @conf_items member in struct
 - rebase to pinctrl/devel: conflict in abx500
 - rename _pinconf_generic_dump() to pinconf_generic_dump_one()
 - removed '_' from _parse_dt_cfg()
 - removed BUG_ONs, error condition is handled in if statements
 - removed pinconf_generic_dump_group() & pinconf_generic_dump_pin
   helpers
   - fixed up corresponding call sites
   - renamed pinconf_generic_dump() to pinconf_generic_dump_pins()
   - added kernel-doc to pinconf_generic_dump_pins()
 - add kernel-doc
 - more verbose commit message
---
 drivers/pinctrl/nomadik/pinctrl-abx500.c |   2 +-
 drivers/pinctrl/pinconf-generic.c        | 182 +++++++++++++++++--------------
 drivers/pinctrl/pinconf.c                |   4 +-
 drivers/pinctrl/pinconf.h                |  22 ++--
 drivers/pinctrl/pinctrl-rockchip.c       |   2 +-
 drivers/pinctrl/pinctrl-tz1090-pdc.c     |   2 +-
 drivers/pinctrl/pinctrl-tz1090.c         |   2 +-
 drivers/pinctrl/sh-pfc/pinctrl.c         |   2 +-
 include/linux/pinctrl/pinconf-generic.h  |  18 +++
 include/linux/pinctrl/pinctrl.h          |   9 ++
 10 files changed, 141 insertions(+), 104 deletions(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index e1087c75e4f4..de68c1f8477b 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -914,7 +914,7 @@ static int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		}
 	}
 
-	ret = pinconf_generic_parse_dt_config(np, &configs, &nconfigs);
+	ret = pinconf_generic_parse_dt_config(np, pctldev, &configs, &nconfigs);
 	if (nconfigs) {
 		const char *gpio_name;
 		const char *pin;
diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 1e782a0d6e48..ac1dcf1925ba 100644
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
+static void pinconf_generic_dump_one(struct pinctrl_dev *pctldev,
+				     struct seq_file *s, const char *gname,
+				     unsigned pin,
+				     const struct pin_config_item *items,
+				     int nitems)
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
@@ -85,56 +77,46 @@ void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
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
+/**
+ * pinconf_generic_dump_pins - Print information about pin or group of pins
+ * @pctldev:	Pincontrol device
+ * @s:		File to print to
+ * @gname:	Group name specifying pins
+ * @pin:	Pin number specyfying pin
+ *
+ * Print the pinconf configuration for the requested pin(s) to @s. Pins can be
+ * specified either by pin using @pin or by group using @gname. Only one needs
+ * to be specified the other can be NULL/0.
+ */
+void pinconf_generic_dump_pins(struct pinctrl_dev *pctldev, struct seq_file *s,
+			       const char *gname, unsigned pin)
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
-	}
+	/* generic parameters */
+	pinconf_generic_dump_one(pctldev, s, gname, pin, conf_items,
+				 ARRAY_SIZE(conf_items));
+	/* driver-specific parameters */
+	if (pctldev->desc->num_dt_params && pctldev->desc->conf_items)
+		pinconf_generic_dump_one(pctldev, s, gname, pin,
+					 pctldev->desc->conf_items,
+					 pctldev->desc->num_dt_params);
 }
 
 void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
@@ -148,17 +130,21 @@ void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
 		seq_printf(s, "%s: 0x%x", conf_items[i].display,
 			   pinconf_to_config_argument(config));
 	}
+
+	if (!pctldev->desc->num_dt_params || !pctldev->desc->conf_items)
+		return;
+
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
@@ -184,6 +170,47 @@ static const struct pinconf_generic_dt_params dt_params[] = {
 };
 
 /**
+ * parse_dt_cfg - Parse DT pinconf parameters
+ * @np:	DT node
+ * @params:	Array of describing DT parameters
+ * @count:	Number of entries in @params
+ * @cfg:	Array of parsed config options
+ * @ncfg:	Number of entries in @cfg
+ *
+ * Parse the config options described in @params from @np and puts the result
+ * in @cfg. @cfg does not need to be empty, entries are added beggining at
+ * @ncfg. @ncfg is updated to reflect the number of entries after parsing. @cfg
+ * needs to have enough memory allocated to hold all possible entries.
+ */
+static void parse_dt_cfg(struct device_node *np,
+			 const struct pinconf_generic_dt_params *params,
+			 unsigned int count, unsigned long *cfg,
+			 unsigned int *ncfg)
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
+/**
  * pinconf_generic_parse_dt_config()
  * parse the config properties into generic pinconfig values.
  * @np: node containing the pinconfig properties
@@ -191,39 +218,29 @@ static const struct pinconf_generic_dt_params dt_params[] = {
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
-	}
+	parse_dt_cfg(np, dt_params, ARRAY_SIZE(dt_params), cfg, &ncfg);
+	if (pctldev && pctldev->desc->num_dt_params && pctldev->desc->params)
+		parse_dt_cfg(np, pctldev->desc->params,
+			      pctldev->desc->num_dt_params, cfg, &ncfg);
 
 	ret = 0;
 
@@ -274,7 +291,8 @@ int pinconf_generic_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		function = NULL;
 	}
 
-	ret = pinconf_generic_parse_dt_config(np, &configs, &num_configs);
+	ret = pinconf_generic_parse_dt_config(np, pctldev, &configs,
+					      &num_configs);
 	if (ret < 0) {
 		dev_err(dev, "could not parse node property\n");
 		return ret;
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 8bfa0643e5dc..1fc09dc20199 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -288,7 +288,7 @@ static void pinconf_dump_pin(struct pinctrl_dev *pctldev,
 	const struct pinconf_ops *ops = pctldev->desc->confops;
 
 	/* no-op when not using generic pin config */
-	pinconf_generic_dump_pin(pctldev, s, pin);
+	pinconf_generic_dump_pins(pctldev, s, NULL, pin);
 	if (ops && ops->pin_config_dbg_show)
 		ops->pin_config_dbg_show(pctldev, s, pin);
 }
@@ -333,7 +333,7 @@ static void pinconf_dump_group(struct pinctrl_dev *pctldev,
 	const struct pinconf_ops *ops = pctldev->desc->confops;
 
 	/* no-op when not using generic pin config */
-	pinconf_generic_dump_group(pctldev, s, gname);
+	pinconf_generic_dump_pins(pctldev, s, gname, 0);
 	if (ops && ops->pin_config_group_dbg_show)
 		ops->pin_config_group_dbg_show(pctldev, s, selector);
 }
diff --git a/drivers/pinctrl/pinconf.h b/drivers/pinctrl/pinconf.h
index a4a5417e1413..55c75780b3b2 100644
--- a/drivers/pinctrl/pinconf.h
+++ b/drivers/pinctrl/pinconf.h
@@ -92,26 +92,17 @@ static inline void pinconf_init_device_debugfs(struct dentry *devroot,
 
 #if defined(CONFIG_GENERIC_PINCONF) && defined(CONFIG_DEBUG_FS)
 
-void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
-			      struct seq_file *s, unsigned pin);
-
-void pinconf_generic_dump_group(struct pinctrl_dev *pctldev,
-			      struct seq_file *s, const char *gname);
+void pinconf_generic_dump_pins(struct pinctrl_dev *pctldev,
+			       struct seq_file *s, const char *gname,
+			       unsigned pin);
 
 void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
 				 struct seq_file *s, unsigned long config);
 #else
 
-static inline void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
-					    struct seq_file *s,
-					    unsigned pin)
-{
-	return;
-}
-
-static inline void pinconf_generic_dump_group(struct pinctrl_dev *pctldev,
-					      struct seq_file *s,
-					      const char *gname)
+static inline void pinconf_generic_dump_pins(struct pinctrl_dev *pctldev,
+					     struct seq_file *s,
+					     const char *gname, unsigned pin)
 {
 	return;
 }
@@ -126,6 +117,7 @@ static inline void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
 
 #if defined(CONFIG_GENERIC_PINCONF) && defined(CONFIG_OF)
 int pinconf_generic_parse_dt_config(struct device_node *np,
+				    struct pinctrl_dev *pctldev,
 				    unsigned long **configs,
 				    unsigned int *nconfigs);
 #endif
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 40970c305dd0..a72fe6faa392 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1140,7 +1140,7 @@ static int rockchip_pinctrl_parse_groups(struct device_node *np,
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
index cc8e1aff0e28..c58b3e11ba8e 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -24,6 +24,7 @@ struct pinctrl_dev;
 struct pinctrl_map;
 struct pinmux_ops;
 struct pinconf_ops;
+struct pin_config_item;
 struct gpio_chip;
 struct device_node;
 
@@ -117,6 +118,9 @@ struct pinctrl_ops {
  * @confops: pin config operations vtable, if you support pin configuration in
  *	your driver
  * @owner: module providing the pin controller, used for refcounting
+ * @num_dt_params: Number of driver-specific DT parameters
+ * @params: List of DT parameters
+ * @conf_items: Information how to print @params in debugfs
  */
 struct pinctrl_desc {
 	const char *name;
@@ -126,6 +130,11 @@ struct pinctrl_desc {
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
2.1.3.1.ge241007

