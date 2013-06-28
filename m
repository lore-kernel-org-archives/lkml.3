Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3F1Sy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:54:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41660 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3F1Syy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:54:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 074/105] ip_tunnel: fix kernel panic with icmp_dest_unreach
Date: Fri, 28 Jun 2013 11:51:36 -0700
Message-Id: <1372445527-24414-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a622260254ee481747cceaaa8609985b29a31565 ]

Daniel Petre reported crashes in icmp_dst_unreach() with following call
graph:

Daniel found a similar problem mentioned in
 http://lkml.indiana.edu/hypermail/linux/kernel/1007.0/00961.html

And indeed this is the root cause : skb->cb[] contains data fooling IP
stack.

We must clear IPCB in ip_tunnel_xmit() sooner in case dst_link_failure()
is called. Or else skb->cb[] might contain garbage from GSO segmentation
layer.

A similar fix was tested on linux-3.9, but gre code was refactored in
linux-3.10. I'll send patches for stable kernels as well.

Many thanks to Daniel for providing reports, patches and testing !

Reported-by: Daniel Petre <daniel.petre@rcs-rds.ro>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_gre.c | 2 +-
 net/ipv4/ipip.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index a85062b..e0c1929 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -767,6 +767,7 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 		tiph = &tunnel->parms.iph;
 	}
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if ((dst = tiph->daddr) == 0) {
 		/* NBMA tunnel */
 
@@ -912,7 +913,6 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 	skb_push(skb, gre_hlen);
 	skb_reset_network_header(skb);
 	skb_set_transport_header(skb, sizeof(*iph));
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 191fc24..b3fc09d 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -489,6 +489,7 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (tos & 1)
 		tos = old_iph->tos;
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if (!dst) {
 		/* NBMA tunnel */
 		if ((rt = skb_rtable(skb)) == NULL) {
@@ -571,7 +572,6 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb->transport_header = skb->network_header;
 	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);
-- 
1.8.1.2

