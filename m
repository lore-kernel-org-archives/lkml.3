Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425Ab3CZPap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:30:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965401Ab3CZPX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 134/150] sfc: Fix efx_rx_buf_offset() in the presence of swiotlb
Date: Tue, 26 Mar 2013 15:20:33 +0000
Message-Id: <1364311249-14454-135-git-send-email-luis.henriques@canonical.com>
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

commit b590ace09d51cd39744e0f7662c5e4a0d1b5d952 upstream.

We assume that the mapping between DMA and virtual addresses is done
on whole pages, so we can find the page offset of an RX buffer using
the lower bits of the DMA address.  However, swiotlb maps in units of
2K, breaking this assumption.

Add an explicit page_offset field to struct efx_rx_buffer.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/net_driver.h |  4 +++-
 drivers/net/ethernet/sfc/rx.c         | 10 +++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 8e3e0cf..b3b3a60 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -206,6 +206,7 @@ struct efx_tx_queue {
  *	Will be %NULL if the buffer slot is currently free.
  * @page: The associated page buffer. Valif iff @flags & %EFX_RX_BUF_PAGE.
  *	Will be %NULL if the buffer slot is currently free.
+ * @page_offset: Offset within page. Valid iff @flags & %EFX_RX_BUF_PAGE.
  * @len: Buffer length, in bytes.
  * @flags: Flags for buffer and packet state.
  */
@@ -215,7 +216,8 @@ struct efx_rx_buffer {
 		struct sk_buff *skb;
 		struct page *page;
 	} u;
-	unsigned int len;
+	u16 page_offset;
+	u16 len;
 	u16 flags;
 };
 #define EFX_RX_BUF_PAGE		0x0001
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 622b0d7..7faaea8 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -90,11 +90,7 @@ static unsigned int rx_refill_threshold;
 static inline unsigned int efx_rx_buf_offset(struct efx_nic *efx,
 					     struct efx_rx_buffer *buf)
 {
-	/* Offset is always within one page, so we don't need to consider
-	 * the page order.
-	 */
-	return ((unsigned int) buf->dma_addr & (PAGE_SIZE - 1)) +
-		efx->type->rx_buffer_hash_size;
+	return buf->page_offset + efx->type->rx_buffer_hash_size;
 }
 static inline unsigned int efx_rx_buf_size(struct efx_nic *efx)
 {
@@ -188,6 +184,7 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 	struct efx_rx_buffer *rx_buf;
 	struct page *page;
 	void *page_addr;
+	unsigned int page_offset;
 	struct efx_rx_page_state *state;
 	dma_addr_t dma_addr;
 	unsigned index, count;
@@ -214,12 +211,14 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 
 		page_addr += sizeof(struct efx_rx_page_state);
 		dma_addr += sizeof(struct efx_rx_page_state);
+		page_offset = sizeof(struct efx_rx_page_state);
 
 	split:
 		index = rx_queue->added_count & rx_queue->ptr_mask;
 		rx_buf = efx_rx_buffer(rx_queue, index);
 		rx_buf->dma_addr = dma_addr + EFX_PAGE_IP_ALIGN;
 		rx_buf->u.page = page;
+		rx_buf->page_offset = page_offset;
 		rx_buf->len = efx->rx_buffer_len - EFX_PAGE_IP_ALIGN;
 		rx_buf->flags = EFX_RX_BUF_PAGE;
 		++rx_queue->added_count;
@@ -231,6 +230,7 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 			get_page(page);
 			dma_addr += (PAGE_SIZE >> 1);
 			page_addr += (PAGE_SIZE >> 1);
+			page_offset += (PAGE_SIZE >> 1);
 			++count;
 			goto split;
 		}
-- 
1.8.1.2

