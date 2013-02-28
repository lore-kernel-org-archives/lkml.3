Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab3B1Hpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 02:45:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:7716 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab3B1Hps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 02:45:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,754,1355126400"; 
   d="scan'208";a="291677060"
Subject: [PATCH 2/5] mmc: core: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
From: Li Fei <fei.li@intel.com>
To: cjb@laptop.org, ulf.hansson@linaro.org, johan.rudholm@stericsson.com,
        subhashj@codeaurora.org, prakity@marvell.com,
        rafael.j.wysocki@intel.com, thierry.reding@avionic-design.de,
        sachin.kamat@linaro.org
Cc: linux-mmc@vger.kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, fei.li@intel.com
In-Reply-To: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Feb 2013 15:44:15 +0800
Message-ID: <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Even in failed case of pm_runtime_get_sync, the usage_count
is incremented. In order to keep the usage_count with correct
value and runtime power management to behave correctly, call
pm_runtime_put(_sync) in such case.

Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
---
 drivers/mmc/core/sdio.c     |    3 +--
 drivers/mmc/core/sdio_bus.c |    4 +++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index aa0719a..45ab6f32 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -874,6 +874,7 @@ static void mmc_sdio_detect(struct mmc_host *host)
 
 	mmc_release_host(host);
 
+out:
 	/*
 	 * Tell PM core it's OK to power off the card now.
 	 *
@@ -887,8 +888,6 @@ static void mmc_sdio_detect(struct mmc_host *host)
 	 */
 	if (host->caps & MMC_CAP_POWER_OFF_CARD)
 		pm_runtime_put_sync(&host->card->dev);
-
-out:
 	if (err) {
 		mmc_sdio_remove(host);
 
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 5e57048..d572b31 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -136,8 +136,10 @@ static int sdio_bus_probe(struct device *dev)
 	 */
 	if (func->card->host->caps & MMC_CAP_POWER_OFF_CARD) {
 		ret = pm_runtime_get_sync(dev);
-		if (ret < 0)
+		if (ret < 0) {
+			pm_runtime_put_sync(dev);
 			goto out;
+		}
 	}
 
 	/* Set the default block size so the driver is sure it's something
-- 
1.7.4.1



