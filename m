Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3IKFlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:41:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3IKE5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:15 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=uhmDAmdYmAUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=DqJm2HmpkWEA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=DfNHnWVPAAAA:8 a=vmLDa1wCAAAA:8 a=J1Y8HTJGAAAA:8 a=o52gZbIYfNrWBBcVTTUA:9 a=UTB_XpHje0EA:10 a=lBRciGGoxdUA:10 a=gv_BBZfBKR8A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042919.369181667@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [162/251] atl1c: Fix misuse of netdev_alloc_skb in refilling rx ring
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0162-atl1c-Fix-misuse-of-netdev_alloc_skb-in-refilling-rx.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7b70176421993866e616f1cbc4d0dd4054f1bf78 ]

On Mon, 2013-07-29 at 08:30 -0700, Eric Dumazet wrote:
> On Mon, 2013-07-29 at 13:09 +0100, Luis Henriques wrote:
>
> >
> > I confirm that I can't reproduce the issue using this patch.
> >
>
> Thanks, I'll send a polished patch, as this one had an error if
> build_skb() returns NULL (in case sk_buff allocation fails)

Please try the following patch : It should use 2K frags instead of 4K
for normal 1500 mtu

Thanks !

[PATCH] atl1c: use custom skb allocator

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/atheros/atl1c/atl1c.h      |    3 ++
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |   40 ++++++++++++++++++++++-
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
index 1bf5bbf..033226b 100644
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
@@ -1662,7 +1700,7 @@ static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter)
 	while (next_info->flags & ATL1C_BUFFER_FREE) {
 		rfd_desc = ATL1C_RFD_DESC(rfd_ring, rfd_next_to_use);
 
-		skb = netdev_alloc_skb(adapter->netdev, adapter->rx_buffer_len);
+		skb = atl1c_alloc_skb(adapter);
 		if (unlikely(!skb)) {
 			if (netif_msg_rx_err(adapter))
 				dev_warn(&pdev->dev, "alloc rx buffer failed\n");
-- 
1.7.10.4


