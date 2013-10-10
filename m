Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab3JJPuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:50:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53092 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590Ab3JJPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 029/104] sfc: Fix efx_rx_buf_offset() for recycled pages
Date: Thu, 10 Oct 2013 08:41:17 -0700
Message-Id: <1381419752-29733-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/sfc/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index bb579a6..688d42e 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -302,8 +302,9 @@ static void efx_resurrect_rx_buffer(struct efx_rx_queue *rx_queue,
 
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
1.8.1.2

