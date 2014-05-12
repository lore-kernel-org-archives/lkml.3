Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaELBl0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:41:26 -0400
Received: from 1wt.eu ([62.212.114.60]:34309 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaELBlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:23 -0400
Message-Id: <20140512003200.845173039@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 005/143] ipvs: fix CHECKSUM_PARTIAL for TCP, UDP
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

 	Fix CHECKSUM_PARTIAL handling. Tested for IPv4 TCP,
UDP not tested because it needs network card with HW CSUM support.
May be fixes problem where IPVS can not be used in virtual boxes.
Problem appears with DNAT to local address when the local stack
sends reply in CHECKSUM_PARTIAL mode.

 	Fix tcp_dnat_handler and udp_dnat_handler to provide
vaddr and daddr in right order (old and new IP) when calling
tcp_partial_csum_update/udp_partial_csum_update (CHECKSUM_PARTIAL).

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
(cherry picked from commit 5bc9068e9d962ca6b8bec3f0eb6f60ab4dee1d04)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/netfilter/ipvs/ip_vs_proto_tcp.c | 10 +++++-----
 net/netfilter/ipvs/ip_vs_proto_udp.c | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 91d28e0..d462b0d 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -147,15 +147,15 @@ tcp_partial_csum_update(int af, struct tcphdr *tcph,
 #ifdef CONFIG_IP_VS_IPV6
 	if (af == AF_INET6)
 		tcph->check =
-			csum_fold(ip_vs_check_diff16(oldip->ip6, newip->ip6,
+			~csum_fold(ip_vs_check_diff16(oldip->ip6, newip->ip6,
 					 ip_vs_check_diff2(oldlen, newlen,
-						~csum_unfold(tcph->check))));
+						csum_unfold(tcph->check))));
 	else
 #endif
 	tcph->check =
-		csum_fold(ip_vs_check_diff4(oldip->ip, newip->ip,
+		~csum_fold(ip_vs_check_diff4(oldip->ip, newip->ip,
 				ip_vs_check_diff2(oldlen, newlen,
-						~csum_unfold(tcph->check))));
+						csum_unfold(tcph->check))));
 }
 
 
@@ -269,7 +269,7 @@ tcp_dnat_handler(struct sk_buff *skb,
 	 *	Adjust TCP checksums
 	 */
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		tcp_partial_csum_update(cp->af, tcph, &cp->daddr, &cp->vaddr,
+		tcp_partial_csum_update(cp->af, tcph, &cp->vaddr, &cp->daddr,
 					htons(oldlen),
 					htons(skb->len - tcphoff));
 	} else if (!cp->app) {
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index e7a6885..c1781f5 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -154,15 +154,15 @@ udp_partial_csum_update(int af, struct udphdr *uhdr,
 #ifdef CONFIG_IP_VS_IPV6
 	if (af == AF_INET6)
 		uhdr->check =
-			csum_fold(ip_vs_check_diff16(oldip->ip6, newip->ip6,
+			~csum_fold(ip_vs_check_diff16(oldip->ip6, newip->ip6,
 					 ip_vs_check_diff2(oldlen, newlen,
-						~csum_unfold(uhdr->check))));
+						csum_unfold(uhdr->check))));
 	else
 #endif
 	uhdr->check =
-		csum_fold(ip_vs_check_diff4(oldip->ip, newip->ip,
+		~csum_fold(ip_vs_check_diff4(oldip->ip, newip->ip,
 				ip_vs_check_diff2(oldlen, newlen,
-						~csum_unfold(uhdr->check))));
+						csum_unfold(uhdr->check))));
 }
 
 
@@ -205,7 +205,7 @@ udp_snat_handler(struct sk_buff *skb,
 	 *	Adjust UDP checksums
 	 */
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		udp_partial_csum_update(cp->af, udph, &cp->daddr, &cp->vaddr,
+		udp_partial_csum_update(cp->af, udph, &cp->vaddr, &cp->daddr,
 					htons(oldlen),
 					htons(skb->len - udphoff));
 	} else if (!cp->app && (udph->check != 0)) {
-- 
1.7.12.2.21.g234cd45.dirty



