Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaBNNYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:24:31 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64179 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaBNNY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:24:29 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH] power: twl4030_madc_battery: Add device tree support.
Date: Fri, 14 Feb 2014 14:24:19 +0100
Message-Id: <1392384259-14311-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 .../bindings/power_supply/twl4030_madc_battery.txt |  15 +++
 drivers/power/twl4030_madc_battery.c               | 109 +++++++++++++++++++++
 2 files changed, 124 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt

diff --git a/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt b/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
new file mode 100644
index 0000000..bebc876
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
@@ -0,0 +1,15 @@
+twl4030_madc_battery
+
+Required properties:
+ - compatible : "ti,twl4030-madc-battery"
+ - capacity : battery capacity in uAh
+ - charging-calibration-data : list of voltage(mV):level(%) values for charging calibration (see example)
+ - discharging-calibration-data : list of voltage(mV):level(%) values for discharging calibration (see example)
+
+Example:
+	madc-battery {
+		compatible = "ti,twl4030-madc-battery";
+		capacity = <1200000>;
+		charging-calibration-data = <4200 100 4100 75 4000 55 3900 25 3800 5 3700 2 3600 1 3300 0>;
+		discharging-calibration-data = <4200 100 4100 95 4000 70 3800 50 3700 10 3600 5 3300 0>;
+	};
diff --git a/drivers/power/twl4030_madc_battery.c b/drivers/power/twl4030_madc_battery.c
index 7ef445a..2843382 100644
--- a/drivers/power/twl4030_madc_battery.c
+++ b/drivers/power/twl4030_madc_battery.c
@@ -19,6 +19,7 @@
 #include <linux/sort.h>
 #include <linux/i2c/twl4030-madc.h>
 #include <linux/power/twl4030_madc_battery.h>
+#include <linux/of.h>
 
 struct twl4030_madc_battery {
 	struct power_supply psy;
@@ -188,6 +189,110 @@ static int twl4030_cmp(const void *a, const void *b)
 		((struct twl4030_madc_bat_calibration *)a)->voltage;
 }
 
+#ifdef CONFIG_OF
+static struct twl4030_madc_bat_platform_data *
+	twl4030_madc_dt_probe(struct platform_device *pdev)
+{
+	struct twl4030_madc_bat_platform_data *pdata;
+	struct device_node *np = pdev->dev.of_node;
+	struct property *prop;
+	int ret;
+	int sz, i, j = 0;
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
+	prop = of_find_property(np, "charging-calibration-data", &sz);
+	if (!prop)
+		return ERR_PTR(-EINVAL);
+
+	if (sz % 2) {
+		dev_warn(&pdev->dev, "Count of charging-calibration-data must be even!\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	sz /= sizeof(u32);
+
+	{
+		u32 data[sz];
+
+		ret = of_property_read_u32_array(np,
+				"charging-calibration-data", &data[0], sz);
+		if (ret)
+			return ERR_PTR(ret);
+
+		pdata->charging = devm_kzalloc(&pdev->dev,
+				sizeof(struct twl4030_madc_bat_calibration) * (sz / 2),
+				GFP_KERNEL);
+
+		for (i = 0; i < sz; i += 2) {
+			pdata->charging[j].voltage = data[i];
+			pdata->charging[j].level = data[i+1];
+			j++;
+		}
+
+		pdata->charging_size = sz / 2;
+	}
+
+	/* parse and prepare discharging data */
+	prop = of_find_property(np, "discharging-calibration-data", &sz);
+	if (!prop)
+		return ERR_PTR(-EINVAL);
+
+	if (sz % 2) {
+		dev_warn(&pdev->dev, "Count of discharging-calibration-data must be even!\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	sz /= sizeof(u32);
+
+	{
+		u32 data[sz];
+
+		ret = of_property_read_u32_array(np,
+				"discharging-calibration-data", &data[0], sz);
+		if (ret)
+			return ERR_PTR(ret);
+
+		j = 0;
+
+		pdata->discharging = devm_kzalloc(&pdev->dev,
+				sizeof(struct twl4030_madc_bat_calibration) * (sz / 2),
+				GFP_KERNEL);
+
+		for (i = 0; i < sz; i += 2) {
+			pdata->discharging[j].voltage = data[i];
+			pdata->discharging[j].level = data[i+1];
+			j++;
+		}
+
+		pdata->discharging_size = sz / 2;
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
@@ -197,6 +302,9 @@ static int twl4030_madc_battery_probe(struct platform_device *pdev)
 	if (!twl4030_madc_bat)
 		return -ENOMEM;
 
+	if (!pdata)
+		pdata = twl4030_madc_dt_probe(pdev);
+
 	twl4030_madc_bat->psy.name = "twl4030_battery";
 	twl4030_madc_bat->psy.type = POWER_SUPPLY_TYPE_BATTERY;
 	twl4030_madc_bat->psy.properties = twl4030_madc_bat_props;
@@ -234,6 +342,7 @@ static int twl4030_madc_battery_remove(struct platform_device *pdev)
 static struct platform_driver twl4030_madc_battery_driver = {
 	.driver = {
 		.name = "twl4030_madc_battery",
+		.of_match_table = of_match_ptr(of_twl4030_madc_match),
 	},
 	.probe  = twl4030_madc_battery_probe,
 	.remove = twl4030_madc_battery_remove,
-- 
1.8.3.2

