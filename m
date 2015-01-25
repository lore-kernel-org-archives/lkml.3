Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbbAYSt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:49:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbbAYSKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Eric Biggers <ebiggers3@gmail.com>, Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 3.18 062/183] rtlwifi: Fix error when accessing unmapped memory in skb
Date: Sun, 25 Jan 2015 10:06:24 -0800
Message-Id: <20150125180812.877505995@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit e9538cf4f90713eca71b1d6a74b4eae1d445c664 upstream.

These drivers use 9100-byte receive buffers, thus allocating an skb requires
an O(3) memory allocation. Under heavy memory loads and fragmentation, such
a request can fail. Previous versions of the driver have dropped the packet
and reused the old buffer; however, the new version introduced a bug in that
it released the old buffer before trying to allocate a new one. The previous
method is implemented here. The skb is unmapped before any attempt is made to
allocate another.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Eric Biggers <ebiggers3@gmail.com>
Cc: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/pci.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -666,7 +666,8 @@ tx_status_ok:
 }
 
 static int _rtl_pci_init_one_rxdesc(struct ieee80211_hw *hw,
-				    u8 *entry, int rxring_idx, int desc_idx)
+				    struct sk_buff *new_skb, u8 *entry,
+				    int rxring_idx, int desc_idx)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -674,11 +675,15 @@ static int _rtl_pci_init_one_rxdesc(stru
 	u8 tmp_one = 1;
 	struct sk_buff *skb;
 
+	if (likely(new_skb)) {
+		skb = new_skb;
+		goto remap;
+	}
 	skb = dev_alloc_skb(rtlpci->rxbuffersize);
 	if (!skb)
 		return 0;
-	rtlpci->rx_ring[rxring_idx].rx_buf[desc_idx] = skb;
 
+remap:
 	/* just set skb->cb to mapping addr for pci_unmap_single use */
 	*((dma_addr_t *)skb->cb) =
 		pci_map_single(rtlpci->pdev, skb_tail_pointer(skb),
@@ -686,6 +691,7 @@ static int _rtl_pci_init_one_rxdesc(stru
 	bufferaddress = *((dma_addr_t *)skb->cb);
 	if (pci_dma_mapping_error(rtlpci->pdev, bufferaddress))
 		return 0;
+	rtlpci->rx_ring[rxring_idx].rx_buf[desc_idx] = skb;
 	if (rtlpriv->use_new_trx_flow) {
 		rtlpriv->cfg->ops->set_desc(hw, (u8 *)entry, false,
 					    HW_DESC_RX_PREPARE,
@@ -781,6 +787,7 @@ static void _rtl_pci_rx_interrupt(struct
 		/*rx pkt */
 		struct sk_buff *skb = rtlpci->rx_ring[rxring_idx].rx_buf[
 				      rtlpci->rx_ring[rxring_idx].idx];
+		struct sk_buff *new_skb;
 
 		if (rtlpriv->use_new_trx_flow) {
 			rx_remained_cnt =
@@ -807,6 +814,13 @@ static void _rtl_pci_rx_interrupt(struct
 		pci_unmap_single(rtlpci->pdev, *((dma_addr_t *)skb->cb),
 				 rtlpci->rxbuffersize, PCI_DMA_FROMDEVICE);
 
+		/* get a new skb - if fail, old one will be reused */
+		new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
+		if (unlikely(!new_skb)) {
+			pr_err("Allocation of new skb failed in %s\n",
+			       __func__);
+			goto no_new;
+		}
 		if (rtlpriv->use_new_trx_flow) {
 			buffer_desc =
 			  &rtlpci->rx_ring[rxring_idx].buffer_desc
@@ -911,14 +925,16 @@ static void _rtl_pci_rx_interrupt(struct
 			schedule_work(&rtlpriv->works.lps_change_work);
 		}
 end:
+		skb = new_skb;
+no_new:
 		if (rtlpriv->use_new_trx_flow) {
-			_rtl_pci_init_one_rxdesc(hw, (u8 *)buffer_desc,
+			_rtl_pci_init_one_rxdesc(hw, skb, (u8 *)buffer_desc,
 						 rxring_idx,
-					       rtlpci->rx_ring[rxring_idx].idx);
+						 rtlpci->rx_ring[rxring_idx].idx);
 		} else {
-			_rtl_pci_init_one_rxdesc(hw, (u8 *)pdesc, rxring_idx,
+			_rtl_pci_init_one_rxdesc(hw, skb, (u8 *)pdesc,
+						 rxring_idx,
 						 rtlpci->rx_ring[rxring_idx].idx);
-
 			if (rtlpci->rx_ring[rxring_idx].idx ==
 			    rtlpci->rxringcount - 1)
 				rtlpriv->cfg->ops->set_desc(hw, (u8 *)pdesc,
@@ -1307,7 +1323,7 @@ static int _rtl_pci_init_rx_ring(struct
 		rtlpci->rx_ring[rxring_idx].idx = 0;
 		for (i = 0; i < rtlpci->rxringcount; i++) {
 			entry = &rtlpci->rx_ring[rxring_idx].buffer_desc[i];
-			if (!_rtl_pci_init_one_rxdesc(hw, (u8 *)entry,
+			if (!_rtl_pci_init_one_rxdesc(hw, NULL, (u8 *)entry,
 						      rxring_idx, i))
 				return -ENOMEM;
 		}
@@ -1332,7 +1348,7 @@ static int _rtl_pci_init_rx_ring(struct
 
 		for (i = 0; i < rtlpci->rxringcount; i++) {
 			entry = &rtlpci->rx_ring[rxring_idx].desc[i];
-			if (!_rtl_pci_init_one_rxdesc(hw, (u8 *)entry,
+			if (!_rtl_pci_init_one_rxdesc(hw, NULL, (u8 *)entry,
 						      rxring_idx, i))
 				return -ENOMEM;
 		}


