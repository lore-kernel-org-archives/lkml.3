Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3CZRuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:50:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3CZRgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:20 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=S5mW-wL1zYsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=V-YTkKGxLggA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=Da1No7cPAAAA:8 a=b_IVpaG6E_ewCzWTwaoA:9 a=6z04QOUsx9AA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173606.841406336@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Neal Cardwell <ncardwell@google.com>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 43/86] ipv6: use a stronger hash for tcp
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0043-ipv6-use-a-stronger-hash-for-tcp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 include/net/inet6_hashtables.h |    8 ++++----
 include/net/inet_sock.h        |    1 +
 include/net/ipv6.h             |   12 ++++++++++++
 net/ipv4/af_inet.c             |    9 +++++++--
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index 9e34c87..f071f50 100644
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
index 613cfa4..8eac4a9 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -203,6 +203,7 @@ static inline void inet_sk_copy_descendant(struct sock *sk_to,
 extern int inet_sk_rebuild_header(struct sock *sk);
 
 extern u32 inet_ehash_secret;
+extern u32 ipv6_hash_secret;
 extern void build_ehash_secret(void);
 
 static inline unsigned int inet_ehashfn(struct net *net,
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 01c34b3..640591f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -15,6 +15,7 @@
 
 #include <linux/ipv6.h>
 #include <linux/hardirq.h>
+#include <linux/jhash.h>
 #include <net/if_inet6.h>
 #include <net/ndisc.h>
 #include <net/flow.h>
@@ -432,6 +433,17 @@ static inline u32 ipv6_addr_hash(const struct in6_addr *a)
 #endif
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
index fe4582c..26222ed 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -228,8 +228,12 @@ EXPORT_SYMBOL(inet_listen);
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
@@ -239,7 +243,8 @@ void build_ehash_secret(void)
 		get_random_bytes(&rnd, sizeof(rnd));
 	} while (rnd == 0);
 
-	cmpxchg(&inet_ehash_secret, 0, rnd);
+	if (cmpxchg(&inet_ehash_secret, 0, rnd) == 0)
+		get_random_bytes(&ipv6_hash_secret, sizeof(ipv6_hash_secret));
 }
 EXPORT_SYMBOL(build_ehash_secret);
 
-- 
1.7.10.4


