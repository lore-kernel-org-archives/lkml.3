Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbbAMQHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:07:13 -0500
Received: from mout.gmx.net ([212.227.15.15]:59329 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbbAMQHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:07:10 -0500
MIME-Version: 1.0
Message-ID: <trinity-2ff5fec6-196c-4ecc-9ec2-f1b223f0ea25-1421165228466@3capp-gmx-bs70>
From: "Michael Doswald" <michael.doswald@gmx.net>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 3.19-rc4: Fix race condition in i.MX serial port driver
Content-Type: text/plain; charset=UTF-8
Date: Tue, 13 Jan 2015 17:07:08 +0100
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: 8BIT
X-Priority: 3
X-Provags-ID: V03:K0:waNxa/Hm6cDXJWUniJDtgay3G0D20qC8qY0vwON47YK
 l/iOk2NbSMTKCmC+CqOfDWGI11Wu+Yaq1NgMMZAigBI2Aaa6uS
 fNgYXupiVs5vQvqx1+vl8fZd6AaOftR7yaqT0wZ2z0ML+EdJ/T
 eioqt+SlmA1x1n5NVUfXzy4QgqTYmptiPmp2Fc33yE6qs2QuzV
 nyyvDPX0jFrIMl/C2vnneTwPIVR3bgpKryMFfeIQAvLa2iwu8o
 JPAcnDwGYpWHgsp7sco7aolelbWmH86EX/+FxfY0GXWnlFOw0z yLf4q4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under pressure, the imx.c device driver may transfer the same data multiple
times. 

Reason: 
Function imx_dma_tx checks for an active DMA transfer by calling
dmaengine_tx_status. The return value may indicate that no transfer is 
running while the dma_tx_callback function is still being executed. In 
this case the xmit->tail pointer may not be updated to the correct value 
when imx_dma_tx initiates a new DMA transfer, which will result in a DMA
transfer with the same base address as the previous one.

Patch:
Use existing dma_is_txing variable to guard DMA transfer initiation instead
of dmaengine_tx_status. Clear dma_is_txing at the end of the DMA callback
function therefore extending the critical section where the port lock is
held. Critical section extension is in line with the callback function 
of other drivers, e.g. serial-tegra.c (tegra_uart_tx_dma_complete).
 
 
Signed-off-by: Michael Doswald <michael.doswald@gmx.net>
---
 drivers/tty/serial/imx.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 4c5e909..29e31b1 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -503,13 +503,10 @@ static void dma_tx_callback(void *data)
 
 	dma_unmap_sg(sport->port.dev, sgl, sport->dma_tx_nents, DMA_TO_DEVICE);
 
-	sport->dma_is_txing = 0;
-
 	/* update the stat */
 	spin_lock_irqsave(&sport->port.lock, flags);
 	xmit->tail = (xmit->tail + sport->tx_bytes) & (UART_XMIT_SIZE - 1);
 	sport->port.icount.tx += sport->tx_bytes;
-	spin_unlock_irqrestore(&sport->port.lock, flags);
 
 	dev_dbg(sport->port.dev, "we finish the TX DMA.\n");
 
@@ -518,8 +515,10 @@ static void dma_tx_callback(void *data)
 	if (waitqueue_active(&sport->dma_wait)) {
 		wake_up(&sport->dma_wait);
 		dev_dbg(sport->port.dev, "exit in %s.\n", __func__);
-		return;
 	}
+
+	sport->dma_is_txing = 0;
+	spin_unlock_irqrestore(&sport->port.lock, flags);
 }
 
 static void imx_dma_tx(struct imx_port *sport)
@@ -529,11 +528,9 @@ static void imx_dma_tx(struct imx_port *sport)
 	struct dma_async_tx_descriptor *desc;
 	struct dma_chan	*chan = sport->dma_chan_tx;
 	struct device *dev = sport->port.dev;
-	enum dma_status status;
 	int ret;
 
-	status = dmaengine_tx_status(chan, (dma_cookie_t)0, NULL);
-	if (DMA_IN_PROGRESS == status)
+	if (sport->dma_is_txing)
 		return;
 
 	sport->tx_bytes = uart_circ_chars_pending(xmit);
-- 
1.9.1


 
 
