Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaI3PKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:10:44 -0400
Received: from mx.vmgattei.com ([77.223.18.35]:48174 "EHLO mx.vmgattei.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbaI3PKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:10:17 -0400
From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
To: chris@printf.net, ulf.hansson@linaro.org
Cc: shc_work@mail.ru, s.hauer@pengutronix.de, peter.griffin@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linucppc-dev@lists.ozlabs.org, agust@denx.de, gsi@denx.de,
        sbabic@denx.de, Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
Subject: [PATCH 2/2] mmc: mxcmmc: fix the default value for available voltages into mxcmci_probe
Date: Tue, 30 Sep 2014 16:59:38 +0200
Message-Id: <1412089178-21946-3-git-send-email-matteo.facchinetti@sirius-es.it>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1412089178-21946-1-git-send-email-matteo.facchinetti@sirius-es.it>
References: <1412089178-21946-1-git-send-email-matteo.facchinetti@sirius-es.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>

If available voltages are not given, mmc_regulator_get_supply() function
returns 0 and mxcmmc driver doesn't set a value for ocr_avail mask.

In accordance with the comment in platform_data/mmc-mxcmmc.h,
fix it, assuming MMC_VDD_32_33 | MMC_VDD_33_34 as default value.

Signed-off-by: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
---
 drivers/mmc/host/mxcmmc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 536a898..5350dc5 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1077,13 +1077,13 @@ static int mxcmci_probe(struct platform_device *pdev)
 		dat3_card_detect = true;
 
 	ret = mmc_regulator_get_supply(mmc);
-	if (ret) {
-		if (pdata && ret != -EPROBE_DEFER)
-			mmc->ocr_avail = pdata->ocr_avail ? :
-				MMC_VDD_32_33 | MMC_VDD_33_34;
-		else
-			goto out_free;
-	}
+	if (ret == -EPROBE_DEFER)
+		goto out_free;
+
+	if (pdata && pdata->ocr_avail)
+		mmc->ocr_avail = pdata->ocr_avail;
+	else
+		mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
 	if (dat3_card_detect)
 		host->default_irq_mask =
-- 
1.8.3.2

