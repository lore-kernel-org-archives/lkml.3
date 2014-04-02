Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbaDBNzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:55:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37209 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758681AbaDBNzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:55:49 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Tero Kristo <t-kristo@ti.com>, Mike Turquette <mturquette@linaro.org>
CC: Benoit Cousson <bcousson@baylibre.com>, Tony Lindgren <tony@atomide.com>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/3] clk: Driver for DRA7 ATL (Audio Tracking Logic)
Date: Wed, 2 Apr 2014 16:55:06 +0300
Message-ID: <1396446907-20383-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396446907-20383-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396446907-20383-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Audio Tracking Logic is designed to be used by HD Radio
applications to synchronize the audio output clocks to the
baseband clock. ATL can be also used to track errors between
two reference clocks (BWS, AWS) and generate a modulated
clock output which averages to some desired frequency.

The ATL IP in DRA7 contains 4 ATL instences.

To be able to integrate the ATL provided clocks to the clock tree we need
two types of DT binding:
- DT clock nodes to represent the ATL clocks towards the CCF
- binding for the ATL IP itself which is going to handle the hw
  configuration

The reason for this type of setup is that ATL itself is a separate device
in the SoC, it has it's own address space and clock domain. Other IPs can
use the ATL generated clock as their functional clock (McASPs for example)
and external components like audio codecs can also use the very same clock
as their MCLK.

With setup pm_runtime can handle the ATL clock on demand of it's use and
all the IP which needs ATL clock can be sure that it is enabled for them.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 .../devicetree/bindings/clock/ti/dra7-atl.txt      |  97 +++++++
 drivers/clk/ti/Makefile                            |   3 +-
 drivers/clk/ti/clk-dra7-atl.c                      | 313 +++++++++++++++++++++
 include/dt-bindings/clk/ti-dra7-atl.h              |  40 +++
 4 files changed, 452 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/clock/ti/dra7-atl.txt
 create mode 100644 drivers/clk/ti/clk-dra7-atl.c
 create mode 100644 include/dt-bindings/clk/ti-dra7-atl.h

