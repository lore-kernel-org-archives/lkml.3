Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbaHHWVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:21:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40470 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918AbaHHUqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yuchung Cheng <ycheng@google.com>, Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 248/259] tcp: fix false undo corner cases
Date: Fri,  8 Aug 2014 13:41:11 -0700
Message-Id: <1407530482-4483-249-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit 6e08d5e3c8236e7484229e46fdf92006e1dd4c49 ]

The undo code assumes that, upon entering loss recovery, TCP
1) always retransmit something
2) the retransmission never fails locally (e.g., qdisc drop)

so undo_marker is set in tcp_enter_recovery() and undo_retrans is
incremented only when tcp_retransmit_skb() is successful.

When the assumption is broken because TCP's cwnd is too small to
retransmit or the retransmit fails locally. The next (DUP)ACK
would incorrectly revert the cwnd and the congestion state in
tcp_try_undo_dsack() or tcp_may_undo(). Subsequent (DUP)ACKs
may enter the recovery state. The sender repeatedly enter and
(incorrectly) exit recovery states if the retransmits continue to
fail locally while receiving (DUP)ACKs.

The fix is to initialize undo_retrans to -1 and start counting on
the first retransmission. Always increment undo_retrans even if the
retransmissions fail locally because they couldn't cause DSACKs to
undo the cwnd reduction.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/tcp_input.c  | 8 ++++----
 net/ipv4/tcp_output.c | 6 ++++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a8827e7..53d60b4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1111,7 +1111,7 @@ static bool tcp_check_dsack(struct sock *sk, const struct sk_buff *ack_skb,
 	}
 
 	/* D-SACK for already forgotten data... Do dumb counting. */
-	if (dup_sack && tp->undo_marker && tp->undo_retrans &&
+	if (dup_sack && tp->undo_marker && tp->undo_retrans > 0 &&
 	    !after(end_seq_0, prior_snd_una) &&
 	    after(end_seq_0, tp->undo_marker))
 		tp->undo_retrans--;
@@ -1191,7 +1191,7 @@ static u8 tcp_sacktag_one(struct sock *sk,
 
 	/* Account D-SACK for retransmitted packet. */
 	if (dup_sack && (sacked & TCPCB_RETRANS)) {
-		if (tp->undo_marker && tp->undo_retrans &&
+		if (tp->undo_marker && tp->undo_retrans > 0 &&
 		    after(end_seq, tp->undo_marker))
 			tp->undo_retrans--;
 		if (sacked & TCPCB_SACKED_ACKED)
@@ -1892,7 +1892,7 @@ static void tcp_clear_retrans_partial(struct tcp_sock *tp)
 	tp->lost_out = 0;
 
 	tp->undo_marker = 0;
-	tp->undo_retrans = 0;
+	tp->undo_retrans = -1;
 }
 
 void tcp_clear_retrans(struct tcp_sock *tp)
@@ -2660,7 +2660,7 @@ static void tcp_enter_recovery(struct sock *sk, bool ece_ack)
 
 	tp->prior_ssthresh = 0;
 	tp->undo_marker = tp->snd_una;
-	tp->undo_retrans = tp->retrans_out;
+	tp->undo_retrans = tp->retrans_out ? : -1;
 
 	if (inet_csk(sk)->icsk_ca_state < TCP_CA_CWR) {
 		if (!ece_ack)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 99737ed..e3688a4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2422,8 +2422,6 @@ int tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb)
 		if (!tp->retrans_stamp)
 			tp->retrans_stamp = TCP_SKB_CB(skb)->when;
 
-		tp->undo_retrans += tcp_skb_pcount(skb);
-
 		/* snd_nxt is stored to detect loss of retransmitted segment,
 		 * see tcp_input.c tcp_sacktag_write_queue().
 		 */
@@ -2431,6 +2429,10 @@ int tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb)
 	} else {
 		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPRETRANSFAIL);
 	}
+
+	if (tp->undo_retrans < 0)
+		tp->undo_retrans = 0;
+	tp->undo_retrans += tcp_skb_pcount(skb);
 	return err;
 }
 
-- 
1.9.1

