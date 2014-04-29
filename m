Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaD2IT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:19:59 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:50456 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaD2ITy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:19:54 -0400
From: srinivas.kandagatla@linaro.org
To: Russell King <linux@arm.linux.org.uk>, linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, agross@quicinc.com,
        linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v1 04/11] mmc: mmci: Add register read/write wrappers.
Date: Tue, 29 Apr 2014 09:19:45 +0100
Message-Id: <1398759585-13134-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds wrappers for readl/writel functions used in the driver. The
reason for this wrappers is to accommodate SOCs like Qualcomm which has
requirement for delaying the write for few cycles when writing to its SD Card
Controller registers.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/mmc/host/mmci.c |  114 +++++++++++++++++++++++++----------------------
 1 file changed, 61 insertions(+), 53 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 19d6b6f..36db31e 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -171,6 +171,16 @@ static struct variant_data variant_qcom = {
 	.pwrreg_powerup		= MCI_PWR_UP,
 };
 
+static inline u32 mmci_readl(struct mmci_host *host, u32 off)
+{
+	return readl(host->base  + off);
+}
+
+static inline void mmci_writel(struct mmci_host *host, u32 data, u32 off)
+{
+	writel(data, host->base + off);
+}
+
 static int mmci_card_busy(struct mmc_host *mmc)
 {
 	struct mmci_host *host = mmc_priv(mmc);
@@ -180,7 +190,7 @@ static int mmci_card_busy(struct mmc_host *mmc)
 	pm_runtime_get_sync(mmc_dev(mmc));
 
 	spin_lock_irqsave(&host->lock, flags);
-	if (readl(host->base + MMCISTATUS) & MCI_ST_CARDBUSY)
+	if (mmci_readl(host, MMCISTATUS) & MCI_ST_CARDBUSY)
 		busy = 1;
 	spin_unlock_irqrestore(&host->lock, flags);
 
@@ -230,7 +240,7 @@ static void mmci_write_clkreg(struct mmci_host *host, u32 clk)
 {
 	if (host->clk_reg != clk) {
 		host->clk_reg = clk;
-		writel(clk, host->base + MMCICLOCK);
+		mmci_writel(host, clk, MMCICLOCK);
 	}
 }
 
@@ -241,7 +251,7 @@ static void mmci_write_pwrreg(struct mmci_host *host, u32 pwr)
 {
 	if (host->pwr_reg != pwr) {
 		host->pwr_reg = pwr;
-		writel(pwr, host->base + MMCIPOWER);
+		mmci_writel(host, pwr, MMCIPOWER);
 	}
 }
 
@@ -255,7 +265,7 @@ static void mmci_write_datactrlreg(struct mmci_host *host, u32 datactrl)
 
 	if (host->datactrl_reg != datactrl) {
 		host->datactrl_reg = datactrl;
-		writel(datactrl, host->base + MMCIDATACTRL);
+		mmci_writel(host, datactrl, MMCIDATACTRL);
 	}
 }
 