diff --git a/Documentation/devicetree/bindings/clock/ti/dra7-atl.txt b/Documentation/devicetree/bindings/clock/ti/dra7-atl.txt
new file mode 100644
index 000000000000..c90e63c443ef
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/ti/dra7-atl.txt
@@ -0,0 +1,97 @@
+Device Tree Clock bindings for ATL (Audio Tracking Logic) of DRA7 SoC.
+
+The ATL IP is used to generate clock to be used to synchronize baseband and
+audio codec. A single ATL IP provides four ATL clock instances sharing the same
+functional clock but can be configured to provide different clocks.
+ATL can maintain a clock averages to some desired frequency based on the bws/aws
+signals - can compensate the drift between the two ws signal.
+
+In order to provide the support for ATL and it's output clocks (which can be used
+internally within the SoC or external components) two sets of bindings is needed:
+
+Clock tree binding:
+This binding uses the common clock binding[1].
+To be able to integrate the ATL clocks with DT clock tree.
+Provides ccf level representation of the ATL clocks to be used by drivers.
+Since the clock instances are part of a single IP this binding is used as a node
+for the DT clock tree, the IP driver is needed to handle the actual configuration
+of the IP.
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be "ti,dra7-atl-clock"
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : link phandles to functional clock of ATL
+
+Binding for the IP driver:
+This binding is used to configure the IP driver which is going to handle the
+configuration of the IP for the ATL clock instances.
+
+Required properties:
+- compatible : shall be "ti,dra7-atl"
+- reg : base address for the ATL IP
+- ti,provided-clocks : List of phandles to the clocks associated with the ATL
+- clocks : link phandles to functional clock of ATL
+- clock-names : Shall be set to "fck"
+- ti,hwmods : Shall be set to "atl"
+
+Optional properties:
+Configuration of ATL instances:
+- atl{0/1/2/3} {
+	- bws : Baseband word select signal selection
+	- aws : Audio word select signal selection
+};
+
+For valid word select signals, see the dt-bindings/clk/ti-dra7-atl.h include
+file.
+
+Examples:
+/* clock bindings for atl provided clocks */
+atl_clkin0_ck: atl_clkin0_ck {
+	#clock-cells = <0>;
+	compatible = "ti,dra7-atl-clock";
+	clocks = <&atl_gfclk_mux>;
+};
+
+atl_clkin1_ck: atl_clkin1_ck {
+	#clock-cells = <0>;
+	compatible = "ti,dra7-atl-clock";
+	clocks = <&atl_gfclk_mux>;
+};
+
+atl_clkin2_ck: atl_clkin2_ck {
+	#clock-cells = <0>;
+	compatible = "ti,dra7-atl-clock";
+	clocks = <&atl_gfclk_mux>;
+};
+
+atl_clkin3_ck: atl_clkin3_ck {
+	#clock-cells = <0>;
+	compatible = "ti,dra7-atl-clock";
+	clocks = <&atl_gfclk_mux>;
+};
+
+/* binding for the IP */
+atl: atl@4843c000 {
+	compatible = "ti,dra7-atl";
+	reg = <0x4843c000 0x3ff>;
+	ti,hwmods = "atl";
+	ti,provided-clocks = <&atl_clkin0_ck>, <&atl_clkin1_ck>,
+				<&atl_clkin2_ck>, <&atl_clkin3_ck>;
+	clocks = <&atl_gfclk_mux>;
+	clock-names = "fck";
+	status = "disabled";
+};
+
+#include <dt-bindings/clk/ti-dra7-atl.h>
+
+&atl {
+	status = "okay";
+
+	atl2 {
+		bws = <DRA7_ATL_WS_MCASP2_FSX>;
+		aws = <DRA7_ATL_WS_MCASP3_FSX>;
+	};
+};
+
diff --git a/drivers/clk/ti/Makefile b/drivers/clk/ti/Makefile
index 4319d4031aa3..18e2443224e6 100644
--- a/drivers/clk/ti/Makefile
+++ b/drivers/clk/ti/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_SOC_AM33XX)		+= $(clk-common) clk-33xx.o
 obj-$(CONFIG_ARCH_OMAP3)		+= $(clk-common) interface.o clk-3xxx.o
 obj-$(CONFIG_ARCH_OMAP4)		+= $(clk-common) clk-44xx.o
 obj-$(CONFIG_SOC_OMAP5)			+= $(clk-common) clk-54xx.o
-obj-$(CONFIG_SOC_DRA7XX)		+= $(clk-common) clk-7xx.o
+obj-$(CONFIG_SOC_DRA7XX)		+= $(clk-common) clk-7xx.o \
+					   clk-dra7-atl.o
 obj-$(CONFIG_SOC_AM43XX)		+= $(clk-common) clk-43xx.o
 endif
