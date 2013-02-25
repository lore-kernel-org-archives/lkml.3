Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab3BYG7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 01:59:44 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:60854 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab3BYG7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 01:59:41 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ville Syrjala <syrjala@sci.fi>, Daniel Mack <zonque@gmail.com>,
        Matt Ranostay <mranostay@gmail.com>, panto@antoniou-consulting.com,
        koen@dominion.thruhere.net
Subject: [PATCH 2/5] W1: w1-gpio - switch to using dev_pm_ops
Date: Sun, 24 Feb 2013 22:59:34 -0800
Message-Id: <1361775577-4578-2-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1361775577-4578-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1361606320-4479-1-git-send-email-dmitry.torokhov@gmail.com>
 <1361775577-4578-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/w1/masters/w1-gpio.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index 799dafd..c45b9ae 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -176,11 +176,10 @@ static int w1_gpio_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-
-static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int w1_gpio_suspend(struct device *dev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	const struct w1_gpio_platform_data *pdata = dev_get_platdata(dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -188,31 +187,28 @@ static int w1_gpio_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int w1_gpio_resume(struct platform_device *pdev)
+static int w1_gpio_resume(struct device *dev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	const struct w1_gpio_platform_data *pdata = dev_get_platdata(dev);
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(1);
 
 	return 0;
 }
-
-#else
-#define w1_gpio_suspend	NULL
-#define w1_gpio_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(w1_gpio_pm_ops, w1_gpio_suspend, w1_gpio_resume);
+
 static struct platform_driver w1_gpio_driver = {
 	.driver = {
 		.name	= "w1-gpio",
 		.owner	= THIS_MODULE,
+		.pm	= &w1_gpio_pm_ops,
 		.of_match_table = of_match_ptr(w1_gpio_dt_ids),
 	},
 	.probe = w1_gpio_probe,
 	.remove = w1_gpio_remove,
-	.suspend = w1_gpio_suspend,
-	.resume = w1_gpio_resume,
 };
 
 module_platform_driver(w1_gpio_driver);
-- 
1.7.11.7

