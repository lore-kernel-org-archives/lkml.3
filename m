Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab3APQJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:09:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36815 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749Ab3APQJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:09:43 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Jerry Chu <hkchu@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 190/222] tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation
Date: Wed, 16 Jan 2013 13:56:30 -0200
Message-Id: <1358351822-7675-191-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 354e4aa391ed50a4d827ff6fc11e0667d0859b25 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/tcp_input.c |   43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0b6e6cd..19c430c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3763,6 +3763,24 @@ static bool tcp_process_frto(struct sock *sk, int flag)
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
@@ -3782,8 +3800,14 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
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
@@ -5431,23 +5455,6 @@ out:
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
1.7.9.5

