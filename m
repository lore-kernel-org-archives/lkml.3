Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3ATLaO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 06:30:14 -0500
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:54406 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751809Ab3ATLaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 06:30:12 -0500
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1] mmc: core: move the cache disabling operation to mmc_suspend
Date: Sun, 20 Jan 2013 13:29:16 +0200
Message-Id: <1358681368-13044-1-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache control is an eMMC feature and in therefore should be
part of MMC's bus resume operations, performed in mmc_suspend,
rather than in the generic mmc_suspend_host().

Signed-off-by: Maya Erez <merez@codeaurora.org>

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index aaed768..b438bb2 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2388,6 +2388,7 @@ EXPORT_SYMBOL(mmc_flush_cache);
  * Turn the cache ON/OFF.
  * Turning the cache OFF shall trigger flushing of the data
  * to the non-volatile storage.
+ * This function should be called with host claimed
  */
 int mmc_cache_ctrl(struct mmc_host *host, u8 enable)
 {
@@ -2399,7 +2400,6 @@ int mmc_cache_ctrl(struct mmc_host *host, u8 enable)
 			mmc_card_is_removable(host))
 		return err;
 
-	mmc_claim_host(host);
 	if (card && mmc_card_mmc(card) &&
 			(card->ext_csd.cache_size > 0)) {
 		enable = !!enable;
@@ -2417,7 +2417,6 @@ int mmc_cache_ctrl(struct mmc_host *host, u8 enable)
 				card->ext_csd.cache_ctrl = enable;
 		}
 	}
-	mmc_release_host(host);
 
 	return err;
 }
@@ -2436,10 +2435,6 @@ int mmc_suspend_host(struct mmc_host *host)
 	cancel_delayed_work(&host->detect);
 	mmc_flush_scheduled_work();
 
-	err = mmc_cache_ctrl(host, 0);
-	if (err)
-		goto out;
-
 	mmc_bus_get(host);
 	if (host->bus_ops && !host->bus_dead) {
 		if (host->bus_ops->suspend) {
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index e6e3911..dc17d40 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1379,6 +1379,11 @@ static int mmc_suspend(struct mmc_host *host)
 	BUG_ON(!host->card);
 
 	mmc_claim_host(host);
+
+	err = mmc_cache_ctrl(host, 0);
+	if (err)
+		goto out;
+
 	if (mmc_can_poweroff_notify(host->card))
 		err = mmc_poweroff_notify(host->card, EXT_CSD_POWER_OFF_SHORT);
 	else if (mmc_card_can_sleep(host))
@@ -1386,8 +1391,9 @@ static int mmc_suspend(struct mmc_host *host)
 	else if (!mmc_host_is_spi(host))
 		err = mmc_deselect_cards(host);
 	host->card->state &= ~(MMC_STATE_HIGHSPEED | MMC_STATE_HIGHSPEED_200);
-	mmc_release_host(host);
 
+out:
+	mmc_release_host(host);
 	return err;
 }
 
-- 
1.7.3.3
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
