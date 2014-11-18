Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbaKRPZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:25:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbaKROJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Li RongQing <roy.qing.li@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 009/206] vxlan: using pskb_may_pull as early as possible
Date: Tue, 18 Nov 2014 15:06:04 +0100
Message-Id: <e073fb104ffd9170e37b0c528199aa493ae55978.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li RongQing <roy.qing.li@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 91269e390d062b526432f2ef1352b8df82e0e0bc ]

pskb_may_pull should be used to check if skb->data has enough space,
skb->len can not ensure that.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/vxlan.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 637e5ad186ef..aff1694d2d9e 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1341,9 +1341,6 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb)
 	if (!in6_dev)
 		goto out;
 
-	if (!pskb_may_pull(skb, skb->len))
-		goto out;
-
 	iphdr = ipv6_hdr(skb);
 	saddr = &iphdr->saddr;
 	daddr = &iphdr->daddr;
@@ -1890,7 +1887,8 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 			return arp_reduce(dev, skb);
 #if IS_ENABLED(CONFIG_IPV6)
 		else if (ntohs(eth->h_proto) == ETH_P_IPV6 &&
-			 skb->len >= sizeof(struct ipv6hdr) + sizeof(struct nd_msg) &&
+			 pskb_may_pull(skb, sizeof(struct ipv6hdr)
+				       + sizeof(struct nd_msg)) &&
 			 ipv6_hdr(skb)->nexthdr == IPPROTO_ICMPV6) {
 				struct nd_msg *msg;
 
-- 
2.1.3

