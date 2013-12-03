Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3LCOu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:50:29 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:46430 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3LCOu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:50:26 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/3] pinctrl: abx500: delete non-devicetree probe path
Date: Tue,  3 Dec 2013 15:50:17 +0100
Message-Id: <1386082217-18883-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All instances of this device are now coming from device tree-
enabled platforms probing without using platform data.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-abx500.c | 36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 4780959e11d4..66a06d5194cd 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -1218,21 +1218,15 @@ static const struct of_device_id abx500_gpio_match[] = {
 
 static int abx500_gpio_probe(struct platform_device *pdev)
 {
-	struct ab8500_platform_data *abx500_pdata =
-				dev_get_platdata(pdev->dev.parent);
-	struct abx500_gpio_platform_data *pdata = NULL;
 	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match;
 	struct abx500_pinctrl *pct;
-	const struct platform_device_id *platid = platform_get_device_id(pdev);
 	unsigned int id = -1;
 	int ret, err;
 	int i;
 
-	if (abx500_pdata)
-		pdata = abx500_pdata->gpio;
-
-	if (!(pdata || np)) {
-		dev_err(&pdev->dev, "gpio dt and platform data missing\n");
+	if (!np) {
+		dev_err(&pdev->dev, "gpio dt node missing\n");
 		return -ENODEV;
 	}
 
@@ -1248,17 +1242,14 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	pct->parent = dev_get_drvdata(pdev->dev.parent);
 	pct->chip = abx500gpio_chip;
 	pct->chip.dev = &pdev->dev;
-	pct->chip.base = (np) ? -1 : pdata->gpio_base;
-
-	if (platid)
-		id = platid->driver_data;
-	else if (np) {
-		const struct of_device_id *match;
+	pct->chip.base = -1; /* Dynamic allocation */
 
-		match = of_match_device(abx500_gpio_match, &pdev->dev);
-		if (match)
-			id = (unsigned long)match->data;
+	match = of_match_device(abx500_gpio_match, &pdev->dev);
+	if (!match) {
+		dev_err(&pdev->dev, "gpio dt not matching\n");
+		return -ENODEV;
 	}
+	id = (unsigned long)match->data;
 
 	/* Poke in other ASIC variants here */
 	switch (id) {
@@ -1349,14 +1340,6 @@ static int abx500_gpio_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct platform_device_id abx500_pinctrl_id[] = {
-	{ "pinctrl-ab8500", PINCTRL_AB8500 },
-	{ "pinctrl-ab8540", PINCTRL_AB8540 },
-	{ "pinctrl-ab9540", PINCTRL_AB9540 },
-	{ "pinctrl-ab8505", PINCTRL_AB8505 },
-	{ },
-};
-
 static struct platform_driver abx500_gpio_driver = {
 	.driver = {
 		.name = "abx500-gpio",
@@ -1365,7 +1348,6 @@ static struct platform_driver abx500_gpio_driver = {
 	},
 	.probe = abx500_gpio_probe,
 	.remove = abx500_gpio_remove,
-	.id_table = abx500_pinctrl_id,
 };
 
 static int __init abx500_gpio_init(void)
-- 
1.8.3.1

