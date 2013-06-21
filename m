Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030546Ab3FUGa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:30:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50812 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030412Ab3FUGaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:30:25 -0400
Date: Fri, 21 Jun 2013 08:30:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH 1/2] regulators: max8973: fix multiple instance support
Message-ID: <Pine.LNX.4.64.1306210825040.27277@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:ogqbjZhI9doCvGL0G7nRmhe4TW53KFk2VX2z+bIKpif
 G2AAWwh7BLy01w3YMkFtqZdMQxx5B4npBG1oNt1l5VekSBkQfS
 n7AVd0HGd4NshiJ74B3bj0ujthpcpRHQLQQzB+KRb5r5p9T5TQ
 NzfKKaDWvMJGMsKM3RlV+JUr5XsL1XBaiXN5a4NDt5hTiQXjtF
 MW+NWnW/8zO0IBlhZrHKAGr3y7HHrHyJy1nN3n8SslPpkcvpfM
 49i+kHJ5ya8m0nfMqPQTFWRC9cvMDK6t54C+sRwC2L68PDkKuN
 QSPsKP6ue00c5YCr9ZUD+3Y9PbP3hV3liCCKc1ta5Fja2A4cH/
 USeOMt6BAtjyl/O6olydcgb2J2+ceQyerQQuvhx3j49UMEDS+m
 8/b/mdySFRrVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the max8973 regulator driver uses a single static struct of
regulator operations for all chip instances, but can overwrite some of its
members depending on configuration. This will affect all other MAX8973
instances on the system. This patch fixes this bug by allocating a separate
copy of the struct for each chip instance.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/regulator/max8973-regulator.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index adb1414..b2dbdd7 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -100,6 +100,7 @@ struct max8973_chip {
 	int curr_vout_reg;
 	int curr_gpio_val;
 	bool valid_dvs_gpio;
+	struct regulator_ops ops;
 };
 
 /*
@@ -240,7 +241,7 @@ static unsigned int max8973_dcdc_get_mode(struct regulator_dev *rdev)
 		REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
 }
 
-static struct regulator_ops max8973_dcdc_ops = {
+static const struct regulator_ops max8973_dcdc_ops = {
 	.get_voltage_sel	= max8973_dcdc_get_voltage_sel,
 	.set_voltage_sel	= max8973_dcdc_set_voltage_sel,
 	.list_voltage		= regulator_list_voltage_linear,
@@ -388,10 +389,11 @@ static int max8973_probe(struct i2c_client *client,
 	}
 
 	i2c_set_clientdata(client, max);
+	max->ops = max8973_dcdc_ops;
 	max->dev = &client->dev;
 	max->desc.name = id->name;
 	max->desc.id = 0;
-	max->desc.ops = &max8973_dcdc_ops;
+	max->desc.ops = &max->ops;
 	max->desc.type = REGULATOR_VOLTAGE;
 	max->desc.owner = THIS_MODULE;
 	max->desc.min_uV = MAX8973_MIN_VOLATGE;
@@ -401,9 +403,9 @@ static int max8973_probe(struct i2c_client *client,
 	if (!pdata->enable_ext_control) {
 		max->desc.enable_reg = MAX8973_VOUT;
 		max->desc.enable_mask = MAX8973_VOUT_ENABLE;
-		max8973_dcdc_ops.enable = regulator_enable_regmap;
-		max8973_dcdc_ops.disable = regulator_disable_regmap;
-		max8973_dcdc_ops.is_enabled = regulator_is_enabled_regmap;
+		max->ops.enable = regulator_enable_regmap;
+		max->ops.disable = regulator_disable_regmap;
+		max->ops.is_enabled = regulator_is_enabled_regmap;
 	}
 
 	max->enable_external_control = pdata->enable_ext_control;
-- 
1.7.2.5

