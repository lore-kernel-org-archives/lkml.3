Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaHTDmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:42:21 -0400
Received: from regular1.263xmail.com ([211.150.99.138]:36748 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaHTDmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:42:19 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <e3e204d2642875b705ba65fa41c85603>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Chris Zhong <zyw@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, mturquette@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com,
        Chris Zhong <zyw@rock-chips.com>
Subject: [PATCH v2 5/5] Clk: RK808: Add clkout driver for RK808
Date: Wed, 20 Aug 2014 11:40:09 +0800
Message-Id: <1408506009-29923-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

Changes in v2: None

 drivers/clk/Kconfig     |    9 +++
 drivers/clk/Makefile    |    1 +
 drivers/clk/clk-rk808.c |  146 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 156 insertions(+)
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
index 0000000..8d0467a
--- /dev/null
+++ b/drivers/clk/clk-rk808.c
@@ -0,0 +1,146 @@
+/*
+ * Clkout driver for Rockchip RK808
+ *
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * Author: Chris Zhong <zyw@rock-chips.com>
+ * Author: Zhang Qing <zhangqing@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/rk808>
+
+struct rk808_clk {
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
+	struct rk808_clk *rk808_clk = container_of(hw, struct rk808_clk,
+						   clkout2_hw);
+	struct rk808 *rk808 = rk808_clk->rk808;
+
+	return regmap_update_bits(rk808->regmap, RK808_CLK32OUT_REG,
+				  CLK32KOUT2_EN, enable ? CLK32KOUT2_EN : 0);
+}
+
+static int rk808_clkout2_prepare(struct clk_hw *hw)
+{
+	return rk808_clkout2_control(hw, 1);
+}
+
+static void rk808_clkout2_unprepare(struct clk_hw *hw)
+{
+	rk808_clkout2_control(hw, 0);
+}
+
+static int rk808_clkout2_is_prepared(struct clk_hw *hw)
+{
+	struct rk808_clk *rk808_clk = container_of(hw, struct rk808_clk,
+						   clkout2_hw);
+	struct rk808 *rk808 = rk808_clk->rk808;
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
+static int rk808_clk_probe(struct platform_device *pdev)
+{
+	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
+	struct clk_init_data init;
+	struct clk **clk_table;
+	struct rk808_clk *clkdata;
+	struct device_node *node = client->dev.of_node;
+	int ret;
+
+	clkdata = devm_kzalloc(&pdev->dev, sizeof(*clkdata), GFP_KERNEL);
+	if (!clkdata)
+		return -ENOMEM;
+
+	clkdata->rk808 = rk808;
+
+	clk_table = devm_kzalloc(&client->dev,
+				 2*sizeof(struct clk *), GFP_KERNEL);
+	if (!clk_table)
+		return -ENOMEM;
+
+	init.flags = CLK_IS_ROOT;
+	init.parent_names = NULL;
+	init.num_parents = 0;
+	init.name = "rk808-clkout1";
+	init.ops = &rk808_clkout1_ops;
+	clkdata->clkout1_hw.init = &init;
+	clk_table[0] = devm_clk_register(&pdev->dev, &clkdata->clkout1_hw);
+
+	init.name = "rk808-clkout2";
+	init.ops = &rk808_clkout2_ops;
+	clkdata->clkout2_hw.init = &init;
+	clk_table[1] = devm_clk_register(&pdev->dev, &clkdata->clkout2_hw);
+
+	clk_data->clks = clk_table;
+	clk_data->clk_num = 2;
+	of_clk_add_provider(node, of_clk_src_onecell_get, clk_table)
+
+	return 0;
+}
+
+static struct platform_driver rk808_clk_driver = {
+	.probe = rk808_clk_probe,
+	.driver		= {
+		.name	= "rk808-clkout",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(rk808_clk_driver);
+
+MODULE_DESCRIPTION("Clkout driver for the rk808 series PMICs");
+MODULE_AUTHOR("Chris Zhong <zyw@rock-chips.com>");
+MODULE_AUTHOR("Zhang Qing <zhanqging@rock-chips.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rk808-clk")
-- 
1.7.9.5


