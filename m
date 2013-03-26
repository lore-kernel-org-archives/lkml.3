Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab3CZSEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:04:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab3CZRgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:02 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=PgSsqTC2mTAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1oV6Tce3KUUA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=fTvmYcqeRReboQmCEF8A:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173600.973104236@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Jerry Chu <hkchu@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 07/86] tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0007-tcp-RFC-5961-5.2-Blind-Data-Injection-Attack-Mitigat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 354e4aa391ed50a4d827ff6fc11e0667d0859b25 ]

RFC 5961 5.2 [Blind Data Injection Attack].[Mitigation]

  All TCP stacks MAY implement the following mitigation.  TCP stacks
  that implement this mitigation MUST add an additional input check to
  any incoming segment.  The ACK value is considered acceptable only if
  it is in the range of ((SND.UNA - MAX.SND.WND) <= SEG.ACK <=
  SND.NXT).  All incoming segments whose ACK value doesn't satisfy the
  above condition MUST be discarded and an ACK sent back.

Move tcp_send_challenge_ack() before tcp_ack() to avoid a forward
declaration.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Jerry Chu <hkchu@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp_input.c |   43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7ccf80f..4b3f448 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3579,6 +3579,24 @@ static bool tcp_process_frto(struct sock *sk, int flag)
 	return false;
 }
 
+/* RFC 5961 7 [ACK Throttling] */
+static void tcp_send_challenge_ack(struct sock *sk)
+{
+	/* unprotected vars, we dont care of overwrites */
+	static u32 challenge_timestamp;
+	static unsigned int challenge_count;
+	u32 now = jiffies / HZ;
+
+	if (now != challenge_timestamp) {
+		challenge_timestamp = now;
+		challenge_count = 0;
+	}
+	if (++challenge_count <= sysctl_tcp_challenge_ack_limit) {
+		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPCHALLENGEACK);
+		tcp_send_ack(sk);
+	}
+}
+
 /* This routine deals with incoming acks, but not outgoing ones. */
 static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 {
@@ -3598,8 +3616,14 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	/* If the ack is older than previous acks
 	 * then we can probably ignore it.
 	 */
-	if (before(ack, prior_snd_una))
+	if (before(ack, prior_snd_una)) {
+		/* RFC 5961 5.2 [Blind Data Injection Attack].[Mitigation] */
+		if (before(ack, prior_snd_una - tp->max_window)) {
+			tcp_send_challenge_ack(sk);
+			return -1;
+		}
 		goto old_ack;
+	}
 
 	/* If the ack includes data we haven't sent yet, discard
 	 * this segment (RFC793 Section 3.9).
@@ -5271,23 +5295,6 @@ out:
 }
 #endif /* CONFIG_NET_DMA */
 
-static void tcp_send_challenge_ack(struct sock *sk)
-{
-	/* unprotected vars, we dont care of overwrites */
-	static u32 challenge_timestamp;
-	static unsigned int challenge_count;
-	u32 now = jiffies / HZ;
-
-	if (now != challenge_timestamp) {
-		challenge_timestamp = now;
-		challenge_count = 0;
-	}
-	if (++challenge_count <= sysctl_tcp_challenge_ack_limit) {
-		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPCHALLENGEACK);
-		tcp_send_ack(sk);
-	}
-}
-
 /* Does PAWS and seqno based validation of an incoming segment, flags will
  * play significant role here.
  */
-- 
1.7.10.4


