Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaIKNA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:00:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51518 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755380AbaIKMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.939697826@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 099/131] inetpeer: get rid of ip_id_count
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ppp/pptp.c          |  2 +-
 include/net/inetpeer.h          | 14 ++---------
 include/net/ip.h                | 40 ++++++++++++++++-------------
 include/net/ipip.h              |  2 +-
 include/net/ipv6.h              |  9 +++++--
 include/net/secure_seq.h        |  2 --
 net/core/secure_seq.c           | 23 -----------------
 net/ipv4/igmp.c                 |  4 +--
 net/ipv4/inetpeer.c             | 18 -------------
 net/ipv4/ip_output.c            |  7 +++---
 net/ipv4/ipmr.c                 |  2 +-
 net/ipv4/raw.c                  |  2 +-
 net/ipv4/route.c                | 56 ++++++++++++++---------------------------
 net/ipv4/xfrm4_mode_tunnel.c    |  2 +-
 net/ipv6/ip6_output.c           | 23 +++++++----------
 net/netfilter/ipvs/ip_vs_xmit.c |  2 +-
 16 files changed, 71 insertions(+), 137 deletions(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 2b349d3..c974581 100644
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
index ba0ddb0..6172a44 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -47,13 +47,12 @@ struct inet_peer {
 	};
 	/*
 	 * Once inet_peer is queued for deletion (refcnt == -1), following fields
-	 * are not available: rid, ip_id_count, tcp_ts, tcp_ts_stamp
+	 * are not available: rid, tcp_ts, tcp_ts_stamp
 	 * We can share memory with rcu_head to help keep inet_peer small.
 	 */
 	union {
 		struct {
 			atomic_t			rid;		/* Frag reception counter */
-			atomic_t			ip_id_count;	/* IP ID for the next packet */
 			__u32				tcp_ts;
 			__u32				tcp_ts_stamp;
 		};
@@ -103,7 +102,7 @@ extern bool inet_peer_xrlim_allow(struct inet_peer *peer, int timeout);
 extern void inetpeer_invalidate_tree(int family);
 
 /*
- * temporary check to make sure we dont access rid, ip_id_count, tcp_ts,
+ * temporary check to make sure we dont access rid, tcp_ts,
  * tcp_ts_stamp if no refcount is taken on inet_peer
  */
 static inline void inet_peer_refcheck(const struct inet_peer *p)
@@ -111,13 +110,4 @@ static inline void inet_peer_refcheck(const struct inet_peer *p)
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
index b935e6c..f4ccdd6 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -264,9 +264,19 @@ int ip_dont_fragment(struct sock *sk, struct dst_entry *dst)
 		 !(dst_metric_locked(dst, RTAX_MTU)));
 }
 
-extern void __ip_select_ident(struct iphdr *iph, struct dst_entry *dst, int more);
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
 
