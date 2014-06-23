Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaFWIr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:47:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55557 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 097/111] net: fix inet_getid() and ipv6_select_ident() bugs
Date: Mon, 23 Jun 2014 10:32:12 +0200
Message-Id: <12b4aba2d6f870dd8f505ae5dd5fc887d6484a93.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
index 827f795209cf..b31a01263185 100644
--- a/net/ipv6/output_core.c
+++ b/net/ipv6/output_core.c
@@ -10,7 +10,7 @@
 void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
 {
 	static atomic_t ipv6_fragmentation_id;
-	int old, new;
+	int ident;
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (rt && !(rt->dst.flags & DST_NOPEER)) {
@@ -26,13 +26,8 @@ void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
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
2.0.0

