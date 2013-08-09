Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030331Ab3HICCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:02:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030258Ab3HIB7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 095/102] atl1c: use custom skb allocator
Date: Thu,  8 Aug 2013 18:58:11 -0700
Message-Id: <20130809015032.694973632@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7b70176421993866e616f1cbc4d0dd4054f1bf78 ]

We had reports ( https://bugzilla.kernel.org/show_bug.cgi?id=54021 )
that using high order pages for skb allocations is problematic for atl1c

We do not know exactly what the problem is, but we suspect that crossing
4K pages is not well supported by this hardware.

Use a custom allocator, using page allocator and 2K fragments for
optimal stack behavior. We might make this allocator generic
in future kernels.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Luis Henriques <luis.henriques@canonical.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/atheros/atl1c/atl1c.h      |    3 +
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |   40 +++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
@@ -520,6 +520,9 @@ struct atl1c_adapter {
 	struct net_device   *netdev;
 	struct pci_dev      *pdev;
 	struct napi_struct  napi;
+	struct page         *rx_page;
+	unsigned int	    rx_page_offset;
+	unsigned int	    rx_frag_size;
 	struct atl1c_hw        hw;
 	struct atl1c_hw_stats  hw_stats;
 	struct mii_if_info  mii;    /* MII interface info */
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -481,10 +481,15 @@ static int atl1c_set_mac_addr(struct net
 static void atl1c_set_rxbufsize(struct atl1c_adapter *adapter,
 				struct net_device *dev)
 {
+	unsigned int head_size;
 	int mtu = dev->mtu;
 
 	adapter->rx_buffer_len = mtu > AT_RX_BUF_SIZE ?
 		roundup(mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN, 8) : AT_RX_BUF_SIZE;
+
+	head_size = SKB_DATA_ALIGN(adapter->rx_buffer_len + NET_SKB_PAD) +
+		    SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	adapter->rx_frag_size = roundup_pow_of_two(head_size);
 }
 
 static netdev_features_t atl1c_fix_features(struct net_device *netdev,
@@ -952,6 +957,10 @@ static void atl1c_free_ring_resources(st
 		kfree(adapter->tpd_ring[0].buffer_info);
 		adapter->tpd_ring[0].buffer_info = NULL;
 	}
+	if (adapter->rx_page) {
+		put_page(adapter->rx_page);
+		adapter->rx_page = NULL;
+	}
 }
 
 /**
@@ -1639,6 +1648,35 @@ static inline void atl1c_rx_checksum(str
 	skb_checksum_none_assert(skb);
 }
 
+static struct sk_buff *atl1c_alloc_skb(struct atl1c_adapter *adapter)
+{
+	struct sk_buff *skb;
+	struct page *page;
+
+	if (adapter->rx_frag_size > PAGE_SIZE)
+		return netdev_alloc_skb(adapter->netdev,
+					adapter->rx_buffer_len);
+
+	page = adapter->rx_page;
+	if (!page) {
+		adapter->rx_page = page = alloc_page(GFP_ATOMIC);
+		if (unlikely(!page))
+			return NULL;
+		adapter->rx_page_offset = 0;
+	}
+
+	skb = build_skb(page_address(page) + adapter->rx_page_offset,
+			adapter->rx_frag_size);
+	if (likely(skb)) {
+		adapter->rx_page_offset += adapter->rx_frag_size;
+		if (adapter->rx_page_offset >= PAGE_SIZE)
+			adapter->rx_page = NULL;
+		else
+			get_page(page);
+	}
+	return skb;
+}
+
 static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter)
 {
 	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
@@ -1660,7 +1698,7 @@ static int atl1c_alloc_rx_buffer(struct
 	while (next_info->flags & ATL1C_BUFFER_FREE) {
 		rfd_desc = ATL1C_RFD_DESC(rfd_ring, rfd_next_to_use);
 
-		skb = netdev_alloc_skb(adapter->netdev, adapter->rx_buffer_len);
+		skb = atl1c_alloc_skb(adapter);
 		if (unlikely(!skb)) {
 			if (netif_msg_rx_err(adapter))
 				dev_warn(&pdev->dev, "alloc rx buffer failed\n");


