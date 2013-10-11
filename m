Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab3JKK6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:58:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58625 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab3JKKnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ansis Atteka <aatteka@nicira.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 056/100] ip: generate unique IP identificator if local fragmentation is allowed
Date: Fri, 11 Oct 2013 11:41:26 +0100
Message-Id: <1381488130-30235-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ansis Atteka <aatteka@nicira.com>

commit 703133de331a7a7df47f31fb9de51dc6f68a9de8 upstream.

If local fragmentation is allowed, then ip_select_ident() and
ip_select_ident_more() need to generate unique IDs to ensure
correct defragmentation on the peer.

For example, if IPsec (tunnel mode) has to encrypt large skbs
that have local_df bit set, then all IP fragments that belonged
to different ESP datagrams would have used the same identificator.
If one of these IP fragments would get lost or reordered, then
peer could possibly stitch together wrong IP fragments that did
not belong to the same datagram. This would lead to a packet loss
or data corruption.

Signed-off-by: Ansis Atteka <aatteka@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5 (based on davem backport to 3.4):
  - adjusted context
  - modified to __IPTUNNEL_XMIT macro ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ppp/pptp.c          |  2 +-
 include/net/ip.h                | 12 ++++++++----
 include/net/ipip.h              |  2 +-
 net/ipv4/igmp.c                 |  4 ++--
 net/ipv4/inetpeer.c             |  4 ++--
 net/ipv4/ip_output.c            |  6 +++---
 net/ipv4/ipmr.c                 |  2 +-
 net/ipv4/raw.c                  |  2 +-
 net/ipv4/xfrm4_mode_tunnel.c    |  2 +-
 net/netfilter/ipvs/ip_vs_xmit.c |  2 +-
 10 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 162464f..7f10588 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -281,7 +281,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	nf_reset(skb);
 
 	skb->ip_summed = CHECKSUM_NONE;
-	ip_select_ident(iph, &rt->dst, NULL);
+	ip_select_ident(skb, &rt->dst, NULL);
 	ip_send_check(iph);
 
 	ip_local_out(skb);
diff --git a/include/net/ip.h b/include/net/ip.h
index 83e0619..d34f531 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -246,9 +246,11 @@ int ip_dont_fragment(struct sock *sk, struct dst_entry *dst)
 
 extern void __ip_select_ident(struct iphdr *iph, struct dst_entry *dst, int more);
 
