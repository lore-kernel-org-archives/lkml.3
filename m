Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbaFJO5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:57:16 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57858 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaFJO5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:57:14 -0400
From: Roman Pen <r.peniaev@gmail.com>
Cc: Roman Pen <r.peniaev@gmail.com>, Chris Ball <chris@printf.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: mxs: fix card detection in case of 'broken-cd' flag set
Date: Tue, 10 Jun 2014 23:57:02 +0900
Message-Id: <1402412222-18020-1-git-send-email-r.peniaev@gmail.com>
X-Mailer: git-send-email 1.9.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of reboot my olinuxino imx23 board does not see
mmc card any more. mmc_rescan is being called by delayed
work in loop, but mxs_mmc_get_cd always returns 0, so we
will never pass the card detection check and will not do
further card inition.

This patch is just an attempt to partially revert the patch
a91fe279ae of Sascha Hauer, where it is claimed that upper
layer will handle broken card detection using the polling
logic and MMC_CAP_NEEDS_POLL capability, but seems it is not
true, because upper logic still expects 1 from 'get_cd'.

So, here we always return 1 (card present) in case of
MMC_CAP_NEEDS_POLL capability set.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
CC: Chris Ball <chris@printf.net>
CC: Sascha Hauer <s.hauer@pengutronix.de>
CC: Fabio Estevam <fabio.estevam@freescale.com>
CC: Shawn Guo <shawn.guo@linaro.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/mxs-mmc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 073e871..9187ce1 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -82,7 +82,8 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
 	if (ret >= 0)
 		return ret;
 
-	present = !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
+	present = mmc->caps & MMC_CAP_NEEDS_POLL ||
+		!(readl(ssp->base + HW_SSP_STATUS(ssp)) &
 			BM_SSP_STATUS_CARD_DETECT);
 
 	if (mmc->caps2 & MMC_CAP2_CD_ACTIVE_HIGH)
-- 
1.9.1

