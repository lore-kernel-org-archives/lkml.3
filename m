Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaEFNZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:25:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54122 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbaEFNZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:25:03 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <mturquette@linaro.org>, <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <ldewangan@nvidia.com>,
        <linux-doc@vger.kernel.org>, <nm@ti.com>, <robh+dt@kernel.org>
Subject: [PATCH v2 2/2] clk: Add driver for Palmas clk32kg and clk32kgaudio clocks
Date: Tue, 6 May 2014 16:24:45 +0300
Message-ID: <1399382685-14781-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399382685-14781-1-git-send-email-peter.ujfalusi@ti.com>
References: <1399382685-14781-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas class of devices can provide 32K clock(s) to be used by other devices
on the board. Depending on the actual device the provided clocks can be:
CLK32K_KG and CLK32K_KGAUDIO
or only one:
CLK32K_KG (TPS659039 for example)

Use separate compatible flags for the two 32K clock.
A system which needs or have only one of the 32k clock from
Palmas will need to add node(s) for each clock as separate section
in the dts file.
The two compatible property is:
"ti,palmas-clk32kg" for clk32kg clock
"ti,palmas-clk32kgaudio" for clk32kgaudio clock

Apart from the register control of the clocks - which is done via
the clock API there is a posibility to enable the external sleep
control. In this way the clock can be enabled/disabled on demand by the
user of the clock.

See the documentation for more details.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/clk/Kconfig      |   7 ++
 drivers/clk/Makefile     |   1 +
 drivers/clk/clk-palmas.c | 307 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 315 insertions(+)
 create mode 100644 drivers/clk/clk-palmas.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 6f56d3a4f010..a070b77a1e17 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -109,6 +109,13 @@ config COMMON_CLK_KEYSTONE
           Supports clock drivers for Keystone based SOCs. These SOCs have local
 	  a power sleep control module that gate the clock to the IPs and PLLs.
 
+config COMMON_CLK_PALMAS
+	tristate "Clock driver for TI Palmas devices"
+	depends on MFD_PALMAS
+	---help---
+	  This driver supports TI Palmas devices 32KHz output KG and KG_AUDIO
+	  using common clock framework.
+
 source "drivers/clk/qcom/Kconfig"
 
 endmenu
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 5f8a28735c96..d67214debc12 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_COMMON_CLK_MAX77686)	+= clk-max77686.o
 obj-$(CONFIG_ARCH_MOXART)		+= clk-moxart.o
 obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomadik.o
 obj-$(CONFIG_ARCH_NSPIRE)		+= clk-nspire.o
+obj-$(CONFIG_COMMON_CLK_PALMAS)		+= clk-palmas.o
 obj-$(CONFIG_CLK_PPC_CORENET)		+= clk-ppc-corenet.o
 obj-$(CONFIG_COMMON_CLK_S2MPS11)	+= clk-s2mps11.o
 obj-$(CONFIG_COMMON_CLK_SI5351)		+= clk-si5351.o
