Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbaCEPKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:10:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbaCEO0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: John Ogness <john.ogness@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 073/131] tcp: tsq: fix nonagle handling
Date: Wed,  5 Mar 2014 14:23:17 +0000
Message-Id: <1394029455-23128-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

commit bf06200e732de613a1277984bf34d1a21c2de03d upstream.

Commit 46d3ceabd8d9 ("tcp: TCP Small Queues") introduced a possible
regression for applications using TCP_NODELAY.

If TCP session is throttled because of tsq, we should consult
tp->nonagle when TX completion is done and allow us to send additional
segment, especially if this segment is not a full MSS.
Otherwise this segment is sent after an RTO.

[edumazet] : Cooked the changelog, added another fix about testing
sk_wmem_alloc twice because TX completion can happen right before
setting TSQ_THROTTLED bit.

This problem is particularly visible with recent auto corking,
but might also be triggered with low tcp_limit_output_bytes
values or NIC drivers delaying TX completion by hundred of usec,
and very low rtt.

Thomas Glanzmann for example reported an iscsi regression, caused
by tcp auto corking making this bug quite visible.

Fixes: 46d3ceabd8d9 ("tcp: TCP Small Queues")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_output.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index d26060b..20d01ff 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -691,7 +691,8 @@ static void tcp_tsq_handler(struct sock *sk)
 	if ((1 << sk->sk_state) &
 	    (TCPF_ESTABLISHED | TCPF_FIN_WAIT1 | TCPF_CLOSING |
 	     TCPF_CLOSE_WAIT  | TCPF_LAST_ACK))
-		tcp_write_xmit(sk, tcp_current_mss(sk), 0, 0, GFP_ATOMIC);
+		tcp_write_xmit(sk, tcp_current_mss(sk), tcp_sk(sk)->nonagle,
+			       0, GFP_ATOMIC);
 }
 /*
  * One tasklest per cpu tries to send more skbs.
@@ -1880,7 +1881,15 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 
 		if (atomic_read(&sk->sk_wmem_alloc) > limit) {
 			set_bit(TSQ_THROTTLED, &tp->tsq_flags);
-			break;
+			/* It is possible TX completion already happened
+			 * before we set TSQ_THROTTLED, so we must
+			 * test again the condition.
+			 * We abuse smp_mb__after_clear_bit() because
+			 * there is no smp_mb__after_set_bit() yet
+			 */
+			smp_mb__after_clear_bit();
+			if (atomic_read(&sk->sk_wmem_alloc) > limit)
+				break;
 		}
 
 		limit = mss_now;
-- 
1.9.0

