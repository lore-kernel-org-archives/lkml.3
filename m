Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbaIOXXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:23:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50473 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349AbaIOWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:10:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 004/187] inetpeer: get rid of ip_id_count
Date: Mon, 15 Sep 2014 15:06:54 -0700
Message-Id: <1410818997-9432-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 73f156a6e8c1074ac6327e0abd1169e95eb66463 ]

Ideally, we would need to generate IP ID using a per destination IP
generator.

linux kernels used inet_peer cache for this purpose, but this had a huge
cost on servers disabling MTU discovery.

1) each inet_peer struct consumes 192 bytes

2) inetpeer cache uses a binary tree of inet_peer structs,
   with a nominal size of ~66000 elements under load.

3) lookups in this tree are hitting a lot of cache lines, as tree depth
   is about 20.

4) If server deals with many tcp flows, we have a high probability of
   not finding the inet_peer, allocating a fresh one, inserting it in
   the tree with same initial ip_id_count, (cf secure_ip_id())

5) We garbage collect inet_peer aggressively.

IP ID generation do not have to be 'perfect'

Goal is trying to avoid duplicates in a short period of time,
so that reassembly units have a chance to complete reassembly of
fragments belonging to one message before receiving other fragments
with a recycled ID.

We simply use an array of generators, and a Jenkin hash using the dst IP
as a key.

ipv6_select_ident() is put back into net/ipv6/ip6_output.c where it
belongs (it is only used from this file)

secure_ip_id() and secure_ipv6_id() no longer are needed.

Rename ip_select_ident_more() to ip_select_ident_segs() to avoid
unnecessary decrement/increment of the number of segments.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ppp/pptp.c          |  2 +-
 include/net/inetpeer.h          | 16 +++------------
 include/net/ip.h                | 40 ++++++++++++++++++++----------------
 include/net/ipv6.h              |  2 --
 include/net/secure_seq.h        |  2 --
 net/core/secure_seq.c           | 25 -----------------------
 net/ipv4/igmp.c                 |  4 ++--
 net/ipv4/inetpeer.c             | 18 -----------------
 net/ipv4/ip_output.c            |  7 +++----
 net/ipv4/ip_tunnel_core.c       |  2 +-
 net/ipv4/ipmr.c                 |  2 +-
 net/ipv4/raw.c                  |  2 +-
 net/ipv4/route.c                | 45 +++++++++++++++--------------------------
 net/ipv4/xfrm4_mode_tunnel.c    |  2 +-
 net/ipv6/ip6_output.c           | 12 +++++++++++
 net/ipv6/output_core.c          | 23 ---------------------
 net/netfilter/ipvs/ip_vs_xmit.c |  2 +-
 17 files changed, 65 insertions(+), 141 deletions(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 0180531..1aff970 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -281,7 +281,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	nf_reset(skb);
 
 	skb->ip_summed = CHECKSUM_NONE;
-	ip_select_ident(skb, &rt->dst, NULL);
+	ip_select_ident(skb, NULL);
 	ip_send_check(iph);
 
 	ip_local_out(skb);
diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index 9a93930..83cf417 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -41,14 +41,13 @@ struct inet_peer {
 		struct rcu_head     gc_rcu;
 	};
 	/*
-	 * Once inet_peer is queued for deletion (refcnt == -1), following fields
-	 * are not available: rid, ip_id_count
+	 * Once inet_peer is queued for deletion (refcnt == -1), following field
+	 * is not available: rid
 	 * We can share memory with rcu_head to help keep inet_peer small.
 	 */
 	union {
 		struct {
 			atomic_t			rid;		/* Frag reception counter */
-			atomic_t			ip_id_count;	/* IP ID for the next packet */
 		};
 		struct rcu_head         rcu;
 		struct inet_peer	*gc_next;
@@ -166,7 +165,7 @@ void inetpeer_invalidate_tree(struct inet_peer_base *);
 void inetpeer_invalidate_family(int family);
 
 /*
- * temporary check to make sure we dont access rid, ip_id_count, tcp_ts,
+ * temporary check to make sure we dont access rid, tcp_ts,
  * tcp_ts_stamp if no refcount is taken on inet_peer
  */
 static inline void inet_peer_refcheck(const struct inet_peer *p)
@@ -174,13 +173,4 @@ static inline void inet_peer_refcheck(const struct inet_peer *p)
 	WARN_ON_ONCE(atomic_read(&p->refcnt) <= 0);
 }
 
-
-/* can be called with or without local BH being disabled */
-static inline int inet_getid(struct inet_peer *p, int more)
-{
-	more++;
-	inet_peer_refcheck(p);
-	return atomic_add_return(more, &p->ip_id_count) - more;
-}
-
 #endif /* _NET_INETPEER_H */
diff --git a/include/net/ip.h b/include/net/ip.h
index 5a25f36..3bd9cef 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -269,9 +269,19 @@ int ip_dont_fragment(struct sock *sk, struct dst_entry *dst)
 		 !(dst_metric_locked(dst, RTAX_MTU)));
 }
 
