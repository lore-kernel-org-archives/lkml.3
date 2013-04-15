Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab3DOCnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:43:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab3DOCni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [ 08/27] dmaengine: omap-dma: Start DMA without delay for cyclic channels
Date: Sun, 14 Apr 2013 19:43:07 -0700
Message-Id: <20130415024231.986725437@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit 765024697807ad1e1cac332aa891253ca4a339da upstream.

cyclic DMA is only used by audio which needs DMA to be started without a
delay.
If the DMA for audio is started using the tasklet we experience random
channel switch (to be more precise: channel shift).

Reported-by: Peter Meerwald <pmeerw@pmeerw.net>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/omap-dma.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -276,12 +276,20 @@ static void omap_dma_issue_pending(struc
 
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


