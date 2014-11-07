Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaKGXzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:55:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbaKGXzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:55:05 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Balaji T K <balajitk@ti.com>
Date: Sat, 08 Nov 2014 10:52:28 +1100
Subject: [PATCH 1/3] mmc: omap_hsmmc: remove prepare/complete system suspend
 support.
Cc: Venkatraman S <svenkatr@ti.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Chris Ball <cjb@laptop.org>, linux-omap@vger.kernel.org,
        GTA04 owners <gta04-owner@goldelico.com>
Message-ID: <20141107235228.4923.88336.stgit@notabene.brown>
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

The only function of these 'prepare' and 'complete' is to
disable the 'card detect' irq during suspend.

The commit which added this,
commit a48ce884d5819d5df2cf1139ab3c43f8e9e419b3
    mmc: omap_hsmmc: Introduce omap_hsmmc_prepare/complete

justified it by the need to avoid the registration of new devices
during suspend.
However mmc_pm_notify will set ->rescan_disable in the 'prepare'
stage and clear it in the 'complete' stage, so no card detection
will actually happen.
Also the interrupt will be disabled before final suspend as part
of common suspend processing.

So this disabling of the interrupt is unnecessary, and interferes
with a transition to using common code for card-detect management.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Venkatraman S <svenkatr@ti.com>
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/mmc/host/omap_hsmmc.c          |   52 --------------------------------
 include/linux/platform_data/mmc-omap.h |    4 --
 2 files changed, 56 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 965672663ef0..6958e6898d03 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -257,33 +257,6 @@ static int omap_hsmmc_get_cover_state(struct device *dev, int slot)
 	return !gpio_get_value_cansleep(mmc->slots[0].switch_pin);
 }
 
-#ifdef CONFIG_PM
-
-static int omap_hsmmc_suspend_cdirq(struct device *dev, int slot)
-{
-	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-	struct omap_mmc_platform_data *mmc = host->pdata;
-
-	disable_irq(mmc->slots[0].card_detect_irq);
-	return 0;
-}
-
-static int omap_hsmmc_resume_cdirq(struct device *dev, int slot)
-{
-	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-	struct omap_mmc_platform_data *mmc = host->pdata;
-
-	enable_irq(mmc->slots[0].card_detect_irq);
-	return 0;
-}
-
-#else
-
-#define omap_hsmmc_suspend_cdirq	NULL
-#define omap_hsmmc_resume_cdirq		NULL
-
-#endif
-
 #ifdef CONFIG_REGULATOR
 
 static int omap_hsmmc_set_power(struct device *dev, int slot, int power_on,
@@ -2223,8 +2196,6 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 				"Unable to grab MMC CD IRQ\n");
 			goto err_irq_cd;
 		}
-		pdata->suspend = omap_hsmmc_suspend_cdirq;
-		pdata->resume = omap_hsmmc_resume_cdirq;
 	}
 
 	omap_hsmmc_disable_irq(host);
@@ -2316,25 +2287,6 @@ static int omap_hsmmc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int omap_hsmmc_prepare(struct device *dev)
-{
-	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-
-	if (host->pdata->suspend)
-		return host->pdata->suspend(dev, host->slot_id);
-
-	return 0;
-}
-
-static void omap_hsmmc_complete(struct device *dev)
-{
-	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-
-	if (host->pdata->resume)
-		host->pdata->resume(dev, host->slot_id);
-
-}
-
 static int omap_hsmmc_suspend(struct device *dev)
 {
 	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
@@ -2392,8 +2344,6 @@ static int omap_hsmmc_resume(struct device *dev)
 }
 
 #else
-#define omap_hsmmc_prepare	NULL
-#define omap_hsmmc_complete	NULL
 #define omap_hsmmc_suspend	NULL
 #define omap_hsmmc_resume	NULL
 #endif
@@ -2478,8 +2428,6 @@ static int omap_hsmmc_runtime_resume(struct device *dev)
 static struct dev_pm_ops omap_hsmmc_dev_pm_ops = {
 	.suspend	= omap_hsmmc_suspend,
 	.resume		= omap_hsmmc_resume,
-	.prepare	= omap_hsmmc_prepare,
-	.complete	= omap_hsmmc_complete,
 	.runtime_suspend = omap_hsmmc_runtime_suspend,
 	.runtime_resume = omap_hsmmc_runtime_resume,
 };
diff --git a/include/linux/platform_data/mmc-omap.h b/include/linux/platform_data/mmc-omap.h
index 51e70cf25cbc..0512e3f27de4 100644
--- a/include/linux/platform_data/mmc-omap.h
+++ b/include/linux/platform_data/mmc-omap.h
@@ -55,10 +55,6 @@ struct omap_mmc_platform_data {
 	void (*cleanup)(struct device *dev);
 	void (*shutdown)(struct device *dev);
 
-	/* To handle board related suspend/resume functionality for MMC */
-	int (*suspend)(struct device *dev, int slot);
-	int (*resume)(struct device *dev, int slot);
-
 	/* Return context loss count due to PM states changing */
 	int (*get_context_loss_count)(struct device *dev);
 


