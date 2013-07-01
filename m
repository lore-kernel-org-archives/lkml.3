Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3GADqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 23:46:38 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:54916
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864Ab3GADqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 23:46:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
From: <hongbo.zhang@freescale.com>
To: <vinod.koul@intel.com>, <djbw@fb.com>
CC: <scottwood@freescale.com>, <vakul@freescale.com>, <leoLi@freescale.com>,
        <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH 2/2] DMA: Freescale: update driver to support 8-channel DMA engine
Date: Mon, 1 Jul 2013 11:46:18 +0800
Message-ID: <1372650378-2936-2-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372650378-2936-1-git-send-email-hongbo.zhang@freescale.com>
References: <1372650378-2936-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongbo Zhang <hongbo.zhang@freescale.com>

This patch adds support to 8-channel DMA engine, thus the driver works for both
the new 8-channel and the legacy 4-channel DMA engines.

Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
---
 drivers/dma/fsldma.c |   48 ++++++++++++++++++++++++++++++++++--------------
 drivers/dma/fsldma.h |    4 ++--
 2 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 4fc2980..0f453ea 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1119,27 +1119,33 @@ static irqreturn_t fsldma_ctrl_irq(int irq, void *data)
 	struct fsldma_device *fdev = data;
 	struct fsldma_chan *chan;
 	unsigned int handled = 0;
-	u32 gsr, mask;
+	u8 chan_sr[round_up(FSL_DMA_MAX_CHANS_PER_DEVICE, 4)];
+	u32 gsr;
 	int i;
 
-	gsr = (fdev->feature & FSL_DMA_BIG_ENDIAN) ? in_be32(fdev->regs)
-						   : in_le32(fdev->regs);
-	mask = 0xff000000;
-	dev_dbg(fdev->dev, "IRQ: gsr 0x%.8x\n", gsr);
+	memset(&chan_sr, 0, sizeof(chan_sr));
+	gsr = (fdev->feature & FSL_DMA_BIG_ENDIAN) ? in_be32(fdev->regs0)
+						   : in_le32(fdev->regs0);
+	memcpy(&chan_sr[0], &gsr, 4);
+	dev_dbg(fdev->dev, "IRQ: gsr0 0x%.8x\n", gsr);
+
+	if (of_device_is_compatible(fdev->dev->of_node, "fsl,eloplus-dma2")) {
+		gsr = (fdev->feature & FSL_DMA_BIG_ENDIAN) ?
+			in_be32(fdev->regs1) : in_le32(fdev->regs1);
+		memcpy(&chan_sr[4], &gsr, 4);
+		dev_dbg(fdev->dev, "IRQ: gsr1 0x%.8x\n", gsr);
+	}
 
 	for (i = 0; i < FSL_DMA_MAX_CHANS_PER_DEVICE; i++) {
 		chan = fdev->chan[i];
 		if (!chan)
 			continue;
 
-		if (gsr & mask) {
+		if (chan_sr[i]) {
 			dev_dbg(fdev->dev, "IRQ: chan %d\n", chan->id);
 			fsldma_chan_irq(irq, chan);
 			handled++;
 		}
-
-		gsr &= ~mask;
-		mask >>= 8;
 	}
 
 	return IRQ_RETVAL(handled);
@@ -1261,7 +1267,9 @@ static int fsl_dma_chan_probe(struct fsldma_device *fdev,
 	WARN_ON(fdev->feature != chan->feature);
 
 	chan->dev = fdev->dev;
-	chan->id = ((res.start - 0x100) & 0xfff) >> 7;
+	chan->id = (res.start & 0xfff) < 0x300 ?
+		   ((res.start - 0x100) & 0xfff) >> 7 :
+		   ((res.start - 0x200) & 0xfff) >> 7;
 	if (chan->id >= FSL_DMA_MAX_CHANS_PER_DEVICE) {
 		dev_err(fdev->dev, "too many channels for device\n");
 		err = -EINVAL;
@@ -1341,13 +1349,22 @@ static int fsldma_of_probe(struct platform_device *op)
 	INIT_LIST_HEAD(&fdev->common.channels);
 
 	/* ioremap the registers for use */
-	fdev->regs = of_iomap(op->dev.of_node, 0);
-	if (!fdev->regs) {
-		dev_err(&op->dev, "unable to ioremap registers\n");
+	fdev->regs0 = of_iomap(op->dev.of_node, 0);
+	if (!fdev->regs0) {
+		dev_err(&op->dev, "unable to ioremap register0\n");
 		err = -ENOMEM;
 		goto out_free_fdev;
 	}
 
+	if (of_device_is_compatible(op->dev.of_node, "fsl,eloplus-dma2")) {
+		fdev->regs1 = of_iomap(op->dev.of_node, 1);
+		if (!fdev->regs1) {
+			dev_err(&op->dev, "unable to ioremap register1\n");
+			err = -ENOMEM;
+			goto out_free_fdev;
+		}
+	}
+
 	/* map the channel IRQ if it exists, but don't hookup the handler yet */
 	fdev->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 
@@ -1427,7 +1444,9 @@ static int fsldma_of_remove(struct platform_device *op)
 			fsl_dma_chan_remove(fdev->chan[i]);
 	}
 
-	iounmap(fdev->regs);
+	iounmap(fdev->regs0);
+	if (of_device_is_compatible(op->dev.of_node, "fsl,eloplus-dma2"))
+		iounmap(fdev->regs1);
 	dev_set_drvdata(&op->dev, NULL);
 	kfree(fdev);
 
@@ -1436,6 +1455,7 @@ static int fsldma_of_remove(struct platform_device *op)
 
 static const struct of_device_id fsldma_of_ids[] = {
 	{ .compatible = "fsl,eloplus-dma", },
+	{ .compatible = "fsl,eloplus-dma2", },
 	{ .compatible = "fsl,elo-dma", },
 	{}
 };
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index f5c3879..880664d 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -112,10 +112,10 @@ struct fsldma_chan_regs {
 };
 
 struct fsldma_chan;
-#define FSL_DMA_MAX_CHANS_PER_DEVICE 4
+#define FSL_DMA_MAX_CHANS_PER_DEVICE 8
 
 struct fsldma_device {
-	void __iomem *regs;	/* DGSR register base */
+	void __iomem *regs0, *regs1;	/* DGSR registers */
 	struct device *dev;
 	struct dma_device common;
 	struct fsldma_chan *chan[FSL_DMA_MAX_CHANS_PER_DEVICE];
-- 
1.7.9.5



