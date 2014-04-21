Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaDUVsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:48:38 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33033 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbaDUVsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:48:25 -0400
From: srinivas.kandagatla@linaro.org
To: linux-mmc@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-kernel@vger.kernel.org,
        agross@quicinc.com, linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH RFC 06/12] mmc: mmci: Add write delay to variant structure.
Date: Mon, 21 Apr 2014 22:48:18 +0100
Message-Id: <1398116898-31478-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds write delay parameter required after each write to controller
registers on some of the SOCs like Qualcomm ones. The delay parameter will
provide information on how many clock cycle delay required after each write.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 4f8d0ba..86bf330 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -55,6 +55,8 @@ static unsigned int fmax = 515633;
  *	      is asserted (likewise for RX)
  * @fifohalfsize: number of bytes that can be written when MCI_TXFIFOHALFEMPTY
  *		  is asserted (likewise for RX)
+ * @reg_write_delay: delay in number of clock cycles required after each write
+ *		     to controller registers.
  * @sdio: variant supports SDIO
  * @st_clkdiv: true if using a ST-specific clock divider algorithm
  * @blksz_datactrl16: true if Block size is at b16..b30 position in datactrl register
@@ -72,6 +74,7 @@ struct variant_data {
 	unsigned int		datalength_bits;
 	unsigned int		fifosize;
 	unsigned int		fifohalfsize;
+	unsigned int		reg_write_delay;
 	bool			sdio;
 	bool			st_clkdiv;
 	bool			blksz_datactrl16;
@@ -178,7 +181,12 @@ static inline u32 mmci_readl(struct mmci_host *host, u32 off)
 
 static inline void mmci_writel(struct mmci_host *host, u32 data, u32 off)
 {
+	struct variant_data *var = host->variant;
+
 	writel(data, host->base + off);
+
+	if (var->reg_write_delay && host->mclk)
+		udelay(1 + ((var->reg_write_delay * USEC_PER_SEC)/host->mclk));
 }
 
 static int mmci_card_busy(struct mmc_host *mmc)
-- 
1.7.9.5

