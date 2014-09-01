Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaIAJrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:47:00 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:33774 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752377AbaIAJq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:46:59 -0400
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <cfe9d79da80ab6ac405904092192acba>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Chris Zhong <zyw@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com,
        Chris Zhong <zyw@rock-chips.com>
Subject: [PATCH v7 4/5] clk: RK808: Add clkout driver for RK808
Date: Mon,  1 Sep 2014 17:46:40 +0800
Message-Id: <1409564800-18477-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>
References: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Zhong <zyw@rock-chips.com>


Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
---

Changes in v7:
Adviced by doug
-fix coding style problems

Changes in v6:
Adviced by doug
- use correct argument call of_clk_add_provider in probe

Changes in v5:
Adviced by doug
- add some error checking in probe
- move "rockchip,rk808.h" into the patch about dt-bindings

Changes in v4:
Adviced by doug
- add "clock-output-names" propertiey
- add a header file "rockchip,rk808.h"

Changes in v3:
- fix compile err

Changes in v2:
Adviced by javier.martinez
- separated from rtc-rk808.c

 drivers/clk/Kconfig     |    9 +++
 drivers/clk/Makefile    |    1 +
 drivers/clk/clk-rk808.c |  160 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 170 insertions(+)
 create mode 100644 drivers/clk/clk-rk808.c

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index cfd3af7..84e0590 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -38,6 +38,15 @@ config COMMON_CLK_MAX77686
 	---help---
 	  This driver supports Maxim 77686 crystal oscillator clock. 
 
+config COMMON_CLK_RK808
+	tristate "Clock driver for RK808"
+	depends on MFD_RK808
+	---help---
+	  This driver supports RK808 crystal oscillator clock. These
+	  multi-function devices have two fixed-rate oscillators,
+	  clocked at 32KHz each. Clkout1 is always on, Clkout2 can off
+	  by control register.
+
 config COMMON_CLK_SI5351
 	tristate "Clock driver for SiLabs 5351A/B/C"
 	depends on I2C
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index f537a0b..99f53d5 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomadik.o
 obj-$(CONFIG_ARCH_NSPIRE)		+= clk-nspire.o
 obj-$(CONFIG_COMMON_CLK_PALMAS)		+= clk-palmas.o
 obj-$(CONFIG_CLK_PPC_CORENET)		+= clk-ppc-corenet.o
+obj-$(CONFIG_COMMON_CLK_RK808)		+= clk-rk808.o
 obj-$(CONFIG_COMMON_CLK_S2MPS11)	+= clk-s2mps11.o
 obj-$(CONFIG_COMMON_CLK_SI5351)		+= clk-si5351.o
 obj-$(CONFIG_COMMON_CLK_SI570)		+= clk-si570.o
