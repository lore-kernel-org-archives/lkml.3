Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030757AbaDJMth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:49:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38809 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030557AbaDJMrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:47:49 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@list.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] pinctrl: berlin: add a pinctrl driver for Marvell Berlin SoCs
Date: Thu, 10 Apr 2014 14:47:40 +0200
Message-Id: <1397134063-10503-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397134063-10503-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1397134063-10503-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Marvell Berlin boards have a group based pinmuxing mechanism. This
driver adds the support for the BG2CD, BG2 and BG2Q. We actually do not
need any information about the pins here and only have the definition
of the groups.

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
---
 drivers/pinctrl/Kconfig          |   4 +
 drivers/pinctrl/Makefile         |   1 +
 drivers/pinctrl/pinctrl-berlin.c | 498 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-berlin.h |  72 ++++++
 4 files changed, 575 insertions(+)
 create mode 100644 drivers/pinctrl/pinctrl-berlin.c
 create mode 100644 drivers/pinctrl/pinctrl-berlin.h

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index e49324032611..2d9339a7bd05 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -104,6 +104,10 @@ config PINCTRL_BCM2835
 	select PINMUX
 	select PINCONF
 
+config PINCTRL_BERLIN
+	bool
+	select PINMUX
+
 config PINCTRL_CAPRI
 	bool "Broadcom Capri pinctrl driver"
 	depends on OF
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 4b835880cf80..fd5a01d4475f 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_PINCTRL_BF60x)	+= pinctrl-adi2-bf60x.o
 obj-$(CONFIG_PINCTRL_AT91)	+= pinctrl-at91.o
 obj-$(CONFIG_PINCTRL_BCM2835)	+= pinctrl-bcm2835.o
 obj-$(CONFIG_PINCTRL_BAYTRAIL)	+= pinctrl-baytrail.o
+obj-$(CONFIG_PINCTRL_BERLIN)	+= pinctrl-berlin.o
 obj-$(CONFIG_PINCTRL_CAPRI)	+= pinctrl-capri.o
 obj-$(CONFIG_PINCTRL_IMX)	+= pinctrl-imx.o
 obj-$(CONFIG_PINCTRL_IMX1_CORE)	+= pinctrl-imx1-core.o