diff --git a/drivers/clk/ti/clk-dra7-atl.c b/drivers/clk/ti/clk-dra7-atl.c
new file mode 100644
index 000000000000..97a8992eebb7
--- /dev/null
+++ b/drivers/clk/ti/clk-dra7-atl.c
@@ -0,0 +1,313 @@
+/*
+ * DRA7 ATL (Audio Tracking Logic) clock driver
+ *
+ * Copyright (C) 2013 Texas Instruments, Inc.
+ *
+ * Peter Ujfalusi <peter.ujfalusi@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/clk-provider.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#define DRA7_ATL_INSTANCES	4
+
+#define DRA7_ATL_PPMR_REG(id)		(0x200 + (id * 0x80))
+#define DRA7_ATL_BBSR_REG(id)		(0x204 + (id * 0x80))
+#define DRA7_ATL_ATLCR_REG(id)		(0x208 + (id * 0x80))
+#define DRA7_ATL_SWEN_REG(id)		(0x210 + (id * 0x80))
+#define DRA7_ATL_BWSMUX_REG(id)		(0x214 + (id * 0x80))
+#define DRA7_ATL_AWSMUX_REG(id)		(0x218 + (id * 0x80))
+#define DRA7_ATL_PCLKMUX_REG(id)	(0x21c + (id * 0x80))
+
+#define DRA7_ATL_SWEN			BIT(0)
+#define DRA7_ATL_DIVIDER_MASK		(0x1f)
+#define DRA7_ATL_PCLKMUX		BIT(0)
+struct dra7_atl_clock_info;
+
+struct dra7_atl_desc {
+	struct clk *clk;
+	struct clk_hw hw;
+	struct dra7_atl_clock_info *cinfo;
+	int id;
+
+	bool probed;		/* the driver for the IP has been loaded */
+	bool valid;		/* configured */
+	bool enabled;
+	u32 bws;		/* Baseband Word Select Mux */
+	u32 aws;		/* Audio Word Select Mux */
+	u32 divider;		/* Cached divider value */
+};
+
+struct dra7_atl_clock_info {
+	struct device *dev;
+	void __iomem *iobase;
+
+	struct dra7_atl_desc *cdesc;
+};
+
+#define to_atl_desc(_hw)	container_of(_hw, struct dra7_atl_desc, hw)
+
+static inline void atl_write(struct dra7_atl_clock_info *cinfo, u32 reg,
+			     u32 val)
+{
+	__raw_writel(val, cinfo->iobase + reg);
+}
+
+static inline int atl_read(struct dra7_atl_clock_info *cinfo, u32 reg)
+{
+	return __raw_readl(cinfo->iobase + reg);
+}
+
+static int atl_clk_enable(struct clk_hw *hw)
+{
+	struct dra7_atl_desc *cdesc = to_atl_desc(hw);
+
+	if (!cdesc->probed)
+		goto out;
+
+	if (unlikely(!cdesc->valid))
+		dev_warn(cdesc->cinfo->dev, "atl%d has not been configured\n",
+			 cdesc->id);
+	pm_runtime_get_sync(cdesc->cinfo->dev);
+
+	atl_write(cdesc->cinfo, DRA7_ATL_ATLCR_REG(cdesc->id),
+		  cdesc->divider - 1);
+	atl_write(cdesc->cinfo, DRA7_ATL_SWEN_REG(cdesc->id), DRA7_ATL_SWEN);
+
+out:
+	cdesc->enabled = true;
+
+	return 0;
+}
+
+static void atl_clk_disable(struct clk_hw *hw)
+{
+	struct dra7_atl_desc *cdesc = to_atl_desc(hw);
+
+	if (!cdesc->probed)
+		goto out;
+
+	atl_write(cdesc->cinfo, DRA7_ATL_SWEN_REG(cdesc->id), 0);
+	pm_runtime_put_sync(cdesc->cinfo->dev);
+
+out:
+	cdesc->enabled = false;
+}
+
+static int atl_clk_is_enabled(struct clk_hw *hw)
+{
+	struct dra7_atl_desc *cdesc = to_atl_desc(hw);
+
+	return cdesc->enabled;
+}
+
+static unsigned long atl_clk_recalc_rate(struct clk_hw *hw,
+					 unsigned long parent_rate)
+{
+	struct dra7_atl_desc *cdesc = to_atl_desc(hw);
+
+	return parent_rate / cdesc->divider;
+}
+
+static long atl_clk_round_rate(struct clk_hw *hw, unsigned long rate,
+			       unsigned long *parent_rate)
+{
+	unsigned divider;
+
+	divider = (*parent_rate + rate / 2) / rate;
+	if (divider > DRA7_ATL_DIVIDER_MASK + 1)
+		divider = DRA7_ATL_DIVIDER_MASK + 1;
+
+	return *parent_rate / divider;
+}
+
+static int atl_clk_set_rate(struct clk_hw *hw, unsigned long rate,
+			    unsigned long parent_rate)
+{
+	struct dra7_atl_desc *cdesc = to_atl_desc(hw);
+	u32 divider;
+
+	divider = ((parent_rate + rate / 2) / rate) - 1;
+	if (divider > DRA7_ATL_DIVIDER_MASK)
+		divider = DRA7_ATL_DIVIDER_MASK;
+
+	cdesc->divider = divider + 1;
+
+	return 0;
+}
+
+const struct clk_ops atl_clk_ops = {
+	.enable		= atl_clk_enable,
+	.disable	= atl_clk_disable,
+	.is_enabled	= atl_clk_is_enabled,
+	.recalc_rate	= atl_clk_recalc_rate,
+	.round_rate	= atl_clk_round_rate,
+	.set_rate	= atl_clk_set_rate,
+};
+
+static void __init of_dra7_atl_clock_setup(struct device_node *node)
+{
+	struct dra7_atl_desc *clk_hw = NULL;
+	struct clk_init_data init = { 0 };
+	const char **parent_names = NULL;
+	struct clk *clk;
+
+	clk_hw = kzalloc(sizeof(*clk_hw), GFP_KERNEL);
+	if (!clk_hw) {
+		pr_err("%s: could not allocate dra7_atl_desc\n", __func__);
+		return;
+	}
+
+	clk_hw->hw.init = &init;
+	clk_hw->divider = 1;
+	init.name = node->name;
+	init.ops = &atl_clk_ops;
+	init.flags = CLK_IGNORE_UNUSED;
+	init.num_parents = of_clk_get_parent_count(node);
+
+	if (init.num_parents != 1) {
+		pr_err("%s: atl clock %s must have 1 parent\n", __func__,
+		       node->name);
+		goto cleanup;
+	}
+
+	parent_names = kzalloc(sizeof(char *), GFP_KERNEL);
+
+	if (!parent_names)
+		goto cleanup;
+
+	parent_names[0] = of_clk_get_parent_name(node, 0);
+
+	init.parent_names = parent_names;
+
+	clk = clk_register(NULL, &clk_hw->hw);
+
+	if (!IS_ERR(clk)) {
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+		return;
+	}
+cleanup:
+	kfree(parent_names);
+	kfree(clk_hw);
+}
+CLK_OF_DECLARE(dra7_atl_clock, "ti,dra7-atl-clock", of_dra7_atl_clock_setup);
+
+static int of_dra7_atl_clk_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct dra7_atl_clock_info *cinfo;
+	int i;
+	int ret = 0;
+
+	if (!node)
+		return -ENODEV;
+
+	cinfo = devm_kzalloc(&pdev->dev, sizeof(*cinfo), GFP_KERNEL);
+	if (!cinfo)
+		return -ENOMEM;
+
+	cinfo->iobase = of_iomap(node, 0);
+	cinfo->dev = &pdev->dev;
+	pm_runtime_enable(cinfo->dev);
+
+	pm_runtime_get_sync(cinfo->dev);
+	atl_write(cinfo, DRA7_ATL_PCLKMUX_REG(0), DRA7_ATL_PCLKMUX);
+
+	for (i = 0; i < DRA7_ATL_INSTANCES; i++) {
+		struct device_node *cfg_node;
+		char prop[5];
+		struct dra7_atl_desc *cdesc;
+		struct of_phandle_args clkspec;
+		struct clk *clk;
+		int rc;
+
+		rc = of_parse_phandle_with_args(node, "ti,provided-clocks",
+						NULL, i, &clkspec);
+
+		if (rc) {
+			pr_err("%s: failed to lookup atl clock %d\n", __func__,
+			       i);
+			return -EINVAL;
+		}
+
+		clk = of_clk_get_from_provider(&clkspec);
+
+		cdesc = to_atl_desc(__clk_get_hw(clk));
+		cdesc->cinfo = cinfo;
+		cdesc->id = i;
+
+		/* Get configuration for the ATL instances */
+		snprintf(prop, sizeof(prop), "atl%u", i);
+		cfg_node = of_find_node_by_name(node, prop);
+		if (cfg_node) {
+			ret = of_property_read_u32(cfg_node, "bws",
+						   &cdesc->bws);
+			ret |= of_property_read_u32(cfg_node, "aws",
+						    &cdesc->aws);
+			if (!ret) {
+				cdesc->valid = true;
+				atl_write(cinfo, DRA7_ATL_BWSMUX_REG(i),
+					  cdesc->bws);
+				atl_write(cinfo, DRA7_ATL_AWSMUX_REG(i),
+					  cdesc->aws);
+			}
+		}
+
+		cdesc->probed = true;
+		/*
+		 * Enable the clock if it has been asked prior to loading the
+		 * hw driver
+		 */
+		if (cdesc->enabled)
+			atl_clk_enable(__clk_get_hw(clk));
+	}
+	pm_runtime_put_sync(cinfo->dev);
+
+	return ret;
+}
+
+static int of_dra7_atl_clk_remove(struct platform_device *pdev)
+{
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
+static struct of_device_id of_dra7_atl_clk_match_tbl[] = {
+	{ .compatible = "ti,dra7-atl", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_dra7_atl_clk_match_tbl);
+
+static struct platform_driver dra7_atl_clk_driver = {
+	.driver = {
+		.name = "dra7-atl",
+		.owner = THIS_MODULE,
+		.of_match_table = of_dra7_atl_clk_match_tbl,
+	},
+	.probe = of_dra7_atl_clk_probe,
+	.remove = of_dra7_atl_clk_remove,
+};
+
+module_platform_driver(dra7_atl_clk_driver);
+
+MODULE_DESCRIPTION("Clock driver for DRA7 Audio Tracking Logic");
+MODULE_ALIAS("platform:dra7-atl-clock");
+MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@ti.com>");
+MODULE_LICENSE("GPL v2");
+
diff --git a/include/dt-bindings/clk/ti-dra7-atl.h b/include/dt-bindings/clk/ti-dra7-atl.h
new file mode 100644
index 000000000000..42dd4164f6f4
--- /dev/null
+++ b/include/dt-bindings/clk/ti-dra7-atl.h
@@ -0,0 +1,40 @@
+/*
+ * This header provides constants for DRA7 ATL (Audio Tracking Logic)
+ *
+ * The constants defined in this header are used in dts files
+ *
+ * Copyright (C) 2013 Texas Instruments, Inc.
+ *
+ * Peter Ujfalusi <peter.ujfalusi@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _DT_BINDINGS_CLK_DRA7_ATL_H
+#define _DT_BINDINGS_CLK_DRA7_ATL_H
+
+#define DRA7_ATL_WS_MCASP1_FSR		0
+#define DRA7_ATL_WS_MCASP1_FSX		1
+#define DRA7_ATL_WS_MCASP2_FSR		2
+#define DRA7_ATL_WS_MCASP2_FSX		3
+#define DRA7_ATL_WS_MCASP3_FSX		4
+#define DRA7_ATL_WS_MCASP4_FSX		5
+#define DRA7_ATL_WS_MCASP5_FSX		6
+#define DRA7_ATL_WS_MCASP6_FSX		7
+#define DRA7_ATL_WS_MCASP7_FSX		8
+#define DRA7_ATL_WS_MCASP8_FSX		9
+#define DRA7_ATL_WS_MCASP8_AHCLKX	10
+#define DRA7_ATL_WS_XREF_CLK3		11
+#define DRA7_ATL_WS_XREF_CLK0		12
+#define DRA7_ATL_WS_XREF_CLK1		13
+#define DRA7_ATL_WS_XREF_CLK2		14
+#define DRA7_ATL_WS_OSC1_X1		15
+
+#endif
-- 
1.9.1

