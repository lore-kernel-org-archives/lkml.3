Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3EaKN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:13:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50956 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab3EaKME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:12:04 -0400
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <khilman@linaro.org>, <grant.likely@linaro.org>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <vaibhav.bedia@ti.com>,
        <sudhakar.raj@ti.com>, <gururaja.hebbar@ti.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        <linux-leds@vger.kernel.org>
Subject: [PATCH 02/11] leds: leds-gpio: Enhance pinctrl support
Date: Fri, 31 May 2013 15:43:02 +0530
Message-ID: <1369995191-20855-3-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amend leds-gpio driver to optionally take a pin control handle and set
the state of the pins to:

- "default" on boot, resume
- "sleep" on suspend()

By optionally putting the pins into sleep state in the suspend callback
we can accomplish two things.
- One is to minimize current leakage from pins and thus save power,
- second, we can prevent the IP from driving pins output in an
uncontrolled manner, which may happen if the power domain drops the
domain regulator.

If any of the above pin states are missing in dt, a warning message
about the missing state is displayed.
If certain pin-states are not available, to remove this warning message
pass respective state name with null phandler.

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-leds@vger.kernel.org
---
:100644 100644 b02b679... b094e52... M	drivers/leds/leds-gpio.c
 drivers/leds/leds-gpio.c |   81 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 75 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index b02b679..b094e52 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -153,6 +153,10 @@ static void delete_gpio_led(struct gpio_led_data *led)
 
 struct gpio_leds_priv {
 	int num_leds;
+	/* Two optional pin states - default & sleep */
+	struct pinctrl		*pinctrl;
+	struct pinctrl_state	*pins_default;
+	struct pinctrl_state	*pins_sleep;
 	struct gpio_led_data leds[];
 };
 
@@ -162,6 +166,43 @@ static inline int sizeof_gpio_leds_priv(int num_leds)
 		(sizeof(struct gpio_led_data) * num_leds);
 }
 
+/* Use pinctrl API for gpio configuration */
+static void gpio_led_get_pinctrl(struct gpio_leds_priv *priv,
+				struct platform_device *pdev)
+{
+	priv->pinctrl = devm_pinctrl_get(&pdev->dev);
+	if (!IS_ERR(priv->pinctrl)) {
+		priv->pins_default = pinctrl_lookup_state(priv->pinctrl,
+						PINCTRL_STATE_DEFAULT);
+		/* enable pins to be muxed in and configured */
+		if (IS_ERR(priv->pins_default))
+			dev_dbg(&pdev->dev,
+				"could not get default pinstate\n");
+		else
+			if (pinctrl_select_state(priv->pinctrl,
+						 priv->pins_default))
+				dev_err(&pdev->dev,
+					"could not set default pins\n");
+
+		priv->pins_sleep = pinctrl_lookup_state(priv->pinctrl,
+						PINCTRL_STATE_SLEEP);
+		if (IS_ERR(priv->pins_sleep))
+			dev_dbg(&pdev->dev,
+				"could not get sleep pinstate\n");
+	} else {
+		/*
+		* Since we continue even when pinctrl node is not found,
+		* Invalidate pins as not available. This is to make sure that
+		* IS_ERR(pins_xxx) results in failure when used.
+		*/
+		priv->pins_default = ERR_PTR(-ENODATA);
+		priv->pins_sleep = ERR_PTR(-ENODATA);
+
+		dev_dbg(&pdev->dev,
+			"pins are not configured from the driver\n");
+	}
+}
+
 /* Code to create from OpenFirmware platform devices */
 #ifdef CONFIG_OF_GPIO
 static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
@@ -184,6 +225,8 @@ static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
 	if (!priv)
 		return ERR_PTR(-ENOMEM);
 
+	gpio_led_get_pinctrl(priv, pdev);
+
 	for_each_child_of_node(np, child) {
 		struct gpio_led led = {};
 		enum of_gpio_flags flags;
@@ -236,14 +279,8 @@ static int gpio_led_probe(struct platform_device *pdev)
 {
 	struct gpio_led_platform_data *pdata = pdev->dev.platform_data;
 	struct gpio_leds_priv *priv;
-	struct pinctrl *pinctrl;
 	int i, ret = 0;
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev,
-			"pins are not configured from the driver\n");
-
 	if (pdata && pdata->num_leds) {
 		priv = devm_kzalloc(&pdev->dev,
 				sizeof_gpio_leds_priv(pdata->num_leds),
@@ -251,6 +288,8 @@ static int gpio_led_probe(struct platform_device *pdev)
 		if (!priv)
 			return -ENOMEM;
 
+		gpio_led_get_pinctrl(priv, pdev);
+
 		priv->num_leds = pdata->num_leds;
 		for (i = 0; i < priv->num_leds; i++) {
 			ret = create_gpio_led(&pdata->leds[i],
@@ -287,6 +326,32 @@ static int gpio_led_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int gpio_led_suspend(struct platform_device *pdev,
+					pm_message_t state)
+{
+	struct gpio_leds_priv *priv = platform_get_drvdata(pdev);
+
+	/* Optionally let pins go into sleep states */
+	if (!IS_ERR(priv->pins_sleep))
+		if (pinctrl_select_state(priv->pinctrl, priv->pins_sleep))
+			dev_err(&pdev->dev,
+				"could not set pins to sleep state\n");
+
+	return 0;
+}
+
+static int gpio_led_resume(struct platform_device *pdev)
+{
+	struct gpio_leds_priv *priv = platform_get_drvdata(pdev);
+
+	/* Optionaly enable pins to be muxed in and configured */
+	if (!IS_ERR(priv->pins_default))
+		if (pinctrl_select_state(priv->pinctrl, priv->pins_default))
+			dev_err(&pdev->dev, "could not set default pins\n");
+
+	return 0;
+}
+
 static struct platform_driver gpio_led_driver = {
 	.probe		= gpio_led_probe,
 	.remove		= gpio_led_remove,
@@ -295,6 +360,10 @@ static struct platform_driver gpio_led_driver = {
 		.owner	= THIS_MODULE,
 		.of_match_table = of_match_ptr(of_gpio_leds_match),
 	},
+#ifdef CONFIG_PM
+	.suspend = gpio_led_suspend,
+	.resume = gpio_led_resume,
+#endif
 };
 
 module_platform_driver(gpio_led_driver);
-- 
1.7.9.5

