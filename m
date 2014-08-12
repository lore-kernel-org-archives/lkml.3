Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaHLMFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:05:17 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39113 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaHLMFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:05:14 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
X-Google-Original-From: Srinivas Kandagatla <srinivas.kandadgatla@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH RFC 4/5] mmc: mmci: Add sdio enable mask in variant data
Date: Tue, 12 Aug 2014 13:05:02 +0100
Message-Id: <1407845102-8402-1-git-send-email-srinivas.kandadgatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
References: <1407844950-8072-1-git-send-email-srinivas.kandadgatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds sdio enable mask in variant data, SOCs like ST have
special bits in datactrl register to enable sdio. Unconditionally setting
this bit in this driver breaks other SOCs like Qualcomm which maps this
bits to something else, so making this enable bit to come from variant
data solves the issue.

Originally the issue is detected while testing WLAN ath6kl on Qualcomm
APQ8064.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 747aba0..848e2bb 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -67,6 +67,7 @@ static unsigned int fmax = 515633;
  * @blksz_datactrl16: true if Block size is at b16..b30 position in datactrl register
  * @blksz_datactrl4: true if Block size is at b4..b16 position in datactrl
  *		     register
+ * @datactrl_mask_sdio: SDIO enable mask in datactrl register
  * @pwrreg_powerup: power up value for MMCIPOWER register
  * @f_max: maximum clk frequency supported by the controller.
  * @signal_direction: input/out direction of bus signals can be indicated
@@ -87,6 +88,7 @@ struct variant_data {
 	unsigned int		fifohalfsize;
 	unsigned int		data_cmd_enable;
 	unsigned int		datactrl_mask_ddrmode;
+	unsigned int		datactrl_mask_sdio;
 	bool			sdio;
 	bool			st_clkdiv;
 	bool			blksz_datactrl16;
@@ -133,6 +135,7 @@ static struct variant_data variant_u300 = {
 	.clkreg_enable		= MCI_ST_U300_HWFCEN,
 	.clkreg_8bit_bus_enable = MCI_ST_8BIT_BUS,
 	.datalength_bits	= 16,
+	.datactrl_mask_sdio	= MCI_ST_DPSM_SDIOEN,
 	.sdio			= true,
 	.pwrreg_powerup		= MCI_PWR_ON,
 	.f_max			= 100000000,
@@ -146,6 +149,7 @@ static struct variant_data variant_nomadik = {
 	.fifohalfsize		= 8 * 4,
 	.clkreg			= MCI_CLK_ENABLE,
 	.datalength_bits	= 24,
+	.datactrl_mask_sdio	= MCI_ST_DPSM_SDIOEN,
 	.sdio			= true,
 	.st_clkdiv		= true,
 	.pwrreg_powerup		= MCI_PWR_ON,
@@ -163,6 +167,7 @@ static struct variant_data variant_ux500 = {
 	.clkreg_8bit_bus_enable = MCI_ST_8BIT_BUS,
 	.clkreg_neg_edge_enable	= MCI_ST_UX500_NEG_EDGE,
 	.datalength_bits	= 24,
+	.datactrl_mask_sdio	= MCI_ST_DPSM_SDIOEN,
 	.sdio			= true,
 	.st_clkdiv		= true,
 	.pwrreg_powerup		= MCI_PWR_ON,
@@ -182,6 +187,7 @@ static struct variant_data variant_ux500v2 = {
 	.clkreg_neg_edge_enable	= MCI_ST_UX500_NEG_EDGE,
 	.datactrl_mask_ddrmode	= MCI_ST_DPSM_DDRMODE,
 	.datalength_bits	= 24,
+	.datactrl_mask_sdio	= MCI_ST_DPSM_SDIOEN,
 	.sdio			= true,
 	.st_clkdiv		= true,
 	.blksz_datactrl16	= true,
@@ -811,16 +817,10 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 	if (data->flags & MMC_DATA_READ)
 		datactrl |= MCI_DPSM_DIRECTION;
 
-	/* The ST Micro variants has a special bit to enable SDIO */
 	if (variant->sdio && host->mmc->card)
 		if (mmc_card_sdio(host->mmc->card)) {
-			/*
-			 * The ST Micro variants has a special bit
-			 * to enable SDIO.
-			 */
 			u32 clk;
-
-			datactrl |= MCI_ST_DPSM_SDIOEN;
+			datactrl |= variant->datactrl_mask_sdio;
 
 			/*
 			 * The ST Micro variant for SDIO small write transfers
-- 
1.9.1

