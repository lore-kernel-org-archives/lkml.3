Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaANAlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:41:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaANA2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 45/77] sfc: RX buffer allocation takes prefix size into account in IP header alignment
Date: Mon, 13 Jan 2014 16:28:06 -0800
Message-Id: <20140114002753.784796714@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Rybchenko <Andrew.Rybchenko@oktetlabs.ru>

[ Upstream commit 2ec030144f648a6dd208f95f55ece212f1b72771 ]

rx_prefix_size is 4-bytes aligned on Falcon/Siena (16 bytes), but it is equal
to 14 on EF10. So, it should be taken into account if arch requires IP header
to be 4-bytes aligned (via NET_IP_ALIGN).

Fixes: 8127d661e77f ('sfc: Add support for Solarflare SFC9100 family')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/efx.c        |    4 +++-
 drivers/net/ethernet/sfc/net_driver.h |    3 +++
 drivers/net/ethernet/sfc/rx.c         |    6 +++---
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -585,7 +585,7 @@ static void efx_start_datapath(struct ef
 			   EFX_MAX_FRAME_LEN(efx->net_dev->mtu) +
 			   efx->type->rx_buffer_padding);
 	rx_buf_len = (sizeof(struct efx_rx_page_state) +
-		      NET_IP_ALIGN + efx->rx_dma_len);
+		      efx->rx_ip_align + efx->rx_dma_len);
 	if (rx_buf_len <= PAGE_SIZE) {
 		efx->rx_scatter = efx->type->always_rx_scatter;
 		efx->rx_buffer_order = 0;
@@ -2554,6 +2554,8 @@ static int efx_init_struct(struct efx_ni
 
 	efx->net_dev = net_dev;
 	efx->rx_prefix_size = efx->type->rx_prefix_size;
+	efx->rx_ip_align =
+		NET_IP_ALIGN ? (efx->rx_prefix_size + NET_IP_ALIGN) % 4 : 0;
 	efx->rx_packet_hash_offset =
 		efx->type->rx_hash_offset - efx->type->rx_prefix_size;
 	spin_lock_init(&efx->stats_lock);
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -673,6 +673,8 @@ struct vfdi_status;
  * @n_channels: Number of channels in use
  * @n_rx_channels: Number of channels used for RX (= number of RX queues)
  * @n_tx_channels: Number of channels used for TX
+ * @rx_ip_align: RX DMA address offset to have IP header aligned in
+ *	in accordance with NET_IP_ALIGN
  * @rx_dma_len: Current maximum RX DMA length
  * @rx_buffer_order: Order (log2) of number of pages for each RX buffer
  * @rx_buffer_truesize: Amortised allocation size of an RX buffer,
@@ -806,6 +808,7 @@ struct efx_nic {
 	unsigned rss_spread;
 	unsigned tx_channel_offset;
 	unsigned n_tx_channels;
+	unsigned int rx_ip_align;
 	unsigned int rx_dma_len;
 	unsigned int rx_buffer_order;
 	unsigned int rx_buffer_truesize;
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -93,7 +93,7 @@ static inline void efx_sync_rx_buffer(st
 
 void efx_rx_config_page_split(struct efx_nic *efx)
 {
-	efx->rx_page_buf_step = ALIGN(efx->rx_dma_len + NET_IP_ALIGN,
+	efx->rx_page_buf_step = ALIGN(efx->rx_dma_len + efx->rx_ip_align,
 				      EFX_RX_BUF_ALIGNMENT);
 	efx->rx_bufs_per_page = efx->rx_buffer_order ? 1 :
 		((PAGE_SIZE - sizeof(struct efx_rx_page_state)) /
@@ -188,9 +188,9 @@ static int efx_init_rx_buffers(struct ef
 		do {
 			index = rx_queue->added_count & rx_queue->ptr_mask;
 			rx_buf = efx_rx_buffer(rx_queue, index);
-			rx_buf->dma_addr = dma_addr + NET_IP_ALIGN;
+			rx_buf->dma_addr = dma_addr + efx->rx_ip_align;
 			rx_buf->page = page;
-			rx_buf->page_offset = page_offset + NET_IP_ALIGN;
+			rx_buf->page_offset = page_offset + efx->rx_ip_align;
 			rx_buf->len = efx->rx_dma_len;
 			rx_buf->flags = 0;
 			++rx_queue->added_count;


