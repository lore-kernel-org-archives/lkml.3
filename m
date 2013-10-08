Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3JHM4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:56:49 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13319 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab3JHM4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:56:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 08 Oct 2013 05:56:45 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <mturquette@linaro.org>
CC: <broonie@linaro.org>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <grant.likely@linaro.org>, <rob@landley.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <swarren@nvidia.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3] clk: palmas: add clock driver for palmas
Date: Tue, 8 Oct 2013 18:51:20 +0530
Message-ID: <1381238480-18852-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas devices has two clock output CLK32K_KG and CLK32K_KG_AUDIO
which can be enable/disable through software.

Add clock driver support for the Palmas 32KHz clocks.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1: 
- Call prepare if the clk is needed for boot-enable or sleep control.
- change is_enabled to is_prepared.
- Added ops palmas_clks_recalc_rate.
- Added of_clk_add_provider().

Changes from V2:
- Convert magic number to defines.

 .../devicetree/bindings/clock/clk-palmas.txt       |   45 +++
 drivers/clk/Kconfig                                |    7 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-palmas.c                           |  340 ++++++++++++++++++++
 4 files changed, 393 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/clk-palmas.txt
 create mode 100644 drivers/clk/clk-palmas.c

diff --git a/Documentation/devicetree/bindings/clock/clk-palmas.txt b/Documentation/devicetree/bindings/clock/clk-palmas.txt
new file mode 100644
index 0000000..c247538
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/clk-palmas.txt
@@ -0,0 +1,45 @@
+* Palmas 32KHz clocks *
+
+Palmas device has two clock output pins for 32KHz, KG and KG_AUDIO.
+
+This binding uses the common clock binding ./clock-bindings.txt.
+
+Clock 32KHz KG is output 0 of the driver and clock 32KHz is output 1.
+
+Required properties:
+- compatible : shall be "ti,palmas-clk".
+- #clock-cells : from common clock binding; shall be set to 1.
+
+Optional subnode:
+	The clock node has optional subnode to provide the init configuration of
+	clocks like boot enable, sleep control.
+
+	The subnode name is fixed and it should be
+		clk32k_kg for the 32KHz KG clock.
+		clk32k_kg_audio for the 32KHz KG_AUDIO clock.
+
+	Optional subnode properties:
+	ti,clock-boot-enable: Enable clock at the time of booting.
+	ti,external-sleep-control: The clock is enable/disabled by state
+		of external enable input pins ENABLE, ENABLE2 and NSLEEP.
+		The valid value for the external pins are:
+			1 for ENABLE1
+			2 for ENABLE2
+			3 for NSLEEP.
+		Option 0 or missing this property means the clock is
+		enabled/disabled via register access and these pins do
+		not have any control.
+
+Example:
+	clock {
+		compatible = "ti,palmas-clk";
+		#clock-cells = <1>;
+		clk32k_kg {
+			ti,clock-boot-enable;
+			ti,external-sleep-control = <3>;
+		};
+
+		clk32k_kg_audio {
+			ti,clock-boot-enable;
+		};
+	};
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 279407a..6b8c233 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -93,6 +93,13 @@ config CLK_PPC_CORENET
 	  This adds the clock driver support for Freescale PowerPC corenet
 	  platforms using common clock framework.
 
+config COMMON_CLK_PALMAS
+	tristate "Clock driver for TI Palmas devices"
+	depends on MFD_PALMAS
+	---help---
+	  This driver supports TI Palmas devices 32KHz output KG and KG_AUDIO
+	  using common clock framework.
+
 endmenu
 
 source "drivers/clk/mvebu/Kconfig"
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 7b11106..32e04cf 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -43,3 +43,4 @@ obj-$(CONFIG_COMMON_CLK_SI5351) += clk-si5351.o
 obj-$(CONFIG_COMMON_CLK_S2MPS11) += clk-s2mps11.o
 obj-$(CONFIG_CLK_TWL6040)	+= clk-twl6040.o
 obj-$(CONFIG_CLK_PPC_CORENET)	+= clk-ppc-corenet.o
