Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbaCDVXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:23:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbaCDUDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 056/172] net: ip, ipv6: handle gso skbs in forwarding path
Date: Tue,  4 Mar 2014 12:02:20 -0800
Message-Id: <20140304200301.524097111@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit fe6cc55f3a9a053482a76f5a6b2257cee51b4663 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |   17 +++++++++++
 net/ipv4/ip_forward.c  |   71 +++++++++++++++++++++++++++++++++++++++++++++++--
 net/ipv6/ip6_output.c  |   17 ++++++++++-
 3 files changed, 101 insertions(+), 4 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2811,5 +2811,22 @@ static inline bool skb_head_is_locked(co
 {
 	return !skb->head_frag || skb_cloned(skb);
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
@@ -39,6 +39,71 @@
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
+	struct dst_entry *dst = skb_dst(skb);
+	netdev_features_t features;
+	struct sk_buff *segs;
+	int ret = 0;
+
+	features = netif_skb_dev_features(skb, dst->dev);
+	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
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
 	struct ip_options *opt	= &(IPCB(skb)->opt);
@@ -49,6 +114,9 @@ static int ip_forward_finish(struct sk_b
 	if (unlikely(opt->optlen))
 		ip_forward_options(skb);
 
+	if (ip_gso_exceeds_dst_mtu(skb))
+		return ip_forward_finish_gso(skb);
+
 	return dst_output(skb);
 }
 
@@ -88,8 +156,7 @@ int ip_forward(struct sk_buff *skb)
 	if (opt->is_strictroute && rt->rt_uses_gateway)
 		goto sr_failed;
 
-	if (unlikely(skb->len > dst_mtu(&rt->dst) && !skb_is_gso(skb) &&
-		     (ip_hdr(skb)->frag_off & htons(IP_DF))) && !skb->local_df) {
+	if (!ip_may_fragment(skb) && ip_exceeds_mtu(skb, dst_mtu(&rt->dst))) {
 		IP_INC_STATS(dev_net(rt->dst.dev), IPSTATS_MIB_FRAGFAILS);
 		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 			  htonl(dst_mtu(&rt->dst)));
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -321,6 +321,20 @@ static inline int ip6_forward_finish(str
 	return dst_output(skb);
 }
 
+static bool ip6_pkt_too_big(const struct sk_buff *skb, unsigned int mtu)
+{
+	if (skb->len <= mtu || skb->local_df)
+		return false;
+
+	if (IP6CB(skb)->frag_max_size && IP6CB(skb)->frag_max_size > mtu)
+		return true;
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
@@ -443,8 +457,7 @@ int ip6_forward(struct sk_buff *skb)
 	if (mtu < IPV6_MIN_MTU)
 		mtu = IPV6_MIN_MTU;
 
-	if ((!skb->local_df && skb->len > mtu && !skb_is_gso(skb)) ||
-	    (IP6CB(skb)->frag_max_size && IP6CB(skb)->frag_max_size > mtu)) {
+	if (ip6_pkt_too_big(skb, mtu)) {
 		/* Again, force OUTPUT device used as source address */
 		skb->dev = dst->dev;
 		icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);


