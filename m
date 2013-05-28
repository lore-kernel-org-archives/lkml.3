Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab3E1D4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52554 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758915Ab3E1DyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:19 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.354162096@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [89/94] ipv6: do not clear pinet6 field
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f77d602124d865c38705df7fa25c03de9c284ad2 ]

We have seen multiple NULL dereferences in __inet6_lookup_established()

After analysis, I found that inet6_sk() could be NULL while the
check for sk_family == AF_INET6 was true.

Bug was added in linux-2.6.29 when RCU lookups were introduced in UDP
and TCP stacks.

Once an IPv6 socket, using SLAB_DESTROY_BY_RCU is inserted in a hash
table, we no longer can clear pinet6 field.

This patch extends logic used in commit fcbdf09d9652c891
("net: fix nulls list corruptions in sk_prot_alloc")

TCP/UDP/UDPLite IPv6 protocols provide their own .clear_sk() method
to make sure we do not clear pinet6 field.

At socket clone phase, we do not really care, as cloning the parent (non
NULL) pinet6 is not adding a fatal race.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/sock.h  | 12 ++++++++++++
 net/core/sock.c     | 12 ------------
 net/ipv6/tcp_ipv6.c | 12 ++++++++++++
 net/ipv6/udp.c      | 13 ++++++++++++-
 net/ipv6/udp_impl.h |  2 ++
 net/ipv6/udplite.c  |  2 +-
 6 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index ddf523c..e6454b6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -734,6 +734,18 @@ struct inet_hashinfo;
 struct raw_hashinfo;
 struct module;
 
+/*
+ * caches using SLAB_DESTROY_BY_RCU should let .next pointer from nulls nodes
+ * un-modified. Special care is taken when initializing object to zero.
+ */
+static inline void sk_prot_clear_nulls(struct sock *sk, int size)
+{
+	if (offsetof(struct sock, sk_node.next) != 0)
+		memset(sk, 0, offsetof(struct sock, sk_node.next));
+	memset(&sk->sk_node.pprev, 0,
+	       size - offsetof(struct sock, sk_node.pprev));
+}
+
 /* Networking protocol blocks we attach to sockets.
  * socket layer -> transport layer interface
  * transport -> network interface is defined by struct inet_proto
diff --git a/net/core/sock.c b/net/core/sock.c
index 2c73adf..8a2c2dd 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1021,18 +1021,6 @@ static void sock_copy(struct sock *nsk, const struct sock *osk)
 #endif
 }
 
-/*
- * caches using SLAB_DESTROY_BY_RCU should let .next pointer from nulls nodes
- * un-modified. Special care is taken when initializing object to zero.
- */
-static inline void sk_prot_clear_nulls(struct sock *sk, int size)
-{
-	if (offsetof(struct sock, sk_node.next) != 0)
-		memset(sk, 0, offsetof(struct sock, sk_node.next));
-	memset(&sk->sk_node.pprev, 0,
-	       size - offsetof(struct sock, sk_node.pprev));
-}
-
 void sk_prot_clear_portaddr_nulls(struct sock *sk, int size)
 {
 	unsigned long nulls1, nulls2;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index db10805..c69358c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2196,6 +2196,17 @@ void tcp6_proc_exit(struct net *net)
 }
 #endif
 
+static void tcp_v6_clear_sk(struct sock *sk, int size)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	/* we do not want to clear pinet6 field, because of RCU lookups */
+	sk_prot_clear_nulls(sk, offsetof(struct inet_sock, pinet6));
+
+	size -= offsetof(struct inet_sock, pinet6) + sizeof(inet->pinet6);
+	memset(&inet->pinet6 + 1, 0, size);
+}
+
 struct proto tcpv6_prot = {
 	.name			= "TCPv6",
 	.owner			= THIS_MODULE,
@@ -2235,6 +2246,7 @@ struct proto tcpv6_prot = {
 	.compat_setsockopt	= compat_tcp_setsockopt,
 	.compat_getsockopt	= compat_tcp_getsockopt,
 #endif
+	.clear_sk		= tcp_v6_clear_sk,
 };
 
 static const struct inet6_protocol tcpv6_protocol = {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 8c25419..20f0812 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1453,6 +1453,17 @@ void udp6_proc_exit(struct net *net) {
 }
 #endif /* CONFIG_PROC_FS */
 
+void udp_v6_clear_sk(struct sock *sk, int size)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	/* we do not want to clear pinet6 field, because of RCU lookups */
+	sk_prot_clear_portaddr_nulls(sk, offsetof(struct inet_sock, pinet6));
+
+	size -= offsetof(struct inet_sock, pinet6) + sizeof(inet->pinet6);
+	memset(&inet->pinet6 + 1, 0, size);
+}
+
 /* ------------------------------------------------------------------------ */
 
 struct proto udpv6_prot = {
@@ -1483,7 +1494,7 @@ struct proto udpv6_prot = {
 	.compat_setsockopt = compat_udpv6_setsockopt,
 	.compat_getsockopt = compat_udpv6_getsockopt,
 #endif
-	.clear_sk	   = sk_prot_clear_portaddr_nulls,
+	.clear_sk	   = udp_v6_clear_sk,
 };
 
 static struct inet_protosw udpv6_protosw = {
diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
index d757104..4691ed5 100644
--- a/net/ipv6/udp_impl.h
+++ b/net/ipv6/udp_impl.h
@@ -31,6 +31,8 @@ extern int	udpv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 extern int	udpv6_queue_rcv_skb(struct sock * sk, struct sk_buff *skb);
 extern void	udpv6_destroy_sock(struct sock *sk);
 
+extern void udp_v6_clear_sk(struct sock *sk, int size);
+
 #ifdef CONFIG_PROC_FS
 extern int	udp6_seq_show(struct seq_file *seq, void *v);
 #endif
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index 1d08e21..dfcc4be 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -56,7 +56,7 @@ struct proto udplitev6_prot = {
 	.compat_setsockopt = compat_udpv6_setsockopt,
 	.compat_getsockopt = compat_udpv6_getsockopt,
 #endif
-	.clear_sk	   = sk_prot_clear_portaddr_nulls,
+	.clear_sk	   = udp_v6_clear_sk,
 };
 
 static struct inet_protosw udplite6_protosw = {

