Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaJPKUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:20:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37378 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752582AbaJPKUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:20:19 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH v2 40/53] dmaengine: xilinx: Split device_control
Date: Thu, 16 Oct 2014 12:17:39 +0200
Message-Id: <1413454672-27400-41-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Xilinx VDMA driver to make use of the
newly introduced callbacks, that will eventually be used to retrieve slave
capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/xilinx/xilinx_vdma.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_vdma.c b/drivers/dma/xilinx/xilinx_vdma.c
index 42a13e8d4607..35024e7b9f9f 100644
--- a/drivers/dma/xilinx/xilinx_vdma.c
+++ b/drivers/dma/xilinx/xilinx_vdma.c
@@ -996,8 +996,10 @@ error:
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
 
@@ -1070,27 +1072,6 @@ int xilinx_vdma_channel_set_config(struct dma_chan *dchan,
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
@@ -1295,7 +1276,7 @@ static int xilinx_vdma_probe(struct platform_device *pdev)
 				xilinx_vdma_free_chan_resources;
 	xdev->common.device_prep_interleaved_dma =
 				xilinx_vdma_dma_prep_interleaved;
-	xdev->common.device_control = xilinx_vdma_device_control;
+	xdev->common.device_terminate_all = xilinx_vdma_terminate_all;
 	xdev->common.device_tx_status = xilinx_vdma_tx_status;
 	xdev->common.device_issue_pending = xilinx_vdma_issue_pending;
 
-- 
2.1.1

