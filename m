Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3FDWx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:53:26 -0400
Received: from 1wt.eu ([62.212.114.60]:35813 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab3FDWny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:54 -0400
Message-Id: <20130604172137.353871854@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Julian Anastasov <ja@ssi.bg>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Simon Horman <horms@verge.net.au>, Willy Tarreau <w@1wt.eu>
Subject: [ 170/184] ipvs: allow transmit of GRO aggregated skbs
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@verge.net.au>

Attempt at allowing LVS to transmit skbs of greater than MTU length that
have been aggregated by GRO and can thus be deaggregated by GSO.

Cc: Julian Anastasov <ja@ssi.bg>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Simon Horman <horms@verge.net.au>
(cherry picked from commit 8f1b03a4c18e8f3f0801447b62330faa8ed3bb37)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 30b3189..dd7da3c 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -245,7 +245,8 @@ ip_vs_bypass_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	/* MTU checking */
 	mtu = dst_mtu(&rt->u.dst);
-	if ((skb->len > mtu) && (iph->frag_off & htons(IP_DF))) {
+	if ((skb->len > mtu) && (iph->frag_off & htons(IP_DF)) &&
+	    !skb_is_gso(skb)) {
 		ip_rt_put(rt);
 		icmp_send(skb, ICMP_DEST_UNREACH,ICMP_FRAG_NEEDED, htonl(mtu));
 		IP_VS_DBG_RL("%s(): frag needed\n", __func__);
@@ -309,7 +310,7 @@ ip_vs_bypass_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	/* MTU checking */
 	mtu = dst_mtu(&rt->u.dst);
-	if (skb->len > mtu) {
+	if (skb->len > mtu && !skb_is_gso(skb)) {
 		dst_release(&rt->u.dst);
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu, skb->dev);
 		IP_VS_DBG_RL("%s(): frag needed\n", __func__);
@@ -376,7 +377,7 @@ ip_vs_nat_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	/* MTU checking */
 	mtu = dst_mtu(&rt->u.dst);
-	if ((skb->len > mtu) && (iph->frag_off & htons(IP_DF))) {
+	if ((skb->len > mtu) && (iph->frag_off & htons(IP_DF)) && !skb_is_gso(skb)) {
 		ip_rt_put(rt);
 		icmp_send(skb, ICMP_DEST_UNREACH,ICMP_FRAG_NEEDED, htonl(mtu));
 		IP_VS_DBG_RL_PKT(0, pp, skb, 0, "ip_vs_nat_xmit(): frag needed for");
@@ -452,7 +453,7 @@ ip_vs_nat_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	/* MTU checking */
 	mtu = dst_mtu(&rt->u.dst);
-	if (skb->len > mtu) {
+	if (skb->len > mtu && !skb_is_gso(skb)) {
 		dst_release(&rt->u.dst);
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu, skb->dev);
 		IP_VS_DBG_RL_PKT(0, pp, skb, 0,
@@ -561,8 +562,8 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	df |= (old_iph->frag_off & htons(IP_DF));
 
-	if ((old_iph->frag_off & htons(IP_DF))
-	    && mtu < ntohs(old_iph->tot_len)) {
+	if ((old_iph->frag_off & htons(IP_DF) &&
+	    mtu < ntohs(old_iph->tot_len) && !skb_is_gso(skb))) {
 		icmp_send(skb, ICMP_DEST_UNREACH,ICMP_FRAG_NEEDED, htonl(mtu));
 		ip_rt_put(rt);
 		IP_VS_DBG_RL("%s(): frag needed\n", __func__);
@@ -671,7 +672,7 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	if (skb_dst(skb))
 		skb_dst(skb)->ops->update_pmtu(skb_dst(skb), mtu);
 
-	if (mtu < ntohs(old_iph->payload_len) + sizeof(struct ipv6hdr)) {
+	if (mtu < ntohs(old_iph->payload_len) + sizeof(struct ipv6hdr) && !skb_is_gso(skb)) {
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu, skb->dev);
 		dst_release(&rt->u.dst);
 		IP_VS_DBG_RL("%s(): frag needed\n", __func__);
@@ -760,7 +761,7 @@ ip_vs_dr_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	/* MTU checking */
 	mtu = dst_mtu(&rt->u.dst);
-	if ((iph->frag_off & htons(IP_DF)) && skb->len > mtu) {
+	if ((iph->frag_off & htons(IP_DF)) && skb->len > mtu && !skb_is_gso(skb)) {
 		icmp_send(skb, ICMP_DEST_UNREACH,ICMP_FRAG_NEEDED, htonl(mtu));
 		ip_rt_put(rt);
 		IP_VS_DBG_RL("%s(): frag needed\n", __func__);
@@ -888,7 +889,7 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	/* MTU checking */
 	mtu = dst_mtu(&rt->u.dst);
-	if ((skb->len > mtu) && (ip_hdr(skb)->frag_off & htons(IP_DF))) {
+	if ((skb->len > mtu) && (ip_hdr(skb)->frag_off & htons(IP_DF)) && !skb_is_gso(skb)) {
 		ip_rt_put(rt);
 		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED, htonl(mtu));
 		IP_VS_DBG_RL("%s(): frag needed\n", __func__);
@@ -963,7 +964,7 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	/* MTU checking */
 	mtu = dst_mtu(&rt->u.dst);
-	if (skb->len > mtu) {
+	if (skb->len > mtu && !skb_is_gso(skb)) {
 		dst_release(&rt->u.dst);
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu, skb->dev);
 		IP_VS_DBG_RL("%s(): frag needed\n", __func__);
-- 
1.7.12.2.21.g234cd45.dirty



