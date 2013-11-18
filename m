Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3KRSlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:41:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab3KRSha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:37:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 08/19] tcp: fix SYNACK RTT estimation in Fast Open
Date: Mon, 18 Nov 2013 10:37:21 -0800
Message-Id: <20131118183646.440225229@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118183644.030738675@linuxfoundation.org>
References: <20131118183644.030738675@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit bc15afa39ecc16f01c3389d15d8f6015a427fe85 ]

tp->lsndtime may not always be the SYNACK timestamp if a passive
Fast Open socket sends data before handshake completes. And if the
remote acknowledges both the data and the SYNACK, the RTT sample
is already taken in tcp_ack(), so no need to call
tcp_update_ack_rtt() in tcp_synack_rtt_meas() aagain.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2871,14 +2871,19 @@ static inline bool tcp_ack_update_rtt(st
 }
 
 /* Compute time elapsed between (last) SYNACK and the ACK completing 3WHS. */
-static void tcp_synack_rtt_meas(struct sock *sk, struct request_sock *req)
+static void tcp_synack_rtt_meas(struct sock *sk, const u32 synack_stamp)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	s32 seq_rtt = -1;
 
-	if (tp->lsndtime && !tp->total_retrans)
-		seq_rtt = tcp_time_stamp - tp->lsndtime;
-	tcp_ack_update_rtt(sk, FLAG_SYN_ACKED, seq_rtt, -1);
+	if (synack_stamp && !tp->total_retrans)
+		seq_rtt = tcp_time_stamp - synack_stamp;
+
+	/* If the ACK acks both the SYNACK and the (Fast Open'd) data packets
+	 * sent in SYN_RECV, SYNACK RTT is the smooth RTT computed in tcp_ack()
+	 */
+	if (!tp->srtt)
+		tcp_ack_update_rtt(sk, FLAG_SYN_ACKED, seq_rtt, -1);
 }
 
 static void tcp_cong_avoid(struct sock *sk, u32 ack, u32 in_flight)
@@ -5587,6 +5592,7 @@ int tcp_rcv_state_process(struct sock *s
 	struct request_sock *req;
 	int queued = 0;
 	bool acceptable;
+	u32 synack_stamp;
 
 	tp->rx_opt.saw_tstamp = 0;
 
@@ -5669,9 +5675,11 @@ int tcp_rcv_state_process(struct sock *s
 		 * so release it.
 		 */
 		if (req) {
+			synack_stamp = tcp_rsk(req)->snt_synack;
 			tp->total_retrans = req->num_retrans;
 			reqsk_fastopen_remove(sk, req, false);
 		} else {
+			synack_stamp = tp->lsndtime;
 			/* Make sure socket is routed, for correct metrics. */
 			icsk->icsk_af_ops->rebuild_header(sk);
 			tcp_init_congestion_control(sk);
@@ -5694,7 +5702,7 @@ int tcp_rcv_state_process(struct sock *s
 		tp->snd_una = TCP_SKB_CB(skb)->ack_seq;
 		tp->snd_wnd = ntohs(th->window) << tp->rx_opt.snd_wscale;
 		tcp_init_wl(tp, TCP_SKB_CB(skb)->seq);
-		tcp_synack_rtt_meas(sk, req);
+		tcp_synack_rtt_meas(sk, synack_stamp);
 
 		if (tp->rx_opt.tstamp_ok)
 			tp->advmss -= TCPOLEN_TSTAMP_ALIGNED;


