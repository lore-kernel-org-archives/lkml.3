Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaELBly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:41:54 -0400
Received: from 1wt.eu ([62.212.114.60]:34412 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbaELBlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:50 -0400
Message-Id: <20140512003204.042698099@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: mpb <mpb.mail@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 082/143] inet: fix addr_len/msg->msg_namelen assignment in recv_error and
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 rxpmtu functions

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/net/ip.h       | 2 +-
 include/net/ipv6.h     | 3 ++-
 net/ipv4/ip_sockglue.c | 3 ++-
 net/ipv4/raw.c         | 2 +-
 net/ipv4/udp.c         | 2 +-
 net/ipv6/datagram.c    | 3 ++-
 net/ipv6/raw.c         | 2 +-
 net/ipv6/udp.c         | 2 +-
 8 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index a7d4675..e6860b1 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -391,7 +391,7 @@ extern int	compat_ip_getsockopt(struct sock *sk, int level,
 			int optname, char __user *optval, int __user *optlen);
 extern int	ip_ra_control(struct sock *sk, unsigned char on, void (*destructor)(struct sock *));
 
-extern int 	ip_recv_error(struct sock *sk, struct msghdr *msg, int len);
+extern int 	ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len);
 extern void	ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err, 
 			      __be16 port, u32 info, u8 *payload);
 extern void	ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 dport,
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 52d86da..cf928c4 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -567,7 +567,8 @@ extern int			compat_ipv6_getsockopt(struct sock *sk,
 extern int			ip6_datagram_connect(struct sock *sk, 
 						     struct sockaddr *addr, int addr_len);
 
-extern int 			ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len);
+extern int 			ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len,
+						int *addr_len);
 extern void			ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err, __be16 port,
 						u32 info, u8 *payload);
 extern void			ipv6_local_error(struct sock *sk, int err, struct flowi *fl, u32 info);
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 099e6c3..d5a179b 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -356,7 +356,7 @@ void ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 port, u32 inf
 /*
  *	Handle MSG_ERRQUEUE
  */
-int ip_recv_error(struct sock *sk, struct msghdr *msg, int len)
+int ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
 	struct sock_exterr_skb *serr;
 	struct sk_buff *skb, *skb2;
@@ -393,6 +393,7 @@ int ip_recv_error(struct sock *sk, struct msghdr *msg, int len)
 						   serr->addr_offset);
 		sin->sin_port = serr->port;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 
 	memcpy(&errhdr.ee, &serr->ee, sizeof(struct sock_extended_err));
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index c50344b..8065efa 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -682,7 +682,7 @@ static int raw_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		goto out;
 
 	if (flags & MSG_ERRQUEUE) {
-		err = ip_recv_error(sk, msg, len);
+		err = ip_recv_error(sk, msg, len, addr_len);
 		goto out;
 	}
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 80487ee..a9aed7e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -942,7 +942,7 @@ int udp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	int is_udplite = IS_UDPLITE(sk);
 
 	if (flags & MSG_ERRQUEUE)
-		return ip_recv_error(sk, msg, len);
+		return ip_recv_error(sk, msg, len, addr_len);
 
 try_again:
 	skb = __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index e2bdc6d..ef6436d 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -281,7 +281,7 @@ void ipv6_local_error(struct sock *sk, int err, struct flowi *fl, u32 info)
 /*
  *	Handle MSG_ERRQUEUE
  */
-int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
+int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sock_exterr_skb *serr;
@@ -333,6 +333,7 @@ int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
 				      htonl(0xffff),
 				      *(__be32 *)(nh + serr->addr_offset));
 		}
+		*addr_len = sizeof(*sin);
 	}
 
 	memcpy(&errhdr.ee, &serr->ee, sizeof(struct sock_extended_err));
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index df75f94..d5b09c7 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -457,7 +457,7 @@ static int rawv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 		return -EOPNOTSUPP;
 
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ce291af..3a91859 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -201,7 +201,7 @@ int udpv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 	int is_udp4;
 
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 try_again:
 	skb = __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),
-- 
1.7.12.2.21.g234cd45.dirty



