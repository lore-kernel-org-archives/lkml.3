Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaI2Ed3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:33:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50241 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaI2Ed0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:33:26 -0400
From: Archit Taneja <architt@codeaurora.org>
To: vinod.koul@intel.com, agross@codeaurora.org
Cc: galak@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, Archit Taneja <architt@codeaurora.org>
Subject: [PATCH v2 1/3] dmaengine: qcom_bam_dma: Generalize BAM register offset calculations
Date: Mon, 29 Sep 2014 10:03:07 +0530
Message-Id: <1411965189-24499-1-git-send-email-architt@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1411037575-13153-1-git-send-email-architt@codeaurora.org>
References: <1411037575-13153-1-git-send-email-architt@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BAM DMA IP comes in different versions. The register offset layout varies
among these versions. The layouts depend on which generation/family of SoCs they
belong to.

The current SoCs(like 8084, 8074) have a layout where the Top level registers
come in the beginning of the address range, followed by pipe and event
registers. The BAM revision numbers fall above 1.4.0.

The older SoCs (like 8064, 8960) have a layout where the pipe registers come
first, and the top level come later. These have BAM revision numbers lesser than
1.4.0.

It isn't suitable to have macros provide the register offsets with the layouts
changed. Future BAM revisions may have different register layouts too. The
register addresses are now calculated by referring a table which contains a base
offset and multipliers for pipe/evnt/ee registers.

We have a common function bam_addr() which computes addresses for all the
registers. When computing address of top level/ee registers, we pass 0 to the
pipe argument in addr() since they don't have any multiple instances.

Some of the unused register definitions are removed. We can add new registers as
we need them.

Reviewed-by: Kumar Gala <galak@codeaurora.org>
Reviewed-by: Andy Gross <agross@codeaurora.org>
Signed-off-by: Archit Taneja <architt@codeaurora.org>
---
 drivers/dma/qcom_bam_dma.c | 176 +++++++++++++++++++++++++++++----------------
 1 file changed, 113 insertions(+), 63 deletions(-)

diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
index 7a4bbb0..b5a1662 100644
--- a/drivers/dma/qcom_bam_dma.c
+++ b/drivers/dma/qcom_bam_dma.c
@@ -79,35 +79,68 @@ struct bam_async_desc {
 	struct bam_desc_hw desc[0];
 };
 
