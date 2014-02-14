Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaBNXHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 18:07:08 -0500
Received: from ring0.de ([5.45.105.125]:33067 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbaBNXHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 18:07:04 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Luciano Coelho <luca@coelho.fi>,
        Tony Lindgren <tony@atomide.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCHv2 4/5] wl1251: spi: add device tree support
Date: Sat, 15 Feb 2014 00:05:55 +0100
Message-Id: <1392419156-14394-5-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392419156-14394-1-git-send-email-sre@debian.org>
References: <20140125000929.GD25488@atomide.com>
 <1392419156-14394-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support for the spi variant of wl1251.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/net/wireless/ti/wl1251/spi.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/spi.c b/drivers/net/wireless/ti/wl1251/spi.c
index 0a8aacc..b06d36d 100644
--- a/drivers/net/wireless/ti/wl1251/spi.c
+++ b/drivers/net/wireless/ti/wl1251/spi.c
@@ -27,6 +27,8 @@
 #include <linux/spi/spi.h>
 #include <linux/wl12xx.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/regulator/consumer.h>
 
 #include "wl1251.h"
@@ -240,13 +242,13 @@ static const struct wl1251_if_operations wl1251_spi_ops = {
 
 static int wl1251_spi_probe(struct spi_device *spi)
 {
-	struct wl1251_platform_data *pdata;
+	struct wl1251_platform_data *pdata = dev_get_platdata(&spi->dev);
+	struct device_node *np = spi->dev.of_node;
 	struct ieee80211_hw *hw;
 	struct wl1251 *wl;
 	int ret;
 
-	pdata = dev_get_platdata(&spi->dev);
-	if (!pdata) {
+	if (!np && !pdata) {
 		wl1251_error("no platform data");
 		return -ENODEV;
 	}
@@ -273,7 +275,18 @@ static int wl1251_spi_probe(struct spi_device *spi)
 		goto out_free;
 	}
 
-	wl->power_gpio = pdata->power_gpio;
+	if (np) {
+		wl->use_eeprom = of_property_read_bool(np, "ti,wl1251-has-eeprom");
+		wl->power_gpio = of_get_named_gpio(np, "ti,power-gpio", 0);
+	} else if (pdata) {
+		wl->power_gpio = pdata->power_gpio;
+		wl->use_eeprom = pdata->use_eeprom;
+	}
+
+	if (wl->power_gpio == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto out_free;
+	}
 
 	if (gpio_is_valid(wl->power_gpio)) {
 		ret = devm_gpio_request_one(&spi->dev, wl->power_gpio,
@@ -295,8 +308,6 @@ static int wl1251_spi_probe(struct spi_device *spi)
 		goto out_free;
 	}
 
-	wl->use_eeprom = pdata->use_eeprom;
-
 	irq_set_status_flags(wl->irq, IRQ_NOAUTOEN);
 	ret = devm_request_irq(&spi->dev, wl->irq, wl1251_irq, 0,
 							DRIVER_NAME, wl);
-- 
1.8.5.3