+obj-$(CONFIG_COMMON_CLK_PALMAS)	+= clk-palmas.o
diff --git a/drivers/clk/clk-palmas.c b/drivers/clk/clk-palmas.c
new file mode 100644
index 0000000..3e070b2
--- /dev/null
+++ b/drivers/clk/clk-palmas.c
@@ -0,0 +1,340 @@
+/*
+ * Clock driver for Palmas device.
+ *
+ * Copyright (c) 2013, NVIDIA Corporation.
+ *
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307, USA
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
+enum PALMAS_CLOCK32K {
+	PALMAS_CLOCK32KG,
+	PALMAS_CLOCK32KG_AUDIO,
+
+	/* Last entry */
+	PALMAS_CLOCK32K_NR,
+};
+
+#define PALMAS_CLOCK_DT_EXT_CONTROL_ENABLE1	1
+#define PALMAS_CLOCK_DT_EXT_CONTROL_ENABLE2	2
+#define PALMAS_CLOCK_DT_EXT_CONTROL_NSLEEP	3
+
+struct palmas_clks;
+
+struct palmas_clk32k_desc {
+	const char *clk_name;
+	unsigned int control_reg;
+	unsigned int enable_mask;
+	unsigned int sleep_mask;
+	unsigned int sleep_reqstr_id;
+};
+
+struct palmas_clock_info {
+	struct clk *clk;
+	struct clk_hw hw;
+	struct palmas_clk32k_desc *clk_desc;
+	struct palmas_clks *palmas_clk;
+	int ext_control_pin;
+	bool boot_enable;
+};
+
+struct palmas_clks {
+	struct device *dev;
+	struct palmas *palmas;
+	struct clk_onecell_data clk_data;
+	struct palmas_clock_info clk_info[PALMAS_CLOCK32K_NR];
+};
+
+static struct palmas_clk32k_desc palmas_clk32k_descs[] = {
+	{
+		.clk_name = "clk32k_kg",
+		.control_reg = PALMAS_CLK32KG_CTRL,
+		.enable_mask = PALMAS_CLK32KG_CTRL_MODE_ACTIVE,
+		.sleep_mask = PALMAS_CLK32KG_CTRL_MODE_SLEEP,
+		.sleep_reqstr_id = PALMAS_EXTERNAL_REQSTR_ID_CLK32KG,
+	}, {
+		.clk_name = "clk32k_kg_audio",
+		.control_reg = PALMAS_CLK32KGAUDIO_CTRL,
+		.enable_mask = PALMAS_CLK32KG_CTRL_MODE_ACTIVE,
+		.sleep_mask = PALMAS_CLK32KG_CTRL_MODE_SLEEP,
+		.sleep_reqstr_id = PALMAS_EXTERNAL_REQSTR_ID_CLK32KGAUDIO,
+	},
+};
+
+static inline struct palmas_clock_info *to_palmas_clks_info(struct clk_hw *hw)
+{
+	return container_of(hw, struct palmas_clock_info, hw);
+}
+
+static unsigned long palmas_clks_recalc_rate(struct clk_hw *hw,
+	unsigned long parent_rate)
+{
+	return 32768;
+}
+
+static int palmas_clks_prepare(struct clk_hw *hw)
+{
+	struct palmas_clock_info *cinfo = to_palmas_clks_info(hw);
+	struct palmas_clks *palmas_clks = cinfo->palmas_clk;
+	int ret;
+
+	ret = palmas_update_bits(palmas_clks->palmas, PALMAS_RESOURCE_BASE,
+			cinfo->clk_desc->control_reg,
+			cinfo->clk_desc->enable_mask,
+			cinfo->clk_desc->enable_mask);
+	if (ret < 0)
+		dev_err(palmas_clks->dev, "Reg 0x%02x update failed, %d\n",
+			cinfo->clk_desc->control_reg, ret);
+
+	return ret;
+}
+
+static void palmas_clks_unprepare(struct clk_hw *hw)
+{
+	struct palmas_clock_info *cinfo = to_palmas_clks_info(hw);
+	struct palmas_clks *palmas_clks = cinfo->palmas_clk;
+	int ret;
+
+	/*
+	 * Clock can be disabled through external pin if it is externally
+	 * controlled.
+	 */
+	if (cinfo->ext_control_pin)
+		return;
+
+	ret = palmas_update_bits(palmas_clks->palmas, PALMAS_RESOURCE_BASE,
+			cinfo->clk_desc->control_reg,
+			cinfo->clk_desc->enable_mask, 0);
+	if (ret < 0)
+		dev_err(palmas_clks->dev, "Reg 0x%02x update failed, %d\n",
+			cinfo->clk_desc->control_reg, ret);
+
+}
+
+static int palmas_clks_is_prepared(struct clk_hw *hw)
+{
+	struct palmas_clock_info *cinfo = to_palmas_clks_info(hw);
+	struct palmas_clks *palmas_clks = cinfo->palmas_clk;
+	int ret;
+	u32 val;
+
+	if (cinfo->ext_control_pin)
+		return 1;
+
+	ret = palmas_read(palmas_clks->palmas, PALMAS_RESOURCE_BASE,
+			cinfo->clk_desc->control_reg, &val);
+	if (ret < 0) {
+		dev_err(palmas_clks->dev, "Reg 0x%02x read failed, %d\n",
+				cinfo->clk_desc->control_reg, ret);
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
+static struct clk_init_data palmas_clks_hw_init[PALMAS_CLOCK32K_NR] = {
+	[PALMAS_CLOCK32KG] = {
+		.name = "clk32k_kg",
+		.ops = &palmas_clks_ops,
+		.flags = CLK_IS_ROOT | CLK_IGNORE_UNUSED,
+	},
+	[PALMAS_CLOCK32KG_AUDIO] = {
+		.name = "clk32k_kg_audio",
+		.ops = &palmas_clks_ops,
+		.flags = CLK_IS_ROOT | CLK_IGNORE_UNUSED,
+	},
+};
+
+static int palmas_clks_get_clk_data(struct platform_device *pdev,
+	struct palmas_clks *palmas_clks)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct device_node *child;
+	struct palmas_clock_info *cinfo;
+	unsigned int prop;
+	int ret;
+	int i;
+
+	for (i = 0; i < PALMAS_CLOCK32K_NR; ++i) {
+		child = of_get_child_by_name(node,
+				palmas_clk32k_descs[i].clk_name);
+		if (!child)
+			continue;
+
+		cinfo = &palmas_clks->clk_info[i];
+		cinfo->boot_enable = of_property_read_bool(child,
+						"ti,clock-boot-enable");
+		ret = of_property_read_u32(child, "ti,external-sleep-control",
+					&prop);
+		if (!ret) {
+			switch (prop) {
+			case PALMAS_CLOCK_DT_EXT_CONTROL_ENABLE1:
+				prop = PALMAS_EXT_CONTROL_ENABLE1;
+				break;
+			case PALMAS_CLOCK_DT_EXT_CONTROL_ENABLE2:
+				prop = PALMAS_EXT_CONTROL_ENABLE2;
+				break;
+			case PALMAS_CLOCK_DT_EXT_CONTROL_NSLEEP:
+				prop = PALMAS_EXT_CONTROL_NSLEEP;
+				break;
+			default:
+				WARN_ON(1);
+				dev_warn(&pdev->dev,
+					"%s: Invalid ext control option: %u\n",
+					child->name, prop);
+				prop = 0;
+				break;
+			}
+			cinfo->ext_control_pin = prop;
+		}
+	}
+
+	return 0;
+}
+
+static int palmas_clks_init_configure(struct palmas_clock_info *cinfo)
+{
+	struct palmas_clks *palmas_clks = cinfo->palmas_clk;
+	int ret;
+
+	if (cinfo->boot_enable || cinfo->ext_control_pin) {
+		ret = clk_prepare(cinfo->clk);
+		if (ret < 0) {
+			dev_err(palmas_clks->dev,
+				"Clock prep failed, %d\n", ret);
+			return ret;
+		}
+	}
+
+	ret = palmas_update_bits(palmas_clks->palmas, PALMAS_RESOURCE_BASE,
+			cinfo->clk_desc->control_reg,
+			cinfo->clk_desc->sleep_mask, 0);
+	if (ret < 0) {
+		dev_err(palmas_clks->dev, "Reg 0x%02x update failed, %d\n",
+			cinfo->clk_desc->control_reg, ret);
+		return ret;
+	}
+
+	if (cinfo->ext_control_pin) {
+		ret = palmas_ext_control_req_config(palmas_clks->palmas,
+				cinfo->clk_desc->sleep_reqstr_id,
+				cinfo->ext_control_pin, true);
+		if (ret < 0) {
+			dev_err(palmas_clks->dev,
+				"Ext config for %s failed, %d\n",
+				cinfo->clk_desc->clk_name, ret);
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+static int palmas_clks_probe(struct platform_device *pdev)
+{
+	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
+	struct palmas_clock_info *cinfo;
+	struct palmas_clks *palmas_clks;
+	struct clk *clk;
+	int i, ret;
+
+	palmas_clks = devm_kzalloc(&pdev->dev, sizeof(*palmas_clks),
+				GFP_KERNEL);
+	if (!palmas_clks)
+		return -ENOMEM;
+
+	palmas_clks->clk_data.clks = devm_kzalloc(&pdev->dev,
+			PALMAS_CLOCK32K_NR * sizeof(palmas_clks->clk_data.clks),
+			GFP_KERNEL);
+	if (!palmas_clks->clk_data.clks)
+		return -ENOMEM;
+
+	palmas_clks_get_clk_data(pdev, palmas_clks);
+	platform_set_drvdata(pdev, palmas_clks);
+
+	palmas_clks->dev = &pdev->dev;
+	palmas_clks->palmas = palmas;
+
+	for (i = 0; i < PALMAS_CLOCK32K_NR; i++) {
+		cinfo = &palmas_clks->clk_info[i];
+		cinfo->clk_desc = &palmas_clk32k_descs[i];
+		cinfo->hw.init = &palmas_clks_hw_init[i];
+		cinfo->palmas_clk = palmas_clks;
+		clk = devm_clk_register(&pdev->dev, &cinfo->hw);
+		if (IS_ERR(clk)) {
+			ret = PTR_ERR(clk);
+			dev_err(&pdev->dev, "Fail to register clock %s, %d\n",
+				palmas_clk32k_descs[i].clk_name, ret);
+			return ret;
+		}
+
+		cinfo->clk = clk;
+		palmas_clks->clk_data.clks[i] = clk;
+		palmas_clks->clk_data.clk_num++;
+		palmas_clks_init_configure(cinfo);
+	}
+
+	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_simple_get,
+			&palmas_clks->clk_data);
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
+static struct of_device_id of_palmas_clks_match_tbl[] = {
+	{ .compatible = "ti,palmas-clk", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, of_palmas_clks_match_tbl);
+
+static struct platform_driver palmas_clks_driver = {
+	.driver = {
+		.name = "palmas-clk",
+		.owner = THIS_MODULE,
+		.of_match_table = of_palmas_clks_match_tbl,
+	},
+	.probe = palmas_clks_probe,
+	.remove = palmas_clks_remove,
+};
+
+module_platform_driver(palmas_clks_driver);
+
+MODULE_DESCRIPTION("Clock driver for Palmas Series Devices");
+MODULE_ALIAS("platform:palmas-clk");
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.1.1