-#define BAM_CTRL			0x0000
-#define BAM_REVISION			0x0004
-#define BAM_SW_REVISION			0x0080
-#define BAM_NUM_PIPES			0x003C
-#define BAM_TIMER			0x0040
-#define BAM_TIMER_CTRL			0x0044
-#define BAM_DESC_CNT_TRSHLD		0x0008
-#define BAM_IRQ_SRCS			0x000C
-#define BAM_IRQ_SRCS_MSK		0x0010
-#define BAM_IRQ_SRCS_UNMASKED		0x0030
-#define BAM_IRQ_STTS			0x0014
-#define BAM_IRQ_CLR			0x0018
-#define BAM_IRQ_EN			0x001C
-#define BAM_CNFG_BITS			0x007C
-#define BAM_IRQ_SRCS_EE(ee)		(0x0800 + ((ee) * 0x80))
-#define BAM_IRQ_SRCS_MSK_EE(ee)		(0x0804 + ((ee) * 0x80))
-#define BAM_P_CTRL(pipe)		(0x1000 + ((pipe) * 0x1000))
-#define BAM_P_RST(pipe)			(0x1004 + ((pipe) * 0x1000))
-#define BAM_P_HALT(pipe)		(0x1008 + ((pipe) * 0x1000))
-#define BAM_P_IRQ_STTS(pipe)		(0x1010 + ((pipe) * 0x1000))
-#define BAM_P_IRQ_CLR(pipe)		(0x1014 + ((pipe) * 0x1000))
-#define BAM_P_IRQ_EN(pipe)		(0x1018 + ((pipe) * 0x1000))
-#define BAM_P_EVNT_DEST_ADDR(pipe)	(0x182C + ((pipe) * 0x1000))
-#define BAM_P_EVNT_REG(pipe)		(0x1818 + ((pipe) * 0x1000))
-#define BAM_P_SW_OFSTS(pipe)		(0x1800 + ((pipe) * 0x1000))
-#define BAM_P_DATA_FIFO_ADDR(pipe)	(0x1824 + ((pipe) * 0x1000))
-#define BAM_P_DESC_FIFO_ADDR(pipe)	(0x181C + ((pipe) * 0x1000))
-#define BAM_P_EVNT_TRSHLD(pipe)		(0x1828 + ((pipe) * 0x1000))
-#define BAM_P_FIFO_SIZES(pipe)		(0x1820 + ((pipe) * 0x1000))
+enum bam_reg {
+	BAM_CTRL,
+	BAM_REVISION,
+	BAM_NUM_PIPES,
+	BAM_DESC_CNT_TRSHLD,
+	BAM_IRQ_SRCS,
+	BAM_IRQ_SRCS_MSK,
+	BAM_IRQ_SRCS_UNMASKED,
+	BAM_IRQ_STTS,
+	BAM_IRQ_CLR,
+	BAM_IRQ_EN,
+	BAM_CNFG_BITS,
+	BAM_IRQ_SRCS_EE,
+	BAM_IRQ_SRCS_MSK_EE,
+	BAM_P_CTRL,
+	BAM_P_RST,
+	BAM_P_HALT,
+	BAM_P_IRQ_STTS,
+	BAM_P_IRQ_CLR,
+	BAM_P_IRQ_EN,
+	BAM_P_EVNT_DEST_ADDR,
+	BAM_P_EVNT_REG,
+	BAM_P_SW_OFSTS,
+	BAM_P_DATA_FIFO_ADDR,
+	BAM_P_DESC_FIFO_ADDR,
+	BAM_P_EVNT_GEN_TRSHLD,
+	BAM_P_FIFO_SIZES,
+};
+
+struct reg_offset_data {
+	u32 base_offset;
+	unsigned int pipe_mult, evnt_mult, ee_mult;
+};
+
+static const struct reg_offset_data reg_info[] = {
+	[BAM_CTRL]		= { 0x0000, 0x00, 0x00, 0x00 },
+	[BAM_REVISION]		= { 0x0004, 0x00, 0x00, 0x00 },
+	[BAM_NUM_PIPES]		= { 0x003C, 0x00, 0x00, 0x00 },
+	[BAM_DESC_CNT_TRSHLD]	= { 0x0008, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_SRCS]		= { 0x000C, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_SRCS_MSK]	= { 0x0010, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_SRCS_UNMASKED]	= { 0x0030, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_STTS]		= { 0x0014, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_CLR]		= { 0x0018, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_EN]		= { 0x001C, 0x00, 0x00, 0x00 },
+	[BAM_CNFG_BITS]		= { 0x007C, 0x00, 0x00, 0x00 },
+	[BAM_IRQ_SRCS_EE]	= { 0x0800, 0x00, 0x00, 0x80 },
+	[BAM_IRQ_SRCS_MSK_EE]	= { 0x0804, 0x00, 0x00, 0x80 },
+	[BAM_P_CTRL]		= { 0x1000, 0x1000, 0x00, 0x00 },
+	[BAM_P_RST]		= { 0x1004, 0x1000, 0x00, 0x00 },
+	[BAM_P_HALT]		= { 0x1008, 0x1000, 0x00, 0x00 },
+	[BAM_P_IRQ_STTS]	= { 0x1010, 0x1000, 0x00, 0x00 },
+	[BAM_P_IRQ_CLR]		= { 0x1014, 0x1000, 0x00, 0x00 },
+	[BAM_P_IRQ_EN]		= { 0x1018, 0x1000, 0x00, 0x00 },
+	[BAM_P_EVNT_DEST_ADDR]	= { 0x102C, 0x00, 0x1000, 0x00 },
+	[BAM_P_EVNT_REG]	= { 0x1018, 0x00, 0x1000, 0x00 },
+	[BAM_P_SW_OFSTS]	= { 0x1000, 0x00, 0x1000, 0x00 },
+	[BAM_P_DATA_FIFO_ADDR]	= { 0x1824, 0x00, 0x1000, 0x00 },
+	[BAM_P_DESC_FIFO_ADDR]	= { 0x181C, 0x00, 0x1000, 0x00 },
+	[BAM_P_EVNT_GEN_TRSHLD]	= { 0x1828, 0x00, 0x1000, 0x00 },
+	[BAM_P_FIFO_SIZES]	= { 0x1820, 0x00, 0x1000, 0x00 },
+};
 
 /* BAM CTRL */
 #define BAM_SW_RST			BIT(0)
