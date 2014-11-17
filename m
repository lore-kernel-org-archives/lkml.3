Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaKQNxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:53:31 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49106 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753378AbaKQNpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:39 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 44/61] dmaengine: xilinx: Split device_control
Date: Mon, 17 Nov 2014 14:42:38 +0100
Message-Id: <1416231775-31252-45-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Xilinx VDMA driver to make use of the
newly introduced callbacks, that will eventually be used to retrieve slave
capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/dma/xilinx/xilinx_vdma.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_vdma.c b/drivers/dma/xilinx/xilinx_vdma.c
index 4a3a8f3137b3..bdd2a5dd7220 100644
--- a/drivers/dma/xilinx/xilinx_vdma.c
+++ b/drivers/dma/xilinx/xilinx_vdma.c
@@ -1001,13 +1001,17 @@ error:
  * xilinx_vdma_terminate_all - Halt the channel and free descriptors
  * @chan: Driver specific VDMA Channel pointer
  */
-static void xilinx_vdma_terminate_all(struct xilinx_vdma_chan *chan)
+static int xilinx_vdma_terminate_all(struct dma_chan *dchan)
 {
+	struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
+
 	/* Halt the DMA engine */
 	xilinx_vdma_halt(chan);
 
 	/* Remove and free all of the descriptors in the lists */
 	xilinx_vdma_free_descriptors(chan);
+
+	return 0;
 }
 
 /**
@@ -1075,27 +1079,6 @@ int xilinx_vdma_channel_set_config(struct dma_chan *dchan,
 }
 EXPORT_SYMBOL(xilinx_vdma_channel_set_config);
 
-/**
- * xilinx_vdma_device_control - Configure DMA channel of the device
- * @dchan: DMA Channel pointer
- * @cmd: DMA control command
- * @arg: Channel configuration
- *
- * Return: '0' on success and failure value on error
- */
-static int xilinx_vdma_device_control(struct dma_chan *dchan,
-				      enum dma_ctrl_cmd cmd, unsigned long arg)
-{
-	struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
-
-	if (cmd != DMA_TERMINATE_ALL)
-		return -ENXIO;
-
-	xilinx_vdma_terminate_all(chan);
-
-	return 0;
-}
-
 /* -----------------------------------------------------------------------------
  * Probe and remove
  */
@@ -1300,7 +1283,7 @@ static int xilinx_vdma_probe(struct platform_device *pdev)
 				xilinx_vdma_free_chan_resources;
 	xdev->common.device_prep_interleaved_dma =
 				xilinx_vdma_dma_prep_interleaved;
-	xdev->common.device_control = xilinx_vdma_device_control;
+	xdev->common.device_terminate_all = xilinx_vdma_terminate_all;
 	xdev->common.device_tx_status = xilinx_vdma_tx_status;
 	xdev->common.device_issue_pending = xilinx_vdma_issue_pending;
 
-- 
2.1.1