@@ -276,24 +286,20 @@ static inline void ip_select_ident(struct sk_buff *skb, struct dst_entry *dst, s
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
diff --git a/include/net/ipip.h b/include/net/ipip.h
index 4dccfe3..e8ee3bb 100644
--- a/include/net/ipip.h
+++ b/include/net/ipip.h
@@ -50,7 +50,7 @@ struct ip_tunnel_prl_entry {
 	int pkt_len = skb->len - skb_transport_offset(skb);		\
 									\
 	skb->ip_summed = CHECKSUM_NONE;					\
-	ip_select_ident(skb, &rt->dst, NULL);				\
+	ip_select_ident(skb, NULL);				\
 									\
 	err = ip_local_out(skb);					\
 	if (likely(net_xmit_eval(err) == 0)) {				\
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 0580673..00a2eb6 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -388,14 +388,19 @@ void ip6_frag_init(struct inet_frag_queue *q, void *a);
 int ip6_frag_match(struct inet_frag_queue *q, void *a);
 
 /* more secured version of ipv6_addr_hash() */
-static inline u32 ipv6_addr_jhash(const struct in6_addr *a)
+static inline u32 __ipv6_addr_jhash(const struct in6_addr *a, const u32 initval)
 {
 	u32 v = (__force u32)a->s6_addr32[0] ^ (__force u32)a->s6_addr32[1];
 
 	return jhash_3words(v,
 			    (__force u32)a->s6_addr32[2],
 			    (__force u32)a->s6_addr32[3],
-			    ipv6_hash_secret);
+			    initval);
+}
+
+static inline u32 ipv6_addr_jhash(const struct in6_addr *a)
+{
+	return __ipv6_addr_jhash(a, ipv6_hash_secret);
 }
 
 static inline int ipv6_addr_any(const struct in6_addr *a)
diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
index c2e542b..b1c3d1c 100644
--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@ -3,8 +3,6 @@
 
 #include <linux/types.h>
 
-extern __u32 secure_ip_id(__be32 daddr);
-extern __u32 secure_ipv6_id(const __be32 daddr[4]);
 extern u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
 extern u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 				      __be16 dport);
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 925991a..fd53919 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -79,29 +79,6 @@ u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 #endif
 
 #ifdef CONFIG_INET
-__u32 secure_ip_id(__be32 daddr)
-{
-	u32 hash[MD5_DIGEST_WORDS];
-
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
-	memcpy(hash, daddr, 16);
-	md5_transform(hash, net_secret);
-
-	return hash[0];
-}
 
 __u32 secure_tcp_sequence_number(__be32 saddr, __be32 daddr,
 				 __be16 sport, __be16 dport)
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 7f7e670..7fe66d9 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -342,7 +342,7 @@ static struct sk_buff *igmpv3_newpack(struct net_device *dev, int size)
 	pip->saddr    = fl4.saddr;
 	pip->protocol = IPPROTO_IGMP;
 	pip->tot_len  = 0;	/* filled in later */
-	ip_select_ident(skb, &rt->dst, NULL);
+	ip_select_ident(skb, NULL);
 	((u8*)&pip[1])[0] = IPOPT_RA;
 	((u8*)&pip[1])[1] = 4;
 	((u8*)&pip[1])[2] = 0;
@@ -683,7 +683,7 @@ static int igmp_send_report(struct in_device *in_dev, struct ip_mc_list *pmc,
 	iph->daddr    = dst;
 	iph->saddr    = fl4.saddr;
 	iph->protocol = IPPROTO_IGMP;
-	ip_select_ident(skb, &rt->dst, NULL);
+	ip_select_ident(skb, NULL);
 	((u8*)&iph[1])[0] = IPOPT_RA;
 	((u8*)&iph[1])[1] = 4;
 	((u8*)&iph[1])[2] = 0;
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index 58c4e696..9d74cc7 100644
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
@@ -488,10 +474,6 @@ relookup:
 		p->daddr = *daddr;
 		atomic_set(&p->refcnt, 1);
 		atomic_set(&p->rid, 0);
-		atomic_set(&p->ip_id_count,
-				(daddr->family == AF_INET) ?
-					secure_ip_id(daddr->addr.a4) :
-					secure_ipv6_id(daddr->addr.a6));
 		p->tcp_ts_stamp = 0;
 		p->metrics[RTAX_LOCK-1] = INETPEER_METRICS_NEW;
 		p->rate_tokens = 0;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 16191f0..223085f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -162,7 +162,7 @@ int ip_build_and_send_pkt(struct sk_buff *skb, struct sock *sk,
 	iph->daddr    = (opt && opt->opt.srr ? opt->opt.faddr : daddr);
 	iph->saddr    = saddr;
 	iph->protocol = sk->sk_protocol;
-	ip_select_ident(skb, &rt->dst, sk);
+	ip_select_ident(skb, sk);
 
 	if (opt && opt->opt.optlen) {
 		iph->ihl += opt->opt.optlen>>2;
@@ -390,8 +390,7 @@ packet_routed:
 		ip_options_build(skb, &inet_opt->opt, inet->inet_daddr, rt, 0);
 	}
 
-	ip_select_ident_more(skb, &rt->dst, sk,
-			     (skb_shinfo(skb)->gso_segs ?: 1) - 1);
+	ip_select_ident_segs(skb, sk, skb_shinfo(skb)->gso_segs ?: 1);
 
 	skb->priority = sk->sk_priority;
 	skb->mark = sk->sk_mark;
@@ -1334,7 +1333,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	iph->ihl = 5;
 	iph->tos = inet->tos;
 	iph->frag_off = df;
-	ip_select_ident(skb, &rt->dst, sk);
+	ip_select_ident(skb, sk);
 	iph->ttl = ttl;
 	iph->protocol = sk->sk_protocol;
 	iph->saddr = fl4->saddr;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 140d377..7993d16 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1579,7 +1579,7 @@ static void ip_encap(struct sk_buff *skb, __be32 saddr, __be32 daddr)
 	iph->protocol	=	IPPROTO_IPIP;
 	iph->ihl	=	5;
 	iph->tot_len	=	htons(skb->len);
-	ip_select_ident(skb, skb_dst(skb), NULL);
+	ip_select_ident(skb, NULL);
 	ip_send_check(iph);
 
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index cfded93..75fea1f 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -380,7 +380,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 		iph->check   = 0;
 		iph->tot_len = htons(length);
 		if (!iph->id)
-			ip_select_ident(skb, &rt->dst, NULL);
+			ip_select_ident(skb, NULL);
 
 		iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
 	}
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6526110..278784e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1344,46 +1344,23 @@ void rt_bind_peer(struct rtable *rt, __be32 daddr, int create)
 		rt->rt_peer_genid = rt_peer_genid();
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
-	struct rtable *rt = (struct rtable *) dst;
+	static u32 ip_idents_hashrnd __read_mostly;
+	static bool hashrnd_initialized = false;
+	u32 hash, id;
 
-	if (rt && !(rt->dst.flags & DST_NOPEER)) {
-		if (rt->peer == NULL)
-			rt_bind_peer(rt, rt->rt_dst, 1);
-
-		/* If peer is attached to destination, it is never detached,
-		   so that we need not to grab a lock to dereference it.
-		 */
-		if (rt->peer) {
-			iph->id = htons(inet_getid(rt->peer, more));
-			return;
-		}
-	} else if (!rt)
-		printk(KERN_DEBUG "rt_bind_peer(0) @%p\n",
-		       __builtin_return_address(0));
+	if (unlikely(!hashrnd_initialized)) {
+		hashrnd_initialized = true;
+		get_random_bytes(&ip_idents_hashrnd, sizeof(ip_idents_hashrnd));
+	}
 
-	ip_select_fb_ident(iph);
+	hash = jhash_1word((__force u32)iph->daddr, ip_idents_hashrnd);
+	id = ip_idents_reserve(hash, segs);
+	iph->id = htons(id);
 }
 EXPORT_SYMBOL(__ip_select_ident);
 
@@ -3023,7 +3000,6 @@ static int rt_fill_info(struct net *net,
 	error = rt->dst.error;
 	if (peer) {
 		inet_peer_refcheck(rt->peer);
-		id = atomic_read(&peer->ip_id_count) & 0xffff;
 		if (peer->tcp_ts_stamp) {
 			ts = peer->tcp_ts;
 			tsage = get_seconds() - peer->tcp_ts_stamp;
@@ -3455,6 +3431,12 @@ int __init ip_rt_init(void)
 {
 	int rc = 0;
 
+	ip_idents = kmalloc(IP_IDENTS_SZ * sizeof(*ip_idents), GFP_KERNEL);
+	if (!ip_idents)
+		panic("IP: failed to allocate ip_idents\n");
+
+	get_random_bytes(ip_idents, IP_IDENTS_SZ * sizeof(*ip_idents));
+
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	ip_rt_acct = __alloc_percpu(256 * sizeof(struct ip_rt_acct), __alignof__(struct ip_rt_acct));
 	if (!ip_rt_acct)
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index 938553e..5531eb2 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -54,12 +54,12 @@ static int xfrm4_mode_tunnel_output(struct xfrm_state *x, struct sk_buff *skb)
 
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
index 064b5c9..f79defc 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -600,22 +600,17 @@ int ip6_find_1stfragopt(struct sk_buff *skb, u8 **nexthdr)
 
 void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
 {
-	static atomic_t ipv6_fragmentation_id;
-	int ident;
+	static u32 ip6_idents_hashrnd __read_mostly;
+	static bool hashrnd_initialized = false;
+	u32 hash, id;
 
-	if (rt && !(rt->dst.flags & DST_NOPEER)) {
-		struct inet_peer *peer;
-
-		if (!rt->rt6i_peer)
-			rt6_bind_peer(rt, 1);
-		peer = rt->rt6i_peer;
-		if (peer) {
-			fhdr->identification = htonl(inet_getid(peer, 0));
-			return;
-		}
+	if (unlikely(!hashrnd_initialized)) {
+		hashrnd_initialized = true;
+		get_random_bytes(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
 	}
-	ident = atomic_inc_return(&ipv6_fragmentation_id);
-	fhdr->identification = htonl(ident);
+	hash = __ipv6_addr_jhash(&rt->rt6i_dst.addr, ip6_idents_hashrnd);
+	id = ip_idents_reserve(hash, 1);
+	fhdr->identification = htonl(id);
 }
 
 int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 38c0813..cc8f8b4 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -853,7 +853,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	iph->daddr		=	cp->daddr.ip;
 	iph->saddr		=	saddr;
 	iph->ttl		=	old_iph->ttl;
-	ip_select_ident(skb, &rt->dst, NULL);
+	ip_select_ident(skb, NULL);
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->local_df = 1;