@@ -305,6 +338,23 @@ struct bam_device {
 };
 
 /**
+ * bam_addr - returns BAM register address
+ * @bdev: bam device
+ * @pipe: pipe instance (ignored when register doesn't have multiple instances)
+ * @reg:  register enum
+ */
+static inline void __iomem *bam_addr(struct bam_device *bdev, u32 pipe,
+		enum bam_reg reg)
+{
+	const struct reg_offset_data r = reg_info[reg];
+
+	return bdev->regs + r.base_offset +
+		r.pipe_mult * pipe +
+		r.evnt_mult * pipe +
+		r.ee_mult * bdev->ee;
+}
+
+/**
  * bam_reset_channel - Reset individual BAM DMA channel
  * @bchan: bam channel
  *
@@ -317,8 +367,8 @@ static void bam_reset_channel(struct bam_chan *bchan)
 	lockdep_assert_held(&bchan->vc.lock);
 
 	/* reset channel */
-	writel_relaxed(1, bdev->regs + BAM_P_RST(bchan->id));
-	writel_relaxed(0, bdev->regs + BAM_P_RST(bchan->id));
+	writel_relaxed(1, bam_addr(bdev, bchan->id, BAM_P_RST));
+	writel_relaxed(0, bam_addr(bdev, bchan->id, BAM_P_RST));
 
 	/* don't allow cpu to reorder BAM register accesses done after this */
 	wmb();
@@ -347,17 +397,18 @@ static void bam_chan_init_hw(struct bam_chan *bchan,
 	 * because we allocated 1 more descriptor (8 bytes) than we can use
 	 */
 	writel_relaxed(ALIGN(bchan->fifo_phys, sizeof(struct bam_desc_hw)),
-			bdev->regs + BAM_P_DESC_FIFO_ADDR(bchan->id));
-	writel_relaxed(BAM_DESC_FIFO_SIZE, bdev->regs +
-			BAM_P_FIFO_SIZES(bchan->id));
+			bam_addr(bdev, bchan->id, BAM_P_DESC_FIFO_ADDR));
+	writel_relaxed(BAM_DESC_FIFO_SIZE,
+			bam_addr(bdev, bchan->id, BAM_P_FIFO_SIZES));
 
 	/* enable the per pipe interrupts, enable EOT, ERR, and INT irqs */
-	writel_relaxed(P_DEFAULT_IRQS_EN, bdev->regs + BAM_P_IRQ_EN(bchan->id));
+	writel_relaxed(P_DEFAULT_IRQS_EN,
+			bam_addr(bdev, bchan->id, BAM_P_IRQ_EN));
 
 	/* unmask the specific pipe and EE combo */
