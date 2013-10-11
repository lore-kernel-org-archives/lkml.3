Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab3JKUF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:05:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534Ab3JKTl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Hannes Frederic Sowa <hannes@strressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 038/135] net: net_secret should not depend on TCP
Date: Fri, 11 Oct 2013 12:38:39 -0700
Message-Id: <20131011193949.375740230@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9a3bab6b05383f1e4c3716b3615500c51285959e ]

A host might need net_secret[] and never open a single socket.

Problem added in commit aebda156a570782
("net: defer net_secret[] initialization")

Based on prior patch from Hannes Frederic Sowa.

Reported-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Hannes Frederic Sowa <hannes@strressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/secure_seq.h |    1 -
 net/core/secure_seq.c    |   27 ++++++++++++++++++++++++---
 net/ipv4/af_inet.c       |    4 +---
 3 files changed, 25 insertions(+), 7 deletions(-)

--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@ -3,7 +3,6 @@
 
 #include <linux/types.h>
 
-extern void net_secret_init(void);
 extern __u32 secure_ip_id(__be32 daddr);
 extern __u32 secure_ipv6_id(const __be32 daddr[4]);
 extern u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -10,11 +10,24 @@
 
 #include <net/secure_seq.h>
 
-static u32 net_secret[MD5_MESSAGE_BYTES / 4] ____cacheline_aligned;
+#define NET_SECRET_SIZE (MD5_MESSAGE_BYTES / 4)
 
-void net_secret_init(void)
+static u32 net_secret[NET_SECRET_SIZE] ____cacheline_aligned;
+
+static void net_secret_init(void)
 {
-	get_random_bytes(net_secret, sizeof(net_secret));
+	u32 tmp;
+	int i;
+
+	if (likely(net_secret[0]))
+		return;
+
+	for (i = NET_SECRET_SIZE; i > 0;) {
+		do {
+			get_random_bytes(&tmp, sizeof(tmp));
+		} while (!tmp);
+		cmpxchg(&net_secret[--i], 0, tmp);
+	}
 }
 
 #ifdef CONFIG_INET
@@ -42,6 +55,7 @@ __u32 secure_tcpv6_sequence_number(const
 	u32 hash[MD5_DIGEST_WORDS];
 	u32 i;
 
+	net_secret_init();
 	memcpy(hash, saddr, 16);
 	for (i = 0; i < 4; i++)
 		secret[i] = net_secret[i] + (__force u32)daddr[i];
@@ -63,6 +77,7 @@ u32 secure_ipv6_port_ephemeral(const __b
 	u32 hash[MD5_DIGEST_WORDS];
 	u32 i;
 
+	net_secret_init();
 	memcpy(hash, saddr, 16);
 	for (i = 0; i < 4; i++)
 		secret[i] = net_secret[i] + (__force u32) daddr[i];
@@ -82,6 +97,7 @@ __u32 secure_ip_id(__be32 daddr)
 {
 	u32 hash[MD5_DIGEST_WORDS];
 
+	net_secret_init();
 	hash[0] = (__force __u32) daddr;
 	hash[1] = net_secret[13];
 	hash[2] = net_secret[14];
@@ -96,6 +112,7 @@ __u32 secure_ipv6_id(const __be32 daddr[
 {
 	__u32 hash[4];
 
+	net_secret_init();
 	memcpy(hash, daddr, 16);
 	md5_transform(hash, net_secret);
 
@@ -107,6 +124,7 @@ __u32 secure_tcp_sequence_number(__be32
 {
 	u32 hash[MD5_DIGEST_WORDS];
 
+	net_secret_init();
 	hash[0] = (__force u32)saddr;
 	hash[1] = (__force u32)daddr;
 	hash[2] = ((__force u16)sport << 16) + (__force u16)dport;
@@ -121,6 +139,7 @@ u32 secure_ipv4_port_ephemeral(__be32 sa
 {
 	u32 hash[MD5_DIGEST_WORDS];
 
+	net_secret_init();
 	hash[0] = (__force u32)saddr;
 	hash[1] = (__force u32)daddr;
 	hash[2] = (__force u32)dport ^ net_secret[14];
@@ -140,6 +159,7 @@ u64 secure_dccp_sequence_number(__be32 s
 	u32 hash[MD5_DIGEST_WORDS];
 	u64 seq;
 
+	net_secret_init();
 	hash[0] = (__force u32)saddr;
 	hash[1] = (__force u32)daddr;
 	hash[2] = ((__force u16)sport << 16) + (__force u16)dport;
@@ -164,6 +184,7 @@ u64 secure_dccpv6_sequence_number(__be32
 	u64 seq;
 	u32 i;
 
+	net_secret_init();
 	memcpy(hash, saddr, 16);
 	for (i = 0; i < 4; i++)
 		secret[i] = net_secret[i] + daddr[i];
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -263,10 +263,8 @@ void build_ehash_secret(void)
 		get_random_bytes(&rnd, sizeof(rnd));
 	} while (rnd == 0);
 
-	if (cmpxchg(&inet_ehash_secret, 0, rnd) == 0) {
+	if (cmpxchg(&inet_ehash_secret, 0, rnd) == 0)
 		get_random_bytes(&ipv6_hash_secret, sizeof(ipv6_hash_secret));
-		net_secret_init();
-	}
 }
 EXPORT_SYMBOL(build_ehash_secret);
 


