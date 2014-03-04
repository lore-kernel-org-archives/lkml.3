Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbaCDUbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:31:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbaCDUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John Ogness <john.ogness@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Glanzmann <thomas@glanzmann.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 27/97] tcp: tsq: fix nonagle handling
Date: Tue,  4 Mar 2014 12:03:40 -0800
Message-Id: <20140304200346.949639667@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit bf06200e732de613a1277984bf34d1a21c2de03d ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -686,7 +686,8 @@ static void tcp_tsq_handler(struct sock
 	if ((1 << sk->sk_state) &
 	    (TCPF_ESTABLISHED | TCPF_FIN_WAIT1 | TCPF_CLOSING |
 	     TCPF_CLOSE_WAIT  | TCPF_LAST_ACK))
-		tcp_write_xmit(sk, tcp_current_mss(sk), 0, 0, GFP_ATOMIC);
+		tcp_write_xmit(sk, tcp_current_mss(sk), tcp_sk(sk)->nonagle,
+			       0, GFP_ATOMIC);
 }
 /*
  * One tasklest per cpu tries to send more skbs.
@@ -1875,7 +1876,15 @@ static bool tcp_write_xmit(struct sock *
 
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


