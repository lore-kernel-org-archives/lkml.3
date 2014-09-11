Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbaIKNAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:00:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51536 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755388AbaIKMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>, "Willy Tarreau" <w@1wt.eu>,
        "Hannes Frederic Sowa" <hannes@redhat.com>,
        "Jeffrey Knockel" <jeffk@cs.unm.edu>,
        "Jedidiah R. Crandall" <crandall@cs.unm.edu>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.72431652@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 100/131] ip: make IP identifiers less predictable
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/ip.h      | 11 +----------
 net/ipv4/route.c      | 36 +++++++++++++++++++++++++++++++++---
 net/ipv6/ip6_output.c |  2 ++
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index f4ccdd6..1ee535b 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -264,16 +264,7 @@ int ip_dont_fragment(struct sock *sk, struct dst_entry *dst)
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
index 278784e..d361dc0 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1344,8 +1344,35 @@ void rt_bind_peer(struct rtable *rt, __be32 daddr, int create)
 		rt->rt_peer_genid = rt_peer_genid();
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
+		u64 x = random32();
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
@@ -1358,7 +1385,10 @@ void __ip_select_ident(struct iphdr *iph, int segs)
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
index f79defc..46fc6a3 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -609,6 +609,8 @@ void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
 		get_random_bytes(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
 	}
 	hash = __ipv6_addr_jhash(&rt->rt6i_dst.addr, ip6_idents_hashrnd);
+	hash = __ipv6_addr_jhash(&rt->rt6i_src.addr, hash);
+
 	id = ip_idents_reserve(hash, 1);
 	fhdr->identification = htonl(id);
 }

