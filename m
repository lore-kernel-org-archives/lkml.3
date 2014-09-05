Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaIEWvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:51:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43571 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaIEWrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:47:42 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH v2 08/15] clk: qcom: Add HFPLL driver
Date: Fri,  5 Sep 2014 15:47:28 -0700
Message-Id: <1409957256-23729-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
In-Reply-To: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some devices (MSM8974 for example), the HFPLLs are
instantiated within the Krait processor subsystem as separate
register regions. Add a driver for these PLLs so that we can
provide HFPLL clocks for use by the system.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Kconfig  |   8 ++++
 drivers/clk/qcom/Makefile |   1 +
 drivers/clk/qcom/hfpll.c  | 110 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+)
 create mode 100644 drivers/clk/qcom/hfpll.c

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 1107351ed346..3ff19a51a933 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -70,3 +70,11 @@ config MSM_MMCC_8974
 	  Support for the multimedia clock controller on msm8974 devices.
 	  Say Y if you want to support multimedia devices such as display,
 	  graphics, video encode/decode, camera, etc.
+
+config QCOM_HFPLL
+	tristate "High-Frequency PLL (HFPLL) Clock Controller"
+	depends on COMMON_CLK_QCOM
+	help
+	  Support for the high-frequency PLLs present on Qualcomm devices.
+	  Say Y if you want to support CPU frequency scaling on devices
+	  such as MSM8974, APQ8084, etc.
diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index f1e54065e4dc..db39912cffec 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_MSM_GCC_8960) += gcc-msm8960.o
 obj-$(CONFIG_MSM_GCC_8974) += gcc-msm8974.o
 obj-$(CONFIG_MSM_MMCC_8960) += mmcc-msm8960.o
 obj-$(CONFIG_MSM_MMCC_8974) += mmcc-msm8974.o
+obj-$(CONFIG_QCOM_HFPLL) += hfpll.o
diff --git a/drivers/clk/qcom/hfpll.c b/drivers/clk/qcom/hfpll.c
new file mode 100644
index 000000000000..701a377d35c1
--- /dev/null
+++ b/drivers/clk/qcom/hfpll.c
@@ -0,0 +1,110 @@
+/*
+ * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/regmap.h>
+
+#include "clk-regmap.h"
+#include "clk-hfpll.h"
+
+static const struct hfpll_data hdata = {
+	.mode_reg = 0x00,
+	.l_reg = 0x04,
+	.m_reg = 0x08,
+	.n_reg = 0x0c,
+	.user_reg = 0x10,
+	.config_reg = 0x14,
+	.config_val = 0x430405d,
+	.status_reg = 0x1c,
+	.lock_bit = 16,
+
+	.user_val = 0x8,
+	.user_vco_mask = 0x100000,
+	.low_vco_max_rate = 1248000000,
+	.min_rate = 537600000UL,
+	.max_rate = 2900000000UL,
+};
+
+static const struct of_device_id qcom_hfpll_match_table[] = {
+	{ .compatible = "qcom,hfpll" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, qcom_hfpll_match_table);
+
+static struct regmap_config hfpll_regmap_config = {
+	.reg_bits	= 32,
+	.reg_stride	= 4,
+	.val_bits	= 32,
+	.max_register	= 0x30,
+	.fast_io	= true,
+};
+
+static int qcom_hfpll_probe(struct platform_device *pdev)
+{
+	struct clk *clk;
+	struct resource *res;
+	struct device *dev = &pdev->dev;
+	void __iomem *base;
+	struct regmap *regmap;
+	struct clk_hfpll *h;
+	struct clk_init_data init = {
+		.parent_names = (const char *[]){ "xo" },
+		.num_parents = 1,
+		.ops = &clk_ops_hfpll,
+	};
+
+	h = devm_kzalloc(dev, sizeof(*h), GFP_KERNEL);
+	if (!h)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	regmap = devm_regmap_init_mmio(&pdev->dev, base, &hfpll_regmap_config);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	if (of_property_read_string_index(dev->of_node, "clock-output-names",
+						  0, &init.name))
+		return -ENODEV;
+
+	h->d = &hdata;
+	h->clkr.hw.init = &init;
+	spin_lock_init(&h->lock);
+
+	clk = devm_clk_register_regmap(&pdev->dev, &h->clkr);
+
+	return PTR_ERR_OR_ZERO(clk);
+}
+
+static struct platform_driver qcom_hfpll_driver = {
+	.probe		= qcom_hfpll_probe,
+	.driver		= {
+		.name	= "qcom-hfpll",
+		.owner	= THIS_MODULE,
+		.of_match_table = qcom_hfpll_match_table,
+	},
+};
+module_platform_driver(qcom_hfpll_driver);
+
+MODULE_DESCRIPTION("QCOM HFPLL Clock Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:qcom-hfpll");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

