Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3L2CK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:10:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54963 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934Ab3L2CKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:19 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <eric.dumazet@gmail.com>, "mpb" <mpb.mail@gmail.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.522949252@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 158/185] inet: prevent leakage of uninitialized memory
 to user  in recv syscalls
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/ping.c       | 9 ++++-----
 net/ipv4/raw.c        | 4 +---
 net/ipv4/udp.c        | 7 +------
 net/ipv6/raw.c        | 4 +---
 net/ipv6/udp.c        | 5 +----
 net/l2tp/l2tp_ip.c    | 4 +---
 net/phonet/datagram.c | 9 ++++-----
 7 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 294a380..41fea2d 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -623,7 +623,6 @@ static int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 			size_t len, int noblock, int flags, int *addr_len)
 {
 	struct inet_sock *isk = inet_sk(sk);
-	struct sockaddr_in *sin = (struct sockaddr_in *)msg->msg_name;
 	struct sk_buff *skb;
 	int copied, err;
 
@@ -632,9 +631,6 @@ static int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	if (flags & MSG_ERRQUEUE)
 		return ip_recv_error(sk, msg, len);
 
@@ -656,11 +652,14 @@ static int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	sock_recv_timestamp(msg, sk, skb);
 
 	/* Copy the address. */
-	if (sin) {
+	if (msg->msg_name) {
+		struct sockaddr_in *sin = (struct sockaddr_in *)msg->msg_name;
+
 		sin->sin_family = AF_INET;
 		sin->sin_port = 0 /* skb->h.uh->source */;
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (isk->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 2815014..c676d07 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -686,9 +686,6 @@ static int raw_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	if (flags & MSG_ERRQUEUE) {
 		err = ip_recv_error(sk, msg, len);
 		goto out;
@@ -716,6 +713,7 @@ static int raw_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		sin->sin_port = 0;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 5decc93..107ab5c 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1171,12 +1171,6 @@ int udp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	int is_udplite = IS_UDPLITE(sk);
 	bool slow;
 
-	/*
-	 *	Check any passed addresses
-	 */
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	if (flags & MSG_ERRQUEUE)
 		return ip_recv_error(sk, msg, len);
 
@@ -1231,6 +1225,7 @@ try_again:
 		sin->sin_port = udp_hdr(skb)->source;
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 6e6c2c4..3278f27 100644
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
 
@@ -498,6 +495,7 @@ static int rawv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 		sin6->sin6_scope_id = 0;
 		if (ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
 			sin6->sin6_scope_id = IP6CB(skb)->iif;
+		*addr_len = sizeof(*sin6);
 	}
 
 	sock_recv_ts_and_drops(msg, sk, skb);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index f9e496b..391329e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -347,9 +347,6 @@ int udpv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 	int is_udp4;
 	bool slow;
 
-	if (addr_len)
-		*addr_len=sizeof(struct sockaddr_in6);
-
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len);
 
@@ -423,7 +420,7 @@ try_again:
 			if (ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
 				sin6->sin6_scope_id = IP6CB(skb)->iif;
 		}
-
+		*addr_len = sizeof(*sin6);
 	}
 	if (is_udp4) {
 		if (inet->cmsg_flags)
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 6c7e609..334a93d 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -568,9 +568,6 @@ static int l2tp_ip_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *m
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		goto out;
@@ -593,6 +590,7 @@ static int l2tp_ip_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *m
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		sin->sin_port = 0;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/phonet/datagram.c b/net/phonet/datagram.c
index bf35b4e..b25f2d3 100644
--- a/net/phonet/datagram.c
+++ b/net/phonet/datagram.c
@@ -139,9 +139,6 @@ static int pn_recvmsg(struct kiocb *iocb, struct sock *sk,
 			MSG_CMSG_COMPAT))
 		goto out_nofree;
 
-	if (addr_len)
-		*addr_len = sizeof(sa);
-
 	skb = skb_recv_datagram(sk, flags, noblock, &rval);
 	if (skb == NULL)
 		goto out_nofree;
@@ -162,8 +159,10 @@ static int pn_recvmsg(struct kiocb *iocb, struct sock *sk,
 
 	rval = (flags & MSG_TRUNC) ? skb->len : copylen;
 
-	if (msg->msg_name != NULL)
-		memcpy(msg->msg_name, &sa, sizeof(struct sockaddr_pn));
+	if (msg->msg_name != NULL) {
+		memcpy(msg->msg_name, &sa, sizeof(sa));
+		*addr_len = sizeof(sa);
+	}
 
 out:
 	skb_free_datagram(sk, skb);

