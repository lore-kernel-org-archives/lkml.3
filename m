Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab3KVMOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:14:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:59658 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab3KVMOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:14:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,751,1378882800"; 
   d="scan'208";a="439827874"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] net: rfkill: gpio: convert to descriptor-based GPIO interface
Date: Fri, 22 Nov 2013 14:14:28 +0200
Message-Id: <1385122474-14926-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Convert to the safer gpiod_* family of API functions.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 net/rfkill/rfkill-gpio.c | 112 +++++++++++++++++++++++++++++------------------
 1 file changed, 70 insertions(+), 42 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 5620d3c07479..503432154616 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -25,15 +25,15 @@
 #include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
-#include <linux/acpi_gpio.h>
+#include <linux/gpio/consumer.h>
 
 #include <linux/rfkill-gpio.h>
 
 struct rfkill_gpio_data {
 	const char		*name;
 	enum rfkill_type	type;
-	int			reset_gpio;
-	int			shutdown_gpio;
+	struct gpio_desc	*reset_gpio;
+	struct gpio_desc	*shutdown_gpio;
 
 	struct rfkill		*rfkill_dev;
 	char			*reset_name;
@@ -48,19 +48,15 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
 	struct rfkill_gpio_data *rfkill = data;
 
 	if (blocked) {
-		if (gpio_is_valid(rfkill->shutdown_gpio))
-			gpio_set_value(rfkill->shutdown_gpio, 0);
-		if (gpio_is_valid(rfkill->reset_gpio))
-			gpio_set_value(rfkill->reset_gpio, 0);
+		gpiod_set_value(rfkill->shutdown_gpio, 0);
+		gpiod_set_value(rfkill->reset_gpio, 0);
 		if (!IS_ERR(rfkill->clk) && rfkill->clk_enabled)
 			clk_disable(rfkill->clk);
 	} else {
 		if (!IS_ERR(rfkill->clk) && !rfkill->clk_enabled)
 			clk_enable(rfkill->clk);
-		if (gpio_is_valid(rfkill->reset_gpio))
-			gpio_set_value(rfkill->reset_gpio, 1);
-		if (gpio_is_valid(rfkill->shutdown_gpio))
-			gpio_set_value(rfkill->shutdown_gpio, 1);
+		gpiod_set_value(rfkill->reset_gpio, 1);
+		gpiod_set_value(rfkill->shutdown_gpio, 1);
 	}
 
 	rfkill->clk_enabled = blocked;
@@ -72,6 +68,35 @@ static const struct rfkill_ops rfkill_gpio_ops = {
 	.set_block = rfkill_gpio_set_power,
 };
 
+static int rfkill_gpio_convert_to_desc(struct platform_device *pdev,
+				       struct rfkill_gpio_data *rfkill)
+{
+	struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
+	int ret;
+
+	if (gpio_is_valid(pdata->reset_gpio)) {
+		ret = devm_gpio_request_one(&pdev->dev, pdata->reset_gpio,
+					    0, rfkill->reset_name);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to get reset gpio.\n");
+			return ret;
+		}
+		rfkill->reset_gpio = gpio_to_desc(pdata->reset_gpio);
+	}
+
+	if (gpio_is_valid(pdata->shutdown_gpio)) {
+		ret = devm_gpio_request_one(&pdev->dev, pdata->shutdown_gpio,
+					    0, rfkill->shutdown_name);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to get shutdown gpio.\n");
+			return ret;
+		}
+		rfkill->shutdown_gpio = gpio_to_desc(pdata->shutdown_gpio);
+	}
+
+	return 0;
+}
+
 static int rfkill_gpio_acpi_probe(struct device *dev,
 				  struct rfkill_gpio_data *rfkill)
 {
@@ -83,8 +108,6 @@ static int rfkill_gpio_acpi_probe(struct device *dev,
 
 	rfkill->name = dev_name(dev);
 	rfkill->type = (unsigned)id->driver_data;
-	rfkill->reset_gpio = acpi_get_gpio_by_index(dev, 0, NULL);
-	rfkill->shutdown_gpio = acpi_get_gpio_by_index(dev, 1, NULL);
 
 	return 0;
 }
@@ -94,8 +117,8 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 	struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
 	struct rfkill_gpio_data *rfkill;
 	const char *clk_name = NULL;
-	int ret = 0;
-	int len = 0;
+	int ret;
+	int len;
 
 	rfkill = devm_kzalloc(&pdev->dev, sizeof(*rfkill), GFP_KERNEL);
 	if (!rfkill)
@@ -109,28 +132,10 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 		clk_name = pdata->power_clk_name;
 		rfkill->name = pdata->name;
 		rfkill->type = pdata->type;
-		rfkill->reset_gpio = pdata->reset_gpio;
-		rfkill->shutdown_gpio = pdata->shutdown_gpio;
 	} else {
 		return -ENODEV;
 	}
 
