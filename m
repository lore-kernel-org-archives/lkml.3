Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3BETvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:51:45 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:45669 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756727Ab3BETtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:49:23 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 10/14] pinctrl/abx500: add Device Tree support
Date: Tue, 5 Feb 2013 20:48:31 +0100
Message-ID: <1360093715-6348-11-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

This patch will allow the ABX500 Pinctrl driver to be probed when
Device Tree is enabled with an appropriate node contained.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-abx500.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index a0d324b..20f94cf 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -14,6 +14,8 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
@@ -825,22 +827,44 @@ static int abx500_get_gpio_num(struct abx500_pinctrl_soc_data *soc)
 	return npins;
 }
 
+static const struct of_device_id abx500_gpio_match[] = {
+	{ .compatible = "stericsson,ab8500-gpio", .data = (void *)PINCTRL_AB8500, },
+	{ .compatible = "stericsson,ab8505-gpio", .data = (void *)PINCTRL_AB8505, },
+	{ .compatible = "stericsson,ab8540-gpio", .data = (void *)PINCTRL_AB8540, },
+	{ .compatible = "stericsson,ab9540-gpio", .data = (void *)PINCTRL_AB9540, },
+};
+
 static int abx500_gpio_probe(struct platform_device *pdev)
 {
 	struct ab8500_platform_data *abx500_pdata =
 				dev_get_platdata(pdev->dev.parent);
-	struct abx500_gpio_platform_data *pdata;
+	struct abx500_gpio_platform_data *pdata = NULL;
+	struct device_node *np = pdev->dev.of_node;
 	struct abx500_pinctrl *pct;
 	const struct platform_device_id *platid = platform_get_device_id(pdev);
+	unsigned int id = -1;
 	int ret, err;
 	int i;
 
-	pdata = abx500_pdata->gpio;
+	if (abx500_pdata)
+		pdata = abx500_pdata->gpio;
 	if (!pdata) {
-		dev_err(&pdev->dev, "gpio platform data missing\n");
-		return -ENODEV;
+		if (np) {
+			const struct of_device_id *match;
+
+			match = of_match_device(abx500_gpio_match, &pdev->dev);
+			if (!match)
+				return -ENODEV;
+			id = (unsigned long)match->data;
+		} else {
+			dev_err(&pdev->dev, "gpio dt and platform data missing\n");
+			return -ENODEV;
+		}
 	}
 
+	if (platid)
+		id = platid->driver_data;
+
 	pct = devm_kzalloc(&pdev->dev, sizeof(struct abx500_pinctrl),
 				   GFP_KERNEL);
 	if (pct == NULL) {
@@ -854,12 +878,13 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	pct->chip = abx500gpio_chip;
 	pct->chip.dev = &pdev->dev;
 	pct->chip.base = pdata->gpio_base;
+	pct->chip.base = (np) ? -1 : pdata->gpio_base;
 
 	/* initialize the lock */
 	mutex_init(&pct->lock);
 
 	/* Poke in other ASIC variants here */
-	switch (platid->driver_data) {
+	switch (id) {
 	case PINCTRL_AB8500:
 		abx500_pinctrl_ab8500_init(&pct->soc);
 		break;
@@ -966,6 +991,7 @@ static struct platform_driver abx500_gpio_driver = {
 	.driver = {
 		.name = "abx500-gpio",
 		.owner = THIS_MODULE,
+		.of_match_table = abx500_gpio_match,
 	},
 	.probe = abx500_gpio_probe,
 	.remove = abx500_gpio_remove,
-- 
1.7.11.3

