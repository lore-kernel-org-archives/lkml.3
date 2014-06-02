Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaFBJJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:09:40 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:65110 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbaFBJJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:09:35 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v6 07/12] mmc: mmci: add edge support to data and command out in variant data.
Date: Mon,  2 Jun 2014 10:09:30 +0100
Message-Id: <1401700170-11711-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds edge support for data and command out to variant structure
giving more flexibility to the driver to support more SOCs which have
different clock register layout.

Without this patch other new SOCs like Qcom will have to add more code to
special case them

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mmc/host/mmci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index fa3ad83..4c95a9b 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -53,6 +53,7 @@ static unsigned int fmax = 515633;
  * @clkreg: default value for MCICLOCK register
  * @clkreg_enable: enable value for MMCICLOCK register
  * @clkreg_8bit_bus_enable: enable value for 8 bit bus
+ * @clkreg_neg_edge_enable: enable value for inverted data/cmd output
  * @datalength_bits: number of bits in the MMCIDATALENGTH register
  * @fifosize: number of bytes that can be written when MMCI_TXFIFOEMPTY
  *	      is asserted (likewise for RX)
@@ -74,6 +75,7 @@ struct variant_data {
 	unsigned int		clkreg;
 	unsigned int		clkreg_enable;
 	unsigned int		clkreg_8bit_bus_enable;
+	unsigned int		clkreg_neg_edge_enable;
 	unsigned int		datalength_bits;
 	unsigned int		fifosize;
 	unsigned int		fifohalfsize;
@@ -143,6 +145,7 @@ static struct variant_data variant_ux500 = {
 	.clkreg			= MCI_CLK_ENABLE,
 	.clkreg_enable		= MCI_ST_UX500_HWFCEN,
 	.clkreg_8bit_bus_enable = MCI_ST_8BIT_BUS,
+	.clkreg_neg_edge_enable	= MCI_ST_UX500_NEG_EDGE,
 	.datalength_bits	= 24,
 	.sdio			= true,
 	.st_clkdiv		= true,
@@ -159,6 +162,7 @@ static struct variant_data variant_ux500v2 = {
 	.clkreg			= MCI_CLK_ENABLE,
 	.clkreg_enable		= MCI_ST_UX500_HWFCEN,
 	.clkreg_8bit_bus_enable = MCI_ST_8BIT_BUS,
+	.clkreg_neg_edge_enable	= MCI_ST_UX500_NEG_EDGE,
 	.datactrl_mask_ddrmode	= MCI_ST_DPSM_DDRMODE,
 	.datalength_bits	= 24,
 	.sdio			= true,
@@ -313,7 +317,7 @@ static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
 		clk |= variant->clkreg_8bit_bus_enable;
 
 	if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50)
-		clk |= MCI_ST_UX500_NEG_EDGE;
+		clk |= variant->clkreg_neg_edge_enable;
 
 	mmci_write_clkreg(host, clk);
 }
-- 
1.9.1

