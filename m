Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161152Ab3DEMMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:12:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36227 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765141Ab3DEMMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:12:42 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: wm8994: Provide default init data
Date: Fri,  5 Apr 2013 13:12:30 +0100
Message-Id: <1365163950-6658-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost all systems use the regulators on the WM8994 series devices to
provide DCVDD and AVDD1 so if no init data is supplied then set up the
supplies for the user. This simplifies integration of the device into
systems, especially when device tree is supported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm8994-regulator.c |   41 ++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 5115881..f03fbf1 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -18,6 +18,7 @@
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
 
@@ -28,6 +29,8 @@
 struct wm8994_ldo {
 	struct regulator_dev *regulator;
 	struct wm8994 *wm8994;
+	struct regulator_consumer_supply supply;
+	struct regulator_init_data init_data;
 };
 
 #define WM8994_LDO1_MAX_SELECTOR 0x7
@@ -99,6 +102,26 @@ static const struct regulator_desc wm8994_ldo_desc[] = {
 	},
 };
 
+static const struct regulator_consumer_supply wm8994_ldo_consumer[] = {
+	{ .supply = "AVDD1" },
+	{ .supply = "DCVDD" },
+};
+
+static const struct regulator_init_data wm8994_ldo_default[] = {
+	{
+		.constraints = {
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = 1,
+	},
+	{
+		.constraints = {
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.num_consumer_supplies = 1,
+	},
+};
+
 static int wm8994_ldo_probe(struct platform_device *pdev)
 {
 	struct wm8994 *wm8994 = dev_get_drvdata(pdev->dev.parent);
@@ -117,13 +140,27 @@ static int wm8994_ldo_probe(struct platform_device *pdev)
 	}
 
 	ldo->wm8994 = wm8994;
+	ldo->supply = wm8994_ldo_consumer[id];
+	ldo->supply.dev_name = dev_name(wm8994->dev);
 
 	config.dev = wm8994->dev;
 	config.driver_data = ldo;
 	config.regmap = wm8994->regmap;
-	if (pdata) {
-		config.init_data = pdata->ldo[id].init_data;
+	config.init_data = &ldo->init_data;
+	if (pdata)
 		config.ena_gpio = pdata->ldo[id].enable;
+
+	/* Use default constraints if none set up */
+	if (!pdata || !pdata->ldo[id].init_data) {
+		dev_dbg(wm8994->dev, "Using default init data, supply %s %s\n",
+			ldo->supply.dev_name, ldo->supply.supply);
+
+		ldo->init_data = wm8994_ldo_default[id];
+		ldo->init_data.consumer_supplies = &ldo->supply;
+		if (!config.ena_gpio)
+			ldo->init_data.constraints.valid_ops_mask = 0;
+	} else {
+		ldo->init_data = *pdata->ldo[id].init_data;
 	}
 
 	ldo->regulator = regulator_register(&wm8994_ldo_desc[id], &config);
-- 
1.7.10.4

