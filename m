Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbaFJUbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:31:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35000 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbaFJTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:47:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Loic Poulain <loic.poulain@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 087/160] serial: 8250: Fix thread unsafe __dma_tx_complete function
Date: Tue, 10 Jun 2014 12:45:27 -0700
Message-Id: <1402429600-20477-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@intel.com>

commit f8fd1b0350d3a4581125f5eda6528f5a2c5f9183 upstream.

__dma_tx_complete is not protected against concurrent
call of serial8250_tx_dma. it can lead to circular tail
index corruption or parallel call of serial_tx_dma on the
same data portion.

This patch fixes this issue by holding the port lock.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/8250/8250_dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 7046769..ab9096d 100644
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
1.9.1

