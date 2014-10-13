Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaJMFtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 01:49:35 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46065 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaJMFta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 01:49:30 -0400
From: Gyungoh Yoo <gyungoh@gmail.com>
X-Google-Original-From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
To: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, broonie@kernel.org, lgirdwood@gmail.com
Cc: jack.yoo@skyworksinc.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: [RESUBMIT PATCH v4 7/8] regulator: sky81452: Add compatible string for device binding
Date: Mon, 13 Oct 2014 14:47:41 +0900
Message-Id: <1413179262-27636-8-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
---
Changes v4:
Removed MODULE_VERSION()
Modified license to GPLv2

Changes v3:
Modified to return ENODATA when of_node is NULL
Modified the messages in error cases

Changes v2:
Added 'compatible' attribute in the driver
Added message for exception or errors.

 drivers/regulator/Kconfig              |  2 +-
 drivers/regulator/sky81452-regulator.c | 23 ++++++++++++++++-------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 55d7b7b..fe84bd4 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -547,7 +547,7 @@ config REGULATOR_S5M8767
 
 config REGULATOR_SKY81452
 	tristate "Skyworks Solutions SKY81452 voltage regulator"
-	depends on SKY81452
+	depends on MFD_SKY81452
 	help
 	  This driver supports Skyworks SKY81452 voltage output regulator
 	  via I2C bus. SKY81452 has one voltage linear regulator can be
diff --git a/drivers/regulator/sky81452-regulator.c b/drivers/regulator/sky81452-regulator.c
index 97aff0c..dfdefdb 100644
--- a/drivers/regulator/sky81452-regulator.c
+++ b/drivers/regulator/sky81452-regulator.c
@@ -68,12 +68,11 @@ static const struct regulator_desc sky81452_reg = {
 static struct regulator_init_data *sky81452_reg_parse_dt(struct device *dev)
 {
 	struct regulator_init_data *init_data;
-	struct device_node *np;
+	struct device_node *np = of_node_get(dev->of_node);
 
-	np = of_get_child_by_name(dev->parent->of_node, "regulator");
-	if (unlikely(!np)) {
+	if (!np) {
 		dev_err(dev, "regulator node not found");
-		return NULL;
+		return ERR_PTR(-ENODATA);
 	}
 
 	init_data = of_get_regulator_init_data(dev, np);
@@ -107,17 +106,28 @@ static int sky81452_reg_probe(struct platform_device *pdev)
 	config.regmap = dev_get_drvdata(dev->parent);
 
 	rdev = devm_regulator_register(dev, &sky81452_reg, &config);
-	if (IS_ERR(rdev))
+	if (IS_ERR(rdev)) {
+		dev_err(dev, "failed to register. err=%ld", PTR_ERR(rdev));
 		return PTR_ERR(rdev);
+	}
 
 	platform_set_drvdata(pdev, rdev);
 
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static const struct of_device_id sky81452_reg_of_match[] = {
+	{ .compatible = "skyworks,sky81452-regulator", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sky81452_reg_of_match);
+#endif
+
 static struct platform_driver sky81452_reg_driver = {
 	.driver = {
 		.name = "sky81452-regulator",
+		.of_match_table = of_match_ptr(sky81452_reg_of_match),
 	},
 	.probe = sky81452_reg_probe,
 };
@@ -126,5 +136,4 @@ module_platform_driver(sky81452_reg_driver);
 
 MODULE_DESCRIPTION("Skyworks SKY81452 Regulator driver");
 MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
-MODULE_LICENSE("GPL");
-MODULE_VERSION("1.0");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

