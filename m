Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab3CYBX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:23:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34066 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184Ab3CYBQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:13 -0400
Message-Id: <20130325010528.827865754@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:10 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 046/104] sfc: Fix efx_rx_buf_offset() in the presence of  swiotlb
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

[ Upstream commits 06e63c57acbb1df7c35ebe846ae416a8b88dfafa,
  b590ace09d51cd39744e0f7662c5e4a0d1b5d952 and
  c73e787a8db9117d59b5180baf83203a42ecadca ]

We assume that the mapping between DMA and virtual addresses is done
on whole pages, so we can find the page offset of an RX buffer using
the lower bits of the DMA address.  However, swiotlb maps in units of
2K, breaking this assumption.

Add an explicit page_offset field to struct efx_rx_buffer.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/sfc/net_driver.h |  4 +++-
 drivers/net/ethernet/sfc/rx.c         | 10 +++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 9e2e802..8bcb8fd 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -213,6 +213,7 @@ struct efx_tx_queue {
  *	If both this and page are %NULL, the buffer slot is currently free.
  * @page: The associated page buffer, if any.
  *	If both this and skb are %NULL, the buffer slot is currently free.
+ * @page_offset: Offset within page. Valid iff @flags & %EFX_RX_BUF_PAGE.
  * @len: Buffer length, in bytes.
  * @is_page: Indicates if @page is valid. If false, @skb is valid.
  */
@@ -222,7 +223,8 @@ struct efx_rx_buffer {
 		struct sk_buff *skb;
 		struct page *page;
 	} u;
-	unsigned int len;
+	u16 page_offset;
+	u16 len;
 	bool is_page;
 };
 
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index b4d3cd5..9ce8665 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -95,11 +95,7 @@ static unsigned int rx_refill_limit = 95;
 static inline unsigned int efx_rx_buf_offset(struct efx_nic *efx,
 					     struct efx_rx_buffer *buf)
 {
-	/* Offset is always within one page, so we don't need to consider
-	 * the page order.
-	 */
-	return (((__force unsigned long) buf->dma_addr & (PAGE_SIZE - 1)) +
-		efx->type->rx_buffer_hash_size);
+	return buf->page_offset + efx->type->rx_buffer_hash_size;
 }
 static inline unsigned int efx_rx_buf_size(struct efx_nic *efx)
 {
@@ -194,6 +190,7 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 	struct efx_rx_buffer *rx_buf;
 	struct page *page;
 	void *page_addr;
+	unsigned int page_offset;
 	struct efx_rx_page_state *state;
 	dma_addr_t dma_addr;
 	unsigned index, count;
@@ -220,12 +217,14 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 
 		page_addr += sizeof(struct efx_rx_page_state);
 		dma_addr += sizeof(struct efx_rx_page_state);
+		page_offset = sizeof(struct efx_rx_page_state);
 
 	split:
 		index = rx_queue->added_count & rx_queue->ptr_mask;
 		rx_buf = efx_rx_buffer(rx_queue, index);
 		rx_buf->dma_addr = dma_addr + EFX_PAGE_IP_ALIGN;
 		rx_buf->u.page = page;
+		rx_buf->page_offset = page_offset + EFX_PAGE_IP_ALIGN;
 		rx_buf->len = efx->rx_buffer_len - EFX_PAGE_IP_ALIGN;
 		rx_buf->is_page = true;
 		++rx_queue->added_count;
@@ -237,6 +236,7 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 			get_page(page);
 			dma_addr += (PAGE_SIZE >> 1);
 			page_addr += (PAGE_SIZE >> 1);
+			page_offset += (PAGE_SIZE >> 1);
 			++count;
 			goto split;
 		}


