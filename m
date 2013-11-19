Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab3KSRLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:11:13 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56495 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3KSRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:11:09 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-f7-528b9baa71b7
From: Tomasz Figa <t.figa@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Doug Anderson <dianders@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH] pinctrl: samsung: Allow grouping multiple pinmux/pinconf nodes
Date: Tue, 19 Nov 2013 18:10:34 +0100
Message-id: <1384881034-10520-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.8.4.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e/4Nd1Vs7uDDH4e07CYf+Qcq8XZZQfZ
	LP4/es1q0bvgKpvF2aY37BZT/ixnstj0+BqrxeVdc9gsZpzfx2Sx9shddotXB9tYLNbPeM1i
	cWzGEkYHXo/ZDRdZPO5c28PmsXlJvUffllWMHtuvzWP2+LxJzmPj3NAA9igum5TUnMyy1CJ9
	uwSujF2PljIVLDzHWLFy/lWmBsYfixm7GDk4JARMJH4f8O1i5AQyxSQu3FvP1sXIxSEksJRR
	4uXiZVBOH5PEn6a17CBVbAJqEp8bHrGB2CICGhJTuh6zgxQxCzxhlli74RUzSEJYwF/i54cT
	YDaLgKrEmUN/wJp5BZwk/r+ZzQKxTkFi86RLzBMYuRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L
	10vOz93ECAm7LzsYFx+zOsQowMGoxMM7wb0rSIg1say4MvcQowQHs5IIb019d5AQb0piZVVq
	UX58UWlOavEhRiYOTqkGRqfFrHOLPmx8skrsYv123zV7bi3R+K0ltH6jNbNPIuPCJ+pcnzyu
	eaa9Pz4jXOT6neK3kvmOE1/weTx9V1DEIV537N5hzvvJuVrz1UwtV010MTIVeyHn2Lnwz5WV
	Oz7x3PzyueYD8wf3VIOzkRn7eJsPx67X8RTV43m1rEX4n08h70WPrZMbZiixFGckGmoxFxUn
	AgA3MLeJGQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of remaining limitations of current pinctrl-samsung driver was
the inability to parse multiple pinmux/pinconf group nodes grouped
inside a single device tree node. It made defining groups of pins for
single purpose, but with different parameters very inconvenient.

This patch implements Tegra-like support for grouping multiple pinctrl
groups inside one device tree node, by completely changing the way
pin groups and functions are parsed from device tree. The code creating
pinctrl maps from DT nodes has been borrowed from pinctrl-tegra, while
the initial creation of groups and functions has been completely
rewritten with following assumptions:
 - each group consists of just one pin and does not depend on data
   from device tree,
 - each function is represented by a device tree child node of the
   pin controller, which in turn can contain multiple child nodes
   for pins that need to have different configuration values.

Device Tree bindings are fully backwards compatible. New functionality
can be used by defining a new pinctrl group consisting of several child
nodes, as on following example:

	sd4_bus8: sd4-bus-width8 {
		part-1 {
			samsung,pins = "gpk0-3", "gpk0-4",
					"gpk0-5", "gpk0-6";
			samsung,pin-function = <3>;
			samsung,pin-pud = <3>;
			samsung,pin-drv = <3>;
		};
		part-2 {
			samsung,pins = "gpk1-3", "gpk1-4",
					"gpk1-5", "gpk1-6";
			samsung,pin-function = <4>;
			samsung,pin-pud = <4>;
			samsung,pin-drv = <3>;
		};
	};

Tested on Exynos4210-Trats board and a custom Exynos4212-based one.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../bindings/pinctrl/samsung-pinctrl.txt           |  23 +-
 drivers/pinctrl/pinctrl-samsung.c                  | 619 ++++++++++++---------
 drivers/pinctrl/pinctrl-samsung.h                  |   1 +
 3 files changed, 392 insertions(+), 251 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
index 257677d..fe34cbb 100644
--- a/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
@@ -43,7 +43,11 @@ Required Properties:
 - Pin mux/config groups as child nodes: The pin mux (selecting pin function
   mode) and pin config (pull up/down, driver strength) settings are represented
   as child nodes of the pin-controller node. There should be atleast one
