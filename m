Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaELCLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:11:18 -0400
Received: from 1wt.eu ([62.212.114.60]:34501 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbaELBmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:14 -0400
Message-Id: <20140512003203.384736824@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 066/143] tcp: cubic: fix bug in bictcp_acked()
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cd6b423afd3c08b27e1fed52db828ade0addbc6b ]

While investigating about strange increase of retransmit rates
on hosts ~24 days after boot, Van found hystart was disabled
if ca->epoch_start was 0, as following condition is true
when tcp_time_stamp high order bit is set.

(s32)(tcp_time_stamp - ca->epoch_start) < HZ

Quoting Van :

 At initialization & after every loss ca->epoch_start is set to zero so
 I believe that the above line will turn off hystart as soon as the 2^31
 bit is set in tcp_time_stamp & hystart will stay off for 24 days.
 I think we've observed that cubic's restart is too aggressive without
 hystart so this might account for the higher drop rate we observe.

Diagnosed-by: Van Jacobson <vanj@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp_cubic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 71d5f2f..0d41c26 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -388,7 +388,7 @@ static void bictcp_acked(struct sock *sk, u32 cnt, s32 rtt_us)
 		return;
 
 	/* Discard delay samples right after fast recovery */
-	if ((s32)(tcp_time_stamp - ca->epoch_start) < HZ)
+	if (ca->epoch_start && (s32)(tcp_time_stamp - ca->epoch_start) < HZ)
 		return;
 
 	delay = usecs_to_jiffies(rtt_us) << 3;
-- 
1.7.12.2.21.g234cd45.dirty



