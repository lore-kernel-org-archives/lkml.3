Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbaELBz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:55:59 -0400
Received: from 1wt.eu ([62.212.114.60]:34694 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbaELBnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:13 -0400
Message-Id: <20140512003203.876294671@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 078/143] ipv4: fix possible seqlock deadlock
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c9e9042994d37cbc1ee538c500e9da1bb9d1bcdf ]

ip4_datagram_connect() being called from process context,
it should use IP_INC_STATS() instead of IP_INC_STATS_BH()
otherwise we can deadlock on 32bit arches, or get corruptions of
SNMP counters.

Fixes: 584bdf8cbdf6 ("[IPV4]: Fix "ipOutNoRoutes" counter error for TCP and UDP")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/datagram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 5e6c5a0..30aeb26 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -52,7 +52,7 @@ int ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 			       inet->sport, usin->sin_port, sk, 1);
 	if (err) {
 		if (err == -ENETUNREACH)
-			IP_INC_STATS_BH(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
+			IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
 		return err;
 	}
 
-- 
1.7.12.2.21.g234cd45.dirty



