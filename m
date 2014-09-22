Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaIVM0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 08:26:05 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:50230 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753709AbaIVM0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:26:02 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>, Balaji T K <balajitk@ti.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH] mmc: omap_hsmmc:  Switch to using managed version to gpio request
Date: Mon, 22 Sep 2014 17:59:24 +0530
Message-Id: <1411388964-25803-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change switches to managed version of gpio_request to simplify
module unloading and failure cases and does away with code to release
gpio resources.

Cc: Balaji T K <balajitk@ti.com>
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/mmc/host/omap_hsmmc.c |   38 +++++++++++---------------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 9656726..761d408 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -449,7 +449,8 @@ static inline int omap_hsmmc_have_reg(void)
 
 #endif
 
-static int omap_hsmmc_gpio_init(struct omap_mmc_platform_data *pdata)
+static int omap_hsmmc_gpio_init(struct platform_device *pdev,
+				struct omap_mmc_platform_data *pdata)
 {
 	int ret;
 
@@ -461,43 +462,29 @@ static int omap_hsmmc_gpio_init(struct omap_mmc_platform_data *pdata)
 			pdata->slots[0].card_detect = omap_hsmmc_card_detect;
 		pdata->slots[0].card_detect_irq =
 				gpio_to_irq(pdata->slots[0].switch_pin);
-		ret = gpio_request(pdata->slots[0].switch_pin, "mmc_cd");
+		ret = devm_gpio_request(&pdev->dev, pdata->slots[0].switch_pin,
+					"mmc_cd");
 		if (ret)
 			return ret;
 		ret = gpio_direction_input(pdata->slots[0].switch_pin);
 		if (ret)
-			goto err_free_sp;
+			return ret;
 	} else
 		pdata->slots[0].switch_pin = -EINVAL;
 
 	if (gpio_is_valid(pdata->slots[0].gpio_wp)) {
 		pdata->slots[0].get_ro = omap_hsmmc_get_wp;
-		ret = gpio_request(pdata->slots[0].gpio_wp, "mmc_wp");
+		ret = devm_gpio_request(&pdev->dev, pdata->slots[0].gpio_wp,
+					"mmc_wp");
 		if (ret)
-			goto err_free_cd;
+			return ret;
 		ret = gpio_direction_input(pdata->slots[0].gpio_wp);
 		if (ret)
-			goto err_free_wp;
+			return ret;
 	} else
 		pdata->slots[0].gpio_wp = -EINVAL;
 
 	return 0;
-
-err_free_wp:
-	gpio_free(pdata->slots[0].gpio_wp);
-err_free_cd:
-	if (gpio_is_valid(pdata->slots[0].switch_pin))
-err_free_sp:
-		gpio_free(pdata->slots[0].switch_pin);
-	return ret;
-}
-
-static void omap_hsmmc_gpio_free(struct omap_mmc_platform_data *pdata)
-{
-	if (gpio_is_valid(pdata->slots[0].gpio_wp))
-		gpio_free(pdata->slots[0].gpio_wp);
-	if (gpio_is_valid(pdata->slots[0].switch_pin))
-		gpio_free(pdata->slots[0].switch_pin);
 }
 
 /*
@@ -2052,14 +2039,14 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	ret = omap_hsmmc_gpio_init(pdata);
+	ret = omap_hsmmc_gpio_init(pdev, pdata);
 	if (ret)
 		goto err;
 
 	mmc = mmc_alloc_host(sizeof(struct omap_hsmmc_host), &pdev->dev);
 	if (!mmc) {
 		ret = -ENOMEM;
-		goto err_alloc;
+		goto err;
 	}
 
 	host		= mmc_priv(mmc);
@@ -2282,8 +2269,6 @@ err_irq:
 		clk_disable_unprepare(host->dbclk);
 err1:
 	mmc_free_host(mmc);
-err_alloc:
-	omap_hsmmc_gpio_free(pdata);
 err:
 	return ret;
 }
@@ -2309,7 +2294,6 @@ static int omap_hsmmc_remove(struct platform_device *pdev)
 	if (host->dbclk)
 		clk_disable_unprepare(host->dbclk);
 
-	omap_hsmmc_gpio_free(host->pdata);
 	mmc_free_host(host->mmc);
 
 	return 0;
-- 
1.7.9.5

