Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbaDNLpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:45:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59825 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbaDNLmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:42:55 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>,
        <joelf@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH v3 08/10] dmaengine: edma: Prefix debug prints where the text were identical in prep callbacks
Date: Mon, 14 Apr 2014 14:42:03 +0300
Message-ID: <1397475725-5036-9-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
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
Acked-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 6d9edc47150d..bc8175c92e0c 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -436,14 +436,14 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
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
 
@@ -459,7 +459,8 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 						EDMA_SLOT_ANY);
 			if (echan->slot[i] < 0) {
 				kfree(edesc);
-				dev_err(dev, "Failed to allocate slot\n");
+				dev_err(dev, "%s: Failed to allocate slot\n",
+					__func__);
 				return NULL;
 			}
 		}
@@ -528,7 +529,7 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
 	}
 
 	if (dev_width == DMA_SLAVE_BUSWIDTH_UNDEFINED) {
-		dev_err(dev, "Undefined slave buswidth\n");
+		dev_err(dev, "%s: Undefined slave buswidth\n", __func__);
 		return NULL;
 	}
 
@@ -553,7 +554,7 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
 	edesc = kzalloc(sizeof(*edesc) + nslots *
 		sizeof(edesc->pset[0]), GFP_ATOMIC);
 	if (!edesc) {
-		dev_dbg(dev, "Failed to allocate a descriptor\n");
+		dev_err(dev, "%s: Failed to allocate a descriptor\n", __func__);
 		return NULL;
 	}
 
@@ -571,7 +572,8 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
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
1.9.2

