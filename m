Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaH3QUB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 12:20:01 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:58316 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbaH3QUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 12:20:00 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Sherman Yin <syin@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: bcm281xx: Add remove function to pinctrl_unregister
Date: Sat, 30 Aug 2014 21:49:25 +0530
Message-Id: <1409415565-13232-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a remove function in platform_driver to pinctrl_unregister
for clean unloading.
This makes local struct pinctrl_dev a part of struct bcm281xx_pinctrl_data to
be accessed from pdev in remove function.

CC: Sherman Yin <syin@broadcom.com>
CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/pinctrl/pinctrl-bcm281xx.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-bcm281xx.c b/drivers/pinctrl/pinctrl-bcm281xx.c
index c5ca9e6..63db3b6 100644
--- a/drivers/pinctrl/pinctrl-bcm281xx.c
+++ b/drivers/pinctrl/pinctrl-bcm281xx.c
@@ -87,7 +87,7 @@ struct bcm281xx_pin_function {
  */
 struct bcm281xx_pinctrl_data {
 	void __iomem *reg_base;
-
+	struct pinctrl_dev *pctl;
 	/* List of all pins */
 	const struct pinctrl_pin_desc *pins;
 	const unsigned npins;
@@ -1400,7 +1400,6 @@ static int __init bcm281xx_pinctrl_probe(struct platform_device *pdev)
 {
 	struct bcm281xx_pinctrl_data *pdata = &bcm281xx_pinctrl;
 	struct resource *res;
-	struct pinctrl_dev *pctl;
 
 	/* So far We can assume there is only 1 bank of registers */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1427,10 +1426,10 @@ static int __init bcm281xx_pinctrl_probe(struct platform_device *pdev)
 	bcm281xx_pinctrl_desc.pins = bcm281xx_pinctrl.pins;
 	bcm281xx_pinctrl_desc.npins = bcm281xx_pinctrl.npins;
 
-	pctl = pinctrl_register(&bcm281xx_pinctrl_desc,
+	pdata->pctl = pinctrl_register(&bcm281xx_pinctrl_desc,
 				&pdev->dev,
 				pdata);
-	if (!pctl) {
+	if (!pdata->pctl) {
 		dev_err(&pdev->dev, "Failed to register pinctrl\n");
 		return -ENODEV;
 	}
@@ -1440,6 +1439,15 @@ static int __init bcm281xx_pinctrl_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int bcm281xx_pinctrl_remove(struct platform_device *pdev)
+{
+	struct bcm281xx_pinctrl_data *pdata = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(pdata->pctl);
+
+	return 0;
+}
+
 static struct of_device_id bcm281xx_pinctrl_of_match[] = {
 	{ .compatible = "brcm,bcm11351-pinctrl", },
 	{ },
@@ -1451,6 +1459,7 @@ static struct platform_driver bcm281xx_pinctrl_driver = {
 		.owner = THIS_MODULE,
 		.of_match_table = bcm281xx_pinctrl_of_match,
 	},
+	.remove = bcm281xx_pinctrl_remove,
 };
 
 module_platform_driver_probe(bcm281xx_pinctrl_driver, bcm281xx_pinctrl_probe);
-- 
1.7.0.4

