Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798Ab3CZPbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:31:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54144 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965398Ab3CZPX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 133/150] sfc: Properly sync RX DMA buffer when it is not the last in the page
Date: Tue, 26 Mar 2013 15:20:32 +0000
Message-Id: <1364311249-14454-134-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit 3a68f19d7afb80f548d016effbc6ed52643a8085 upstream.

We may currently allocate two RX DMA buffers to a page, and only unmap
the page when the second is completed.  We do not sync the first RX
buffer to be completed; this can result in packet loss or corruption
if the last RX buffer completed in a NAPI poll is the first in a page
and is not DMA-coherent.  (In the middle of a NAPI poll, we will
handle the following RX completion and unmap the page *before* looking
at the content of the first buffer.)

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/rx.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 243e91f..622b0d7 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -240,7 +240,8 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 }
 
 static void efx_unmap_rx_buffer(struct efx_nic *efx,
-				struct efx_rx_buffer *rx_buf)
+				struct efx_rx_buffer *rx_buf,
+				unsigned int used_len)
 {
 	if ((rx_buf->flags & EFX_RX_BUF_PAGE) && rx_buf->u.page) {
 		struct efx_rx_page_state *state;
@@ -251,6 +252,10 @@ static void efx_unmap_rx_buffer(struct efx_nic *efx,
 				       state->dma_addr,
 				       efx_rx_buf_size(efx),
 				       PCI_DMA_FROMDEVICE);
+		} else if (used_len) {
+			dma_sync_single_for_cpu(&efx->pci_dev->dev,
+						rx_buf->dma_addr, used_len,
+						DMA_FROM_DEVICE);
 		}
 	} else if (!(rx_buf->flags & EFX_RX_BUF_PAGE) && rx_buf->u.skb) {
 		pci_unmap_single(efx->pci_dev, rx_buf->dma_addr,
@@ -273,7 +278,7 @@ static void efx_free_rx_buffer(struct efx_nic *efx,
 static void efx_fini_rx_buffer(struct efx_rx_queue *rx_queue,
 			       struct efx_rx_buffer *rx_buf)
 {
-	efx_unmap_rx_buffer(rx_queue->efx, rx_buf);
+	efx_unmap_rx_buffer(rx_queue->efx, rx_buf, 0);
 	efx_free_rx_buffer(rx_queue->efx, rx_buf);
 }
 
@@ -538,10 +543,10 @@ void efx_rx_packet(struct efx_rx_queue *rx_queue, unsigned int index,
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
-- 
1.8.1.2

