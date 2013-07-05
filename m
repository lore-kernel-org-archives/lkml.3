Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3GEG2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:28:09 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:22767
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751430Ab3GEG2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:28:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
From: <hongbo.zhang@freescale.com>
To: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <scottwood@freescale.com>, <linuxppc-dev@lists.ozlabs.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <vakul@freescale.com>, Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH V2 2/2] DMA: Freescale: update driver to support 8-channel DMA engine
Date: Fri, 5 Jul 2013 14:27:06 +0800
Message-ID: <1373005626-20726-3-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373005626-20726-1-git-send-email-hongbo.zhang@freescale.com>
References: <1373005626-20726-1-git-send-email-hongbo.zhang@freescale.com>
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
 drivers/dma/fsldma.c |    5 ++++-
 drivers/dma/fsldma.h |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 4fc2980..7732de2 100644
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



