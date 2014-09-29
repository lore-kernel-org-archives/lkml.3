Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaI2SIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:08:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:53258 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbaI2SHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:07:01 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        vinod.koul@intel.com
Subject: [PATCH 09/13] dmaengine: edma: check for echan->edesc => NULL in edma_dma_pause()
Date: Mon, 29 Sep 2014 20:06:45 +0200
Message-Id: <1412014009-13315-10-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I added book keeping of whether or not the 8250-dma driver has an RX
transfer pending or not so we don't BUG here if it calls
dmaengine_pause() on a channel which has not a pending transfer. Guess
what, this is not enough.
The following can be triggered with a busy RX channel and hackbench in
background:
- DMA transfer completes. The callback is delayed via
  vchan_cookie_complete() into a tasklet so it das not happen asap.
- hackbench keeps the system busy so the tasklet does not run "soon".
- the UART collected enough data and generates an "timeout"-interrupt.
  Since 8250-dma *thinks* the DMA-transfer is still pending it tries to
  cancel it via invoking dmaengine_pause() first. This causes the segfault
  because echan->edesc is NULL now that the transfer completed (however
  the callback did not run yet).

With this patch we don't BUG in the scenario described.

Cc: vinod.koul@intel.com
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/dma/edma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 7b65633f495e..123f578d6dd3 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -288,7 +288,7 @@ static int edma_slave_config(struct edma_chan *echan,
 static int edma_dma_pause(struct edma_chan *echan)
 {
 	/* Pause/Resume only allowed with cyclic mode */
-	if (!echan->edesc->cyclic)
+	if (!echan->edesc || !echan->edesc->cyclic)
 		return -EINVAL;
 
 	edma_pause(echan->ch_num);
-- 
2.1.0