-void __ip_select_ident(struct iphdr *iph, struct dst_entry *dst, int more);
+#define IP_IDENTS_SZ 2048u
+extern atomic_t *ip_idents;
 
-static inline void ip_select_ident(struct sk_buff *skb, struct dst_entry *dst, struct sock *sk)
+static inline u32 ip_idents_reserve(u32 hash, int segs)
+{
+	atomic_t *id_ptr = ip_idents + hash % IP_IDENTS_SZ;
+
+	return atomic_add_return(segs, id_ptr) - segs;
+}
+
+void __ip_select_ident(struct iphdr *iph, int segs);
+
+static inline void ip_select_ident_segs(struct sk_buff *skb, struct sock *sk, int segs)
 {
 	struct iphdr *iph = ip_hdr(skb);
 
@@ -281,24 +291,20 @@ static inline void ip_select_ident(struct sk_buff *skb, struct dst_entry *dst, s
 		 * does not change, they drop every other packet in
 		 * a TCP stream using header compression.
 		 */
-		iph->id = (sk && inet_sk(sk)->inet_daddr) ?
-					htons(inet_sk(sk)->inet_id++) : 0;
-	} else
-		__ip_select_ident(iph, dst, 0);
-}
-
-static inline void ip_select_ident_more(struct sk_buff *skb, struct dst_entry *dst, struct sock *sk, int more)
-{
-	struct iphdr *iph = ip_hdr(skb);
-
-	if ((iph->frag_off & htons(IP_DF)) && !skb->local_df) {
 		if (sk && inet_sk(sk)->inet_daddr) {
 			iph->id = htons(inet_sk(sk)->inet_id);
-			inet_sk(sk)->inet_id += 1 + more;
-		} else
+			inet_sk(sk)->inet_id += segs;
+		} else {
 			iph->id = 0;
-	} else
-		__ip_select_ident(iph, dst, more);
+		}
+	} else {
+		__ip_select_ident(iph, segs);
+	}
+}
+
+static inline void ip_select_ident(struct sk_buff *skb, struct sock *sk)
+{
+	ip_select_ident_segs(skb, sk, 1);
 }
 
 /*
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 488316e..d164d0c 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -660,8 +660,6 @@ static inline int ipv6_addr_diff(const struct in6_addr *a1, const struct in6_add
 	return __ipv6_addr_diff(a1, a2, sizeof(struct in6_addr));
 }
 
-void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt);
-
 int ip6_dst_hoplimit(struct dst_entry *dst);
 
 /*
diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
index f257486..3f36d45 100644
--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@ -3,8 +3,6 @@
 
 #include <linux/types.h>
 
-__u32 secure_ip_id(__be32 daddr);
-__u32 secure_ipv6_id(const __be32 daddr[4]);
 u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
 u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport);
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 897da56..ba71212 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -85,31 +85,6 @@ EXPORT_SYMBOL(secure_ipv6_port_ephemeral);
 #endif
 
 #ifdef CONFIG_INET
-__u32 secure_ip_id(__be32 daddr)
-{
-	u32 hash[MD5_DIGEST_WORDS];
-
-	net_secret_init();
-	hash[0] = (__force __u32) daddr;
-	hash[1] = net_secret[13];
-	hash[2] = net_secret[14];
-	hash[3] = net_secret[15];
-
-	md5_transform(hash, net_secret);
-
-	return hash[0];
-}
-
-__u32 secure_ipv6_id(const __be32 daddr[4])
-{
-	__u32 hash[4];
-
-	net_secret_init();
-	memcpy(hash, daddr, 16);
-	md5_transform(hash, net_secret);
-
-	return hash[0];
-}
 
 __u32 secure_tcp_sequence_number(__be32 saddr, __be32 daddr,
 				 __be16 sport, __be16 dport)
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 9fa5c09..94d40cc 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -369,7 +369,7 @@ static struct sk_buff *igmpv3_newpack(struct net_device *dev, int size)
 	pip->saddr    = fl4.saddr;
 	pip->protocol = IPPROTO_IGMP;
 	pip->tot_len  = 0;	/* filled in later */
