Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaFBJKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:10:14 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:58041 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaFBJKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:10:09 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v6 11/12] mmc: mmci: Add Qcom specific rx_fifocnt logic.
Date: Mon,  2 Jun 2014 10:10:04 +0100
Message-Id: <1401700204-11876-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1401699818-11329-1-git-send-email-srinivas.kandagatla@linaro.org>
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

This patch implements a qcom specific get_rx_fifocnt function which is
implemented based on status register flags. Based on qcom_fifo flag in
variant data structure, the corresponding get_rx_fifocnt function is selected.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c | 30 ++++++++++++++++++++++++++++--
 drivers/mmc/host/mmci.h |  1 +
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 08715ab..08ff8d2 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -73,6 +73,7 @@ static unsigned int fmax = 515633;
  * @busy_detect: true if busy detection on dat0 is supported
  * @pwrreg_nopower: bits in MMCIPOWER don't controls ext. power supply
  * @explicit_mclk_control: enable explicit mclk control in driver.
+ * @qcom_fifo: enables qcom specific fifo pio read logic.
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
@@ -990,15 +992,34 @@ mmci_cmd_irq(struct mmci_host *host, struct mmc_command *cmd,
 	}
 }
 
+static int mmci_get_rx_fifocnt(struct mmci_host *host, u32 status, int remain)
+{
+	return remain - (readl(host->base + MMCIFIFOCNT) << 2);
+}
+
+static int mmci_qcom_get_rx_fifocnt(struct mmci_host *host, u32 status, int r)
+{
+	/*
+	 * on qcom SDCC4 only 8 words are used in each burst so only 8 addresses
+	 * from the fifo range should be used
+	 */
+	if (status & MCI_RXFIFOHALFFULL)
+		return host->variant->fifohalfsize;
+	else if (status & MCI_RXDATAAVLBL)
+		return 4;
+
+	return 0;
+}
+
 static int mmci_pio_read(struct mmci_host *host, char *buffer, unsigned int remain)
 {
 	void __iomem *base = host->base;
 	char *ptr = buffer;
-	u32 status;
+	u32 status = readl(host->base + MMCISTATUS);
 	int host_remain = host->size;
 
 	do {
-		int count = host_remain - (readl(base + MMCIFIFOCNT) << 2);
+		int count = host->get_rx_fifocnt(host, status, host_remain);
 
 		if (count > remain)
 			count = remain;
@@ -1488,6 +1509,11 @@ static int mmci_probe(struct amba_device *dev,
 	if (ret)
 		goto host_free;
 
+	if (variant->qcom_fifo)
+		host->get_rx_fifocnt = mmci_qcom_get_rx_fifocnt;
+	else
+		host->get_rx_fifocnt = mmci_get_rx_fifocnt;
+
 	host->plat = plat;
 	host->variant = variant;
 	host->mclk = clk_get_rate(host->clk);
diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index ef34617..a1f5e4f 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -229,6 +229,7 @@ struct mmci_host {
 	/* pio stuff */
 	struct sg_mapping_iter	sg_miter;
 	unsigned int		size;
+	int (*get_rx_fifocnt)(struct mmci_host *h, u32 status, int remain);
 
 #ifdef CONFIG_DMA_ENGINE
 	/* DMA stuff */
-- 
1.9.1