@@ -321,7 +331,7 @@ static void mmci_set_clkreg(struct mmci_host *host, unsigned int desired)
 static void
 mmci_request_end(struct mmci_host *host, struct mmc_request *mrq)
 {
-	writel(0, host->base + MMCICOMMAND);
+	mmci_writel(host, 0, MMCICOMMAND);
 
 	BUG_ON(host->data);
 
@@ -336,18 +346,16 @@ mmci_request_end(struct mmci_host *host, struct mmc_request *mrq)
 
 static void mmci_set_mask1(struct mmci_host *host, unsigned int mask)
 {
-	void __iomem *base = host->base;
-
 	if (host->singleirq) {
-		unsigned int mask0 = readl(base + MMCIMASK0);
+		unsigned int mask0 = mmci_readl(host, MMCIMASK0);
 
 		mask0 &= ~MCI_IRQ1MASK;
 		mask0 |= mask;
 
-		writel(mask0, base + MMCIMASK0);
+		mmci_writel(host, mask0, MMCIMASK0);
 	}
 
-	writel(mask, base + MMCIMASK1);
+	mmci_writel(host, mask, MMCIMASK1);
 }
 
 static void mmci_stop_data(struct mmci_host *host)
@@ -498,7 +506,7 @@ static void mmci_dma_finalize(struct mmci_host *host, struct mmc_data *data)
 
 	/* Wait up to 1ms for the DMA to complete */
 	for (i = 0; ; i++) {
-		status = readl(host->base + MMCISTATUS);
+		status = mmci_readl(host, MMCISTATUS);
 		if (!(status & MCI_RXDATAAVLBLMASK) || i >= 100)
 			break;
 		udelay(10);
@@ -637,8 +645,8 @@ static int mmci_dma_start_data(struct mmci_host *host, unsigned int datactrl)
 	 * to fire next DMA request. When that happens, MMCI will
 	 * call mmci_data_end()
 	 */
-	writel(readl(host->base + MMCIMASK0) | MCI_DATAENDMASK,
-	       host->base + MMCIMASK0);
+	mmci_writel(host, mmci_readl(host, MMCIMASK0) | MCI_DATAENDMASK,
+		    MMCIMASK0);
 	return 0;
 }
 
@@ -756,8 +764,8 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 	timeout = data->timeout_clks + (unsigned int)clks;
 
 	base = host->base;
-	writel(timeout, base + MMCIDATATIMER);
-	writel(host->size, base + MMCIDATALENGTH);
+	mmci_writel(host, timeout, MMCIDATATIMER);
+	mmci_writel(host, host->size, MMCIDATALENGTH);
 
 	blksz_bits = ffs(data->blksz) - 1;
 	BUG_ON(1 << blksz_bits != data->blksz);
@@ -831,20 +839,19 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
 	}
 
 	mmci_write_datactrlreg(host, datactrl);
