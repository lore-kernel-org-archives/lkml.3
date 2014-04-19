Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaDSWHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 18:07:32 -0400
Received: from isonoe.totalueberwachung.de ([78.47.116.18]:39035 "EHLO
	isonoe.totalueberwachung.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbaDSWHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 18:07:25 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Apr 2014 18:07:24 EDT
From: Daniel Willmann <daniel@totalueberwachung.de>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Daniel Willmann <daniel@totalueberwachung.de>
Subject: [PATCH] mmc: mxs: fix card detection function for broken card detect
Date: Sat, 19 Apr 2014 23:59:18 +0200
Message-Id: <dec3cef26b7470cabfc11a83750a88db5b545a41.1397944151.git.daniel@totalueberwachung.de>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOSYS in get_cd if broken-cd is specified in the device tree.

Commit a91fe279ae75 (mmc: mxs: use standard flag for broken card
detection) sets MMC_CAP_NEEDS_POLL when broken-cd is specified. This
driver sets this flag unconditionally as it does not support a card
detect interrupt. Instead, broken-cd means that there is no card detect
signal connected.

The mmc core checks the get_cd function return value to determine if a
card is present. Only for a non-zero return value it will attempt to
initialize the card. So retuning -ENOSYS will allow the card to be
initialized.
For comparison, mmc_gpio_get_cd in slot-gpio.c also returns -ENOSYS if
the card detect GPIO is not valid.

Signed-off-by: Daniel Willmann <daniel@totalueberwachung.de>
---
This might be relevant for stable kernels. The patch was tested with 3.14.1 on
olinuxino nano.

 drivers/mmc/host/mxs-mmc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 073e871a0fc8..babfea03ba8a 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -70,6 +70,7 @@ struct mxs_mmc_host {
 	unsigned char			bus_width;
 	spinlock_t			lock;
 	int				sdio_irq_en;
+	bool				broken_cd;
 };
 
 static int mxs_mmc_get_cd(struct mmc_host *mmc)
@@ -78,6 +79,9 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
 	struct mxs_ssp *ssp = &host->ssp;
 	int present, ret;
 
+	if (host->broken_cd)
+		return -ENOSYS;
+
 	ret = mmc_gpio_get_cd(mmc);
 	if (ret >= 0)
 		return ret;
@@ -568,6 +572,7 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id =
 			of_match_device(mxs_mmc_dt_ids, &pdev->dev);
+	struct device_node *np = pdev->dev.of_node;
 	struct mxs_mmc_host *host;
 	struct mmc_host *mmc;
 	struct resource *iores;
@@ -634,6 +639,8 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 	mmc->caps = MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED |
 		    MMC_CAP_SDIO_IRQ | MMC_CAP_NEEDS_POLL;
 
+	host->broken_cd = of_property_read_bool(np, "broken-cd");
+
 	mmc->f_min = 400000;
 	mmc->f_max = 288000000;
 
-- 
1.8.4.2

