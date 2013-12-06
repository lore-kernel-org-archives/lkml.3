Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162062Ab3LFWSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:18:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272Ab3LFVx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brad Spengler <spender@grsecurity.net>, mpb <mpb.mail@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [PATCH 3.10 21/58] inet: fix addr_len/msg->msg_namelen assignment in recv_error and rxpmtu functions
Date: Fri,  6 Dec 2013 13:51:52 -0800
Message-Id: <20131206214846.885817306@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 85fbaa75037d0b6b786ff18658ddf0b4014ce2a4 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip.h       |    2 +-
 include/net/ipv6.h     |    6 ++++--
 net/ipv4/ip_sockglue.c |    3 ++-
 net/ipv4/ping.c        |    2 +-
 net/ipv4/raw.c         |    2 +-
 net/ipv4/udp.c         |    2 +-
 net/ipv6/datagram.c    |    7 +++++--
 net/ipv6/raw.c         |    4 ++--
 net/ipv6/udp.c         |    4 ++--
 net/l2tp/l2tp_ip6.c    |    2 +-
 10 files changed, 20 insertions(+), 14 deletions(-)

--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -454,7 +454,7 @@ extern int	compat_ip_getsockopt(struct s
 			int optname, char __user *optval, int __user *optlen);
 extern int	ip_ra_control(struct sock *sk, unsigned char on, void (*destructor)(struct sock *));
 
-extern int 	ip_recv_error(struct sock *sk, struct msghdr *msg, int len);
+extern int 	ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len);
 extern void	ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err, 
 			      __be16 port, u32 info, u8 *payload);
 extern void	ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 dport,
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -793,8 +793,10 @@ extern int			compat_ipv6_getsockopt(stru
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
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -368,7 +368,7 @@ void ip_local_error(struct sock *sk, int
 /*
  *	Handle MSG_ERRQUEUE
  */
-int ip_recv_error(struct sock *sk, struct msghdr *msg, int len)
+int ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
 	struct sock_exterr_skb *serr;
 	struct sk_buff *skb, *skb2;
@@ -405,6 +405,7 @@ int ip_recv_error(struct sock *sk, struc
 						   serr->addr_offset);
 		sin->sin_port = serr->port;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 
 	memcpy(&errhdr.ee, &serr->ee, sizeof(struct sock_extended_err));
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -636,7 +636,7 @@ static int ping_recvmsg(struct kiocb *io
 		goto out;
 
 	if (flags & MSG_ERRQUEUE)
-		return ip_recv_error(sk, msg, len);
+		return ip_recv_error(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -693,7 +693,7 @@ static int raw_recvmsg(struct kiocb *ioc
 		goto out;
 
 	if (flags & MSG_ERRQUEUE) {
-		err = ip_recv_error(sk, msg, len);
+		err = ip_recv_error(sk, msg, len, addr_len);
 		goto out;
 	}
 
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1208,7 +1208,7 @@ int udp_recvmsg(struct kiocb *iocb, stru
 	bool slow;
 
 	if (flags & MSG_ERRQUEUE)
-		return ip_recv_error(sk, msg, len);
+		return ip_recv_error(sk, msg, len, addr_len);
 
 try_again:
 	skb = __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -318,7 +318,7 @@ void ipv6_local_rxpmtu(struct sock *sk,
 /*
  *	Handle MSG_ERRQUEUE
  */
-int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
+int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sock_exterr_skb *serr;
@@ -369,6 +369,7 @@ int ipv6_recv_error(struct sock *sk, str
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
@@ -457,6 +459,7 @@ int ipv6_recv_rxpmtu(struct sock *sk, st
 		sin->sin6_port = 0;
 		sin->sin6_scope_id = mtu_info.ip6m_addr.sin6_scope_id;
 		sin->sin6_addr = mtu_info.ip6m_addr.sin6_addr;
+		*addr_len = sizeof(*sin);
 	}
 
 	put_cmsg(msg, SOL_IPV6, IPV6_PATHMTU, sizeof(mtu_info), &mtu_info);
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -460,10 +460,10 @@ static int rawv6_recvmsg(struct kiocb *i
 		return -EOPNOTSUPP;
 
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
-		return ipv6_recv_rxpmtu(sk, msg, len);
+		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -374,10 +374,10 @@ int udpv6_recvmsg(struct kiocb *iocb, st
 	bool slow;
 
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
-		return ipv6_recv_rxpmtu(sk, msg, len);
+		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 try_again:
 	skb = __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -665,7 +665,7 @@ static int l2tp_ip6_recvmsg(struct kiocb
 		*addr_len = sizeof(*lsa);
 
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)


