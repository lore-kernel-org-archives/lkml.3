Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaHTMDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:03:12 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58917 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Willy Tarreau <w@1wt.eu>, Hannes Frederic Sowa <hannes@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 034/104] ip: make IP identifiers less predictable
Date: Wed, 20 Aug 2014 13:42:57 +0200
Message-Id: <2b03bce84364b12644b35a88f6d9e88bfcb7aacc.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 04ca6973f7c1a0d8537f2d9906a0cf8e69886d75 ]

In "Counting Packets Sent Between Arbitrary Internet Hosts", Jeffrey and
Jedidiah describe ways exploiting linux IP identifier generation to
infer whether two machines are exchanging packets.

With commit 73f156a6e8c1 ("inetpeer: get rid of ip_id_count"), we
changed IP id generation, but this does not really prevent this
side-channel technique.

This patch adds a random amount of perturbation so that IP identifiers
for a given destination [1] are no longer monotonically increasing after
an idle period.

Note that prandom_u32_max(1) returns 0, so if generator is used at most
once per jiffy, this patch inserts no hole in the ID suite and do not
increase collision probability.

This is jiffies based, so in the worst case (HZ=1000), the id can
rollover after ~65 seconds of idle time, which should be fine.

We also change the hash used in __ip_select_ident() to not only hash
on daddr, but also saddr and protocol, so that ICMP probes can not be
used to infer information for other protocols.

For IPv6, adds saddr into the hash as well, but not nexthdr.

If I ping the patched target, we can see ID are now hard to predict.

21:57:11.008086 IP (...)
    A > target: ICMP echo request, seq 1, length 64
21:57:11.010752 IP (... id 2081 ...)
    target > A: ICMP echo reply, seq 1, length 64

21:57:12.013133 IP (...)
    A > target: ICMP echo request, seq 2, length 64
21:57:12.015737 IP (... id 3039 ...)
    target > A: ICMP echo reply, seq 2, length 64

21:57:13.016580 IP (...)
    A > target: ICMP echo request, seq 3, length 64
21:57:13.019251 IP (... id 3437 ...)
    target > A: ICMP echo reply, seq 3, length 64

[1] TCP sessions uses a per flow ID generator not changed by this patch.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jeffrey Knockel <jeffk@cs.unm.edu>
Reported-by: Jedidiah R. Crandall <crandall@cs.unm.edu>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Hannes Frederic Sowa <hannes@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/net/ip.h      | 11 +----------
 net/ipv4/route.c      | 36 +++++++++++++++++++++++++++++++++---
 net/ipv6/ip6_output.c |  2 ++
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index fef09567d4c0..53573e06cf87 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -262,16 +262,7 @@ int ip_dont_fragment(struct sock *sk, struct dst_entry *dst)
 		 !(dst_metric_locked(dst, RTAX_MTU)));
 }
 
-#define IP_IDENTS_SZ 2048u
-extern atomic_t *ip_idents;
-
-static inline u32 ip_idents_reserve(u32 hash, int segs)
-{
-	atomic_t *id_ptr = ip_idents + hash % IP_IDENTS_SZ;
-
-	return atomic_add_return(segs, id_ptr) - segs;
-}
-
+u32 ip_idents_reserve(u32 hash, int segs);
 void __ip_select_ident(struct iphdr *iph, int segs);
 
 static inline void ip_select_ident_segs(struct sk_buff *skb, struct sock *sk, int segs)
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index bbd08354e593..9089c4f2965c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -466,8 +466,35 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 	return neigh_create(&arp_tbl, pkey, dev);
 }
 
-atomic_t *ip_idents __read_mostly;
-EXPORT_SYMBOL(ip_idents);
+#define IP_IDENTS_SZ 2048u
+struct ip_ident_bucket {
+	atomic_t	id;
+	u32		stamp32;
+};
+
+static struct ip_ident_bucket *ip_idents __read_mostly;
+
+/* In order to protect privacy, we add a perturbation to identifiers
+ * if one generator is seldom used. This makes hard for an attacker
+ * to infer how many packets were sent between two points in time.
+ */
+u32 ip_idents_reserve(u32 hash, int segs)
+{
+	struct ip_ident_bucket *bucket = ip_idents + hash % IP_IDENTS_SZ;
+	u32 old = ACCESS_ONCE(bucket->stamp32);
+	u32 now = (u32)jiffies;
+	u32 delta = 0;
+
+	if (old != now && cmpxchg(&bucket->stamp32, old, now) == old) {
+		u64 x = prandom_u32();
+
+		x *= (now - old);
+		delta = (u32)(x >> 32);
+	}
+
+	return atomic_add_return(segs + delta, &bucket->id) - segs;
+}
+EXPORT_SYMBOL(ip_idents_reserve);
 
 void __ip_select_ident(struct iphdr *iph, int segs)
 {
@@ -480,7 +507,10 @@ void __ip_select_ident(struct iphdr *iph, int segs)
 		get_random_bytes(&ip_idents_hashrnd, sizeof(ip_idents_hashrnd));
 	}
 
-	hash = jhash_1word((__force u32)iph->daddr, ip_idents_hashrnd);
+	hash = jhash_3words((__force u32)iph->daddr,
+			    (__force u32)iph->saddr,
+			    iph->protocol,
+			    ip_idents_hashrnd);
 	id = ip_idents_reserve(hash, segs);
 	iph->id = htons(id);
 }
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 74129e8acba0..e5e59c36cfc5 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -527,6 +527,8 @@ static void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
 		get_random_bytes(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
 	}
 	hash = __ipv6_addr_jhash(&rt->rt6i_dst.addr, ip6_idents_hashrnd);
+	hash = __ipv6_addr_jhash(&rt->rt6i_src.addr, hash);
+
 	id = ip_idents_reserve(hash, 1);
 	fhdr->identification = htonl(id);
 }
-- 
2.0.4

