Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaHRJgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:36:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43157 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaHRJgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Paasch <christoph.paasch@uclouvain.be>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 132/137] tcp: Fix integer-overflows in TCP veno
Date: Mon, 18 Aug 2014 10:33:13 +0100
Message-Id: <1408354398-10226-133-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Paasch <christoph.paasch@uclouvain.be>

commit 45a07695bc64b3ab5d6d2215f9677e5b8c05a7d0 upstream.

In veno we do a multiplication of the cwnd and the rtt. This
may overflow and thus their result is stored in a u64. However, we first
need to cast the cwnd so that actually 64-bit arithmetic is done.

A first attempt at fixing 76f1017757aa0 ([TCP]: TCP Veno congestion
control) was made by 159131149c2 (tcp: Overflow bug in Vegas), but it
failed to add the required cast in tcp_veno_cong_avoid().

Fixes: 76f1017757aa0 ([TCP]: TCP Veno congestion control)
Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_veno.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_veno.c b/net/ipv4/tcp_veno.c
index ac43cd747bce..b4d1858be550 100644
--- a/net/ipv4/tcp_veno.c
+++ b/net/ipv4/tcp_veno.c
@@ -144,7 +144,7 @@ static void tcp_veno_cong_avoid(struct sock *sk, u32 ack, u32 in_flight)
 
 		rtt = veno->minrtt;
 
-		target_cwnd = (tp->snd_cwnd * veno->basertt);
+		target_cwnd = (u64)tp->snd_cwnd * veno->basertt;
 		target_cwnd <<= V_PARAM_SHIFT;
 		do_div(target_cwnd, rtt);
 
-- 
1.9.1

