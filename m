Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab3FYTBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:01:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3FYSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Petre <daniel.petre@rcs-rds.ro>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 55/95] ip_tunnel: fix kernel panic with icmp_dest_unreach
Date: Tue, 25 Jun 2013 11:32:42 -0700
Message-Id: <20130625182159.856000678@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |    2 +-
 net/ipv4/ipip.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -804,6 +804,7 @@ static netdev_tx_t ipgre_tunnel_xmit(str
 		tiph = &tunnel->parms.iph;
 	}
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if ((dst = tiph->daddr) == 0) {
 		/* NBMA tunnel */
 
@@ -952,7 +953,6 @@ static netdev_tx_t ipgre_tunnel_xmit(str
 	skb_push(skb, gre_hlen);
 	skb_reset_network_header(skb);
 	skb_set_transport_header(skb, sizeof(*iph));
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -491,6 +491,7 @@ static netdev_tx_t ipip_tunnel_xmit(stru
 	if (tos & 1)
 		tos = old_iph->tos;
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if (!dst) {
 		/* NBMA tunnel */
 		if ((rt = skb_rtable(skb)) == NULL) {
@@ -573,7 +574,6 @@ static netdev_tx_t ipip_tunnel_xmit(stru
 	skb->transport_header = skb->network_header;
 	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);


