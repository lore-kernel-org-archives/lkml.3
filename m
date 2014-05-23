Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaEWMw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:52:59 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34702 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaEWMwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:52:53 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v3 11/13] mmc: mmci: Add support to data commands via variant structure.
Date: Fri, 23 May 2014 13:52:48 +0100
Message-Id: <1400849568-7543-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

On some SOCs like Qcom there are explicit bits in the command register
to specify if its a data transfer command or not. So this patch adds
support to such bits in variant data, giving more flexibility to the
driver.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/host/mmci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 6434f5b1..5cbf644 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -59,6 +59,7 @@ static unsigned int fmax = 515633;
  *	      is asserted (likewise for RX)
  * @fifohalfsize: number of bytes that can be written when MCI_TXFIFOHALFEMPTY
  *		  is asserted (likewise for RX)
+ * @data_cmd_enable: enable value for data commands.
  * @sdio: variant supports SDIO
  * @st_clkdiv: true if using a ST-specific clock divider algorithm
  * @datactrl_mask_ddrmode: ddr mode mask in datactrl register.
@@ -81,6 +82,7 @@ struct variant_data {
 	unsigned int		datalength_bits;
 	unsigned int		fifosize;
 	unsigned int		fifohalfsize;
+	unsigned int		data_cmd_enable;
 	unsigned int		datactrl_mask_ddrmode;
 	bool			sdio;
 	bool			st_clkdiv;
@@ -189,6 +191,7 @@ static struct variant_data variant_qcom = {
 				  MCI_QCOM_CLK_FEEDBACK_CLK,
 	.clkreg_8bit_bus_enable = MCI_QCOM_CLK_WIDEBUS_8,
 	.datactrl_mask_ddrmode	= MCI_QCOM_CLK_DDR_MODE,
+	.data_cmd_enable	= MCI_QCOM_CSPM_DATCMD,
 	.blksz_datactrl4	= true,
 	.datalength_bits	= 24,
 	.blksz_datactrl4	= true,
@@ -875,6 +878,9 @@ mmci_start_command(struct mmci_host *host, struct mmc_command *cmd, u32 c)
 	if (/*interrupt*/0)
 		c |= MCI_CPSM_INTERRUPT;
 
+	if (mmc_cmd_type(cmd) == MMC_CMD_ADTC)
+		c |= host->variant->data_cmd_enable;
+
 	host->cmd = cmd;
 
 	mmci_writel(host, cmd->arg, MMCIARGUMENT);
-- 
1.9.1

