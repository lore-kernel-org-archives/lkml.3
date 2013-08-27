Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab3H0Kpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:45:34 -0400
Received: from [216.32.180.186] ([216.32.180.186]:11326 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753285Ab3H0KpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:45:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: <hongbo.zhang@freescale.com>
To: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ian.campbell@citrix.com>,
        <vinod.koul@intel.com>, <djbw@fb.com>
CC: <devicetree@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
Subject: [PATCH v8 3/3] DMA: Freescale: update driver to support 8-channel DMA engine
Date: Tue, 27 Aug 2013 18:42:03 +0800
Message-ID: <1377600123-5746-4-git-send-email-hongbo.zhang@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377600123-5746-1-git-send-email-hongbo.zhang@freescale.com>
References: <1377600123-5746-1-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
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
index 6825957..3979c65 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -89,14 +89,15 @@ config AT_HDMAC
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
+	  The Elo is the DMA controller on some mpc82xx and mpc83xx parts, the
+	  EloPlus is on mpc85xx and mpc86xx and Pxxx parts, and the Elo3 is on
+	  some Txxx and Bxxx parts.
 
 config MPC512X_DMA
 	tristate "Freescale MPC512x built-in DMA engine support"
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 49e8fbd..16a9a48 100644
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
@@ -1434,6 +1436,7 @@ static int fsldma_of_remove(struct platform_device *op)
 }
 
 static const struct of_device_id fsldma_of_ids[] = {
+	{ .compatible = "fsl,elo3-dma", },
 	{ .compatible = "fsl,eloplus-dma", },
 	{ .compatible = "fsl,elo-dma", },
 	{}
@@ -1455,7 +1458,7 @@ static struct platform_driver fsldma_of_driver = {
 
 static __init int fsldma_init(void)
 {
-	pr_info("Freescale Elo / Elo Plus DMA driver\n");
+	pr_info("Freescale Elo series DMA driver\n");
 	return platform_driver_register(&fsldma_of_driver);
 }
 
@@ -1467,5 +1470,5 @@ static void __exit fsldma_exit(void)
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



