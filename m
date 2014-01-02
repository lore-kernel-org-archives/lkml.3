Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaABRHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:07:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40296 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaABRHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:07:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 35/91] inet: fix possible seqlock deadlocks
Date: Thu,  2 Jan 2014 09:04:10 -0800
Message-Id: <1388682306-30859-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ping.c     | 2 +-
 net/ipv4/tcp_ipv4.c | 2 +-
 net/ipv4/udp.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index eeaf513..3d8ddd9 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -571,7 +571,7 @@ static int ping_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 		err = PTR_ERR(rt);
 		rt = NULL;
 		if (err == -ENETUNREACH)
-			IP_INC_STATS_BH(net, IPSTATS_MIB_OUTNOROUTES);
+			IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
 		goto out;
 	}
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 47b459a..94b273c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -176,7 +176,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	if (IS_ERR(rt)) {
 		err = PTR_ERR(rt);
 		if (err == -ENETUNREACH)
-			IP_INC_STATS_BH(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
+			IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
 		return err;
 	}
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9de5641..f982418 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -946,7 +946,7 @@ int udp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 			err = PTR_ERR(rt);
 			rt = NULL;
 			if (err == -ENETUNREACH)
-				IP_INC_STATS_BH(net, IPSTATS_MIB_OUTNOROUTES);
+				IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
 			goto out;
 		}
 
-- 
1.8.3.2

