Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374AbaLKVoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:44:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964903AbaLKVoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:44:21 -0500
From: NeilBrown <neilb@suse.de>
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Date: Fri, 12 Dec 2014 08:43:08 +1100
Subject: [PATCH 1/3] mmc: omap_hsmmc: remove prepare/complete system suspend
 support.
Cc: Venkatraman S <svenkatr@ti.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        GTA04 owners <gta04-owner@goldelico.com>, Chris Ball <cjb@laptop.org>,
        linux-omap@vger.kernel.org
Message-ID: <20141211214308.3753.79794.stgit@notabene.brown>
In-Reply-To: <20141211214023.3753.10652.stgit@notabene.brown>
References: <20141211214023.3753.10652.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/mmc/host/omap_hsmmc.c          |   50 --------------------------------
 include/linux/platform_data/mmc-omap.h |    4 ---
 2 files changed, 54 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 7c71dcdcba8b..537cba8f1de1 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -275,31 +275,6 @@ static int omap_hsmmc_get_cover_state(struct device *dev)
 	return !gpio_get_value_cansleep(mmc->switch_pin);
 }
 
-#ifdef CONFIG_PM
-
-static int omap_hsmmc_suspend_cdirq(struct device *dev)
-{
-	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-
-	disable_irq(host->card_detect_irq);
-	return 0;
-}
-
-static int omap_hsmmc_resume_cdirq(struct device *dev)
-{
-	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-
-	enable_irq(host->card_detect_irq);
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
 
 static int omap_hsmmc_set_power(struct device *dev, int power_on, int vdd)
@@ -2234,8 +2209,6 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 				"Unable to grab MMC CD IRQ\n");
 			goto err_irq_cd;
 		}
-		host->suspend = omap_hsmmc_suspend_cdirq;
-		host->resume = omap_hsmmc_resume_cdirq;
 	}
 
 	omap_hsmmc_disable_irq(host);
@@ -2322,25 +2295,6 @@ static int omap_hsmmc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int omap_hsmmc_prepare(struct device *dev)
-{
-	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-
-	if (host->suspend)
-		return host->suspend(dev);
-
-	return 0;
-}
-
-static void omap_hsmmc_complete(struct device *dev)
-{
-	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
-
-	if (host->resume)
-		host->resume(dev);
-
-}
-
 static int omap_hsmmc_suspend(struct device *dev)
 {
 	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
@@ -2398,8 +2352,6 @@ static int omap_hsmmc_resume(struct device *dev)
 }
 
 #else
-#define omap_hsmmc_prepare	NULL
-#define omap_hsmmc_complete	NULL
 #define omap_hsmmc_suspend	NULL
 #define omap_hsmmc_resume	NULL
 #endif
@@ -2484,8 +2436,6 @@ static int omap_hsmmc_runtime_resume(struct device *dev)
 static struct dev_pm_ops omap_hsmmc_dev_pm_ops = {
 	.suspend	= omap_hsmmc_suspend,
 	.resume		= omap_hsmmc_resume,
-	.prepare	= omap_hsmmc_prepare,
-	.complete	= omap_hsmmc_complete,
 	.runtime_suspend = omap_hsmmc_runtime_suspend,
 	.runtime_resume = omap_hsmmc_runtime_resume,
 };
diff --git a/include/linux/platform_data/mmc-omap.h b/include/linux/platform_data/mmc-omap.h
index 5c188f4e9bec..929469291406 100644
--- a/include/linux/platform_data/mmc-omap.h
+++ b/include/linux/platform_data/mmc-omap.h
@@ -31,10 +31,6 @@ struct omap_mmc_platform_data {
 	void (*cleanup)(struct device *dev);
 	void (*shutdown)(struct device *dev);
 
-	/* To handle board related suspend/resume functionality for MMC */
-	int (*suspend)(struct device *dev, int slot);
-	int (*resume)(struct device *dev, int slot);
-
 	/* Return context loss count due to PM states changing */
 	int (*get_context_loss_count)(struct device *dev);
 


