Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab3DKUfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:35:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27887 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab3DKU0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:10 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=QfNxEgZ1p0wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mSSEIm2r2DMA:10 a=zRKbQ67AAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=1Dwx9gnmAe4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202549.989783446@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 023/171 ] sfc: Correct efx_rx_buffer::page_offset when EFX_PAGE_IP_ALIGN != 0
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0023-sfc-Correct-efx_rx_buffer-page_offset-when-EFX_PAGE_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit c73e787a8db9117d59b5180baf83203a42ecadca ]

RX DMA buffers start at an offset of EFX_PAGE_IP_ALIGN bytes from the
start of a cache line.  This offset obviously needs to be included in
the virtual address, but this was missed in commit b590ace09d51
('sfc: Fix efx_rx_buf_offset() in the presence of swiotlb') since
EFX_PAGE_IP_ALIGN is equal to 0 on both x86 and powerpc.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/sfc/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index b59b6fe..cd3f12f 100644
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
1.7.10.4


