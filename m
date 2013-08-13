Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab3HMQKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:10:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18357 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630Ab3HMP62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:28 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=GjuKO2722MQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=OWnFCWaM3wgA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=N-YY0Xkx_qFBa8UGhSIA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155826.004475884@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nandita Dukkipati <nanditad@google.com>, Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [15/88] tcp: bug fix in proportional rate reduction.
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0015-tcp-bug-fix-in-proportional-rate-reduction.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nandita Dukkipati <nanditad@google.com>

[ Upstream commit 35f079ebbc860dcd1cca70890c9c8d59c1145525 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/tcp_input.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c30a56e..a5080e4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2924,8 +2924,8 @@ static void tcp_enter_recovery(struct sock *sk, bool ece_ack)
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
@@ -2991,7 +2991,8 @@ static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked,
 				tcp_add_reno_sack(sk);
 		} else
 			do_lost = tcp_try_undo_partial(sk, pkts_acked);
-		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
+		newly_acked_sacked = prior_packets - tp->packets_out +
+				     tp->sacked_out - prior_sacked;
 		break;
 	case TCP_CA_Loss:
 		if (flag & FLAG_DATA_ACKED)
@@ -3013,7 +3014,8 @@ static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked,
 			if (is_dupack)
 				tcp_add_reno_sack(sk);
 		}
-		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
+		newly_acked_sacked = prior_packets - tp->packets_out +
+				     tp->sacked_out - prior_sacked;
 
 		if (icsk->icsk_ca_state <= TCP_CA_Disorder)
 			tcp_try_undo_dsack(sk);
@@ -3632,10 +3634,11 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	bool is_dupack = false;
 	u32 prior_in_flight;
 	u32 prior_fackets;
-	int prior_packets;
+	int prior_packets = tp->packets_out;
 	int prior_sacked = tp->sacked_out;
 	int pkts_acked = 0;
 	bool frto_cwnd = false;
+	int previous_packets_out = 0;
 
 	/* If the ack is older than previous acks
 	 * then we can probably ignore it.
@@ -3714,14 +3717,14 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
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
@@ -3736,7 +3739,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 			tcp_cong_avoid(sk, ack, prior_in_flight);
 		is_dupack = !(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP));
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	} else {
 		if ((flag & FLAG_DATA_ACKED) && !frto_cwnd)
 			tcp_cong_avoid(sk, ack, prior_in_flight);
@@ -3753,7 +3756,7 @@ no_queue:
 	/* If data was DSACKed, see if we can undo a cwnd reduction. */
 	if (flag & FLAG_DSACKING_ACK)
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	/* If this ack opens up a zero window, clear backoff.  It was
 	 * being used to time the probes, and is probably far higher than
 	 * it needs to be for normal retransmission.
@@ -3773,7 +3776,7 @@ old_ack:
 	if (TCP_SKB_CB(skb)->sacked) {
 		flag |= tcp_sacktag_write_queue(sk, skb, prior_snd_una);
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	}
 
 	SOCK_DEBUG(sk, "Ack %u before %u:%u\n", ack, tp->snd_una, tp->snd_nxt);
-- 
1.7.10.4


