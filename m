Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbaJCWaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:30:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbaJCW3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:29:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Petallo, MauriceX R" <mauricex.r.petallo@intel.com>
Subject: [PATCH 3.10 135/143] serial: 8250_dma: check the result of TX buffer mapping
Date: Fri,  3 Oct 2014 14:35:30 -0700
Message-Id: <20141003213318.528372443@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit d4089a332883ad969700aac5dd4dd5f1c4fee825 upstream.

Using dma_mapping_error() to make sure the mapping did not
fail.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: "Petallo, MauriceX R" <mauricex.r.petallo@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_dma.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -192,21 +192,28 @@ int serial8250_request_dma(struct uart_8
 
 	dma->rx_buf = dma_alloc_coherent(dma->rxchan->device->dev, dma->rx_size,
 					&dma->rx_addr, GFP_KERNEL);
-	if (!dma->rx_buf) {
-		dma_release_channel(dma->rxchan);
-		dma_release_channel(dma->txchan);
-		return -ENOMEM;
-	}
+	if (!dma->rx_buf)
+		goto err;
 
 	/* TX buffer */
 	dma->tx_addr = dma_map_single(dma->txchan->device->dev,
 					p->port.state->xmit.buf,
 					UART_XMIT_SIZE,
 					DMA_TO_DEVICE);
+	if (dma_mapping_error(dma->txchan->device->dev, dma->tx_addr)) {
+		dma_free_coherent(dma->rxchan->device->dev, dma->rx_size,
+				  dma->rx_buf, dma->rx_addr);
+		goto err;
+	}
 
 	dev_dbg_ratelimited(p->port.dev, "got both dma channels\n");
 
 	return 0;
+err:
+	dma_release_channel(dma->rxchan);
+	dma_release_channel(dma->txchan);
+
+	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(serial8250_request_dma);
 


