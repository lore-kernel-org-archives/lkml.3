Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaJVC4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 22:56:15 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:41724 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaJVC4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 22:56:13 -0400
X-Original-SENDERIP: 10.186.119.199
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        HyoJun Im <hyojun.im@lge.com>, gunho.lee@lge.com,
        Hankyung Yu <hankyung.yu@lge.com>, Chanho Min <chanho.min@lge.com>
Subject: [PATCH] mmc:core: fix hs400 timing selection
Date: Wed, 22 Oct 2014 11:55:55 +0900
Message-Id: <1413946555-1266-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to JEDEC v5.01 spec (6.6.5), In order to switch to HS400 mode,
host should perform the following steps.

 1. HS200 mode selection completed
 2. Set HS_TIMING to 0x01(High Speed)
 3. Host changes frequency to =< 52MHz
 4. Set the bus width to DDR 8bit (CMD6)
 5. Host may read Driver Strength (CMD8)
 6. Set HS_TIMING to 0x03 (HS400)

In current implementation, the order of 2 and 3 is reversed.
The HS_TIMING field should be set to 0x1 before the clock frequency
is set to a value not greater than 52 MHz. Otherwise, Initialization of
timing can be failed. Also, the host contoller's UHS timing mode should
be set to DDR50 after the bus width is set to DDR 8bit.

Signed-off-by: Hankyung Yu <hankyung.yu@lge.com>
Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 drivers/mmc/core/mmc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index a301a78..52f78e0 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1061,9 +1061,6 @@ static int mmc_select_hs400(struct mmc_card *card)
 	 * Before switching to dual data rate operation for HS400,
 	 * it is required to convert from HS200 mode to HS mode.
 	 */
-	mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
-	mmc_set_bus_speed(card);
-
 	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 			   EXT_CSD_HS_TIMING, EXT_CSD_TIMING_HS,
 			   card->ext_csd.generic_cmd6_time,
@@ -1074,6 +1071,14 @@ static int mmc_select_hs400(struct mmc_card *card)
 		return err;
 	}
 
+	/*
+	 * According to JEDEC v5.01 spec (6.6.5), Clock frequency should
+	 * be set to a value not greater than 52MHz after the HS_TIMING
+	 * field is set to 0x1.
+	 */
+	mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
+	mmc_set_bus_speed(card);
+
 	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 			 EXT_CSD_BUS_WIDTH,
 			 EXT_CSD_DDR_BUS_WIDTH_8,
@@ -1084,6 +1089,8 @@ static int mmc_select_hs400(struct mmc_card *card)
 		return err;
 	}
 
+	mmc_set_timing(card->host, MMC_TIMING_MMC_DDR52);
+
 	err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 			   EXT_CSD_HS_TIMING, EXT_CSD_TIMING_HS400,
 			   card->ext_csd.generic_cmd6_time,
-- 
1.7.9.5

