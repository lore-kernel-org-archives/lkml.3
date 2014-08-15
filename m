Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaHOSFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:05:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:57834 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaHOSFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:05:17 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 12/15] tty: serial: 8250_dma: add pm runtime
Date: Fri, 15 Aug 2014 19:42:40 +0200
Message-Id: <1408124563-31541-13-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is nothing to do for RPM in the RX path. If the HW goes off then it
won't assert the DMA line and the transfer won't happen. So we hope that
the HW does not go off for RX to work (DMA or PIO makes no difference
here).

For TX the situation is slightly different. RPM is enabled on
start_tx(). We can't disable RPM on DMA complete callback because there
is still data in the FIFO which is being sent. We have to wait until
the FIFO is empty before we disable it.
For this to happen we fake a TX sent error and enable THRI. Once the
FIFO is empty we receive an interrupt and since the TTY-buffer is still
empty we "put RPM" via __stop_tx(). Should it been filed then in the
start_tx() path we should program the DMA transfer and remove the error
flag and the THRI bit.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_dma.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index cfc83d4..8a26024 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -21,6 +21,7 @@ static void __dma_tx_complete(void *param)
 	struct uart_8250_dma	*dma = p->dma;
 	struct circ_buf		*xmit = &p->port.state->xmit;
 	unsigned long	flags;
+	bool en_thri = false;
 
 	dma_sync_single_for_cpu(dma->txchan->device->dev, dma->tx_addr,
 				UART_XMIT_SIZE, DMA_TO_DEVICE);
@@ -40,11 +41,16 @@ static void __dma_tx_complete(void *param)
 		int ret;
 
 		ret = serial8250_tx_dma(p);
-		if (ret) {
-			p->dma_tx_err = 1;
-			p->ier |= UART_IER_THRI;
-			serial_port_out(&p->port, UART_IER, p->ier);
-		}
+		if (ret)
+			en_thri = true;
+
+	} else if (p->capabilities & UART_CAP_RPM)
+		en_thri = true;
+
+	if (en_thri) {
+		p->dma_tx_err = 1;
+		p->ier |= UART_IER_THRI;
+		serial_port_out(&p->port, UART_IER, p->ier);
 	}
 
 	spin_unlock_irqrestore(&p->port.lock, flags);
-- 
2.0.1

