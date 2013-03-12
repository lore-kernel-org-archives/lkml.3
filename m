Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3CLKn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:43:57 -0400
Received: from multi.imgtec.com ([194.200.65.239]:42786 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3CLKn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:43:56 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-mmc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH] mmc: dw_mmc: setpower on MMC_POWER_{UP,OFF}
Date: Tue, 12 Mar 2013 10:43:32 +0000
Message-ID: <1363085012-9220-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_12_10_43_47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call the setpower platform callback in response to set_ios with
ios->power_mode == MMC_POWER_UP or MMC_POWER_OFF, instead of from the
card detect work function.

This appears to fix a problem I have where a card stuck in a funny state
doesn't get properly cleared by the power being turned off, presumably
due to lack of power sequencing. This resulted in the following log
messages after boot:

mmc0: error -110 whilst initialising SD card
mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 300000Hz, actual 298922HZ div = 167)
mmc0: error -110 whilst initialising SD card
mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 200000Hz, actual 199680HZ div = 250)
mmc0: error -110 whilst initialising SD card
mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 195765Hz, actual 195764HZ div = 255)
mmc0: error -110 whilst initialising SD card
mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 400000Hz, actual 399360HZ div = 125)
mmc0: error -110 whilst initialising SD card
mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 300000Hz, actual 298922HZ div = 167)

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/host/dw_mmc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 60063cc..1a42c7c 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -818,6 +818,14 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	switch (ios->power_mode) {
 	case MMC_POWER_UP:
 		set_bit(DW_MMC_CARD_NEED_INIT, &slot->flags);
+		/* Power up slot */
+		if (slot->host->pdata->setpower)
+			slot->host->pdata->setpower(slot->id, mmc->ocr_avail);
+		break;
+	case MMC_POWER_OFF:
+		/* Power down slot */
+		if (slot->host->pdata->setpower)
+			slot->host->pdata->setpower(slot->id, 0);
 		break;
 	default:
 		break;
@@ -1674,10 +1682,6 @@ static void dw_mci_work_routine_card(struct work_struct *work)
 			dev_dbg(&slot->mmc->class_dev, "card %s\n",
 				present ? "inserted" : "removed");
 
-			/* Power up slot (before spin_lock, may sleep) */
-			if (present != 0 && host->pdata->setpower)
-				host->pdata->setpower(slot->id, mmc->ocr_avail);
-
 			spin_lock_bh(&host->lock);
 
 			/* Card change detected */
@@ -1760,10 +1764,6 @@ static void dw_mci_work_routine_card(struct work_struct *work)
 
 			spin_unlock_bh(&host->lock);
 
-			/* Power down slot (after spin_unlock, may sleep) */
-			if (present == 0 && host->pdata->setpower)
-				host->pdata->setpower(slot->id, 0);
-
 			present = dw_mci_get_cd(mmc);
 		}
 
-- 
1.8.1.2


