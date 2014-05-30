Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaE3J1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:27:32 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:63191 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaE3J13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:27:29 -0400
From: "Wang, Jiada (ESD)" <Jiada_Wang@mentor.com>
To: Huang Shijie <b32955@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Behme, Dirk - Bosch" <dirk.behme@de.bosch.com>
Subject: RE: [PATCH 1/2] serial: imx: remove the DMA wait queue
Thread-Topic: [PATCH 1/2] serial: imx: remove the DMA wait queue
Thread-Index: AQHPdktjQjLgiywSm02dMUAQiefQ6ZtYv2xw
Date: Fri, 30 May 2014 09:27:20 +0000
Message-ID: <857E9EDCA6C0904DB3357321AA9123EBE14B5A2C@NA-MBX-03.mgc.mentorg.com>
References: <1400819575-20435-1-git-send-email-b32955@freescale.com>
In-Reply-To: <1400819575-20435-1-git-send-email-b32955@freescale.com>
Accept-Language: en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [147.34.91.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 30 May 2014 09:27:21.0597 (UTC) FILETIME=[5BDEFAD0:01CF7BE9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shijie

After apply this patch into our kernel,
We are facing data hang issue when sending big size file (2M used in test) to uart port
Note: Rx port is also keep receiving data.

After read the implementation of uart_stop(),
I feel like, stop_tx() is used to perform flow control when like a XOFF is received.
Which means no data should be dropped, as they may need to be sent out,
When next start_tx() is called.

But by calling dmaengine_termiate_all(), the data already be submitted to DMA engine,
May be lost, thus cause data hang.

What do you think?

Thanks,
Jiada

-----Original Message-----
From: linux-arm-kernel [mailto:linux-arm-kernel-bounces@lists.infradead.org] On Behalf Of Huang Shijie
Sent: Friday, May 23, 2014 1:33 PM
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org; Huang Shijie; linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org
Subject: [PATCH 1/2] serial: imx: remove the DMA wait queue

The DMA wait queue makes the code very complicated:
  For RX, the @->stop_rx hook does not really stop the RX;
  For TX, the @->stop_tx hook does not really stop the TX.

The above make the imx_shutdown has to wait the RX/TX DMA to be finished.

In order to make code more simple, this patch removes the DMA wait queue.
By calling the dmaengine_terminate_all, this patch makes the RX stops immediately after we call the @->stop_rx hook, so does the TX.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/tty/serial/imx.c |   42 ++++++++++++++----------------------------
 1 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c index d1f16d3..ed6cdf7 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -225,7 +225,6 @@ struct imx_port {
 	void			*rx_buf;
 	unsigned int		tx_bytes;
 	unsigned int		dma_tx_nents;
-	wait_queue_head_t	dma_wait;
 	unsigned int            saved_reg[11];
 };
 
@@ -417,12 +416,10 @@ static void imx_stop_tx(struct uart_port *port)
 		return;
 	}
 
-	/*
-	 * We are maybe in the SMP context, so if the DMA TX thread is running
-	 * on other cpu, we have to wait for it to finish.
-	 */
-	if (sport->dma_is_enabled && sport->dma_is_txing)
-		return;
+	if (sport->dma_is_enabled && sport->dma_is_txing) {
+		dmaengine_terminate_all(sport->dma_chan_tx);
+		sport->dma_is_txing = 0;
+	}
 
 	temp = readl(sport->port.membase + UCR1);
 	writel(temp & ~UCR1_TXMPTYEN, sport->port.membase + UCR1); @@ -436,12 +433,10 @@ static void imx_stop_rx(struct uart_port *port)
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long temp;
 
-	/*
-	 * We are maybe in the SMP context, so if the DMA TX thread is running
-	 * on other cpu, we have to wait for it to finish.
-	 */
-	if (sport->dma_is_enabled && sport->dma_is_rxing)
-		return;
+	if (sport->dma_is_enabled && sport->dma_is_rxing) {
+		dmaengine_terminate_all(sport->dma_chan_rx);
+		sport->dma_is_rxing = 0;
+	}
 
 	temp = readl(sport->port.membase + UCR2);
 	writel(temp & ~UCR2_RXEN, sport->port.membase + UCR2); @@ -498,12 +493,6 @@ static void dma_tx_callback(void *data)
 	dev_dbg(sport->port.dev, "we finish the TX DMA.\n");
 
 	uart_write_wakeup(&sport->port);
-
-	if (waitqueue_active(&sport->dma_wait)) {
-		wake_up(&sport->dma_wait);
-		dev_dbg(sport->port.dev, "exit in %s.\n", __func__);
-		return;
-	}
 }
 
 static void imx_dma_tx(struct imx_port *sport) @@ -876,10 +865,6 @@ static void imx_rx_dma_done(struct imx_port *sport)
 	writel(temp, sport->port.membase + UCR1);
 
 	sport->dma_is_rxing = 0;
-
-	/* Is the shutdown waiting for us? */
-	if (waitqueue_active(&sport->dma_wait))
-		wake_up(&sport->dma_wait);
 }
 
 /*
@@ -1026,8 +1011,6 @@ static void imx_enable_dma(struct imx_port *sport)  {
 	unsigned long temp;
 
-	init_waitqueue_head(&sport->dma_wait);
-
 	/* set UCR1 */
 	temp = readl(sport->port.membase + UCR1);
 	temp |= UCR1_RDMAEN | UCR1_TDMAEN | UCR1_ATDMAEN | @@ -1219,10 +1202,13 @@ static void imx_shutdown(struct uart_port *port)
 	unsigned long flags;
 
 	if (sport->dma_is_enabled) {
-		/* We have to wait for the DMA to finish. */
-		wait_event(sport->dma_wait,
-			!sport->dma_is_rxing && !sport->dma_is_txing);
+		/*
+		 * The upper layer may does not call the @->stop_tx and
+		 * @->stop_rx, so we call them ourselves.
+		 */
+		imx_stop_tx(port);
 		imx_stop_rx(port);
+
 		imx_disable_dma(sport);
 		imx_uart_dma_exit(sport);
 	}
--
1.7.8


_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
