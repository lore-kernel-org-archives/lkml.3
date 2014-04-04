Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaDDSpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:45:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59310 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaDDSpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:45:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 2/4] clk: qcom: Add GDSCs within 8974 multimedia clock controller
Date: Fri,  4 Apr 2014 11:45:34 -0700
Message-Id: <1396637136-29974-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1396637136-29974-1-git-send-email-sboyd@codeaurora.org>
References: <1396637136-29974-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary data and register the GDSCs that are present on
the 8974 multimedia clock controller.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/mmcc-msm8974.c | 86 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/mmcc-msm8974.c b/drivers/clk/qcom/mmcc-msm8974.c
index c95774514b81..1e7f69716d2f 100644
--- a/drivers/clk/qcom/mmcc-msm8974.c
+++ b/drivers/clk/qcom/mmcc-msm8974.c
@@ -21,6 +21,7 @@
 #include <linux/clk-provider.h>
 #include <linux/regmap.h>
 #include <linux/reset-controller.h>
+#include <linux/regulator/of_regulator.h>
 
 #include <dt-bindings/clock/qcom,mmcc-msm8974.h>
 #include <dt-bindings/reset/qcom,mmcc-msm8974.h>
@@ -30,6 +31,7 @@
 #include "clk-rcg.h"
 #include "clk-branch.h"
 #include "reset.h"
+#include "gdsc.h"
 
 #define P_XO		0
 #define P_MMPLL0	1
@@ -2516,6 +2518,60 @@ static const struct qcom_reset_map mmcc_msm8974_resets[] = {
 	[OCMEMNOC_RESET] = { 0x50b0 },
 };
 
+static struct gdsc_desc gdsc_venus = {
+	.gdscr = 0x1024,
+	.cxcs = (unsigned int []){ 0x1028 },
+	.cxc_count = 1,
+	.resets = (unsigned int []){ VENUS0_RESET },
+	.reset_count = 1,
+};
+
+static struct gdsc_desc gdsc_mdss = {
+	.gdscr = 0x2304,
+	.cxcs = (unsigned int []){ 0x231c, 0x2320 },
+	.cxc_count = 2,
+	.resets = (unsigned int []){ MDSS_RESET },
+	.reset_count = 1,
+};
+
+static struct gdsc_desc gdsc_jpeg = {
+	.gdscr = 0x35a4,
+	.cxcs = (unsigned int []){ 0x35a8, 0x35ac, 0x35b0 },
+	.cxc_count = 3,
+	.resets = (unsigned int []){ CAMSS_JPEG_RESET },
+	.reset_count = 1,
+};
+
+static struct gdsc_desc gdsc_vfe = {
+	.gdscr = 0x36a4,
+	.cxcs = (unsigned int []){ 0x36a8, 0x36ac, 0x3704, 0x3714, 0x36b0 },
+	.cxc_count = 5,
+	.resets = (unsigned int []){ CAMSS_VFE_RESET, CAMSS_CSI_VFE0_RESET,
+				     CAMSS_CSI_VFE1_RESET },
+	.reset_count = 3,
+};
+
+static struct gdsc_desc gdsc_oxili_gx = {
+	.gdscr = 0x4024,
+	.cxcs = (unsigned int []){ 0x4028 },
+	.cxc_count = 1,
+	.resets = (unsigned int []){ OXILI_RESET },
+	.reset_count = 1,
+};
+
+static struct gdsc_desc gdsc_oxili_cx = {
+	.gdscr = 0x4034,
+};
+
+static struct of_regulator_match mmcc_msm8974_gdscs[] = {
+	{ .name = "gdsc_venus", .driver_data = &gdsc_venus },
+	{ .name = "gdsc_mdss", .driver_data = &gdsc_mdss },
+	{ .name = "gdsc_jpeg", .driver_data = &gdsc_jpeg },
+	{ .name = "gdsc_vfe", .driver_data = &gdsc_vfe },
+	{ .name = "gdsc_oxili_gx", .driver_data = &gdsc_oxili_gx },
+	{ .name = "gdsc_oxili_cx", .driver_data = &gdsc_oxili_cx },
+};
+
 static const struct regmap_config mmcc_msm8974_regmap_config = {
 	.reg_bits	= 32,
 	.reg_stride	= 4,
@@ -2540,7 +2596,7 @@ static int mmcc_msm8974_probe(struct platform_device *pdev)
 {
 	void __iomem *base;
 	struct resource *res;
-	int i, ret;
+	int i, ret, num;
 	struct device *dev = &pdev->dev;
 	struct clk *clk;
 	struct clk_onecell_data *data;
@@ -2549,6 +2605,7 @@ static int mmcc_msm8974_probe(struct platform_device *pdev)
 	size_t num_clks;
 	struct qcom_reset_controller *reset;
 	struct qcom_cc *cc;
+	struct device_node *regs;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(dev, res);
@@ -2597,8 +2654,33 @@ static int mmcc_msm8974_probe(struct platform_device *pdev)
 
 	ret = reset_controller_register(&reset->rcdev);
 	if (ret)
-		of_clk_del_provider(dev->of_node);
+		goto err_reset;
+
+	regs = of_get_child_by_name(dev->of_node, "regulators");
+	if (!regs)
+		return 0;
+
+	num = of_regulator_match(&pdev->dev, regs, mmcc_msm8974_gdscs,
+				 ARRAY_SIZE(mmcc_msm8974_gdscs));
+	of_node_put(regs);
+	if (num < 0) {
+		dev_err(&pdev->dev, "Regulator match failed\n");
+		ret = num;
+		goto err_regs;
+	}
+
+	for (i = 0; i < num; i++) {
+		ret = gdsc_register(&pdev->dev, &mmcc_msm8974_gdscs[i],
+				    &reset->rcdev);
+		if (ret)
+			goto err_regs;
+	}
 
+	return 0;
+err_regs:
+	reset_controller_unregister(&reset->rcdev);
+err_reset:
+	of_clk_del_provider(dev->of_node);
 	return ret;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

