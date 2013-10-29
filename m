Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab3J2SN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:13:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59593 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab3J2SJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ansis Atteka <aatteka@nicira.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 47/81] ip: generate unique IP identificator if local fragmentation is allowed
Date: Tue, 29 Oct 2013 11:04:08 -0700
Message-Id: <1383069882-11437-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ansis Atteka <aatteka@nicira.com>

[ Upstream commit 703133de331a7a7df47f31fb9de51dc6f68a9de8 ]

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ppp/pptp.c          |  2 +-
 include/net/ip.h                | 12 ++++++++----
 include/net/ipip.h              |  3 +--
 net/ipv4/igmp.c                 |  4 ++--
 net/ipv4/inetpeer.c             |  4 ++--
 net/ipv4/ip_output.c            |  6 +++---
 net/ipv4/ipmr.c                 |  2 +-
 net/ipv4/raw.c                  |  2 +-
 net/ipv4/xfrm4_mode_tunnel.c    |  2 +-
 net/netfilter/ipvs/ip_vs_xmit.c |  2 +-
 10 files changed, 21 insertions(+), 18 deletions(-)

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
index a68f838..edfa591 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -254,9 +254,11 @@ int ip_dont_fragment(struct sock *sk, struct dst_entry *dst)
 
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
@@ -268,9 +270,11 @@ static inline void ip_select_ident(struct iphdr *iph, struct dst_entry *dst, str
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
index 21947cf..ef7a40a 100644
--- a/include/net/ipip.h
+++ b/include/net/ipip.h
@@ -51,13 +51,12 @@ struct ip_tunnel_prl_entry {
 static inline void iptunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	int err;
-	struct iphdr *iph = ip_hdr(skb);
 	int pkt_len = skb->len - skb_transport_offset(skb);
 	struct pcpu_tstats *tstats = this_cpu_ptr(dev->tstats);
 
 	nf_reset(skb);
 	skb->ip_summed = CHECKSUM_NONE;
-	ip_select_ident(iph, skb_dst(skb), NULL);
+	ip_select_ident(skb, skb_dst(skb), NULL);
 
 	err = ip_local_out(skb);
 	if (likely(net_xmit_eval(err) == 0)) {
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 736ab70..f5c3722f 100644
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
index 000e3d2..33d5537 100644
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
index c3209b5..11b2d78 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -148,7 +148,7 @@ int ip_build_and_send_pkt(struct sk_buff *skb, struct sock *sk,
 	iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    = saddr;
 	iph->protocol = sk->sk_protocol;
-	ip_select_ident(iph, &rt->dst, sk);
+	ip_select_ident(skb, &rt->dst, sk);
 
 	if (opt && opt->opt.optlen) {
 		iph->ihl += opt->opt.optlen>>2;
@@ -394,7 +394,7 @@ packet_routed:
 		ip_options_build(skb, &inet_opt->opt, inet->inet_daddr, rt, 0);
 	}
 
-	ip_select_ident_more(iph, &rt->dst, sk,
+	ip_select_ident_more(skb, &rt->dst, sk,
 			     (skb_shinfo(skb)->gso_segs ?: 1) - 1);
 
 	skb->priority = sk->sk_priority;
@@ -1332,7 +1332,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	iph->ttl = ttl;
 	iph->protocol = sk->sk_protocol;
 	ip_copy_addrs(iph, fl4);
-	ip_select_ident(iph, &rt->dst, sk);
+	ip_select_ident(skb, &rt->dst, sk);
 
 	if (opt) {
 		iph->ihl += opt->optlen>>2;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index a9454cb..ae0adfe 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1606,7 +1606,7 @@ static void ip_encap(struct sk_buff *skb, __be32 saddr, __be32 daddr)
 	iph->protocol	=	IPPROTO_IPIP;
 	iph->ihl	=	5;
 	iph->tot_len	=	htons(skb->len);
-	ip_select_ident(iph, skb_dst(skb), NULL);
+	ip_select_ident(skb, skb_dst(skb), NULL);
 	ip_send_check(iph);
 
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 47b4797..a9b4ef3 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -389,7 +389,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 		iph->check   = 0;
 		iph->tot_len = htons(length);
 		if (!iph->id)
-			ip_select_ident(iph, &rt->dst, NULL);
+			ip_select_ident(skb, &rt->dst, NULL);
 
 		iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
 	}
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index ddee0a0..91ab23b 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -113,7 +113,7 @@ static int xfrm4_mode_tunnel_output(struct xfrm_state *x, struct sk_buff *skb)
 
 	top_iph->frag_off = (flags & XFRM_STATE_NOPMTUDISC) ?
 		0 : (XFRM_MODE_SKB_CB(skb)->frag_off & htons(IP_DF));
-	ip_select_ident(top_iph, dst->child, NULL);
+	ip_select_ident(skb, dst->child, NULL);
 
 	top_iph->ttl = ip4_dst_hoplimit(dst->child);
 
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index ee6b7a9..658490d 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -906,7 +906,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	iph->daddr		=	cp->daddr.ip;
 	iph->saddr		=	saddr;
 	iph->ttl		=	old_iph->ttl;
-	ip_select_ident(iph, &rt->dst, NULL);
+	ip_select_ident(skb, &rt->dst, NULL);
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;
-- 
1.8.1.2

