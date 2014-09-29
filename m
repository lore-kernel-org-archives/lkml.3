Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaI2NWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:22:07 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:59825 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403AbaI2NWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:22:06 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        linux-mmc@vger.kernel.org
Subject: [PATCH] mmc: sdhci-pxav3: Fix Sparse warning of duplicate set_uhs_signaling entry
Date: Mon, 29 Sep 2014 18:55:37 +0530
Message-Id: <1411997137-13034-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below sparse warning:
drivers/mmc/host/sdhci-pxav3.c:227:10: warning: Initializer entry defined twice
drivers/mmc/host/sdhci-pxav3.c:232:10:   also defined here

by removing duplicate initialization of .set_uhs_signaling in
struct sdhci_ops. Also does away with duplcated function.

Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>
Cc: linux-mmc@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/mmc/host/sdhci-pxav3.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 6f842fb..fd93e60 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -186,45 +186,8 @@ static void pxav3_gen_init_74_clocks(struct sdhci_host *host, u8 power_mode)
 	pxa->power_mode = power_mode;
 }
 
-static void pxav3_set_uhs_signaling(struct sdhci_host *host, unsigned int uhs)
-{
-	u16 ctrl_2;
-
-	/*
-	 * Set V18_EN -- UHS modes do not work without this.
-	 * does not change signaling voltage
-	 */
-	ctrl_2 = sdhci_readw(host, SDHCI_HOST_CONTROL2);
-
-	/* Select Bus Speed Mode for host */
-	ctrl_2 &= ~SDHCI_CTRL_UHS_MASK;
-	switch (uhs) {
-	case MMC_TIMING_UHS_SDR12:
-		ctrl_2 |= SDHCI_CTRL_UHS_SDR12;
-		break;
-	case MMC_TIMING_UHS_SDR25:
-		ctrl_2 |= SDHCI_CTRL_UHS_SDR25;
-		break;
-	case MMC_TIMING_UHS_SDR50:
-		ctrl_2 |= SDHCI_CTRL_UHS_SDR50 | SDHCI_CTRL_VDD_180;
-		break;
-	case MMC_TIMING_UHS_SDR104:
-		ctrl_2 |= SDHCI_CTRL_UHS_SDR104 | SDHCI_CTRL_VDD_180;
-		break;
-	case MMC_TIMING_UHS_DDR50:
-		ctrl_2 |= SDHCI_CTRL_UHS_DDR50 | SDHCI_CTRL_VDD_180;
-		break;
-	}
-
-	sdhci_writew(host, ctrl_2, SDHCI_HOST_CONTROL2);
-	dev_dbg(mmc_dev(host->mmc),
-		"%s uhs = %d, ctrl_2 = %04X\n",
-		__func__, uhs, ctrl_2);
-}
-
 static const struct sdhci_ops pxav3_sdhci_ops = {
 	.set_clock = sdhci_set_clock,
-	.set_uhs_signaling = pxav3_set_uhs_signaling,
 	.platform_send_init_74_clocks = pxav3_gen_init_74_clocks,
 	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
 	.set_bus_width = sdhci_set_bus_width,
-- 
1.7.9.5

