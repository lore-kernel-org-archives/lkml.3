Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3CZXHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:07:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab3CZXCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:02:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 16/49] sfc: Properly sync RX DMA buffer when it is not the last in the page
Date: Tue, 26 Mar 2013 16:01:13 -0700
Message-Id: <20130326225841.246449143@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit 3a68f19d7afb80f548d016effbc6ed52643a8085 ]

We may currently allocate two RX DMA buffers to a page, and only unmap
the page when the second is completed.  We do not sync the first RX
buffer to be completed; this can result in packet loss or corruption
if the last RX buffer completed in a NAPI poll is the first in a page
and is not DMA-coherent.  (In the middle of a NAPI poll, we will
handle the following RX completion and unmap the page *before* looking
at the content of the first buffer.)

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
[bwh: Backported to 3.0: adjust context]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/sfc/rx.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/net/sfc/rx.c
+++ b/drivers/net/sfc/rx.c
@@ -245,7 +245,8 @@ static int efx_init_rx_buffers_page(stru
 }
 
 static void efx_unmap_rx_buffer(struct efx_nic *efx,
-				struct efx_rx_buffer *rx_buf)
+				struct efx_rx_buffer *rx_buf,
+				unsigned int used_len)
 {
 	if (rx_buf->is_page && rx_buf->u.page) {
 		struct efx_rx_page_state *state;
@@ -256,6 +257,10 @@ static void efx_unmap_rx_buffer(struct e
 				       state->dma_addr,
 				       efx_rx_buf_size(efx),
 				       PCI_DMA_FROMDEVICE);
+		} else if (used_len) {
+			dma_sync_single_for_cpu(&efx->pci_dev->dev,
+						rx_buf->dma_addr, used_len,
+						DMA_FROM_DEVICE);
 		}
 	} else if (!rx_buf->is_page && rx_buf->u.skb) {
 		pci_unmap_single(efx->pci_dev, rx_buf->dma_addr,
@@ -278,7 +283,7 @@ static void efx_free_rx_buffer(struct ef
 static void efx_fini_rx_buffer(struct efx_rx_queue *rx_queue,
 			       struct efx_rx_buffer *rx_buf)
 {
-	efx_unmap_rx_buffer(rx_queue->efx, rx_buf);
+	efx_unmap_rx_buffer(rx_queue->efx, rx_buf, 0);
 	efx_free_rx_buffer(rx_queue->efx, rx_buf);
 }
 
@@ -549,10 +554,10 @@ void efx_rx_packet(struct efx_rx_queue *
 		goto out;
 	}
 
-	/* Release card resources - assumes all RX buffers consumed in-order
-	 * per RX queue
+	/* Release and/or sync DMA mapping - assumes all RX buffers
+	 * consumed in-order per RX queue
 	 */
-	efx_unmap_rx_buffer(efx, rx_buf);
+	efx_unmap_rx_buffer(efx, rx_buf, len);
 
 	/* Prefetch nice and early so data will (hopefully) be in cache by
 	 * the time we look at it.


