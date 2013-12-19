Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab3LSNFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:05:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44483 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3LSLzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:55:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: mpb <mpb.mail@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 024/208] inet: fix addr_len/msg->msg_namelen assignment in recv_error and rxpmtu functions
Date: Thu, 19 Dec 2013 11:52:02 +0000
Message-Id: <1387454106-19326-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 85fbaa75037d0b6b786ff18658ddf0b4014ce2a4 upstream.

Commit bceaa90240b6019ed73b49965eac7d167610be69 ("inet: prevent leakage
of uninitialized memory to user in recv syscalls") conditionally updated
addr_len if the msg_name is written to. The recv_error and rxpmtu
functions relied on the recvmsg functions to set up addr_len before.

As this does not happen any more we have to pass addr_len to those
functions as well and set it to the size of the corresponding sockaddr
length.

This broke traceroute and such.

Fixes: bceaa90240b6 ("inet: prevent leakage of uninitialized memory to user in recv syscalls")
Reported-by: Brad Spengler <spender@grsecurity.net>
Reported-by: Tom Labanowski
Cc: mpb <mpb.mail@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/ip.h       | 2 +-
 include/net/ipv6.h     | 6 ++++--
 include/net/ping.h     | 3 ++-
 net/ipv4/ip_sockglue.c | 3 ++-
 net/ipv4/ping.c        | 5 +++--
 net/ipv4/raw.c         | 2 +-
 net/ipv4/udp.c         | 2 +-
 net/ipv6/datagram.c    | 7 +++++--
 net/ipv6/ping.c        | 3 ++-
 net/ipv6/raw.c         | 4 ++--
 net/ipv6/udp.c         | 4 ++--
 net/l2tp/l2tp_ip6.c    | 2 +-
 12 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index edfa591..788f1d8 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -454,7 +454,7 @@ extern int	compat_ip_getsockopt(struct sock *sk, int level,
 			int optname, char __user *optval, int __user *optlen);
 extern int	ip_ra_control(struct sock *sk, unsigned char on, void (*destructor)(struct sock *));
 
-extern int 	ip_recv_error(struct sock *sk, struct msghdr *msg, int len);
+extern int 	ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len);
 extern void	ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err, 
 			      __be16 port, u32 info, u8 *payload);
 extern void	ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 dport,
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 5fe5649..62ccfc0 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -799,8 +799,10 @@ extern int			compat_ipv6_getsockopt(struct sock *sk,
 extern int			ip6_datagram_connect(struct sock *sk, 
 						     struct sockaddr *addr, int addr_len);
 
-extern int 			ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len);
-extern int 			ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len);
+extern int 			ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
+						int *addr_len);
+extern int 			ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len,
+						 int *addr_len);
 extern void			ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err, __be16 port,
 						u32 info, u8 *payload);
 extern void			ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
diff --git a/include/net/ping.h b/include/net/ping.h
index 5db0224..2b496e9 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -31,7 +31,8 @@
 
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 struct pingv6_ops {
-	int (*ipv6_recv_error)(struct sock *sk, struct msghdr *msg, int len);
+	int (*ipv6_recv_error)(struct sock *sk, struct msghdr *msg, int len,
+			       int *addr_len);
 	int (*ip6_datagram_recv_ctl)(struct sock *sk, struct msghdr *msg,
 				     struct sk_buff *skb);
 	int (*icmpv6_err_convert)(u8 type, u8 code, int *err);
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index d9c4f11..23e6ab0 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -368,7 +368,7 @@ void ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 port, u32 inf
 /*
  *	Handle MSG_ERRQUEUE
  */
-int ip_recv_error(struct sock *sk, struct msghdr *msg, int len)
+int ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
 	struct sock_exterr_skb *serr;
 	struct sk_buff *skb, *skb2;
@@ -405,6 +405,7 @@ int ip_recv_error(struct sock *sk, struct msghdr *msg, int len)
 						   serr->addr_offset);
 		sin->sin_port = serr->port;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 
 	memcpy(&errhdr.ee, &serr->ee, sizeof(struct sock_extended_err));
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 8bdf040..09ee970 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -838,10 +838,11 @@ int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 
 	if (flags & MSG_ERRQUEUE) {
 		if (family == AF_INET) {
-			return ip_recv_error(sk, msg, len);
+			return ip_recv_error(sk, msg, len, addr_len);
 #if IS_ENABLED(CONFIG_IPV6)
 		} else if (family == AF_INET6) {
-			return pingv6_ops.ipv6_recv_error(sk, msg, len);
+			return pingv6_ops.ipv6_recv_error(sk, msg, len,
+							  addr_len);
 #endif
 		}
 	}
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 448e5a7..402870f 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -693,7 +693,7 @@ static int raw_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		goto out;
 
 	if (flags & MSG_ERRQUEUE) {
-		err = ip_recv_error(sk, msg, len);
+		err = ip_recv_error(sk, msg, len, addr_len);
 		goto out;
 	}
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c69955f..a5fbb8c 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1209,7 +1209,7 @@ int udp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	bool slow;
 
 	if (flags & MSG_ERRQUEUE)
-		return ip_recv_error(sk, msg, len);
+		return ip_recv_error(sk, msg, len, addr_len);
 
 try_again:
 	skb = __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 197e6f4..a5ca9bf 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -318,7 +318,7 @@ void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu)
 /*
  *	Handle MSG_ERRQUEUE
  */
-int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
+int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sock_exterr_skb *serr;
@@ -369,6 +369,7 @@ int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
 					       &sin->sin6_addr);
 			sin->sin6_scope_id = 0;
 		}
+		*addr_len = sizeof(*sin);
 	}
 
 	memcpy(&errhdr.ee, &serr->ee, sizeof(struct sock_extended_err));
@@ -423,7 +424,8 @@ EXPORT_SYMBOL_GPL(ipv6_recv_error);
 /*
  *	Handle IPV6_RECVPATHMTU
  */
-int ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len)
+int ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len,
+		     int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sk_buff *skb;
@@ -457,6 +459,7 @@ int ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len)
 		sin->sin6_port = 0;
 		sin->sin6_scope_id = mtu_info.ip6m_addr.sin6_scope_id;
 		sin->sin6_addr = mtu_info.ip6m_addr.sin6_addr;
+		*addr_len = sizeof(*sin);
 	}
 
 	put_cmsg(msg, SOL_IPV6, IPV6_PATHMTU, sizeof(mtu_info), &mtu_info);
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 18f19df..7856e96 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -57,7 +57,8 @@ static struct inet_protosw pingv6_protosw = {
 
 
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
-static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
+static int dummy_ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
+				 int *addr_len)
 {
 	return -EAFNOSUPPORT;
 }
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 8aa1b31..df838ee 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -460,10 +460,10 @@ static int rawv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 		return -EOPNOTSUPP;
 
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
-		return ipv6_recv_rxpmtu(sk, msg, len);
+		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index a483286..524b278 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -375,10 +375,10 @@ int udpv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 	bool slow;
 
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
-		return ipv6_recv_rxpmtu(sk, msg, len);
+		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 try_again:
 	skb = __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index b8a6039..e6e8408 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -665,7 +665,7 @@ static int l2tp_ip6_recvmsg(struct kiocb *iocb, struct sock *sk,
 		*addr_len = sizeof(*lsa);
 
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
-- 
1.8.3.2

