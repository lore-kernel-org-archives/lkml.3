Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab3KNMj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:39:27 -0500
Received: from ring0.de ([91.143.88.219]:55333 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab3KNMjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:39:23 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@debian.org>, Tony Lindgren <tony@atomide.com>,
        Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 1/2] isp1704_charger: Add DT support
Date: Thu, 14 Nov 2013 12:38:53 +0000
Message-Id: <1384432734-1490-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces device tree support to the isp1704
charger driver. Adding support involved moving the handling
of the enable GPIO from board code into the driver.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c | 10 +----
 drivers/power/isp1704_charger.c              | 56 +++++++++++++++++++++++++---
 include/linux/power/isp1704_charger.h        |  2 +-
 3 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index a791fef..2986d16 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -273,13 +273,8 @@ static struct platform_device rx51_battery_device = {
 	.id	= -1,
 };
 
-static void rx51_charger_set_power(bool on)
-{
-	gpio_set_value(RX51_USB_TRANSCEIVER_RST_GPIO, on);
-}
-
 static struct isp1704_charger_data rx51_charger_data = {
-	.set_power	= rx51_charger_set_power,
+	.enable_gpio	= RX51_USB_TRANSCEIVER_RST_GPIO,
 };
 
 static struct platform_device rx51_charger_device = {
@@ -291,9 +286,6 @@ static struct platform_device rx51_charger_device = {
 
 static void __init rx51_charger_init(void)
 {
-	WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
-		GPIOF_OUT_INIT_HIGH, "isp1704_reset"));
-
 	platform_device_register(&rx51_battery_device);
 	platform_device_register(&rx51_charger_device);
 }
diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index fc04d19..db96778 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -28,6 +28,8 @@
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 
 #include <linux/usb/otg.h>
 #include <linux/usb/ulpi.h>
@@ -89,8 +91,8 @@ static void isp1704_charger_set_power(struct isp1704_charger *isp, bool on)
 {
 	struct isp1704_charger_data	*board = isp->dev->platform_data;
 
-	if (board && board->set_power)
-		board->set_power(on);
+	if (board)
+		gpio_set_value(board->enable_gpio, on);
 }
 
 /*
@@ -411,12 +413,46 @@ static int isp1704_charger_probe(struct platform_device *pdev)
 	struct isp1704_charger	*isp;
 	int			ret = -ENODEV;
 
+	struct isp1704_charger_data *pdata = dev_get_platdata(&pdev->dev);
+	struct device_node *np = pdev->dev.of_node;
+
+	if (np) {
+		int gpio = of_get_named_gpio(np, "nxp,enable-gpio", 0);
+
+		if (gpio < 0)
+			return gpio;
+
+		pdata = devm_kzalloc(&pdev->dev,
+			sizeof(struct isp1704_charger_data), GFP_KERNEL);
+		pdata->enable_gpio = gpio;
+	}
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "missing platform data!\n");
+		return -ENODEV;
+	}
+
+	dev_info(&pdev->dev, "init gpio %d\n", pdata->enable_gpio);
+
+	ret = devm_gpio_request_one(&pdev->dev, pdata->enable_gpio,
+					GPIOF_OUT_INIT_HIGH, "isp1704_reset");
+	if (ret)
+		goto fail0;
+
 	isp = devm_kzalloc(&pdev->dev, sizeof(*isp), GFP_KERNEL);
 	if (!isp)
 		return -ENOMEM;
 
-	isp->phy = usb_get_phy(USB_PHY_TYPE_USB2);
-	if (IS_ERR_OR_NULL(isp->phy))
+	if (np)
+		isp->phy = devm_usb_get_phy_by_phandle(&pdev->dev, "usb-phy", 0);
+	else
+		isp->phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
+
+	if (IS_ERR(isp->phy)) {
+		ret = PTR_ERR(isp->phy);
+		goto fail0;
+	}
+	if (!isp->phy)
 		goto fail0;
 
 	isp->dev = &pdev->dev;
@@ -475,7 +511,6 @@ fail2:
 	power_supply_unregister(&isp->psy);
 fail1:
 	isp1704_charger_set_power(isp, 0);
-	usb_put_phy(isp->phy);
 fail0:
 	dev_err(&pdev->dev, "failed to register isp1704 with error %d\n", ret);
 
@@ -488,15 +523,24 @@ static int isp1704_charger_remove(struct platform_device *pdev)
 
 	usb_unregister_notifier(isp->phy, &isp->nb);
 	power_supply_unregister(&isp->psy);
-	usb_put_phy(isp->phy);
 	isp1704_charger_set_power(isp, 0);
 
 	return 0;
 }
 
+
+#ifdef CONFIG_OF
+static const struct of_device_id omap_isp1704_of_match[] = {
+	{ .compatible = "nxp,isp1704", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_isp1704_of_match);
+#endif
+
 static struct platform_driver isp1704_charger_driver = {
 	.driver = {
 		.name = "isp1704_charger",
+		.of_match_table = of_match_ptr(omap_isp1704_of_match),
 	},
 	.probe = isp1704_charger_probe,
 	.remove = isp1704_charger_remove,
diff --git a/include/linux/power/isp1704_charger.h b/include/linux/power/isp1704_charger.h
index 68096a6..05081a9 100644
--- a/include/linux/power/isp1704_charger.h
+++ b/include/linux/power/isp1704_charger.h
@@ -23,7 +23,7 @@
 #define __ISP1704_CHARGER_H
 
 struct isp1704_charger_data {
-	void		(*set_power)(bool on);
+	int		enable_gpio;
 };
 
 #endif
-- 
1.8.4.2

