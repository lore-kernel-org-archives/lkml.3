Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaKGXzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:55:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbaKGXzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:55:13 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Balaji T K <balajitk@ti.com>
Date: Sat, 08 Nov 2014 10:52:28 +1100
Subject: [PATCH 2/3] mmc: omap_hsmmc: use slot-gpio library for gpio support.
Cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>
Message-ID: <20141107235228.4923.4743.stgit@notabene.brown>
In-Reply-To: <20141107234628.4923.60525.stgit@notabene.brown>
References: <20141107234628.4923.60525.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
X-Spam-Warning: HELO: vger.kernel.org not a valid domain

Using the common code removes some code duplication, and
makes it easier to switch to using mmc_of_parse() which
will remove more duplication.

As hsmmc has a slightly different interrupt service routine
for card-detect, enhance slot-gpio to allow an alternate
routine to be provided.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/mmc/core/slot-gpio.c  |   21 +++++++++++-
 drivers/mmc/host/omap_hsmmc.c |   73 ++++++++++-------------------------------
 include/linux/mmc/slot-gpio.h |    2 +
 3 files changed, 39 insertions(+), 57 deletions(-)

diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
index 5f89cb83d5f0..f3bc51f9aba9 100644
--- a/drivers/mmc/core/slot-gpio.c
+++ b/drivers/mmc/core/slot-gpio.c
@@ -23,6 +23,7 @@ struct mmc_gpio {
 	struct gpio_desc *cd_gpio;
 	bool override_ro_active_level;
 	bool override_cd_active_level;
+	irqreturn_t (*cd_gpio_isr)(int irq, void *dev_id);
 	char *ro_label;
 	char cd_label[0];
 };
@@ -156,8 +157,10 @@ void mmc_gpiod_request_cd_irq(struct mmc_host *host)
 		irq = -EINVAL;
 
 	if (irq >= 0) {
+		if (ctx->cd_gpio_isr == NULL)
+			ctx->cd_gpio_isr = mmc_gpio_cd_irqt;
 		ret = devm_request_threaded_irq(&host->class_dev, irq,
-			NULL, mmc_gpio_cd_irqt,
+			NULL, ctx->cd_gpio_isr,
 			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 			ctx->cd_label, host);
 		if (ret < 0)
@@ -171,6 +174,22 @@ void mmc_gpiod_request_cd_irq(struct mmc_host *host)
 }
 EXPORT_SYMBOL(mmc_gpiod_request_cd_irq);
 
+int mmc_gpio_request_cd_isr(struct mmc_host *host,
+			    irqreturn_t (*isr)(int irq, void *dev_id))
+{
+	struct mmc_gpio *ctx;
+	int ret;
+
+	ret = mmc_gpio_alloc(host);
+	if (ret < 0)
+		return ret;
+	ctx = host->slot.handler_priv;
+	if (ctx->cd_gpio_isr)
+		return -EBUSY;
+	ctx->cd_gpio_isr = isr;
+	return 0;
+}
+
 /**
  * mmc_gpio_request_cd - request a gpio for card-detection
  * @host: mmc host
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 6958e6898d03..3fe02cf077ec 100644
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
@@ -233,28 +234,22 @@ static void omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host);
 static int omap_hsmmc_card_detect(struct device *dev, int slot)
 {
 	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-	struct omap_mmc_platform_data *mmc = host->pdata;
 
-	/* NOTE: assumes card detect signal is active-low */
-	return !gpio_get_value_cansleep(mmc->slots[0].switch_pin);
+	return mmc_gpio_get_cd(host->mmc);
 }
 
 static int omap_hsmmc_get_wp(struct device *dev, int slot)
 {
 	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-	struct omap_mmc_platform_data *mmc = host->pdata;
 
-	/* NOTE: assumes write protect signal is active-high */
-	return gpio_get_value_cansleep(mmc->slots[0].gpio_wp);
+	return mmc_gpio_get_ro(host->mmc);
 }
 
 static int omap_hsmmc_get_cover_state(struct device *dev, int slot)
 {
 	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-	struct omap_mmc_platform_data *mmc = host->pdata;
 
-	/* NOTE: assumes card detect signal is active-low */
-	return !gpio_get_value_cansleep(mmc->slots[0].switch_pin);
+	return mmc_gpio_get_cd(host->mmc);
 }
 
 #ifdef CONFIG_REGULATOR
