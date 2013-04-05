Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3DEESW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:18:22 -0400
Received: from mail-gh0-f179.google.com ([209.85.160.179]:51581 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3DEESV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:18:21 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: cjb@laptop.org, shawn.guo@linaro.org, marex@denx.de,
        fabio.estevam@freescale.com, otavio@ossystems.com.br,
        broonie@opensource.wolfsonmicro.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: [PATCH] mmc: mxs-mmc: Add support for non-removable cards
Date: Fri,  5 Apr 2013 01:18:38 -0300
Message-Id: <1365135518-31549-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some boards and card slots doesn't have card detect feature available.
In that case allow to mark the cards as non-removable, via devicetree.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/mmc/host/mxs-mmc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 4efe302..7d2cd74 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -95,6 +95,9 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
 	struct mxs_mmc_host *host = mmc_priv(mmc);
 	struct mxs_ssp *ssp = &host->ssp;
 
+	if (mmc->caps & MMC_CAP_NONREMOVABLE)
+		return 1;
+
 	return !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
 		 BM_SSP_STATUS_CARD_DETECT);
 }
@@ -691,6 +694,9 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 	if (flags & OF_GPIO_ACTIVE_LOW)
 		host->wp_inverted = 1;
 
+	if (of_find_property(np, "non-removable", NULL))
+		mmc->caps |= MMC_CAP_NONREMOVABLE;
+
 	mmc->f_min = 400000;
 	mmc->f_max = 288000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-- 
1.7.10

