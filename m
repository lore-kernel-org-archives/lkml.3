Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520AbaFQO5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:57:44 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41388 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167AbaFQOx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:53:29 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH v2 12/20] clk: sunxi: Add A23 APB0 support to sun6i-a31-apb0-clk
Date: Tue, 17 Jun 2014 22:52:49 +0800
Message-Id: <1403016777-15121-13-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403016777-15121-1-git-send-email-wens@csie.org>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A23 has an almost identical PRCM clock tree. The difference in
the APB0 clock is the smallest divisor is 1, instead of 2.

This patch extends the sun6i-a31-apb0-clk driver to take divider
tables associated to compatibles, and adds a compatible for the A23
variant.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/devicetree/bindings/clock/sunxi.txt |  1 +
 drivers/clk/sunxi/clk-sun6i-apb0.c                | 28 ++++++++++++++++++-----
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
index af9e47d..e3a47ec 100644
--- a/Documentation/devicetree/bindings/clock/sunxi.txt
+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
@@ -28,6 +28,7 @@ Required properties:
 	"allwinner,sun8i-a23-ahb1-gates-clk" - for the AHB1 gates on A23
 	"allwinner,sun4i-a10-apb0-clk" - for the APB0 clock
 	"allwinner,sun6i-a31-apb0-clk" - for the APB0 clock on A31
+	"allwinner,sun8i-a23-apb0-clk" - for the APB0 clock on A23
 	"allwinner,sun4i-a10-apb0-gates-clk" - for the APB0 gates on A10
 	"allwinner,sun5i-a13-apb0-gates-clk" - for the APB0 gates on A13
 	"allwinner,sun5i-a10s-apb0-gates-clk" - for the APB0 gates on A10s
diff --git a/drivers/clk/sunxi/clk-sun6i-apb0.c b/drivers/clk/sunxi/clk-sun6i-apb0.c
index 11f17c3..2197ac7 100644
--- a/drivers/clk/sunxi/clk-sun6i-apb0.c
+++ b/drivers/clk/sunxi/clk-sun6i-apb0.c
@@ -11,6 +11,7 @@
 #include <linux/clk-provider.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 
 /*
@@ -28,6 +29,21 @@ static const struct clk_div_table sun6i_a31_apb0_divs[] = {
 	{ /* sentinel */ },
 };
 
+/* The A23 APB0 clock has a standard power of 2 divisor */
+static const struct clk_div_table sun8i_a23_apb0_divs[] = {
+	{ .val = 0, .div = 1, },
+	{ .val = 1, .div = 2, },
+	{ .val = 2, .div = 4, },
+	{ .val = 3, .div = 8, },
+	{ /* sentinel */ },
+};
+
+const struct of_device_id sun6i_a31_apb0_clk_dt_ids[] = {
+	{ .compatible = "allwinner,sun6i-a31-apb0-clk", .data = &sun6i_a31_apb0_divs },
+	{ .compatible = "allwinner,sun8i-a23-apb0-clk", .data = &sun8i_a23_apb0_divs },
+	{ /* sentinel */ }
+};
+
 static int sun6i_a31_apb0_clk_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -36,12 +52,17 @@ static int sun6i_a31_apb0_clk_probe(struct platform_device *pdev)
 	struct resource *r;
 	void __iomem *reg;
 	struct clk *clk;
+	const struct of_device_id *device;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	reg = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(reg))
 		return PTR_ERR(reg);
 
+	device = of_match_device(sun6i_a31_apb0_clk_dt_ids, &pdev->dev);
+	if (!device)
+		return -EINVAL;
+
 	clk_parent = of_clk_get_parent_name(np, 0);
 	if (!clk_parent)
 		return -EINVAL;
@@ -49,7 +70,7 @@ static int sun6i_a31_apb0_clk_probe(struct platform_device *pdev)
 	of_property_read_string(np, "clock-output-names", &clk_name);
 
 	clk = clk_register_divider_table(&pdev->dev, clk_name, clk_parent,
-					 0, reg, 0, 2, 0, sun6i_a31_apb0_divs,
+					 0, reg, 0, 2, 0, device->data,
 					 NULL);
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
@@ -57,11 +78,6 @@ static int sun6i_a31_apb0_clk_probe(struct platform_device *pdev)
 	return of_clk_add_provider(np, of_clk_src_simple_get, clk);
 }
 
-const struct of_device_id sun6i_a31_apb0_clk_dt_ids[] = {
-	{ .compatible = "allwinner,sun6i-a31-apb0-clk" },
-	{ /* sentinel */ }
-};
-
 static struct platform_driver sun6i_a31_apb0_clk_driver = {
 	.driver = {
 		.name = "sun6i-a31-apb0-clk",
-- 
2.0.0