@@ -422,7 +417,10 @@ static inline int omap_hsmmc_have_reg(void)
 
 #endif
 
-static int omap_hsmmc_gpio_init(struct omap_mmc_platform_data *pdata)
+static irqreturn_t omap_hsmmc_detect(int irq, void *dev_id);
+
+static int omap_hsmmc_gpio_init(struct mmc_host *mmc,
+				struct omap_mmc_platform_data *pdata)
 {
 	int ret;
 
@@ -434,43 +432,24 @@ static int omap_hsmmc_gpio_init(struct omap_mmc_platform_data *pdata)
 			pdata->slots[0].card_detect = omap_hsmmc_card_detect;
 		pdata->slots[0].card_detect_irq =
 				gpio_to_irq(pdata->slots[0].switch_pin);
-		ret = gpio_request(pdata->slots[0].switch_pin, "mmc_cd");
+		ret = mmc_gpio_request_cd_isr(mmc, omap_hsmmc_detect);
 		if (ret)
 			return ret;
-		ret = gpio_direction_input(pdata->slots[0].switch_pin);
+		ret = mmc_gpio_request_cd(mmc, pdata->slots[0].switch_pin, 0);
 		if (ret)
-			goto err_free_sp;
+			return ret;
 	} else
 		pdata->slots[0].switch_pin = -EINVAL;
 
 	if (gpio_is_valid(pdata->slots[0].gpio_wp)) {
 		pdata->slots[0].get_ro = omap_hsmmc_get_wp;
-		ret = gpio_request(pdata->slots[0].gpio_wp, "mmc_wp");
-		if (ret)
-			goto err_free_cd;
-		ret = gpio_direction_input(pdata->slots[0].gpio_wp);
+		ret = mmc_gpio_request_ro(mmc, pdata->slots[0].gpio_wp);
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
@@ -2025,16 +2004,16 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	ret = omap_hsmmc_gpio_init(pdata);
-	if (ret)
-		goto err;
-
 	mmc = mmc_alloc_host(sizeof(struct omap_hsmmc_host), &pdev->dev);
 	if (!mmc) {
 		ret = -ENOMEM;
 		goto err_alloc;
 	}
 
+	ret = omap_hsmmc_gpio_init(mmc, pdata);
+	if (ret)
+		goto err1;
+
 	host		= mmc_priv(mmc);
 	host->mmc	= mmc;
 	host->pdata	= pdata;
@@ -2184,20 +2163,6 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 
 	mmc->ocr_avail = mmc_slot(host).ocr_mask;
 
-	/* Request IRQ for card detect */
-	if ((mmc_slot(host).card_detect_irq)) {
-		ret = devm_request_threaded_irq(&pdev->dev,
-						mmc_slot(host).card_detect_irq,
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
@@ -2236,7 +2201,6 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 
 err_slot_name:
 	mmc_remove_host(mmc);
-err_irq_cd:
 	if (host->use_reg)
 		omap_hsmmc_reg_put(host);
 err_reg:
@@ -2254,8 +2218,6 @@ err_irq:
 err1:
 	mmc_free_host(mmc);
 err_alloc:
-	omap_hsmmc_gpio_free(pdata);
-err:
 	return ret;
 }
 
@@ -2280,7 +2242,6 @@ static int omap_hsmmc_remove(struct platform_device *pdev)
 	if (host->dbclk)
 		clk_disable_unprepare(host->dbclk);
 
-	omap_hsmmc_gpio_free(host->pdata);
 	mmc_free_host(host->mmc);
 
 	return 0;
diff --git a/include/linux/mmc/slot-gpio.h b/include/linux/mmc/slot-gpio.h
index d2433381e828..a119892cebdb 100644
--- a/include/linux/mmc/slot-gpio.h
+++ b/include/linux/mmc/slot-gpio.h
@@ -25,6 +25,8 @@ void mmc_gpio_free_cd(struct mmc_host *host);
 int mmc_gpiod_request_cd(struct mmc_host *host, const char *con_id,
 			 unsigned int idx, bool override_active_level,
 			 unsigned int debounce);
+int mmc_gpio_request_cd_isr(struct mmc_host *host,
+			    irqreturn_t (*isr)(int irq, void *dev_id));
 void mmc_gpiod_free_cd(struct mmc_host *host);
 void mmc_gpiod_request_cd_irq(struct mmc_host *host);
 


