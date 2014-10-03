Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbaJCXYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:24:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775AbaJCWNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 3.16 357/357] clk: qcom: Fix PLL rate configurations
Date: Fri,  3 Oct 2014 14:32:23 -0700
Message-Id: <20141003212944.185047288@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit 5b6b7490af110c2b0df807eddd00ae6290bcf50a upstream.

Sometimes we need to program PLLs with a fixed rate
configuration during driver probe. Doing this after we register
the PLLs with the clock framework causes the common clock
framework to assume the rate of the PLLs are 0. This causes all
sorts of problems for rate recalculations because the common
clock framework caches the rate once at registration time unless
a flag is set to always recalculate the rates.

Split the qcom_cc_probe() function into two pieces, map and
everything else, so that drivers which need to configure some
PLL rates or otherwise twiddle bits in the clock controller can
do so before registering clocks. This allows us to properly
detect the rates of PLLs that are programmed at boot.

Fixes: 49fc825f0cc2 "clk: qcom: Consolidate common probe code"
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/qcom/common.c       |   39 ++++++++++++++++++++++++++++-----------
 drivers/clk/qcom/common.h       |    6 ++++++
 drivers/clk/qcom/mmcc-msm8974.c |   10 ++++------
 3 files changed, 38 insertions(+), 17 deletions(-)

--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -27,30 +27,35 @@ struct qcom_cc {
 	struct clk *clks[];
 };
 
-int qcom_cc_probe(struct platform_device *pdev, const struct qcom_cc_desc *desc)
+struct regmap *
+qcom_cc_map(struct platform_device *pdev, const struct qcom_cc_desc *desc)
 {
 	void __iomem *base;
 	struct resource *res;
+	struct device *dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return ERR_CAST(base);
+
+	return devm_regmap_init_mmio(dev, base, desc->config);
+}
+EXPORT_SYMBOL_GPL(qcom_cc_map);
+
+int qcom_cc_really_probe(struct platform_device *pdev,
+			 const struct qcom_cc_desc *desc, struct regmap *regmap)
+{
 	int i, ret;
 	struct device *dev = &pdev->dev;
 	struct clk *clk;
 	struct clk_onecell_data *data;
 	struct clk **clks;
-	struct regmap *regmap;
 	struct qcom_reset_controller *reset;
 	struct qcom_cc *cc;
 	size_t num_clks = desc->num_clks;
 	struct clk_regmap **rclks = desc->clks;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
-	regmap = devm_regmap_init_mmio(dev, base, desc->config);
-	if (IS_ERR(regmap))
-		return PTR_ERR(regmap);
-
 	cc = devm_kzalloc(dev, sizeof(*cc) + sizeof(*clks) * num_clks,
 			  GFP_KERNEL);
 	if (!cc)
@@ -91,6 +96,18 @@ int qcom_cc_probe(struct platform_device
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(qcom_cc_really_probe);
+
+int qcom_cc_probe(struct platform_device *pdev, const struct qcom_cc_desc *desc)
+{
+	struct regmap *regmap;
+
+	regmap = qcom_cc_map(pdev, desc);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
+
+	return qcom_cc_really_probe(pdev, desc, regmap);
+}
 EXPORT_SYMBOL_GPL(qcom_cc_probe);
 
 void qcom_cc_remove(struct platform_device *pdev)
--- a/drivers/clk/qcom/common.h
+++ b/drivers/clk/qcom/common.h
@@ -17,6 +17,7 @@ struct platform_device;
 struct regmap_config;
 struct clk_regmap;
 struct qcom_reset_map;
+struct regmap;
 
 struct qcom_cc_desc {
 	const struct regmap_config *config;
@@ -26,6 +27,11 @@ struct qcom_cc_desc {
 	size_t num_resets;
 };
 
+extern struct regmap *qcom_cc_map(struct platform_device *pdev,
+				  const struct qcom_cc_desc *desc);
+extern int qcom_cc_really_probe(struct platform_device *pdev,
+				const struct qcom_cc_desc *desc,
+				struct regmap *regmap);
 extern int qcom_cc_probe(struct platform_device *pdev,
 			 const struct qcom_cc_desc *desc);
 
--- a/drivers/clk/qcom/mmcc-msm8974.c
+++ b/drivers/clk/qcom/mmcc-msm8974.c
@@ -2547,18 +2547,16 @@ MODULE_DEVICE_TABLE(of, mmcc_msm8974_mat
 
 static int mmcc_msm8974_probe(struct platform_device *pdev)
 {
-	int ret;
 	struct regmap *regmap;
 
-	ret = qcom_cc_probe(pdev, &mmcc_msm8974_desc);
-	if (ret)
-		return ret;
+	regmap = qcom_cc_map(pdev, &mmcc_msm8974_desc);
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
 
-	regmap = dev_get_regmap(&pdev->dev, NULL);
 	clk_pll_configure_sr_hpm_lp(&mmpll1, regmap, &mmpll1_config, true);
 	clk_pll_configure_sr_hpm_lp(&mmpll3, regmap, &mmpll3_config, false);
 
-	return 0;
+	return qcom_cc_really_probe(pdev, &mmcc_msm8974_desc, regmap);
 }
 
 static int mmcc_msm8974_remove(struct platform_device *pdev)


