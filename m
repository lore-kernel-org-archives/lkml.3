Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3JUIxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:53:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39849 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393Ab3JUIxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:15 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ben Hutchings" <bhutchings@solarflare.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.989222344@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 130/149] sfc: Fix efx_rx_buf_offset() for recycled pages
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
---
 drivers/net/ethernet/sfc/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 9ce8665..c231b3f 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -312,8 +312,9 @@ static void efx_resurrect_rx_buffer(struct efx_rx_queue *rx_queue,
 
 	index = rx_queue->added_count & rx_queue->ptr_mask;
 	new_buf = efx_rx_buffer(rx_queue, index);
-	new_buf->dma_addr = rx_buf->dma_addr ^ (PAGE_SIZE >> 1);
 	new_buf->u.page = rx_buf->u.page;
+	new_buf->page_offset = rx_buf->page_offset ^ (PAGE_SIZE >> 1);
+	new_buf->dma_addr = state->dma_addr + new_buf->page_offset;
 	new_buf->len = rx_buf->len;
 	new_buf->is_page = true;
 	++rx_queue->added_count;
-- 
1.8.1.4

