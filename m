Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbaJVP67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:58:59 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54159 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754887AbaJVPpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:55 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH v3 44/59] dmaengine: xilinx: Split device_control
Date: Wed, 22 Oct 2014 17:43:58 +0200
Message-Id: <1413992653-21963-45-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
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
index a6e64767186e..1df06b45c798 100644
--- a/drivers/dma/xilinx/xilinx_vdma.c
+++ b/drivers/dma/xilinx/xilinx_vdma.c
@@ -996,13 +996,17 @@ error:
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
@@ -1070,27 +1074,6 @@ int xilinx_vdma_channel_set_config(struct dma_chan *dchan,
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
@@ -1295,7 +1278,7 @@ static int xilinx_vdma_probe(struct platform_device *pdev)
 				xilinx_vdma_free_chan_resources;
 	xdev->common.device_prep_interleaved_dma =
 				xilinx_vdma_dma_prep_interleaved;
-	xdev->common.device_control = xilinx_vdma_device_control;
+	xdev->common.device_terminate_all = xilinx_vdma_terminate_all;
 	xdev->common.device_tx_status = xilinx_vdma_tx_status;
 	xdev->common.device_issue_pending = xilinx_vdma_issue_pending;
 
-- 
2.1.1

