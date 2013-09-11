Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab3IKFll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:41:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab3IKE5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:14 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=2PaHEdDgd0IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=n08UaEH4KG0A:10 a=vmLDa1wCAAAA:8 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=zhf81SHlAAAA:8 a=5QkjkmBl6feHZfsO8TQA:9 a=gv_BBZfBKR8A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042919.863984724@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Francois Romieu <romieu@fr.zoreil.com>
Subject: [165/251] 8139cp: Add dma_mapping_error checking
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0165-8139cp-Add-dma_mapping_error-checking.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit cf3c4c03060b688cbc389ebc5065ebcce5653e96 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/realtek/8139cp.c |   48 ++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index dd3371b..e933d57 100644
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
@@ -520,6 +520,13 @@ rx_status_loop:
 			goto rx_next;
 		}
 
+		new_mapping = dma_map_single(&cp->pdev->dev, new_skb->data, buflen,
+					 PCI_DMA_FROMDEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, new_mapping)) {
+			dev->stats.rx_dropped++;
+			goto rx_next;
+		}
+
 		dma_unmap_single(&cp->pdev->dev, mapping,
 				 buflen, PCI_DMA_FROMDEVICE);
 
@@ -531,12 +538,11 @@ rx_status_loop:
 
 		skb_put(skb, len);
 
-		mapping = dma_map_single(&cp->pdev->dev, new_skb->data, buflen,
-					 PCI_DMA_FROMDEVICE);
 		cp->rx_skb[rx_tail] = new_skb;
 
 		cp_rx_skb(cp, skb, desc);
 		rx++;
+		mapping = new_mapping;
 
 rx_next:
 		cp->rx_ring[rx_tail].opts2 = 0;
@@ -707,6 +713,22 @@ static inline u32 cp_tx_vlan_tag(struct sk_buff *skb)
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
@@ -740,6 +762,9 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 
 		len = skb->len;
 		mapping = dma_map_single(&cp->pdev->dev, skb->data, len, PCI_DMA_TODEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, mapping))
+			goto out_dma_error;
+
 		txd->opts2 = opts2;
 		txd->addr = cpu_to_le64(mapping);
 		wmb();
@@ -777,6 +802,9 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
 		first_len = skb_headlen(skb);
 		first_mapping = dma_map_single(&cp->pdev->dev, skb->data,
 					       first_len, PCI_DMA_TODEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, first_mapping))
+			goto out_dma_error;
+
 		cp->tx_skb[entry] = skb;
 		entry = NEXT_TX(entry);
 
@@ -790,6 +818,11 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
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
@@ -848,11 +881,16 @@ static netdev_tx_t cp_start_xmit (struct sk_buff *skb,
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
@@ -1023,6 +1061,10 @@ static int cp_refill_rx(struct cp_private *cp)
 
 		mapping = dma_map_single(&cp->pdev->dev, skb->data,
 					 cp->rx_buf_sz, PCI_DMA_FROMDEVICE);
+		if (dma_mapping_error(&cp->pdev->dev, mapping)) {
+			kfree_skb(skb);
+			goto err_out;
+		}
 		cp->rx_skb[i] = skb;
 
 		cp->rx_ring[i].opts2 = 0;
-- 
1.7.10.4


