Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3JUIuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:50:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39276 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083Ab3JUIuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:50:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Neil Horman" <nhorman@tuxdriver.com>,
        "Francois Romieu" <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.918174719@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 007/149] 8139cp: Add dma_mapping_error checking
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commits cf3c4c03060b688cbc389ebc5065ebcce5653e96 and
  d06f5187469eee1b2932c02fd093d113cfc60d5e (the latter is a fixup
  from Dave Jones) ]

Self explanitory dma_mapping_error addition to the 8139 driver, based on this:
https://bugzilla.redhat.com/show_bug.cgi?id=947250

It showed several backtraces arising for dma_map_* usage without checking the
return code on the mapping.  Add the check and abort the rx/tx operation if its
failed.  Untested as I have no hardware and the reporter has wandered off, but
seems pretty straightforward.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/8139cp.c | 49 ++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 8f47907..4236b82 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -478,7 +478,7 @@ rx_status_loop:
 
 	while (1) {
 		u32 status, len;
-		dma_addr_t mapping;
+		dma_addr_t mapping, new_mapping;
 		struct sk_buff *skb, *new_skb;
 		struct cp_desc *desc;
 		const unsigned buflen = cp->rx_buf_sz;
@@ -520,6 +520,14 @@ rx_status_loop:
 			goto rx_next;
 		}
 
+		new_mapping = dma_map_single(&cp->pdev->dev, new_skb->data, buflen,
+					 PCI_DMA_FROMDEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, new_mapping)) {
+			dev->stats.rx_dropped++;
+			kfree_skb(new_skb);
+			goto rx_next;
+		}
+
 		dma_unmap_single(&cp->pdev->dev, mapping,
 				 buflen, PCI_DMA_FROMDEVICE);
 
@@ -531,12 +539,11 @@ rx_status_loop:
 
 		skb_put(skb, len);
 
-		mapping = dma_map_single(&cp->pdev->dev, new_skb->data, buflen,
-					 PCI_DMA_FROMDEVICE);
 		cp->rx_skb[rx_tail] = new_skb;
 
 		cp_rx_skb(cp, skb, desc);
 		rx++;
+		mapping = new_mapping;
 
 rx_next:
 		cp->rx_ring[rx_tail].opts2 = 0;
@@ -704,6 +711,22 @@ static inline u32 cp_tx_vlan_tag(struct sk_buff *skb)
 		TxVlanTag | swab16(vlan_tx_tag_get(skb)) : 0x00;
 }
 
+static void unwind_tx_frag_mapping(struct cp_private *cp, struct sk_buff *skb,
+				   int first, int entry_last)
+{
+	int frag, index;
+	struct cp_desc *txd;
+	skb_frag_t *this_frag;
+	for (frag = 0; frag+first < entry_last; frag++) {
+		index = first+frag;
+		cp->tx_skb[index] = NULL;
+		txd = &cp->tx_ring[index];
+		this_frag = &skb_shinfo(skb)->frags[frag];
+		dma_unmap_single(&cp->pdev->dev, le64_to_cpu(txd->addr),
+				 skb_frag_size(this_frag), PCI_DMA_TODEVICE);
+	}
+}
+
 static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 					struct net_device *dev)
 {
@@ -737,6 +760,9 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 
 		len = skb->len;
 		mapping = dma_map_single(&cp->pdev->dev, skb->data, len, PCI_DMA_TODEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, mapping))
+			goto out_dma_error;
+
 		txd->opts2 = opts2;
 		txd->addr = cpu_to_le64(mapping);
 		wmb();
@@ -774,6 +800,9 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 		first_len = skb_headlen(skb);
 		first_mapping = dma_map_single(&cp->pdev->dev, skb->data,
 					       first_len, PCI_DMA_TODEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, first_mapping))
+			goto out_dma_error;
+
 		cp->tx_skb[entry] = skb;
 		entry = NEXT_TX(entry);
 
@@ -787,6 +816,11 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 			mapping = dma_map_single(&cp->pdev->dev,
 						 skb_frag_address(this_frag),
 						 len, PCI_DMA_TODEVICE);
+			if (dma_mapping_error(&cp->pdev->dev, mapping)) {
+				unwind_tx_frag_mapping(cp, skb, first_entry, entry);
+				goto out_dma_error;
+			}
+
 			eor = (entry == (CP_TX_RING_SIZE - 1)) ? RingEnd : 0;
 
 			ctrl = eor | len | DescOwn;
@@ -845,11 +879,16 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 	if (TX_BUFFS_AVAIL(cp) <= (MAX_SKB_FRAGS + 1))
 		netif_stop_queue(dev);
 
+out_unlock:
 	spin_unlock_irqrestore(&cp->lock, intr_flags);
 
 	cpw8(TxPoll, NormalTxPoll);
 
 	return NETDEV_TX_OK;
+out_dma_error:
+	kfree_skb(skb);
+	cp->dev->stats.tx_dropped++;
+	goto out_unlock;
 }
 
 /* Set or clear the multicast filter for this adaptor.
@@ -1023,6 +1062,10 @@ static int cp_refill_rx(struct cp_private *cp)
 
 		mapping = dma_map_single(&cp->pdev->dev, skb->data,
 					 cp->rx_buf_sz, PCI_DMA_FROMDEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, mapping)) {
+			kfree_skb(skb);
+			goto err_out;
+		}
 		cp->rx_skb[i] = skb;
 
 		cp->rx_ring[i].opts2 = 0;

