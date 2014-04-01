Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaDANHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:07:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35325 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbaDANHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:07:18 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joelf@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: [PATCH v2 12/14] dma: edma: Prefix debug prints where the text were identical in prep callbacks
Date: Tue, 1 Apr 2014 16:06:13 +0300
Message-ID: <1396357575-30585-13-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prep_slave_sg and prep_dma_cyclic callbacks have mostly same failure cases
with the same texts printed in case we hit them. It helps when debugging if
we know exactly which callback generated the errors.
At the same time change the debug level for descriptor allocation failure
from dbg to err since all other error cases are dev_err and this failure is
similarly fatal as the other ones.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index e8de2e84a60a..7feb6231276e 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -434,14 +434,14 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 	}
 
 	if (dev_width == DMA_SLAVE_BUSWIDTH_UNDEFINED) {
-		dev_err(dev, "Undefined slave buswidth\n");
+		dev_err(dev, "%s: Undefined slave buswidth\n", __func__);
 		return NULL;
 	}
 
 	edesc = kzalloc(sizeof(*edesc) + sg_len *
 		sizeof(edesc->pset[0]), GFP_ATOMIC);
 	if (!edesc) {
-		dev_dbg(dev, "Failed to allocate a descriptor\n");
+		dev_err(dev, "%s: Failed to allocate a descriptor\n", __func__);
 		return NULL;
 	}
 
@@ -457,7 +457,8 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 						EDMA_SLOT_ANY);
 			if (echan->slot[i] < 0) {
 				kfree(edesc);
-				dev_err(dev, "Failed to allocate slot\n");
+				dev_err(dev, "%s: Failed to allocate slot\n",
+					__func__);
 				return NULL;
 			}
 		}
@@ -526,7 +527,7 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
 	}
 
 	if (dev_width == DMA_SLAVE_BUSWIDTH_UNDEFINED) {
-		dev_err(dev, "Undefined slave buswidth\n");
+		dev_err(dev, "%s: Undefined slave buswidth\n", __func__);
 		return NULL;
 	}
 
@@ -551,7 +552,7 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
 	edesc = kzalloc(sizeof(*edesc) + nslots *
 		sizeof(edesc->pset[0]), GFP_ATOMIC);
 	if (!edesc) {
-		dev_dbg(dev, "Failed to allocate a descriptor\n");
+		dev_err(dev, "%s: Failed to allocate a descriptor\n", __func__);
 		return NULL;
 	}
 
@@ -569,7 +570,8 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
 						EDMA_SLOT_ANY);
 			if (echan->slot[i] < 0) {
 				kfree(edesc);
-				dev_err(dev, "Failed to allocate slot\n");
+				dev_err(dev, "%s: Failed to allocate slot\n",
+					__func__);
 				return NULL;
 			}
 		}
-- 
1.9.1