-  child node and there is no limit on the count of these child nodes.
+  child node and there is no limit on the count of these child nodes. It is
+  also possible for a child node to consist of several further child nodes
+  to allow grouping multiple pinctrl groups into one. The format of second
+  level child nodes is exactly the same as for first level ones and is
+  described below.
 
   The child node should contain a list of pin(s) on which a particular pin
   function selection or pin configuration (or both) have to applied. This
@@ -248,6 +252,23 @@ Example 1: A pin-controller node with pin groups.
 			samsung,pin-pud = <3>;
 			samsung,pin-drv = <0>;
 		};
+
+		sd4_bus8: sd4-bus-width8 {
+			part-1 {
+				samsung,pins = "gpk0-3", "gpk0-4",
+						"gpk0-5", "gpk0-6";
+				samsung,pin-function = <3>;
+				samsung,pin-pud = <3>;
+				samsung,pin-drv = <3>;
+			};
+			part-2 {
+				samsung,pins = "gpk1-3", "gpk1-4",
+						"gpk1-5", "gpk1-6";
+				samsung,pin-function = <4>;
+				samsung,pin-pud = <4>;
+				samsung,pin-drv = <3>;
+			};
+		};
 	};
 
 Example 2: A pin-controller node with external wakeup interrupt controller node.
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 47ec2e8..c752de4 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -40,9 +40,9 @@
 
 /* list of all possible config options supported */
 static struct pin_config {
-	char		*prop_cfg;
-	unsigned int	cfg_type;
-} pcfgs[] = {
+	const char *property;
+	enum pincfg_type param;
+} cfg_params[] = {
 	{ "samsung,pin-pud", PINCFG_TYPE_PUD },
 	{ "samsung,pin-drv", PINCFG_TYPE_DRV },
 	{ "samsung,pin-con-pdn", PINCFG_TYPE_CON_PDN },
@@ -59,163 +59,242 @@ static inline struct samsung_pin_bank *gc_to_pin_bank(struct gpio_chip *gc)
 	return container_of(gc, struct samsung_pin_bank, gpio_chip);
 }
 
-/* check if the selector is a valid pin group selector */
 static int samsung_get_group_count(struct pinctrl_dev *pctldev)
 {
-	struct samsung_pinctrl_drv_data *drvdata;
+	struct samsung_pinctrl_drv_data *pmx = pinctrl_dev_get_drvdata(pctldev);
 
-	drvdata = pinctrl_dev_get_drvdata(pctldev);
-	return drvdata->nr_groups;
+	return pmx->nr_groups;
 }
 
-/* return the name of the group selected by the group selector */
 static const char *samsung_get_group_name(struct pinctrl_dev *pctldev,
-						unsigned selector)
+						unsigned group)
 {
-	struct samsung_pinctrl_drv_data *drvdata;
+	struct samsung_pinctrl_drv_data *pmx = pinctrl_dev_get_drvdata(pctldev);
 
-	drvdata = pinctrl_dev_get_drvdata(pctldev);
-	return drvdata->pin_groups[selector].name;
+	return pmx->pin_groups[group].name;
 }
 
-/* return the pin numbers associated with the specified group */
 static int samsung_get_group_pins(struct pinctrl_dev *pctldev,
-		unsigned selector, const unsigned **pins, unsigned *num_pins)
+					unsigned group,
+					const unsigned **pins,
+					unsigned *num_pins)
 {
-	struct samsung_pinctrl_drv_data *drvdata;
+	struct samsung_pinctrl_drv_data *pmx = pinctrl_dev_get_drvdata(pctldev);
+
+	*pins = pmx->pin_groups[group].pins;
+	*num_pins = pmx->pin_groups[group].num_pins;
 
-	drvdata = pinctrl_dev_get_drvdata(pctldev);
-	*pins = drvdata->pin_groups[selector].pins;
-	*num_pins = drvdata->pin_groups[selector].num_pins;
 	return 0;
 }
 
