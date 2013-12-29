Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3L2Cnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:43:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55187 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325Ab3L2CKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:30 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>, "mpb" <mpb.mail@gmail.com>,
        Tom@decadent.org.uk, "David S. Miller" <davem@davemloft.net>,
        "Brad Spengler" <spender@grsecurity.net>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.732763262@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 161/185] inet: fix addr_len/msg->msg_namelen
 assignment in  recv_error and rxpmtu functions
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
 9 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 06aed72..b935e6c 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -466,7 +466,7 @@ extern int	compat_ip_getsockopt(struct sock *sk, int level,
 			int optname, char __user *optval, int __user *optlen);
 extern int	ip_ra_control(struct sock *sk, unsigned char on, void (*destructor)(struct sock *));
 
-extern int 	ip_recv_error(struct sock *sk, struct msghdr *msg, int len);
+extern int 	ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len);
 extern void	ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err, 
 			      __be16 port, u32 info, u8 *payload);
 extern void	ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 dport,
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 4d549cf..0580673 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -602,8 +602,10 @@ extern int			compat_ipv6_getsockopt(struct sock *sk,
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
index 3b36002..542a9c1 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -374,7 +374,7 @@ void ip_local_error(struct sock *sk, int err, __be32 daddr, __be16 port, u32 inf
 /*
  *	Handle MSG_ERRQUEUE
  */
-int ip_recv_error(struct sock *sk, struct msghdr *msg, int len)
+int ip_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
 	struct sock_exterr_skb *serr;
 	struct sk_buff *skb, *skb2;
@@ -411,6 +411,7 @@ int ip_recv_error(struct sock *sk, struct msghdr *msg, int len)
 						   serr->addr_offset);
 		sin->sin_port = serr->port;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 
 	memcpy(&errhdr.ee, &serr->ee, sizeof(struct sock_extended_err));
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 41fea2d..a1f6b34 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -632,7 +632,7 @@ static int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		goto out;
 
 	if (flags & MSG_ERRQUEUE)
-		return ip_recv_error(sk, msg, len);
+		return ip_recv_error(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index c676d07..cfded93 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -687,7 +687,7 @@ static int raw_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		goto out;
 
 	if (flags & MSG_ERRQUEUE) {
-		err = ip_recv_error(sk, msg, len);
+		err = ip_recv_error(sk, msg, len, addr_len);
 		goto out;
 	}
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 107ab5c..ccdb85a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1172,7 +1172,7 @@ int udp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	bool slow;
 
 	if (flags & MSG_ERRQUEUE)
-		return ip_recv_error(sk, msg, len);
+		return ip_recv_error(sk, msg, len, addr_len);
 
 try_again:
 	skb = __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index e248069..144c105 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -315,7 +315,7 @@ void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu)
 /*
  *	Handle MSG_ERRQUEUE
  */
-int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
+int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sock_exterr_skb *serr;
@@ -366,6 +366,7 @@ int ipv6_recv_error(struct sock *sk, struct msghdr *msg, int len)
 			ipv6_addr_set_v4mapped(*(__be32 *)(nh + serr->addr_offset),
 					       &sin->sin6_addr);
 		}
+		*addr_len = sizeof(*sin);
 	}
 
 	memcpy(&errhdr.ee, &serr->ee, sizeof(struct sock_extended_err));
@@ -418,7 +419,8 @@ out:
 /*
  *	Handle IPV6_RECVPATHMTU
  */
-int ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len)
+int ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len,
+		     int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sk_buff *skb;
@@ -452,6 +454,7 @@ int ipv6_recv_rxpmtu(struct sock *sk, struct msghdr *msg, int len)
 		sin->sin6_port = 0;
 		sin->sin6_scope_id = mtu_info.ip6m_addr.sin6_scope_id;
 		ipv6_addr_copy(&sin->sin6_addr, &mtu_info.ip6m_addr.sin6_addr);
+		*addr_len = sizeof(*sin);
 	}
 
 	put_cmsg(msg, SOL_IPV6, IPV6_PATHMTU, sizeof(mtu_info), &mtu_info);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 3278f27..9ecbc84 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -457,10 +457,10 @@ static int rawv6_recvmsg(struct kiocb *iocb, struct sock *sk,
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
index 391329e..f8bec1e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -348,10 +348,10 @@ int udpv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 	bool slow;
 
 	if (flags & MSG_ERRQUEUE)
-		return ipv6_recv_error(sk, msg, len);
+		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
-		return ipv6_recv_rxpmtu(sk, msg, len);
+		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 try_again:
 	skb = __skb_recv_datagram(sk, flags | (noblock ? MSG_DONTWAIT : 0),

