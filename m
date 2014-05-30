Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384AbaE3RNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:13:47 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48388 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934343AbaE3RNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:13:45 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v5 06/13] mmc: mmci: add ddrmode mask to variant data
Date: Fri, 30 May 2014 18:13:39 +0100
Message-Id: <1401470019-27072-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401469918-26817-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401469918-26817-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds ddrmode mask to variant structure giving more flexibility
to the driver to support more SOCs which have different datactrl register
layout.

Without this patch datactrl register is updated with incorrect ddrmode mask,
resulting in failures on Qualcomm SD Card Controller.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/host/mmci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 72981f6..ad7e538 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -59,6 +59,7 @@ static unsigned int fmax = 515633;
  *		  is asserted (likewise for RX)
  * @sdio: variant supports SDIO
  * @st_clkdiv: true if using a ST-specific clock divider algorithm
+ * @datactrl_mask_ddrmode: ddr mode mask in datactrl register.
  * @blksz_datactrl16: true if Block size is at b16..b30 position in datactrl register
  * @blksz_datactrl4: true if Block size is at b4..b16 position in datactrl
  *		     register
@@ -74,6 +75,7 @@ struct variant_data {
 	unsigned int		datalength_bits;
 	unsigned int		fifosize;
 	unsigned int		fifohalfsize;
+	unsigned int		datactrl_mask_ddrmode;
 	bool			sdio;
 	bool			st_clkdiv;
 	bool			blksz_datactrl16;
@@ -152,6 +154,7 @@ static struct variant_data variant_ux500v2 = {
 	.fifohalfsize		= 8 * 4,
 	.clkreg			= MCI_CLK_ENABLE,
 	.clkreg_enable		= MCI_ST_UX500_HWFCEN,
+	.datactrl_mask_ddrmode	= MCI_ST_DPSM_DDRMODE,
 	.datalength_bits	= 24,
 	.sdio			= true,
 	.st_clkdiv		= true,
@@ -770,7 +773,7 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 		}
 
 	if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50)
-		datactrl |= MCI_ST_DPSM_DDRMODE;
+		datactrl |= variant->datactrl_mask_ddrmode;
 
 	/*
 	 * Attempt to use DMA operation mode, if this
-- 
1.9.1

