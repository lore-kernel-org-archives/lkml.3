Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbaDPVqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:46:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38067 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783AbaDPVps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:45:48 -0400
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 1/2] dmaengine: qcom_bam_dma: Add v1.3.0 driver support
Date: Wed, 16 Apr 2014 16:45:18 -0500
Message-Id: <1397684719-30065-2-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397684719-30065-1-git-send-email-agross@codeaurora.org>
References: <1397684719-30065-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the v1.3.0 version of the BAM dma ip block.  This
patch adds register access abstraction to deal with the changes to the register
map between the two versions.  Blocks of registers moved around within the
address space, and multipliers used for calculating the pipe registers changed
as well.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/dma/qcom_bam_dma.c |  177 ++++++++++++++++++++++++++++----------------
 1 file changed, 114 insertions(+), 63 deletions(-)

diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
index 82c9231..02f7fef 100644
--- a/drivers/dma/qcom_bam_dma.c
+++ b/drivers/dma/qcom_bam_dma.c
@@ -74,35 +74,49 @@ struct bam_async_desc {
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
+/* Register base offset and multplier values.  Use version of map as index */
+static unsigned int ctrl_offs[] = { 0xf80, 0x0 };
+static unsigned int pipe_offs[] = { 0x0, 0x1000 };
+static unsigned int ee_offs[] = { 0x1800, 0x800 };
+static unsigned int evnt_offs[] = { 0x1000, 0x1800 };
+static unsigned int pipe_mult[] = { 0x80, 0x1000 };
+static unsigned int evnt_mult[] = { 0x40, 0x1000 };
+
+/* relative offset from ctrl register base */
+#define BAM_CTRL			0x00
+#define BAM_REVISION			0x04
+#define BAM_DESC_CNT_TRSHLD		0x08
+#define BAM_IRQ_SRCS			0x0C
+#define BAM_IRQ_SRCS_MSK		0x10
+#define BAM_IRQ_STTS			0x14
+#define BAM_IRQ_CLR			0x18
+#define BAM_IRQ_EN			0x1C
+#define BAM_IRQ_SRCS_UNMASKED		0x30
+#define BAM_NUM_PIPES			0x3c
+#define BAM_TIMER			0x40
+#define BAM_TIMER_CTRL			0x44
+#define BAM_CNFG_BITS			0x7c
+
+/* relative offset from irq register base */
+#define BAM_IRQ_SRCS_EE			0x00
+#define BAM_IRQ_SRCS_MSK_EE		0x04
+
+/* relative offset from pipe register base */
+#define BAM_P_CTRL			0x00
+#define BAM_P_RST			0x04
+#define BAM_P_HALT			0x08
+#define BAM_P_IRQ_STTS			0x10
+#define BAM_P_IRQ_CLR			0x14
+#define BAM_P_IRQ_EN			0x18
+
+/* relative offset from event register base */
+#define BAM_P_SW_OFSTS			0x00
+#define BAM_P_EVNT_REG			0x18
+#define BAM_P_DESC_FIFO_ADDR		0x1C
+#define BAM_P_FIFO_SIZES		0x20
+#define BAM_P_DATA_FIFO_ADDR		0x24
+#define BAM_P_EVNT_TRSHLD		0x28
+#define BAM_P_EVNT_DEST_ADDR		0x2C
 
 /* BAM CTRL */
 #define BAM_SW_RST			BIT(0)
@@ -292,6 +306,8 @@ struct bam_device {
 	/* execution environment ID, from DT */
 	u32 ee;
 
+	u32 reg_ver;
+
 	struct clk *bamclk;
 	int irq;
 
@@ -299,6 +315,36 @@ struct bam_device {
 	struct tasklet_struct task;
 };
 
+static inline void __iomem *ctrl_addr(struct bam_device *bdev, u32 reg)
+{
+	return bdev->regs + ctrl_offs[bdev->reg_ver] + reg;
+}
+
+static inline void __iomem *ee_addr(struct bam_device *bdev, u32 reg)
+{
+	u32 offset = ee_offs[bdev->reg_ver] + reg + (bdev->ee * 0x80);
+
+	return bdev->regs + offset;
+}
+
+static inline void __iomem *pipe_addr(struct bam_device *bdev, u32 pipe,
+	u32 reg)
+{
+	u32 offset = pipe_offs[bdev->reg_ver] + reg;
+
+	offset += pipe_mult[bdev->reg_ver] * pipe;
+	return bdev->regs + offset;
+}
+
+static inline void __iomem *evnt_addr(struct bam_device *bdev, u32 pipe,
+	u32 reg)
+{
+	u32 offset = evnt_offs[bdev->reg_ver] + reg;
+
+	offset += evnt_mult[bdev->reg_ver] * pipe;
+	return bdev->regs + offset;
+}
+
 /**
  * bam_reset_channel - Reset individual BAM DMA channel
  * @bchan: bam channel
@@ -312,8 +358,8 @@ static void bam_reset_channel(struct bam_chan *bchan)
 	lockdep_assert_held(&bchan->vc.lock);
 
 	/* reset channel */
-	writel_relaxed(1, bdev->regs + BAM_P_RST(bchan->id));
-	writel_relaxed(0, bdev->regs + BAM_P_RST(bchan->id));
+	writel_relaxed(1, pipe_addr(bdev, bchan->id, BAM_P_RST));
+	writel_relaxed(0, pipe_addr(bdev, bchan->id, BAM_P_RST));
 
 	/* don't allow cpu to reorder BAM register accesses done after this */
 	wmb();
@@ -342,17 +388,18 @@ static void bam_chan_init_hw(struct bam_chan *bchan,
 	 * because we allocated 1 more descriptor (8 bytes) than we can use
 	 */
 	writel_relaxed(ALIGN(bchan->fifo_phys, sizeof(struct bam_desc_hw)),
-			bdev->regs + BAM_P_DESC_FIFO_ADDR(bchan->id));
-	writel_relaxed(BAM_DESC_FIFO_SIZE, bdev->regs +
-			BAM_P_FIFO_SIZES(bchan->id));
+			evnt_addr(bdev, bchan->id, BAM_P_DESC_FIFO_ADDR));
+	writel_relaxed(BAM_DESC_FIFO_SIZE, evnt_addr(bdev, bchan->id,
+				BAM_P_FIFO_SIZES));
 
 	/* enable the per pipe interrupts, enable EOT, ERR, and INT irqs */
-	writel_relaxed(P_DEFAULT_IRQS_EN, bdev->regs + BAM_P_IRQ_EN(bchan->id));
+	writel_relaxed(P_DEFAULT_IRQS_EN,
+			pipe_addr(bdev, bchan->id, BAM_P_IRQ_EN));
 
 	/* unmask the specific pipe and EE combo */
-	val = readl_relaxed(bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
+	val = readl_relaxed(ee_addr(bdev, BAM_IRQ_SRCS_MSK_EE));
 	val |= BIT(bchan->id);
-	writel_relaxed(val, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
+	writel_relaxed(val, ee_addr(bdev, BAM_IRQ_SRCS_MSK_EE));
 
 	/* don't allow cpu to reorder the channel enable done below */
 	wmb();
@@ -362,7 +409,7 @@ static void bam_chan_init_hw(struct bam_chan *bchan,
 	if (dir == DMA_DEV_TO_MEM)
 		val |= P_DIRECTION;
 
-	writel_relaxed(val, bdev->regs + BAM_P_CTRL(bchan->id));
+	writel_relaxed(val, pipe_addr(bdev, bchan->id, BAM_P_CTRL));
 
 	bchan->initialized = 1;
 
@@ -427,12 +474,12 @@ static void bam_free_chan(struct dma_chan *chan)
 	bchan->fifo_virt = NULL;
 
 	/* mask irq for pipe/channel */
-	val = readl_relaxed(bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
+	val = readl_relaxed(ee_addr(bdev, BAM_IRQ_SRCS_MSK_EE));
 	val &= ~BIT(bchan->id);
-	writel_relaxed(val, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
+	writel_relaxed(val, ee_addr(bdev, BAM_IRQ_SRCS_MSK_EE));
 
 	/* disable irq */
-	writel_relaxed(0, bdev->regs + BAM_P_IRQ_EN(bchan->id));
+	writel_relaxed(0, pipe_addr(bdev, bchan->id, BAM_P_IRQ_EN));
 }
 
 /**
@@ -570,14 +617,14 @@ static int bam_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	switch (cmd) {
 	case DMA_PAUSE:
 		spin_lock_irqsave(&bchan->vc.lock, flag);
-		writel_relaxed(1, bdev->regs + BAM_P_HALT(bchan->id));
+		writel_relaxed(1, pipe_addr(bdev, bchan->id, BAM_P_HALT));
 		bchan->paused = 1;
 		spin_unlock_irqrestore(&bchan->vc.lock, flag);
 		break;
 
 	case DMA_RESUME:
 		spin_lock_irqsave(&bchan->vc.lock, flag);
-		writel_relaxed(0, bdev->regs + BAM_P_HALT(bchan->id));
+		writel_relaxed(0, pipe_addr(bdev, bchan->id, BAM_P_HALT));
 		bchan->paused = 0;
 		spin_unlock_irqrestore(&bchan->vc.lock, flag);
 		break;
@@ -613,7 +660,7 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 	unsigned long flags;
 	struct bam_async_desc *async_desc;
 
-	srcs = readl_relaxed(bdev->regs + BAM_IRQ_SRCS_EE(bdev->ee));
+	srcs = readl_relaxed(ee_addr(bdev, BAM_IRQ_SRCS_EE));
 
 	/* return early if no pipe/channel interrupts are present */
 	if (!(srcs & P_IRQ))
@@ -626,11 +673,9 @@ static u32 process_channel_irqs(struct bam_device *bdev)
 			continue;
 
 		/* clear pipe irq */
-		pipe_stts = readl_relaxed(bdev->regs +
-			BAM_P_IRQ_STTS(i));
+		pipe_stts = readl_relaxed(pipe_addr(bdev, i, BAM_P_IRQ_STTS));
 
-		writel_relaxed(pipe_stts, bdev->regs +
-				BAM_P_IRQ_CLR(i));
+		writel_relaxed(pipe_stts, pipe_addr(bdev, i, BAM_P_IRQ_CLR));
 
 		spin_lock_irqsave(&bchan->vc.lock, flags);
 		async_desc = bchan->curr_txd;
@@ -681,12 +726,12 @@ static irqreturn_t bam_dma_irq(int irq, void *data)
 		tasklet_schedule(&bdev->task);
 
 	if (srcs & BAM_IRQ)
-		clr_mask = readl_relaxed(bdev->regs + BAM_IRQ_STTS);
+		clr_mask = readl_relaxed(ctrl_addr(bdev, BAM_IRQ_STTS));
 
 	/* don't allow reorder of the various accesses to the BAM registers */
 	mb();
 
-	writel_relaxed(clr_mask, bdev->regs + BAM_IRQ_CLR);
+	writel_relaxed(clr_mask, ctrl_addr(bdev, BAM_IRQ_CLR));
 
 	return IRQ_HANDLED;
 }
@@ -750,7 +795,7 @@ static void bam_apply_new_config(struct bam_chan *bchan,
 	else
 		maxburst = bchan->slave.dst_maxburst;
 
-	writel_relaxed(maxburst, bdev->regs + BAM_DESC_CNT_TRSHLD);
+	writel_relaxed(maxburst, ctrl_addr(bdev, BAM_DESC_CNT_TRSHLD));
 
 	bchan->reconfigure = 0;
 }
@@ -814,7 +859,7 @@ static void bam_start_dma(struct bam_chan *bchan)
 	/* ensure descriptor writes and dma start not reordered */
 	wmb();
 	writel_relaxed(bchan->tail * sizeof(struct bam_desc_hw),
-			bdev->regs + BAM_P_EVNT_REG(bchan->id));
+			evnt_addr(bdev, bchan->id, BAM_P_EVNT_REG));
 }
 
 /**
@@ -902,43 +947,45 @@ static int bam_init(struct bam_device *bdev)
 	u32 val;
 
 	/* read revision and configuration information */
-	val = readl_relaxed(bdev->regs + BAM_REVISION) >> NUM_EES_SHIFT;
+	val = readl_relaxed(ctrl_addr(bdev, BAM_REVISION)) >> NUM_EES_SHIFT;
 	val &= NUM_EES_MASK;
 
 	/* check that configured EE is within range */
 	if (bdev->ee >= val)
 		return -EINVAL;
 
-	val = readl_relaxed(bdev->regs + BAM_NUM_PIPES);
+	val = readl_relaxed(ctrl_addr(bdev, BAM_NUM_PIPES));
 	bdev->num_channels = val & BAM_NUM_PIPES_MASK;
 
 	/* s/w reset bam */
 	/* after reset all pipes are disabled and idle */
-	val = readl_relaxed(bdev->regs + BAM_CTRL);
+	val = readl_relaxed(ctrl_addr(bdev, BAM_CTRL));
 	val |= BAM_SW_RST;
-	writel_relaxed(val, bdev->regs + BAM_CTRL);
+	writel_relaxed(val, ctrl_addr(bdev, BAM_CTRL));
 	val &= ~BAM_SW_RST;
-	writel_relaxed(val, bdev->regs + BAM_CTRL);
+	writel_relaxed(val, ctrl_addr(bdev, BAM_CTRL));
 
 	/* make sure previous stores are visible before enabling BAM */
 	wmb();
 
 	/* enable bam */
 	val |= BAM_EN;
-	writel_relaxed(val, bdev->regs + BAM_CTRL);
+	writel_relaxed(val, ctrl_addr(bdev, BAM_CTRL));
 
 	/* set descriptor threshhold, start with 4 bytes */
-	writel_relaxed(DEFAULT_CNT_THRSHLD, bdev->regs + BAM_DESC_CNT_TRSHLD);
+	writel_relaxed(DEFAULT_CNT_THRSHLD,
+			ctrl_addr(bdev, BAM_DESC_CNT_TRSHLD));
 
 	/* Enable default set of h/w workarounds, ie all except BAM_FULL_PIPE */
-	writel_relaxed(BAM_CNFG_BITS_DEFAULT, bdev->regs + BAM_CNFG_BITS);
+	writel_relaxed(BAM_CNFG_BITS_DEFAULT,
+			ctrl_addr(bdev, BAM_CNFG_BITS));
 
 	/* enable irqs for errors */
 	writel_relaxed(BAM_ERROR_EN | BAM_HRESP_ERR_EN,
-				bdev->regs + BAM_IRQ_EN);
+			ctrl_addr(bdev, BAM_IRQ_EN));
 
 	/* unmask global bam interrupt */
-	writel_relaxed(BAM_IRQ_MSK, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
+	writel_relaxed(BAM_IRQ_MSK, ee_addr(bdev, BAM_IRQ_SRCS_MSK_EE));
 
 	return 0;
 }
@@ -980,6 +1027,9 @@ static int bam_dma_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	if (of_device_is_compatible(pdev->dev.of_node, "qcom,bam-v1.4.0"))
+		bdev->reg_ver = 1;
+
 	bdev->bamclk = devm_clk_get(bdev->dev, "bam_clk");
 	if (IS_ERR(bdev->bamclk))
 		return PTR_ERR(bdev->bamclk);
@@ -1068,7 +1118,7 @@ static int bam_dma_remove(struct platform_device *pdev)
 	dma_async_device_unregister(&bdev->common);
 
 	/* mask all interrupts for this execution environment */
-	writel_relaxed(0, bdev->regs + BAM_IRQ_SRCS_MSK_EE(bdev->ee));
+	writel_relaxed(0, ee_addr(bdev, BAM_IRQ_SRCS_MSK_EE));
 
 	devm_free_irq(bdev->dev, bdev->irq, bdev);
 
@@ -1089,6 +1139,7 @@ static int bam_dma_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id bam_of_match[] = {
+	{ .compatible = "qcom,bam-v1.3.0", },
 	{ .compatible = "qcom,bam-v1.4.0", },
 	{}
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

