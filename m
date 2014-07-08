Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685AbaGHTqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:46:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54056 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755660AbaGHTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.110773631@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 112/125] net: fix inet_getid() and ipv6_select_ident()
 bugs
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 39c36094d78c39e038c1e499b2364e13bce36f54 ]

I noticed we were sending wrong IPv4 ID in TCP flows when MTU discovery
is disabled.
Note how GSO/TSO packets do not have monotonically incrementing ID.

06:37:41.575531 IP (id 14227, proto: TCP (6), length: 4396)
06:37:41.575534 IP (id 14272, proto: TCP (6), length: 65212)
06:37:41.575544 IP (id 14312, proto: TCP (6), length: 57972)
06:37:41.575678 IP (id 14317, proto: TCP (6), length: 7292)
06:37:41.575683 IP (id 14361, proto: TCP (6), length: 63764)

It appears I introduced this bug in linux-3.1.

inet_getid() must return the old value of peer->ip_id_count,
not the new one.

Lets revert this part, and remove the prevention of
a null identification field in IPv6 Fragment Extension Header,
which is dubious and not even done properly.

Fixes: 87c48fa3b463 ("ipv6: make fragment identifications less predictable")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/inetpeer.h |  9 +--------
 net/ipv6/ip6_output.c  | 11 +++--------
 2 files changed, 4 insertions(+), 16 deletions(-)

--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -115,16 +115,9 @@ static inline void inet_peer_refcheck(co
 /* can be called with or without local BH being disabled */
 static inline int inet_getid(struct inet_peer *p, int more)
 {
-	int old, new;
 	more++;
 	inet_peer_refcheck(p);
-	do {
-		old = atomic_read(&p->ip_id_count);
-		new = old + more;
-		if (!new)
-			new = 1;
-	} while (atomic_cmpxchg(&p->ip_id_count, old, new) != old);
-	return new;
+	return atomic_add_return(more, &p->ip_id_count) - more;
 }
 
 #endif /* _NET_INETPEER_H */
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -612,7 +612,7 @@ int ip6_find_1stfragopt(struct sk_buff *
 void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
 {
 	static atomic_t ipv6_fragmentation_id;
-	int old, new;
+	int ident;
 
 	if (rt && !(rt->dst.flags & DST_NOPEER)) {
 		struct inet_peer *peer;
@@ -625,13 +625,8 @@ void ipv6_select_ident(struct frag_hdr *
 			return;
 		}
 	}
-	do {
-		old = atomic_read(&ipv6_fragmentation_id);
-		new = old + 1;
-		if (!new)
-			new = 1;
-	} while (atomic_cmpxchg(&ipv6_fragmentation_id, old, new) != old);
-	fhdr->identification = htonl(new);
+	ident = atomic_inc_return(&ipv6_fragmentation_id);
+	fhdr->identification = htonl(ident);
 }
 
 int ip6_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))

