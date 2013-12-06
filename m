Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab3LFWjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:39:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758985Ab3LFVwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        mpb <mpb.mail@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 28/83] inet: prevent leakage of uninitialized memory to user in recv syscalls
Date: Fri,  6 Dec 2013 13:51:18 -0800
Message-Id: <20131206214642.685736062@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/dgram.c |    3 +--
 net/ipv4/ping.c        |   19 +++++++------------
 net/ipv4/raw.c         |    4 +---
 net/ipv4/udp.c         |    7 +------
 net/ipv6/raw.c         |    4 +---
 net/ipv6/udp.c         |    5 +----
 net/l2tp/l2tp_ip.c     |    4 +---
 net/phonet/datagram.c  |    9 ++++-----
 8 files changed, 17 insertions(+), 38 deletions(-)

--- a/net/ieee802154/dgram.c
+++ b/net/ieee802154/dgram.c
@@ -315,9 +315,8 @@ static int dgram_recvmsg(struct kiocb *i
 	if (saddr) {
 		saddr->family = AF_IEEE802154;
 		saddr->addr = mac_cb(skb)->sa;
-	}
-	if (addr_len)
 		*addr_len = sizeof(*saddr);
+	}
 
 	if (flags & MSG_TRUNC)
 		copied = skb->len;
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -827,8 +827,6 @@ int ping_recvmsg(struct kiocb *iocb, str
 {
 	struct inet_sock *isk = inet_sk(sk);
 	int family = sk->sk_family;
-	struct sockaddr_in *sin;
-	struct sockaddr_in6 *sin6;
 	struct sk_buff *skb;
 	int copied, err;
 
@@ -838,13 +836,6 @@ int ping_recvmsg(struct kiocb *iocb, str
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len) {
-		if (family == AF_INET)
-			*addr_len = sizeof(*sin);
-		else if (family == AF_INET6 && addr_len)
-			*addr_len = sizeof(*sin6);
-	}
-
 	if (flags & MSG_ERRQUEUE) {
 		if (family == AF_INET) {
 			return ip_recv_error(sk, msg, len);
@@ -874,11 +865,13 @@ int ping_recvmsg(struct kiocb *iocb, str
 
 	/* Copy the address and add cmsg data. */
 	if (family == AF_INET) {
-		sin = (struct sockaddr_in *) msg->msg_name;
+		struct sockaddr_in *sin = (struct sockaddr_in *)msg->msg_name;
+
 		sin->sin_family = AF_INET;
 		sin->sin_port = 0 /* skb->h.uh->source */;
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 
 		if (isk->cmsg_flags)
 			ip_cmsg_recv(msg, skb);
@@ -887,17 +880,19 @@ int ping_recvmsg(struct kiocb *iocb, str
 	} else if (family == AF_INET6) {
 		struct ipv6_pinfo *np = inet6_sk(sk);
 		struct ipv6hdr *ip6 = ipv6_hdr(skb);
-		sin6 = (struct sockaddr_in6 *) msg->msg_name;
+		struct sockaddr_in6 *sin6 =
+			(struct sockaddr_in6 *)msg->msg_name;
+
 		sin6->sin6_family = AF_INET6;
 		sin6->sin6_port = 0;
 		sin6->sin6_addr = ip6->saddr;
-
 		sin6->sin6_flowinfo = 0;
 		if (np->sndflow)
 			sin6->sin6_flowinfo = ip6_flowinfo(ip6);
 
 		sin6->sin6_scope_id = ipv6_iface_scope_id(&sin6->sin6_addr,
 							  IP6CB(skb)->iif);
+		*addr_len = sizeof(*sin6);
 
 		if (inet6_sk(sk)->rxopt.all)
 			pingv6_ops.ip6_datagram_recv_ctl(sk, msg, skb);
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -694,9 +694,6 @@ static int raw_recvmsg(struct kiocb *ioc
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	if (flags & MSG_ERRQUEUE) {
 		err = ip_recv_error(sk, msg, len);
 		goto out;
@@ -724,6 +721,7 @@ static int raw_recvmsg(struct kiocb *ioc
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		sin->sin_port = 0;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1209,12 +1209,6 @@ int udp_recvmsg(struct kiocb *iocb, stru
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
 
@@ -1276,6 +1270,7 @@ try_again:
 		sin->sin_port = udp_hdr(skb)->source;
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -466,9 +466,6 @@ static int rawv6_recvmsg(struct kiocb *i
 	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	if (addr_len)
-		*addr_len=sizeof(*sin6);
-
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len);
 
@@ -507,6 +504,7 @@ static int rawv6_recvmsg(struct kiocb *i
 		sin6->sin6_flowinfo = 0;
 		sin6->sin6_scope_id = ipv6_iface_scope_id(&sin6->sin6_addr,
 							  IP6CB(skb)->iif);
+		*addr_len = sizeof(*sin6);
 	}
 
 	sock_recv_ts_and_drops(msg, sk, skb);
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -374,9 +374,6 @@ int udpv6_recvmsg(struct kiocb *iocb, st
 	int is_udp4;
 	bool slow;
 
-	if (addr_len)
-		*addr_len = sizeof(struct sockaddr_in6);
-
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len);
 
@@ -462,7 +459,7 @@ try_again:
 				ipv6_iface_scope_id(&sin6->sin6_addr,
 						    IP6CB(skb)->iif);
 		}
-
+		*addr_len = sizeof(*sin6);
 	}
 	if (is_udp4) {
 		if (inet->cmsg_flags)
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -518,9 +518,6 @@ static int l2tp_ip_recvmsg(struct kiocb
 	if (flags & MSG_OOB)
 		goto out;
 
-	if (addr_len)
-		*addr_len = sizeof(*sin);
-
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		goto out;
@@ -543,6 +540,7 @@ static int l2tp_ip_recvmsg(struct kiocb
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		sin->sin_port = 0;
 		memset(&sin->sin_zero, 0, sizeof(sin->sin_zero));
+		*addr_len = sizeof(*sin);
 	}
 	if (inet->cmsg_flags)
 		ip_cmsg_recv(msg, skb);
--- a/net/phonet/datagram.c
+++ b/net/phonet/datagram.c
@@ -139,9 +139,6 @@ static int pn_recvmsg(struct kiocb *iocb
 			MSG_CMSG_COMPAT))
 		goto out_nofree;
 
-	if (addr_len)
-		*addr_len = sizeof(sa);
-
 	skb = skb_recv_datagram(sk, flags, noblock, &rval);
 	if (skb == NULL)
 		goto out_nofree;
@@ -162,8 +159,10 @@ static int pn_recvmsg(struct kiocb *iocb
 
 	rval = (flags & MSG_TRUNC) ? skb->len : copylen;
 
-	if (msg->msg_name != NULL)
-		memcpy(msg->msg_name, &sa, sizeof(struct sockaddr_pn));
+	if (msg->msg_name != NULL) {
+		memcpy(msg->msg_name, &sa, sizeof(sa));
+		*addr_len = sizeof(sa);
+	}
 
 out:
 	skb_free_datagram(sk, skb);


