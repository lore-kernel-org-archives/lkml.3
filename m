Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaB0VaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:30:07 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:33923 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaB0VaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:30:03 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com, sre@ring0.de,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 2/3] power: twl4030_madc_battery: Add device tree support.
Date: Thu, 27 Feb 2014 22:29:29 +0100
Message-Id: <1393536570-29969-3-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393536570-29969-1-git-send-email-marek@goldelico.com>
References: <1393536570-29969-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 drivers/power/twl4030_madc_battery.c | 83 +++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/drivers/power/twl4030_madc_battery.c b/drivers/power/twl4030_madc_battery.c
index 42685df..24c69f7 100644
--- a/drivers/power/twl4030_madc_battery.c
+++ b/drivers/power/twl4030_madc_battery.c
@@ -20,6 +20,7 @@
 #include <linux/i2c/twl4030-madc.h>
 #include <linux/power/twl4030_madc_battery.h>
 #include <linux/iio/consumer.h>
+#include <linux/of.h>
 
 struct twl4030_madc_battery {
 	struct power_supply psy;
@@ -184,6 +185,82 @@ static int twl4030_cmp(const void *a, const void *b)
 		((struct twl4030_madc_bat_calibration *)a)->voltage;
 }
 
+#ifdef CONFIG_OF
+static struct twl4030_madc_bat_platform_data *
+	twl4030_madc_dt_probe(struct platform_device *pdev)
+{
+	struct twl4030_madc_bat_platform_data *pdata;
+	struct device_node *np = pdev->dev.of_node;
+	int ret;
+	int i, proplen;
+
+	pdata = devm_kzalloc(&pdev->dev,
+			sizeof(struct twl4030_madc_bat_platform_data),
+			GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	ret = of_property_read_u32(np, "capacity", &pdata->capacity);
+	if (ret != 0)
+		return ERR_PTR(-EINVAL);
+
+	/* parse and prepare charging data */
+	proplen = of_property_count_u32_elems(np, "charging-calibration-data");
+	if (proplen < 0) {
+		dev_warn(&pdev->dev, "No 'charging-calibration-data' property found\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	pdata->charging = devm_kzalloc(&pdev->dev,
+		sizeof(struct twl4030_madc_bat_calibration) * (proplen / 2),
+		GFP_KERNEL);
+
+	for (i = 0; i < proplen / 2; i++) {
+		of_property_read_u32_index(np, "charging-calibration-data",
+					   i * 2,
+					   (u32 *)&pdata->charging[i].voltage);
+		of_property_read_u32_index(np, "charging-calibration-data",
+					  i * 2 + 1,
+					  (u32 *)&pdata->charging[i].level);
+	}
+
+	/* parse and prepare discharging data */
+	proplen = of_property_count_u32_elems(np,
+			"discharging-calibration-data");
+	if (proplen < 0) {
+		dev_warn(&pdev->dev, "No 'discharging-calibration-data' property found\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	pdata->discharging = devm_kzalloc(&pdev->dev,
+		sizeof(struct twl4030_madc_bat_calibration) * (proplen / 2),
+		GFP_KERNEL);
+
+	for (i = 0; i < proplen / 2; i++) {
+		of_property_read_u32_index(np, "discharging-calibration-data",
+					   i * 2,
+					   (u32 *)&pdata->discharging[i].voltage);
+		of_property_read_u32_index(np, "discharging-calibration-data",
+					   i * 2 + 1,
+					   (u32 *)&pdata->discharging[i].level);
+	}
+
+	return pdata;
+}
+
+static const struct of_device_id of_twl4030_madc_match[] = {
+	{ .compatible = "ti,twl4030-madc-battery", },
+	{},
+};
+
+#else
+static struct twl4030_madc_bat_platform_data *
+	twl4030_madc_dt_probe(struct platform_device *pdev)
+{
+	return ERR_PTR(-ENODEV);
+}
+#endif
+
 static int twl4030_madc_battery_probe(struct platform_device *pdev)
 {
 	struct twl4030_madc_battery *twl4030_madc_bat;
@@ -193,6 +270,9 @@ static int twl4030_madc_battery_probe(struct platform_device *pdev)
 	if (!twl4030_madc_bat)
 		return -ENOMEM;
 
+	if (!pdata)
+		pdata = twl4030_madc_dt_probe(pdev);
+
 	twl4030_madc_bat->psy.name = "twl4030_battery";
 	twl4030_madc_bat->psy.type = POWER_SUPPLY_TYPE_BATTERY;
 	twl4030_madc_bat->psy.properties = twl4030_madc_bat_props;
@@ -201,7 +281,7 @@ static int twl4030_madc_battery_probe(struct platform_device *pdev)
 	twl4030_madc_bat->psy.get_property = twl4030_madc_bat_get_property;
 	twl4030_madc_bat->psy.external_power_changed =
 					twl4030_madc_bat_ext_changed;
-	 
+
 	twl4030_madc_bat->channel_temp = iio_channel_get(&pdev->dev, "temp");
 	if (IS_ERR(twl4030_madc_bat->channel_temp))
 		return PTR_ERR(twl4030_madc_bat->channel_temp);
@@ -242,6 +322,7 @@ static int twl4030_madc_battery_remove(struct platform_device *pdev)
 static struct platform_driver twl4030_madc_battery_driver = {
 	.driver = {
 		.name = "twl4030_madc_battery",
+		.of_match_table = of_match_ptr(of_twl4030_madc_match),
 	},
 	.probe  = twl4030_madc_battery_probe,
 	.remove = twl4030_madc_battery_remove,
-- 
1.8.3.2