diff --git a/drivers/pinctrl/pinctrl-berlin.c b/drivers/pinctrl/pinctrl-berlin.c
new file mode 100644
index 000000000000..a377d6fbb127
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-berlin.c
@@ -0,0 +1,498 @@
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
+#include "core.h"
+#include "pinctrl-utils.h"
+#include "pinctrl-berlin.h"
+
+#define NFCTS(bit_width)	(1 << ((bit_width) + 1))
+
+static const struct berlin_desc_group berlin2cd_pinctrl_groups[] = {
+	/* GSM */
+	BERLIN_PINCTRL_GROUP("GSM0",  "apb_base",    0x40, 0x2, 0x00),
+	BERLIN_PINCTRL_GROUP("GSM1",  "apb_base",    0x40, 0x2, 0x02),
+	BERLIN_PINCTRL_GROUP("GSM2",  "apb_base",    0x40, 0x2, 0x04),
+	BERLIN_PINCTRL_GROUP("GSM3",  "apb_base",    0x40, 0x2, 0x06),
+	BERLIN_PINCTRL_GROUP("GSM4",  "apb_base",    0x40, 0x2, 0x08),
+	BERLIN_PINCTRL_GROUP("GSM5",  "apb_base",    0x40, 0x2, 0x0a),
+	BERLIN_PINCTRL_GROUP("GSM6",  "apb_base",    0x40, 0x2, 0x0c),
+	BERLIN_PINCTRL_GROUP("GSM7",  "apb_base",    0x40, 0x1, 0x0e),
+	BERLIN_PINCTRL_GROUP("GSM8",  "apb_base",    0x40, 0x1, 0x0f),
+	BERLIN_PINCTRL_GROUP("GSM9",  "apb_base",    0x40, 0x1, 0x10),
+	BERLIN_PINCTRL_GROUP("GSM10", "apb_base",    0x40, 0x1, 0x11),
+	BERLIN_PINCTRL_GROUP("GSM11", "apb_base",    0x40, 0x1, 0x12),
+	/* G */
+	BERLIN_PINCTRL_GROUP("G0",    "global_base", 0x00, 0x1, 0x00),
+	BERLIN_PINCTRL_GROUP("G1",    "global_base", 0x00, 0x2, 0x01),
+	BERLIN_PINCTRL_GROUP("G2",    "global_base", 0x00, 0x2, 0x02),
+	BERLIN_PINCTRL_GROUP("G3",    "global_base", 0x00, 0x2, 0x04),
+	BERLIN_PINCTRL_GROUP("G4",    "global_base", 0x00, 0x2, 0x06),
+	BERLIN_PINCTRL_GROUP("G5",    "global_base", 0x00, 0x3, 0x08),
+	BERLIN_PINCTRL_GROUP("G6",    "global_base", 0x00, 0x2, 0x0b),
+	BERLIN_PINCTRL_GROUP("G7",    "global_base", 0x00, 0x3, 0x0d),
+	BERLIN_PINCTRL_GROUP("G8",    "global_base", 0x00, 0x3, 0x10),
+	BERLIN_PINCTRL_GROUP("G9",    "global_base", 0x00, 0x3, 0x13),
+	BERLIN_PINCTRL_GROUP("G10",   "global_base", 0x00, 0x2, 0x16),
+	BERLIN_PINCTRL_GROUP("G11",   "global_base", 0x00, 0x2, 0x18),
+	BERLIN_PINCTRL_GROUP("G12",   "global_base", 0x00, 0x3, 0x1a),
+	BERLIN_PINCTRL_GROUP("G13",   "global_base", 0x04, 0x3, 0x00),
+	BERLIN_PINCTRL_GROUP("G14",   "global_base", 0x04, 0x1, 0x03),
+	BERLIN_PINCTRL_GROUP("G15",   "global_base", 0x04, 0x2, 0x04),
+	BERLIN_PINCTRL_GROUP("G16",   "global_base", 0x04, 0x3, 0x06),
+	BERLIN_PINCTRL_GROUP("G17",   "global_base", 0x04, 0x3, 0x09),
+	BERLIN_PINCTRL_GROUP("G18",   "global_base", 0x04, 0x1, 0x0c),
+	BERLIN_PINCTRL_GROUP("G19",   "global_base", 0x04, 0x1, 0x0d),
+	BERLIN_PINCTRL_GROUP("G20",   "global_base", 0x04, 0x1, 0x0e),
+	BERLIN_PINCTRL_GROUP("G21",   "global_base", 0x04, 0x3, 0x0f),
+	BERLIN_PINCTRL_GROUP("G22",   "global_base", 0x04, 0x3, 0x12),
+	BERLIN_PINCTRL_GROUP("G23",   "global_base", 0x04, 0x3, 0x15),
+	BERLIN_PINCTRL_GROUP("G24",   "global_base", 0x04, 0x2, 0x18),
+	BERLIN_PINCTRL_GROUP("G25",   "global_base", 0x04, 0x2, 0x1a),
+	BERLIN_PINCTRL_GROUP("G26",   "global_base", 0x04, 0x1, 0x1c),
+	BERLIN_PINCTRL_GROUP("G27",   "global_base", 0x04, 0x1, 0x1d),
+	BERLIN_PINCTRL_GROUP("G28",   "global_base", 0x04, 0x2, 0x1e),
+};
+
+static const struct berlin_desc_group berlin2q_pinctrl_groups[] = {
+	/* GSM */
+	BERLIN_PINCTRL_GROUP("GSM0",  "sm_base",     0x40, 0x2, 0x00),
+	BERLIN_PINCTRL_GROUP("GSM1",  "sm_base",     0x40, 0x2, 0x02),
+	BERLIN_PINCTRL_GROUP("GSM2",  "sm_base",     0x40, 0x2, 0x04),
+	BERLIN_PINCTRL_GROUP("GSM3",  "sm_base",     0x40, 0x2, 0x06),
+	BERLIN_PINCTRL_GROUP("GSM4",  "sm_base",     0x40, 0x1, 0x08),
+	BERLIN_PINCTRL_GROUP("GSM5",  "sm_base",     0x40, 0x1, 0x09),
+	BERLIN_PINCTRL_GROUP("GSM6",  "sm_base",     0x40, 0x1, 0x0a),
+	BERLIN_PINCTRL_GROUP("GSM7",  "sm_base",     0x40, 0x1, 0x0b),
+	BERLIN_PINCTRL_GROUP("GSM8",  "sm_base",     0x40, 0x1, 0x0c),
+	BERLIN_PINCTRL_GROUP("GSM9",  "sm_base",     0x40, 0x1, 0x0d),
+	BERLIN_PINCTRL_GROUP("GSM10", "sm_base",     0x40, 0x1, 0x0e),
+	BERLIN_PINCTRL_GROUP("GSM11", "sm_base",     0x40, 0x1, 0x0f),
+	BERLIN_PINCTRL_GROUP("GSM12", "sm_base",     0x40, 0x2, 0x10),
+	BERLIN_PINCTRL_GROUP("GSM13", "sm_base",     0x40, 0x2, 0x12),
+	BERLIN_PINCTRL_GROUP("GSM14", "sm_base",     0x40, 0x2, 0x14),
+	BERLIN_PINCTRL_GROUP("GSM15", "sm_base",     0x40, 0x2, 0x16),
+	BERLIN_PINCTRL_GROUP("GSM16", "sm_base",     0x40, 0x1, 0x18),
+	BERLIN_PINCTRL_GROUP("GSM17", "sm_base",     0x40, 0x1, 0x19),
+	BERLIN_PINCTRL_GROUP("GSM18", "sm_base",     0x40, 0x1, 0x1a),
+	/* G */
+	BERLIN_PINCTRL_GROUP("G0",    "global_base", 0x18, 0x3, 0x00),
+	BERLIN_PINCTRL_GROUP("G1",    "global_base", 0x18, 0x3, 0x03),
+	BERLIN_PINCTRL_GROUP("G2",    "global_base", 0x18, 0x3, 0x06),
+	BERLIN_PINCTRL_GROUP("G3",    "global_base", 0x18, 0x3, 0x09),
+	BERLIN_PINCTRL_GROUP("G4",    "global_base", 0x18, 0x3, 0x0c),
+	BERLIN_PINCTRL_GROUP("G5",    "global_base", 0x18, 0x3, 0x0f),
+	BERLIN_PINCTRL_GROUP("G6",    "global_base", 0x18, 0x3, 0x12),
+	BERLIN_PINCTRL_GROUP("G7",    "global_base", 0x18, 0x3, 0x15),
+	BERLIN_PINCTRL_GROUP("G8",    "global_base", 0x18, 0x3, 0x18),
+	BERLIN_PINCTRL_GROUP("G9",    "global_base", 0x18, 0x3, 0x1b),
+	BERLIN_PINCTRL_GROUP("G10",   "global_base", 0x1c, 0x3, 0x00),
+	BERLIN_PINCTRL_GROUP("G11",   "global_base", 0x1c, 0x3, 0x03),
+	BERLIN_PINCTRL_GROUP("G12",   "global_base", 0x1c, 0x3, 0x06),
+	BERLIN_PINCTRL_GROUP("G13",   "global_base", 0x1c, 0x3, 0x09),
+	BERLIN_PINCTRL_GROUP("G14",   "global_base", 0x1c, 0x3, 0x0c),
+	BERLIN_PINCTRL_GROUP("G15",   "global_base", 0x1c, 0x3, 0x0f),
+	BERLIN_PINCTRL_GROUP("G16",   "global_base", 0x1c, 0x3, 0x12),
+	BERLIN_PINCTRL_GROUP("G17",   "global_base", 0x1c, 0x3, 0x15),
+	BERLIN_PINCTRL_GROUP("G18",   "global_base", 0x1c, 0x3, 0x18),
+	BERLIN_PINCTRL_GROUP("G19",   "global_base", 0x1c, 0x3, 0x1b),
+	BERLIN_PINCTRL_GROUP("G20",   "global_base", 0x20, 0x3, 0x00),
+	BERLIN_PINCTRL_GROUP("G21",   "global_base", 0x20, 0x3, 0x03),
+	BERLIN_PINCTRL_GROUP("G22",   "global_base", 0x20, 0x3, 0x06),
+	BERLIN_PINCTRL_GROUP("G23",   "global_base", 0x20, 0x3, 0x09),
+	BERLIN_PINCTRL_GROUP("G24",   "global_base", 0x20, 0x3, 0x0c),
+	BERLIN_PINCTRL_GROUP("G25",   "global_base", 0x20, 0x3, 0x0f),
+	BERLIN_PINCTRL_GROUP("G26",   "global_base", 0x20, 0x3, 0x12),
+	BERLIN_PINCTRL_GROUP("G27",   "global_base", 0x20, 0x3, 0x15),
+	BERLIN_PINCTRL_GROUP("G28",   "global_base", 0x20, 0x3, 0x18),
+	BERLIN_PINCTRL_GROUP("G29",   "global_base", 0x20, 0x3, 0x1b),
+	BERLIN_PINCTRL_GROUP("G30",   "global_base", 0x24, 0x3, 0x00),
+	BERLIN_PINCTRL_GROUP("G31",   "global_base", 0x24, 0x3, 0x03),
+	BERLIN_PINCTRL_GROUP("G32",   "global_base", 0x24, 0x3, 0x06),
+	/* GAV */
+	BERLIN_PINCTRL_GROUP("GAV0",  "global_base", 0x24, 0x3, 0x09),
+	BERLIN_PINCTRL_GROUP("GAV1",  "global_base", 0x24, 0x3, 0x0c),
+	BERLIN_PINCTRL_GROUP("GAV2",  "global_base", 0x24, 0x3, 0x0f),
+	BERLIN_PINCTRL_GROUP("GAV3",  "global_base", 0x24, 0x3, 0x12),
+	BERLIN_PINCTRL_GROUP("GAV4",  "global_base", 0x24, 0x3, 0x15),
+	BERLIN_PINCTRL_GROUP("GAV5",  "global_base", 0x24, 0x3, 0x18),
+	BERLIN_PINCTRL_GROUP("GAV6",  "global_base", 0x24, 0x3, 0x1b),
+	BERLIN_PINCTRL_GROUP("GAV7",  "global_base", 0x28, 0x3, 0x00),
+	BERLIN_PINCTRL_GROUP("GAV8",  "global_base", 0x28, 0x3, 0x03),
+	BERLIN_PINCTRL_GROUP("GAV9",  "global_base", 0x28, 0x3, 0x06),
+	BERLIN_PINCTRL_GROUP("GAV10", "global_base", 0x28, 0x3, 0x09),
+	BERLIN_PINCTRL_GROUP("GAV11", "global_base", 0x28, 0x3, 0x0c),
+	BERLIN_PINCTRL_GROUP("GAV12", "global_base", 0x28, 0x3, 0x0f),
+	BERLIN_PINCTRL_GROUP("GAV13", "global_base", 0x28, 0x3, 0x12),
+	BERLIN_PINCTRL_GROUP("GAV14", "global_base", 0x28, 0x3, 0x15),
+	BERLIN_PINCTRL_GROUP("GAV15", "global_base", 0x28, 0x3, 0x18),
+	BERLIN_PINCTRL_GROUP("GAV16", "global_base", 0x28, 0x3, 0x1b),
+	BERLIN_PINCTRL_GROUP("GAV17", "global_base", 0x2c, 0x3, 0x00),
+	BERLIN_PINCTRL_GROUP("GAV18", "global_base", 0x2c, 0x3, 0x03),
+	BERLIN_PINCTRL_GROUP("GAV19", "global_base", 0x2c, 0x3, 0x06),
+};
+
+static int berlin_pinctrl_get_group_count(struct pinctrl_dev *pctrl_dev)
+{
+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
+
+	return pctrl->ngroups;
+}
+
+static const char *berlin_pinctrl_get_group_name(struct pinctrl_dev *pctrl_dev,
+						 unsigned group)
+{
+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
+
+	return pctrl->groups[group].name;
+}
+
+static int berlin_pinctrl_dt_node_to_map(struct pinctrl_dev *pctrl_dev,
+					 struct device_node *node,
+					 struct pinctrl_map **map,
+					 unsigned *num_maps)
+{
+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
+	const char *group_name;
+	char *function_name;
+	unsigned reserved_maps = 0;
+	u32 function;
+	int ret;
+
+	*map = NULL;
+	*num_maps = 0;
+
+	ret = pinctrl_utils_reserve_map(pctrl_dev, map, &reserved_maps,
+					num_maps, 1);
+	if (ret) {
+		dev_err(pctrl->dev, "can't reserve map: %d\n", ret);
+		return ret;
+	}
+
+	ret = of_property_read_u32(node, "berlin,function", &function);
+	if (ret) {
+		dev_err(pctrl->dev,
+			"missing 'berlin,function' property in node %s\n",
+			node->name);
+		return -EINVAL;
+	}
+
+	ret = of_property_read_string(node, "berlin,group", &group_name);
+	if (ret) {
+		dev_err(pctrl->dev,
+			"missing 'berlin,group' property in node %s\n",
+			node->name);
+		return -EINVAL;
+	}
+
+	function_name = kzalloc(strlen(group_name) + 7, GFP_KERNEL);
+	if (!function_name)
+		return -ENOMEM;
+	snprintf(function_name, strlen(group_name) + 7, "%s_mode%d", group_name,
+			function);
+
+	ret = pinctrl_utils_add_map_mux(pctrl_dev, map, &reserved_maps,
+					num_maps, group_name, function_name);
+	if (ret) {
+		dev_err(pctrl->dev, "can't add map: %d\n", ret);
+		return ret;
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
+	for (i = 0; i < nmaps; i++) {
+		if (map[i].type == PIN_MAP_TYPE_MUX_GROUP) {
+			kfree(map[i].data.mux.group);
+			kfree(map[i].data.mux.function);
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
+	*groups = &pctrl->functions[function].group;
+	*num_groups = 1;
+
+	return 0;
+}
+
+static int berlin_pinmux_enable(struct pinctrl_dev *pctrl_dev,
+				unsigned function,
+				unsigned group)
+{
+	struct berlin_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctrl_dev);
+	struct berlin_pinctrl_group *group_desc = pctrl->groups + group;
+	struct berlin_pinctrl_function *function_desc =
+		pctrl->functions + function;
+	unsigned long flags;
+	u32 regval;
+
+	spin_lock_irqsave(&pctrl->lock, flags);
+
+	regval = readl(group_desc->reg);
+	regval &= group_desc->mask;
+	regval |= function_desc->muxval << group_desc->lsb;
+	writel(regval, group_desc->reg);
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
+static int berlin_pinctrl_build_state(struct platform_device *pdev,
+			      struct berlin_pinctrl_reg_base *bases,
+			      unsigned nbases)
+{
+	struct berlin_pinctrl *pctrl = platform_get_drvdata(pdev);
+	int i, j, cur_fct = 0;
+
+	pctrl->ngroups = pctrl->desc->ngroups;
+	pctrl->nfunctions = 0;
+
+	for (i = 0; i < pctrl->ngroups; i++) {
+		struct berlin_desc_group const *desc = pctrl->desc->groups + i;
+		pctrl->nfunctions += NFCTS(desc->bit_width);
+	}
+
+	pctrl->groups = devm_kzalloc(&pdev->dev,
+				     pctrl->ngroups * sizeof(struct berlin_pinctrl_group),
+				     GFP_KERNEL);
+	if (!pctrl->groups)
+		return -ENOMEM;
+
+	pctrl->functions = devm_kzalloc(&pdev->dev,
+					pctrl->ngroups * pctrl->nfunctions *
+						sizeof(struct berlin_pinctrl_function),
+					GFP_KERNEL);
+	if (!pctrl->functions)
+		return -ENOMEM;
+
+	for (i = 0; i < pctrl->ngroups; i++) {
+		struct berlin_desc_group const *desc = pctrl->desc->groups + i;
+		struct berlin_pinctrl_group *group = pctrl->groups + i;
+
+		group->name = desc->name;
+		group->mask = GENMASK(desc->lsb + desc->bit_width - 1,
+				      desc->lsb);
+		group->lsb = desc->lsb;
+
+		for (j = 0; j < nbases; j++) {
+			if (!strcmp(desc->base_name, bases[j].name)) {
+				group->reg = bases[j].base + desc->offset;
+				break;
+			}
+		}
+
+		if (j == nbases) {
+			dev_err(pctrl->dev, "cannot find base address for %s\n",
+					desc->base_name);
+			return -EINVAL;
+		}
+
+		for (j = 0; j < NFCTS(desc->bit_width); j++) {
+			struct berlin_pinctrl_function *function =
+				pctrl->functions + cur_fct;
+			char *function_name = devm_kzalloc(&pdev->dev,
+							   (strlen(desc->name) + 7) * sizeof(char),
+							   GFP_KERNEL);
+			if (!function_name)
+				return -ENOMEM;
+
+			snprintf(function_name, strlen(desc->name) + 7,
+				 "%s_mode%d", desc->name, j);
+
+			function->name = function_name;
+			function->group = desc->name;
+			function->muxval = j;
+
+			cur_fct++;
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
+static const struct berlin_pinctrl_desc berlin2cd_pinctrl_data = {
+	.groups = berlin2cd_pinctrl_groups,
+	.ngroups = ARRAY_SIZE(berlin2cd_pinctrl_groups),
+};
+
+static const struct berlin_pinctrl_desc berlin2q_pinctrl_data = {
+	.groups = berlin2q_pinctrl_groups,
+	.ngroups = ARRAY_SIZE(berlin2q_pinctrl_groups),
+};
+
+static struct of_device_id berlin_pinctrl_match[] = {
+	{
+		.compatible = "marvell,berlin2cd-pinctrl",
+		.data = &berlin2cd_pinctrl_data
+	},
+	{
+		.compatible = "marvell,berlin2-pinctrl",
+		.data = &berlin2cd_pinctrl_data
+	},
+	{
+		.compatible = "marvell,berlin2q-pinctrl",
+		.data = &berlin2q_pinctrl_data
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(of, berlin_pinctrl_match);
+
+static int berlin_pinctrl_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node;
+	struct property *prop;
+	struct berlin_pinctrl *pctrl;
+	struct berlin_pinctrl_reg_base *bases;
+	const struct of_device_id *device;
+	const char *reg_name;
+	int ret, i = 0;
+	unsigned nbases;
+
+	if (!dev->of_node) {
+		dev_err(dev, "device node not found\n");
+		return -ENODEV;
+	}
+	node = dev->of_node;
+
+	pctrl = devm_kzalloc(dev, sizeof(struct berlin_pinctrl), GFP_KERNEL);
+	if (!pctrl)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, pctrl);
+
+	spin_lock_init(&pctrl->lock);
+
+	device = of_match_device(berlin_pinctrl_match, dev);
+	if (!device) {
+		dev_err(dev, "pinctrl didn't match\n");
+		return -ENODEV;
+	}
+
+	nbases = of_property_count_strings(node, "reg-names");
+	if (nbases < 0) {
+		dev_err(dev, "missing 'reg-names' property in node %s\n",
+				node->name);
+		return -EINVAL;
+	}
+
+	bases = devm_kzalloc(dev,
+			     nbases * sizeof(struct berlin_pinctrl_reg_base),
+			     GFP_KERNEL);
+	if (!bases)
+		return -ENOMEM;
+
+	of_property_for_each_string(node, "reg-names", prop, reg_name) {
+		struct resource *r =
+			platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						     reg_name);
+		bases[i].base = devm_ioremap_resource(&pdev->dev, r);
+		if (IS_ERR(bases[i].base))
+			return PTR_ERR(bases[i].base);
+
+		bases[i].name = reg_name;
+		i++;
+	}
+
+	pctrl->desc = (struct berlin_pinctrl_desc *)device->data;
+
+	ret = berlin_pinctrl_build_state(pdev, bases, nbases);
+	kfree(bases);
+	if (ret) {
+		dev_err(dev, "cannot build driver state: %d\n", ret);
+		return ret;
+	}
+
+	pctrl->dev = &pdev->dev;
+
+	pctrl->pctrl_dev = pinctrl_register(&berlin_pctrl_desc, dev, pctrl);
+	if (!pctrl->pctrl_dev) {
+		dev_err(dev, "failed to register pinctrl driver\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct platform_driver berlin_pinctrl_driver = {
+	.probe	= berlin_pinctrl_probe,
+	.driver	= {
+		.name = "berlin-pinctrl",
+		.owner = THIS_MODULE,
+		.of_match_table = berlin_pinctrl_match,
+	},
+};
+module_platform_driver(berlin_pinctrl_driver);
+
+MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
+MODULE_DESCRIPTION("Marvell Berlin pinctrl driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/pinctrl/pinctrl-berlin.h b/drivers/pinctrl/pinctrl-berlin.h
new file mode 100644
index 000000000000..db3e8a379e84
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-berlin.h
@@ -0,0 +1,72 @@
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
+struct berlin_desc_group {
+	const char	*name;
+	const char	*base_name;
+	u32		offset;
+	u32		bit_width;
+	u32		lsb;
+};
+
+struct berlin_pinctrl_base_reg {
+	void __iomem	*base;
+	const char	*name;
+};
+
+struct berlin_pinctrl_desc {
+	const struct berlin_desc_group	*groups;
+	unsigned			ngroups;
+};
+
+struct berlin_pinctrl_group {
+	const char	*name;
+	void __iomem	*reg;
+	u32		mask;
+	u32		lsb;
+};
+
+struct berlin_pinctrl_function {
+	const char	*name;
+	const char	*group;
+	u32		muxval;
+};
+
+struct berlin_pinctrl {
+	spinlock_t                      lock;
+	struct device			*dev;
+	struct berlin_pinctrl_desc	*desc;
+	struct berlin_pinctrl_group     *groups;
+	unsigned			ngroups;
+	struct berlin_pinctrl_function	*functions;
+	unsigned			nfunctions;
+	struct pinctrl_dev              *pctrl_dev;
+};
+
+struct berlin_pinctrl_reg_base {
+	const char	*name;
+	void __iomem	*base;
+};
+
+#define BERLIN_PINCTRL_GROUP(_name, _base_name, _offset, _width, _lsb)	\
+	{								\
+		.name = _name,						\
+		.base_name = _base_name,				\
+		.offset = _offset,					\
+		.bit_width = _width,					\
+		.lsb = _lsb,						\
+	}
+
+#endif /* __PINCTRL_BERLIN_H */
-- 
1.8.3.2

