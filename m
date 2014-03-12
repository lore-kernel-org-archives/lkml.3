Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaCLOZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:25:38 -0400
Received: from gloria.sntech.de ([95.129.55.99]:44676 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbaCLOZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:25:35 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 2/3] power: gpio-charger: add device tree support
Date: Wed, 12 Mar 2014 14:48:16 +0100
Message-ID: <2397129.GGrYQoE9LA@phil>
User-Agent: KMail/4.11.5 (Linux/3.12-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <12569216.pGctOhkhxz@phil>
References: <12569216.pGctOhkhxz@phil>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@bq.com>

Add the ability to parse gpio-charger data from a devicetree node.

Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>
---
 drivers/power/gpio-charger.c | 66 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 3 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index a0024b2..64d31a8 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -22,6 +22,8 @@
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 
 #include <linux/power/gpio-charger.h>
 
@@ -69,17 +71,68 @@ static enum power_supply_property gpio_charger_properties[] = {
 	POWER_SUPPLY_PROP_ONLINE,
 };
 
+static
+struct gpio_charger_platform_data *gpio_charger_parse_dt(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct gpio_charger_platform_data *pdata;
+	const char *chargetype;
+	enum of_gpio_flags flags;
+	int ret;
+
+	if (!np)
+		return ERR_PTR(-ENOENT);
+
+	pdata = devm_kzalloc(dev, sizeof(struct gpio_charger_platform_data),
+			     GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	pdata->name = np->name;
+
+	pdata->gpio = of_get_gpio_flags(np, 0, &flags);
+	pdata->gpio_active_low = flags & OF_GPIO_ACTIVE_LOW;
+
+	pdata->type = POWER_SUPPLY_TYPE_UNKNOWN;
+	ret = of_property_read_string(np, "charger-type", &chargetype);
+	if (ret >= 0) {
+		if (!strncmp("unknown", chargetype, 7))
+			pdata->type = POWER_SUPPLY_TYPE_UNKNOWN;
+		else if (!strncmp("battery", chargetype, 7))
+			pdata->type = POWER_SUPPLY_TYPE_BATTERY;
+		else if (!strncmp("ups", chargetype, 3))
+			pdata->type = POWER_SUPPLY_TYPE_UPS;
+		else if (!strncmp("mains", chargetype, 5))
+			pdata->type = POWER_SUPPLY_TYPE_MAINS;
+		else if (!strncmp("usb-sdp", chargetype, 7))
+			pdata->type = POWER_SUPPLY_TYPE_USB;
+		else if (!strncmp("usb-dcp", chargetype, 7))
+			pdata->type = POWER_SUPPLY_TYPE_USB_DCP;
+		else if (!strncmp("usb-cdp", chargetype, 7))
+			pdata->type = POWER_SUPPLY_TYPE_USB_CDP;
+		else if (!strncmp("usb-aca", chargetype, 7))
+			pdata->type = POWER_SUPPLY_TYPE_USB_ACA;
+		else
+			dev_warn(dev, "unknown charger type %s\n", chargetype);
+	}
+
+	return pdata;
+}
+
 static int gpio_charger_probe(struct platform_device *pdev)
 {
-	const struct gpio_charger_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_charger_platform_data *pdata = pdev->dev.platform_data;
 	struct gpio_charger *gpio_charger;
 	struct power_supply *charger;
 	int ret;
 	int irq;
 
 	if (!pdata) {
-		dev_err(&pdev->dev, "No platform data\n");
-		return -EINVAL;
+		pdata = gpio_charger_parse_dt(&pdev->dev);
+		if (IS_ERR(pdata)) {
+			dev_err(&pdev->dev, "No platform data\n");
+			return -EINVAL;
+		}
 	}
 
 	if (!gpio_is_valid(pdata->gpio)) {
@@ -189,6 +242,12 @@ static int gpio_charger_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(gpio_charger_pm_ops,
 		gpio_charger_suspend, gpio_charger_resume);
 
+static const struct of_device_id gpio_charger_match[] = {
+	{ .compatible = "gpio-charger" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, gpio_charger_match);
+
 static struct platform_driver gpio_charger_driver = {
 	.probe = gpio_charger_probe,
 	.remove = gpio_charger_remove,
@@ -196,6 +255,7 @@ static struct platform_driver gpio_charger_driver = {
 		.name = "gpio-charger",
 		.owner = THIS_MODULE,
 		.pm = &gpio_charger_pm_ops,
+		.of_match_table = of_match_ptr(gpio_charger_match),
 	},
 };
 
-- 
1.8.5.3


