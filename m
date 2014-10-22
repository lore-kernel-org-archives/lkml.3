Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaJVQE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:04:59 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53988 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754527AbaJVPpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:31 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 24/59] dmaengine: intel-mid-dma: Split device_control
Date: Wed, 22 Oct 2014 17:43:38 +0200
Message-Id: <1413992653-21963-25-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Intel MID DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/intel_mid_dma.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 1aab8130efa1..5aaead9b56f7 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -492,10 +492,10 @@ static enum dma_status intel_mid_dma_tx_status(struct dma_chan *chan,
 	return ret;
 }
 
-static int dma_slave_control(struct dma_chan *chan, unsigned long arg)
+static int intel_mid_dma_config(struct dma_chan *chan,
+				struct dma_slave_config *slave)
 {
 	struct intel_mid_dma_chan	*midc = to_intel_mid_dma_chan(chan);
-	struct dma_slave_config  *slave = (struct dma_slave_config *)arg;
 	struct intel_mid_dma_slave *mid_slave;
 
 	BUG_ON(!midc);
@@ -509,28 +509,14 @@ static int dma_slave_control(struct dma_chan *chan, unsigned long arg)
 	midc->mid_slave = mid_slave;
 	return 0;
 }
-/**
- * intel_mid_dma_device_control -	DMA device control
- * @chan: chan for DMA control
- * @cmd: control cmd
- * @arg: cmd arg value
- *
- * Perform DMA control command
- */
-static int intel_mid_dma_device_control(struct dma_chan *chan,
-			enum dma_ctrl_cmd cmd, unsigned long arg)
+
+static int intel_mid_dma_terminate_all(struct dma_chan *chan)
 {
 	struct intel_mid_dma_chan	*midc = to_intel_mid_dma_chan(chan);
 	struct middma_device	*mid = to_middma_device(chan->device);
 	struct intel_mid_dma_desc	*desc, *_desc;
 	union intel_mid_dma_cfg_lo cfg_lo;
 
-	if (cmd == DMA_SLAVE_CONFIG)
-		return dma_slave_control(chan, arg);
-
-	if (cmd != DMA_TERMINATE_ALL)
-		return -ENXIO;
-
 	spin_lock_bh(&midc->lock);
 	if (midc->busy == false) {
 		spin_unlock_bh(&midc->lock);
@@ -1148,7 +1134,8 @@ static int mid_setup_dma(struct pci_dev *pdev)
 	dma->common.device_prep_dma_memcpy = intel_mid_dma_prep_memcpy;
 	dma->common.device_issue_pending = intel_mid_dma_issue_pending;
 	dma->common.device_prep_slave_sg = intel_mid_dma_prep_slave_sg;
-	dma->common.device_control = intel_mid_dma_device_control;
+	dma->common.device_config = intel_mid_dma_config;
+	dma->common.device_terminate_all = intel_mid_dma_terminate_all;
 
 	/*enable dma cntrl*/
 	iowrite32(REG_BIT0, dma->dma_base + DMA_CFG);
-- 
2.1.1

