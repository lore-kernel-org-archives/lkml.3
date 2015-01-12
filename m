Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbbALTY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:24:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723AbbALTYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:24:55 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Date: Tue, 13 Jan 2015 08:23:18 +1300
Subject: [PATCH 2/3] mmc: omap_hsmmc: use slot-gpio library for gpio support.
Cc: GTA04 owners <gta04-owner@goldelico.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20150112192318.2895.38864.stgit@notabene.brown>
In-Reply-To: <20150112191702.2895.75815.stgit@notabene.brown>
References: <20150112191702.2895.75815.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the common code removes some code duplication, and
makes it easier to switch to using mmc_of_parse() which
will remove more duplication.

This uses the new mmc_gpio_request_cd_isr to provide a non-standard
interrupt service routine for card-detect interrupts.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/mmc/host/omap_hsmmc.c |   67 ++++++++---------------------------------
 1 file changed, 13 insertions(+), 54 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 537cba8f1de1..08c65e01b547 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -36,6 +36,7 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/core.h>
 #include <linux/mmc/mmc.h>
+#include <linux/mmc/slot-gpio.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
@@ -251,28 +252,22 @@ static void omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host);
 static int omap_hsmmc_card_detect(struct device *dev)
 {
 	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-	struct omap_hsmmc_platform_data *mmc = host->pdata;
 
-	/* NOTE: assumes card detect signal is active-low */
-	return !gpio_get_value_cansleep(mmc->switch_pin);
+	return mmc_gpio_get_cd(host->mmc);
 }
 
 static int omap_hsmmc_get_wp(struct device *dev)
 {
 	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-	struct omap_hsmmc_platform_data *mmc = host->pdata;
 
-	/* NOTE: assumes write protect signal is active-high */
-	return gpio_get_value_cansleep(mmc->gpio_wp);
+	return mmc_gpio_get_ro(host->mmc);
 }
 
 static int omap_hsmmc_get_cover_state(struct device *dev)
 {
 	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-	struct omap_hsmmc_platform_data *mmc = host->pdata;
 
-	/* NOTE: assumes card detect signal is active-low */
-	return !gpio_get_value_cansleep(mmc->switch_pin);
+	return mmc_gpio_get_cd(host->mmc);
 }
 
 #ifdef CONFIG_REGULATOR
@@ -439,7 +434,10 @@ static inline int omap_hsmmc_have_reg(void)
 
 #endif
 
-static int omap_hsmmc_gpio_init(struct omap_hsmmc_host *host,
+static irqreturn_t omap_hsmmc_detect(int irq, void *dev_id);
+
+static int omap_hsmmc_gpio_init(struct mmc_host *mmc,
+				struct omap_hsmmc_host *host,
 				struct omap_hsmmc_platform_data *pdata)
 {
 	int ret;
@@ -452,46 +450,24 @@ static int omap_hsmmc_gpio_init(struct omap_hsmmc_host *host,
 			host->card_detect = omap_hsmmc_card_detect;
 		host->card_detect_irq =
 				gpio_to_irq(pdata->switch_pin);
-		ret = gpio_request(pdata->switch_pin, "mmc_cd");
+		mmc_gpio_set_cd_isr(mmc, omap_hsmmc_detect);
+		ret = mmc_gpio_request_cd(mmc, pdata->switch_pin, 0);
 		if (ret)
 			return ret;
-		ret = gpio_direction_input(pdata->switch_pin);
-		if (ret)
-			goto err_free_sp;
 	} else {
 		pdata->switch_pin = -EINVAL;
 	}
 
 	if (gpio_is_valid(pdata->gpio_wp)) {
 		host->get_ro = omap_hsmmc_get_wp;
-		ret = gpio_request(pdata->gpio_wp, "mmc_wp");
-		if (ret)
-			goto err_free_cd;
-		ret = gpio_direction_input(pdata->gpio_wp);
+		ret = mmc_gpio_request_ro(mmc, pdata->gpio_wp);
 		if (ret)
-			goto err_free_wp;
+			return ret;
 	} else {
 		pdata->gpio_wp = -EINVAL;
 	}
 
 	return 0;
-
-err_free_wp:
-	gpio_free(pdata->gpio_wp);
-err_free_cd:
-	if (gpio_is_valid(pdata->switch_pin))
-err_free_sp:
-		gpio_free(pdata->switch_pin);
-	return ret;
-}
-
-static void omap_hsmmc_gpio_free(struct omap_hsmmc_host *host,
-				 struct omap_hsmmc_platform_data *pdata)
-{
-	if (gpio_is_valid(pdata->gpio_wp))
-		gpio_free(pdata->gpio_wp);
-	if (gpio_is_valid(pdata->switch_pin))
-		gpio_free(pdata->switch_pin);
 }
 
 /*
@@ -2066,7 +2042,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	host->next_data.cookie = 1;
 	host->pbias_enabled = 0;
 
-	ret = omap_hsmmc_gpio_init(host, pdata);
+	ret = omap_hsmmc_gpio_init(mmc, host, pdata);
 	if (ret)
 		goto err_gpio;
 
@@ -2197,20 +2173,6 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 
 	mmc->ocr_avail = mmc_pdata(host)->ocr_mask;
 
-	/* Request IRQ for card detect */
-	if (host->card_detect_irq) {
-		ret = devm_request_threaded_irq(&pdev->dev,
-						host->card_detect_irq,
-						NULL, omap_hsmmc_detect,
-					   IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-					   mmc_hostname(mmc), host);
-		if (ret) {
-			dev_err(mmc_dev(host->mmc),
-				"Unable to grab MMC CD IRQ\n");
-			goto err_irq_cd;
-		}
-	}
-
 	omap_hsmmc_disable_irq(host);
 
 	/*
@@ -2249,7 +2211,6 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 
 err_slot_name:
 	mmc_remove_host(mmc);
-err_irq_cd:
 	if (host->use_reg)
 		omap_hsmmc_reg_put(host);
 err_irq:
@@ -2262,7 +2223,6 @@ err_irq:
 	if (host->dbclk)
 		clk_disable_unprepare(host->dbclk);
 err1:
-	omap_hsmmc_gpio_free(host, pdata);
 err_gpio:
 	mmc_free_host(mmc);
 err:
@@ -2288,7 +2248,6 @@ static int omap_hsmmc_remove(struct platform_device *pdev)
 	if (host->dbclk)
 		clk_disable_unprepare(host->dbclk);
 
-	omap_hsmmc_gpio_free(host, host->pdata);
 	mmc_free_host(host->mmc);
 
 	return 0;


