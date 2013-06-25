Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3FYSqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:46:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab3FYSgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:36:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nandita Dukkipati <nanditad@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 12/27] tcp: bug fix in proportional rate reduction.
Date: Tue, 25 Jun 2013 11:35:31 -0700
Message-Id: <20130625183519.100155425@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183517.651770593@linuxfoundation.org>
References: <20130625183517.651770593@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3038,8 +3038,8 @@ static void tcp_update_cwnd_in_recovery(
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
@@ -3105,7 +3105,8 @@ static void tcp_fastretrans_alert(struct
 				tcp_add_reno_sack(sk);
 		} else
 			do_lost = tcp_try_undo_partial(sk, pkts_acked);
-		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
+		newly_acked_sacked = prior_packets - tp->packets_out +
+				     tp->sacked_out - prior_sacked;
 		break;
 	case TCP_CA_Loss:
 		if (flag & FLAG_DATA_ACKED)
@@ -3127,7 +3128,8 @@ static void tcp_fastretrans_alert(struct
 			if (is_dupack)
 				tcp_add_reno_sack(sk);
 		}
-		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
+		newly_acked_sacked = prior_packets - tp->packets_out +
+				     tp->sacked_out - prior_sacked;
 
 		if (icsk->icsk_ca_state <= TCP_CA_Disorder)
 			tcp_try_undo_dsack(sk);
@@ -3740,9 +3742,10 @@ static int tcp_ack(struct sock *sk, cons
 	bool is_dupack = false;
 	u32 prior_in_flight;
 	u32 prior_fackets;
-	int prior_packets;
+	int prior_packets = tp->packets_out;
 	int prior_sacked = tp->sacked_out;
 	int pkts_acked = 0;
+	int previous_packets_out = 0;
 	int frto_cwnd = 0;
 
 	/* If the ack is older than previous acks
@@ -3819,14 +3822,14 @@ static int tcp_ack(struct sock *sk, cons
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
@@ -3841,7 +3844,7 @@ static int tcp_ack(struct sock *sk, cons
 			tcp_cong_avoid(sk, ack, prior_in_flight);
 		is_dupack = !(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP));
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	} else {
 		if ((flag & FLAG_DATA_ACKED) && !frto_cwnd)
 			tcp_cong_avoid(sk, ack, prior_in_flight);
@@ -3856,7 +3859,7 @@ no_queue:
 	/* If data was DSACKed, see if we can undo a cwnd reduction. */
 	if (flag & FLAG_DSACKING_ACK)
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	/* If this ack opens up a zero window, clear backoff.  It was
 	 * being used to time the probes, and is probably far higher than
 	 * it needs to be for normal retransmission.
@@ -3876,7 +3879,7 @@ old_ack:
 	if (TCP_SKB_CB(skb)->sacked) {
 		flag |= tcp_sacktag_write_queue(sk, skb, prior_snd_una);
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	}
 
 	SOCK_DEBUG(sk, "Ack %u before %u:%u\n", ack, tp->snd_una, tp->snd_nxt);


