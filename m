Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaIJTj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:39:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:35533 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaIJTj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:39:28 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Joel Fernandes <joelf@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC] ARM: edma: unconditionally ack the error interrupt
Date: Wed, 10 Sep 2014 21:39:20 +0200
Message-Id: <1410377960-26921-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 8250-dma, 8250-omap and am335x I observe the following:

- start a RX transfer which will finish once the FIFO has enough data
- The TX side starts a large TX transfer, say 1244 bytes. It takes approx
  102ms for the transfer to complete
- cancel the RX transfer & start the RX transfer a few times
- the TX transfer completes. dma_irq_handler() notices this and
  schedules the completion callback
- dma_ccerr_handler() is invoked. It returns IRQ_NONE because all four
  checked registers return 0.
- the last irq handler is repeated a few times until the irq core shuts it
  down.

I see the above describes pattern also without dma_ccerr_handler()
beeing invoked. But if it is invoked, it always _after_ the dma interrupt
handler for the TX handler was handled. If I disable TX-DMA for the UART
then I don't see this dma_ccerr_handler() at all.

Testing longer I see two addition scenarios of dma_ccerr_handler():
- EDMA_EMR0 reports 0x04000000 (the channel used by TX-UART).
  edma_callback() reports "looks like slot is null". Looks harmless.
- EDMA_EMR0 reports the same values but later in the loop where a match
  search again EDMA_EMR0 reports 0 and so thing is done.

Since it looks like the EDMA_EMR0 is loosing its content before the
dma_ccerr_handler() is invoked, I suggest to unconditionally ack the
interrupt so the irq core does not shut it down.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/common/edma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 88099175fc56..b31f3b7b3851 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -432,8 +432,10 @@ static irqreturn_t dma_ccerr_handler(int irq, void *data)
 	if ((edma_read_array(ctlr, EDMA_EMR, 0) == 0) &&
 	    (edma_read_array(ctlr, EDMA_EMR, 1) == 0) &&
 	    (edma_read(ctlr, EDMA_QEMR) == 0) &&
-	    (edma_read(ctlr, EDMA_CCERR) == 0))
+	    (edma_read(ctlr, EDMA_CCERR) == 0)) {
+		edma_write(ctlr, EDMA_EEVAL, 1);
 		return IRQ_NONE;
+	}
 
 	while (1) {
 		int j = -1;
-- 
2.1.0

