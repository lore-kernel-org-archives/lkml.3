Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3GBLSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:18:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36190 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab3GBLIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nandita Dukkipati <nanditad@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 12/50] tcp: bug fix in proportional rate reduction.
Date: Tue,  2 Jul 2013 12:07:00 +0100
Message-Id: <1372763258-20664-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nandita Dukkipati <nanditad@google.com>

commit 35f079ebbc860dcd1cca70890c9c8d59c1145525 upstream.

This patch is a fix for a bug triggering newly_acked_sacked < 0
in tcp_ack(.).

The bug is triggered by sacked_out decreasing relative to prior_sacked,
but packets_out remaining the same as pior_packets. This is because the
snapshot of prior_packets is taken after tcp_sacktag_write_queue() while
prior_sacked is captured before tcp_sacktag_write_queue(). The problem
is: tcp_sacktag_write_queue (tcp_match_skb_to_sack() -> tcp_fragment)
adjusts the pcount for packets_out and sacked_out (MSS change or other
reason). As a result, this delta in pcount is reflected in
(prior_sacked - sacked_out) but not in (prior_packets - packets_out).

This patch does the following:
1) initializes prior_packets at the start of tcp_ack() so as to
capture the delta in packets_out created by tcp_fragment.
2) introduces a new "previous_packets_out" variable that snapshots
packets_out right before tcp_clean_rtx_queue, so pkts_acked can be
correctly computed as before.
3) Computes pkts_acked using previous_packets_out, and computes
newly_acked_sacked using prior_packets.

Signed-off-by: Nandita Dukkipati <nanditad@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/tcp_input.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e8139f8..3d5ffe0 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3108,8 +3108,8 @@ static void tcp_enter_recovery(struct sock *sk, bool ece_ack)
  * tcp_xmit_retransmit_queue().
  */
 static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked,
-				  int prior_sacked, bool is_dupack,
-				  int flag)
+				  int prior_sacked, int prior_packets,
+				  bool is_dupack, int flag)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -3175,7 +3175,8 @@ static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked,
 				tcp_add_reno_sack(sk);
 		} else
 			do_lost = tcp_try_undo_partial(sk, pkts_acked);
-		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
+		newly_acked_sacked = prior_packets - tp->packets_out +
+				     tp->sacked_out - prior_sacked;
 		break;
 	case TCP_CA_Loss:
 		if (flag & FLAG_DATA_ACKED)
@@ -3197,7 +3198,8 @@ static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked,
 			if (is_dupack)
 				tcp_add_reno_sack(sk);
 		}
-		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
+		newly_acked_sacked = prior_packets - tp->packets_out +
+				     tp->sacked_out - prior_sacked;
 
 		if (icsk->icsk_ca_state <= TCP_CA_Disorder)
 			tcp_try_undo_dsack(sk);
@@ -3816,9 +3818,10 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	bool is_dupack = false;
 	u32 prior_in_flight;
 	u32 prior_fackets;
-	int prior_packets;
+	int prior_packets = tp->packets_out;
 	int prior_sacked = tp->sacked_out;
 	int pkts_acked = 0;
+	int previous_packets_out = 0;
 	bool frto_cwnd = false;
 
 	/* If the ack is older than previous acks
@@ -3898,14 +3901,14 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	sk->sk_err_soft = 0;
 	icsk->icsk_probes_out = 0;
 	tp->rcv_tstamp = tcp_time_stamp;
-	prior_packets = tp->packets_out;
 	if (!prior_packets)
 		goto no_queue;
 
 	/* See if we can take anything off of the retransmit queue. */
+	previous_packets_out = tp->packets_out;
 	flag |= tcp_clean_rtx_queue(sk, prior_fackets, prior_snd_una);
 
-	pkts_acked = prior_packets - tp->packets_out;
+	pkts_acked = previous_packets_out - tp->packets_out;
 
 	if (tp->frto_counter)
 		frto_cwnd = tcp_process_frto(sk, flag);
@@ -3920,7 +3923,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 			tcp_cong_avoid(sk, ack, prior_in_flight);
 		is_dupack = !(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP));
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	} else {
 		if ((flag & FLAG_DATA_ACKED) && !frto_cwnd)
 			tcp_cong_avoid(sk, ack, prior_in_flight);
@@ -3935,7 +3938,7 @@ no_queue:
 	/* If data was DSACKed, see if we can undo a cwnd reduction. */
 	if (flag & FLAG_DSACKING_ACK)
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	/* If this ack opens up a zero window, clear backoff.  It was
 	 * being used to time the probes, and is probably far higher than
 	 * it needs to be for normal retransmission.
@@ -3955,7 +3958,7 @@ old_ack:
 	if (TCP_SKB_CB(skb)->sacked) {
 		flag |= tcp_sacktag_write_queue(sk, skb, prior_snd_una);
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	}
 
 	SOCK_DEBUG(sk, "Ack %u before %u:%u\n", ack, tp->snd_una, tp->snd_nxt);
-- 
1.8.1.2

