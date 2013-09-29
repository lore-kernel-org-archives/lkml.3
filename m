Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3I2UGZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:06:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3I2T1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>
Subject: [ 16/17] sfc: Fix efx_rx_buf_offset() for recycled pages
Date: Sun, 29 Sep 2013 12:26:55 -0700
Message-Id: <20130929190758.245268941@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929190757.138351117@linuxfoundation.org>
References: <20130929190757.138351117@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/sfc/rx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/sfc/rx.c
+++ b/drivers/net/sfc/rx.c
@@ -311,8 +311,9 @@ static void efx_resurrect_rx_buffer(stru
 
 	index = rx_queue->added_count & rx_queue->ptr_mask;
 	new_buf = efx_rx_buffer(rx_queue, index);
-	new_buf->dma_addr = rx_buf->dma_addr ^ (PAGE_SIZE >> 1);
 	new_buf->u.page = rx_buf->u.page;
+	new_buf->page_offset = rx_buf->page_offset ^ (PAGE_SIZE >> 1);
+	new_buf->dma_addr = state->dma_addr + new_buf->page_offset;
 	new_buf->len = rx_buf->len;
 	new_buf->is_page = true;
 	++rx_queue->added_count;


