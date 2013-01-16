Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab3APQJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:09:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36810 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab3APQJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:09:40 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        "H.K. Jerry Chu" <hkchu@google.com>,
        Romain Francoise <romain@orebokech.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 189/222] tcp: tcp_replace_ts_recent() should not be called from tcp_validate_incoming()
Date: Wed, 16 Jan 2013 13:56:29 -0200
Message-Id: <1358351822-7675-190-git-send-email-herton.krzesinski@canonical.com>
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

commit bd090dfc634ddd711a5fbd0cadc6e0ab4977bcaf upstream.

We added support for RFC 5961 in latest kernels but TCP fails
to perform exhaustive check of ACK sequence.

We can update our view of peer tsval from a frame that is
later discarded by tcp_ack()

This makes timestamps enabled sessions vulnerable to injection of
a high tsval : peers start an ACK storm, since the victim
sends a dupack each time it receives an ACK from the other peer.

As tcp_validate_incoming() is called before tcp_ack(), we should
not peform tcp_replace_ts_recent() from it, and let callers do it
at the right time.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Nandita Dukkipati <nanditad@google.com>
Cc: H.K. Jerry Chu <hkchu@google.com>
Cc: Romain Francoise <romain@orebokech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/tcp_input.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index afb436d..0b6e6cd 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5500,11 +5500,6 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		goto discard;
 	}
 
-	/* ts_recent update must be made after we are sure that the packet
-	 * is in window.
-	 */
-	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
-
 	/* step 3: check security and precedence [ignored] */
 
 	/* step 4: Check for a SYN
@@ -5737,6 +5732,11 @@ step5:
 	if (th->ack && tcp_ack(sk, skb, FLAG_SLOWPATH) < 0)
 		goto discard;
 
+	/* ts_recent update must be made after we are sure that the packet
+	 * is in window.
+	 */
+	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	tcp_rcv_rtt_measure_ts(sk, skb);
 
 	/* Process urgent data. */
@@ -6215,6 +6215,11 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	} else
 		goto discard;
 
+	/* ts_recent update must be made after we are sure that the packet
+	 * is in window.
+	 */
+	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	/* step 6: check the URG bit */
 	tcp_urg(sk, skb, th);
 
-- 
1.7.9.5

