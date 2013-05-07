Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648Ab3EGEoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:44:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401Ab3EGEZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:38 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=CtmU7MkCHM8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=9oLtIKHviXEA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=bCBhyRctIgBHKXl2fmoA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035901.155274174@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yuchung Cheng <ycheng@google.com>, Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [121/126] tcp: call tcp_replace_ts_recent() from tcp_ack()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0121-tcp-call-tcp_replace_ts_recent-from-tcp_ack.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 12fb3dd9dc3c64ba7d64cec977cca9b5fb7b1d4e ]

commit bd090dfc634d (tcp: tcp_replace_ts_recent() should not be called
from tcp_validate_incoming()) introduced a TS ecr bug in slow path
processing.

1 A > B P. 1:10001(10000) ack 1 <nop,nop,TS val 1001 ecr 200>
2 B < A . 1:1(0) ack 1 win 257 <sack 9001:10001,TS val 300 ecr 1001>
3 A > B . 1:1001(1000) ack 1 win 227 <nop,nop,TS val 1002 ecr 200>
4 A > B . 1001:2001(1000) ack 1 win 227 <nop,nop,TS val 1002 ecr 200>

(ecr 200 should be ecr 300 in packets 3 & 4)

Problem is tcp_ack() can trigger send of new packets (retransmits),
reflecting the prior TSval, instead of the TSval contained in the
currently processed incoming packet.

Fix this by calling tcp_replace_ts_recent() from tcp_ack() after the
checks, but before the actions.

Reported-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/tcp_input.c |   65 +++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 33 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index db1b172..c30a56e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -116,6 +116,7 @@ int sysctl_tcp_early_retrans __read_mostly = 2;
 #define FLAG_DSACKING_ACK	0x800 /* SACK blocks contained D-SACK info */
 #define FLAG_NONHEAD_RETRANS_ACKED	0x1000 /* Non-head rexmitted data was ACKed */
 #define FLAG_SACK_RENEGING	0x2000 /* snd_una advanced to a sacked seq */
+#define FLAG_UPDATE_TS_RECENT	0x4000 /* tcp_replace_ts_recent() */
 
 #define FLAG_ACKED		(FLAG_DATA_ACKED|FLAG_SYN_ACKED)
 #define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED)
@@ -3599,6 +3600,27 @@ static void tcp_send_challenge_ack(struct sock *sk)
 	}
 }
 
+static void tcp_store_ts_recent(struct tcp_sock *tp)
+{
+	tp->rx_opt.ts_recent = tp->rx_opt.rcv_tsval;
+	tp->rx_opt.ts_recent_stamp = get_seconds();
+}
+
+static void tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
+{
+	if (tp->rx_opt.saw_tstamp && !after(seq, tp->rcv_wup)) {
+		/* PAWS bug workaround wrt. ACK frames, the PAWS discard
+		 * extra check below makes sure this can only happen
+		 * for pure ACK frames.  -DaveM
+		 *
+		 * Not only, also it occurs for expired timestamps.
+		 */
+
+		if (tcp_paws_check(&tp->rx_opt, 0))
+			tcp_store_ts_recent(tp);
+	}
+}
+
 /* This routine deals with incoming acks, but not outgoing ones. */
 static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 {
@@ -3651,6 +3673,12 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	prior_fackets = tp->fackets_out;
 	prior_in_flight = tcp_packets_in_flight(tp);
 
+	/* ts_recent update must be made after we are sure that the packet
+	 * is in window.
+	 */
+	if (flag & FLAG_UPDATE_TS_RECENT)
+		tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	if (!(flag & FLAG_SLOWPATH) && after(ack, prior_snd_una)) {
 		/* Window is constant, pure forward advance.
 		 * No more checks are required.
@@ -3967,27 +3995,6 @@ const u8 *tcp_parse_md5sig_option(const struct tcphdr *th)
 EXPORT_SYMBOL(tcp_parse_md5sig_option);
 #endif
 
-static inline void tcp_store_ts_recent(struct tcp_sock *tp)
-{
-	tp->rx_opt.ts_recent = tp->rx_opt.rcv_tsval;
-	tp->rx_opt.ts_recent_stamp = get_seconds();
-}
-
-static inline void tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
-{
-	if (tp->rx_opt.saw_tstamp && !after(seq, tp->rcv_wup)) {
-		/* PAWS bug workaround wrt. ACK frames, the PAWS discard
-		 * extra check below makes sure this can only happen
-		 * for pure ACK frames.  -DaveM
-		 *
-		 * Not only, also it occurs for expired timestamps.
-		 */
-
-		if (tcp_paws_check(&tp->rx_opt, 0))
-			tcp_store_ts_recent(tp);
-	}
-}
-
 /* Sorry, PAWS as specified is broken wrt. pure-ACKs -DaveM
  *
  * It is not fatal. If this ACK does _not_ change critical state (seqs, window)
@@ -5580,14 +5587,10 @@ slow_path:
 		return 0;
 
 step5:
-	if (th->ack && tcp_ack(sk, skb, FLAG_SLOWPATH) < 0)
+	if (th->ack &&
+	    tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT) < 0)
 		goto discard;
 
-	/* ts_recent update must be made after we are sure that the packet
-	 * is in window.
-	 */
-	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
-
 	tcp_rcv_rtt_measure_ts(sk, skb);
 
 	/* Process urgent data. */
@@ -6002,7 +6005,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 
 	/* step 5: check the ACK field */
 	if (th->ack) {
-		int acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH) > 0;
+		int acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH |
+						  FLAG_UPDATE_TS_RECENT) > 0;
 
 		switch (sk->sk_state) {
 		case TCP_SYN_RECV:
@@ -6114,11 +6118,6 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	} else
 		goto discard;
 
-	/* ts_recent update must be made after we are sure that the packet
-	 * is in window.
-	 */
-	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
-
 	/* step 6: check the URG bit */
 	tcp_urg(sk, skb, th);
 
-- 
1.7.10.4


