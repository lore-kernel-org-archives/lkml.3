Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaDNSwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:52:36 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:32894 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbaDNSuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:50:39 -0400
From: Matt Porter <mporter@linaro.org>
To: Devicetree List <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Tim Kryger <tim.kryger@linaro.org>, Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/4] mfd: bcm590xx: add support for second i2c slave address space
Date: Mon, 14 Apr 2014 14:50:26 -0400
Message-Id: <1397501428-8857-3-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1397501428-8857-1-git-send-email-mporter@linaro.org>
References: <1397501428-8857-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BCM590xx utilizes a second i2c slave address to access additional
register space. Add support for the second address space by
instantiated a dummy i2c device with the appropriate secondary
i2c slave address. Expose a second regmap register space so that
mfd drivers can access this secondary i2c slave address space.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 drivers/mfd/bcm590xx.c       | 60 +++++++++++++++++++++++++++++++++-----------
 include/linux/mfd/bcm590xx.h |  9 ++++---
 2 files changed, 52 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/bcm590xx.c b/drivers/mfd/bcm590xx.c
index e9a33c7..b710ffa 100644
--- a/drivers/mfd/bcm590xx.c
+++ b/drivers/mfd/bcm590xx.c
@@ -28,39 +28,71 @@ static const struct mfd_cell bcm590xx_devs[] = {
 	},
 };
 
-static const struct regmap_config bcm590xx_regmap_config = {
+static const struct regmap_config bcm590xx_regmap_config_0 = {
 	.reg_bits	= 8,
 	.val_bits	= 8,
-	.max_register	= BCM590XX_MAX_REGISTER,
+	.max_register	= BCM590XX_MAX_REGISTER_0,
 	.cache_type	= REGCACHE_RBTREE,
 };
 
-static int bcm590xx_i2c_probe(struct i2c_client *i2c,
+static const struct regmap_config bcm590xx_regmap_config_1 = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.max_register	= BCM590XX_MAX_REGISTER_1,
+	.cache_type	= REGCACHE_RBTREE,
+};
+
+static int bcm590xx_i2c_probe(struct i2c_client *addmap0,
 			      const struct i2c_device_id *id)
 {
 	struct bcm590xx *bcm590xx;
 	int ret;
 
-	bcm590xx = devm_kzalloc(&i2c->dev, sizeof(*bcm590xx), GFP_KERNEL);
+	bcm590xx = devm_kzalloc(&addmap0->dev, sizeof(*bcm590xx), GFP_KERNEL);
 	if (!bcm590xx)
 		return -ENOMEM;
 
-	i2c_set_clientdata(i2c, bcm590xx);
-	bcm590xx->dev = &i2c->dev;
-	bcm590xx->i2c_client = i2c;
+	i2c_set_clientdata(addmap0, bcm590xx);
+	bcm590xx->dev = &addmap0->dev;
+	bcm590xx->addmap0 = addmap0;
 
-	bcm590xx->regmap = devm_regmap_init_i2c(i2c, &bcm590xx_regmap_config);
-	if (IS_ERR(bcm590xx->regmap)) {
-		ret = PTR_ERR(bcm590xx->regmap);
-		dev_err(&i2c->dev, "regmap initialization failed: %d\n", ret);
+	bcm590xx->regmap0 = devm_regmap_init_i2c(addmap0,
+						 &bcm590xx_regmap_config_0);
+	if (IS_ERR(bcm590xx->regmap0)) {
+		ret = PTR_ERR(bcm590xx->regmap0);
+		dev_err(&addmap0->dev, "regmap 0 init failed: %d\n", ret);
 		return ret;
 	}
 
-	ret = mfd_add_devices(&i2c->dev, -1, bcm590xx_devs,
+	/* Second I2C slave address is the base address with A(2) asserted */
+	bcm590xx->addmap1 = i2c_new_dummy(addmap0->adapter,
+					  addmap0->addr | BIT(2));
+	if (IS_ERR_OR_NULL(bcm590xx->addmap1)) {
+		dev_err(&addmap0->dev, "failed to add address map 1 device\n");
+		return -ENODEV;
+	}
+	i2c_set_clientdata(bcm590xx->addmap1, bcm590xx);
+
+	bcm590xx->regmap1 = devm_regmap_init_i2c(bcm590xx->addmap1,
+						&bcm590xx_regmap_config_1);
+	if (IS_ERR(bcm590xx->regmap1)) {
+		ret = PTR_ERR(bcm590xx->regmap1);
+		dev_err(&bcm590xx->addmap1->dev,
+			"regmap 1 init failed: %d\n", ret);
+		goto err;
+	}
+
+	ret = mfd_add_devices(&addmap0->dev, -1, bcm590xx_devs,
 			      ARRAY_SIZE(bcm590xx_devs), NULL, 0, NULL);
-	if (ret < 0)
-		dev_err(&i2c->dev, "failed to add sub-devices: %d\n", ret);
+	if (ret < 0) {
+		dev_err(&addmap0->dev, "failed to add sub-devices: %d\n", ret);
+		goto err;
+	}
+
+	return 0;
 
+err:
+	i2c_unregister_device(bcm590xx->addmap1);
 	return ret;
 }
 
diff --git a/include/linux/mfd/bcm590xx.h b/include/linux/mfd/bcm590xx.h
index 434df2d..a2723f2 100644
--- a/include/linux/mfd/bcm590xx.h
+++ b/include/linux/mfd/bcm590xx.h
@@ -19,12 +19,15 @@
 #include <linux/regmap.h>
 
 /* max register address */
-#define BCM590XX_MAX_REGISTER	0xe7
+#define BCM590XX_MAX_REGISTER_0	0xe7
+#define BCM590XX_MAX_REGISTER_1	0xf0
 
 struct bcm590xx {
 	struct device *dev;
-	struct i2c_client *i2c_client;
-	struct regmap *regmap;
+	struct i2c_client *addmap0;
+	struct i2c_client *addmap1;
+	struct regmap *regmap0;
+	struct regmap *regmap1;
 	unsigned int id;
 };
 
-- 
1.8.4

