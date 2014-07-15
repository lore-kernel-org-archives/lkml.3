Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998AbaGOW1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:27:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53904 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107AbaGOVbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:31:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sven Wegener <sven.wegener@stealer.net>,
        "David S. Miller" <davem@davemloft.net>,
        Tim Gardner <tim.gardner@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 003/198] ipv6: Fix regression caused by efe4208 in udp_v6_mcast_next()
Date: Tue, 15 Jul 2014 14:27:53 -0700
Message-Id: <1405459868-15089-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Wegener <sven.wegener@stealer.net>

commit 3bfdc59a6c24608ed23e903f670aaf5f58c7a6f3 upstream.

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
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/udp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 089c741..6028bc74 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -711,15 +711,15 @@ static struct sock *udp_v6_mcast_next(struct net *net, struct sock *sk,
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
-- 
1.9.1

