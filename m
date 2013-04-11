Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945Ab3DKUhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:37:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27951 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3DKU0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:02 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=oBCU9obzIHwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_fYHw4IRGwwA:10 a=zRKbQ67AAAAA:8 a=0u0nhMPvhaUjrep2UKUA:9 a=1Dwx9gnmAe4A:10 a=jeBq3FmKZ4MA:10 a=HIlZi078OZJAk_Go:21 a=ZlPOnRfq8dW4G3bK:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202549.829773582@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 022/171 ] sfc: Fix efx_rx_buf_offset() in the presence of swiotlb
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0022-sfc-Fix-efx_rx_buf_offset-in-the-presence-of-swiotlb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit b590ace09d51cd39744e0f7662c5e4a0d1b5d952 ]

We assume that the mapping between DMA and virtual addresses is done
on whole pages, so we can find the page offset of an RX buffer using
the lower bits of the DMA address.  However, swiotlb maps in units of
2K, breaking this assumption.

Add an explicit page_offset field to struct efx_rx_buffer.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/sfc/net_driver.h |    4 +++-
 drivers/net/ethernet/sfc/rx.c         |   10 +++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index cd9c0a9..4c454bdc 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -205,6 +205,7 @@ struct efx_tx_queue {
  *	Will be %NULL if the buffer slot is currently free.
  * @page: The associated page buffer. Valif iff @flags & %EFX_RX_BUF_PAGE.
  *	Will be %NULL if the buffer slot is currently free.
+ * @page_offset: Offset within page. Valid iff @flags & %EFX_RX_BUF_PAGE.
  * @len: Buffer length, in bytes.
  * @flags: Flags for buffer and packet state.
  */
@@ -214,7 +215,8 @@ struct efx_rx_buffer {
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
index 16ef366..b59b6fe 100644
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
@@ -187,6 +183,7 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 	struct efx_nic *efx = rx_queue->efx;
 	struct efx_rx_buffer *rx_buf;
 	struct page *page;
+	unsigned int page_offset;
 	void *page_addr;
 	struct efx_rx_page_state *state;
 	dma_addr_t dma_addr;
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
@@ -230,6 +229,7 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 			/* Use the second half of the page */
 			get_page(page);
 			dma_addr += (PAGE_SIZE >> 1);
+			page_offset += (PAGE_SIZE >> 1);
 			page_addr += (PAGE_SIZE >> 1);
 			++count;
 			goto split;
-- 
1.7.10.4


