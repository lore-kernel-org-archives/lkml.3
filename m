Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaG3Mcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:32:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36729 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915AbaG3MPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 47/94] tcp: fix false undo corner cases
Date: Wed, 30 Jul 2014 14:14:36 +0200
Message-Id: <06fc671aca0543a6002bde676885935878b3a095.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/tcp_input.c  | 8 ++++----
 net/ipv4/tcp_output.c | 6 ++++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3c6ee41ba419..95f67671f56e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1064,7 +1064,7 @@ static bool tcp_check_dsack(struct sock *sk, const struct sk_buff *ack_skb,
 	}
 
 	/* D-SACK for already forgotten data... Do dumb counting. */
-	if (dup_sack && tp->undo_marker && tp->undo_retrans &&
+	if (dup_sack && tp->undo_marker && tp->undo_retrans > 0 &&
 	    !after(end_seq_0, prior_snd_una) &&
 	    after(end_seq_0, tp->undo_marker))
 		tp->undo_retrans--;
@@ -1144,7 +1144,7 @@ static u8 tcp_sacktag_one(struct sock *sk,
 
 	/* Account D-SACK for retransmitted packet. */
 	if (dup_sack && (sacked & TCPCB_RETRANS)) {
-		if (tp->undo_marker && tp->undo_retrans &&
+		if (tp->undo_marker && tp->undo_retrans > 0 &&
 		    after(end_seq, tp->undo_marker))
 			tp->undo_retrans--;
 		if (sacked & TCPCB_SACKED_ACKED)
@@ -1845,7 +1845,7 @@ static void tcp_clear_retrans_partial(struct tcp_sock *tp)
 	tp->lost_out = 0;
 
 	tp->undo_marker = 0;
-	tp->undo_retrans = 0;
+	tp->undo_retrans = -1;
 }
 
 void tcp_clear_retrans(struct tcp_sock *tp)
@@ -2613,7 +2613,7 @@ static void tcp_enter_recovery(struct sock *sk, bool ece_ack)
 
 	tp->prior_ssthresh = 0;
 	tp->undo_marker = tp->snd_una;
-	tp->undo_retrans = tp->retrans_out;
+	tp->undo_retrans = tp->retrans_out ? : -1;
 
 	if (inet_csk(sk)->icsk_ca_state < TCP_CA_CWR) {
 		if (!ece_ack)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 826fc6fab576..0cce660cf7dd 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2437,8 +2437,6 @@ int tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb)
 		if (!tp->retrans_stamp)
 			tp->retrans_stamp = TCP_SKB_CB(skb)->when;
 
-		tp->undo_retrans += tcp_skb_pcount(skb);
-
 		/* snd_nxt is stored to detect loss of retransmitted segment,
 		 * see tcp_input.c tcp_sacktag_write_queue().
 		 */
@@ -2446,6 +2444,10 @@ int tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb)
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
2.0.1

