Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaKLEST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:18:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaKLBVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:21:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 006/319] vxlan: using pskb_may_pull as early as possible
Date: Wed, 12 Nov 2014 10:12:24 +0900
Message-Id: <20141112010953.706830320@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit 91269e390d062b526432f2ef1352b8df82e0e0bc ]

pskb_may_pull should be used to check if skb->data has enough space,
skb->len can not ensure that.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1440,9 +1440,6 @@ static int neigh_reduce(struct net_devic
 	if (!in6_dev)
 		goto out;
 
-	if (!pskb_may_pull(skb, skb->len))
-		goto out;
-
 	iphdr = ipv6_hdr(skb);
 	saddr = &iphdr->saddr;
 	daddr = &iphdr->daddr;
@@ -1929,7 +1926,8 @@ static netdev_tx_t vxlan_xmit(struct sk_
 			return arp_reduce(dev, skb);
 #if IS_ENABLED(CONFIG_IPV6)
 		else if (ntohs(eth->h_proto) == ETH_P_IPV6 &&
-			 skb->len >= sizeof(struct ipv6hdr) + sizeof(struct nd_msg) &&
+			 pskb_may_pull(skb, sizeof(struct ipv6hdr)
+				       + sizeof(struct nd_msg)) &&
 			 ipv6_hdr(skb)->nexthdr == IPPROTO_ICMPV6) {
 				struct nd_msg *msg;
 


