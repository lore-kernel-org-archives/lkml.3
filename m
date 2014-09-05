Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaIEWvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:51:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43560 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbaIEWrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:47:43 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH v2 12/15] clk: qcom: Add KPSS ACC/GCC driver
Date: Fri,  5 Sep 2014 15:47:32 -0700
Message-Id: <1409957256-23729-14-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
In-Reply-To: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACC and GCC regions present in KPSSv1 contain registers to
control clocks and power to each Krait CPU and L2. For CPUfreq
purposes probe these devices and expose a mux clock that chooses
between PXO and PLL8.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Kconfig    |  8 ++++
 drivers/clk/qcom/Makefile   |  1 +
 drivers/clk/qcom/kpss-xcc.c | 94 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 103 insertions(+)
 create mode 100644 drivers/clk/qcom/kpss-xcc.c

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 2fd07b17e10e..6bf73773f75a 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -79,6 +79,14 @@ config QCOM_HFPLL
 	  Say Y if you want to support CPU frequency scaling on devices
 	  such as MSM8974, APQ8084, etc.
 
+config KPSS_XCC
+	tristate "KPSS Clock Controller"
+	depends on COMMON_CLK_QCOM
+	help
+	  Support for the Krait ACC and GCC clock controllers. Say Y
+	  if you want to support CPU frequency scaling on devices such
+	  as MSM8960, APQ8064, etc.
+
 config KRAIT_CLOCKS
 	bool
 	select KRAIT_L2_ACCESSORS
diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index c7fda5e9dcc7..d85491bfc053 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -18,4 +18,5 @@ obj-$(CONFIG_MSM_GCC_8960) += gcc-msm8960.o
 obj-$(CONFIG_MSM_GCC_8974) += gcc-msm8974.o
 obj-$(CONFIG_MSM_MMCC_8960) += mmcc-msm8960.o
 obj-$(CONFIG_MSM_MMCC_8974) += mmcc-msm8974.o
+obj-$(CONFIG_KPSS_XCC) += kpss-xcc.o
 obj-$(CONFIG_QCOM_HFPLL) += hfpll.o
diff --git a/drivers/clk/qcom/kpss-xcc.c b/drivers/clk/qcom/kpss-xcc.c
new file mode 100644
index 000000000000..9c49496afa6a
--- /dev/null
+++ b/drivers/clk/qcom/kpss-xcc.c
@@ -0,0 +1,94 @@
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
+
+static const char *aux_parents[] = {
+	"pll8_vote",
+	"pxo",
+};
+
+static unsigned int aux_parent_map[] = {
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
+	const char *name;
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
+	if (id->data) {
+		if (of_property_read_string_index(pdev->dev.of_node,
+					"clock-output-names", 0, &name))
+			return -ENODEV;
+		base += 0x14;
+	} else {
+		name = "acpu_l2_aux";
+		base += 0x28;
+	}
+
+	clk = clk_register_mux_table(&pdev->dev, name, aux_parents,
+				     ARRAY_SIZE(aux_parents), 0, base, 0, 0x3,
+				     0, aux_parent_map, NULL);
+
+	platform_set_drvdata(pdev, clk);
+
+	return PTR_ERR_OR_ZERO(clk);
+}
+
+static int kpss_xcc_driver_remove(struct platform_device *pdev)
+{
+	clk_unregister_mux(platform_get_drvdata(pdev));
+	return 0;
+}
+
+static struct platform_driver kpss_xcc_driver = {
+	.probe = kpss_xcc_driver_probe,
+	.remove = kpss_xcc_driver_remove,
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

