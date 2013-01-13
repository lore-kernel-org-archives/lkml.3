Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3AMRv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:51:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35040 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755458Ab3AMRpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:38 -0500
Message-Id: <20130113174304.756429461@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:38 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        "H.K. Jerry Chu" <hkchu@google.com>,
        Romain Francoise <romain@orebokech.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 43/49] tcp: tcp_replace_ts_recent() should not be called from  tcp_validate_incoming()
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

[ Upstream commit bd090dfc634ddd711a5fbd0cadc6e0ab4977bcaf ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index de434bc..b75cb85 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5312,11 +5312,6 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		goto discard;
 	}
 
-	/* ts_recent update must be made after we are sure that the packet
-	 * is in window.
-	 */
-	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
-
 	/* step 3: check security and precedence [ignored] */
 
 	/* step 4: Check for a SYN
@@ -5551,6 +5546,11 @@ step5:
 	if (th->ack && tcp_ack(sk, skb, FLAG_SLOWPATH) < 0)
 		goto discard;
 
+	/* ts_recent update must be made after we are sure that the packet
+	 * is in window.
+	 */
+	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	tcp_rcv_rtt_measure_ts(sk, skb);
 
 	/* Process urgent data. */
@@ -6021,6 +6021,11 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	} else
 		goto discard;
 
+	/* ts_recent update must be made after we are sure that the packet
+	 * is in window.
+	 */
+	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	/* step 6: check the URG bit */
 	tcp_urg(sk, skb, th);
 


