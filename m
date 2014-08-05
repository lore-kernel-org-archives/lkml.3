Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaHEBT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:19:56 -0400
Received: from mail-oi0-f73.google.com ([209.85.218.73]:44070 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaHEBTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:19:54 -0400
From: Sonny Rao <sonnyrao@chromium.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-next@vger.kernel.org,
        grundler@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-arm-kernel@lists.infradead.org, jh80.chung@samsung.com,
        cjb@laptop.org, tgih.jun@samsung.com, kgene.kim@samsung.com,
        joshi@samsung.com, t.figa@samsung.com, dianders@chromium.org,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: [PATCH] mmc: dw_mmc: change to use recommended reset procedure
Date: Mon,  4 Aug 2014 18:19:50 -0700
Message-Id: <1407201590-26740-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <CAPDyKFq2isO+DKMuLT9Ud8B9reFZiVYKG6LL8ysF0ZTNGfY8Nw@mail.gmail.com>
References: <CAPDyKFq2isO+DKMuLT9Ud8B9reFZiVYKG6LL8ysF0ZTNGfY8Nw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the fifo reset code to follow the reset procedure
outlined in the documentation of Synopsys Mobile storage host databook.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[sonnyrao: fix compile for !CONFIG_MMC_DW_IDMAC case]
---
 drivers/mmc/host/dw_mmc.c | 87 ++++++++++++++++++++++++++++++++++-------------
 drivers/mmc/host/dw_mmc.h |  5 +++
 2 files changed, 69 insertions(+), 23 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 1ac227c..39cf54f 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -111,8 +111,7 @@ static const u8 tuning_blk_pattern_8bit[] = {
 	0xff, 0x77, 0x77, 0xff, 0x77, 0xbb, 0xdd, 0xee,
 };
 
-static inline bool dw_mci_fifo_reset(struct dw_mci *host);
-static inline bool dw_mci_ctrl_all_reset(struct dw_mci *host);
+static bool dw_mci_reset(struct dw_mci *host);
 
 #if defined(CONFIG_DEBUG_FS)
 static int dw_mci_req_show(struct seq_file *s, void *v)
@@ -1235,7 +1234,7 @@ static int dw_mci_data_complete(struct dw_mci *host, struct mmc_data *data)
 		 * After an error, there may be data lingering
 		 * in the FIFO
 		 */
-		dw_mci_fifo_reset(host);
+		dw_mci_reset(host);
 	} else {
 		data->bytes_xfered = data->blocks * data->blksz;
 		data->error = 0;
@@ -1352,7 +1351,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
 
 			/* CMD error in data command */
 			if (mrq->cmd->error && mrq->data)
-				dw_mci_fifo_reset(host);
+				dw_mci_reset(host);
 
 			host->cmd = NULL;
 			host->data = NULL;
@@ -1963,14 +1962,8 @@ static void dw_mci_work_routine_card(struct work_struct *work)
 			}
 
 			/* Power down slot */
-			if (present == 0) {
-				/* Clear down the FIFO */
-				dw_mci_fifo_reset(host);
-#ifdef CONFIG_MMC_DW_IDMAC
-				dw_mci_idmac_reset(host);
-#endif
-
-			}
+			if (present == 0)
+				dw_mci_reset(host);
 
 			spin_unlock_bh(&host->lock);
 
@@ -2208,8 +2201,11 @@ static bool dw_mci_ctrl_reset(struct dw_mci *host, u32 reset)
 	return false;
 }
 