diff --git a/drivers/clk/clk-palmas.c b/drivers/clk/clk-palmas.c
new file mode 100644
index 000000000000..781630e1372b
--- /dev/null
+++ b/drivers/clk/clk-palmas.c
@@ -0,0 +1,307 @@
+/*
+ * Clock driver for Palmas device.
+ *
+ * Copyright (c) 2013, NVIDIA Corporation.
+ * Copyright (c) 2013-2014 Texas Instruments, Inc.
+ *
+ * Author:	Laxman Dewangan <ldewangan@nvidia.com>
+ *		Peter Ujfalusi <peter.ujfalusi@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/mfd/palmas.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define PALMAS_CLOCK_DT_EXT_CONTROL_ENABLE1	1
+#define PALMAS_CLOCK_DT_EXT_CONTROL_ENABLE2	2
+#define PALMAS_CLOCK_DT_EXT_CONTROL_NSLEEP	3
+
+struct palmas_clk32k_desc {
+	const char *clk_name;
+	unsigned int control_reg;
+	unsigned int enable_mask;
+	unsigned int sleep_mask;
+	unsigned int sleep_reqstr_id;
+	int delay;
+};
+
+struct palmas_clock_info {
+	struct device *dev;
+	struct clk *clk;
+	struct clk_hw hw;
+	struct palmas *palmas;
+	struct palmas_clk32k_desc *clk_desc;
+	int ext_control_pin;
+};
+
+static inline struct palmas_clock_info *to_palmas_clks_info(struct clk_hw *hw)
+{
+	return container_of(hw, struct palmas_clock_info, hw);
+}
+
+static unsigned long palmas_clks_recalc_rate(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	return 32768;
+}
+
+static int palmas_clks_prepare(struct clk_hw *hw)
+{
+	struct palmas_clock_info *cinfo = to_palmas_clks_info(hw);
+	int ret;
+
+	ret = palmas_update_bits(cinfo->palmas, PALMAS_RESOURCE_BASE,
+				 cinfo->clk_desc->control_reg,
+				 cinfo->clk_desc->enable_mask,
+				 cinfo->clk_desc->enable_mask);
+	if (ret < 0)
+		dev_err(cinfo->dev, "Reg 0x%02x update failed, %d\n",
+			cinfo->clk_desc->control_reg, ret);
+	else if (cinfo->clk_desc->delay)
+		udelay(cinfo->clk_desc->delay);
+
+	return ret;
+}
+
+static void palmas_clks_unprepare(struct clk_hw *hw)
+{
+	struct palmas_clock_info *cinfo = to_palmas_clks_info(hw);
+	int ret;
+
+	/*
+	 * Clock can be disabled through external pin if it is externally
+	 * controlled.
+	 */
+	if (cinfo->ext_control_pin)
+		return;
+
+	ret = palmas_update_bits(cinfo->palmas, PALMAS_RESOURCE_BASE,
+				 cinfo->clk_desc->control_reg,
+				 cinfo->clk_desc->enable_mask, 0);
+	if (ret < 0)
+		dev_err(cinfo->dev, "Reg 0x%02x update failed, %d\n",
+			cinfo->clk_desc->control_reg, ret);
+}
+
+static int palmas_clks_is_prepared(struct clk_hw *hw)
+{
+	struct palmas_clock_info *cinfo = to_palmas_clks_info(hw);
+	int ret;
+	u32 val;
+
+	if (cinfo->ext_control_pin)
+		return 1;
+
+	ret = palmas_read(cinfo->palmas, PALMAS_RESOURCE_BASE,
+			  cinfo->clk_desc->control_reg, &val);
+	if (ret < 0) {
+		dev_err(cinfo->dev, "Reg 0x%02x read failed, %d\n",
+			cinfo->clk_desc->control_reg, ret);
+		return ret;
+	}
+	return !!(val & cinfo->clk_desc->enable_mask);
+}
+
+static struct clk_ops palmas_clks_ops = {
+	.prepare	= palmas_clks_prepare,
+	.unprepare	= palmas_clks_unprepare,
+	.is_prepared	= palmas_clks_is_prepared,
+	.recalc_rate	= palmas_clks_recalc_rate,
+};
+
+struct palmas_clks_of_match_data {
+	struct clk_init_data init;
+	struct palmas_clk32k_desc desc;
+};
+
+static struct palmas_clks_of_match_data palmas_of_clk32kg = {
+	.init = {
+		.name = "clk32kg",
+		.ops = &palmas_clks_ops,
+		.flags = CLK_IS_ROOT | CLK_IGNORE_UNUSED,
+	},
+	.desc = {
+		.clk_name = "clk32kg",
+		.control_reg = PALMAS_CLK32KG_CTRL,
+		.enable_mask = PALMAS_CLK32KG_CTRL_MODE_ACTIVE,
+		.sleep_mask = PALMAS_CLK32KG_CTRL_MODE_SLEEP,
+		.sleep_reqstr_id = PALMAS_EXTERNAL_REQSTR_ID_CLK32KG,
+		.delay = 200,
+	},
+};
+
+static struct palmas_clks_of_match_data palmas_of_clk32kgaudio = {
+	.init = {
+		.name = "clk32kgaudio",
+		.ops = &palmas_clks_ops,
+		.flags = CLK_IS_ROOT | CLK_IGNORE_UNUSED,
+	},
+	.desc = {
+		.clk_name = "clk32kgaudio",
+		.control_reg = PALMAS_CLK32KGAUDIO_CTRL,
+		.enable_mask = PALMAS_CLK32KG_CTRL_MODE_ACTIVE,
+		.sleep_mask = PALMAS_CLK32KG_CTRL_MODE_SLEEP,
+		.sleep_reqstr_id = PALMAS_EXTERNAL_REQSTR_ID_CLK32KGAUDIO,
+		.delay = 200,
+	},
+};
+
+static struct of_device_id palmas_clks_of_match[] = {
+	{
+		.compatible = "ti,palmas-clk32kg",
+		.data = &palmas_of_clk32kg,
+	},
+	{
+		.compatible = "ti,palmas-clk32kgaudio",
+		.data = &palmas_of_clk32kgaudio,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, palmas_clks_of_match);
+
+static void palmas_clks_get_clk_data(struct platform_device *pdev,
+				     struct palmas_clock_info *cinfo)
+{
+	struct device_node *node = pdev->dev.of_node;
+	unsigned int prop;
+	int ret;
+
+	ret = of_property_read_u32(node, "ti,external-sleep-control",
+				   &prop);
+	if (ret)
+		return;
+
+	switch (prop) {
+	case PALMAS_CLOCK_DT_EXT_CONTROL_ENABLE1:
+		prop = PALMAS_EXT_CONTROL_ENABLE1;
+		break;
+	case PALMAS_CLOCK_DT_EXT_CONTROL_ENABLE2:
+		prop = PALMAS_EXT_CONTROL_ENABLE2;
+		break;
+	case PALMAS_CLOCK_DT_EXT_CONTROL_NSLEEP:
+		prop = PALMAS_EXT_CONTROL_NSLEEP;
+		break;
+	default:
+		dev_warn(&pdev->dev, "%s: Invalid ext control option: %u\n",
+			 node->name, prop);
+		prop = 0;
+		break;
+	}
+	cinfo->ext_control_pin = prop;
+}
+
+static int palmas_clks_init_configure(struct palmas_clock_info *cinfo)
+{
+	int ret;
+
+	ret = palmas_update_bits(cinfo->palmas, PALMAS_RESOURCE_BASE,
+				 cinfo->clk_desc->control_reg,
+				 cinfo->clk_desc->sleep_mask, 0);
+	if (ret < 0) {
+		dev_err(cinfo->dev, "Reg 0x%02x update failed, %d\n",
+			cinfo->clk_desc->control_reg, ret);
+		return ret;
+	}
+
+	if (cinfo->ext_control_pin) {
+		ret = clk_prepare(cinfo->clk);
+		if (ret < 0) {
+			dev_err(cinfo->dev, "Clock prep failed, %d\n", ret);
+			return ret;
+		}
+
+		ret = palmas_ext_control_req_config(cinfo->palmas,
+					cinfo->clk_desc->sleep_reqstr_id,
+					cinfo->ext_control_pin, true);
+		if (ret < 0) {
+			dev_err(cinfo->dev, "Ext config for %s failed, %d\n",
+				cinfo->clk_desc->clk_name, ret);
+			return ret;
+		}
+	}
+
+	return ret;
+}
+static int palmas_clks_probe(struct platform_device *pdev)
+{
+	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
+	struct device_node *node = pdev->dev.of_node;
+	struct palmas_clks_of_match_data *match_data;
+	const struct of_device_id *match;
+	struct palmas_clock_info *cinfo;
+	struct clk *clk;
+	int ret;
+
+	match = of_match_device(palmas_clks_of_match, &pdev->dev);
+	match_data = (struct palmas_clks_of_match_data *)match->data;
+
+	cinfo = devm_kzalloc(&pdev->dev, sizeof(*cinfo), GFP_KERNEL);
+	if (!cinfo)
+		return -ENOMEM;
+
+	palmas_clks_get_clk_data(pdev, cinfo);
+	platform_set_drvdata(pdev, cinfo);
+
+	cinfo->dev = &pdev->dev;
+	cinfo->palmas = palmas;
+
+	cinfo->clk_desc = &match_data->desc;
+	cinfo->hw.init = &match_data->init;
+	clk = devm_clk_register(&pdev->dev, &cinfo->hw);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		dev_err(&pdev->dev, "Fail to register clock %s, %d\n",
+			match_data->desc.clk_name, ret);
+		return ret;
+	}
+
+	cinfo->clk = clk;
+	ret = palmas_clks_init_configure(cinfo);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Clock config failed, %d\n", ret);
+		return ret;
+	}
+
+	ret = of_clk_add_provider(node, of_clk_src_simple_get, cinfo->clk);
+	if (ret < 0)
+		dev_err(&pdev->dev, "Fail to add clock driver, %d\n", ret);
+	return ret;
+}
+
+static int palmas_clks_remove(struct platform_device *pdev)
+{
+	of_clk_del_provider(pdev->dev.of_node);
+	return 0;
+}
+
+static struct platform_driver palmas_clks_driver = {
+	.driver = {
+		.name = "palmas-clk",
+		.owner = THIS_MODULE,
+		.of_match_table = palmas_clks_of_match,
+	},
+	.probe = palmas_clks_probe,
+	.remove = palmas_clks_remove,
+};
+
+module_platform_driver(palmas_clks_driver);
+
+MODULE_DESCRIPTION("Clock driver for Palmas Series Devices");
+MODULE_ALIAS("platform:palmas-clk");
+MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@ti.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.9.2

