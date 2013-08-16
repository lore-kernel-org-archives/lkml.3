Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab3HPWiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:38:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51509 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab3HPWiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:38:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 129/133] atl1c: use custom skb allocator
Date: Fri, 16 Aug 2013 15:34:31 -0700
Message-Id: <1376692475-28413-130-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c.h      |  3 ++
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 40 ++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
index b2bf324..0f05565 100644
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
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index bfcb8bc..26a8c62 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -482,10 +482,15 @@ static int atl1c_set_mac_addr(struct net_device *netdev, void *p)
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
@@ -953,6 +958,10 @@ static void atl1c_free_ring_resources(struct atl1c_adapter *adapter)
 		kfree(adapter->tpd_ring[0].buffer_info);
 		adapter->tpd_ring[0].buffer_info = NULL;
 	}
+	if (adapter->rx_page) {
+		put_page(adapter->rx_page);
+		adapter->rx_page = NULL;
+	}
 }
 
 /**
@@ -1642,6 +1651,35 @@ static inline void atl1c_rx_checksum(struct atl1c_adapter *adapter,
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
@@ -1663,7 +1701,7 @@ static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter)
 	while (next_info->flags & ATL1C_BUFFER_FREE) {
 		rfd_desc = ATL1C_RFD_DESC(rfd_ring, rfd_next_to_use);
 
-		skb = netdev_alloc_skb(adapter->netdev, adapter->rx_buffer_len);
+		skb = atl1c_alloc_skb(adapter);
 		if (unlikely(!skb)) {
 			if (netif_msg_rx_err(adapter))
 				dev_warn(&pdev->dev, "alloc rx buffer failed\n");
-- 
1.8.1.2

