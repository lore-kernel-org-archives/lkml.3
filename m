Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaELBmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:42:00 -0400
Received: from 1wt.eu ([62.212.114.60]:34435 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbaELBl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:57 -0400
Message-Id: <20140512003203.916690450@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 079/143] inet: prevent leakage of uninitialized memory to user in recv
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 syscalls

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit bceaa90240b6019ed73b49965eac7d167610be69 ]

Only update *addr_len when we actually fill in sockaddr, otherwise we
can return uninitialized memory from the stack to the caller in the
recvfrom, recvmmsg and recvmsg syscalls. Drop the the (addr_len == NULL)
checks because we only get called with a valid addr_len pointer either
from sock_common_recvmsg or inet_recvmsg.

If a blocking read waits on a socket which is concurrently shut down we
now return zero and set msg_msgnamelen to 0.

Reported-by: mpb <mpb.mail@gmail.com>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[wt: no ieee802154, ping nor l2tp in 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/raw.c        | 4 +---
 net/ipv4/udp.c        | 7 +------
 net/ipv6/raw.c        | 4 +---
 net/ipv6/udp.c        | 5 +----
 net/phonet/datagram.c | 9 ++++-----
 5 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 07ab583..c50344b 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -681,9 +681,6 @@ static int raw_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	if (flags & MSG_ERRQUEUE) {
 		err = ip_recv_error(sk, msg, len);
 		goto out;
@@ -711,6 +708,7 @@ static int raw_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		sin->sin_port = 0;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index af559e0..80487ee 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -941,12 +941,6 @@ int udp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	int err;
 	int is_udplite = IS_UDPLITE(sk);
 
-	/*
-	 *	Check any passed addresses
-	 */
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	if (flags & MSG_ERRQUEUE)
 		return ip_recv_error(sk, msg, len);
 
@@ -1001,6 +995,7 @@ try_again:
 		sin->sin_port = udp_hdr(skb)->source;
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 4f24570..df75f94 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -456,9 +456,6 @@ static int rawv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	if (addr_len)
-		*addr_len=sizeof(*sin6);
-
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len);
 
@@ -495,6 +492,7 @@ static int rawv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 		sin6->sin6_scope_id = 0;
 		if (ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
 			sin6->sin6_scope_id = IP6CB(skb)->iif;
+		*addr_len = sizeof(*sin6);
 	}
 
 	sock_recv_timestamp(msg, sk, skb);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index d8c0374..ce291af 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -200,9 +200,6 @@ int udpv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 	int is_udplite = IS_UDPLITE(sk);
 	int is_udp4;
 
-	if (addr_len)
-		*addr_len=sizeof(struct sockaddr_in6);
-
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len);
 
@@ -273,7 +270,7 @@ try_again:
 			if (ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
 				sin6->sin6_scope_id = IP6CB(skb)->iif;
 		}
-
+		*addr_len = sizeof(*sin6);
 	}
 	if (is_udp4) {
 		if (inet->cmsg_flags)
diff --git a/net/phonet/datagram.c b/net/phonet/datagram.c
index ef5c75c..c88da73 100644
--- a/net/phonet/datagram.c
+++ b/net/phonet/datagram.c
@@ -122,9 +122,6 @@ static int pn_recvmsg(struct kiocb *iocb, struct sock *sk,
 	if (flags & MSG_OOB)
 		goto out_nofree;
 
-	if (addr_len)
-		*addr_len = sizeof(sa);
-
 	skb = skb_recv_datagram(sk, flags, noblock, &rval);
 	if (skb == NULL)
 		goto out_nofree;
@@ -145,8 +142,10 @@ static int pn_recvmsg(struct kiocb *iocb, struct sock *sk,
 
 	rval = (flags & MSG_TRUNC) ? skb->len : copylen;
 
-	if (msg->msg_name != NULL)
-		memcpy(msg->msg_name, &sa, sizeof(struct sockaddr_pn));
+	if (msg->msg_name != NULL) {
+		memcpy(msg->msg_name, &sa, sizeof(sa));
+		*addr_len = sizeof(sa);
+	}
 
 out:
 	skb_free_datagram(sk, skb);
-- 
1.7.12.2.21.g234cd45.dirty



