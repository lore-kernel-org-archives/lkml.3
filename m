Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaKKLvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:51:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57452 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbaKKLKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 071/170] vxlan: using pskb_may_pull as early as possible
Date: Tue, 11 Nov 2014 11:07:10 +0000
Message-Id: <1415704129-12709-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

commit 91269e390d062b526432f2ef1352b8df82e0e0bc upstream.

pskb_may_pull should be used to check if skb->data has enough space,
skb->len can not ensure that.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/vxlan.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a5da8d49a824..53b5bdeb45af 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1438,9 +1438,6 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb)
 	if (!in6_dev)
 		goto out;
 
-	if (!pskb_may_pull(skb, skb->len))
-		goto out;
-
 	iphdr = ipv6_hdr(skb);
 	saddr = &iphdr->saddr;
 	daddr = &iphdr->daddr;
@@ -1945,7 +1942,8 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 			return arp_reduce(dev, skb);
 #if IS_ENABLED(CONFIG_IPV6)
 		else if (ntohs(eth->h_proto) == ETH_P_IPV6 &&
-			 skb->len >= sizeof(struct ipv6hdr) + sizeof(struct nd_msg) &&
+			 pskb_may_pull(skb, sizeof(struct ipv6hdr)
+				       + sizeof(struct nd_msg)) &&
 			 ipv6_hdr(skb)->nexthdr == IPPROTO_ICMPV6) {
 				struct nd_msg *msg;
 
-- 
2.1.0

