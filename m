Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaELBmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:42:12 -0400
Received: from 1wt.eu ([62.212.114.60]:34464 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbaELBmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:07 -0400
Message-Id: <20140512003205.963248202@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephen Hemminger <shemminger@vyatta.com>, Liu Yu <allanyuliu@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 127/143] tcp_cubic: fix the range of delayed_ack
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Yu <allanyuliu@tencent.com>

commit b9f47a3aaeab (tcp_cubic: limit delayed_ack ratio to prevent
divide error) try to prevent divide error, but there is still a little
chance that delayed_ack can reach zero. In case the param cnt get
negative value, then ratio+cnt would overflow and may happen to be zero.
As a result, min(ratio, ACK_RATIO_LIMIT) will calculate to be zero.

In some old kernels, such as 2.6.32, there is a bug that would
pass negative param, which then ultimately leads to this divide error.

commit 5b35e1e6e9c (tcp: fix tcp_trim_head() to adjust segment count
with skb MSS) fixed the negative param issue. However,
it's safe that we fix the range of delayed_ack as well,
to make sure we do not hit a divide by zero.

CC: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Liu Yu <allanyuliu@tencent.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit 0cda345d1b2201dd15591b163e3c92bad5191745)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp_cubic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 1b6b8c2..db41113 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -385,7 +385,7 @@ static void bictcp_acked(struct sock *sk, u32 cnt, s32 rtt_us)
 		ratio -= ca->delayed_ack >> ACK_RATIO_SHIFT;
 		ratio += cnt;
 
-		ca->delayed_ack = min(ratio, ACK_RATIO_LIMIT);
+		ca->delayed_ack = clamp(ratio, 1U, ACK_RATIO_LIMIT);
 	}
 
 	/* Some calls are for duplicates without timetamps */
-- 
1.7.12.2.21.g234cd45.dirty



