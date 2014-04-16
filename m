Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaDPJLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:11:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58368 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755189AbaDPJJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:09:50 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, sameo@linux.intel.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, ckeepax@opensource.wolfsonmicro.com
Subject: [PATCH 5/6] regulator: arizona-micsupp: Add processing of init_data from device tree
Date: Wed, 16 Apr 2014 10:01:41 +0100
Message-Id: <1397638902-7576-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1397638902-7576-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1397638902-7576-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-micsupp.c |   37 +++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index 6fdd9bf..b80ebbe 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
@@ -195,6 +196,32 @@ static const struct regulator_init_data arizona_micsupp_ext_default = {
 	.num_consumer_supplies = 1,
 };
 
+static int arizona_micsupp_of_get_pdata(struct arizona *arizona,
+					struct regulator_config *config)
+{
+	struct arizona_pdata *pdata = &arizona->pdata;
+	struct arizona_micsupp *micsupp = config->driver_data;
+	struct device_node *np;
+	struct regulator_init_data *init_data;
+
+	np = of_get_child_by_name(arizona->dev->of_node, "micvdd");
+
+	if (np) {
+		config->of_node = np;
+
+		init_data = of_get_regulator_init_data(arizona->dev, np);
+
+		if (init_data) {
+			init_data->consumer_supplies = &micsupp->supply;
+			init_data->num_consumer_supplies = 1;
+
+			pdata->micvdd = init_data;
+		}
+	}
+
+	return 0;
+}
+
 static int arizona_micsupp_probe(struct platform_device *pdev)
 {
 	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
@@ -234,6 +261,14 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 	config.driver_data = micsupp;
 	config.regmap = arizona->regmap;
 
+	if (IS_ENABLED(CONFIG_OF)) {
+		if (!dev_get_platdata(arizona->dev)) {
+			ret = arizona_micsupp_of_get_pdata(arizona, &config);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
 	if (arizona->pdata.micvdd)
 		config.init_data = arizona->pdata.micvdd;
 	else
@@ -253,6 +288,8 @@ static int arizona_micsupp_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	of_node_put(config.of_node);
+
 	platform_set_drvdata(pdev, micsupp);
 
 	return 0;
-- 
1.7.2.5

