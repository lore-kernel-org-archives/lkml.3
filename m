Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaEVQ0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:26:30 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:58969 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbaEVQZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:25:12 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sboyd@codeaurora.org, rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v1 2/5] clk: qcom: Allow an override function to be passed as data
Date: Thu, 22 May 2014 19:24:42 +0300
Message-Id: <1400775885-10296-3-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400775885-10296-1-git-send-email-gdjakov@mm-sol.com>
References: <1400775885-10296-1-git-send-email-gdjakov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The APQ8084 and MSM8974 SoCs share a lot of clock data. Instead of
duplicating all the data, we can add the support for APQ8084 into
the MSM8974 code and just describe the differences by using an
override function.

This patch applies to the clk-next tree and the following patchset
on top of it: https://lkml.org/lkml/2014/5/16/666

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/clk/qcom/gcc-msm8974.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/qcom/gcc-msm8974.c b/drivers/clk/qcom/gcc-msm8974.c
index 33eb051..58cb2f5 100644
--- a/drivers/clk/qcom/gcc-msm8974.c
+++ b/drivers/clk/qcom/gcc-msm8974.c
@@ -2674,14 +2674,6 @@ static const struct qcom_cc_desc gcc_msm8974_desc = {
 	.num_resets = ARRAY_SIZE(gcc_msm8974_resets),
 };
 
-static const struct of_device_id gcc_msm8974_match_table[] = {
-	{ .compatible = "qcom,gcc-msm8974" },
-	{ .compatible = "qcom,gcc-msm8974pro" , .data = (void *)1UL },
-	{ .compatible = "qcom,gcc-msm8974pro-ac", .data = (void *)1UL },
-	{ }
-};
-MODULE_DEVICE_TABLE(of, gcc_msm8974_match_table);
-
 static void msm8974_pro_clock_override(void)
 {
 	sdcc1_apps_clk_src_init.parent_names = gcc_xo_gpll0_gpll4;
@@ -2697,20 +2689,31 @@ static void msm8974_pro_clock_override(void)
 		&gcc_sdcc1_cdccal_ff_clk.clkr;
 }
 
+static const struct of_device_id gcc_msm8974_match_table[] = {
+	{ .compatible = "qcom,gcc-msm8974" },
+	{ .compatible = "qcom,gcc-msm8974pro",
+		.data =	&msm8974_pro_clock_override },
+	{ .compatible = "qcom,gcc-msm8974pro-ac",
+		.data = &msm8974_pro_clock_override },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, gcc_msm8974_match_table);
+
 static int gcc_msm8974_probe(struct platform_device *pdev)
 {
 	struct clk *clk;
 	struct device *dev = &pdev->dev;
-	bool pro;
 	const struct of_device_id *id;
+	void (*overrides)(void);
 
 	id = of_match_device(gcc_msm8974_match_table, dev);
 	if (!id)
 		return -ENODEV;
-	pro = !!(id->data);
 
-	if (pro)
-		msm8974_pro_clock_override();
+	if (id->data) {
+		overrides = id->data;
+		overrides();
+	}
 
 	/* Temporary until RPM clocks supported */
 	clk = clk_register_fixed_rate(dev, "xo", NULL, CLK_IS_ROOT, 19200000);
-- 
1.7.9.5

