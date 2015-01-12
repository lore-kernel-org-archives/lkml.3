Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbbALTZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:25:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881AbbALTZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:25:01 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Date: Tue, 13 Jan 2015 08:23:18 +1300
Subject: [PATCH 3/3] mmc: omap_hsmmc: use mmc_of_parse to parse common mmc
 configuration.
Cc: GTA04 owners <gta04-owner@goldelico.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20150112192318.2895.17426.stgit@notabene.brown>
In-Reply-To: <20150112191702.2895.75815.stgit@notabene.brown>
References: <20150112191702.2895.75815.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ensures that all standard options are available to hsmmc,
In particular, I need cap-power-off-card.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/mmc/host/omap_hsmmc.c |   33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 08c65e01b547..f84cfb01716d 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1929,13 +1929,6 @@ static struct omap_hsmmc_platform_data *of_get_hsmmc_pdata(struct device *dev)
 {
 	struct omap_hsmmc_platform_data *pdata;
 	struct device_node *np = dev->of_node;
-	u32 bus_width, max_freq;
-	int cd_gpio, wp_gpio;
-
-	cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
-	wp_gpio = of_get_named_gpio(np, "wp-gpios", 0);
-	if (cd_gpio == -EPROBE_DEFER || wp_gpio == -EPROBE_DEFER)
-		return ERR_PTR(-EPROBE_DEFER);
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
@@ -1944,34 +1937,20 @@ static struct omap_hsmmc_platform_data *of_get_hsmmc_pdata(struct device *dev)
 	if (of_find_property(np, "ti,dual-volt", NULL))
 		pdata->controller_flags |= OMAP_HSMMC_SUPPORTS_DUAL_VOLT;
 
-	pdata->switch_pin = cd_gpio;
-	pdata->gpio_wp = wp_gpio;
+	pdata->switch_pin = -EINVAL;
+	pdata->gpio_wp = -EINVAL;
 
 	if (of_find_property(np, "ti,non-removable", NULL)) {
 		pdata->nonremovable = true;
 		pdata->no_regulator_off_init = true;
 	}
-	of_property_read_u32(np, "bus-width", &bus_width);
-	if (bus_width == 4)
-		pdata->caps |= MMC_CAP_4_BIT_DATA;
-	else if (bus_width == 8)
-		pdata->caps |= MMC_CAP_8_BIT_DATA;
 
 	if (of_find_property(np, "ti,needs-special-reset", NULL))
 		pdata->features |= HSMMC_HAS_UPDATED_RESET;
 
-	if (!of_property_read_u32(np, "max-frequency", &max_freq))
-		pdata->max_freq = max_freq;
-
 	if (of_find_property(np, "ti,needs-special-hs-handling", NULL))
 		pdata->features |= HSMMC_HAS_HSPE_SUPPORT;
 
-	if (of_find_property(np, "keep-power-in-suspend", NULL))
-		pdata->pm_caps |= MMC_PM_KEEP_POWER;
-
-	if (of_find_property(np, "enable-sdio-wakeup", NULL))
-		pdata->pm_caps |= MMC_PM_WAKE_SDIO_IRQ;
-
 	return pdata;
 }
 #else
@@ -2029,6 +2008,10 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 		goto err;
 	}
 
+	ret = mmc_of_parse(mmc);
+	if (ret)
+		goto err1;
+
 	host		= mmc_priv(mmc);
 	host->mmc	= mmc;
 	host->pdata	= pdata;
@@ -2057,7 +2040,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 
 	if (pdata->max_freq > 0)
 		mmc->f_max = pdata->max_freq;
-	else
+	else if (mmc->f_max == 0)
 		mmc->f_max = OMAP_MMC_MAX_CLOCK;
 
 	spin_lock_init(&host->irq_lock);
@@ -2111,7 +2094,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	if (mmc_pdata(host)->nonremovable)
 		mmc->caps |= MMC_CAP_NONREMOVABLE;
 
-	mmc->pm_caps = mmc_pdata(host)->pm_caps;
+	mmc->pm_caps |= mmc_pdata(host)->pm_caps;
 
 	omap_hsmmc_conf_bus_power(host);
 


