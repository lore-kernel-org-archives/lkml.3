Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3H3EaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:30:03 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33466 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab3H3E37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:29:59 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 4/6] extcon-gpio: Add devicetree support
Date: Thu, 29 Aug 2013 21:29:36 -0700
Message-Id: <1377836978-24082-5-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/extcon/extcon-gpio.c |   59 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index d4e3c89..16951fe 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -30,6 +30,8 @@
 #include <linux/gpio.h>
 #include <linux/extcon.h>
 #include <linux/extcon/extcon-gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/err.h>
 
 struct gpio_extcon_data {
 	struct extcon_dev edev;
@@ -77,14 +79,66 @@ static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
 	return -EINVAL;
 }
 
+#ifdef CONFIG_OF_GPIO
+
+static struct gpio_extcon_platform_data *
+extcon_gpio_config_of(struct device *dev)
+{
+	struct gpio_extcon_platform_data *pdata;
+	struct device_node *np = dev->of_node;
+	enum of_gpio_flags flags;
+	int gpio, ret;
+	u32 debounce;
+
+	gpio = of_get_named_gpio_flags(np, "presence-detect-gpios", 0, &flags);
+	if (gpio < 0)
+		return ERR_PTR(gpio);
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	pdata->gpio = gpio;
+	pdata->gpio_active_low = flags & OF_GPIO_ACTIVE_LOW;
+	pdata->irq_flags = IRQ_TYPE_EDGE_BOTH;
+
+	if (!of_property_read_u32(np, "debounce-interval", &debounce))
+		pdata->debounce = debounce;
+
+	ret = of_property_read_string(np, "name", &pdata->name);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	of_property_read_string(np, "state-on", &pdata->state_on);
+	of_property_read_string(np, "state-off", &pdata->state_off);
+
+	return pdata;
+}
+
+static const struct of_device_id of_gpio_extcon_match[] = {
+	{ .compatible = "gpio-connector", },
+	{},
+};
+#else /* CONFIG_OF_GPIO */
+static struct gpio_extcon_platform_data *
+extcon_gpio_config_of(struct device *pdev)
+{
+	return ERR_PTR(-ENODEV);
+}
+#endif /* CONFIG_OF_GPIO */
+
 static int gpio_extcon_probe(struct platform_device *pdev)
 {
 	struct gpio_extcon_platform_data *pdata = pdev->dev.platform_data;
 	struct gpio_extcon_data *extcon_data;
 	int ret;
 
-	if (!pdata)
-		return -EBUSY;
+	if (!pdata) {
+		pdata = extcon_gpio_config_of(&pdev->dev);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+	}
+
 	if (!pdata->irq_flags) {
 		dev_err(&pdev->dev, "IRQ flag is not specified.\n");
 		return -EINVAL;
@@ -161,6 +215,7 @@ static struct platform_driver gpio_extcon_driver = {
 	.driver		= {
 		.name	= "extcon-gpio",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(of_gpio_extcon_match),
 	},
 };
 
-- 
1.7.9.7

