Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaIPQaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:30:21 -0400
Received: from gloria.sntech.de ([95.129.55.99]:55906 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbaIPQaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:30:19 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH v2 1/4] regulator: fan53555: use set_ramp_delay to set the ramp up slew rate
Date: Tue, 16 Sep 2014 17:54:01 +0200
Message-Id: <1410882844-10349-2-git-send-email-heiko@sntech.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1410882844-10349-1-git-send-email-heiko@sntech.de>
References: <1410882844-10349-1-git-send-email-heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator constraints already provide a field for the ramp_delay, so
there is no need to set this manually. Therefore implement the set_ramp_delay
callback and convert the pdata value to the constraint value if necessary.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/regulator/fan53555.c | 53 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index c912ba7..5808435 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -135,6 +135,38 @@ static unsigned int fan53555_get_mode(struct regulator_dev *rdev)
 		return REGULATOR_MODE_NORMAL;
 }
 
+static int slew_rates[] = {
+	64000,
+	32000,
+	16000,
+	 8000,
+	 4000,
+	 2000,
+	 1000,
+	  500,
+};
+
+static int fan53555_set_ramp(struct regulator_dev *rdev, int ramp)
+{
+	struct fan53555_device_info *di = rdev_get_drvdata(rdev);
+	int regval = -1, i;
+
+	for (i = 0; i < ARRAY_SIZE(slew_rates); i++) {
+		if (ramp <= slew_rates[i])
+			regval = i;
+		else
+			break;
+	}
+
+	if (regval < 0) {
+		dev_err(di->dev, "unsupported ramp value %d\n", ramp);
+		return -EINVAL;
+	}
+
+	return regmap_update_bits(di->regmap, FAN53555_CONTROL,
+				  CTL_SLEW_MASK, regval << CTL_SLEW_SHIFT);
+}
+
 static struct regulator_ops fan53555_regulator_ops = {
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
@@ -146,6 +178,7 @@ static struct regulator_ops fan53555_regulator_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 	.set_mode = fan53555_set_mode,
 	.get_mode = fan53555_get_mode,
+	.set_ramp_delay = fan53555_set_ramp,
 };
 
 /* For 00,01,03,05 options:
@@ -156,8 +189,6 @@ static struct regulator_ops fan53555_regulator_ops = {
 static int fan53555_device_setup(struct fan53555_device_info *di,
 				struct fan53555_platform_data *pdata)
 {
-	unsigned int reg, data, mask;
-
 	/* Setup voltage control register */
 	switch (pdata->sleep_vsel_id) {
 	case FAN53555_VSEL_ID_0:
@@ -190,15 +221,8 @@ static int fan53555_device_setup(struct fan53555_device_info *di,
 			"Chip ID[%d]\n not supported!\n", di->chip_id);
 		return -EINVAL;
 	}
-	/* Init slew rate */
-	if (pdata->slew_rate & 0x7)
-		di->slew_rate = pdata->slew_rate;
-	else
-		di->slew_rate = FAN53555_SLEW_RATE_64MV;
-	reg = FAN53555_CONTROL;
-	data = di->slew_rate << CTL_SLEW_SHIFT;
-	mask = CTL_SLEW_MASK;
-	return regmap_update_bits(di->regmap, reg, mask, data);
+
+	return 0;
 }
 
 static int fan53555_regulator_register(struct fan53555_device_info *di,
@@ -248,6 +272,13 @@ static int fan53555_regulator_probe(struct i2c_client *client,
 	if (!di)
 		return -ENOMEM;
 
+	/* if no ramp constraint set, get the pdata ramp_delay */
+	if (!di->regulator->constraints.ramp_delay) {
+		int slew_idx = (pdata->slew_rate & 0x7) ? pdata->slew_rate : 0;
+
+		di->regulator->constraints.ramp_delay = slew_rates[slew_idx];
+	}
+
 	di->regmap = devm_regmap_init_i2c(client, &fan53555_regmap_config);
 	if (IS_ERR(di->regmap)) {
 		dev_err(&client->dev, "Failed to allocate regmap!\n");
-- 
2.0.1

