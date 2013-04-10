Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936542Ab3DJOBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:01:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:55949 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936721Ab3DJN6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:58:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,447,1363158000"; 
   d="scan'208";a="284281386"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 1/9] serial: 8250_dma: TX cleanup
Date: Wed, 10 Apr 2013 16:58:24 +0300
Message-Id: <1365602312-25436-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing one unneeded uart_write_wakeup(). There is no need
to start PIO transfer unless DMA fails, so this also changes
serial8250_tx_dma() to return 0 unless that is the case.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dma.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index b9f7fd2..ce2518d 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -33,10 +33,8 @@ static void __dma_tx_complete(void *param)
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&p->port);
 
-	if (!uart_circ_empty(xmit) && !uart_tx_stopped(&p->port)) {
+	if (!uart_circ_empty(xmit) && !uart_tx_stopped(&p->port))
 		serial8250_tx_dma(p);
-		uart_write_wakeup(&p->port);
-	}
 }
 
 static void __dma_rx_complete(void *param)
@@ -67,12 +65,11 @@ int serial8250_tx_dma(struct uart_8250_port *p)
 	struct circ_buf			*xmit = &p->port.state->xmit;
 	struct dma_async_tx_descriptor	*desc;
 
-	if (dma->tx_running)
-		return -EBUSY;
+	if (uart_tx_stopped(&p->port) || dma->tx_running ||
+	    uart_circ_empty(xmit))
+		return 0;
 
 	dma->tx_size = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
-	if (!dma->tx_size)
-		return -EINVAL;
 
 	desc = dmaengine_prep_slave_single(dma->txchan,
 					   dma->tx_addr + xmit->tail,
-- 
1.7.10.4

