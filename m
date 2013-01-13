Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3AMRx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:53:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35018 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755419Ab3AMRpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:35 -0500
Message-Id: <20130113174304.984362214@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:39 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Jerry Chu <hkchu@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 44/49] tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c | 43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b75cb85..aab8f08 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3703,6 +3703,24 @@ static int tcp_process_frto(struct sock *sk, int flag)
 	return 0;
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
@@ -3721,8 +3739,14 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
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
@@ -5243,23 +5267,6 @@ out:
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


