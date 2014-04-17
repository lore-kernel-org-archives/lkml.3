Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161220AbaDQF7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 01:59:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58829 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757103AbaDQF67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 01:58:59 -0400
From: Joel Fernandes <joelf@ti.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH] dmaengine: edma: No need save/restore interrupt flags during spin_lock in IRQ
Date: Thu, 17 Apr 2014 00:58:33 -0500
Message-ID: <1397714313-26561-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vchan lock in edma_callback is acquired in hard interrupt context. As
interrupts are already disabled, there's no point in save/restoring interrupt
mask bit or cpsr flags.

Get rid of flags local variable and use spin_lock instead of spin_lock_irqsave.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/dma/edma.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 91849aa..25a75e2 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -638,7 +638,6 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 	struct edma_chan *echan = data;
 	struct device *dev = echan->vchan.chan.device->dev;
 	struct edma_desc *edesc;
-	unsigned long flags;
 	struct edmacc_param p;
 
 	edesc = echan->edesc;
@@ -649,7 +648,7 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 
 	switch (ch_status) {
 	case EDMA_DMA_COMPLETE:
-		spin_lock_irqsave(&echan->vchan.lock, flags);
+		spin_lock(&echan->vchan.lock);
 
 		if (edesc) {
 			if (edesc->cyclic) {
@@ -665,11 +664,11 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 			}
 		}
 
-		spin_unlock_irqrestore(&echan->vchan.lock, flags);
+		spin_unlock(&echan->vchan.lock);
 
 		break;
 	case EDMA_DMA_CC_ERROR:
-		spin_lock_irqsave(&echan->vchan.lock, flags);
+		spin_lock(&echan->vchan.lock);
 
 		edma_read_slot(EDMA_CHAN_SLOT(echan->slot[0]), &p);
 
@@ -700,7 +699,7 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 			edma_trigger_channel(echan->ch_num);
 		}
 
-		spin_unlock_irqrestore(&echan->vchan.lock, flags);
+		spin_unlock(&echan->vchan.lock);
 
 		break;
 	default:
-- 
1.7.9.5

