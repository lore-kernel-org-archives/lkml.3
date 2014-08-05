Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbaHESeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:34:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbaHES35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:29:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [PATCH 3.4 14/19] Revert: "net: ip, ipv6: handle gso skbs in forwarding path"
Date: Tue,  5 Aug 2014 11:29:38 -0700
Message-Id: <20140805182934.469311843@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805182934.022406678@linuxfoundation.org>
References: <20140805182934.022406678@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 29a3cd46644ec8098dbe1c12f89643b5c11831a9 which is
commit fe6cc55f3a9a053482a76f5a6b2257cee51b4663 upstream.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/skbuff.h |   17 ------------
 net/ipv4/ip_forward.c  |   68 +------------------------------------------------
 net/ipv6/ip6_output.c  |   13 ---------
 3 files changed, 3 insertions(+), 95 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2608,22 +2608,5 @@ static inline bool skb_is_recycleable(co
 
 	return true;
 }
-
-/**
- * skb_gso_network_seglen - Return length of individual segments of a gso packet
- *
- * @skb: GSO skb
- *
- * skb_gso_network_seglen is used to determine the real size of the
- * individual segments, including Layer3 (IP, IPv6) and L4 headers (TCP/UDP).
- *
- * The MAC/L2 header is not accounted for.
- */
-static inline unsigned int skb_gso_network_seglen(const struct sk_buff *skb)
-{
-	unsigned int hdr_len = skb_transport_header(skb) -
-			       skb_network_header(skb);
-	return hdr_len + skb_gso_transport_seglen(skb);
-}
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -39,68 +39,6 @@
 #include <net/route.h>
 #include <net/xfrm.h>
 
-static bool ip_may_fragment(const struct sk_buff *skb)
-{
-	return unlikely((ip_hdr(skb)->frag_off & htons(IP_DF)) == 0) ||
-		skb->local_df;
-}
-
-static bool ip_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
-{
-	if (skb->len <= mtu)
-		return false;
-
-	if (skb_is_gso(skb) && skb_gso_network_seglen(skb) <= mtu)
-		return false;
-
-	return true;
-}
-
-static bool ip_gso_exceeds_dst_mtu(const struct sk_buff *skb)
-{
-	unsigned int mtu;
-
-	if (skb->local_df || !skb_is_gso(skb))
-		return false;
-
-	mtu = dst_mtu(skb_dst(skb));
-
-	/* if seglen > mtu, do software segmentation for IP fragmentation on
-	 * output.  DF bit cannot be set since ip_forward would have sent
-	 * icmp error.
-	 */
-	return skb_gso_network_seglen(skb) > mtu;
-}
-
-/* called if GSO skb needs to be fragmented on forward */
-static int ip_forward_finish_gso(struct sk_buff *skb)
-{
-	struct sk_buff *segs;
-	int ret = 0;
-
-	segs = skb_gso_segment(skb, 0);
-	if (IS_ERR(segs)) {
-		kfree_skb(skb);
-		return -ENOMEM;
-	}
-
-	consume_skb(skb);
-
-	do {
-		struct sk_buff *nskb = segs->next;
-		int err;
-
-		segs->next = NULL;
-		err = dst_output(segs);
-
-		if (err && ret == 0)
-			ret = err;
-		segs = nskb;
-	} while (segs);
-
-	return ret;
-}
-
 static int ip_forward_finish(struct sk_buff *skb)
 {
 	struct ip_options * opt	= &(IPCB(skb)->opt);
@@ -110,9 +48,6 @@ static int ip_forward_finish(struct sk_b
 	if (unlikely(opt->optlen))
 		ip_forward_options(skb);
 
-	if (ip_gso_exceeds_dst_mtu(skb))
-		return ip_forward_finish_gso(skb);
-
 	return dst_output(skb);
 }
 
@@ -152,7 +87,8 @@ int ip_forward(struct sk_buff *skb)
 	if (opt->is_strictroute && opt->nexthop != rt->rt_gateway)
 		goto sr_failed;
 
-	if (!ip_may_fragment(skb) && ip_exceeds_mtu(skb, dst_mtu(&rt->dst))) {
+	if (unlikely(skb->len > dst_mtu(&rt->dst) && !skb_is_gso(skb) &&
+		     (ip_hdr(skb)->frag_off & htons(IP_DF))) && !skb->local_df) {
 		IP_INC_STATS(dev_net(rt->dst.dev), IPSTATS_MIB_FRAGFAILS);
 		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 			  htonl(dst_mtu(&rt->dst)));
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -382,17 +382,6 @@ static inline int ip6_forward_finish(str
 	return dst_output(skb);
 }
 
-static bool ip6_pkt_too_big(const struct sk_buff *skb, unsigned int mtu)
-{
-	if (skb->len <= mtu || skb->local_df)
-		return false;
-
-	if (skb_is_gso(skb) && skb_gso_network_seglen(skb) <= mtu)
-		return false;
-
-	return true;
-}
-
 int ip6_forward(struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
@@ -514,7 +503,7 @@ int ip6_forward(struct sk_buff *skb)
 	if (mtu < IPV6_MIN_MTU)
 		mtu = IPV6_MIN_MTU;
 
-	if (ip6_pkt_too_big(skb, mtu)) {
+	if (skb->len > mtu && !skb_is_gso(skb)) {
 		/* Again, force OUTPUT device used as source address */
 		skb->dev = dst->dev;
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);


