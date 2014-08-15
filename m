Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaHORnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:43:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:57639 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaHORm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:42:58 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 08/15] dmaengine: edma: fix two faults which happen with the 8250_dma user
Date: Fri, 15 Aug 2014 19:42:36 +0200
Message-Id: <1408124563-31541-9-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rx path of the 8250_dma user in the RX-timeout case:
- it starts the RX transfer
  if the rx-timeout interrupt occurs, it dmaengine_pause() the transfer
- step two is dmaengine_terminate_all() on this channel.
- based on dmaengine_tx_status() it learns the number of transferred
  bytes.
- the rx interrupt occurs, it does not start the RX-transfer because
  according to dmaengine_tx_status() the status of the current transfer
  is still DMA_IN_PROGRESS because the earlier dmaengine_terminate_all()
  did not reset this.
- on rx-timeout it invokes dmaengine_pause() again. This time, it
  segfaults because the channel has no descriptor yet.

To make the upper case work better, this patch adds dma_cookie_complete()
to complete the cookie. Also it adds is an additional check for echan->edesc
in case the channel has no descriptor assigned.

Cc: Joel Fernandes <joelf@ti.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/dma/edma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index d08c4de..ff05dd4 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -256,6 +256,7 @@ static int edma_terminate_all(struct edma_chan *echan)
 	 * echan->edesc is NULL and exit.)
 	 */
 	if (echan->edesc) {
+		dma_cookie_complete(&echan->edesc->vdesc.tx);
 		echan->edesc = NULL;
 		edma_stop(echan->ch_num);
 	}
@@ -282,7 +283,7 @@ static int edma_slave_config(struct edma_chan *echan,
 static int edma_dma_pause(struct edma_chan *echan)
 {
 	/* Pause/Resume only allowed with cyclic mode */
-	if (!echan->edesc->cyclic)
+	if (!echan->edesc || !echan->edesc->cyclic)
 		return -EINVAL;
 
 	edma_pause(echan->ch_num);
-- 
2.0.1

