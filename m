Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab3EWPcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:32:17 -0400
Received: from mail-wi0-f193.google.com ([209.85.212.193]:46080 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab3EWPcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:32:16 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH] pinctrl: abx500: suppress unused mutex
Date: Thu, 23 May 2013 17:31:42 +0200
Message-Id: <1369323102-3030-1-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

Suppress a mutex which was initialized on probe
and destroyed on remove but never used.

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index aa17f75..bbada4b 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -99,7 +99,6 @@ struct abx500_pinctrl {
 	struct abx500_pinctrl_soc_data *soc;
 	struct gpio_chip chip;
 	struct ab8500 *parent;
-	struct mutex lock;
 	struct abx500_gpio_irq_cluster *irq_cluster;
 	int irq_cluster_size;
 };
@@ -882,8 +881,6 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	pct->chip.dev = &pdev->dev;
 	pct->chip.base = (np) ? -1 : pdata->gpio_base;
 
-	/* initialize the lock */
-	mutex_init(&pct->lock);
 
 	/* Poke in other ASIC variants here */
 	switch (id) {
@@ -902,13 +899,11 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	default:
 		dev_err(&pdev->dev, "Unsupported pinctrl sub driver (%d)\n",
 				(int) platid->driver_data);
-		mutex_destroy(&pct->lock);
 		return -EINVAL;
 	}
 
 	if (!pct->soc) {
 		dev_err(&pdev->dev, "Invalid SOC data\n");
-		mutex_destroy(&pct->lock);
 		return -EINVAL;
 	}
 
@@ -919,7 +914,6 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	ret = gpiochip_add(&pct->chip);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to add gpiochip: %d\n", ret);
-		mutex_destroy(&pct->lock);
 		return ret;
 	}
 	dev_info(&pdev->dev, "added gpiochip\n");
@@ -956,7 +950,6 @@ out_rem_chip:
 	if (err)
 		dev_info(&pdev->dev, "failed to remove gpiochip\n");
 
-	mutex_destroy(&pct->lock);
 	return ret;
 }
 
@@ -976,8 +969,6 @@ static int abx500_gpio_remove(struct platform_device *pdev)
 		return ret;
 	}
 
-	mutex_destroy(&pct->lock);
-
 	return 0;
 }
 
-- 
1.7.10

