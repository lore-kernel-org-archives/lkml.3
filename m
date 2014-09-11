Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaIKNPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:15:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51514 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755378AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Christoph Paasch" <christoph.paasch@uclouvain.be>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.666983400@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 101/131] tcp: Fix integer-overflows in TCP veno
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_veno.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_veno.c b/net/ipv4/tcp_veno.c
index ac43cd7..b4d1858 100644
--- a/net/ipv4/tcp_veno.c
+++ b/net/ipv4/tcp_veno.c
@@ -144,7 +144,7 @@ static void tcp_veno_cong_avoid(struct sock *sk, u32 ack, u32 in_flight)
 
 		rtt = veno->minrtt;
 
-		target_cwnd = (tp->snd_cwnd * veno->basertt);
+		target_cwnd = (u64)tp->snd_cwnd * veno->basertt;
 		target_cwnd <<= V_PARAM_SHIFT;
 		do_div(target_cwnd, rtt);
 

