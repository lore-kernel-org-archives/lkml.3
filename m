Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3FDWpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:45:00 -0400
Received: from 1wt.eu ([62.212.114.60]:35941 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab3FDWoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:55 -0400
Message-Id: <20130604172137.395791120@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jesper Dangaard Brouer <brouer@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>, Willy Tarreau <w@1wt.eu>
Subject: [ 171/184] ipvs: IPv6 MTU checking cleanup and bugfix
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Dangaard Brouer <brouer@redhat.com>

Cleaning up the IPv6 MTU checking in the IPVS xmit code, by using
a common helper function __mtu_check_toobig_v6().

The MTU check for tunnel mode can also use this helper as
ntohs(old_iph->payload_len) + sizeof(struct ipv6hdr) is qual to
skb->len.  And the 'mtu' variable have been adjusted before
calling helper.

Notice, this also fixes a bug, as the the MTU check in ip_vs_dr_xmit_v6()
were missing a check for skb_is_gso().

This bug e.g. caused issues for KVM IPVS setups, where different
Segmentation Offloading techniques are utilized, between guests,
via the virtio driver.  This resulted in very bad performance,
due to the ICMPv6 "too big" messages didn't affect the sender.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
(cherry picked from commit 590e3f79a21edd2e9857ac3ced25ba6b2a491ef8)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index dd7da3c..5be9140 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -64,6 +64,15 @@ __ip_vs_dst_check(struct ip_vs_dest *dest, u32 rtos, u32 cookie)
 	return dst;
 }
 
+static inline bool
+__mtu_check_toobig_v6(const struct sk_buff *skb, u32 mtu)
+{
+	if (skb->len > mtu && !skb_is_gso(skb)) {
+		return true; /* Packet size violate MTU size */
+	}
+	return false;
+}
+
 static struct rtable *
 __ip_vs_get_out_rt(struct ip_vs_conn *cp, u32 rtos)
 {
@@ -310,7 +319,7 @@ ip_vs_bypass_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	/* MTU checking */
 	mtu = dst_mtu(&rt->u.dst);
-	if (skb->len > mtu && !skb_is_gso(skb)) {
+	if (__mtu_check_toobig_v6(skb, mtu)) {
 		dst_release(&rt->u.dst);
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu, skb->dev);
 		IP_VS_DBG_RL("%s(): frag needed\n", __func__);
@@ -453,7 +462,7 @@ ip_vs_nat_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	/* MTU checking */
 	mtu = dst_mtu(&rt->u.dst);
-	if (skb->len > mtu && !skb_is_gso(skb)) {
+	if (__mtu_check_toobig_v6(skb, mtu)) {
 		dst_release(&rt->u.dst);
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu, skb->dev);
 		IP_VS_DBG_RL_PKT(0, pp, skb, 0,
@@ -672,7 +681,8 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	if (skb_dst(skb))
 		skb_dst(skb)->ops->update_pmtu(skb_dst(skb), mtu);
 
-	if (mtu < ntohs(old_iph->payload_len) + sizeof(struct ipv6hdr) && !skb_is_gso(skb)) {
+	/* MTU checking: Notice that 'mtu' have been adjusted before hand */
+	if (__mtu_check_toobig_v6(skb, mtu)) {
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu, skb->dev);
 		dst_release(&rt->u.dst);
 		IP_VS_DBG_RL("%s(): frag needed\n", __func__);
@@ -814,7 +824,7 @@ ip_vs_dr_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	/* MTU checking */
 	mtu = dst_mtu(&rt->u.dst);
-	if (skb->len > mtu) {
+	if (__mtu_check_toobig_v6(skb, mtu)) {
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu, skb->dev);
 		dst_release(&rt->u.dst);
 		IP_VS_DBG_RL("%s(): frag needed\n", __func__);
@@ -964,7 +974,7 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 
 	/* MTU checking */
 	mtu = dst_mtu(&rt->u.dst);
-	if (skb->len > mtu && !skb_is_gso(skb)) {
+	if (__mtu_check_toobig_v6(skb, mtu)) {
 		dst_release(&rt->u.dst);
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu, skb->dev);
 		IP_VS_DBG_RL("%s(): frag needed\n", __func__);
-- 
1.7.12.2.21.g234cd45.dirty



