Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3LQSOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:14:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60771 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab3LQSOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: mpb <mpb.mail@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 017/103] inet: fix addr_len/msg->msg_namelen assignment in recv_error and rxpmtu functions
Date: Tue, 17 Dec 2013 18:12:06 +0000
Message-Id: <1387304012-23805-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: based on davem's backport to 3.4 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/ip.h       | 2 +-
 include/net/ipv6.h     | 6 ++++--
 net/ipv4/ip_sockglue.c | 3 ++-
 net/ipv4/ping.c        | 2 +-
 net/ipv4/raw.c         | 2 +-
 net/ipv4/udp.c         | 2 +-
 net/ipv6/datagram.c    | 7 +++++--
 net/ipv6/raw.c         | 4 ++--
 net/ipv6/udp.c         | 4 ++--
 net/l2tp/l2tp_ip6.c    | 2 +-
 10 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index d34f531..9fd963f 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -446,7 +446,7 @@ extern int	compat_ip_getsockopt(struct sock *sk, int level,
 			int optname, char __user *optval, int __user *optlen);
 extern int	ip_ra_control(struct sock *sk, unsigned char on, void (*destructor)(struct sock *));
 
-extern int 	ip_recv_error(struct sock *sk, struct msghdr *msg, int len);
+extern int 	ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len);
 extern void	ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err, 
 			      __be16 port, u32 info, u8 *payload);
 extern void	ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 dport,
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index c11fa5d..94cb787 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -605,8 +605,10 @@ extern int			compat_ipv6_getsockopt(struct sock *sk,
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
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index aabeb7b..34790df 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -367,7 +367,7 @@ void ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 port, u32 inf
 /*
  *	Handle MSG_ERRQUEUE
  */
-int ip_recv_error(struct sock *sk, struct msghdr *msg, int len)
+int ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
 	struct sock_exterr_skb *serr;
 	struct sk_buff *skb, *skb2;
@@ -404,6 +404,7 @@ int ip_recv_error(struct sock *sk, struct msghdr *msg, int len)
 						   serr->addr_offset);
 		sin->sin_port = serr->port;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 
 	memcpy(&errhdr.ee, &serr->ee, sizeof(struct sock_extended_err));
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index ef0d19d..7207980 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -641,7 +641,7 @@ static int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		goto out;
 
 	if (flags & MSG_ERRQUEUE)
-		return ip_recv_error(sk, msg, len);
+		return ip_recv_error(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 16d075e..e9c21f7 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -689,7 +689,7 @@ static int raw_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		goto out;
 
 	if (flags & MSG_ERRQUEUE) {
-		err = ip_recv_error(sk, msg, len);
+		err = ip_recv_error(sk, msg, len, addr_len);
 		goto out;
 	}
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 6579494..de3033a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1176,7 +1176,7 @@ int udp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	bool slow;
 
 	if (flags & MSG_ERRQUEUE)
-		return ip_recv_error(sk, msg, len);
+		return ip_recv_error(sk, msg, len, addr_len);
 
 try_again:
 	skb = __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index be2b67d6..876739f 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -317,7 +317,7 @@ void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu)
 /*
  *	Handle MSG_ERRQUEUE
  */
-int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
+int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sock_exterr_skb *serr;
@@ -368,6 +368,7 @@ int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
 			ipv6_addr_set_v4mapped(*(__be32 *)(nh + serr->addr_offset),
 					       &sin->sin6_addr);
 		}
+		*addr_len = sizeof(*sin);
 	}
 
 	memcpy(&errhdr.ee, &serr->ee, sizeof(struct sock_extended_err));
@@ -421,7 +422,8 @@ EXPORT_SYMBOL_GPL(ipv6_recv_error);
 /*
  *	Handle IPV6_RECVPATHMTU
  */
-int ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len)
+int ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len,
+		     int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sk_buff *skb;
@@ -455,6 +457,7 @@ int ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len)
 		sin->sin6_port = 0;
 		sin->sin6_scope_id = mtu_info.ip6m_addr.sin6_scope_id;
 		sin->sin6_addr = mtu_info.ip6m_addr.sin6_addr;
+		*addr_len = sizeof(*sin);
 	}
 
 	put_cmsg(msg, SOL_IPV6, IPV6_PATHMTU, sizeof(mtu_info), &mtu_info);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 07a7df6..dbd6795 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -458,10 +458,10 @@ static int rawv6_recvmsg(struct kiocb *iocb, struct sock *sk,
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
index a7364cd..0a56096 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -349,10 +349,10 @@ int udpv6_recvmsg(struct kiocb *iocb, struct sock *sk,
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
index 2c9ccce..c466f04 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -659,7 +659,7 @@ static int l2tp_ip6_recvmsg(struct kiocb *iocb, struct sock *sk,
 		*addr_len = sizeof(*lsa);
 
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
-- 
1.8.3.2

