Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbaLBUu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:50:29 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41990 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132AbaLBUu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:50:27 -0500
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>, chris@printf.net,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/3] mmc: dw_mmc: Protect read-modify-write of INTMASK with a lock
Date: Tue,  2 Dec 2014 12:49:57 -0800
Message-Id: <1417553397-460-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1417553397-460-1-git-send-email-dianders@chromium.org>
References: <1417553397-460-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're running into cases where our enabling of the SDIO interrupt in
dw_mmc doesn't actually take effect.  Specifically, adding patch like
this:

 +++ b/drivers/mmc/host/dw_mmc.c
 @@ -1076,6 +1076,9 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)

      mci_writel(host, INTMASK,
           (int_mask | SDMMC_INT_SDIO(slot->id)));
 +    int_mask = mci_readl(host, INTMASK);
 +    if (!(int_mask & SDMMC_INT_SDIO(slot->id)))
 +      dev_err(&mmc->class_dev, "failed to enable sdio irq\n");
    } else {

...actually triggers the error message.  That's because the
dw_mci_enable_sdio_irq() unsafely does a read-modify-write of the
INTMASK register.

We can't just use the standard host->lock since that lock is not irq
safe and mmc_signal_sdio_irq() (called from interrupt context) calls
dw_mci_enable_sdio_irq().  Add a new irq-safe lock to protect INTMASK.

An alternate solution to this is to punt mmc_signal_sdio_irq() to the
tasklet and then protect INTMASK modifications by the standard host
lock.  This seemed like a bit more of a high-latency change.

Reported-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
---
Changes in v3: None
Changes in v2:
- intmask_lock renamed to irq_lock

 drivers/mmc/host/dw_mmc.c  | 13 +++++++++++++
 include/linux/mmc/dw_mmc.h |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index ae10a02..64ea042 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -759,6 +759,7 @@ disable:
 
 static int dw_mci_submit_data_dma(struct dw_mci *host, struct mmc_data *data)
 {
+	unsigned long irqflags;
 	int sg_len;
 	u32 temp;
 
@@ -795,9 +796,11 @@ static int dw_mci_submit_data_dma(struct dw_mci *host, struct mmc_data *data)
 	mci_writel(host, CTRL, temp);
 
 	/* Disable RX/TX IRQs, let DMA handle it */
+	spin_lock_irqsave(&host->irq_lock, irqflags);
 	temp = mci_readl(host, INTMASK);
 	temp  &= ~(SDMMC_INT_RXDR | SDMMC_INT_TXDR);
 	mci_writel(host, INTMASK, temp);
+	spin_unlock_irqrestore(&host->irq_lock, irqflags);
 
 	host->dma_ops->start(host, sg_len);
 
@@ -806,6 +809,7 @@ static int dw_mci_submit_data_dma(struct dw_mci *host, struct mmc_data *data)
 
 static void dw_mci_submit_data(struct dw_mci *host, struct mmc_data *data)
 {
+	unsigned long irqflags;
 	u32 temp;
 
 	data->error = -EINPROGRESS;
@@ -834,9 +838,12 @@ static void dw_mci_submit_data(struct dw_mci *host, struct mmc_data *data)
 		host->part_buf_count = 0;
 
 		mci_writel(host, RINTSTS, SDMMC_INT_TXDR | SDMMC_INT_RXDR);
+
+		spin_lock_irqsave(&host->irq_lock, irqflags);
 		temp = mci_readl(host, INTMASK);
 		temp |= SDMMC_INT_TXDR | SDMMC_INT_RXDR;
 		mci_writel(host, INTMASK, temp);
+		spin_unlock_irqrestore(&host->irq_lock, irqflags);
 
 		temp = mci_readl(host, CTRL);
 		temp &= ~SDMMC_CTRL_DMA_ENABLE;
@@ -1284,8 +1291,11 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
 {
 	struct dw_mci_slot *slot = mmc_priv(mmc);
 	struct dw_mci *host = slot->host;
+	unsigned long irqflags;
 	u32 int_mask;
 
+	spin_lock_irqsave(&host->irq_lock, irqflags);
+
 	/* Enable/disable Slot Specific SDIO interrupt */
 	int_mask = mci_readl(host, INTMASK);
 	if (enb)
@@ -1293,6 +1303,8 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
 	else
 		int_mask &= ~SDMMC_INT_SDIO(slot->sdio_id);
 	mci_writel(host, INTMASK, int_mask);
+
+	spin_unlock_irqrestore(&host->irq_lock, irqflags);
 }
 
 static int dw_mci_execute_tuning(struct mmc_host *mmc, u32 opcode)
@@ -2661,6 +2673,7 @@ int dw_mci_probe(struct dw_mci *host)
 	host->quirks = host->pdata->quirks;
 
 	spin_lock_init(&host->lock);
+	spin_lock_init(&host->irq_lock);
 	INIT_LIST_HEAD(&host->queue);
 
 	/*
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 42b724e..471fb31 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -106,6 +106,11 @@ struct mmc_data;
  * @cur_slot, @mrq and @state. These must always be updated
  * at the same time while holding @lock.
  *
+ * @irq_lock is an irq-safe spinlock protecting the INTMASK register
+ * to allow the interrupt handler to modify it directly.  Held for only long
+ * enough to read-modify-write INTMASK and no other locks are grabbed when
+ * holding this one.
+ *
  * The @mrq field of struct dw_mci_slot is also protected by @lock,
  * and must always be written at the same time as the slot is added to
  * @queue.
@@ -125,6 +130,7 @@ struct mmc_data;
  */
 struct dw_mci {
 	spinlock_t		lock;
+	spinlock_t		irq_lock;
 	void __iomem		*regs;
 
 	struct scatterlist	*sg;
-- 
2.2.0.rc0.207.ga3a616c

