Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab3B0AFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:05:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab3BZX7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:59:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>, Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 46/53] ipv6: use a stronger hash for tcp
Date: Tue, 26 Feb 2013 15:58:15 -0800
Message-Id: <20130226235624.650571285@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 08dcdbf6a7b9d14c2302c5bd0c5390ddf122f664 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet6_hashtables.h |    8 ++++----
 include/net/inet_sock.h        |    1 +
 include/net/ipv6.h             |   12 ++++++++++++
 net/ipv4/af_inet.c             |    9 +++++++--
 4 files changed, 24 insertions(+), 6 deletions(-)

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
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -199,6 +199,7 @@ static inline void inet_sk_copy_descenda
 extern int inet_sk_rebuild_header(struct sock *sk);
 
 extern u32 inet_ehash_secret;
+extern u32 ipv6_hash_secret;
 extern void build_ehash_secret(void);
 
 static inline unsigned int inet_ehashfn(struct net *net,
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -15,6 +15,7 @@
 
 #include <linux/ipv6.h>
 #include <linux/hardirq.h>
+#include <linux/jhash.h>
 #include <net/if_inet6.h>
 #include <net/ndisc.h>
 #include <net/flow.h>
@@ -386,6 +387,17 @@ struct ip6_create_arg {
 void ip6_frag_init(struct inet_frag_queue *q, void *a);
 int ip6_frag_match(struct inet_frag_queue *q, void *a);
 
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
 static inline int ipv6_addr_any(const struct in6_addr *a)
 {
 	return (a->s6_addr32[0] | a->s6_addr32[1] |
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -226,8 +226,12 @@ EXPORT_SYMBOL(inet_listen);
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
@@ -237,7 +241,8 @@ void build_ehash_secret(void)
 		get_random_bytes(&rnd, sizeof(rnd));
 	} while (rnd == 0);
 
-	cmpxchg(&inet_ehash_secret, 0, rnd);
+	if (cmpxchg(&inet_ehash_secret, 0, rnd) == 0)
+		get_random_bytes(&ipv6_hash_secret, sizeof(ipv6_hash_secret));
 }
 EXPORT_SYMBOL(build_ehash_secret);
 


