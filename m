Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaKGXz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:55:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbaKGXzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:55:22 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Balaji T K <balajitk@ti.com>
Date: Sat, 08 Nov 2014 10:52:28 +1100
Subject: [PATCH 3/3] mmc: omap_hsmmc: use mmc_of_parse to parse common mmc
 configuration.
Cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>
Message-ID: <20141107235228.4923.23453.stgit@notabene.brown>
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

This ensures that all standard options are available to hsmmc,
In particular, I need cap-power-off-card.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/mmc/host/omap_hsmmc.c |   33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 3fe02cf077ec..06362c1ee31d 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1903,13 +1903,6 @@ static struct omap_mmc_platform_data *of_get_hsmmc_pdata(struct device *dev)
 {
 	struct omap_mmc_platform_data *pdata;
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
@@ -1920,34 +1913,20 @@ static struct omap_mmc_platform_data *of_get_hsmmc_pdata(struct device *dev)
 
 	/* This driver only supports 1 slot */
 	pdata->nr_slots = 1;
-	pdata->slots[0].switch_pin = cd_gpio;
-	pdata->slots[0].gpio_wp = wp_gpio;
+	pdata->slots[0].switch_pin = -EINVAL;
+	pdata->slots[0].gpio_wp = -EINVAL;
 
 	if (of_find_property(np, "ti,non-removable", NULL)) {
 		pdata->slots[0].nonremovable = true;
 		pdata->slots[0].no_regulator_off_init = true;
 	}
-	of_property_read_u32(np, "bus-width", &bus_width);
-	if (bus_width == 4)
-		pdata->slots[0].caps |= MMC_CAP_4_BIT_DATA;
-	else if (bus_width == 8)
-		pdata->slots[0].caps |= MMC_CAP_8_BIT_DATA;
 
 	if (of_find_property(np, "ti,needs-special-reset", NULL))
 		pdata->slots[0].features |= HSMMC_HAS_UPDATED_RESET;
 
-	if (!of_property_read_u32(np, "max-frequency", &max_freq))
-		pdata->max_freq = max_freq;
-
 	if (of_find_property(np, "ti,needs-special-hs-handling", NULL))
 		pdata->slots[0].features |= HSMMC_HAS_HSPE_SUPPORT;
 
-	if (of_find_property(np, "keep-power-in-suspend", NULL))
-		pdata->slots[0].pm_caps |= MMC_PM_KEEP_POWER;
-
-	if (of_find_property(np, "enable-sdio-wakeup", NULL))
-		pdata->slots[0].pm_caps |= MMC_PM_WAKE_SDIO_IRQ;
-
 	return pdata;
 }
 #else
@@ -2014,6 +1993,10 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err1;
 
+	ret = mmc_of_parse(mmc);
+	if (ret)
+		goto err1;
+
 	host		= mmc_priv(mmc);
 	host->mmc	= mmc;
 	host->pdata	= pdata;
@@ -2039,7 +2022,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 
 	if (pdata->max_freq > 0)
 		mmc->f_max = pdata->max_freq;
-	else
+	else if (mmc->f_max == 0)
 		mmc->f_max = OMAP_MMC_MAX_CLOCK;
 
 	spin_lock_init(&host->irq_lock);
@@ -2093,7 +2076,7 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	if (mmc_slot(host).nonremovable)
 		mmc->caps |= MMC_CAP_NONREMOVABLE;
 
-	mmc->pm_caps = mmc_slot(host).pm_caps;
+	mmc->pm_caps |= mmc_slot(host).pm_caps;
 
 	omap_hsmmc_conf_bus_power(host);
 


