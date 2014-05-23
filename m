Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaEWF74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 01:59:56 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:44805
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751919AbaEWF7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 01:59:53 -0400
From: Huang Shijie <b32955@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH 1/2 rebased] serial: imx: remove the DMA wait queue
Date: Fri, 23 May 2014 12:40:40 +0800
Message-ID: <1400820040-21396-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1400819575-20435-1-git-send-email-b32955@freescale.com>
References: <1400819575-20435-1-git-send-email-b32955@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(80022001)(44976005)(19580405001)(50986999)(77982001)(76482001)(6806004)(19580395003)(33646001)(83322001)(4396001)(74662001)(93916002)(77096999)(76176999)(87286001)(89996001)(31966008)(88136002)(62966002)(21056001)(81342001)(87936001)(81542001)(50226001)(26826002)(83072002)(79102001)(48376002)(102836001)(74502001)(47776003)(92726001)(99396002)(64706001)(92566001)(77156001)(50466002)(36756003)(20776003)(46102001)(85852003)(42262001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB425;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:gate-tx3.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0220D4B98D
Authentication-Results: spf=fail (sender IP is 192.88.168.1)
 smtp.mailfrom=shijie.huang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA wait queue makes the code very complicated:
  For RX, the @->stop_rx hook does not really stop the RX;
  For TX, the @->stop_tx hook does not really stop the TX.

The above make the imx_shutdown has to wait the RX/TX DMA to be finished.

In order to make code more simple, this patch removes the DMA wait queue.
By calling the dmaengine_terminate_all, this patch makes the RX stops
immediately after we call the @->stop_rx hook, so does the TX.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
rebase this patch on the linux-next.
---
 drivers/tty/serial/imx.c |   42 ++++++++++++++----------------------------
 1 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index febf400..366f169 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -225,7 +225,6 @@ struct imx_port {
 	void			*rx_buf;
 	unsigned int		tx_bytes;
 	unsigned int		dma_tx_nents;
-	wait_queue_head_t	dma_wait;
 };
 
 struct imx_port_ucrs {
@@ -416,12 +415,10 @@ static void imx_stop_tx(struct uart_port *port)
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
 	writel(temp & ~UCR1_TXMPTYEN, sport->port.membase + UCR1);
@@ -435,12 +432,10 @@ static void imx_stop_rx(struct uart_port *port)
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
 	writel(temp & ~UCR2_RXEN, sport->port.membase + UCR2);
@@ -497,12 +492,6 @@ static void dma_tx_callback(void *data)
 	dev_dbg(sport->port.dev, "we finish the TX DMA.\n");
 
 	uart_write_wakeup(&sport->port);
-
-	if (waitqueue_active(&sport->dma_wait)) {
-		wake_up(&sport->dma_wait);
-		dev_dbg(sport->port.dev, "exit in %s.\n", __func__);
-		return;
-	}
 }
 
 static void imx_dma_tx(struct imx_port *sport)
@@ -875,10 +864,6 @@ static void imx_rx_dma_done(struct imx_port *sport)
 	writel(temp, sport->port.membase + UCR1);
 
 	sport->dma_is_rxing = 0;
-
-	/* Is the shutdown waiting for us? */
-	if (waitqueue_active(&sport->dma_wait))
-		wake_up(&sport->dma_wait);
 }
 
 /*
@@ -1025,8 +1010,6 @@ static void imx_enable_dma(struct imx_port *sport)
 {
 	unsigned long temp;
 
-	init_waitqueue_head(&sport->dma_wait);
-
 	/* set UCR1 */
 	temp = readl(sport->port.membase + UCR1);
 	temp |= UCR1_RDMAEN | UCR1_TDMAEN | UCR1_ATDMAEN |
@@ -1218,10 +1201,13 @@ static void imx_shutdown(struct uart_port *port)
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

