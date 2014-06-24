Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaFXPzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:55:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaFXPzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:55:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sven Wegener <sven.wegener@stealer.net>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 07/61] ipv6: Fix regression caused by efe4208 in udp_v6_mcast_next()
Date: Tue, 24 Jun 2014 11:50:50 -0400
Message-Id: <20140624154953.101839922@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Wegener <sven.wegener@stealer.net>

[ Upstream commit 3bfdc59a6c24608ed23e903f670aaf5f58c7a6f3 ]

Commit efe4208 ("ipv6: make lookups simpler and faster") introduced a
regression in udp_v6_mcast_next(), resulting in multicast packets not
reaching the destination sockets under certain conditions.

The packet's IPv6 addresses are wrongly compared to the IPv6 addresses
from the function's socket argument, which indicates the starting point
for looping, instead of the loop variable. If the addresses from the
first socket do not match the packet's addresses, no socket in the list
will match.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/udp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -716,15 +716,15 @@ static struct sock *udp_v6_mcast_next(st
 				if (inet->inet_dport != rmt_port)
 					continue;
 			}
-			if (!ipv6_addr_any(&sk->sk_v6_daddr) &&
-			    !ipv6_addr_equal(&sk->sk_v6_daddr, rmt_addr))
+			if (!ipv6_addr_any(&s->sk_v6_daddr) &&
+			    !ipv6_addr_equal(&s->sk_v6_daddr, rmt_addr))
 				continue;
 
 			if (s->sk_bound_dev_if && s->sk_bound_dev_if != dif)
 				continue;
 
-			if (!ipv6_addr_any(&sk->sk_v6_rcv_saddr)) {
-				if (!ipv6_addr_equal(&sk->sk_v6_rcv_saddr, loc_addr))
+			if (!ipv6_addr_any(&s->sk_v6_rcv_saddr)) {
+				if (!ipv6_addr_equal(&s->sk_v6_rcv_saddr, loc_addr))
 					continue;
 			}
 			if (!inet6_mc_check(s, loc_addr, rmt_addr))


