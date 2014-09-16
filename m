Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbaIPWIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:08:02 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36362 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaIPWH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:07:58 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: remove remaining users of gpiochip_remove() retval
Date: Tue, 16 Sep 2014 15:07:54 -0700
Message-Id: <1410905274-22339-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers accidentally still use the return value from
gpiochip_remove(). Get rid of them so we can simplify this function
and get rid of the return value.

Abdoulaye Berthe <berthe.ab@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
This patch will be merged through the GPIO tree.
---
 drivers/pinctrl/nomadik/pinctrl-abx500.c     | 14 ++------------
 drivers/pinctrl/nomadik/pinctrl-nomadik.c    |  2 +-
 drivers/pinctrl/qcom/pinctrl-msm.c           |  9 +--------
 drivers/pinctrl/samsung/pinctrl-exynos5440.c |  6 +-----
 drivers/pinctrl/samsung/pinctrl-samsung.c    | 13 +++----------
 5 files changed, 8 insertions(+), 36 deletions(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index a53a689a2bfa..7df34b70e8b6 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -1298,10 +1298,7 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 out_rem_chip:
-	err = gpiochip_remove(&pct->chip);
-	if (err)
-		dev_info(&pdev->dev, "failed to remove gpiochip\n");
-
+	gpiochip_remove(&pct->chip);
 	return ret;
 }
 
@@ -1312,15 +1309,8 @@ out_rem_chip:
 static int abx500_gpio_remove(struct platform_device *pdev)
 {
 	struct abx500_pinctrl *pct = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = gpiochip_remove(&pct->chip);
-	if (ret < 0) {
-		dev_err(pct->dev, "unable to remove gpiochip: %d\n",
-			ret);
-		return ret;
-	}
 
+	gpiochip_remove(&pct->chip);
 	return 0;
 }
 
diff --git a/drivers/pinctrl/nomadik/pinctrl-nomadik.c b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
index e7cab07eef47..4332b38c52ab 100644
--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -1261,7 +1261,7 @@ static int nmk_gpio_probe(struct platform_device *dev)
 				   IRQ_TYPE_EDGE_FALLING);
 	if (ret) {
 		dev_err(&dev->dev, "could not add irqchip\n");
-		ret = gpiochip_remove(&nmk_chip->chip);
+		gpiochip_remove(&nmk_chip->chip);
 		return -ENODEV;
 	}
 	/* Then register the chain on the parent IRQ */
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 2738108caff2..041677113a48 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -903,16 +903,9 @@ EXPORT_SYMBOL(msm_pinctrl_probe);
 int msm_pinctrl_remove(struct platform_device *pdev)
 {
 	struct msm_pinctrl *pctrl = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = gpiochip_remove(&pctrl->chip);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to remove gpiochip\n");
-		return ret;
-	}
 
+	gpiochip_remove(&pctrl->chip);
 	pinctrl_unregister(pctrl->pctrl);
-
 	return 0;
 }
 EXPORT_SYMBOL(msm_pinctrl_remove);
diff --git a/drivers/pinctrl/samsung/pinctrl-exynos5440.c b/drivers/pinctrl/samsung/pinctrl-exynos5440.c
index 603da2f9dd95..8ef370244aee 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos5440.c
@@ -873,11 +873,7 @@ static int exynos5440_gpiolib_register(struct platform_device *pdev,
 static int exynos5440_gpiolib_unregister(struct platform_device *pdev,
 				struct exynos5440_pinctrl_priv_data *priv)
 {
-	int ret = gpiochip_remove(priv->gc);
-	if (ret) {
-		dev_err(&pdev->dev, "gpio chip remove failed\n");
-		return ret;
-	}
+	gpiochip_remove(priv->gc);
 	return 0;
 }
 
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index b07406da333c..0d137c56a6a5 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -945,9 +945,7 @@ static int samsung_gpiolib_register(struct platform_device *pdev,
 
 fail:
 	for (--i, --bank; i >= 0; --i, --bank)
-		if (gpiochip_remove(&bank->gpio_chip))
-			dev_err(&pdev->dev, "gpio chip %s remove failed\n",
-							bank->gpio_chip.label);
+		gpiochip_remove(&bank->gpio_chip);
 	return ret;
 }
 
@@ -957,16 +955,11 @@ static int samsung_gpiolib_unregister(struct platform_device *pdev,
 {
 	struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
 	struct samsung_pin_bank *bank = ctrl->pin_banks;
-	int ret = 0;
 	int i;
 
 	for (i = 0; !ret && i < ctrl->nr_banks; ++i, ++bank)
-		ret = gpiochip_remove(&bank->gpio_chip);
-
-	if (ret)
-		dev_err(&pdev->dev, "gpio chip remove failed\n");
-
-	return ret;
+		gpiochip_remove(&bank->gpio_chip);
+	return 0;
 }
 
 static const struct of_device_id samsung_pinctrl_dt_match[];
-- 
1.9.3

