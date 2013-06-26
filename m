Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3FZCpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:45:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54130 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126Ab3FZCp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:29 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "Daniel Petre" <daniel.petre@rcs-rds.ro>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.172204640@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [18/26] ip_tunnel: fix kernel panic with icmp_dest_unreach
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/ip_gre.c | 2 +-
 net/ipv4/ipip.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index d55110e..5f28fab 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -716,6 +716,7 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 		tiph = &tunnel->parms.iph;
 	}
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if ((dst = tiph->daddr) == 0) {
 		/* NBMA tunnel */
 
@@ -851,7 +852,6 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 	skb_reset_transport_header(skb);
 	skb_push(skb, gre_hlen);
 	skb_reset_network_header(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 17ad951..5dc5137 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -448,6 +448,7 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (tos & 1)
 		tos = old_iph->tos;
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if (!dst) {
 		/* NBMA tunnel */
 		if ((rt = skb_rtable(skb)) == NULL) {
@@ -531,7 +532,6 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb->transport_header = skb->network_header;
 	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);

