Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab3JKKmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:42:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58391 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab3JKKmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 015/100] sfc: Fix efx_rx_buf_offset() for recycled pages
Date: Fri, 11 Oct 2013 11:40:45 +0100
Message-Id: <1381488130-30235-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

This bug fix is only for stable branches older than 3.10.  The bug was
fixed upstream by commit 2768935a4660 ('sfc: reuse pages to avoid DMA
mapping/unmapping costs'), but that change is totally unsuitable for
stable.

Commit b590ace09d51 ('sfc: Fix efx_rx_buf_offset() in the presence of
swiotlb') added an explicit page_offset member to struct
efx_rx_buffer, which must be set consistently with the u.page and
dma_addr fields.  However, it failed to add the necessary assignment
in efx_resurrect_rx_buffer().  It also did not correct the calculation
of efx_rx_buffer::dma_addr in efx_resurrect_rx_buffer(), which assumes
that DMA-mapping a page will result in a page-aligned DMA address
(exactly what swiotlb violates).

Add the assignment of efx_rx_buffer::page_offset and change the
calculation of dma_addr to make use of it.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index f8f7fc8..617e625 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -306,8 +306,9 @@ static void efx_resurrect_rx_buffer(struct efx_rx_queue *rx_queue,
 
 	index = rx_queue->added_count & rx_queue->ptr_mask;
 	new_buf = efx_rx_buffer(rx_queue, index);
-	new_buf->dma_addr = rx_buf->dma_addr ^ (PAGE_SIZE >> 1);
 	new_buf->u.page = rx_buf->u.page;
+	new_buf->page_offset = rx_buf->page_offset ^ (PAGE_SIZE >> 1);
+	new_buf->dma_addr = state->dma_addr + new_buf->page_offset;
 	new_buf->len = rx_buf->len;
 	new_buf->flags = EFX_RX_BUF_PAGE;
 	++rx_queue->added_count;
-- 
1.8.3.2

