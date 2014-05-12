Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaELBoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:44:24 -0400
Received: from 1wt.eu ([62.212.114.60]:34788 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaELBoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:44:20 -0400
Message-Id: <20140512003204.290982630@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 088/143] inet: fix possible seqlock deadlocks
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f1d8cba61c3c4b1eb88e507249c4cb8d635d9a76 ]

In commit c9e9042994d3 ("ipv4: fix possible seqlock deadlock") I left
another places where IP_INC_STATS_BH() were improperly used.

udp_sendmsg(), ping_v4_sendmsg() and tcp_v4_connect() are called from
process context, not from softirq context.

This was detected by lockdep seqlock support.

Reported-by: jongman heo <jongman.heo@samsung.com>
Fixes: 584bdf8cbdf6 ("[IPV4]: Fix "ipOutNoRoutes" counter error for TCP and UDP")
Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp_ipv4.c | 2 +-
 net/ipv4/udp.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d746d3b3..e60f0fd 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -174,7 +174,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 			       inet->sport, usin->sin_port, sk, 1);
 	if (tmp < 0) {
 		if (tmp == -ENETUNREACH)
-			IP_INC_STATS_BH(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
+			IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
 		return tmp;
 	}
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index a9aed7e..dba3c01 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -723,7 +723,7 @@ int udp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		err = ip_route_output_flow(net, &rt, &fl, sk, 1);
 		if (err) {
 			if (err == -ENETUNREACH)
-				IP_INC_STATS_BH(net, IPSTATS_MIB_OUTNOROUTES);
+				IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
 			goto out;
 		}
 
-- 
1.7.12.2.21.g234cd45.dirty



