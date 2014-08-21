Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaHUCbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:31:40 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63085 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaHUCbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:31:38 -0400
Message-ID: <1408588293.10818.3.camel@phoenix>
Subject: [PATCH] regulator: hi6421: Remove unused fields from struct
 hi6421_regulator_info
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: Guodong Xu <guodong.xu@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 21 Aug 2014 10:31:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The valid_modes_mask and *dev are not used in this driver, remove them.
Current code uses devm_regulator_register, so we don't need *regulator in
hi6421_regulator_info. Use a local variable instead.

Also removes a few unnecessary inclusion of header files.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/hi6421-regulator.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/hi6421-regulator.c b/drivers/regulator/hi6421-regulator.c
index b0de92b..e389920 100644
--- a/drivers/regulator/hi6421-regulator.c
+++ b/drivers/regulator/hi6421-regulator.c
@@ -17,19 +17,13 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <linux/io.h>
-#include <linux/jiffies.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
-#include <linux/of_device.h>
-#include <linux/of_address.h>
 #include <linux/regmap.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
 #include <linux/mfd/hi6421-pmic.h>
-#include <linux/delay.h>
-#include <linux/time.h>
 
 /*
  * struct hi6421_regulator_pdata - Hi6421 regulator data of platform device
@@ -41,20 +35,14 @@ struct hi6421_regulator_pdata {
 
 /*
  * struct hi6421_regulator_info - hi6421 regulator information
- * @dev: device pointer
  * @desc: regulator description
- * @regulator: regulator device
  * @mode_mask: ECO mode bitmask of LDOs; for BUCKs, this masks sleep
  * @eco_microamp: eco mode load upper limit (in mA), valid for LDOs only
- * @valid_modes_mask: valid operating modes
  */
 struct hi6421_regulator_info {
-	struct device		*dev;
 	struct regulator_desc	desc;
-	struct regulator_dev	*regulator;
 	u8		mode_mask;
 	u32		eco_microamp;
-	unsigned int	valid_modes_mask;
 };
 
 /* HI6421 regulators */
@@ -198,8 +186,6 @@ static const struct regulator_ops hi6421_buck345_ops;
 		},							\
 		.mode_mask		= ecomask,			\
 		.eco_microamp		= ecoamp,			\
-		.valid_modes_mask	= (REGULATOR_MODE_NORMAL	\
-					   | REGULATOR_MODE_IDLE),	\
 	}
 
 /* HI6421 LDO1~3 are linear voltage regulators at fixed uV_step
@@ -237,8 +223,6 @@ static const struct regulator_ops hi6421_buck345_ops;
 		},							\
 		.mode_mask		= ecomask,			\
 		.eco_microamp		= ecoamp,			\
-		.valid_modes_mask	= (REGULATOR_MODE_NORMAL	\
-					   | REGULATOR_MODE_IDLE),	\
 	}
 
 /* HI6421 LDOAUDIO is a linear voltage regulator with two 4-step ranges
@@ -276,8 +260,6 @@ static const struct regulator_ops hi6421_buck345_ops;
 		},							\
 		.mode_mask		= ecomask,			\
 		.eco_microamp		= ecoamp,			\
-		.valid_modes_mask	= (REGULATOR_MODE_NORMAL	\
-					   | REGULATOR_MODE_IDLE),	\
 	}
 
 /* HI6421 BUCK0/1/2 are linear voltage regulators at fixed uV_step
@@ -311,8 +293,6 @@ static const struct regulator_ops hi6421_buck345_ops;
 			.off_on_delay	= odelay,			\
 		},							\
 		.mode_mask		= sleepmask,			\
-		.valid_modes_mask	= (REGULATOR_MODE_NORMAL	\
-					   | REGULATOR_MODE_STANDBY),	\
 	}
 
 /* HI6421 BUCK3/4/5 share similar configurations as LDOs, with exception
@@ -346,8 +326,6 @@ static const struct regulator_ops hi6421_buck345_ops;
 			.off_on_delay	= odelay,			\
 		},							\
 		.mode_mask		= sleepmask,			\
-		.valid_modes_mask	= (REGULATOR_MODE_NORMAL	\
-					   | REGULATOR_MODE_STANDBY),	\
 	}
 
 /* HI6421 regulator information */
@@ -580,10 +558,10 @@ static int hi6421_regulator_register(struct platform_device *pdev,
 {
 	struct hi6421_regulator_info *info = NULL;
 	struct regulator_config config = { };
+	struct regulator_dev *rdev;
 
 	/* assign per-regulator data */
 	info = &hi6421_regulator_info[id];
-	info->dev = &pdev->dev;
 
 	config.dev = &pdev->dev;
 	config.init_data = init_data;
@@ -592,12 +570,11 @@ static int hi6421_regulator_register(struct platform_device *pdev,
 	config.of_node = np;
 
 	/* register regulator with framework */
-	info->regulator = devm_regulator_register(&pdev->dev, &info->desc,
-						&config);
-	if (IS_ERR(info->regulator)) {
+	rdev = devm_regulator_register(&pdev->dev, &info->desc, &config);
+	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 			info->desc.name);
-		return PTR_ERR(info->regulator);
+		return PTR_ERR(rdev);
 	}
 
 	return 0;
-- 
1.9.1



