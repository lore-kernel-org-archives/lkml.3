Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaE1NsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:48:17 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60027 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbaE1NsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:48:14 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v4 13/13] mmc: mmci: Add Qcom specific pio_read function.
Date: Wed, 28 May 2014 14:48:06 +0100
Message-Id: <1401284886-16978-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>
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
 drivers/mmc/host/mmci.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/mmc/host/mmci.h |  1 +
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 6eb0a29..b68223a 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -73,6 +73,7 @@ static unsigned int fmax = 515633;
  * @busy_detect: true if busy detection on dat0 is supported
  * @pwrreg_nopower: bits in MMCIPOWER don't controls ext. power supply
  * @explicit_mclk_control: enable explicit mclk control in driver.
+ * @qcom_fifo: enables qcom specific fifo pio read function.
  */
 struct variant_data {
 	unsigned int		clkreg;
@@ -95,6 +96,7 @@ struct variant_data {
 	bool			busy_detect;
 	bool			pwrreg_nopower;
 	bool			explicit_mclk_control;
+	bool			qcom_fifo;
 };
 
 static struct variant_data variant_arm = {
@@ -202,6 +204,7 @@ static struct variant_data variant_qcom = {
 	.pwrreg_powerup		= MCI_PWR_UP,
 	.f_max			= 208000000,
 	.explicit_mclk_control	= true,
+	.qcom_fifo		= true,
 };
 
 static int mmci_card_busy(struct mmc_host *mmc)
@@ -1006,6 +1009,40 @@ mmci_cmd_irq(struct mmci_host *host, struct mmc_command *cmd,
 	}
 }
 
+static int mmci_qcom_pio_read(struct mmci_host *host, char *buffer,
+			unsigned int remain)
+{
+	u32 *ptr = (u32 *) buffer;
+	unsigned int count = 0;
+	unsigned int words, bytes;
+	unsigned int fsize = host->variant->fifosize;
+
+	words = remain >> 2;
+	bytes = remain % 4;
+	/* read full words followed by leftover bytes */
+	if (words) {
+		while (readl(host->base + MMCISTATUS) & MCI_RXDATAAVLBL) {
+			*ptr = readl(host->base + MMCIFIFO + (count % fsize));
+			ptr++;
+			count += 4;
+			words--;
+			if (!words)
+				break;
+		}
+	}
+
+	if (bytes) {
+		unsigned char buf[4];
+		if (readl(host->base + MMCISTATUS) & MCI_RXDATAAVLBL) {
+			*buf = readl(host->base + MMCIFIFO + (count % fsize));
+			memcpy(ptr, buf, bytes);
+			count += bytes;
+		}
+	}
+
+	return count;
+}
+
 static int mmci_pio_read(struct mmci_host *host, char *buffer, unsigned int remain)
 {
 	void __iomem *base = host->base;
@@ -1129,7 +1166,8 @@ static irqreturn_t mmci_pio_irq(int irq, void *dev_id)
 
 		len = 0;
 		if (status & MCI_RXACTIVE)
-			len = mmci_pio_read(host, buffer, remain);
+			len = host->pio_read(host, buffer, remain);
+
 		if (status & MCI_TXACTIVE)
 			len = mmci_pio_write(host, buffer, remain, status);
 
@@ -1504,6 +1542,11 @@ static int mmci_probe(struct amba_device *dev,
 	if (ret)
 		goto host_free;
 
+	if (variant->qcom_fifo)
+		host->pio_read = mmci_qcom_pio_read;
+	else
+		host->pio_read = mmci_pio_read;
+
 	host->plat = plat;
 	host->variant = variant;
 	host->mclk = clk_get_rate(host->clk);
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index 1882e20..dc9fe0a 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -229,6 +229,7 @@ struct mmci_host {
 	/* pio stuff */
 	struct sg_mapping_iter	sg_miter;
 	unsigned int		size;
+	int (*pio_read)(struct mmci_host *h, char *buf, unsigned int remain);
 
 #ifdef CONFIG_DMA_ENGINE
 	/* DMA stuff */
-- 
1.9.1

