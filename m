Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030236AbaGRNGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:06:34 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17172 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932739AbaGRNCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:02:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Christensen <pch@ordbogen.com>,
        Simon Horman <horms@verge.net.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 052/170] ipvs: Fix panic due to non-linear skb
Date: Fri, 18 Jul 2014 14:10:57 +0200
Message-Id: <8391d35ef8245102821c29553fa7b5db545f9446.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Christensen <pch@ordbogen.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f44a5f45f544561302e855e7bd104e5f506ec01b upstream.

Receiving a ICMP response to an IPIP packet in a non-linear skb could
cause a kernel panic in __skb_pull.

The problem was introduced in
commit f2edb9f7706dcb2c0d9a362b2ba849efe3a97f5e ("ipvs: implement
passive PMTUD for IPIP packets").

Signed-off-by: Peter Christensen <pch@ordbogen.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/netfilter/ipvs/ip_vs_core.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 3581736446d5..e2d38e5318d4 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1392,15 +1392,19 @@ ip_vs_in_icmp(struct sk_buff *skb, int *related, unsigned int hooknum)
 
 	if (ipip) {
 		__be32 info = ic->un.gateway;
+		__u8 type = ic->type;
+		__u8 code = ic->code;
 
 		/* Update the MTU */
 		if (ic->type == ICMP_DEST_UNREACH &&
 		    ic->code == ICMP_FRAG_NEEDED) {
 			struct ip_vs_dest *dest = cp->dest;
 			u32 mtu = ntohs(ic->un.frag.mtu);
+			__be16 frag_off = cih->frag_off;
 
 			/* Strip outer IP and ICMP, go to IPIP header */
-			__skb_pull(skb, ihl + sizeof(_icmph));
+			if (pskb_pull(skb, ihl + sizeof(_icmph)) == NULL)
+				goto ignore_ipip;
 			offset2 -= ihl + sizeof(_icmph);
 			skb_reset_network_header(skb);
 			IP_VS_DBG(12, "ICMP for IPIP %pI4->%pI4: mtu=%u\n",
@@ -1408,7 +1412,7 @@ ip_vs_in_icmp(struct sk_buff *skb, int *related, unsigned int hooknum)
 			ipv4_update_pmtu(skb, dev_net(skb->dev),
 					 mtu, 0, 0, 0, 0);
 			/* Client uses PMTUD? */
-			if (!(cih->frag_off & htons(IP_DF)))
+			if (!(frag_off & htons(IP_DF)))
 				goto ignore_ipip;
 			/* Prefer the resulting PMTU */
 			if (dest) {
@@ -1427,12 +1431,13 @@ ip_vs_in_icmp(struct sk_buff *skb, int *related, unsigned int hooknum)
 		/* Strip outer IP, ICMP and IPIP, go to IP header of
 		 * original request.
 		 */
-		__skb_pull(skb, offset2);
+		if (pskb_pull(skb, offset2) == NULL)
+			goto ignore_ipip;
 		skb_reset_network_header(skb);
 		IP_VS_DBG(12, "Sending ICMP for %pI4->%pI4: t=%u, c=%u, i=%u\n",
 			&ip_hdr(skb)->saddr, &ip_hdr(skb)->daddr,
-			ic->type, ic->code, ntohl(info));
-		icmp_send(skb, ic->type, ic->code, info);
+			type, code, ntohl(info));
+		icmp_send(skb, type, code, info);
 		/* ICMP can be shorter but anyways, account it */
 		ip_vs_out_stats(cp, skb);
 
-- 
2.0.0

