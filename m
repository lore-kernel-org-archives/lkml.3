Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019AbaD2IV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:21:28 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:56518 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbaD2IVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:21:21 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, agross@quicinc.com,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v1 11/11] mmc: mmci: Add Qcom specific pio_read function.
Date: Tue, 29 Apr 2014 09:21:14 +0100
Message-Id: <1398759674-13421-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
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
not suitable for Qcom SOCs.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index def1b19..45198b6 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1038,6 +1038,29 @@ mmci_cmd_irq(struct mmci_host *host, struct mmc_command *cmd,
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
@@ -1159,8 +1182,12 @@ static irqreturn_t mmci_pio_irq(int irq, void *dev_id)
 		remain = sg_miter->length;
 
 		len = 0;
-		if (status & MCI_RXACTIVE)
-			len = mmci_pio_read(host, buffer, remain);
+		if (status & MCI_RXACTIVE) {
+			if (host->hw_designer == AMBA_VENDOR_QCOM)
+				len = mmci_qcom_pio_read(host, buffer, remain);
+			else
+				len = mmci_pio_read(host, buffer, remain);
+		}
 		if (status & MCI_TXACTIVE)
 			len = mmci_pio_write(host, buffer, remain, status);
 
-- 
1.7.9.5

