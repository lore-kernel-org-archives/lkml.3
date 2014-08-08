Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbaHHWgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:36:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40064 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaHHUlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Christensen <pch@ordbogen.com>, Simon Horman <horms@verge.net.au>,
        Chris J Arges <chris.j.arges@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 011/259] ipvs: Fix panic due to non-linear skb
Date: Fri,  8 Aug 2014 13:37:14 -0700
Message-Id: <1407530482-4483-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Christensen <pch@ordbogen.com>

commit f44a5f45f544561302e855e7bd104e5f506ec01b upstream.

Receiving a ICMP response to an IPIP packet in a non-linear skb could
cause a kernel panic in __skb_pull.

The problem was introduced in
commit f2edb9f7706dcb2c0d9a362b2ba849efe3a97f5e ("ipvs: implement
passive PMTUD for IPIP packets").

Signed-off-by: Peter Christensen <pch@ordbogen.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 4f26ee4..3d2d2c8 100644
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
1.9.1

