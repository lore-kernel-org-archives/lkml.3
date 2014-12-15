Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaLOT1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:27:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40605 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaLOT1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:27:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 05/96] vxlan: using pskb_may_pull as early as possible
Date: Mon, 15 Dec 2014 11:25:25 -0800
Message-Id: <1418671616-25482-6-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit 91269e390d062b526432f2ef1352b8df82e0e0bc ]

pskb_may_pull should be used to check if skb->data has enough space,
skb->len can not ensure that.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/vxlan.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 311d63d..0969176 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1337,9 +1337,6 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb)
 	if (!in6_dev)
 		goto out;
 
-	if (!pskb_may_pull(skb, skb->len))
-		goto out;
-
 	iphdr = ipv6_hdr(skb);
 	saddr = &iphdr->saddr;
 	daddr = &iphdr->daddr;
@@ -1886,7 +1883,8 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 			return arp_reduce(dev, skb);
 #if IS_ENABLED(CONFIG_IPV6)
 		else if (ntohs(eth->h_proto) == ETH_P_IPV6 &&
-			 skb->len >= sizeof(struct ipv6hdr) + sizeof(struct nd_msg) &&
+			 pskb_may_pull(skb, sizeof(struct ipv6hdr)
+				       + sizeof(struct nd_msg)) &&
 			 ipv6_hdr(skb)->nexthdr == IPPROTO_ICMPV6) {
 				struct nd_msg *msg;
 
-- 
1.9.1

