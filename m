Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3LSL4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:56:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44601 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab3LSL4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 044/208] ping: prevent NULL pointer dereference on write to msg_name
Date: Thu, 19 Dec 2013 11:52:22 +0000
Message-Id: <1387454106-19326-45-git-send-email-luis.henriques@canonical.com>
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

commit cf970c002d270c36202bd5b9c2804d3097a52da0 upstream.

A plain read() on a socket does set msg->msg_name to NULL. So check for
NULL pointer first.

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ping.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index d7886b2..d243eef 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -868,11 +868,13 @@ int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	if (family == AF_INET) {
 		struct sockaddr_in *sin = (struct sockaddr_in *)msg->msg_name;
 
-		sin->sin_family = AF_INET;
-		sin->sin_port = 0 /* skb->h.uh->source */;
-		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
-		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
-		*addr_len = sizeof(*sin);
+		if (sin) {
+			sin->sin_family = AF_INET;
+			sin->sin_port = 0 /* skb->h.uh->source */;
+			sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
+			memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
+			*addr_len = sizeof(*sin);
+		}
 
 		if (isk->cmsg_flags)
 			ip_cmsg_recv(msg, skb);
@@ -884,16 +886,18 @@ int ping_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		struct sockaddr_in6 *sin6 =
 			(struct sockaddr_in6 *)msg->msg_name;
 
-		sin6->sin6_family = AF_INET6;
-		sin6->sin6_port = 0;
-		sin6->sin6_addr = ip6->saddr;
-		sin6->sin6_flowinfo = 0;
-		if (np->sndflow)
-			sin6->sin6_flowinfo = ip6_flowinfo(ip6);
-
-		sin6->sin6_scope_id = ipv6_iface_scope_id(&sin6->sin6_addr,
-							  IP6CB(skb)->iif);
-		*addr_len = sizeof(*sin6);
+		if (sin6) {
+			sin6->sin6_family = AF_INET6;
+			sin6->sin6_port = 0;
+			sin6->sin6_addr = ip6->saddr;
+			sin6->sin6_flowinfo = 0;
+			if (np->sndflow)
+				sin6->sin6_flowinfo = ip6_flowinfo(ip6);
+			sin6->sin6_scope_id =
+				ipv6_iface_scope_id(&sin6->sin6_addr,
+						    IP6CB(skb)->iif);
+			*addr_len = sizeof(*sin6);
+		}
 
 		if (inet6_sk(sk)->rxopt.all)
 			pingv6_ops.ip6_datagram_recv_ctl(sk, msg, skb);
-- 
1.8.3.2