-	writel(readl(base + MMCIMASK0) & ~MCI_DATAENDMASK, base + MMCIMASK0);
+	mmci_writel(host, mmci_readl(host, MMCIMASK0) & ~MCI_DATAENDMASK,
+		    MMCIMASK0);
 	mmci_set_mask1(host, irqmask);
 }
 
 static void
 mmci_start_command(struct mmci_host *host, struct mmc_command *cmd, u32 c)
 {
-	void __iomem *base = host->base;
-
 	dev_dbg(mmc_dev(host->mmc), "op %02x arg %08x flags %08x\n",
 	    cmd->opcode, cmd->arg, cmd->flags);
 
-	if (readl(base + MMCICOMMAND) & MCI_CPSM_ENABLE) {
-		writel(0, base + MMCICOMMAND);
+	if (mmci_readl(host, MMCICOMMAND) & MCI_CPSM_ENABLE) {
+		mmci_writel(host, 0, MMCICOMMAND);
 		udelay(1);
 	}
 
@@ -859,8 +866,8 @@ mmci_start_command(struct mmci_host *host, struct mmc_command *cmd, u32 c)
 
 	host->cmd = cmd;
 
-	writel(cmd->arg, base + MMCIARGUMENT);
-	writel(c, base + MMCICOMMAND);
+	mmci_writel(host, cmd->arg, MMCIARGUMENT);
+	mmci_writel(host, c, MMCICOMMAND);
 }
 
 static void
@@ -885,7 +892,7 @@ mmci_data_irq(struct mmci_host *host, struct mmc_data *data,
 		 * can be as much as a FIFO-worth of data ahead.  This
 		 * matters for FIFO overruns only.
 		 */
-		remain = readl(host->base + MMCIDATACNT);
+		remain = mmci_readl(host, MMCIDATACNT);
 		success = data->blksz * data->blocks - remain;
 
 		dev_dbg(mmc_dev(host->mmc), "MCI ERROR IRQ, status 0x%08x at 0x%08x\n",
@@ -967,10 +974,10 @@ mmci_cmd_irq(struct mmci_host *host, struct mmc_command *cmd,
 	} else if (status & MCI_CMDCRCFAIL && cmd->flags & MMC_RSP_CRC) {
 		cmd->error = -EILSEQ;
 	} else {
-		cmd->resp[0] = readl(base + MMCIRESPONSE0);
-		cmd->resp[1] = readl(base + MMCIRESPONSE1);
-		cmd->resp[2] = readl(base + MMCIRESPONSE2);
-		cmd->resp[3] = readl(base + MMCIRESPONSE3);
+		cmd->resp[0] = mmci_readl(host, MMCIRESPONSE0);
+		cmd->resp[1] = mmci_readl(host, MMCIRESPONSE1);
+		cmd->resp[2] = mmci_readl(host, MMCIRESPONSE2);
+		cmd->resp[3] = mmci_readl(host, MMCIRESPONSE3);
 	}
 
 	if ((!sbc && !cmd->data) || cmd->error) {
@@ -1081,11 +1088,10 @@ static irqreturn_t mmci_pio_irq(int irq, void *dev_id)
 	struct mmci_host *host = dev_id;
 	struct sg_mapping_iter *sg_miter = &host->sg_miter;
 	struct variant_data *variant = host->variant;
-	void __iomem *base = host->base;
 	unsigned long flags;
 	u32 status;
 
-	status = readl(base + MMCISTATUS);
+	status = mmci_readl(host, MMCISTATUS);
 
 	dev_dbg(mmc_dev(host->mmc), "irq1 (pio) %08x\n", status);
 
@@ -1125,7 +1131,7 @@ static irqreturn_t mmci_pio_irq(int irq, void *dev_id)
 		if (remain)
 			break;
 
-		status = readl(base + MMCISTATUS);
+		status = mmci_readl(host, MMCISTATUS);
 	} while (1);
 
 	sg_miter_stop(sg_miter);
@@ -1147,7 +1153,9 @@ static irqreturn_t mmci_pio_irq(int irq, void *dev_id)
 	 */
 	if (host->size == 0) {
 		mmci_set_mask1(host, 0);
-		writel(readl(base + MMCIMASK0) | MCI_DATAENDMASK, base + MMCIMASK0);
+		mmci_writel(host,
+			    mmci_readl(host, MMCIMASK0) | MCI_DATAENDMASK,
+			    MMCIMASK0);
 	}
 
 	return IRQ_HANDLED;
@@ -1168,10 +1176,10 @@ static irqreturn_t mmci_irq(int irq, void *dev_id)
 		struct mmc_command *cmd;
 		struct mmc_data *data;
 
-		status = readl(host->base + MMCISTATUS);
+		status = mmci_readl(host, MMCISTATUS);
 
 		if (host->singleirq) {
-			if (status & readl(host->base + MMCIMASK1))
+			if (status & mmci_readl(host, MMCIMASK1))
 				mmci_pio_irq(irq, dev_id);
 
 			status &= ~MCI_IRQ1MASK;
@@ -1182,8 +1190,8 @@ static irqreturn_t mmci_irq(int irq, void *dev_id)
 		 * enabled) since the HW seems to be triggering the IRQ on both
 		 * edges while monitoring DAT0 for busy completion.
 		 */
-		status &= readl(host->base + MMCIMASK0);
-		writel(status, host->base + MMCICLEAR);
+		status &= mmci_readl(host, MMCIMASK0);
+		mmci_writel(host, status, MMCICLEAR);
 
 		dev_dbg(mmc_dev(host->mmc), "irq0 (data+cmd) %08x\n", status);
 
@@ -1627,9 +1635,9 @@ static int mmci_probe(struct amba_device *dev,
 
 	spin_lock_init(&host->lock);
 
-	writel(0, host->base + MMCIMASK0);
-	writel(0, host->base + MMCIMASK1);
-	writel(0xfff, host->base + MMCICLEAR);
+	mmci_writel(host, 0, MMCIMASK0);
+	mmci_writel(host, 0, MMCIMASK1);
+	mmci_writel(host, 0xfff, MMCICLEAR);
 
 	if (plat->gpio_cd == -EPROBE_DEFER) {
 		ret = -EPROBE_DEFER;
@@ -1689,7 +1697,7 @@ static int mmci_probe(struct amba_device *dev,
 			goto irq0_free;
 	}
 
-	writel(MCI_IRQENABLE, host->base + MMCIMASK0);
+	mmci_writel(host, MCI_IRQENABLE, MMCIMASK0);
 
 	amba_set_drvdata(dev, mmc);
 
@@ -1745,11 +1753,11 @@ static int mmci_remove(struct amba_device *dev)
 
 		mmc_remove_host(mmc);
 
-		writel(0, host->base + MMCIMASK0);
-		writel(0, host->base + MMCIMASK1);
+		mmci_writel(host, 0, MMCIMASK0);
+		mmci_writel(host, 0, MMCIMASK1);
 
-		writel(0, host->base + MMCICOMMAND);
-		writel(0, host->base + MMCIDATACTRL);
+		mmci_writel(host, 0, MMCICOMMAND);
+		mmci_writel(host, 0, MMCIDATACTRL);
 
 		mmci_dma_release(host);
 		free_irq(dev->irq[0], host);
@@ -1783,7 +1791,7 @@ static int mmci_suspend(struct device *dev)
 	if (mmc) {
 		struct mmci_host *host = mmc_priv(mmc);
 		pm_runtime_get_sync(dev);
-		writel(0, host->base + MMCIMASK0);
+		mmci_writel(host, 0, MMCIMASK0);
 	}
 
 	return 0;
@@ -1796,7 +1804,7 @@ static int mmci_resume(struct device *dev)
 
 	if (mmc) {
 		struct mmci_host *host = mmc_priv(mmc);
-		writel(MCI_IRQENABLE, host->base + MMCIMASK0);
+		mmci_writel(host, MCI_IRQENABLE, MMCIMASK0);
 		pm_runtime_put(dev);
 	}
 
@@ -1812,10 +1820,10 @@ static void mmci_save(struct mmci_host *host)
 	if (host->variant->pwrreg_nopower) {
 		spin_lock_irqsave(&host->lock, flags);
 
-		writel(0, host->base + MMCIMASK0);
-		writel(0, host->base + MMCIDATACTRL);
-		writel(0, host->base + MMCIPOWER);
-		writel(0, host->base + MMCICLOCK);
+		mmci_writel(host, 0, MMCIMASK0);
+		mmci_writel(host, 0, MMCIDATACTRL);
+		mmci_writel(host, 0, MMCIPOWER);
+		mmci_writel(host, 0, MMCICLOCK);
 		mmci_reg_delay(host);
 
 		spin_unlock_irqrestore(&host->lock, flags);
@@ -1830,10 +1838,10 @@ static void mmci_restore(struct mmci_host *host)
 	if (host->variant->pwrreg_nopower) {
 		spin_lock_irqsave(&host->lock, flags);
 
-		writel(host->clk_reg, host->base + MMCICLOCK);
-		writel(host->datactrl_reg, host->base + MMCIDATACTRL);
-		writel(host->pwr_reg, host->base + MMCIPOWER);
-		writel(MCI_IRQENABLE, host->base + MMCIMASK0);
+		mmci_writel(host, host->clk_reg, MMCICLOCK);
+		mmci_writel(host, host->datactrl_reg, MMCIDATACTRL);
+		mmci_writel(host, host->pwr_reg, MMCIPOWER);
+		mmci_writel(host, MCI_IRQENABLE, MMCIMASK0);
 		mmci_reg_delay(host);
 
 		spin_unlock_irqrestore(&host->lock, flags);
-- 
1.7.9.5

