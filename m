Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbaIKMwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:52:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51588 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412AbaIKMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Doug Leith" <doug.leith@nuim.ie>,
        "David Laight" <David.Laight@ACULAB.COM>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        "Christoph Paasch" <christoph.paasch@uclouvain.be>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.356389477@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 102/131] tcp: Fix integer-overflow in TCP vegas
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

[ Upstream commit 1f74e613ded11517db90b2bd57e9464d9e0fb161 ]

In vegas we do a multiplication of the cwnd and the rtt. This
may overflow and thus their result is stored in a u64. However, we first
need to cast the cwnd so that actually 64-bit arithmetic is done.

Then, we need to do do_div to allow this to be used on 32-bit arches.

Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Doug Leith <doug.leith@nuim.ie>
Fixes: 8d3a564da34e (tcp: tcp_vegas cong avoid fix)
Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_vegas.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_vegas.c b/net/ipv4/tcp_vegas.c
index 80fa2bf..c042e52 100644
--- a/net/ipv4/tcp_vegas.c
+++ b/net/ipv4/tcp_vegas.c
@@ -218,7 +218,8 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 in_flight)
 			 * This is:
 			 *     (actual rate in segments) * baseRTT
 			 */
-			target_cwnd = tp->snd_cwnd * vegas->baseRTT / rtt;
+			target_cwnd = (u64)tp->snd_cwnd * vegas->baseRTT;
+			do_div(target_cwnd, rtt);
 
 			/* Calculate the difference between the window we had,
 			 * and the window we would like to have. This quantity

