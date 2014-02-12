Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaBLQAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:00:24 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:47126 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbaBLQAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:00:18 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/13] pinctrl: mvebu: move resource allocation to SoC specific drivers
Date: Wed, 12 Feb 2014 16:59:33 +0100
Message-Id: <1392220776-30851-11-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way that mvebu pinctrl is designed, requesting mpp registers
in common pinctrl driver does not allow SoC specific drivers to
access this resource.

Move resource allocation in each SoC pinctrl driver and enable
already provided mpp_{set,get} callbacks.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
---
Cc: Linus Walleij <linus.walleij@linaro.org> 
Cc: Jason Cooper <jason@lakedaemon.net> 
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-armada-370.c |  8 +++++++-
 drivers/pinctrl/mvebu/pinctrl-armada-xp.c  |  8 +++++++-
 drivers/pinctrl/mvebu/pinctrl-dove.c       |  8 +++++++-
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c   | 13 ++++++++++---
 drivers/pinctrl/mvebu/pinctrl-mvebu.c      |  8 --------
 5 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-370.c b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
index bcde42ce598f..f6fa18749787 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-370.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-370.c
@@ -397,7 +397,7 @@ static struct of_device_id armada_370_pinctrl_of_match[] = {
 };
 
 static struct mvebu_mpp_ctrl mv88f6710_mpp_controls[] = {
-	MPP_REG_CTRL(0, 65),
+	MPP_FUNC_CTRL(0, 65, NULL, armada_370_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv88f6710_mpp_gpio_ranges[] = {
@@ -409,6 +409,12 @@ static struct pinctrl_gpio_range mv88f6710_mpp_gpio_ranges[] = {
 static int armada_370_pinctrl_probe(struct platform_device *pdev)
 {
 	struct mvebu_pinctrl_soc_info *soc = &armada_370_pinctrl_info;
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mpp_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mpp_base))
+		return PTR_ERR(mpp_base);
 
 	soc->variant = 0; /* no variants for Armada 370 */
 	soc->controls = mv88f6710_mpp_controls;
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
index b5381b421284..6acea0020dd2 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-xp.c
@@ -409,7 +409,7 @@ static struct pinctrl_gpio_range mv78260_mpp_gpio_ranges[] = {
 };
 
 static struct mvebu_mpp_ctrl mv78460_mpp_controls[] = {
-	MPP_REG_CTRL(0, 66),
+	MPP_FUNC_CTRL(0, 66, NULL, armada_xp_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv78460_mpp_gpio_ranges[] = {
@@ -423,10 +423,16 @@ static int armada_xp_pinctrl_probe(struct platform_device *pdev)
 	struct mvebu_pinctrl_soc_info *soc = &armada_xp_pinctrl_info;
 	const struct of_device_id *match =
 		of_match_device(armada_xp_pinctrl_of_match, &pdev->dev);
+	struct resource *res;
 
 	if (!match)
 		return -ENODEV;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mpp_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mpp_base))
+		return PTR_ERR(mpp_base);
+
 	soc->variant = (unsigned) match->data & 0xff;
 
 	switch (soc->variant) {
diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index b2e317e30759..fdb589b21d8d 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -379,7 +379,7 @@ static struct mvebu_mpp_ctrl dove_mpp_controls[] = {
 	MPP_FUNC_CTRL(13, 13, "mpp13", dove_pmu_mpp_ctrl),
 	MPP_FUNC_CTRL(14, 14, "mpp14", dove_pmu_mpp_ctrl),
 	MPP_FUNC_CTRL(15, 15, "mpp15", dove_pmu_mpp_ctrl),
-	MPP_REG_CTRL(16, 23),
+	MPP_FUNC_CTRL(16, 23, NULL, dove_mpp_ctrl),
 	MPP_FUNC_CTRL(24, 39, "mpp_camera", dove_mpp4_ctrl),
 	MPP_FUNC_CTRL(40, 45, "mpp_sdio0", dove_mpp4_ctrl),
 	MPP_FUNC_CTRL(46, 51, "mpp_sdio1", dove_mpp4_ctrl),
@@ -781,6 +781,7 @@ static struct of_device_id dove_pinctrl_of_match[] = {
 
 static int dove_pinctrl_probe(struct platform_device *pdev)
 {
+	struct resource *res;
 	const struct of_device_id *match =
 		of_match_device(dove_pinctrl_of_match, &pdev->dev);
 	pdev->dev.platform_data = (void *)match->data;
@@ -796,6 +797,11 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(clk);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mpp_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mpp_base))
+		return PTR_ERR(mpp_base);
+
 	return mvebu_pinctrl_probe(pdev);
 }
 
diff --git a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
index be8b2c9e2585..09f101946265 100644
--- a/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
+++ b/drivers/pinctrl/mvebu/pinctrl-kirkwood.c
@@ -383,7 +383,7 @@ static struct mvebu_mpp_mode mv88f6xxx_mpp_modes[] = {
 };
 
 static struct mvebu_mpp_ctrl mv88f6180_mpp_controls[] = {
-	MPP_REG_CTRL(0, 29),
+	MPP_FUNC_CTRL(0, 29, NULL, kirkwood_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv88f6180_gpio_ranges[] = {
@@ -391,7 +391,7 @@ static struct pinctrl_gpio_range mv88f6180_gpio_ranges[] = {
 };
 
 static struct mvebu_mpp_ctrl mv88f619x_mpp_controls[] = {
-	MPP_REG_CTRL(0, 35),
+	MPP_FUNC_CTRL(0, 35, NULL, kirkwood_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv88f619x_gpio_ranges[] = {
@@ -400,7 +400,7 @@ static struct pinctrl_gpio_range mv88f619x_gpio_ranges[] = {
 };
 
 static struct mvebu_mpp_ctrl mv88f628x_mpp_controls[] = {
-	MPP_REG_CTRL(0, 49),
+	MPP_FUNC_CTRL(0, 49, NULL, kirkwood_mpp_ctrl),
 };
 
 static struct pinctrl_gpio_range mv88f628x_gpio_ranges[] = {
@@ -480,9 +480,16 @@ static struct of_device_id kirkwood_pinctrl_of_match[] = {
 
 static int kirkwood_pinctrl_probe(struct platform_device *pdev)
 {
+	struct resource *res;
 	const struct of_device_id *match =
 		of_match_device(kirkwood_pinctrl_of_match, &pdev->dev);
 	pdev->dev.platform_data = (void *)match->data;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	mpp_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mpp_base))
+		return PTR_ERR(mpp_base);
+
 	return mvebu_pinctrl_probe(pdev);
 }
 
diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index 873aef5bdd9c..45e99e80502f 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -593,9 +593,7 @@ static int mvebu_pinctrl_build_functions(struct platform_device *pdev,
 int mvebu_pinctrl_probe(struct platform_device *pdev)
 {
 	struct mvebu_pinctrl_soc_info *soc = dev_get_platdata(&pdev->dev);
-	struct resource *res;
 	struct mvebu_pinctrl *pctl;
-	void __iomem *base;
 	struct pinctrl_pin_desc *pdesc;
 	unsigned gid, n, k;
 	unsigned size, noname = 0;
@@ -608,11 +606,6 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
 	pctl = devm_kzalloc(&pdev->dev, sizeof(struct mvebu_pinctrl),
 			GFP_KERNEL);
 	if (!pctl) {
@@ -626,7 +619,6 @@ int mvebu_pinctrl_probe(struct platform_device *pdev)
 	pctl->desc.pmxops = &mvebu_pinmux_ops;
 	pctl->desc.confops = &mvebu_pinconf_ops;
 	pctl->variant = soc->variant;
-	pctl->base = base;
 	pctl->dev = &pdev->dev;
 	platform_set_drvdata(pdev, pctl);
 
-- 
1.8.5.3

