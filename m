Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbaFXPyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:54:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbaFXPyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:54:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 18/68] net: fix inet_getid() and ipv6_select_ident() bugs
Date: Tue, 24 Jun 2014 11:50:37 -0400
Message-Id: <20140624154724.734681360@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inetpeer.h |    9 +--------
 net/ipv6/output_core.c |   11 +++--------
 2 files changed, 4 insertions(+), 16 deletions(-)

--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -177,16 +177,9 @@ static inline void inet_peer_refcheck(co
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
@@ -26,13 +26,8 @@ void ipv6_select_ident(struct frag_hdr *
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
 


