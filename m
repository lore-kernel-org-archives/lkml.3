Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3GBLRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:17:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36210 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab3GBLIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 16/50] ip_tunnel: fix kernel panic with icmp_dest_unreach
Date: Tue,  2 Jul 2013 12:07:04 +0100
Message-Id: <1372763258-20664-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit a622260254ee481747cceaaa8609985b29a31565 upstream.

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
[ luis: backported to 3.5: used davem's backport to 3.4 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ip_gre.c | 2 +-
 net/ipv4/ipip.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index f49047b..37000b5 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -743,6 +743,7 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 		tiph = &tunnel->parms.iph;
 	}
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if ((dst = tiph->daddr) == 0) {
 		/* NBMA tunnel */
 
@@ -886,7 +887,6 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 	skb_reset_transport_header(skb);
 	skb_push(skb, gre_hlen);
 	skb_reset_network_header(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 2d0f99b..d614b42 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -465,6 +465,7 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (tos & 1)
 		tos = old_iph->tos;
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if (!dst) {
 		/* NBMA tunnel */
 		if ((rt = skb_rtable(skb)) == NULL) {
@@ -547,7 +548,6 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb->transport_header = skb->network_header;
 	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);
-- 
1.8.1.2

