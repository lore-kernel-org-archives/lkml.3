Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaAYUsn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 15:48:43 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59134 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaAYUsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 15:48:41 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND TAKE 3] clk: si5351: remove variant from platform_data
Date: Sat, 25 Jan 2014 21:48:31 +0100
Message-Id: <1390682911-9022-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9807362bfe1748d9bb48eecb9261f1b1aaafea1c
  "clk: si5351: declare all device IDs for module loading"
removed the common i2c_device_id and introduced new ones for each variant
of the clock generator. Instead of exploiting that information in the driver,
it still depends on platform_data passing the chips .variant.

This removes the now redundant .variant from the platform_data and puts it in
i2c_device_id's .driver_data instead.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Mike,

this is the patch I mentioned during ARM summit ;). Still applies to
pre-v3.14-rc1 cleanly. Maybe it is time to take it now?

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/clk-si5351.c             |   28 ++++++++++++----------------
 drivers/clk/clk-si5351.h             |   14 ++++++++++++++
 include/linux/platform_data/si5351.h |   16 ----------------
 3 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index c50e837..b95aa09 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -1111,11 +1111,11 @@ static const struct of_device_id si5351_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, si5351_dt_ids);
 
-static int si5351_dt_parse(struct i2c_client *client)
+static int si5351_dt_parse(struct i2c_client *client,
+			   enum si5351_variant variant)
 {
 	struct device_node *child, *np = client->dev.of_node;
 	struct si5351_platform_data *pdata;
-	const struct of_device_id *match;
 	struct property *prop;
 	const __be32 *p;
 	int num = 0;
@@ -1124,15 +1124,10 @@ static int si5351_dt_parse(struct i2c_client *client)
 	if (np == NULL)
 		return 0;
 
-	match = of_match_node(si5351_dt_ids, np);
-	if (match == NULL)
-		return -EINVAL;
-
 	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
-	pdata->variant = (enum si5351_variant)match->data;
 	pdata->clk_xtal = of_clk_get(np, 0);
 	if (!IS_ERR(pdata->clk_xtal))
 		clk_put(pdata->clk_xtal);
@@ -1163,7 +1158,7 @@ static int si5351_dt_parse(struct i2c_client *client)
 			pdata->pll_src[num] = SI5351_PLL_SRC_XTAL;
 			break;
 		case 1:
-			if (pdata->variant != SI5351_VARIANT_C) {
+			if (variant != SI5351_VARIANT_C) {
 				dev_err(&client->dev,
 					"invalid parent %d for pll %d\n",
 					val, num);
@@ -1187,7 +1182,7 @@ static int si5351_dt_parse(struct i2c_client *client)
 		}
 
 		if (num >= 8 ||
-		    (pdata->variant == SI5351_VARIANT_A3 && num >= 3)) {
+		    (variant == SI5351_VARIANT_A3 && num >= 3)) {
 			dev_err(&client->dev, "invalid clkout %d\n", num);
 			return -EINVAL;
 		}
@@ -1226,7 +1221,7 @@ static int si5351_dt_parse(struct i2c_client *client)
 					SI5351_CLKOUT_SRC_XTAL;
 				break;
 			case 3:
-				if (pdata->variant != SI5351_VARIANT_C) {
+				if (variant != SI5351_VARIANT_C) {
 					dev_err(&client->dev,
 						"invalid parent %d for clkout %d\n",
 						val, num);
@@ -1307,6 +1302,7 @@ static int si5351_dt_parse(struct i2c_client *client)
 static int si5351_i2c_probe(struct i2c_client *client,
 			    const struct i2c_device_id *id)
 {
+	enum si5351_variant variant = (enum si5351_variant)id->driver_data;
 	struct si5351_platform_data *pdata;
 	struct si5351_driver_data *drvdata;
 	struct clk_init_data init;
@@ -1315,7 +1311,7 @@ static int si5351_i2c_probe(struct i2c_client *client,
 	u8 num_parents, num_clocks;
 	int ret, n;
 
-	ret = si5351_dt_parse(client);
+	ret = si5351_dt_parse(client, variant);
 	if (ret)
 		return ret;
 
@@ -1331,7 +1327,7 @@ static int si5351_i2c_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, drvdata);
 	drvdata->client = client;
-	drvdata->variant = pdata->variant;
+	drvdata->variant = variant;
 	drvdata->pxtal = pdata->clk_xtal;
 	drvdata->pclkin = pdata->clk_clkin;
 
@@ -1568,10 +1564,10 @@ static int si5351_i2c_probe(struct i2c_client *client,
 }
 
 static const struct i2c_device_id si5351_i2c_ids[] = {
-	{ "si5351a", 0 },
-	{ "si5351a-msop", 0 },
-	{ "si5351b", 0 },
-	{ "si5351c", 0 },
+	{ "si5351a", SI5351_VARIANT_A },
+	{ "si5351a-msop", SI5351_VARIANT_A3 },
+	{ "si5351b", SI5351_VARIANT_B },
+	{ "si5351c", SI5351_VARIANT_C },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, si5351_i2c_ids);
diff --git a/drivers/clk/clk-si5351.h b/drivers/clk/clk-si5351.h
index c0dbf26..4d0746b 100644
--- a/drivers/clk/clk-si5351.h
+++ b/drivers/clk/clk-si5351.h
@@ -153,4 +153,18 @@
 #define  SI5351_XTAL_ENABLE			(1<<6)
 #define  SI5351_MULTISYNTH_ENABLE		(1<<4)
 
+/**
+ * enum si5351_variant - SiLabs Si5351 chip variant
+ * @SI5351_VARIANT_A: Si5351A (8 output clocks, XTAL input)
+ * @SI5351_VARIANT_A3: Si5351A MSOP10 (3 output clocks, XTAL input)
+ * @SI5351_VARIANT_B: Si5351B (8 output clocks, XTAL/VXCO input)
+ * @SI5351_VARIANT_C: Si5351C (8 output clocks, XTAL/CLKIN input)
+ */
+enum si5351_variant {
+	SI5351_VARIANT_A = 1,
+	SI5351_VARIANT_A3 = 2,
+	SI5351_VARIANT_B = 3,
+	SI5351_VARIANT_C = 4,
+};
+
 #endif
diff --git a/include/linux/platform_data/si5351.h b/include/linux/platform_data/si5351.h
index 5433439..a947ab8 100644
--- a/include/linux/platform_data/si5351.h
+++ b/include/linux/platform_data/si5351.h
@@ -8,20 +8,6 @@
 struct clk;
 
 /**
- * enum si5351_variant - SiLabs Si5351 chip variant
- * @SI5351_VARIANT_A: Si5351A (8 output clocks, XTAL input)
- * @SI5351_VARIANT_A3: Si5351A MSOP10 (3 output clocks, XTAL input)
- * @SI5351_VARIANT_B: Si5351B (8 output clocks, XTAL/VXCO input)
- * @SI5351_VARIANT_C: Si5351C (8 output clocks, XTAL/CLKIN input)
- */
-enum si5351_variant {
-	SI5351_VARIANT_A = 1,
-	SI5351_VARIANT_A3 = 2,
-	SI5351_VARIANT_B = 3,
-	SI5351_VARIANT_C = 4,
-};
-
-/**
  * enum si5351_pll_src - Si5351 pll clock source
  * @SI5351_PLL_SRC_DEFAULT: default, do not change eeprom config
  * @SI5351_PLL_SRC_XTAL: pll source clock is XTAL input
@@ -115,14 +101,12 @@ struct si5351_clkout_config {
 
 /**
  * struct si5351_platform_data - Platform data for the Si5351 clock driver
- * @variant: Si5351 chip variant
  * @clk_xtal: xtal input clock
  * @clk_clkin: clkin input clock
  * @pll_src: array of pll source clock setting
  * @clkout: array of clkout configuration
  */
 struct si5351_platform_data {
-	enum si5351_variant variant;
 	struct clk *clk_xtal;
 	struct clk *clk_clkin;
 	enum si5351_pll_src pll_src[2];
-- 
1.7.10.4