-static inline bool dw_mci_fifo_reset(struct dw_mci *host)
+static bool dw_mci_reset(struct dw_mci *host)
 {
+	u32 flags = SDMMC_CTRL_RESET | SDMMC_CTRL_FIFO_RESET;
+	bool ret = false;
+
 	/*
 	 * Reseting generates a block interrupt, hence setting
 	 * the scatter-gather pointer to NULL.
@@ -2219,15 +2215,60 @@ static inline bool dw_mci_fifo_reset(struct dw_mci *host)
 		host->sg = NULL;
 	}
 
-	return dw_mci_ctrl_reset(host, SDMMC_CTRL_FIFO_RESET);
-}
+	if (host->use_dma)
+		flags |= SDMMC_CTRL_DMA_RESET;
 
-static inline bool dw_mci_ctrl_all_reset(struct dw_mci *host)
-{
-	return dw_mci_ctrl_reset(host,
-				 SDMMC_CTRL_FIFO_RESET |
-				 SDMMC_CTRL_RESET |
-				 SDMMC_CTRL_DMA_RESET);
+	if (dw_mci_ctrl_reset(host, flags)) {
+		/*
+		 * In all cases we clear the RAWINTS register to clear any
+		 * interrupts.
+		 */
+		mci_writel(host, RINTSTS, 0xFFFFFFFF);
+
+		/* if using dma we wait for dma_req to clear */
+		if (host->use_dma) {
+			unsigned long timeout = jiffies + msecs_to_jiffies(500);
+			u32 status;
+			do {
+				status = mci_readl(host, STATUS);
+				if (!(status & SDMMC_STATUS_DMA_REQ))
+					break;
+				cpu_relax();
+			} while (time_before(jiffies, timeout));
+
+			if (status & SDMMC_STATUS_DMA_REQ) {
+				dev_err(host->dev,
+					"%s: Timeout waiting for dma_req to "
+					"clear during reset\n", __func__);
+				goto ciu_out;
+			}
+
+			/* when using DMA next we reset the fifo again */
+			if (!dw_mci_ctrl_reset(host, SDMMC_CTRL_FIFO_RESET))
+				goto ciu_out;
+		}
+	} else {
+		/* if the controller reset bit did clear, then set clock regs */
+		if (!(mci_readl(host, CTRL) & SDMMC_CTRL_RESET)) {
+			dev_err(host->dev, "%s: fifo/dma reset bits didn't "
+				"clear but ciu was reset, doing clock update\n",
+				__func__);
+			goto ciu_out;
+		}
+	}
+
+#if IS_ENABLED(CONFIG_MMC_DW_IDMAC)
+	/* It is also recommended that we reset and reprogram idmac */
+	dw_mci_idmac_reset(host);
+#endif
+
+	ret = true;
+
+ciu_out:
+	/* After a CTRL reset we need to have CIU set clock registers  */
+	mci_send_cmd(host->cur_slot, SDMMC_CMD_UPD_CLK, 0);
+
+	return ret;
 }
 
 #ifdef CONFIG_OF
@@ -2425,7 +2466,7 @@ int dw_mci_probe(struct dw_mci *host)
 	}
 
 	/* Reset all blocks */
-	if (!dw_mci_ctrl_all_reset(host))
+	if (!dw_mci_ctrl_reset(host, SDMMC_CTRL_ALL_RESET_FLAGS))
 		return -ENODEV;
 
 	host->dma_ops = host->pdata->dma_ops;
@@ -2612,7 +2653,7 @@ int dw_mci_resume(struct dw_mci *host)
 		}
 	}
 
-	if (!dw_mci_ctrl_all_reset(host)) {
+	if (!dw_mci_ctrl_reset(host, SDMMC_CTRL_ALL_RESET_FLAGS)) {
 		ret = -ENODEV;
 		return ret;
 	}
diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
index 738fa24..08fd956 100644
--- a/drivers/mmc/host/dw_mmc.h
+++ b/drivers/mmc/host/dw_mmc.h
@@ -129,6 +129,7 @@
 #define SDMMC_CMD_INDX(n)		((n) & 0x1F)
 /* Status register defines */
 #define SDMMC_GET_FCNT(x)		(((x)>>17) & 0x1FFF)
+#define SDMMC_STATUS_DMA_REQ		BIT(31)
 /* FIFOTH register defines */
 #define SDMMC_SET_FIFOTH(m, r, t)	(((m) & 0x7) << 28 | \
 					 ((r) & 0xFFF) << 16 | \
@@ -150,6 +151,10 @@
 /* Card read threshold */
 #define SDMMC_SET_RD_THLD(v, x)		(((v) & 0x1FFF) << 16 | (x))
 
+/* All ctrl reset bits */
+#define SDMMC_CTRL_ALL_RESET_FLAGS \
+	(SDMMC_CTRL_RESET | SDMMC_CTRL_FIFO_RESET | SDMMC_CTRL_DMA_RESET)
+
 /* Register access macros */
 #define mci_readl(dev, reg)			\
 	__raw_readl((dev)->regs + SDMMC_##reg)
-- 
1.8.3.2