-	val = readl_relaxed(bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
+	val = readl_relaxed(bam_addr(bdev, 0, BAM_IRQ_SRCS_MSK_EE));
 	val |= BIT(bchan->id);
-	writel_relaxed(val, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
+	writel_relaxed(val, bam_addr(bdev, 0, BAM_IRQ_SRCS_MSK_EE));
 
 	/* don't allow cpu to reorder the channel enable done below */
 	wmb();
@@ -367,7 +418,7 @@ static void bam_chan_init_hw(struct bam_chan *bchan,
 	if (dir == DMA_DEV_TO_MEM)
 		val |= P_DIRECTION;
 
-	writel_relaxed(val, bdev->regs + BAM_P_CTRL(bchan->id));
+	writel_relaxed(val, bam_addr(bdev, bchan->id, BAM_P_CTRL));
 
 	bchan->initialized = 1;
 
@@ -432,12 +483,12 @@ static void bam_free_chan(struct dma_chan *chan)
 	bchan->fifo_virt = NULL;
 
 	/* mask irq for pipe/channel */
-	val = readl_relaxed(bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
+	val = readl_relaxed(bam_addr(bdev, 0, BAM_IRQ_SRCS_MSK_EE));
 	val &= ~BIT(bchan->id);
-	writel_relaxed(val, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
+	writel_relaxed(val, bam_addr(bdev, 0, BAM_IRQ_SRCS_MSK_EE));
 
 	/* disable irq */
-	writel_relaxed(0, bdev->regs + BAM_P_IRQ_EN(bchan->id));
+	writel_relaxed(0, bam_addr(bdev, bchan->id, BAM_P_IRQ_EN));
 }
 
 /**
@@ -583,14 +634,14 @@ static int bam_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	switch (cmd) {
 	case DMA_PAUSE:
 		spin_lock_irqsave(&bchan->vc.lock, flag);
-		writel_relaxed(1, bdev->regs + BAM_P_HALT(bchan->id));
+		writel_relaxed(1, bam_addr(bdev, bchan->id, BAM_P_HALT));
 		bchan->paused = 1;
 		spin_unlock_irqrestore(&bchan->vc.lock, flag);
 		break;
 
 	case DMA_RESUME:
 		spin_lock_irqsave(&bchan->vc.lock, flag);
-		writel_relaxed(0, bdev->regs + BAM_P_HALT(bchan->id));
+		writel_relaxed(0, bam_addr(bdev, bchan->id, BAM_P_HALT));
 		bchan->paused = 0;
 		spin_unlock_irqrestore(&bchan->vc.lock, flag);
 		break;
@@ -626,7 +677,7 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 	unsigned long flags;
 	struct bam_async_desc *async_desc;
 
-	srcs = readl_relaxed(bdev->regs + BAM_IRQ_SRCS_EE(bdev->ee));
+	srcs = readl_relaxed(bam_addr(bdev, 0, BAM_IRQ_SRCS_EE));
 
 	/* return early if no pipe/channel interrupts are present */
 	if (!(srcs & P_IRQ))
@@ -639,11 +690,9 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 			continue;
 
 		/* clear pipe irq */
-		pipe_stts = readl_relaxed(bdev->regs +
-			BAM_P_IRQ_STTS(i));
+		pipe_stts = readl_relaxed(bam_addr(bdev, i, BAM_P_IRQ_STTS));
 
-		writel_relaxed(pipe_stts, bdev->regs +
-				BAM_P_IRQ_CLR(i));
+		writel_relaxed(pipe_stts, bam_addr(bdev, i, BAM_P_IRQ_CLR));
 
 		spin_lock_irqsave(&bchan->vc.lock, flags);
 		async_desc = bchan->curr_txd;
@@ -694,12 +743,12 @@ static irqreturn_t bam_dma_irq(int irq, void *data)
 		tasklet_schedule(&bdev->task);
 
 	if (srcs & BAM_IRQ)
-		clr_mask = readl_relaxed(bdev->regs + BAM_IRQ_STTS);
+		clr_mask = readl_relaxed(bam_addr(bdev, 0, BAM_IRQ_STTS));
 
 	/* don't allow reorder of the various accesses to the BAM registers */
 	mb();
 
-	writel_relaxed(clr_mask, bdev->regs + BAM_IRQ_CLR);
+	writel_relaxed(clr_mask, bam_addr(bdev, 0, BAM_IRQ_CLR));
 
 	return IRQ_HANDLED;
 }
@@ -763,7 +812,7 @@ static void bam_apply_new_config(struct bam_chan *bchan,
 	else
 		maxburst = bchan->slave.dst_maxburst;
 
-	writel_relaxed(maxburst, bdev->regs + BAM_DESC_CNT_TRSHLD);
+	writel_relaxed(maxburst, bam_addr(bdev, 0, BAM_DESC_CNT_TRSHLD));
 
 	bchan->reconfigure = 0;
 }
@@ -830,7 +879,7 @@ static void bam_start_dma(struct bam_chan *bchan)
 	/* ensure descriptor writes and dma start not reordered */
 	wmb();
 	writel_relaxed(bchan->tail * sizeof(struct bam_desc_hw),
-			bdev->regs + BAM_P_EVNT_REG(bchan->id));
+			bam_addr(bdev, bchan->id, BAM_P_EVNT_REG));
 }
 
 /**
@@ -918,43 +967,44 @@ static int bam_init(struct bam_device *bdev)
 	u32 val;
 
 	/* read revision and configuration information */
-	val = readl_relaxed(bdev->regs + BAM_REVISION) >> NUM_EES_SHIFT;
+	val = readl_relaxed(bam_addr(bdev, 0, BAM_REVISION)) >> NUM_EES_SHIFT;
 	val &= NUM_EES_MASK;
 
 	/* check that configured EE is within range */
 	if (bdev->ee >= val)
 		return -EINVAL;
 
-	val = readl_relaxed(bdev->regs + BAM_NUM_PIPES);
+	val = readl_relaxed(bam_addr(bdev, 0, BAM_NUM_PIPES));
 	bdev->num_channels = val & BAM_NUM_PIPES_MASK;
 
 	/* s/w reset bam */
 	/* after reset all pipes are disabled and idle */
-	val = readl_relaxed(bdev->regs + BAM_CTRL);
+	val = readl_relaxed(bam_addr(bdev, 0, BAM_CTRL));
 	val |= BAM_SW_RST;
-	writel_relaxed(val, bdev->regs + BAM_CTRL);
+	writel_relaxed(val, bam_addr(bdev, 0, BAM_CTRL));
 	val &= ~BAM_SW_RST;
-	writel_relaxed(val, bdev->regs + BAM_CTRL);
+	writel_relaxed(val, bam_addr(bdev, 0, BAM_CTRL));
 
 	/* make sure previous stores are visible before enabling BAM */
 	wmb();
 
 	/* enable bam */
 	val |= BAM_EN;
-	writel_relaxed(val, bdev->regs + BAM_CTRL);
+	writel_relaxed(val, bam_addr(bdev, 0, BAM_CTRL));
 
 	/* set descriptor threshhold, start with 4 bytes */
-	writel_relaxed(DEFAULT_CNT_THRSHLD, bdev->regs + BAM_DESC_CNT_TRSHLD);
+	writel_relaxed(DEFAULT_CNT_THRSHLD,
+			bam_addr(bdev, 0, BAM_DESC_CNT_TRSHLD));
 
 	/* Enable default set of h/w workarounds, ie all except BAM_FULL_PIPE */
-	writel_relaxed(BAM_CNFG_BITS_DEFAULT, bdev->regs + BAM_CNFG_BITS);
+	writel_relaxed(BAM_CNFG_BITS_DEFAULT, bam_addr(bdev, 0, BAM_CNFG_BITS));
 
 	/* enable irqs for errors */
 	writel_relaxed(BAM_ERROR_EN | BAM_HRESP_ERR_EN,
-				bdev->regs + BAM_IRQ_EN);
+			bam_addr(bdev, 0, BAM_IRQ_EN));
 
 	/* unmask global bam interrupt */
-	writel_relaxed(BAM_IRQ_MSK, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
+	writel_relaxed(BAM_IRQ_MSK, bam_addr(bdev, 0, BAM_IRQ_SRCS_MSK_EE));
 
 	return 0;
 }
@@ -1084,7 +1134,7 @@ static int bam_dma_remove(struct platform_device *pdev)
 	dma_async_device_unregister(&bdev->common);
 
 	/* mask all interrupts for this execution environment */
-	writel_relaxed(0, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
+	writel_relaxed(0, bam_addr(bdev, 0,  BAM_IRQ_SRCS_MSK_EE));
 
 	devm_free_irq(bdev->dev, bdev->irq, bdev);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

