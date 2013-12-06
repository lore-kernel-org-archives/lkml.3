Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab3LFWij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:38:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991Ab3LFVwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 29/83] ping: prevent NULL pointer dereference on write to msg_name
Date: Fri,  6 Dec 2013 13:51:19 -0800
Message-Id: <20131206214642.774749801@linuxfoundation.org>
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

[ Upstream commit cf970c002d270c36202bd5b9c2804d3097a52da0 ]

A plain read() on a socket does set msg->msg_name to NULL. So check for
NULL pointer first.

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ping.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -867,11 +867,13 @@ int ping_recvmsg(struct kiocb *iocb, str
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
@@ -883,16 +885,18 @@ int ping_recvmsg(struct kiocb *iocb, str
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


