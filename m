Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaCMJT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:19:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57541 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752AbaCMJT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:19:56 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <nsekhar@ti.com>,
        Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: [PATCH 11/18] dma: edma: Prefix debug prints where the text were identical in prep callbacks
Date: Thu, 13 Mar 2014 11:18:33 +0200
Message-ID: <1394702320-21743-12-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
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
index e2aa42b8342f..07ac5f4eeb56 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -430,14 +430,14 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
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
 
@@ -453,7 +453,8 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 						EDMA_SLOT_ANY);
 			if (echan->slot[i] < 0) {
 				kfree(edesc);
-				dev_err(dev, "Failed to allocate slot\n");
+				dev_err(dev, "%s: Failed to allocate slot\n",
+					__func__);
 				return NULL;
 			}
 		}
@@ -522,7 +523,7 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
 	}
 
 	if (dev_width == DMA_SLAVE_BUSWIDTH_UNDEFINED) {
-		dev_err(dev, "Undefined slave buswidth\n");
+		dev_err(dev, "%s: Undefined slave buswidth\n", __func__);
 		return NULL;
 	}
 
@@ -547,7 +548,7 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
 	edesc = kzalloc(sizeof(*edesc) + nslots *
 		sizeof(edesc->pset[0]), GFP_ATOMIC);
 	if (!edesc) {
-		dev_dbg(dev, "Failed to allocate a descriptor\n");
+		dev_err(dev, "%s: Failed to allocate a descriptor\n", __func__);
 		return NULL;
 	}
 
@@ -565,7 +566,8 @@ static struct dma_async_tx_descriptor *edma_prep_dma_cyclic(
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
1.9.0

