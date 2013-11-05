Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3KEGwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:52:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:44088 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab3KEGwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:52:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="317066379"
Subject: [PATCH] mmc: sdhci: Setting the host->mrq to NULL before executing
 tuning
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, chuanxiao.dong@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Nov 2013 14:52:45 +0800
Message-ID: <1383634365.26153.100.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In function sdhci_request(), it is possible to do the tuning execution
like below:

sdhci_request() {
	spin_lock_irqsave(&host->lock, flags);
	host->mrq = mrq;
	...
	spin_unlock_irqrestore(&host->lock, flags);

<=== Here it is possible one pending finish_tasklet get running
     and it will operate the original mrq, and notified the mrq
     is done, and causes memory corruption.

	sdhci_execute_tuning(mmc, tuning_opcode);
	spin_lock_irqsave(&host->lock, flags);
	host->mrq = mrq;
...
}

In the above race place, the original mrq should not be finished wrongly,
so here before unlock the spinlock, we need to set the host->mrq to NULL
to avoid this case.

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/mmc/host/sdhci.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7a7fb4f..c7a001a 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1391,6 +1391,13 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 					mmc->card->type == MMC_TYPE_MMC ?
 					MMC_SEND_TUNING_BLOCK_HS200 :
 					MMC_SEND_TUNING_BLOCK;
+
+				/* Here we need to set the host->mrq to NULL,
+				 * in case the penging finish_tasklet
+				 * operates it wrongly.
+				 */
+				host->mrq = NULL;
+
 				spin_unlock_irqrestore(&host->lock, flags);
 				sdhci_execute_tuning(mmc, tuning_opcode);
 				spin_lock_irqsave(&host->lock, flags);
-- 
1.7.9.5



