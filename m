Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889AbaESRg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:36:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61717 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802AbaESRgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:36:54 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/7] pinctrl: berlin: add the core pinctrl driver for Marvell Berlin SoCs
Date: Mon, 19 May 2014 19:36:29 +0200
Message-Id: <1400520995-27365-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Tenart <antoine.tenart@free-electrons.com>

The Marvell Berlin boards have a group based pinmuxing mechanism. This
adds the core driver support. We actually do not need any information
about the pins here and only have the definition of the groups.

Let's take the example of the uart0 pinmuxing on the BG2Q. Balls BK4 and
BH6 are muxed to respectively UART0 RX and TX if the group GSM12 is set
to mode 0:

Group	Modes	Offset Base	Offset	LSB	Bit Width
GSM12	3	sm_base		0x40	0x10	0x2

Ball	Group	Mode 0		Mode 1		Mode 2
BK4	GSM12	UART0_RX	IrDA0_RX	GPIO9
BH6	GSM12	UART0_TX	IrDA0_TX	GPIO10

So in order to configure BK4 -> UART0_TX and BH6 -> UART0_RX, we need
to set (sm_base + 0x40 + 0x10) &= ff3fffff.

As pin control registers are part of either chip control or system
control registers, that deal with a bunch of other functions we rely
on a regmap instead of exclusively remapping any resources.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v3->v4:
- replace resource request with regmap provided by SoC-specific stubs.
- use regmap_update_bits to setup pinmux setting
- move driver private struct from include to driver
- remove "marvell," prefix from pinctrl function/groups property

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: zmxu@marvell.com
Cc: jszhang@marvell.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/Kconfig         |   1 +
 drivers/pinctrl/Makefile        |   1 +
 drivers/pinctrl/berlin/Kconfig  |   8 +
 drivers/pinctrl/berlin/Makefile |   1 +
 drivers/pinctrl/berlin/berlin.c | 348 ++++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/berlin/berlin.h |  61 +++++++
 6 files changed, 420 insertions(+)
 create mode 100644 drivers/pinctrl/berlin/Kconfig
 create mode 100644 drivers/pinctrl/berlin/Makefile
 create mode 100644 drivers/pinctrl/berlin/berlin.c
 create mode 100644 drivers/pinctrl/berlin/berlin.h

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index e49324032611..efeef15270b5 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -368,6 +368,7 @@ config PINCTRL_S3C64XX
 	depends on ARCH_S3C64XX
 	select PINCTRL_SAMSUNG
 
+source "drivers/pinctrl/berlin/Kconfig"
 source "drivers/pinctrl/mvebu/Kconfig"
 source "drivers/pinctrl/sh-pfc/Kconfig"
 source "drivers/pinctrl/spear/Kconfig"
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 4b835880cf80..02ffdff82676 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_PINCTRL_TB10X)	+= pinctrl-tb10x.o
 obj-$(CONFIG_PINCTRL_ST) 	+= pinctrl-st.o
 obj-$(CONFIG_PINCTRL_VF610)	+= pinctrl-vf610.o
 
+obj-$(CONFIG_ARCH_BERLIN)	+= berlin/
 obj-$(CONFIG_PLAT_ORION)        += mvebu/
 obj-$(CONFIG_ARCH_SHMOBILE)	+= sh-pfc/
 obj-$(CONFIG_SUPERH)		+= sh-pfc/