-/* create pinctrl_map entries by parsing device tree nodes */
-static int samsung_dt_node_to_map(struct pinctrl_dev *pctldev,
-			struct device_node *np, struct pinctrl_map **maps,
-			unsigned *nmaps)
+static int reserve_map(struct device *dev, struct pinctrl_map **map,
+		       unsigned *reserved_maps, unsigned *num_maps,
+		       unsigned reserve)
 {
-	struct device *dev = pctldev->dev;
-	struct pinctrl_map *map;
-	unsigned long *cfg = NULL;
-	char *gname, *fname;
-	int cfg_cnt = 0, map_cnt = 0, idx = 0;
-
-	/* count the number of config options specfied in the node */
-	for (idx = 0; idx < ARRAY_SIZE(pcfgs); idx++) {
-		if (of_find_property(np, pcfgs[idx].prop_cfg, NULL))
-			cfg_cnt++;
-	}
+	unsigned old_num = *reserved_maps;
+	unsigned new_num = *num_maps + reserve;
+	struct pinctrl_map *new_map;
 
-	/*
-	 * Find out the number of map entries to create. All the config options
-	 * can be accomadated into a single config map entry.
-	 */
-	if (cfg_cnt)
-		map_cnt = 1;
-	if (of_find_property(np, "samsung,pin-function", NULL))
-		map_cnt++;
-	if (!map_cnt) {
-		dev_err(dev, "node %s does not have either config or function "
-				"configurations\n", np->name);
-		return -EINVAL;
-	}
+	if (old_num >= new_num)
+		return 0;
 
-	/* Allocate memory for pin-map entries */
-	map = kzalloc(sizeof(*map) * map_cnt, GFP_KERNEL);
-	if (!map) {
-		dev_err(dev, "could not alloc memory for pin-maps\n");
+	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
+	if (!new_map) {
+		dev_err(dev, "krealloc(map) failed\n");
 		return -ENOMEM;
 	}
-	*nmaps = 0;
 
-	/*
-	 * Allocate memory for pin group name. The pin group name is derived
-	 * from the node name from which these map entries are be created.
-	 */
-	gname = kzalloc(strlen(np->name) + GSUFFIX_LEN, GFP_KERNEL);
-	if (!gname) {
-		dev_err(dev, "failed to alloc memory for group name\n");
-		goto free_map;
+	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
+
+	*map = new_map;
+	*reserved_maps = new_num;
+
+	return 0;
+}
+
+static int add_map_mux(struct pinctrl_map **map, unsigned *reserved_maps,
+		       unsigned *num_maps, const char *group,
+		       const char *function)
+{
+	if (WARN_ON(*num_maps == *reserved_maps))
+		return -ENOSPC;
+
+	(*map)[*num_maps].type = PIN_MAP_TYPE_MUX_GROUP;
+	(*map)[*num_maps].data.mux.group = group;
+	(*map)[*num_maps].data.mux.function = function;
+	(*num_maps)++;
+
+	return 0;
+}
+
+static int add_map_configs(struct device *dev, struct pinctrl_map **map,
+			   unsigned *reserved_maps, unsigned *num_maps,
+			   const char *group, unsigned long *configs,
+			   unsigned num_configs)
+{
+	unsigned long *dup_configs;
+
+	if (WARN_ON(*num_maps == *reserved_maps))
+		return -ENOSPC;
+
+	dup_configs = kmemdup(configs, num_configs * sizeof(*dup_configs),
+			      GFP_KERNEL);
+	if (!dup_configs) {
+		dev_err(dev, "kmemdup(configs) failed\n");
+		return -ENOMEM;
 	}
-	sprintf(gname, "%s%s", np->name, GROUP_SUFFIX);
 
-	/*
-	 * don't have config options? then skip over to creating function
-	 * map entries.
-	 */
-	if (!cfg_cnt)
-		goto skip_cfgs;
-
-	/* Allocate memory for config entries */
-	cfg = kzalloc(sizeof(*cfg) * cfg_cnt, GFP_KERNEL);
-	if (!cfg) {
-		dev_err(dev, "failed to alloc memory for configs\n");
-		goto free_gname;
+	(*map)[*num_maps].type = PIN_MAP_TYPE_CONFIGS_GROUP;
+	(*map)[*num_maps].data.configs.group_or_pin = group;
+	(*map)[*num_maps].data.configs.configs = dup_configs;
+	(*map)[*num_maps].data.configs.num_configs = num_configs;
+	(*num_maps)++;
+
+	return 0;
+}
+
+static int add_config(struct device *dev, unsigned long **configs,
+		      unsigned *num_configs, unsigned long config)
+{
+	unsigned old_num = *num_configs;
+	unsigned new_num = old_num + 1;
+	unsigned long *new_configs;
+
+	new_configs = krealloc(*configs, sizeof(*new_configs) * new_num,
+			       GFP_KERNEL);
+	if (!new_configs) {
+		dev_err(dev, "krealloc(configs) failed\n");
+		return -ENOMEM;
 	}
 
-	/* Prepare a list of config settings */
-	for (idx = 0, cfg_cnt = 0; idx < ARRAY_SIZE(pcfgs); idx++) {
-		u32 value;
-		if (!of_property_read_u32(np, pcfgs[idx].prop_cfg, &value))
-			cfg[cfg_cnt++] =
-				PINCFG_PACK(pcfgs[idx].cfg_type, value);
+	new_configs[old_num] = config;
+
+	*configs = new_configs;
+	*num_configs = new_num;
+
+	return 0;
+}
+
+static void samsung_dt_free_map(struct pinctrl_dev *pctldev,
+				      struct pinctrl_map *map,
+				      unsigned num_maps)
+{
+	int i;
+
+	for (i = 0; i < num_maps; i++)
+		if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
+			kfree(map[i].data.configs.configs);
+
+	kfree(map);
+}
+
+static int samsung_dt_subnode_to_map(struct samsung_pinctrl_drv_data *drvdata,
+				     struct device *dev,
+				     struct device_node *np,
+				     struct pinctrl_map **map,
+				     unsigned *reserved_maps,
+				     unsigned *num_maps)
+{
+	int ret, i;
+	u32 val;
+	unsigned long config;
+	unsigned long *configs = NULL;
+	unsigned num_configs = 0;
+	unsigned reserve;
+	struct property *prop;
+	const char *group;
+	bool has_func = false;
+
+	ret = of_property_read_u32(np, "samsung,pin-function", &val);
+	if (!ret)
+		has_func = true;
+
+	for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
+		ret = of_property_read_u32(np, cfg_params[i].property, &val);
+		if (!ret) {
+			config = PINCFG_PACK(cfg_params[i].param, val);
+			ret = add_config(dev, &configs, &num_configs, config);
+			if (ret < 0)
+				goto exit;
+		/* EINVAL=missing, which is fine since it's optional */
+		} else if (ret != -EINVAL) {
+			dev_err(dev, "could not parse property %s\n",
+				cfg_params[i].property);
+		}
 	}
 
-	/* create the config map entry */
-	map[*nmaps].data.configs.group_or_pin = gname;
-	map[*nmaps].data.configs.configs = cfg;
-	map[*nmaps].data.configs.num_configs = cfg_cnt;
-	map[*nmaps].type = PIN_MAP_TYPE_CONFIGS_GROUP;
-	*nmaps += 1;
-
-skip_cfgs:
-	/* create the function map entry */
-	if (of_find_property(np, "samsung,pin-function", NULL)) {
-		fname = kzalloc(strlen(np->name) + FSUFFIX_LEN,	GFP_KERNEL);
-		if (!fname) {
-			dev_err(dev, "failed to alloc memory for func name\n");
-			goto free_cfg;
+	reserve = 0;
+	if (has_func)
+		reserve++;
+	if (num_configs)
+		reserve++;
+	ret = of_property_count_strings(np, "samsung,pins");
+	if (ret < 0) {
+		dev_err(dev, "could not parse property samsung,pins\n");
+		goto exit;
+	}
+	reserve *= ret;
+
+	ret = reserve_map(dev, map, reserved_maps, num_maps, reserve);
+	if (ret < 0)
+		goto exit;
+
+	of_property_for_each_string(np, "samsung,pins", prop, group) {
+		if (has_func) {
+			ret = add_map_mux(map, reserved_maps,
+						num_maps, group, np->full_name);
+			if (ret < 0)
+				goto exit;
 		}
-		sprintf(fname, "%s%s", np->name, FUNCTION_SUFFIX);
 
-		map[*nmaps].data.mux.group = gname;
-		map[*nmaps].data.mux.function = fname;
-		map[*nmaps].type = PIN_MAP_TYPE_MUX_GROUP;
-		*nmaps += 1;
+		if (num_configs) {
+			ret = add_map_configs(dev, map, reserved_maps,
+					      num_maps, group, configs,
+					      num_configs);
+			if (ret < 0)
+				goto exit;
+		}
 	}
 
-	*maps = map;
-	return 0;
+	ret = 0;
 
-free_cfg:
-	kfree(cfg);
-free_gname:
-	kfree(gname);
-free_map:
-	kfree(map);
-	return -ENOMEM;
+exit:
+	kfree(configs);
+	return ret;
 }
 
-/* free the memory allocated to hold the pin-map table */
-static void samsung_dt_free_map(struct pinctrl_dev *pctldev,
-			     struct pinctrl_map *map, unsigned num_maps)
+static int samsung_dt_node_to_map(struct pinctrl_dev *pctldev,
+					struct device_node *np_config,
+					struct pinctrl_map **map,
+					unsigned *num_maps)
 {
-	int idx;
-
-	for (idx = 0; idx < num_maps; idx++) {
-		if (map[idx].type == PIN_MAP_TYPE_MUX_GROUP) {
-			kfree(map[idx].data.mux.function);
-			if (!idx)
-				kfree(map[idx].data.mux.group);
-		} else if (map->type == PIN_MAP_TYPE_CONFIGS_GROUP) {
-			kfree(map[idx].data.configs.configs);
-			if (!idx)
-				kfree(map[idx].data.configs.group_or_pin);
+	struct samsung_pinctrl_drv_data *drvdata;
+	unsigned reserved_maps;
+	struct device_node *np;
+	int ret;
+
+	drvdata = pinctrl_dev_get_drvdata(pctldev);
+
+	reserved_maps = 0;
+	*map = NULL;
+	*num_maps = 0;
+
+	if (!of_get_child_count(np_config))
+		return samsung_dt_subnode_to_map(drvdata, pctldev->dev,
+							np_config, map,
+							&reserved_maps,
+							num_maps);
+
+	for_each_child_of_node(np_config, np) {
+		ret = samsung_dt_subnode_to_map(drvdata, pctldev->dev, np, map,
+						&reserved_maps, num_maps);
+		if (ret < 0) {
+			samsung_dt_free_map(pctldev, *map, *num_maps);
+			return ret;
 		}
-	};
+	}
 
-	kfree(map);
+	return 0;
 }
 
 /* list of pinctrl callbacks for the pinctrl core */
@@ -286,43 +365,38 @@ static void samsung_pinmux_setup(struct pinctrl_dev *pctldev, unsigned selector,
 					unsigned group, bool enable)
 {
 	struct samsung_pinctrl_drv_data *drvdata;
-	const unsigned int *pins;
+	struct samsung_pin_bank_type *type;
 	struct samsung_pin_bank *bank;
 	void __iomem *reg;
-	u32 mask, shift, data, pin_offset, cnt;
+	u32 mask, shift, data, pin_offset;
 	unsigned long flags;
+	const struct samsung_pmx_func *func;
+	const struct samsung_pin_group *grp;
 
 	drvdata = pinctrl_dev_get_drvdata(pctldev);
-	pins = drvdata->pin_groups[group].pins;
+	func = &drvdata->pmx_functions[selector];
+	grp = &drvdata->pin_groups[group];
 
-	/*
-	 * for each pin in the pin group selected, program the correspoding pin
-	 * pin function number in the config register.
-	 */
-	for (cnt = 0; cnt < drvdata->pin_groups[group].num_pins; cnt++) {
-		struct samsung_pin_bank_type *type;
-
-		pin_to_reg_bank(drvdata, pins[cnt] - drvdata->ctrl->base,
-				&reg, &pin_offset, &bank);
-		type = bank->type;
-		mask = (1 << type->fld_width[PINCFG_TYPE_FUNC]) - 1;
-		shift = pin_offset * type->fld_width[PINCFG_TYPE_FUNC];
-		if (shift >= 32) {
-			/* Some banks have two config registers */
-			shift -= 32;
-			reg += 4;
-		}
+	pin_to_reg_bank(drvdata, grp->pins[0] - drvdata->ctrl->base,
+			&reg, &pin_offset, &bank);
+	type = bank->type;
+	mask = (1 << type->fld_width[PINCFG_TYPE_FUNC]) - 1;
+	shift = pin_offset * type->fld_width[PINCFG_TYPE_FUNC];
+	if (shift >= 32) {
+		/* Some banks have two config registers */
+		shift -= 32;
+		reg += 4;
+	}
 
-		spin_lock_irqsave(&bank->slock, flags);
+	spin_lock_irqsave(&bank->slock, flags);
 
-		data = readl(reg + type->reg_offset[PINCFG_TYPE_FUNC]);
-		data &= ~(mask << shift);
-		if (enable)
-			data |= drvdata->pin_groups[group].func << shift;
-		writel(data, reg + type->reg_offset[PINCFG_TYPE_FUNC]);
+	data = readl(reg + type->reg_offset[PINCFG_TYPE_FUNC]);
+	data &= ~(mask << shift);
+	if (enable)
+		data |= func->val << shift;
+	writel(data, reg + type->reg_offset[PINCFG_TYPE_FUNC]);
 
-		spin_unlock_irqrestore(&bank->slock, flags);
-	}
+	spin_unlock_irqrestore(&bank->slock, flags);
 }
 
 /* enable a specified pinmux by writing to registers */
@@ -578,87 +652,125 @@ static int samsung_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 	return (virq) ? : -ENXIO;
 }
 
-/*
- * Parse the pin names listed in the 'samsung,pins' property and convert it
- * into a list of gpio numbers are create a pin group from it.
- */
-static int samsung_pinctrl_parse_dt_pins(struct platform_device *pdev,
-					 struct device_node *cfg_np,
-					 struct pinctrl_desc *pctl,
-					 unsigned int **pin_list,
-					 unsigned int *npins)
+static struct samsung_pin_group *samsung_pinctrl_create_groups(
+				struct device *dev,
+				struct samsung_pinctrl_drv_data *drvdata,
+				unsigned int *cnt)
 {
-	struct device *dev = &pdev->dev;
-	struct property *prop;
-	struct pinctrl_pin_desc const *pdesc = pctl->pins;
-	unsigned int idx = 0, cnt;
-	const char *pin_name;
+	struct pinctrl_desc *ctrldesc = &drvdata->pctl;
+	struct samsung_pin_group *groups, *grp;
+	const struct pinctrl_pin_desc *pdesc;
+	int i;
+
+	groups = devm_kzalloc(dev, ctrldesc->npins * sizeof(*groups),
+				GFP_KERNEL);
+	if (!groups) {
+		dev_err(dev, "failed allocate memory for ping group list\n");
+		return ERR_PTR(-EINVAL);
+	}
+	grp = groups;
+
+	pdesc = ctrldesc->pins;
+	for (i = 0; i < ctrldesc->npins; ++i, ++pdesc, ++grp) {
+		grp->name = pdesc->name;
+		grp->pins = &pdesc->number;
+		grp->num_pins = 1;
+	}
+
+	*cnt = ctrldesc->npins;
+	return groups;
+}
+
+static int samsung_pinctrl_create_function(struct device *dev,
+				struct samsung_pinctrl_drv_data *drvdata,
+				struct device_node *func_np,
+				struct samsung_pmx_func *func)
+{
+	int npins;
+	int ret;
+	int i;
+
+	if (of_property_read_u32(func_np, "samsung,pin-function", &func->val))
+		return 0;
 
-	*npins = of_property_count_strings(cfg_np, "samsung,pins");
-	if (IS_ERR_VALUE(*npins)) {
-		dev_err(dev, "invalid pin list in %s node", cfg_np->name);
+	npins = of_property_count_strings(func_np, "samsung,pins");
+	if (npins < 1) {
+		dev_err(dev, "invalid pin list in %s node", func_np->name);
 		return -EINVAL;
 	}
 
-	*pin_list = devm_kzalloc(dev, *npins * sizeof(**pin_list), GFP_KERNEL);
-	if (!*pin_list) {
-		dev_err(dev, "failed to allocate memory for pin list\n");
+	func->name = func_np->full_name;
+
+	func->groups = devm_kzalloc(dev, npins * sizeof(char *), GFP_KERNEL);
+	if (!func->groups) {
+		dev_err(dev, "failed to alloc memory for group list in pin function");
 		return -ENOMEM;
 	}
 
-	of_property_for_each_string(cfg_np, "samsung,pins", prop, pin_name) {
-		for (cnt = 0; cnt < pctl->npins; cnt++) {
-			if (pdesc[cnt].name) {
-				if (!strcmp(pin_name, pdesc[cnt].name)) {
-					(*pin_list)[idx++] = pdesc[cnt].number;
-					break;
-				}
-			}
-		}
-		if (cnt == pctl->npins) {
-			dev_err(dev, "pin %s not valid in %s node\n",
-					pin_name, cfg_np->name);
-			devm_kfree(dev, *pin_list);
-			return -EINVAL;
+	for (i = 0; i < npins; ++i) {
+		const char *gname;
+		char *gname_copy;
+
+		ret = of_property_read_string_index(func_np, "samsung,pins",
+							i, &gname);
+		if (ret) {
+			dev_err(dev,
+				"failed to read pin name %d from %s node\n",
+				i, func_np->name);
+			return ret;
 		}
+
+		gname_copy = devm_kzalloc(dev, strlen(gname) + 1, GFP_KERNEL);
+		if (!gname_copy)
+			return -ENOMEM;
+		strcpy(gname_copy, gname);
+
+		func->groups[i] = gname_copy;
 	}
 
-	return 0;
+	func->num_groups = npins;
+	return 1;
 }
 
-/*
- * Parse the information about all the available pin groups and pin functions
- * from device node of the pin-controller. A pin group is formed with all
- * the pins listed in the "samsung,pins" property.
- */
-static int samsung_pinctrl_parse_dt(struct platform_device *pdev,
-				    struct samsung_pinctrl_drv_data *drvdata)
+static struct samsung_pmx_func *samsung_pinctrl_create_functions(
+				struct device *dev,
+				struct samsung_pinctrl_drv_data *drvdata,
+				unsigned int *cnt)
 {
-	struct device *dev = &pdev->dev;
+	struct samsung_pmx_func *functions, *func;
 	struct device_node *dev_np = dev->of_node;
 	struct device_node *cfg_np;
-	struct samsung_pin_group *groups, *grp;
-	struct samsung_pmx_func *functions, *func;
-	unsigned *pin_list;
-	unsigned int npins, grp_cnt, func_idx = 0;
-	char *gname, *fname;
+	unsigned int func_cnt = 0;
 	int ret;
 
-	grp_cnt = of_get_child_count(dev_np);
-	if (!grp_cnt)
-		return -EINVAL;
+	/*
+	 * Iterate over all the child nodes of the pin controller node
+	 * and create pin groups and pin function lists.
+	 */
+	for_each_child_of_node(dev_np, cfg_np) {
+		struct device_node *func_np;
 
-	groups = devm_kzalloc(dev, grp_cnt * sizeof(*groups), GFP_KERNEL);
-	if (!groups) {
-		dev_err(dev, "failed allocate memory for ping group list\n");
-		return -EINVAL;
+		if (!of_get_child_count(cfg_np)) {
+			if (!of_find_property(cfg_np,
+			    "samsung,pin-function", NULL))
+				continue;
+			++func_cnt;
+			continue;
+		}
+
+		for_each_child_of_node(cfg_np, func_np) {
+			if (!of_find_property(func_np,
+			    "samsung,pin-function", NULL))
+				continue;
+			++func_cnt;
+		}
 	}
-	grp = groups;
 
-	functions = devm_kzalloc(dev, grp_cnt * sizeof(*functions), GFP_KERNEL);
+	functions = devm_kzalloc(dev, func_cnt * sizeof(*functions),
+					GFP_KERNEL);
 	if (!functions) {
 		dev_err(dev, "failed to allocate memory for function list\n");
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 	func = functions;
 
@@ -666,61 +778,68 @@ static int samsung_pinctrl_parse_dt(struct platform_device *pdev,
 	 * Iterate over all the child nodes of the pin controller node
 	 * and create pin groups and pin function lists.
 	 */
+	func_cnt = 0;
 	for_each_child_of_node(dev_np, cfg_np) {
-		u32 function;
-		if (!of_find_property(cfg_np, "samsung,pins", NULL))
+		struct device_node *func_np;
+
+		if (!of_get_child_count(cfg_np)) {
+			ret = samsung_pinctrl_create_function(dev, drvdata,
+							cfg_np, func);
+			if (ret < 0)
+				return ERR_PTR(ret);
+			if (ret > 0) {
+				++func;
+				++func_cnt;
+			}
 			continue;
+		}
 
-		ret = samsung_pinctrl_parse_dt_pins(pdev, cfg_np,
-					&drvdata->pctl,	&pin_list, &npins);
-		if (ret)
-			return ret;
-
-		/* derive pin group name from the node name */
-		gname = devm_kzalloc(dev, strlen(cfg_np->name) + GSUFFIX_LEN,
-					GFP_KERNEL);
-		if (!gname) {
-			dev_err(dev, "failed to alloc memory for group name\n");
-			return -ENOMEM;
+		for_each_child_of_node(cfg_np, func_np) {
+			ret = samsung_pinctrl_create_function(dev, drvdata,
+						func_np, func);
+			if (ret < 0)
+				return ERR_PTR(ret);
+			if (ret > 0) {
+				++func;
+				++func_cnt;
+			}
 		}
-		sprintf(gname, "%s%s", cfg_np->name, GROUP_SUFFIX);
+	}
 
-		grp->name = gname;
-		grp->pins = pin_list;
-		grp->num_pins = npins;
-		of_property_read_u32(cfg_np, "samsung,pin-function", &function);
-		grp->func = function;
-		grp++;
+	*cnt = func_cnt;
+	return functions;
+}
 
-		if (!of_find_property(cfg_np, "samsung,pin-function", NULL))
-			continue;
+/*
+ * Parse the information about all the available pin groups and pin functions
+ * from device node of the pin-controller. A pin group is formed with all
+ * the pins listed in the "samsung,pins" property.
+ */
 
-		/* derive function name from the node name */
-		fname = devm_kzalloc(dev, strlen(cfg_np->name) + FSUFFIX_LEN,
-					GFP_KERNEL);
-		if (!fname) {
-			dev_err(dev, "failed to alloc memory for func name\n");
-			return -ENOMEM;
-		}
-		sprintf(fname, "%s%s", cfg_np->name, FUNCTION_SUFFIX);
+static int samsung_pinctrl_parse_dt(struct platform_device *pdev,
+				    struct samsung_pinctrl_drv_data *drvdata)
+{
+	struct device *dev = &pdev->dev;
+	struct samsung_pin_group *groups;
+	struct samsung_pmx_func *functions;
+	unsigned int grp_cnt = 0, func_cnt = 0;
+
+	groups = samsung_pinctrl_create_groups(dev, drvdata, &grp_cnt);
+	if (IS_ERR(groups)) {
+		dev_err(dev, "failed to parse pin groups\n");
+		return PTR_ERR(groups);
+	}
 
-		func->name = fname;
-		func->groups = devm_kzalloc(dev, sizeof(char *), GFP_KERNEL);
-		if (!func->groups) {
-			dev_err(dev, "failed to alloc memory for group list "
-					"in pin function");
-			return -ENOMEM;
-		}
-		func->groups[0] = gname;
-		func->num_groups = 1;
-		func++;
-		func_idx++;
+	functions = samsung_pinctrl_create_functions(dev, drvdata, &func_cnt);
+	if (IS_ERR(functions)) {
+		dev_err(dev, "failed to parse pin functions\n");
+		return PTR_ERR(groups);
 	}
 
 	drvdata->pin_groups = groups;
 	drvdata->nr_groups = grp_cnt;
 	drvdata->pmx_functions = functions;
-	drvdata->nr_functions = func_idx;
+	drvdata->nr_functions = func_cnt;
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/pinctrl-samsung.h
index 30622d9..a7488d5 100644
--- a/drivers/pinctrl/pinctrl-samsung.h
+++ b/drivers/pinctrl/pinctrl-samsung.h
@@ -248,6 +248,7 @@ struct samsung_pmx_func {
 	const char		*name;
 	const char		**groups;
 	u8			num_groups;
+	u32			val;
 };
 
 /* list of all exported SoC specific data */
-- 
1.8.4.2

