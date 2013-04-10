Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936894Ab3DJOBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:01:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:20948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936729Ab3DJN6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:58:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,447,1363158000"; 
   d="scan'208";a="284281393"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 2/9] serial: 8250_dma: Fix RX handling
Date: Wed, 10 Apr 2013 16:58:25 +0300
Message-Id: <1365602312-25436-3-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overrun, parity and framing errors should be handled in
8250_core. This also adds check for the dma_status and exits
if the channel is not idle.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dma.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index ce2518d..6643061 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -101,20 +101,29 @@ int serial8250_rx_dma(struct uart_8250_port *p, unsigned int iir)
 	struct dma_tx_state		state;
 	int				dma_status;
 
-	/*
-	 * If RCVR FIFO trigger level was not reached, complete the transfer and
-	 * let 8250.c copy the remaining data.
-	 */
-	if ((iir & 0x3f) == UART_IIR_RX_TIMEOUT) {
-		dma_status = dmaengine_tx_status(dma->rxchan, dma->rx_cookie,
-						&state);
+	dma_status = dmaengine_tx_status(dma->rxchan, dma->rx_cookie, &state);
+
+	switch (iir & 0x3f) {
+	case UART_IIR_RLSI:
+		/* 8250_core handles errors and break interrupts */
+		return -EIO;
+	case UART_IIR_RX_TIMEOUT:
+		/*
+		 * If RCVR FIFO trigger level was not reached, complete the
+		 * transfer and let 8250_core copy the remaining data.
+		 */
 		if (dma_status == DMA_IN_PROGRESS) {
 			dmaengine_pause(dma->rxchan);
 			__dma_rx_complete(p);
 		}
 		return -ETIMEDOUT;
+	default:
+		break;
 	}
 
+	if (dma_status)
+		return 0;
+
 	desc = dmaengine_prep_slave_single(dma->rxchan, dma->rx_addr,
 					   dma->rx_size, DMA_DEV_TO_MEM,
 					   DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
-- 
1.7.10.4

