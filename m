Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3GOKiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:38:16 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:6662
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755089Ab3GOKiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:38:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
From: <hongbo.zhang@freescale.com>
To: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <vakul@freescale.com>, Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v3 2/2] DMA: Freescale: update driver to support 8-channel DMA engine
Date: Mon, 15 Jul 2013 18:34:59 +0800
Message-ID: <1373884499-24079-3-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373884499-24079-1-git-send-email-hongbo.zhang@freescale.com>
References: <1373884499-24079-1-git-send-email-hongbo.zhang@freescale.com>
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
 drivers/dma/Kconfig  |    9 +++++----
 drivers/dma/fsldma.c |    9 ++++++---
 drivers/dma/fsldma.h |    2 +-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index e992489..b916800 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -107,14 +107,15 @@ config AT_HDMAC
 	  Support the Atmel AHB DMA controller.
 
 config FSL_DMA
-	tristate "Freescale Elo and Elo Plus DMA support"
+	tristate "Freescale Elo series DMA support"
 	depends on FSL_SOC
 	select DMA_ENGINE
 	select ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	---help---
-	  Enable support for the Freescale Elo and Elo Plus DMA controllers.
-	  The Elo is the DMA controller on some 82xx and 83xx parts, and the
-	  Elo Plus is the DMA controller on 85xx and 86xx parts.
+	  Enable support for the Freescale Elo series DMA controllers.
+	  The Elo is the DMA controller on some 82xx and 83xx parts, the Elo
+	  Plus is the DMA controller on 85xx and 86xx parts, and the Elo3 is
+	  DMA controller on QorIQ T and B parts.
 
 config MPC512X_DMA
 	tristate "Freescale MPC512x built-in DMA engine support"
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 4fc2980..76252ce 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1261,7 +1261,9 @@ static int fsl_dma_chan_probe(struct fsldma_device *fdev,
 	WARN_ON(fdev->feature != chan->feature);
 
 	chan->dev = fdev->dev;
-	chan->id = ((res.start - 0x100) & 0xfff) >> 7;
+	chan->id = (res.start & 0xfff) < 0x300 ?
+		   ((res.start - 0x100) & 0xfff) >> 7 :
+		   ((res.start - 0x200) & 0xfff) >> 7;
 	if (chan->id >= FSL_DMA_MAX_CHANS_PER_DEVICE) {
 		dev_err(fdev->dev, "too many channels for device\n");
 		err = -EINVAL;
@@ -1435,6 +1437,7 @@ static int fsldma_of_remove(struct platform_device *op)
 }
 
 static const struct of_device_id fsldma_of_ids[] = {
+	{ .compatible = "fsl,elo3-dma", },
 	{ .compatible = "fsl,eloplus-dma", },
 	{ .compatible = "fsl,elo-dma", },
 	{}
@@ -1456,7 +1459,7 @@ static struct platform_driver fsldma_of_driver = {
 
 static __init int fsldma_init(void)
 {
-	pr_info("Freescale Elo / Elo Plus DMA driver\n");
+	pr_info("Freescale Elo series DMA driver\n");
 	return platform_driver_register(&fsldma_of_driver);
 }
 
@@ -1468,5 +1471,5 @@ static void __exit fsldma_exit(void)
 subsys_initcall(fsldma_init);
 module_exit(fsldma_exit);
 
-MODULE_DESCRIPTION("Freescale Elo / Elo Plus DMA driver");
+MODULE_DESCRIPTION("Freescale Elo series DMA driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index f5c3879..1ffc244 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -112,7 +112,7 @@ struct fsldma_chan_regs {
 };
 
 struct fsldma_chan;
-#define FSL_DMA_MAX_CHANS_PER_DEVICE 4
+#define FSL_DMA_MAX_CHANS_PER_DEVICE 8
 
 struct fsldma_device {
 	void __iomem *regs;	/* DGSR register base */
-- 
1.7.9.5



