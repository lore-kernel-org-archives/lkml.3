Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaKQNva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:51:30 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49102 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753418AbaKQNpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:44 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 50/61] dmaengine: at_xdmac: Declare slave capabilities for the generic code
Date: Mon, 17 Nov 2014 14:42:44 +0100
Message-Id: <1416231775-31252-51-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@atmel.com>

Now that the generic slave caps code can make use of the device assigned
capabilities, instead of relying on a callback to be implemented.

Make use of this code.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/at_xdmac.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index 9906e7cfbe37..3951ba8982de 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -174,6 +174,13 @@
 
 #define AT_XDMAC_MAX_CHAN	0x20
 
+#define AT_XDMAC_DMA_BUSWIDTHS\
+	(BIT(DMA_SLAVE_BUSWIDTH_UNDEFINED) |\
+	BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |\
+	BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |\
+	BIT(DMA_SLAVE_BUSWIDTH_4_BYTES) |\
+	BIT(DMA_SLAVE_BUSWIDTH_8_BYTES))
+
 enum atc_status {
 	AT_XDMAC_CHAN_IS_CYCLIC = 0,
 	AT_XDMAC_CHAN_IS_PAUSED,
@@ -1224,27 +1231,6 @@ static void at_xdmac_free_chan_resources(struct dma_chan *chan)
 	return;
 }
 
-#define AT_XDMAC_DMA_BUSWIDTHS\
-	(BIT(DMA_SLAVE_BUSWIDTH_UNDEFINED) |\
-	BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |\
-	BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |\
-	BIT(DMA_SLAVE_BUSWIDTH_4_BYTES) |\
-	BIT(DMA_SLAVE_BUSWIDTH_8_BYTES))
-
-static int at_xdmac_device_slave_caps(struct dma_chan *dchan,
-				      struct dma_slave_caps *caps)
-{
-
-	caps->src_addr_widths = AT_XDMAC_DMA_BUSWIDTHS;
-	caps->dst_addr_widths = AT_XDMAC_DMA_BUSWIDTHS;
-	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-	caps->cmd_pause = true;
-	caps->cmd_terminate = true;
-	caps->residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
-
-	return 0;
-}
-
 #ifdef CONFIG_PM
 static int atmel_xdmac_prepare(struct device *dev)
 {
@@ -1414,7 +1400,10 @@ static int at_xdmac_probe(struct platform_device *pdev)
 	atxdmac->dma.device_resume			= at_xdmac_device_resume;
 	atxdmac->dma.device_terminate_all		= at_xdmac_device_terminate_all;
 	atxdmac->dma.chancnt				= nr_channels;
-	atxdmac->dma.device_slave_caps			= at_xdmac_device_slave_caps;
+	atxdmac->dma.src_addr_widths = AT_XDMAC_DMA_BUSWIDTHS;
+	atxdmac->dma.dst_addr_widths = AT_XDMAC_DMA_BUSWIDTHS;
+	atxdmac->dma.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	atxdmac->dma.residue_granularity = DMA_RESIDUE_GRANULARITY_BURST;
 
 	/* Disable all chans and interrupts. */
 	at_xdmac_off(atxdmac);
-- 
2.1.1