-	ip_select_ident(skb, &rt->dst, NULL);
+	ip_select_ident(skb, NULL);
 	((u8 *)&pip[1])[0] = IPOPT_RA;
 	((u8 *)&pip[1])[1] = 4;
 	((u8 *)&pip[1])[2] = 0;
@@ -714,7 +714,7 @@ static int igmp_send_report(struct in_device *in_dev, struct ip_mc_list *pmc,
 	iph->daddr    = dst;
 	iph->saddr    = fl4.saddr;
 	iph->protocol = IPPROTO_IGMP;
-	ip_select_ident(skb, &rt->dst, NULL);
+	ip_select_ident(skb, NULL);
 	((u8 *)&iph[1])[0] = IPOPT_RA;
 	((u8 *)&iph[1])[1] = 4;
 	((u8 *)&iph[1])[2] = 0;
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index 33d5537..67140ef 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -26,20 +26,7 @@
  *  Theory of operations.
  *  We keep one entry for each peer IP address.  The nodes contains long-living
  *  information about the peer which doesn't depend on routes.
- *  At this moment this information consists only of ID field for the next
- *  outgoing IP packet.  This field is incremented with each packet as encoded
- *  in inet_getid() function (include/net/inetpeer.h).
- *  At the moment of writing this notes identifier of IP packets is generated
- *  to be unpredictable using this code only for packets subjected
- *  (actually or potentially) to defragmentation.  I.e. DF packets less than
- *  PMTU in size when local fragmentation is disabled use a constant ID and do
- *  not use this code (see ip_select_ident() in include/net/ip.h).
  *
- *  Route cache entries hold references to our nodes.
- *  New cache entries get references via lookup by destination IP address in
- *  the avl tree.  The reference is grabbed only when it's needed i.e. only
- *  when we try to output IP packet which needs an unpredictable ID (see
- *  __ip_select_ident() in net/ipv4/route.c).
  *  Nodes are removed only when reference counter goes to 0.
  *  When it's happened the node may be removed when a sufficient amount of
  *  time has been passed since its last use.  The less-recently-used entry can
@@ -62,7 +49,6 @@
  *		refcnt: atomically against modifications on other CPU;
  *		   usually under some other lock to prevent node disappearing
  *		daddr: unchangeable
- *		ip_id_count: atomic value (no lock needed)
  */
 
 static struct kmem_cache *peer_cachep __read_mostly;
@@ -504,10 +490,6 @@ relookup:
 		p->daddr = *daddr;
 		atomic_set(&p->refcnt, 1);
 		atomic_set(&p->rid, 0);
-		atomic_set(&p->ip_id_count,
-				(daddr->family == AF_INET) ?
-					secure_ip_id(daddr->addr.a4) :
-					secure_ipv6_id(daddr->addr.a6));
 		p->metrics[RTAX_LOCK-1] = INETPEER_METRICS_NEW;
 		p->rate_tokens = 0;
 		/* 60*HZ is arbitrary, but chosen enough high so that the first
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index df18461..5352214 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -148,7 +148,7 @@ int ip_build_and_send_pkt(struct sk_buff *skb, struct sock *sk,
 	iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    = saddr;
 	iph->protocol = sk->sk_protocol;
-	ip_select_ident(skb, &rt->dst, sk);
+	ip_select_ident(skb, sk);
 
 	if (opt && opt->opt.optlen) {
 		iph->ihl += opt->opt.optlen>>2;
@@ -386,8 +386,7 @@ packet_routed:
 		ip_options_build(skb, &inet_opt->opt, inet->inet_daddr, rt, 0);
 	}
 
-	ip_select_ident_more(skb, &rt->dst, sk,
-			     (skb_shinfo(skb)->gso_segs ?: 1) - 1);
+	ip_select_ident_segs(skb, sk, skb_shinfo(skb)->gso_segs ?: 1);
 
 	skb->priority = sk->sk_priority;
 	skb->mark = sk->sk_mark;
@@ -1339,7 +1338,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	iph->ttl = ttl;
 	iph->protocol = sk->sk_protocol;
 	ip_copy_addrs(iph, fl4);
-	ip_select_ident(skb, &rt->dst, sk);
+	ip_select_ident(skb, sk);
 
 	if (opt) {
 		iph->ihl += opt->optlen>>2;
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 42ffbc8..67bd005 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -74,7 +74,7 @@ int iptunnel_xmit(struct rtable *rt, struct sk_buff *skb,
 	iph->daddr	=	dst;
 	iph->saddr	=	src;
 	iph->ttl	=	ttl;
-	__ip_select_ident(iph, &rt->dst, (skb_shinfo(skb)->gso_segs ?: 1) - 1);
+	__ip_select_ident(iph, skb_shinfo(skb)->gso_segs ?: 1);
 
 	err = ip_local_out(skb);
 	if (unlikely(net_xmit_eval(err)))
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 6fbf339..648ba5e 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1661,7 +1661,7 @@ static void ip_encap(struct sk_buff *skb, __be32 saddr, __be32 daddr)
 	iph->protocol	=	IPPROTO_IPIP;
 	iph->ihl	=	5;
 	iph->tot_len	=	htons(skb->len);
-	ip_select_ident(skb, skb_dst(skb), NULL);
+	ip_select_ident(skb, NULL);
 	ip_send_check(iph);
 
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 23c3e5b..3022aed 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -389,7 +389,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 		iph->check   = 0;
 		iph->tot_len = htons(length);
 		if (!iph->id)
-			ip_select_ident(skb, &rt->dst, NULL);
+			ip_select_ident(skb, NULL);
 
 		iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
 	}
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 566bfa5..4d52f74 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -89,6 +89,7 @@
 #include <linux/rcupdate.h>
 #include <linux/times.h>
 #include <linux/slab.h>
+#include <linux/jhash.h>
 #include <net/dst.h>
 #include <net/net_namespace.h>
 #include <net/protocol.h>
@@ -465,39 +466,19 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 	return neigh_create(&arp_tbl, pkey, dev);
 }
 
-/*
- * Peer allocation may fail only in serious out-of-memory conditions.  However
- * we still can generate some output.
- * Random ID selection looks a bit dangerous because we have no chances to
- * select ID being unique in a reasonable period of time.
- * But broken packet identifier may be better than no packet at all.
- */
-static void ip_select_fb_ident(struct iphdr *iph)
-{
-	static DEFINE_SPINLOCK(ip_fb_id_lock);
-	static u32 ip_fallback_id;
-	u32 salt;
+atomic_t *ip_idents __read_mostly;
+EXPORT_SYMBOL(ip_idents);
 
-	spin_lock_bh(&ip_fb_id_lock);
-	salt = secure_ip_id((__force __be32)ip_fallback_id ^ iph->daddr);
-	iph->id = htons(salt & 0xFFFF);
-	ip_fallback_id = salt;
-	spin_unlock_bh(&ip_fb_id_lock);
-}
-
-void __ip_select_ident(struct iphdr *iph, struct dst_entry *dst, int more)
+void __ip_select_ident(struct iphdr *iph, int segs)
 {
-	struct net *net = dev_net(dst->dev);
-	struct inet_peer *peer;
+	static u32 ip_idents_hashrnd __read_mostly;
+	u32 hash, id;
 
-	peer = inet_getpeer_v4(net->ipv4.peers, iph->daddr, 1);
-	if (peer) {
-		iph->id = htons(inet_getid(peer, more));
-		inet_putpeer(peer);
-		return;
-	}
+	net_get_random_once(&ip_idents_hashrnd, sizeof(ip_idents_hashrnd));
 
-	ip_select_fb_ident(iph);
+	hash = jhash_1word((__force u32)iph->daddr, ip_idents_hashrnd);
+	id = ip_idents_reserve(hash, segs);
+	iph->id = htons(id);
 }
 EXPORT_SYMBOL(__ip_select_ident);
 
@@ -2716,6 +2697,12 @@ int __init ip_rt_init(void)
 {
 	int rc = 0;
 
+	ip_idents = kmalloc(IP_IDENTS_SZ * sizeof(*ip_idents), GFP_KERNEL);
+	if (!ip_idents)
+		panic("IP: failed to allocate ip_idents\n");
+
+	prandom_bytes(ip_idents, IP_IDENTS_SZ * sizeof(*ip_idents));
+
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	ip_rt_acct = __alloc_percpu(256 * sizeof(struct ip_rt_acct), __alignof__(struct ip_rt_acct));
 	if (!ip_rt_acct)
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index 31b1815..1f564a1 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -117,12 +117,12 @@ static int xfrm4_mode_tunnel_output(struct xfrm_state *x, struct sk_buff *skb)
 
 	top_iph->frag_off = (flags & XFRM_STATE_NOPMTUDISC) ?
 		0 : (XFRM_MODE_SKB_CB(skb)->frag_off & htons(IP_DF));
-	ip_select_ident(skb, dst->child, NULL);
 
 	top_iph->ttl = ip4_dst_hoplimit(dst->child);
 
 	top_iph->saddr = x->props.saddr.a4;
 	top_iph->daddr = x->id.daddr.a4;
+	ip_select_ident(skb, NULL);
 
 	return 0;
 }
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e86c22e..726f113 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -516,6 +516,18 @@ static void ip6_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 	skb_copy_secmark(to, from);
 }
 
