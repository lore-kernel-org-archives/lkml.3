Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936107Ab3DIOdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:33:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53124 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761535Ab3DIOde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:33:34 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
CC: Tony Lindgren <tony@atomide.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Peter Meerwald <pmeerw@pmeerw.net>, <patches@linaro.org>,
        <stable@vger.kernel.org.#.v3.7+>
Subject: [PATCH] dmaengine: omap-dma: Start DMA without delay for cyclic channels
Date: Tue, 9 Apr 2013 16:33:06 +0200
Message-ID: <1365517986-9401-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cyclic DMA is only used by audio which needs DMA to be started without a
delay.
If the DMA for audio is started using the tasklet we experience random
channel switch (to be more precise: channel shift).

Reported-by: Peter Meerwald <pmeerw@pmeerw.net>
CC: stable@vger.kernel.org  # v3.7+
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
Hi Vinod,

Would it be possible to send this patch for 3.9. The channel shift (or switch)
issue in audio has been noticed recently and it turns out that it has been
present since 3.7 kernel.
It would be great if 3.9 kernel could work correctly out of box...

Changes since RFCv2:
- added Acked-by from Santosh and Russell

Thank you,
Peter

 drivers/dma/omap-dma.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index 2ea3d7e..ec3fc4f 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -282,12 +282,20 @@ static void omap_dma_issue_pending(struct dma_chan *chan)
 
 	spin_lock_irqsave(&c->vc.lock, flags);
 	if (vchan_issue_pending(&c->vc) && !c->desc) {
-		struct omap_dmadev *d = to_omap_dma_dev(chan->device);
-		spin_lock(&d->lock);
-		if (list_empty(&c->node))
-			list_add_tail(&c->node, &d->pending);
-		spin_unlock(&d->lock);
-		tasklet_schedule(&d->task);
+		/*
+		 * c->cyclic is used only by audio and in this case the DMA need
+		 * to be started without delay.
+		 */
+		if (!c->cyclic) {
+			struct omap_dmadev *d = to_omap_dma_dev(chan->device);
+			spin_lock(&d->lock);
+			if (list_empty(&c->node))
+				list_add_tail(&c->node, &d->pending);
+			spin_unlock(&d->lock);
+			tasklet_schedule(&d->task);
+		} else {
+			omap_dma_start_desc(c);
+		}
 	}
 	spin_unlock_irqrestore(&c->vc.lock, flags);
 }
-- 
1.8.1.5