diff --git a/drivers/pinctrl/berlin/Kconfig b/drivers/pinctrl/berlin/Kconfig
new file mode 100644
index 000000000000..d81c1bb13697
--- /dev/null
+++ b/drivers/pinctrl/berlin/Kconfig
@@ -0,0 +1,8 @@
+if ARCH_BERLIN
+
+config PINCTRL_BERLIN
+	bool
+	select PINMUX
+	select REGMAP_MMIO
+
+endif
diff --git a/drivers/pinctrl/berlin/Makefile b/drivers/pinctrl/berlin/Makefile
new file mode 100644
index 000000000000..251a2b4e1057
--- /dev/null
+++ b/drivers/pinctrl/berlin/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_PINCTRL_BERLIN)		+= berlin.o
diff --git a/drivers/pinctrl/berlin/berlin.c b/drivers/pinctrl/berlin/berlin.c
new file mode 100644
index 000000000000..aa866a81f223
--- /dev/null
+++ b/drivers/pinctrl/berlin/berlin.c
@@ -0,0 +1,348 @@
+/*
+ * Marvell Berlin SoC pinctrl core driver
+ *
+ * Copyright (C) 2014 Marvell Technology Group Ltd.
+ *
+ * Antoine Ténart <antoine.tenart@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+#include "../core.h"
+#include "../pinctrl-utils.h"
+#include "berlin.h"
+
+struct berlin_pinctrl {
+	struct regmap *regmap;
+	struct device *dev;
+	const struct berlin_pinctrl_desc *desc;
+	struct berlin_pinctrl_function *functions;
+	unsigned nfunctions;
+	struct pinctrl_dev *pctrl_dev;
+};
+
+static int berlin_pinctrl_get_group_count(struct pinctrl_dev *pctrl_dev)
+{
+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
+
+	return pctrl->desc->ngroups;
+}
+
+static const char *berlin_pinctrl_get_group_name(struct pinctrl_dev *pctrl_dev,
+						 unsigned group)
+{
+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
+
+	return pctrl->desc->groups[group].name;
+}
+
+static int berlin_pinctrl_dt_node_to_map(struct pinctrl_dev *pctrl_dev,
+					 struct device_node *node,
+					 struct pinctrl_map **map,
+					 unsigned *num_maps)
+{
+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
+	struct property *prop;
+	const char *function_name, *group_name;
+	unsigned reserved_maps = 0;
+	int ret, ngroups;
+
+	*map = NULL;
+	*num_maps = 0;
+
+	ret = of_property_read_string(node, "function", &function_name);
+	if (ret) {
+		dev_err(pctrl->dev,
+			"missing function property in node %s\n",
+			node->name);
+		return -EINVAL;
+	}
+
+	ngroups = of_property_count_strings(node, "groups");
+	if (ngroups < 0) {
+		dev_err(pctrl->dev,
+			"missing groups property in node %s\n",
+			node->name);
+		return -EINVAL;
+	}
+
+	ret = pinctrl_utils_reserve_map(pctrl_dev, map, &reserved_maps,
+					num_maps, ngroups);
+	if (ret) {
+		dev_err(pctrl->dev, "can't reserve map: %d\n", ret);
+		return ret;
+	}
+
+	of_property_for_each_string(node, "groups", prop, group_name) {
+		ret = pinctrl_utils_add_map_mux(pctrl_dev, map, &reserved_maps,
+						num_maps, group_name,
+						function_name);
+		if (ret) {
+			dev_err(pctrl->dev, "can't add map: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void berlin_pinctrl_dt_free_map(struct pinctrl_dev *pctrl_dev,
+				       struct pinctrl_map *map,
+				       unsigned nmaps)
+{
+	int i;
+
+	for (i = 0; i < nmaps; i++) {
+		if (map[i].type == PIN_MAP_TYPE_MUX_GROUP) {
+			kfree(map[i].data.mux.group);
+
+			/* a function can be applied to multiple groups */
+			if (i == 0)
+				kfree(map[i].data.mux.function);
+		}
+	}
+
+	kfree(map);
+}
+
+static const struct pinctrl_ops berlin_pinctrl_ops = {
+	.get_groups_count	= &berlin_pinctrl_get_group_count,
+	.get_group_name		= &berlin_pinctrl_get_group_name,
+	.dt_node_to_map		= &berlin_pinctrl_dt_node_to_map,
+	.dt_free_map		= &berlin_pinctrl_dt_free_map,
+};
+
+static int berlin_pinmux_get_functions_count(struct pinctrl_dev *pctrl_dev)
+{
+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
+
+	return pctrl->nfunctions;
+}
+
+static const char *berlin_pinmux_get_function_name(struct pinctrl_dev *pctrl_dev,
+						   unsigned function)
+{
+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
+
+	return pctrl->functions[function].name;
+}
+
+static int berlin_pinmux_get_function_groups(struct pinctrl_dev *pctrl_dev,
+					     unsigned function,
+					     const char * const **groups,
+					     unsigned * const num_groups)
+{
+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
+
+	*groups = pctrl->functions[function].groups;
+	*num_groups = pctrl->functions[function].ngroups;
+
+	return 0;
+}
+
+static struct berlin_desc_function *
+berlin_pinctrl_find_function_by_name(struct berlin_pinctrl *pctrl,
+				     const struct berlin_desc_group *group,
+				     const char *fname)
+{
+	struct berlin_desc_function *function = group->functions;
+
+	while (function->name) {
+		if (!strcmp(function->name, fname))
+			return function;
+
+		function++;
+	}
+
+	return NULL;
+}
+
+static int berlin_pinmux_enable(struct pinctrl_dev *pctrl_dev,
+				unsigned function,
+				unsigned group)
+{
+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
+	const struct berlin_desc_group *group_desc = pctrl->desc->groups + group;
+	struct berlin_pinctrl_function *func = pctrl->functions + function;
+	struct berlin_desc_function *function_desc =
+		berlin_pinctrl_find_function_by_name(pctrl, group_desc,
+						     func->name);
+	u32 mask, val;
+
+	if (!function_desc)
+		return -EINVAL;
+
+	mask = GENMASK(group_desc->lsb + group_desc->bit_width - 1,
+		       group_desc->lsb);
+	val = function_desc->muxval << group_desc->lsb;
+	regmap_update_bits(pctrl->regmap, group_desc->offset, mask, val);
+
+	return 0;
+}
+
+static const struct pinmux_ops berlin_pinmux_ops = {
+	.get_functions_count	= &berlin_pinmux_get_functions_count,
+	.get_function_name	= &berlin_pinmux_get_function_name,
+	.get_function_groups	= &berlin_pinmux_get_function_groups,
+	.enable			= &berlin_pinmux_enable,
+};
+
+static int berlin_pinctrl_add_function(struct berlin_pinctrl *pctrl,
+				       const char *name)
+{
+	struct berlin_pinctrl_function *function = pctrl->functions;
+
+	while (function->name) {
+		if (!strcmp(function->name, name)) {
+			function->ngroups++;
+			return -EEXIST;
+		}
+		function++;
+	}
+
+	function->name = name;
+	function->ngroups = 1;
+
+	pctrl->nfunctions++;
+
+	return 0;
+}
+
+static int berlin_pinctrl_build_state(struct platform_device *pdev)
+{
+	struct berlin_pinctrl *pctrl = platform_get_drvdata(pdev);
+	struct berlin_desc_group const *desc_group;
+	struct berlin_desc_function const *desc_function;
+	int i, max_functions = 0;
+
+	pctrl->nfunctions = 0;
+
+	for (i = 0; i < pctrl->desc->ngroups; i++) {
+		desc_group = pctrl->desc->groups + i;
+		/* compute the maxiumum number of functions a group can have */
+		max_functions += 1 << (desc_group->bit_width + 1);
+	}
+
+	/* we will reallocate later */
+	pctrl->functions = devm_kzalloc(&pdev->dev,
+					max_functions * sizeof(*pctrl->functions),
+					GFP_KERNEL);
+	if (!pctrl->functions)
+		return -ENOMEM;
+
+	/* register all functions */
+	for (i = 0; i < pctrl->desc->ngroups; i++) {
+		desc_group = pctrl->desc->groups + i;
+		desc_function = desc_group->functions;
+
+		while (desc_function->name) {
+			berlin_pinctrl_add_function(pctrl, desc_function->name);
+			desc_function++;
+		}
+	}
+
+	pctrl->functions = krealloc(pctrl->functions,
+				    pctrl->nfunctions * sizeof(*pctrl->functions),
+				    GFP_KERNEL);
+
+	/* map functions to theirs groups */
+	for (i = 0; i < pctrl->desc->ngroups; i++) {
+		desc_group = pctrl->desc->groups + i;
+		desc_function = desc_group->functions;
+
+		while (desc_function->name) {
+			struct berlin_pinctrl_function
+				*function = pctrl->functions;
+			const char **groups;
+			bool found = false;
+
+			while (function->name) {
+				if (!strcmp(desc_function->name, function->name)) {
+					found = true;
+					break;
+				}
+				function++;
+			}
+
+			if (!found)
+				return -EINVAL;
+
+			if (!function->groups) {
+				function->groups =
+					devm_kzalloc(&pdev->dev,
+						     function->ngroups * sizeof(char *),
+						     GFP_KERNEL);
+
+				if (!function->groups)
+					return -ENOMEM;
+			}
+
+			groups = function->groups;
+			while (*groups)
+				groups++;
+
+			*groups = desc_group->name;
+
+			desc_function++;
+		}
+	}
+
+	return 0;
+}
+
+static struct pinctrl_desc berlin_pctrl_desc = {
+	.name		= "berlin-pinctrl",
+	.pctlops	= &berlin_pinctrl_ops,
+	.pmxops		= &berlin_pinmux_ops,
+	.owner		= THIS_MODULE,
+};
+
+int berlin_pinctrl_probe(struct platform_device *pdev,
+			 const struct berlin_pinctrl_desc *desc)
+{
+	struct device *dev = &pdev->dev;
+	struct berlin_pinctrl *pctrl;
+	struct regmap *regmap;
+	int ret;
+
+	regmap = dev_get_regmap(&pdev->dev, NULL);
+	if (!regmap)
+		return PTR_ERR(regmap);
+
+	pctrl = devm_kzalloc(dev, sizeof(*pctrl), GFP_KERNEL);
+	if (!pctrl)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, pctrl);
+
+	pctrl->regmap = regmap;
+	pctrl->dev = &pdev->dev;
+	pctrl->desc = desc;
+
+	ret = berlin_pinctrl_build_state(pdev);
+	if (ret) {
+		dev_err(dev, "cannot build driver state: %d\n", ret);
+		return ret;
+	}
+
+	pctrl->pctrl_dev = pinctrl_register(&berlin_pctrl_desc, dev, pctrl);
+	if (!pctrl->pctrl_dev) {
+		dev_err(dev, "failed to register pinctrl driver\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/drivers/pinctrl/berlin/berlin.h b/drivers/pinctrl/berlin/berlin.h
new file mode 100644
index 000000000000..5cb738e0b444
--- /dev/null
+++ b/drivers/pinctrl/berlin/berlin.h
@@ -0,0 +1,61 @@
+/*
+ * Marvell Berlin SoC pinctrl driver.
+ *
+ * Copyright (C) 2014 Marvell Technology Group Ltd.
+ *
+ * Antoine Ténart <antoine.tenart@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __PINCTRL_BERLIN_H
+#define __PINCTRL_BERLIN_H
+
+struct berlin_desc_function {
+	const char	*name;
+	u8		muxval;
+};
+
+struct berlin_desc_group {
+	const char			*name;
+	u8				offset;
+	u8				bit_width;
+	u8				lsb;
+	struct berlin_desc_function	*functions;
+};
+
+struct berlin_pinctrl_desc {
+	const struct berlin_desc_group	*groups;
+	unsigned			ngroups;
+};
+
+struct berlin_pinctrl_function {
+	const char	*name;
+	const char	**groups;
+	unsigned	ngroups;
+};
+
+#define BERLIN_PINCTRL_GROUP(_name, _offset, _width, _lsb, ...)		\
+	{								\
+		.name = _name,						\
+		.offset = _offset,					\
+		.bit_width = _width,					\
+		.lsb = _lsb,						\
+		.functions = (struct berlin_desc_function[]){		\
+			__VA_ARGS__, { } },				\
+	}
+
+#define BERLIN_PINCTRL_FUNCTION(_muxval, _name)		\
+	{						\
+		.name = _name,				\
+		.muxval = _muxval,			\
+	}
+
+#define BERLIN_PINCTRL_FUNCTION_UNKNOWN		{}
+
+int berlin_pinctrl_probe(struct platform_device *pdev,
+			 const struct berlin_pinctrl_desc *desc);
+
+#endif /* __PINCTRL_BERLIN_H */
-- 
1.9.1