+static void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
+{
+	static u32 ip6_idents_hashrnd __read_mostly;
+	u32 hash, id;
+
+	net_get_random_once(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
+
+	hash = __ipv6_addr_jhash(&rt->rt6i_dst.addr, ip6_idents_hashrnd);
+	id = ip_idents_reserve(hash, 1);
+	fhdr->identification = htonl(id);
+}
+
 int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 {
 	struct sk_buff *frag;
diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
index b31a012..798eb0f 100644
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -7,29 +7,6 @@
 #include <net/ip6_fib.h>
 #include <net/addrconf.h>
 
-void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
-{
-	static atomic_t ipv6_fragmentation_id;
-	int ident;
-
-#if IS_ENABLED(CONFIG_IPV6)
-	if (rt && !(rt->dst.flags & DST_NOPEER)) {
-		struct inet_peer *peer;
-		struct net *net;
-
-		net = dev_net(rt->dst.dev);
-		peer = inet_getpeer_v6(net->ipv6.peers, &rt->rt6i_dst.addr, 1);
-		if (peer) {
-			fhdr->identification = htonl(inet_getid(peer, 0));
-			inet_putpeer(peer);
-			return;
-		}
-	}
-#endif
-	ident = atomic_inc_return(&ipv6_fragmentation_id);
-	fhdr->identification = htonl(ident);
-}
-EXPORT_SYMBOL(ipv6_select_ident);
 
 int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr)
 {
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index c47444e..7f0e1cf 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -883,7 +883,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	iph->daddr		=	cp->daddr.ip;
 	iph->saddr		=	saddr;
 	iph->ttl		=	old_iph->ttl;
-	ip_select_ident(skb, &rt->dst, NULL);
+	ip_select_ident(skb, NULL);
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;
-- 
1.9.1

