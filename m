Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200Ab3B1OvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:51:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42558 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab3B1OvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 131/139] ipv6: use a stronger hash for tcp
Date: Thu, 28 Feb 2013 14:44:41 +0000
Message-Id: <1362062689-2567-132-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 08dcdbf6a7b9d14c2302c5bd0c5390ddf122f664 upstream.

It looks like its possible to open thousands of TCP IPv6
sessions on a server, all landing in a single slot of TCP hash
table. Incoming packets have to lookup sockets in a very
long list.

We should hash all bits from foreign IPv6 addresses, using
a salt and hash mix, not a simple XOR.

inet6_ehashfn() can also separately use the ports, instead
of xoring them.

Reported-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/inet6_hashtables.h |  8 ++++----
 include/net/inet_sock.h        |  1 +
 include/net/ipv6.h             | 12 ++++++++++++
 net/ipv4/af_inet.c             |  9 +++++++--
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index 00cbb43..2da45ce 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -28,16 +28,16 @@
 
 struct inet_hashinfo;
 
-/* I have no idea if this is a good hash for v6 or not. -DaveM */
 static inline unsigned int inet6_ehashfn(struct net *net,
 				const struct in6_addr *laddr, const u16 lport,
 				const struct in6_addr *faddr, const __be16 fport)
 {
-	u32 ports = (lport ^ (__force u16)fport);
+	u32 ports = (((u32)lport) << 16) | (__force u32)fport;
 
 	return jhash_3words((__force u32)laddr->s6_addr32[3],
-			    (__force u32)faddr->s6_addr32[3],
-			    ports, inet_ehash_secret + net_hash_mix(net));
+			    ipv6_addr_jhash(faddr),
+			    ports,
+			    inet_ehash_secret + net_hash_mix(net));
 }
 
 static inline int inet6_sk_ehashfn(const struct sock *sk)
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index ae17e13..8cd2e1d 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -202,6 +202,7 @@ static inline void inet_sk_copy_descendant(struct sock *sk_to,
 extern int inet_sk_rebuild_header(struct sock *sk);
 
 extern u32 inet_ehash_secret;
+extern u32 ipv6_hash_secret;
 extern void build_ehash_secret(void);
 
 static inline unsigned int inet_ehashfn(struct net *net,
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index aecf884..c11fa5d 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -15,6 +15,7 @@
 
 #include <linux/ipv6.h>
 #include <linux/hardirq.h>
+#include <linux/jhash.h>
 #include <net/if_inet6.h>
 #include <net/ndisc.h>
 #include <net/flow.h>
@@ -395,6 +396,17 @@ static inline bool ipv6_addr_any(const struct in6_addr *a)
 		a->s6_addr32[2] | a->s6_addr32[3]) == 0;
 }
 
+/* more secured version of ipv6_addr_hash() */
+static inline u32 ipv6_addr_jhash(const struct in6_addr *a)
+{
+	u32 v = (__force u32)a->s6_addr32[0] ^ (__force u32)a->s6_addr32[1];
+
+	return jhash_3words(v,
+			    (__force u32)a->s6_addr32[2],
+			    (__force u32)a->s6_addr32[3],
+			    ipv6_hash_secret);
+}
+
 static inline bool ipv6_addr_loopback(const struct in6_addr *a)
 {
 	return (a->s6_addr32[0] | a->s6_addr32[1] |
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index c8f7aee..57b3024 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -227,8 +227,12 @@ EXPORT_SYMBOL(inet_listen);
 u32 inet_ehash_secret __read_mostly;
 EXPORT_SYMBOL(inet_ehash_secret);
 
+u32 ipv6_hash_secret __read_mostly;
+EXPORT_SYMBOL(ipv6_hash_secret);
+
 /*
- * inet_ehash_secret must be set exactly once
+ * inet_ehash_secret must be set exactly once, and to a non nul value
+ * ipv6_hash_secret must be set exactly once.
  */
 void build_ehash_secret(void)
 {
@@ -238,7 +242,8 @@ void build_ehash_secret(void)
 		get_random_bytes(&rnd, sizeof(rnd));
 	} while (rnd == 0);
 
-	cmpxchg(&inet_ehash_secret, 0, rnd);
+	if (cmpxchg(&inet_ehash_secret, 0, rnd) == 0)
+		get_random_bytes(&ipv6_hash_secret, sizeof(ipv6_hash_secret));
 }
 EXPORT_SYMBOL(build_ehash_secret);
 
-- 
1.8.1.2

