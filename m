Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab3CYBQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:16:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34068 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756189Ab3CYBQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:13 -0400
Message-Id: <20130325010528.719100602@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:09 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 045/104] sfc: Properly sync RX DMA buffer when it is not the  last in the page
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/sfc/rx.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 5ef4cc0..b4d3cd5 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -246,7 +246,8 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 }
 
 static void efx_unmap_rx_buffer(struct efx_nic *efx,
-				struct efx_rx_buffer *rx_buf)
+				struct efx_rx_buffer *rx_buf,
+				unsigned int used_len)
 {
 	if (rx_buf->is_page && rx_buf->u.page) {
 		struct efx_rx_page_state *state;
@@ -257,6 +258,10 @@ static void efx_unmap_rx_buffer(struct efx_nic *efx,
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
@@ -279,7 +284,7 @@ static void efx_free_rx_buffer(struct efx_nic *efx,
 static void efx_fini_rx_buffer(struct efx_rx_queue *rx_queue,
 			       struct efx_rx_buffer *rx_buf)
 {
-	efx_unmap_rx_buffer(rx_queue->efx, rx_buf);
+	efx_unmap_rx_buffer(rx_queue->efx, rx_buf, 0);
 	efx_free_rx_buffer(rx_queue->efx, rx_buf);
 }
 
@@ -550,10 +555,10 @@ void efx_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
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


