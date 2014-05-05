Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaEEF3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 01:29:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35587 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754359AbaEEF1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 01:27:34 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/7] pinctrl: berlin: add the core pinctrl driver for Marvell Berlin SoCs
Date: Mon,  5 May 2014 07:27:23 +0200
Message-Id: <1399267649-20218-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
 drivers/pinctrl/Kconfig         |   1 +
 drivers/pinctrl/Makefile        |   1 +
 drivers/pinctrl/berlin/Kconfig  |   7 +
 drivers/pinctrl/berlin/Makefile |   1 +
 drivers/pinctrl/berlin/berlin.c | 346 ++++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/berlin/berlin.h |  71 +++++++++
 6 files changed, 427 insertions(+)
 create mode 100644 drivers/pinctrl/berlin/Kconfig
 create mode 100644 drivers/pinctrl/berlin/Makefile
 create mode 100644 drivers/pinctrl/berlin/berlin.c
 create mode 100644 drivers/pinctrl/berlin/berlin.h

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index e00c02d0a094..f758fa43ab92 100644
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
index 6d3fd62b9ae8..0bd6dcb5baf9 100644
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
index 000000000000..df843e01a001
--- /dev/null
+++ b/drivers/pinctrl/berlin/Kconfig
@@ -0,0 +1,7 @@
+if ARCH_BERLIN
+
+config PINCTRL_BERLIN
+	bool
+	select PINMUX
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
index 000000000000..20c1374d11f0
--- /dev/null
+++ b/drivers/pinctrl/berlin/berlin.c
@@ -0,0 +1,346 @@
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
+#include <linux/slab.h>
+
+#include "../core.h"
+#include "../pinctrl-utils.h"
+#include "berlin.h"
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
+	ret = of_property_read_string(node, "marvell,function", &function_name);
+	if (ret) {
+		dev_err(pctrl->dev,
+			"missing 'marvell,function' property in node %s\n",
+			node->name);
+		return -EINVAL;
+	}
+
+	ngroups = of_property_count_strings(node, "marvell,groups");
+	if (ngroups < 0) {
+		dev_err(pctrl->dev,
+			"missing 'marvell,groups' property in node %s\n",
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
+	of_property_for_each_string(node, "marvell,groups", prop, group_name) {
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
+	unsigned long flags;
+	u32 regval;
+
+	if (!function_desc)
+		return -EINVAL;
+
+	spin_lock_irqsave(&pctrl->lock, flags);
+
+	regval = readl(pctrl->base + group_desc->offset);
+	regval &= GENMASK(group_desc->lsb + group_desc->bit_width - 1,
+			  group_desc->lsb);
+	regval |= function_desc->muxval << group_desc->lsb;
+	writel_relaxed(regval, pctrl->base + group_desc->offset);
+
+	spin_unlock_irqrestore(&pctrl->lock, flags);
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
+	struct resource *r;
+	int ret;
+
+	pctrl = devm_kzalloc(dev, sizeof(*pctrl), GFP_KERNEL);
+	if (!pctrl)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, pctrl);
+
+	spin_lock_init(&pctrl->lock);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	pctrl->base = devm_ioremap_resource(dev, r);
+	if (IS_ERR(pctrl->base))
+		return PTR_ERR(pctrl->base);
+
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
index 000000000000..e9214722c879
--- /dev/null
+++ b/drivers/pinctrl/berlin/berlin.h
@@ -0,0 +1,71 @@
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
+struct berlin_pinctrl {
+	spinlock_t				lock;
+	void __iomem				*base;
+	struct device				*dev;
+	const struct berlin_pinctrl_desc	*desc;
+	struct berlin_pinctrl_function		*functions;
+	unsigned				nfunctions;
+	struct pinctrl_dev			*pctrl_dev;
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
1.8.3.2

