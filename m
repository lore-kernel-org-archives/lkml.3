Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbaKFXXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:23:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaKFWhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 003/162] myri10ge: check for DMA mapping errors
Date: Thu,  6 Nov 2014 14:34:27 -0800
Message-Id: <1415313426-9622-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

[ Upstream commit 10545937e866ccdbb7ab583031dbdcc6b14e4eb4 ]

On IOMMU systems DMA mapping can fail, we need to check for
that possibility.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 88 ++++++++++++++++--------
 1 file changed, 58 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 68026f7..4a474dd 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -872,6 +872,10 @@ static int myri10ge_dma_test(struct myri10ge_priv *mgp, int test_type)
 		return -ENOMEM;
 	dmatest_bus = pci_map_page(mgp->pdev, dmatest_page, 0, PAGE_SIZE,
 				   DMA_BIDIRECTIONAL);
+	if (unlikely(pci_dma_mapping_error(mgp->pdev, dmatest_bus))) {
+		__free_page(dmatest_page);
+		return -ENOMEM;
+	}
 
 	/* Run a small DMA test.
 	 * The magic multipliers to the length tell the firmware
@@ -1293,6 +1297,7 @@ myri10ge_alloc_rx_pages(struct myri10ge_priv *mgp, struct myri10ge_rx_buf *rx,
 			int bytes, int watchdog)
 {
 	struct page *page;
+	dma_addr_t bus;
 	int idx;
 #if MYRI10GE_ALLOC_SIZE > 4096
 	int end_offset;
@@ -1317,11 +1322,21 @@ myri10ge_alloc_rx_pages(struct myri10ge_priv *mgp, struct myri10ge_rx_buf *rx,
 					rx->watchdog_needed = 1;
 				return;
 			}
+
+			bus = pci_map_page(mgp->pdev, page, 0,
+					   MYRI10GE_ALLOC_SIZE,
+					   PCI_DMA_FROMDEVICE);
+			if (unlikely(pci_dma_mapping_error(mgp->pdev, bus))) {
+				__free_pages(page, MYRI10GE_ALLOC_ORDER);
+				if (rx->fill_cnt - rx->cnt < 16)
+					rx->watchdog_needed = 1;
+				return;
+			}
+
 			rx->page = page;
 			rx->page_offset = 0;
-			rx->bus = pci_map_page(mgp->pdev, page, 0,
-					       MYRI10GE_ALLOC_SIZE,
-					       PCI_DMA_FROMDEVICE);
+			rx->bus = bus;
+
 		}
 		rx->info[idx].page = rx->page;
 		rx->info[idx].page_offset = rx->page_offset;
@@ -2765,6 +2780,35 @@ myri10ge_submit_req(struct myri10ge_tx_buf *tx, struct mcp_kreq_ether_send *src,
 	mb();
 }
 
+static void myri10ge_unmap_tx_dma(struct myri10ge_priv *mgp,
+				  struct myri10ge_tx_buf *tx, int idx)
+{
+	unsigned int len;
+	int last_idx;
+
+	/* Free any DMA resources we've alloced and clear out the skb slot */
+	last_idx = (idx + 1) & tx->mask;
+	idx = tx->req & tx->mask;
+	do {
+		len = dma_unmap_len(&tx->info[idx], len);
+		if (len) {
+			if (tx->info[idx].skb != NULL)
+				pci_unmap_single(mgp->pdev,
+						 dma_unmap_addr(&tx->info[idx],
+								bus), len,
+						 PCI_DMA_TODEVICE);
+			else
+				pci_unmap_page(mgp->pdev,
+					       dma_unmap_addr(&tx->info[idx],
+							      bus), len,
+					       PCI_DMA_TODEVICE);
+			dma_unmap_len_set(&tx->info[idx], len, 0);
+			tx->info[idx].skb = NULL;
+		}
+		idx = (idx + 1) & tx->mask;
+	} while (idx != last_idx);
+}
+
 /*
  * Transmit a packet.  We need to split the packet so that a single
  * segment does not cross myri10ge->tx_boundary, so this makes segment
@@ -2788,7 +2832,7 @@ static netdev_tx_t myri10ge_xmit(struct sk_buff *skb,
 	u32 low;
 	__be32 high_swapped;
 	unsigned int len;
-	int idx, last_idx, avail, frag_cnt, frag_idx, count, mss, max_segments;
+	int idx, avail, frag_cnt, frag_idx, count, mss, max_segments;
 	u16 pseudo_hdr_offset, cksum_offset, queue;
 	int cum_len, seglen, boundary, rdma_count;
 	u8 flags, odd_flag;
@@ -2885,9 +2929,12 @@ again:
 
 	/* map the skb for DMA */
 	len = skb_headlen(skb);
+	bus = pci_map_single(mgp->pdev, skb->data, len, PCI_DMA_TODEVICE);
+	if (unlikely(pci_dma_mapping_error(mgp->pdev, bus)))
+		goto drop;
+
 	idx = tx->req & tx->mask;
 	tx->info[idx].skb = skb;
-	bus = pci_map_single(mgp->pdev, skb->data, len, PCI_DMA_TODEVICE);
 	dma_unmap_addr_set(&tx->info[idx], bus, bus);
 	dma_unmap_len_set(&tx->info[idx], len, len);
 
@@ -2986,12 +3033,16 @@ again:
 			break;
 
 		/* map next fragment for DMA */
-		idx = (count + tx->req) & tx->mask;
 		frag = &skb_shinfo(skb)->frags[frag_idx];
 		frag_idx++;
 		len = skb_frag_size(frag);
 		bus = skb_frag_dma_map(&mgp->pdev->dev, frag, 0, len,
 				       DMA_TO_DEVICE);
+		if (unlikely(pci_dma_mapping_error(mgp->pdev, bus))) {
+			myri10ge_unmap_tx_dma(mgp, tx, idx);
+			goto drop;
+		}
+		idx = (count + tx->req) & tx->mask;
 		dma_unmap_addr_set(&tx->info[idx], bus, bus);
 		dma_unmap_len_set(&tx->info[idx], len, len);
 	}
@@ -3022,31 +3073,8 @@ again:
 	return NETDEV_TX_OK;
 
 abort_linearize:
-	/* Free any DMA resources we've alloced and clear out the skb
-	 * slot so as to not trip up assertions, and to avoid a
-	 * double-free if linearizing fails */
+	myri10ge_unmap_tx_dma(mgp, tx, idx);
 
-	last_idx = (idx + 1) & tx->mask;
-	idx = tx->req & tx->mask;
-	tx->info[idx].skb = NULL;
-	do {
-		len = dma_unmap_len(&tx->info[idx], len);
-		if (len) {
-			if (tx->info[idx].skb != NULL)
-				pci_unmap_single(mgp->pdev,
-						 dma_unmap_addr(&tx->info[idx],
-								bus), len,
-						 PCI_DMA_TODEVICE);
-			else
-				pci_unmap_page(mgp->pdev,
-					       dma_unmap_addr(&tx->info[idx],
-							      bus), len,
-					       PCI_DMA_TODEVICE);
-			dma_unmap_len_set(&tx->info[idx], len, 0);
-			tx->info[idx].skb = NULL;
-		}
-		idx = (idx + 1) & tx->mask;
-	} while (idx != last_idx);
 	if (skb_is_gso(skb)) {
 		netdev_err(mgp->dev, "TSO but wanted to linearize?!?!?\n");
 		goto drop;
-- 
1.9.1

