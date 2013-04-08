Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934687Ab3DHBkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 21:40:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:36260 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934658Ab3DHBkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 21:40:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,427,1363158000"; 
   d="scan'208";a="315534919"
Subject: [PATCH 2/5 V2] mmc: core: call pm_runtime_put_noidle in
 pm_runtime_get_sync failed case
From: Li Fei <fei.li@intel.com>
To: cjb@laptop.org, ohad@wizery.com
Cc: ulf.hansson@linaro.org, johan.rudholm@stericsson.com,
        subhashj@codeaurora.org, rafael.j.wysocki@intel.com,
        thierry.reding@avionic-design.de, sachin.kamat@linaro.org,
        linux-mmc@vger.kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, fei.li@intel.com
In-Reply-To: <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Apr 2013 09:36:39 +0800
Message-ID: <1365384999.31128.6.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Even in failed case of pm_runtime_get_sync, the usage_count
is incremented. In order to keep the usage_count with correct
value and runtime power management to behave correctly, call
pm_runtime_put_noidle in such case.

Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
---
 drivers/mmc/core/sdio.c     |    4 +++-
 drivers/mmc/core/sdio_bus.c |    3 +--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index aa0719a..6889a82 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -861,8 +861,10 @@ static void mmc_sdio_detect(struct mmc_host *host)
 	/* Make sure card is powered before detecting it */
 	if (host->caps & MMC_CAP_POWER_OFF_CARD) {
 		err = pm_runtime_get_sync(&host->card->dev);
-		if (err < 0)
+		if (err < 0) {
+			pm_runtime_put_noidle(&host->card->dev);
 			goto out;
+		}
 	}
 
 	mmc_claim_host(host);
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 5e57048..7bfefb5 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -137,7 +137,7 @@ static int sdio_bus_probe(struct device *dev)
 	if (func->card->host->caps & MMC_CAP_POWER_OFF_CARD) {
 		ret = pm_runtime_get_sync(dev);
 		if (ret < 0)
-			goto out;
+			goto disable_runtimepm;
 	}
 
 	/* Set the default block size so the driver is sure it's something
@@ -157,7 +157,6 @@ static int sdio_bus_probe(struct device *dev)
 disable_runtimepm:
 	if (func->card->host->caps & MMC_CAP_POWER_OFF_CARD)
 		pm_runtime_put_noidle(dev);
-out:
 	return ret;
 }
 
-- 
1.7.4.1




