Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaG2TAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:00:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:50402 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaG2TAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:00:45 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org
Subject: [PATCH 2/7] dmaengine: omap-dma: complete the transfer on terminate_all
Date: Tue, 29 Jul 2014 20:58:59 +0200
Message-Id: <1406660344-25307-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de>
References: <1406660344-25307-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rx path of the 8250_dma user in the RX-timeout case:
- it starts the RX transfer
- if the rx-timeout interrupt occures, it dmaengine_pause() the transfer
- step two is dmaengine_terminate_all() on this channel.
- the rx interrupt occures, it does not start the RX-transfer because
  according to dmaengine_tx_status() the status of the current transfer
  is still DMA_IN_PROGRESS because the earlier dmaengine_terminate_all()
  did not reset this.

To fix this problem, the patch adds dma_cookie_complete() "complete" the
current cookie.

Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Vinod Koul <vinod.koul@intel.com> 
Cc: Dan Williams <dan.j.williams@intel.com> 
Cc: dmaengine@vger.kernel.org 
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/dma/omap-dma.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index b19f04f..81ede01 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -970,6 +970,12 @@ static int omap_dma_terminate_all(struct omap_chan *c)
 
 	/* Prevent this channel being scheduled */
 	spin_lock(&d->lock);
+	if (!c->desc && !list_empty(&c->node)) {
+		struct virt_dma_desc *vd = vchan_next_desc(&c->vc);
+
+		if (vd)
+			dma_cookie_complete(&vd->tx);
+	}
 	list_del_init(&c->node);
 	spin_unlock(&d->lock);
 
@@ -979,6 +985,7 @@ static int omap_dma_terminate_all(struct omap_chan *c)
 	 * c->desc is NULL and exit.)
 	 */
 	if (c->desc) {
+		dma_cookie_complete(&c->desc->vd.tx);
 		c->desc = NULL;
 		/* Avoid stopping the dma twice */
 		if (!c->paused)
-- 
2.0.1

