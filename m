Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3AYIjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:39:44 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:46388 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab3AYIjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:39:41 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Brian Lilly <brian@crystalfontz.com>, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] spi: spi-gpio: Add checks for the dt properties
Date: Fri, 25 Jan 2013 09:39:34 +0100
Message-Id: <1359103175-26304-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359103175-26304-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359103175-26304-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bindings assumed that the gpios properties were always there, which
made the NO_TX and NO_RX mode not usable from device tree. Add extra
checks to make sure that the driver can work if either MOSI or MISO is
not used.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/spi/spi-gpio.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index c7cf0b7..9ddef55 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -365,9 +365,26 @@ static int spi_gpio_probe_dt(struct platform_device *pdev)
 	if (!pdata)
 		return -ENOMEM;
 
-	pdata->sck = of_get_named_gpio(np, "gpio-sck", 0);
-	pdata->miso = of_get_named_gpio(np, "gpio-miso", 0);
-	pdata->mosi = of_get_named_gpio(np, "gpio-mosi", 0);
+	ret = of_get_named_gpio(np, "gpio-sck", 0);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "gpio-sck property not found\n");
+		goto error_free;
+	}
+	pdata->sck = ret;
+
+	ret = of_get_named_gpio(np, "gpio-miso", 0);
+	if (ret < 0) {
+		dev_info(&pdev->dev, "gpio-miso property not found, switching to no-rx mode\n");
+		pdata->miso = SPI_GPIO_NO_MISO;
+	} else
+		pdata->miso = ret;
+
+	ret = of_get_named_gpio(np, "gpio-mosi", 0);
+	if (ret < 0) {
+		dev_info(&pdev->dev, "gpio-mosi property not found, switching to no-tx mode\n");
+		pdata->mosi = SPI_GPIO_NO_MOSI;
+	} else
+		pdata->mosi = ret;
 
 	ret = of_property_read_u32(np, "num-chipselects", &tmp);
 	if (ret < 0) {
-- 
1.7.10.4

