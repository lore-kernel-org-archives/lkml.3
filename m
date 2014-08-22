Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaHVEzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 00:55:14 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58762 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbaHVEzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 00:55:11 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 2/3] mmc: mmci: Add sdio enable mask in variant data
Date: Fri, 22 Aug 2014 05:54:55 +0100
Message-Id: <1408683295-8030-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408683219-7939-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1408683219-7939-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds sdio enable mask in variant data, SOCs like ST have
special bits in datactrl register to enable sdio. Unconditionally setting
this bit in this driver breaks other SOCs like Qualcomm which maps this
bits to something else, so making this enable bit to come from variant
data solves the issue.

Originally the issue is detected while testing WLAN ath6kl on Qualcomm
APQ8064.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 533ad2b..a25759e 100644
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
@@ -89,6 +90,7 @@ struct variant_data {
 	unsigned int		fifohalfsize;
 	unsigned int		data_cmd_enable;
 	unsigned int		datactrl_mask_ddrmode;
+	unsigned int		datactrl_mask_sdio;
 	bool			sdio;
 	bool			st_clkdiv;
 	bool			blksz_datactrl16;
@@ -138,6 +140,7 @@ static struct variant_data variant_u300 = {
 	.clkreg_enable		= MCI_ST_U300_HWFCEN,
 	.clkreg_8bit_bus_enable = MCI_ST_8BIT_BUS,
 	.datalength_bits	= 16,
+	.datactrl_mask_sdio	= MCI_ST_DPSM_SDIOEN,
 	.sdio			= true,
 	.pwrreg_powerup		= MCI_PWR_ON,
 	.f_max			= 100000000,
@@ -151,6 +154,7 @@ static struct variant_data variant_nomadik = {
 	.fifohalfsize		= 8 * 4,
 	.clkreg			= MCI_CLK_ENABLE,
 	.datalength_bits	= 24,
+	.datactrl_mask_sdio	= MCI_ST_DPSM_SDIOEN,
 	.sdio			= true,
 	.st_clkdiv		= true,
 	.pwrreg_powerup		= MCI_PWR_ON,
@@ -168,6 +172,7 @@ static struct variant_data variant_ux500 = {
 	.clkreg_8bit_bus_enable = MCI_ST_8BIT_BUS,
 	.clkreg_neg_edge_enable	= MCI_ST_UX500_NEG_EDGE,
 	.datalength_bits	= 24,
+	.datactrl_mask_sdio	= MCI_ST_DPSM_SDIOEN,
 	.sdio			= true,
 	.st_clkdiv		= true,
 	.pwrreg_powerup		= MCI_PWR_ON,
@@ -187,6 +192,7 @@ static struct variant_data variant_ux500v2 = {
 	.clkreg_neg_edge_enable	= MCI_ST_UX500_NEG_EDGE,
 	.datactrl_mask_ddrmode	= MCI_ST_DPSM_DDRMODE,
 	.datalength_bits	= 24,
+	.datactrl_mask_sdio	= MCI_ST_DPSM_SDIOEN,
 	.sdio			= true,
 	.st_clkdiv		= true,
 	.blksz_datactrl16	= true,
@@ -812,16 +818,10 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
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

