Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaDFXkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:40:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59480 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbaDFXjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Herbert Xu" <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Marcelo Ricardo Leitner" <mleitner@redhat.com>,
        "Florian Westphal" <fw@strlen.de>
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.608966197@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 08/18] net: ip, ipv6: handle gso skbs in forwarding path
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit fe6cc55f3a9a053482a76f5a6b2257cee51b4663 upstream.

[ use zero netdev_feature mask to avoid backport of
  netif_skb_dev_features function ]

Marcelo Ricardo Leitner reported problems when the forwarding link path
has a lower mtu than the incoming one if the inbound interface supports GRO.

Given:
Host <mtu1500> R1 <mtu1200> R2

Host sends tcp stream which is routed via R1 and R2.  R1 performs GRO.

In this case, the kernel will fail to send ICMP fragmentation needed
messages (or pkt too big for ipv6), as GSO packets currently bypass dstmtu
checks in forward path. Instead, Linux tries to send out packets exceeding
the mtu.

When locking route MTU on Host (i.e., no ipv4 DF bit set), R1 does
not fragment the packets when forwarding, and again tries to send out
packets exceeding R1-R2 link mtu.

This alters the forwarding dstmtu checks to take the individual gso
segment lengths into account.

For ipv6, we send out pkt too big error for gso if the individual
segments are too big.

For ipv4, we either send icmp fragmentation needed, or, if the DF bit
is not set, perform software segmentation and let the output path
create fragments when the packet is leaving the machine.
It is not 100% correct as the error message will contain the headers of
the GRO skb instead of the original/segmented one, but it seems to
work fine in my (limited) tests.

Eric Dumazet suggested to simply shrink mss via ->gso_size to avoid
sofware segmentation.

However it turns out that skb_segment() assumes skb nr_frags is related
to mss size so we would BUG there.  I don't want to mess with it considering
Herbert and Eric disagree on what the correct behavior should be.

Hannes Frederic Sowa notes that when we would shrink gso_size
skb_segment would then also need to deal with the case where
SKB_MAX_FRAGS would be exceeded.

This uses sofware segmentation in the forward path when we hit ipv4
non-DF packets and the outgoing link mtu is too small.  Its not perfect,
but given the lack of bug reports wrt. GRO fwd being broken this is a
rare case anyway.  Also its not like this could not be improved later
once the dust settles.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Reported-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/skbuff.h | 17 +++++++++++++
 net/ipv4/ip_forward.c  | 68 ++++++++++++++++++++++++++++++++++++++++++++++++--
 net/ipv6/ip6_output.c  | 13 +++++++++-
 3 files changed, 95 insertions(+), 3 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2557,5 +2557,22 @@ static inline bool skb_is_recycleable(co
 
 	return true;
 }
+
+/**
+ * skb_gso_network_seglen - Return length of individual segments of a gso packet
+ *
+ * @skb: GSO skb
+ *
+ * skb_gso_network_seglen is used to determine the real size of the
+ * individual segments, including Layer3 (IP, IPv6) and L4 headers (TCP/UDP).
+ *
+ * The MAC/L2 header is not accounted for.
+ */
+static inline unsigned int skb_gso_network_seglen(const struct sk_buff *skb)
+{
+	unsigned int hdr_len = skb_transport_header(skb) -
+			       skb_network_header(skb);
+	return hdr_len + skb_gso_transport_seglen(skb);
+}
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -39,6 +39,68 @@
 #include <net/route.h>
 #include <net/xfrm.h>
 
+static bool ip_may_fragment(const struct sk_buff *skb)
+{
+	return unlikely((ip_hdr(skb)->frag_off & htons(IP_DF)) == 0) ||
+	       !skb->local_df;
+}
+
+static bool ip_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
+{
+	if (skb->len <= mtu || skb->local_df)
+		return false;
+
+	if (skb_is_gso(skb) && skb_gso_network_seglen(skb) <= mtu)
+		return false;
+
+	return true;
+}
+
+static bool ip_gso_exceeds_dst_mtu(const struct sk_buff *skb)
+{
+	unsigned int mtu;
+
+	if (skb->local_df || !skb_is_gso(skb))
+		return false;
+
+	mtu = dst_mtu(skb_dst(skb));
+
+	/* if seglen > mtu, do software segmentation for IP fragmentation on
+	 * output.  DF bit cannot be set since ip_forward would have sent
+	 * icmp error.
+	 */
+	return skb_gso_network_seglen(skb) > mtu;
+}
+
+/* called if GSO skb needs to be fragmented on forward */
+static int ip_forward_finish_gso(struct sk_buff *skb)
+{
+	struct sk_buff *segs;
+	int ret = 0;
+
+	segs = skb_gso_segment(skb, 0);
+	if (IS_ERR(segs)) {
+		kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	consume_skb(skb);
+
+	do {
+		struct sk_buff *nskb = segs->next;
+		int err;
+
+		segs->next = NULL;
+		err = dst_output(segs);
+
+		if (err && ret == 0)
+			ret = err;
+		segs = nskb;
+	} while (segs);
+
+	return ret;
+}
+
 static int ip_forward_finish(struct sk_buff *skb)
 {
 	struct ip_options * opt	= &(IPCB(skb)->opt);
@@ -48,6 +110,9 @@ static int ip_forward_finish(struct sk_b
 	if (unlikely(opt->optlen))
 		ip_forward_options(skb);
 
+	if (ip_gso_exceeds_dst_mtu(skb))
+		return ip_forward_finish_gso(skb);
+
 	return dst_output(skb);
 }
 
@@ -87,8 +152,7 @@ int ip_forward(struct sk_buff *skb)
 	if (opt->is_strictroute && opt->nexthop != rt->rt_gateway)
 		goto sr_failed;
 
-	if (unlikely(skb->len > dst_mtu(&rt->dst) && !skb_is_gso(skb) &&
-		     (ip_hdr(skb)->frag_off & htons(IP_DF))) && !skb->local_df) {
+	if (!ip_may_fragment(skb) && ip_exceeds_mtu(skb, dst_mtu(&rt->dst))) {
 		IP_INC_STATS(dev_net(rt->dst.dev), IPSTATS_MIB_FRAGFAILS);
 		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 			  htonl(dst_mtu(&rt->dst)));
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -381,6 +381,17 @@ static inline int ip6_forward_finish(str
 	return dst_output(skb);
 }
 
+static bool ip6_pkt_too_big(const struct sk_buff *skb, unsigned int mtu)
+{
+	if (skb->len <= mtu || skb->local_df)
+		return false;
+
+	if (skb_is_gso(skb) && skb_gso_network_seglen(skb) <= mtu)
+		return false;
+
+	return true;
+}
+
 int ip6_forward(struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
@@ -504,7 +515,7 @@ int ip6_forward(struct sk_buff *skb)
 	if (mtu < IPV6_MIN_MTU)
 		mtu = IPV6_MIN_MTU;
 
-	if (skb->len > mtu && !skb_is_gso(skb)) {
+	if (ip6_pkt_too_big(skb, mtu)) {
 		/* Again, force OUTPUT device used as source address */
 		skb->dev = dst->dev;
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);

