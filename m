Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab3HMMOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:14:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39354 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757763Ab3HMMOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:14:39 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] mc13xxx-ts: use zero as default value if no pdata was defined
Date: Tue, 13 Aug 2013 14:14:30 +0200
Message-Id: <1376396070-24507-1-git-send-email-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc2
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of devicetree, we currently don't have a way to append pdata for
the touchscreen. The current approach is to bail out in that case.
This patch makes it possible to probe the touchscreen without pdata
and use zero as default values for the atox and ato adc conversion.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/input/touchscreen/mc13783_ts.c | 14 +++++++++-----
 drivers/mfd/mc13xxx-core.c             | 11 +++++++----
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
index d6f099c..0e24304 100644
--- a/drivers/input/touchscreen/mc13783_ts.c
+++ b/drivers/input/touchscreen/mc13783_ts.c
@@ -124,10 +124,17 @@ static void mc13783_ts_work(struct work_struct *work)
 		container_of(work, struct mc13783_ts_priv, work.work);
 	unsigned int mode = MC13XXX_ADC_MODE_TS;
 	unsigned int channel = 12;
+	u8 ato = 0;
+	bool atox = 0;
+
+	if (priv->touch) {
+		ato = priv->touch->ato;
+		atox = priv->touch->atox;
+	}
 
 	if (mc13xxx_adc_do_conversion(priv->mc13xxx,
 				mode, channel,
-				priv->touch->ato, priv->touch->atox,
+				ato, atox,
 				priv->sample) == 0)
 		mc13783_ts_report_sample(priv);
 }
@@ -183,11 +190,8 @@ static int __init mc13783_ts_probe(struct platform_device *pdev)
 	priv->mc13xxx = dev_get_drvdata(pdev->dev.parent);
 	priv->idev = idev;
 	priv->touch = dev_get_platdata(&pdev->dev);
-	if (!priv->touch) {
+	if (!priv->touch)
 		dev_err(&pdev->dev, "missing platform data\n");
-		ret = -ENODEV;
-		goto err_free_mem;
-	}
 
 	/*
 	 * We need separate workqueue because mc13783_adc_do_conversion
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 2a9b100..278601f 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -694,10 +694,6 @@ err_revision:
 	if (mc13xxx->flags & MC13XXX_USE_RTC)
 		mc13xxx_add_subdevice(mc13xxx, "%s-rtc");
 
-	if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
-		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-ts",
-				&pdata->touch, sizeof(pdata->touch));
-
 	if (pdata) {
 		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-regulator",
 			&pdata->regulators, sizeof(pdata->regulators));
@@ -705,10 +701,17 @@ err_revision:
 				pdata->leds, sizeof(*pdata->leds));
 		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-pwrbutton",
 				pdata->buttons, sizeof(*pdata->buttons));
+
+		if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
+			mc13xxx_add_subdevice_pdata(mc13xxx, "%s-ts",
+					&pdata->touch, sizeof(pdata->touch));
 	} else {
 		mc13xxx_add_subdevice(mc13xxx, "%s-regulator");
 		mc13xxx_add_subdevice(mc13xxx, "%s-led");
 		mc13xxx_add_subdevice(mc13xxx, "%s-pwrbutton");
+
+		if (mc13xxx->flags & MC13XXX_USE_TOUCHSCREEN)
+			mc13xxx_add_subdevice(mc13xxx, "%s-ts");
 	}
 
 	return 0;
-- 
1.8.4.rc2

