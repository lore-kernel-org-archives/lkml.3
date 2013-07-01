Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab3GAWC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:02:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58464 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab3GAWCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:02:55 -0400
From: Mark Brown <broonie@kernel.org>
To: Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Date: Mon,  1 Jul 2013 23:02:19 +0100
Message-Id: <1372716139-5586-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: sec: Provide max_register to regmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Enable debugfs register dumps and greater error checking within the
regmap API providing the maximum register to the regmap API.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/sec-core.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index cc896d1..7976768 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -25,6 +25,9 @@
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/irq.h>
 #include <linux/mfd/samsung/rtc.h>
+#include <linux/mfd/samsung/s2mps11.h>
+#include <linux/mfd/samsung/s5m8763.h>
+#include <linux/mfd/samsung/s5m8767.h>
 #include <linux/regmap.h>
 
 static struct mfd_cell s5m8751_devs[] = {
@@ -105,6 +108,26 @@ static struct regmap_config sec_regmap_config = {
 	.val_bits = 8,
 };
 
+static struct regmap_config s2mps11_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = S2MPS11_REG_L38CTRL,
+};
+
+static struct regmap_config s5m8763_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = S5M8763_REG_LBCNFG2,
+};
+
+static struct regmap_config s5m8767_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = S5M8767_REG_LDO28CTRL,
+};
 
 #ifdef CONFIG_OF
 /*
@@ -160,6 +183,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct sec_platform_data *pdata = i2c->dev.platform_data;
+	const struct regmap_config *regmap;
 	struct sec_pmic_dev *sec_pmic;
 	int ret;
 
@@ -190,7 +214,22 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		sec_pmic->pdata = pdata;
 	}
 
-	sec_pmic->regmap = devm_regmap_init_i2c(i2c, &sec_regmap_config);
+	switch (sec_pmic->device_type) {
+	case S2MPS11X:
+		regmap = &s2mps11_regmap_config;
+		break;
+	case S5M8763X:
+		regmap = &s5m8763_regmap_config;
+		break;
+	case S5M8767X:
+		regmap = &s5m8767_regmap_config;
+		break;
+	default:
+		regmap = &sec_regmap_config;
+		break;
+	}
+
+	sec_pmic->regmap = devm_regmap_init_i2c(i2c, regmap);
 	if (IS_ERR(sec_pmic->regmap)) {
 		ret = PTR_ERR(sec_pmic->regmap);
 		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
-- 
1.8.3.1

