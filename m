Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030344AbaGCJYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:24:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52304 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030319AbaGCJYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 140/198] net: fix inet_getid() and ipv6_select_ident() bugs
Date: Thu,  3 Jul 2014 10:19:43 +0100
Message-Id: <1404379241-8590-141-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 39c36094d78c39e038c1e499b2364e13bce36f54 upstream.

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
[ luis: backported to 3.11: used davem's backport for 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/inetpeer.h |  9 +--------
 net/ipv6/output_core.c | 11 +++--------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index 53f464d7cddc..6ca347a0717e 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -178,16 +178,9 @@ static inline void inet_peer_refcheck(const struct inet_peer *p)
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
diff --git a/net/ipv6/output_core.c b/net/ipv6/output_core.c
index ab92a3673fbb..39f6ad1629ff 100644
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -9,7 +9,7 @@
 void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
 {
 	static atomic_t ipv6_fragmentation_id;
-	int old, new;
+	int ident;
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (rt && !(rt->dst.flags & DST_NOPEER)) {
@@ -25,13 +25,8 @@ void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
 		}
 	}
 #endif
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
 EXPORT_SYMBOL(ipv6_select_ident);
 
-- 
1.9.1

