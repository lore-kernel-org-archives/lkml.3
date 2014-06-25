Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbaFYAH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:07:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41377 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaFYAGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:06:32 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [RFC/PATCH 08/12] clk: qcom: Add KPSS ACC/GCC driver
Date: Tue, 24 Jun 2014 17:06:19 -0700
Message-Id: <1403654783-7176-9-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
References: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACC and GCC regions present in KPSSv1 contain registers to
control clocks and power to each Krait CPU and L2. For CPUfreq
purposes probe these devices and expose a mux clock that chooses
between PXO and PLL8.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Kconfig    |   8 +++
 drivers/clk/qcom/Makefile   |   1 +
 drivers/clk/qcom/kpss-xcc.c | 115 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+)
 create mode 100644 drivers/clk/qcom/kpss-xcc.c

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 425bcfe3c39a..247f042dc110 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -53,3 +53,11 @@ config QCOM_HFPLL
 	  Support for the high-frequency PLLs present on Qualcomm devices.
 	  Say Y if you want to support CPU frequency scaling on devices
 	  such as MSM8974, APQ8084, etc.
+
+config KPSS_XCC
+	tristate "KPSS Clock Controller"
+	depends on COMMON_CLK_QCOM
+	help
+	  Support for the Krait ACC and GCC clock controllers. Say Y
+	  if you want to support CPU frequency scaling on devices such
+	  as MSM8960, APQ8064, etc.
diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index b982d271d7db..bb4666733bd9 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -16,4 +16,5 @@ obj-$(CONFIG_MSM_GCC_8960) += gcc-msm8960.o
 obj-$(CONFIG_MSM_GCC_8974) += gcc-msm8974.o
 obj-$(CONFIG_MSM_MMCC_8960) += mmcc-msm8960.o
 obj-$(CONFIG_MSM_MMCC_8974) += mmcc-msm8974.o
+obj-$(CONFIG_KPSS_XCC) += kpss-xcc.o
 obj-$(CONFIG_QCOM_HFPLL) += hfpll.o
diff --git a/drivers/clk/qcom/kpss-xcc.c b/drivers/clk/qcom/kpss-xcc.c
new file mode 100644
index 000000000000..1061668d48c0
--- /dev/null
+++ b/drivers/clk/qcom/kpss-xcc.c
@@ -0,0 +1,115 @@
+/* Copyright (c) 2014, The Linux Foundation. All rights reserved.
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
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/clk/msm-clk-generic.h>
+
+static int kpss_xcc_set_mux_sel(struct mux_clk *clk, int sel)
+{
+	writel_relaxed(sel, clk->base + clk->offset);
+	return 0;
+}
+
+static int kpss_xcc_get_mux_sel(struct mux_clk *clk)
+{
+	return readl_relaxed(clk->base + clk->offset);
+}
+
+static const struct clk_mux_ops kpss_xcc_ops = {
+	.set_mux_sel = kpss_xcc_set_mux_sel,
+	.get_mux_sel = kpss_xcc_get_mux_sel,
+};
+
+static const char *aux_parents[] = {
+	"pll8_vote",
+	"pxo",
+};
+
+static u8 aux_parent_map[] = {
+	3,
+	0,
+};
+
+static const struct of_device_id kpss_xcc_match_table[] = {
+	{ .compatible = "qcom,kpss-acc-v1", .data = (void *)1UL },
+	{ .compatible = "qcom,kpss-gcc" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, kpss_xcc_match_table);
+
+static int kpss_xcc_driver_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *id;
+	struct clk *clk;
+	struct resource *res;
+	void __iomem *base;
+	struct mux_clk *mux_clk;
+	struct clk_init_data init = {
+		.parent_names = aux_parents,
+		.num_parents = 2,
+		.ops = &clk_ops_gen_mux,
+	};
+
+	id = of_match_device(kpss_xcc_match_table, &pdev->dev);
+	if (!id)
+		return -ENODEV;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	mux_clk = devm_kzalloc(&pdev->dev, sizeof(*mux_clk), GFP_KERNEL);
+	if (!mux_clk)
+		return -ENOMEM;
+
+	mux_clk->mask = 0x3;
+	mux_clk->parent_map = aux_parent_map;
+	mux_clk->ops = &kpss_xcc_ops;
+	mux_clk->base = base;
+	mux_clk->hw.init = &init;
+
+	if (id->data) {
+		if (of_property_read_string_index(pdev->dev.of_node,
+					"clock-output-names", 0, &init.name))
+			return -ENODEV;
+		mux_clk->offset = 0x14;
+	} else {
+		init.name = "acpu_l2_aux";
+		mux_clk->offset = 0x28;
+	}
+
+	clk = devm_clk_register(&pdev->dev, &mux_clk->hw);
+
+	return PTR_ERR_OR_ZERO(clk);
+}
+
+static struct platform_driver kpss_xcc_driver = {
+	.probe = kpss_xcc_driver_probe,
+	.driver = {
+		.name = "kpss-xcc",
+		.of_match_table = kpss_xcc_match_table,
+		.owner = THIS_MODULE,
+	},
+};
+module_platform_driver(kpss_xcc_driver);
+
+MODULE_LICENSE("GPL v2");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