diff --git a/drivers/clk/clk-rk808.c b/drivers/clk/clk-rk808.c
new file mode 100644
index 0000000..88f020b
--- /dev/null
+++ b/drivers/clk/clk-rk808.c
@@ -0,0 +1,160 @@
+/*
+ * Clkout driver for Rockchip RK808
+ *
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/rk808.h>
+#include <linux/i2c.h>
+
+struct rk808_clkout {
+	struct rk808 *rk808;
+	struct clk_onecell_data clk_data;
+	struct clk_hw		clkout1_hw;
+	struct clk_hw		clkout2_hw;
+};
+
+static unsigned long rk808_clkout_recalc_rate(struct clk_hw *hw,
+					      unsigned long parent_rate)
+{
+	return 32768;
+}
+
+static int rk808_clkout1_is_prepared(struct clk_hw *hw)
+{
+	return 1;
+}
+
+static int rk808_clkout2_control(struct clk_hw *hw, bool enable)
+{
+	struct rk808_clkout *rk808_clkout = container_of(hw,
+							 struct rk808_clkout,
+							 clkout2_hw);
+	struct rk808 *rk808 = rk808_clkout->rk808;
+
+	return regmap_update_bits(rk808->regmap, RK808_CLK32OUT_REG,
+				  CLK32KOUT2_EN, enable ? CLK32KOUT2_EN : 0);
+}
+
+static int rk808_clkout2_prepare(struct clk_hw *hw)
+{
+	return rk808_clkout2_control(hw, true);
+}
+
+static void rk808_clkout2_unprepare(struct clk_hw *hw)
+{
+	rk808_clkout2_control(hw, false);
+}
+
+static int rk808_clkout2_is_prepared(struct clk_hw *hw)
+{
+	struct rk808_clkout *rk808_clkout = container_of(hw,
+							 struct rk808_clkout,
+							 clkout2_hw);
+	struct rk808 *rk808 = rk808_clkout->rk808;
+	uint32_t val;
+
+	int ret = regmap_read(rk808->regmap, RK808_CLK32OUT_REG, &val);
+
+	if (ret < 0)
+		return ret;
+
+	return (val & CLK32KOUT2_EN) ? 1 : 0;
+}
+
+static const struct clk_ops rk808_clkout1_ops = {
+	.is_prepared = rk808_clkout1_is_prepared,
+	.recalc_rate = rk808_clkout_recalc_rate,
+};
+
+static const struct clk_ops rk808_clkout2_ops = {
+	.prepare = rk808_clkout2_prepare,
+	.unprepare = rk808_clkout2_unprepare,
+	.is_prepared = rk808_clkout2_is_prepared,
+	.recalc_rate = rk808_clkout_recalc_rate,
+};
+
+static int rk808_clkout_probe(struct platform_device *pdev)
+{
+	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
+	struct i2c_client *client = rk808->i2c;
+	struct device_node *node = client->dev.of_node;
+	struct clk_init_data init = {};
+	struct clk **clk_table;
+	struct rk808_clkout *rk808_clkout;
+
+	rk808_clkout = devm_kzalloc(&client->dev,
+				    sizeof(*rk808_clkout), GFP_KERNEL);
+	if (!rk808_clkout)
+		return -ENOMEM;
+
+	rk808_clkout->rk808 = rk808;
+
+	clk_table = devm_kzalloc(&client->dev,
+				 2 * sizeof(struct clk *), GFP_KERNEL);
+	if (!clk_table)
+		return -ENOMEM;
+
+	init.flags = CLK_IS_ROOT;
+	init.parent_names = NULL;
+	init.num_parents = 0;
+	init.name = "rk808-clkout1";
+	init.ops = &rk808_clkout1_ops;
+	rk808_clkout->clkout1_hw.init = &init;
+
+	/* optional override of the clockname */
+	of_property_read_string_index(node, "clock-output-names",
+				      0, &init.name);
+
+	clk_table[0] = devm_clk_register(&client->dev,
+					 &rk808_clkout->clkout1_hw);
+	if (IS_ERR(clk_table[0]))
+		return PTR_ERR(clk_table[0]);
+
+	init.name = "rk808-clkout2";
+	init.ops = &rk808_clkout2_ops;
+	rk808_clkout->clkout2_hw.init = &init;
+
+	/* optional override of the clockname */
+	of_property_read_string_index(node, "clock-output-names",
+				      1, &init.name);
+
+	clk_table[1] = devm_clk_register(&client->dev,
+					 &rk808_clkout->clkout2_hw);
+	if (IS_ERR(clk_table[1]))
+		return PTR_ERR(clk_table[1]);
+
+	rk808_clkout->clk_data.clks = clk_table;
+	rk808_clkout->clk_data.clk_num = 2;
+
+	return of_clk_add_provider(node, of_clk_src_onecell_get,
+				   &rk808_clkout->clk_data);
+}
+
+static struct platform_driver rk808_clkout_driver = {
+	.probe = rk808_clkout_probe,
+	.driver		= {
+		.name	= "rk808-clkout",
+	},
+};
+
+module_platform_driver(rk808_clkout_driver);
+
+MODULE_DESCRIPTION("Clkout driver for the rk808 series PMICs");
+MODULE_AUTHOR("Chris Zhong <zyw@rock-chips.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rk808-clkout");
-- 
1.7.9.5

