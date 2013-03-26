Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965239Ab3CZPao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:30:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54152 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965314Ab3CZPYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 135/150] sfc: Correct efx_rx_buffer::page_offset when EFX_PAGE_IP_ALIGN != 0
Date: Tue, 26 Mar 2013 15:20:34 +0000
Message-Id: <1364311249-14454-136-git-send-email-luis.henriques@canonical.com>
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

commit c73e787a8db9117d59b5180baf83203a42ecadca upstream.

RX DMA buffers start at an offset of EFX_PAGE_IP_ALIGN bytes from the
start of a cache line.  This offset obviously needs to be included in
the virtual address, but this was missed in commit b590ace09d51
('sfc: Fix efx_rx_buf_offset() in the presence of swiotlb') since
EFX_PAGE_IP_ALIGN is equal to 0 on both x86 and powerpc.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 7faaea8..f8f7fc8 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -218,7 +218,7 @@ static int efx_init_rx_buffers_page(struct efx_rx_queue *rx_queue)
 		rx_buf = efx_rx_buffer(rx_queue, index);
 		rx_buf->dma_addr = dma_addr + EFX_PAGE_IP_ALIGN;
 		rx_buf->u.page = page;
-		rx_buf->page_offset = page_offset;
+		rx_buf->page_offset = page_offset + EFX_PAGE_IP_ALIGN;
 		rx_buf->len = efx->rx_buffer_len - EFX_PAGE_IP_ALIGN;
 		rx_buf->flags = EFX_RX_BUF_PAGE;
 		++rx_queue->added_count;
-- 
1.8.1.2

