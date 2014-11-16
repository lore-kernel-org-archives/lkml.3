Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaKPWBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:01:04 -0500
Received: from 1wt.eu ([62.212.114.60]:47937 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbaKPWA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:57 -0500
Message-Id: <20141116215329.617534929@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:51 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Christoph Paasch <christoph.paasch@uclouvain.be>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 23/48] tcp: Fix integer-overflows in TCP veno
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Paasch <christoph.paasch@uclouvain.be>

[ Upstream commit 45a07695bc64b3ab5d6d2215f9677e5b8c05a7d0 ]

In veno we do a multiplication of the cwnd and the rtt. This
may overflow and thus their result is stored in a u64. However, we first
need to cast the cwnd so that actually 64-bit arithmetic is done.

A first attempt at fixing 76f1017757aa0 ([TCP]: TCP Veno congestion
control) was made by 159131149c2 (tcp: Overflow bug in Vegas), but it
failed to add the required cast in tcp_veno_cong_avoid().

Fixes: 76f1017757aa0 ([TCP]: TCP Veno congestion control)
Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp_veno.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_veno.c b/net/ipv4/tcp_veno.c
index e9bbff7..8d395a3 100644
--- a/net/ipv4/tcp_veno.c
+++ b/net/ipv4/tcp_veno.c
@@ -144,7 +144,7 @@ static void tcp_veno_cong_avoid(struct sock *sk, u32 ack, u32 in_flight)
 
 		rtt = veno->minrtt;
 
-		target_cwnd = (tp->snd_cwnd * veno->basertt);
+		target_cwnd = (u64)tp->snd_cwnd * veno->basertt;
 		target_cwnd <<= V_PARAM_SHIFT;
 		do_div(target_cwnd, rtt);
 
-- 
1.7.12.2.21.g234cd45.dirty



