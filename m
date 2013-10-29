Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3J2IY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:24:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56434 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3J2IWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:22:52 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        Markus Pargmann <mpa@pengutronix.de>
Subject: [RESEND PATCH 1/2] w1-gpio: Detect of_gpio_error for first gpio
Date: Tue, 29 Oct 2013 09:19:23 +0100
Message-Id: <1383034764-22091-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first DT gpio is necessary for this driver, but errors returned for
of_get_gpio are ignored.

This patch adds a return value check for the first of_get_gpio.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/masters/w1-gpio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index f54ece2..ae53e88 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -58,6 +58,7 @@ static int w1_gpio_probe_dt(struct platform_device *pdev)
 {
 	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
 	struct device_node *np = pdev->dev.of_node;
+	int gpio;
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
@@ -66,7 +67,11 @@ static int w1_gpio_probe_dt(struct platform_device *pdev)
 	if (of_get_property(np, "linux,open-drain", NULL))
 		pdata->is_open_drain = 1;
 
-	pdata->pin = of_get_gpio(np, 0);
+	gpio = of_get_gpio(np, 0);
+	if (gpio < 0)
+		return gpio;
+	pdata->pin = gpio;
+
 	pdata->ext_pullup_enable_pin = of_get_gpio(np, 1);
 	pdev->dev.platform_data = pdata;
 
-- 
1.8.4.rc3

