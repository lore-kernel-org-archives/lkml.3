Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3LQSoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:44:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60716 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3LQSNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:13:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 011/103] inet: prevent leakage of uninitialized memory to user in recv syscalls
Date: Tue, 17 Dec 2013 18:12:00 +0000
Message-Id: <1387304012-23805-12-git-send-email-luis.henriques@canonical.com>
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

commit bceaa90240b6019ed73b49965eac7d167610be69 upstream.

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
[ luis: backported to 3.5: based on davem's backport to 3.4 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
index 79db4e5..ef0d19d 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -631,7 +631,6 @@ static int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 			size_t len, int noblock, int flags, int *addr_len)
 {
 	struct inet_sock *isk = inet_sk(sk);
-	struct sockaddr_in *sin = (struct sockaddr_in *)msg->msg_name;
 	struct sk_buff *skb;
 	int copied, err;
 
@@ -641,9 +640,6 @@ static int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	if (flags & MSG_ERRQUEUE)
 		return ip_recv_error(sk, msg, len);
 
@@ -665,11 +661,14 @@ static int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
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
index 0753bd7..16d075e 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -688,9 +688,6 @@ static int raw_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	if (flags & MSG_ERRQUEUE) {
 		err = ip_recv_error(sk, msg, len);
 		goto out;
@@ -718,6 +715,7 @@ static int raw_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		sin->sin_port = 0;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index cd45011..6579494 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1175,12 +1175,6 @@ int udp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
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
 
@@ -1235,6 +1229,7 @@ try_again:
 		sin->sin_port = udp_hdr(skb)->source;
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 9dca4a8..07a7df6 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -457,9 +457,6 @@ static int rawv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	if (addr_len)
-		*addr_len=sizeof(*sin6);
-
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len);
 
@@ -499,6 +496,7 @@ static int rawv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 		sin6->sin6_scope_id = 0;
 		if (ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
 			sin6->sin6_scope_id = IP6CB(skb)->iif;
+		*addr_len = sizeof(*sin6);
 	}
 
 	sock_recv_ts_and_drops(msg, sk, skb);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index a006a21..a7364cd 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -348,9 +348,6 @@ int udpv6_recvmsg(struct kiocb *iocb, struct sock *sk,
 	int is_udp4;
 	bool slow;
 
-	if (addr_len)
-		*addr_len = sizeof(struct sockaddr_in6);
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
index 61d8b75..2bc35bc 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -510,9 +510,6 @@ static int l2tp_ip_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *m
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		goto out;
@@ -535,6 +532,7 @@ static int l2tp_ip_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *m
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		sin->sin_port = 0;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
diff --git a/net/phonet/datagram.c b/net/phonet/datagram.c
index 12c30f3..38946b2 100644
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
-- 
1.8.3.2

