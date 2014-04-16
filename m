Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaDPJNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:13:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58351 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755165AbaDPJJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:09:48 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sameo@linux.intel.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, ckeepax@opensource.wolfsonmicro.com
Subject: [PATCH 3/6] regulator: arizona-ldo1: Add processing of init_data from device tree
Date: Wed, 16 Apr 2014 10:01:39 +0100
Message-Id: <1397638902-7576-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1397638902-7576-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1397638902-7576-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-ldo1.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 2248733..d3787e1 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
 
@@ -178,12 +179,39 @@ static const struct regulator_init_data arizona_ldo1_default = {
 	.num_consumer_supplies = 1,
 };
 
-static int arizona_ldo1_of_get_pdata(struct arizona *arizona)
+static int arizona_ldo1_of_get_pdata(struct arizona *arizona,
+				     struct regulator_config *config)
 {
 	struct arizona_pdata *pdata = &arizona->pdata;
+	struct arizona_ldo1 *ldo1 = config->driver_data;
+	struct device_node *init_node, *dcvdd_node;
+	struct regulator_init_data *init_data;
 
 	pdata->ldoena = arizona_of_get_named_gpio(arizona, "wlf,ldoena", true);
 
+	init_node = of_get_child_by_name(arizona->dev->of_node, "ldo1");
+	dcvdd_node = of_parse_phandle(arizona->dev->of_node, "DCVDD-supply", 0);
+
+	if (init_node) {
+		config->of_node = init_node;
+
+		init_data = of_get_regulator_init_data(arizona->dev, init_node);
+
+		if (init_data) {
+			init_data->consumer_supplies = &ldo1->supply;
+			init_data->num_consumer_supplies = 1;
+
+			if (dcvdd_node && dcvdd_node != init_node)
+				arizona->external_dcvdd = true;
+
+			pdata->ldo1 = init_data;
+		}
+	} else if (dcvdd_node) {
+		arizona->external_dcvdd = true;
+	}
+
+	of_node_put(dcvdd_node);
+
 	return 0;
 }
 
@@ -230,7 +258,7 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 
 	if (IS_ENABLED(CONFIG_OF)) {
 		if (!dev_get_platdata(arizona->dev)) {
-			ret = arizona_ldo1_of_get_pdata(arizona);
+			ret = arizona_ldo1_of_get_pdata(arizona, &config);
 			if (ret < 0)
 				return ret;
 		}
@@ -258,6 +286,8 @@ static int arizona_ldo1_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	of_node_put(config.of_node);
+
 	platform_set_drvdata(pdev, ldo1);
 
 	return 0;
-- 
1.7.2.5

