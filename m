Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaEOJiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:38:13 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:64069 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbaEOJiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:38:09 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2 14/14] mmc: mmci: Add Qcom specific pio_read function.
Date: Thu, 15 May 2014 10:38:04 +0100
Message-Id: <1400146684-30384-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1400146447-29803-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

MCIFIFOCNT register behaviour on Qcom chips is very different than the other
pl180 integrations. MCIFIFOCNT register contains the number of
words that are still waiting to be transferred through the FIFO. It keeps
decrementing once the host CPU reads the MCIFIFO. With the existing logic and
the MCIFIFOCNT behaviour, mmci_pio_read will loop forever, as the FIFOCNT
register will always return transfer size before reading the FIFO.

Also the data sheet states that "This register is only useful for debug
purposes and should not be used for normal operation since it does not reflect
data which may or may not be in the pipeline".

This patch implements qcom_pio_read function so as existing mmci_pio_read is
not suitable for Qcom SOCs. qcom_pio_read function is only selected
based on qcom_fifo flag in variant data structure.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index cf58fec1..94b99d6 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -77,6 +77,7 @@ static unsigned int fmax = 515633;
  *			 are not ignored.
  * @explicit_mclk_control: enable explicit mclk control in driver.
  * @qcom_cclk_is_mclk: enable iff card clock is multimedia card adapter clock.
+ * @qcom_fifo: enables qcom specific fifo pio read function.
  */
 struct variant_data {
 	unsigned int		clkreg;
@@ -101,6 +102,7 @@ struct variant_data {
 	bool			mclk_delayed_writes;
 	bool			explicit_mclk_control;
 	bool			qcom_cclk_is_mclk;
+	bool			qcom_fifo;
 };
 
 static struct variant_data variant_arm = {
@@ -211,6 +213,7 @@ static struct variant_data variant_qcom = {
 	.mclk_delayed_writes	= true,
 	.explicit_mclk_control	= true,
 	.qcom_cclk_is_mclk	= true,
+	.qcom_fifo		= true,
 };
 
 static inline u32 mmci_readl(struct mmci_host *host, u32 off)
@@ -1026,6 +1029,29 @@ mmci_cmd_irq(struct mmci_host *host, struct mmc_command *cmd,
 	}
 }
 
+static int mmci_qcom_pio_read(struct mmci_host *host, char *buffer,
+			 unsigned int remain)
+{
+	uint32_t	*ptr = (uint32_t *) buffer;
+	int		count = 0;
+	struct variant_data *variant = host->variant;
+	int		fifo_size = variant->fifosize;
+
+	if (remain % 4)
+		remain = ((remain >> 2) + 1) << 2;
+
+	while (readl(host->base + MMCISTATUS) & MCI_RXDATAAVLBL) {
+		*ptr = readl(host->base + MMCIFIFO + (count % fifo_size));
+		ptr++;
+		count += sizeof(uint32_t);
+
+		remain -=  sizeof(uint32_t);
+		if (remain == 0)
+			break;
+	}
+	return count;
+}
+
 static int mmci_pio_read(struct mmci_host *host, char *buffer, unsigned int remain)
 {
 	void __iomem *base = host->base;
@@ -1147,8 +1173,13 @@ static irqreturn_t mmci_pio_irq(int irq, void *dev_id)
 		remain = sg_miter->length;
 
 		len = 0;
-		if (status & MCI_RXACTIVE)
-			len = mmci_pio_read(host, buffer, remain);
+		if (status & MCI_RXACTIVE) {
+			if (variant->qcom_fifo)
+				len = mmci_qcom_pio_read(host, buffer, remain);
+			else
+				len = mmci_pio_read(host, buffer, remain);
+		}
+
 		if (status & MCI_TXACTIVE)
 			len = mmci_pio_write(host, buffer, remain, status);
 
-- 
1.9.1