-	/* make sure at-least one of the GPIO is defined and that
-	 * a name is specified for this instance */
-	if ((!gpio_is_valid(rfkill->reset_gpio) &&
-	     !gpio_is_valid(rfkill->shutdown_gpio)) || !rfkill->name) {
-		pr_warn("%s: invalid platform data\n", __func__);
-		return -EINVAL;
-	}
-
-	if (pdata && pdata->gpio_runtime_setup) {
-		ret = pdata->gpio_runtime_setup(pdev);
-		if (ret) {
-			pr_warn("%s: can't set up gpio\n", __func__);
-			return ret;
-		}
-	}
-
 	len = strlen(rfkill->name);
 	rfkill->reset_name = devm_kzalloc(&pdev->dev, len + 7, GFP_KERNEL);
 	if (!rfkill->reset_name)
@@ -145,20 +150,43 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 
 	rfkill->clk = devm_clk_get(&pdev->dev, clk_name);
 
-	if (gpio_is_valid(rfkill->reset_gpio)) {
-		ret = devm_gpio_request_one(&pdev->dev, rfkill->reset_gpio,
-					    0, rfkill->reset_name);
-		if (ret) {
-			pr_warn("%s: failed to get reset gpio.\n", __func__);
+	if (pdata && (pdata->reset_gpio || pdata->shutdown_gpio)) {
+		ret = rfkill_gpio_convert_to_desc(pdev, rfkill);
+		if (ret)
 			return ret;
+	} else {
+		struct gpio_desc *gpio;
+
+		gpio = devm_gpiod_get_index(&pdev->dev, rfkill->reset_name, 0);
+		if (!IS_ERR(gpio)) {
+			ret = gpiod_direction_output(gpio, 0);
+			if (ret)
+				return ret;
+			rfkill->reset_gpio = gpio;
+		}
+
+		gpio = devm_gpiod_get_index(&pdev->dev,
+					    rfkill->shutdown_name, 1);
+		if (!IS_ERR(gpio)) {
+			ret = gpiod_direction_output(gpio, 0);
+			if (ret)
+				return ret;
+			rfkill->shutdown_gpio = gpio;
 		}
 	}
 
-	if (gpio_is_valid(rfkill->shutdown_gpio)) {
-		ret = devm_gpio_request_one(&pdev->dev, rfkill->shutdown_gpio,
-					    0, rfkill->shutdown_name);
+	/* Make sure at-least one of the GPIO is defined and that
+	 * a name is specified for this instance
+	 */
+	if ((!rfkill->reset_gpio && !rfkill->shutdown_gpio) || !rfkill->name) {
+		dev_err(&pdev->dev, "invalid platform data\n");
+		return -EINVAL;
+	}
+
+	if (pdata && pdata->gpio_runtime_setup) {
+		ret = pdata->gpio_runtime_setup(pdev);
 		if (ret) {
-			pr_warn("%s: failed to get shutdown gpio.\n", __func__);
+			dev_err(&pdev->dev, "can't set up gpio\n");
 			return ret;
 		}
 	}
-- 
1.8.4.3

