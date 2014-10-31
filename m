Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761187AbaJaHKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:10:07 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52392 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761170AbaJaHKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:10:02 -0400
From: gyungoh@gmail.com
X-Google-Original-From: jack.yoo@skyworksinc.com
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
Subject: [RESUBMIT PATCH v6 7/8] regulator: sky81452: Add compatible string for device binding
Date: Fri, 31 Oct 2014 16:08:41 +0900
Message-Id: <1414739322-12487-8-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gyungoh Yoo <jack.yoo@skyworksinc.com>

Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
---
Changes v6:
Added new line character at the end of line of dev_err()

Changes v5:
Changed DT for regulator : 'lout' node should be defined under 'regulator'
Removed compatible string
Modified to return EINVAL when of_node is NULL

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
 drivers/regulator/sky81452-regulator.c | 29 +++++++++++++++++++----------
 2 files changed, 20 insertions(+), 11 deletions(-)

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
index 97aff0c..23a3bd6 100644
--- a/drivers/regulator/sky81452-regulator.c
+++ b/drivers/regulator/sky81452-regulator.c
@@ -65,21 +65,29 @@ static const struct regulator_desc sky81452_reg = {
 };
 
 #ifdef CONFIG_OF
+static struct of_regulator_match sky81452_match = {
+	.name = "lout"
+};
+
 static struct regulator_init_data *sky81452_reg_parse_dt(struct device *dev)
 {
-	struct regulator_init_data *init_data;
 	struct device_node *np;
+	int ret;
 
 	np = of_get_child_by_name(dev->parent->of_node, "regulator");
-	if (unlikely(!np)) {
-		dev_err(dev, "regulator node not found");
-		return NULL;
+	if (!np) {
+		dev_err(dev, "regulator node not found.\n");
+		return ERR_PTR(-EINVAL);
 	}
 
-	init_data = of_get_regulator_init_data(dev, np);
-
+	ret = of_regulator_match(dev, np, &sky81452_match, 1);
 	of_node_put(np);
-	return init_data;
+	if (IS_ERR_VALUE(ret)) {
+		dev_err(dev, "Error parsing init data. err=%d\n", ret);
+		return ERR_PTR(ret);
+	}
+
+	return &sky81452_match.init_data;
 }
 #else
 static struct regulator_init_data *sky81452_reg_parse_dt(struct device *dev)
@@ -107,8 +115,10 @@ static int sky81452_reg_probe(struct platform_device *pdev)
 	config.regmap = dev_get_drvdata(dev->parent);
 
 	rdev = devm_regulator_register(dev, &sky81452_reg, &config);
-	if (IS_ERR(rdev))
+	if (IS_ERR(rdev)) {
+		dev_err(dev, "failed to register. err=%ld\n", PTR_ERR(rdev));
 		return PTR_ERR(rdev);
+	}
 
 	platform_set_drvdata(pdev, rdev);
 
@@ -126,5 +136,4 @@ module_platform_driver(sky81452_reg_driver);
 
 MODULE_DESCRIPTION("Skyworks SKY81452 Regulator driver");
 MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
-MODULE_LICENSE("GPL");
-MODULE_VERSION("1.0");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

