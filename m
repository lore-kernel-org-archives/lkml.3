Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab3LABAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 20:00:23 -0500
Received: from ring0.de ([91.143.88.219]:38267 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab3LABAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 20:00:17 -0500
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
Subject: [PATCHv2 1/2] isp1704_charger: Add DT support
Date: Sun,  1 Dec 2013 02:00:10 +0100
Message-Id: <1385859611-26532-2-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385859611-26532-1-git-send-email-sre@debian.org>
References: <20131114175227.GH10317@atomide.com>
 <1385859611-26532-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces device tree support to the isp1704
charger driver. Adding support involved moving the handling
of the enable GPIO from board code into the driver.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/power/isp1704_charger.c       | 55 ++++++++++++++++++++++++++++++++---
 include/linux/power/isp1704_charger.h |  1 +
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index 1bb3a91..2535989 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -29,6 +29,8 @@
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 
 #include <linux/usb/otg.h>
 #include <linux/usb/ulpi.h>
@@ -88,6 +90,8 @@ static void isp1704_charger_set_power(struct isp1704_charger *isp, bool on)
 
 	if (board && board->set_power)
 		board->set_power(on);
+	else if (board)
+		gpio_set_value(board->enable_gpio, on);
 }
 
 /*
@@ -400,12 +404,47 @@ static int isp1704_charger_probe(struct platform_device *pdev)
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
+
+		dev_info(&pdev->dev, "init gpio %d\n", pdata->enable_gpio);
+
+		ret = devm_gpio_request_one(&pdev->dev, pdata->enable_gpio,
+					GPIOF_OUT_INIT_HIGH, "isp1704_reset");
+		if (ret)
+			goto fail0;
+	}
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "missing platform data!\n");
+		return -ENODEV;
+	}
+
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
@@ -464,7 +503,6 @@ fail2:
 	power_supply_unregister(&isp->psy);
 fail1:
 	isp1704_charger_set_power(isp, 0);
-	usb_put_phy(isp->phy);
 fail0:
 	dev_err(&pdev->dev, "failed to register isp1704 with error %d\n", ret);
 
@@ -477,15 +515,24 @@ static int isp1704_charger_remove(struct platform_device *pdev)
 
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
index 68096a6..0105d9e 100644
--- a/include/linux/power/isp1704_charger.h
+++ b/include/linux/power/isp1704_charger.h
@@ -24,6 +24,7 @@
 
 struct isp1704_charger_data {
 	void		(*set_power)(bool on);
+	int		enable_gpio;
 };
 
 #endif
-- 
1.8.4.3

