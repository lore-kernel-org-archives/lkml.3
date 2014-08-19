Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaHSLQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:16:02 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62854 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbaHSLP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:15:57 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: linux-mmc@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 4/4] mmc: mmci: rename sdio flag in vendor data to st_sdio
Date: Tue, 19 Aug 2014 12:15:24 +0100
Message-Id: <1408446924-1742-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408446785-1399-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1408446785-1399-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames sdio flag in vendor data to st_sdio, as this flag is
only used to enable ST specific sdio setup. This will also ensure that
the ST specfic setup is not done on other vendor like Qualcomm.

Originally the issue was detected while testing WLAN ath6kl on IFC6410
board with APQ8064 SOC.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index fc08203..26aa443 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -61,7 +61,7 @@ static unsigned int fmax = 515633;
  * @fifohalfsize: number of bytes that can be written when MCI_TXFIFOHALFEMPTY
  *		  is asserted (likewise for RX)
  * @data_cmd_enable: enable value for data commands.
- * @sdio: variant supports SDIO
+ * @st_sdio: enable ST specific SDIO logic
  * @st_clkdiv: true if using a ST-specific clock divider algorithm
  * @datactrl_mask_ddrmode: ddr mode mask in datactrl register.
  * @blksz_datactrl16: true if Block size is at b16..b30 position in datactrl register
@@ -91,7 +91,7 @@ struct variant_data {
 	unsigned int		data_cmd_enable;
 	unsigned int		datactrl_mask_ddrmode;
 	unsigned int		datactrl_mask_sdio;
-	bool			sdio;
+	bool			st_sdio;
 	bool			st_clkdiv;
 	bool			blksz_datactrl16;
 	bool			blksz_datactrl4;
@@ -141,7 +141,7 @@ static struct variant_data variant_u300 = {
 	.clkreg_8bit_bus_enable = MCI_ST_8BIT_BUS,
 	.datalength_bits	= 16,
 	.datactrl_mask_sdio	= MCI_ST_DPSM_SDIOEN,
-	.sdio			= true,
+	.st_sdio			= true,
 	.pwrreg_powerup		= MCI_PWR_ON,
 	.f_max			= 100000000,
 	.signal_direction	= true,
@@ -155,7 +155,7 @@ static struct variant_data variant_nomadik = {
 	.clkreg			= MCI_CLK_ENABLE,
 	.datalength_bits	= 24,
 	.datactrl_mask_sdio	= MCI_ST_DPSM_SDIOEN,
-	.sdio			= true,
+	.st_sdio		= true,
 	.st_clkdiv		= true,
 	.pwrreg_powerup		= MCI_PWR_ON,
 	.f_max			= 100000000,
@@ -173,7 +173,7 @@ static struct variant_data variant_ux500 = {
 	.clkreg_neg_edge_enable	= MCI_ST_UX500_NEG_EDGE,
 	.datalength_bits	= 24,
 	.datactrl_mask_sdio	= MCI_ST_DPSM_SDIOEN,
-	.sdio			= true,
+	.st_sdio		= true,
 	.st_clkdiv		= true,
 	.pwrreg_powerup		= MCI_PWR_ON,
 	.f_max			= 100000000,
@@ -193,7 +193,7 @@ static struct variant_data variant_ux500v2 = {
 	.datactrl_mask_ddrmode	= MCI_ST_DPSM_DDRMODE,
 	.datalength_bits	= 24,
 	.datactrl_mask_sdio	= MCI_ST_DPSM_SDIOEN,
-	.sdio			= true,
+	.st_sdio		= true,
 	.st_clkdiv		= true,
 	.blksz_datactrl16	= true,
 	.pwrreg_powerup		= MCI_PWR_ON,
@@ -820,26 +820,26 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 	if (data->flags & MMC_DATA_READ)
 		datactrl |= MCI_DPSM_DIRECTION;
 
-	if (variant->sdio && host->mmc->card)
-		if (mmc_card_sdio(host->mmc->card)) {
-			u32 clk;
-			datactrl |= variant->datactrl_mask_sdio;
+	if (host->mmc->card && mmc_card_sdio(host->mmc->card)) {
+		u32 clk;
 
-			/*
-			 * The ST Micro variant for SDIO small write transfers
-			 * needs to have clock H/W flow control disabled,
-			 * otherwise the transfer will not start. The threshold
-			 * depends on the rate of MCLK.
-			 */
-			if (data->flags & MMC_DATA_WRITE &&
-			    (host->size < 8 ||
-			     (host->size <= 8 && host->mclk > 50000000)))
-				clk = host->clk_reg & ~variant->clkreg_enable;
-			else
-				clk = host->clk_reg | variant->clkreg_enable;
+		datactrl |= variant->datactrl_mask_sdio;
 
-			mmci_write_clkreg(host, clk);
-		}
+		/*
+		 * The ST Micro variant for SDIO small write transfers
+		 * needs to have clock H/W flow control disabled,
+		 * otherwise the transfer will not start. The threshold
+		 * depends on the rate of MCLK.
+		 */
+		if (variant->st_sdio && data->flags & MMC_DATA_WRITE &&
+		    (host->size < 8 ||
+		     (host->size <= 8 && host->mclk > 50000000)))
+			clk = host->clk_reg & ~variant->clkreg_enable;
+		else
+			clk = host->clk_reg | variant->clkreg_enable;
+
+		mmci_write_clkreg(host, clk);
+	}
 
 	if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50 ||
 	    host->mmc->ios.timing == MMC_TIMING_MMC_DDR52)
-- 
1.9.1

