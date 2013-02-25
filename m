Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab3BYHAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 02:00:08 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:37084 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab3BYG7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 01:59:43 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ville Syrjala <syrjala@sci.fi>, Daniel Mack <zonque@gmail.com>,
        Matt Ranostay <mranostay@gmail.com>, panto@antoniou-consulting.com,
        koen@dominion.thruhere.net
Subject: [PATCH 4/5] W1: w1-gpio - rework handling of platform data
Date: Sun, 24 Feb 2013 22:59:36 -0800
Message-Id: <1361775577-4578-4-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1361775577-4578-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1361606320-4479-1-git-send-email-dmitry.torokhov@gmail.com>
 <1361775577-4578-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform data in the dveice structure does not belong to the driver
and so it should not be trying to alter it, but instead use a local pointer
and populate it with a local copy in case we are dealing with device tree
setup.

Also allow mixed setups where platform data coexists with device tree and
prefer kernel-supplied data (it may be easier to fiddle in kernel structure
before committing final result to device tree).

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/w1/masters/w1-gpio.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index aa97a96..465ce52 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -55,30 +55,34 @@ static struct of_device_id w1_gpio_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, w1_gpio_dt_ids);
 
-static int w1_gpio_probe_dt(struct platform_device *pdev)
+static struct w1_gpio_platform_data *
+w1_gpio_probe_dt(struct platform_device *pdev)
 {
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	struct w1_gpio_platform_data *pdata;
 	struct device_node *np = pdev->dev.of_node;
 
+	if (!np)
+		return ERR_PTR(-ENOENT);
+
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	if (of_get_property(np, "linux,open-drain", NULL))
 		pdata->is_open_drain = 1;
 
 	pdata->pin = of_get_gpio(np, 0);
 	pdata->ext_pullup_enable_pin = of_get_gpio(np, 1);
-	pdev->dev.platform_data = pdata;
 
-	return 0;
+	return pdata;
 }
 
 #else
 
-static inline int w1_gpio_probe_dt(struct platform_device *pdev)
+static inline struct w1_gpio_platform_data *
+w1_gpio_probe_dt(struct platform_device *pdev)
 {
-	return -ENOSYS;
+	return NULL;
 }
 
 #endif
@@ -94,19 +98,17 @@ static int w1_gpio_probe(struct platform_device *pdev)
 	if (IS_ERR(pinctrl))
 		dev_warn(&pdev->dev, "unable to select pin group\n");
 
-	if (of_have_populated_dt()) {
-		err = w1_gpio_probe_dt(pdev);
-		if (err < 0) {
-			dev_err(&pdev->dev, "Failed to parse DT\n");
-			return err;
-		}
-	}
-
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
+	if (!pdata)
+		pdata = w1_gpio_probe_dt(pdev);
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No configuration data\n");
 		return -ENXIO;
+	} else if (IS_ERR(pdata)) {
+		err = PTR_ERR(pdata);
+		dev_err(&pdev->dev, "Failed to parse DT\n");
+		return err;
 	}
 
 	master = kzalloc(sizeof(struct w1_bus_master), GFP_KERNEL);
@@ -172,7 +174,7 @@ static int w1_gpio_probe(struct platform_device *pdev)
 static int w1_gpio_remove(struct platform_device *pdev)
 {
 	struct w1_bus_master *master = platform_get_drvdata(pdev);
-	struct w1_gpio_platform_data *pdata = pdev->dev.platform_data;
+	const struct w1_gpio_platform_data *pdata = master->data;
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -190,7 +192,9 @@ static int w1_gpio_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int w1_gpio_suspend(struct device *dev)
 {
-	const struct w1_gpio_platform_data *pdata = dev_get_platdata(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct w1_bus_master *master = platform_get_drvdata(pdev);
+	const struct w1_gpio_platform_data *pdata = master->data;
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(0);
@@ -200,7 +204,9 @@ static int w1_gpio_suspend(struct device *dev)
 
 static int w1_gpio_resume(struct device *dev)
 {
-	const struct w1_gpio_platform_data *pdata = dev_get_platdata(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct w1_bus_master *master = platform_get_drvdata(pdev);
+	const struct w1_gpio_platform_data *pdata = master->data;
 
 	if (pdata->enable_external_pullup)
 		pdata->enable_external_pullup(1);
-- 
1.7.11.7

