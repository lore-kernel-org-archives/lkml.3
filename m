Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaDANKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:10:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54426 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbaDANHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:07:10 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: [PATCH v2 09/14] dma: edma: Implement device_slave_caps callback
Date: Tue, 1 Apr 2014 16:06:10 +0300
Message-ID: <1396357575-30585-10-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the callback implemented omap-dma can provide information to client
drivers regarding to supported address widths, directions, residue
granularity, etc.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 10048b40fac8..855766672aa9 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -855,6 +855,23 @@ static void __init edma_chan_init(struct edma_cc *ecc,
 	}
 }
 
+#define EDMA_DMA_BUSWIDTHS	(BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) | \
+				 BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) | \
+				 BIT(DMA_SLAVE_BUSWIDTH_4_BYTES))
+
+static int edma_dma_device_slave_caps(struct dma_chan *dchan,
+				      struct dma_slave_caps *caps)
+{
+	caps->src_addr_widths = EDMA_DMA_BUSWIDTHS;
+	caps->dstn_addr_widths = EDMA_DMA_BUSWIDTHS;
+	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	caps->cmd_pause = true;
+	caps->cmd_terminate = true;
+	caps->residue_granularity = DMA_RESIDUE_GRANULARITY_DESCRIPTOR;
+
+	return 0;
+}
+
 static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 			  struct device *dev)
 {
@@ -865,6 +882,7 @@ static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 	dma->device_issue_pending = edma_issue_pending;
 	dma->device_tx_status = edma_tx_status;
 	dma->device_control = edma_control;
+	dma->device_slave_caps = edma_dma_device_slave_caps;
 	dma->dev = dev;
 
 	INIT_LIST_HEAD(&dma->channels);
-- 
1.9.1

