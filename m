Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936095AbaFIJR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:17:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58398 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754822AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Loic Poulain <loic.poulain@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 022/146] serial: 8250: Fix thread unsafe __dma_tx_complete function
Date: Mon,  9 Jun 2014 10:49:17 +0200
Message-Id: <e5ffcda2cdc477940a4f86ff7f60316d4d3703f6.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Poulain <loic.poulain@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f8fd1b0350d3a4581125f5eda6528f5a2c5f9183 upstream.

__dma_tx_complete is not protected against concurrent
call of serial8250_tx_dma. it can lead to circular tail
index corruption or parallel call of serial_tx_dma on the
same data portion.

This patch fixes this issue by holding the port lock.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/8250/8250_dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 7046769608d4..ab9096dc3849 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -20,12 +20,15 @@ static void __dma_tx_complete(void *param)
 	struct uart_8250_port	*p = param;
 	struct uart_8250_dma	*dma = p->dma;
 	struct circ_buf		*xmit = &p->port.state->xmit;
-
-	dma->tx_running = 0;
+	unsigned long	flags;
 
 	dma_sync_single_for_cpu(dma->txchan->device->dev, dma->tx_addr,
 				UART_XMIT_SIZE, DMA_TO_DEVICE);
 
+	spin_lock_irqsave(&p->port.lock, flags);
+
+	dma->tx_running = 0;
+
 	xmit->tail += dma->tx_size;
 	xmit->tail &= UART_XMIT_SIZE - 1;
 	p->port.icount.tx += dma->tx_size;
@@ -35,6 +38,8 @@ static void __dma_tx_complete(void *param)
 
 	if (!uart_circ_empty(xmit) && !uart_tx_stopped(&p->port))
 		serial8250_tx_dma(p);
+
+	spin_unlock_irqrestore(&p->port.lock, flags);
 }
 
 static void __dma_rx_complete(void *param)
-- 
1.9.3