-static inline void ip_select_ident(struct iphdr *iph, struct dst_entry *dst, struct sock *sk)
+static inline void ip_select_ident(struct sk_buff *skb, struct dst_entry *dst, struct sock *sk)
 {
-	if (iph->frag_off & htons(IP_DF)) {
+	struct iphdr *iph = ip_hdr(skb);
+
+	if ((iph->frag_off & htons(IP_DF)) && !skb->local_df) {
 		/* This is only to work around buggy Windows95/2000
 		 * VJ compression implementations.  If the ID field
 		 * does not change, they drop every other packet in
@@ -260,9 +262,11 @@ static inline void ip_select_ident(struct iphdr *iph, struct dst_entry *dst, str
 		__ip_select_ident(iph, dst, 0);
 }
 
-static inline void ip_select_ident_more(struct iphdr *iph, struct dst_entry *dst, struct sock *sk, int more)
+static inline void ip_select_ident_more(struct sk_buff *skb, struct dst_entry *dst, struct sock *sk, int more)
 {
-	if (iph->frag_off & htons(IP_DF)) {
+	struct iphdr *iph = ip_hdr(skb);
+
+	if ((iph->frag_off & htons(IP_DF)) && !skb->local_df) {
 		if (sk && inet_sk(sk)->inet_daddr) {
 			iph->id = htons(inet_sk(sk)->inet_id);
 			inet_sk(sk)->inet_id += 1 + more;
diff --git a/include/net/ipip.h b/include/net/ipip.h
index a93cf6d..1157ab8 100644
--- a/include/net/ipip.h
+++ b/include/net/ipip.h
@@ -50,7 +50,7 @@ struct ip_tunnel_prl_entry {
 	int pkt_len = skb->len - skb_transport_offset(skb);		\
 									\
 	skb->ip_summed = CHECKSUM_NONE;					\
-	ip_select_ident(iph, &rt->dst, NULL);				\
+	ip_select_ident(skb, &rt->dst, NULL);				\
 									\
 	err = ip_local_out(skb);					\
 	if (likely(net_xmit_eval(err) == 0)) {				\
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 6699f23..ca66431 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -343,7 +343,7 @@ static struct sk_buff *igmpv3_newpack(struct net_device *dev, int size)
 	pip->saddr    = fl4.saddr;
 	pip->protocol = IPPROTO_IGMP;
 	pip->tot_len  = 0;	/* filled in later */
-	ip_select_ident(pip, &rt->dst, NULL);
+	ip_select_ident(skb, &rt->dst, NULL);
 	((u8 *)&pip[1])[0] = IPOPT_RA;
 	((u8 *)&pip[1])[1] = 4;
 	((u8 *)&pip[1])[2] = 0;
@@ -687,7 +687,7 @@ static int igmp_send_report(struct in_device *in_dev, struct ip_mc_list *pmc,
 	iph->daddr    = dst;
 	iph->saddr    = fl4.saddr;
 	iph->protocol = IPPROTO_IGMP;
-	ip_select_ident(iph, &rt->dst, NULL);
+	ip_select_ident(skb, &rt->dst, NULL);
 	((u8 *)&iph[1])[0] = IPOPT_RA;
 	((u8 *)&iph[1])[1] = 4;
 	((u8 *)&iph[1])[2] = 0;
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index dfba343..d63a926 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -32,8 +32,8 @@
  *  At the moment of writing this notes identifier of IP packets is generated
  *  to be unpredictable using this code only for packets subjected
  *  (actually or potentially) to defragmentation.  I.e. DF packets less than
- *  PMTU in size uses a constant ID and do not use this code (see
- *  ip_select_ident() in include/net/ip.h).
+ *  PMTU in size when local fragmentation is disabled use a constant ID and do
+ *  not use this code (see ip_select_ident() in include/net/ip.h).
  *
  *  Route cache entries hold references to our nodes.
  *  New cache entries get references via lookup by destination IP address in
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 50009a1..7ee32c6 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -161,7 +161,7 @@ int ip_build_and_send_pkt(struct sk_buff *skb, struct sock *sk,
 	iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    = saddr;
 	iph->protocol = sk->sk_protocol;
-	ip_select_ident(iph, &rt->dst, sk);
+	ip_select_ident(skb, &rt->dst, sk);
 
 	if (opt && opt->opt.optlen) {
 		iph->ihl += opt->opt.optlen>>2;
@@ -403,7 +403,7 @@ packet_routed:
 		ip_options_build(skb, &inet_opt->opt, inet->inet_daddr, rt, 0);
 	}
 
-	ip_select_ident_more(iph, &rt->dst, sk,
+	ip_select_ident_more(skb, &rt->dst, sk,
 			     (skb_shinfo(skb)->gso_segs ?: 1) - 1);
 
 	skb->priority = sk->sk_priority;
@@ -1347,7 +1347,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	iph->ihl = 5;
 	iph->tos = inet->tos;
 	iph->frag_off = df;
-	ip_select_ident(iph, &rt->dst, sk);
+	ip_select_ident(skb, &rt->dst, sk);
 	iph->ttl = ttl;
 	iph->protocol = sk->sk_protocol;
 	ip_copy_addrs(iph, fl4);
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 9be3d17..f780fa3 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1572,7 +1572,7 @@ static void ip_encap(struct sk_buff *skb, __be32 saddr, __be32 daddr)
 	iph->protocol	=	IPPROTO_IPIP;
 	iph->ihl	=	5;
 	iph->tot_len	=	htons(skb->len);
-	ip_select_ident(iph, skb_dst(skb), NULL);
+	ip_select_ident(skb, skb_dst(skb), NULL);
 	ip_send_check(iph);
 
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index d53aa77..0753bd7 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -384,7 +384,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 		iph->check   = 0;
 		iph->tot_len = htons(length);
 		if (!iph->id)
-			ip_select_ident(iph, &rt->dst, NULL);
+			ip_select_ident(skb, &rt->dst, NULL);
 
 		iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
 	}
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index ed4bf11..938553e 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -54,7 +54,7 @@ static int xfrm4_mode_tunnel_output(struct xfrm_state *x, struct sk_buff *skb)
 
 	top_iph->frag_off = (flags & XFRM_STATE_NOPMTUDISC) ?
 		0 : (XFRM_MODE_SKB_CB(skb)->frag_off & htons(IP_DF));
-	ip_select_ident(top_iph, dst->child, NULL);
+	ip_select_ident(skb, dst->child, NULL);
 
 	top_iph->ttl = ip4_dst_hoplimit(dst->child);
 
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 7fd66de..ec78ab6 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -853,7 +853,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	iph->daddr		=	cp->daddr.ip;
 	iph->saddr		=	saddr;
 	iph->ttl		=	old_iph->ttl;
-	ip_select_ident(iph, &rt->dst, NULL);
+	ip_select_ident(skb, &rt->dst, NULL);
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;
-- 
1.8.3.2

