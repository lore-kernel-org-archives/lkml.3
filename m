Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaBMWFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:05:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60512 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaBMWFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:05:39 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: kernel@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] w1-gpio: handle of_get_gpio() returning -EPROBE_DEFER better
Date: Thu, 13 Feb 2014 23:05:28 +0100
Message-Id: <1392329128-6221-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_gpio() might return -EPROBE_DEFER meaning that the driver
providing the gpio isn't ready yet. If that happens for the first gpio
the resulting kernel output without this patch is:

	w1-gpio somename: Failed to parse DT
	platform somename: Driver w1-gpio requests probe deferral

The first message is misleading and so is suppressed with this patch.

Further if determining the gpio to switch the external pullup yields
-EPROBE_DEFER this error should be passed back to the caller instead of
just continuing without pullup.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Actually I'm not completely happy with this change because IMHO if a
device tree node contains:

	gpios = <&gpio5 0 0 4>;

where gpio5's #gpio-cells property is <2> I'd prefer to not bind the
driver with an error message instead of treating it as if

	gpios = <&gpio5 0 0>;

was specified. Still this patch is a correct first step.

So something like that would be nice:

	len = get_len_of_gpio_array();
	if (len < 0)
		/* not well-formed */
		return len;

	if (len == 1)
		go on without pullup
	else if (len == 2)
		go on with pullup
	else
		scream
---
 drivers/w1/masters/w1-gpio.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index e36b18b2817b..4b581228a4d9 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -68,11 +68,22 @@ static int w1_gpio_probe_dt(struct platform_device *pdev)
 		pdata->is_open_drain = 1;
 
 	gpio = of_get_gpio(np, 0);
-	if (gpio < 0)
+	if (gpio < 0) {
+		if (gpio != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
+					"Failed to parse gpio property for data pin (%d)\n",
+					gpio);
+
 		return gpio;
+	}
 	pdata->pin = gpio;
 
-	pdata->ext_pullup_enable_pin = of_get_gpio(np, 1);
+	gpio = of_get_gpio(np, 1);
+	if (gpio == -EPROBE_DEFER)
+		return gpio;
+	/* ignore other errors as the pullup gpio is optional */
+	pdata->ext_pullup_enable_pin = gpio;
+
 	pdev->dev.platform_data = pdata;
 
 	return 0;
@@ -86,10 +97,8 @@ static int w1_gpio_probe(struct platform_device *pdev)
 
 	if (of_have_populated_dt()) {
 		err = w1_gpio_probe_dt(pdev);
-		if (err < 0) {
-			dev_err(&pdev->dev, "Failed to parse DT\n");
+		if (err < 0)
 			return err;
-		}
 	}
 
 	pdata = dev_get_platdata(&pdev->dev);
-- 
1.8.5.3

