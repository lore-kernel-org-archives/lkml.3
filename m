Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969Ab3CZSEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:04:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3CZRgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:02 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=pZQ0TaBb_PIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=wNlHInFWIKoA:10 a=1XWaLZrsAAAA:8 a=WbcJuUcRAAAA:8 a=J1Y8HTJGAAAA:8 a=oCcaPWc0AAAA:8 a=kWDgOHFhbxVf0gkMJRgA:9 a=UTB_XpHje0EA:10 a=yi5kreJwjdsA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173600.827499824@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Nandita Dukkipati <nanditad@google.com>,
        "H.K. Jerry Chu" <hkchu@google.com>,
        Romain Francoise <romain@orebokech.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 06/86] tcp: tcp_replace_ts_recent() should not be called from
 tcp_validate_incoming()
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0006-tcp-tcp_replace_ts_recent-should-not-be-called-from-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 net/ipv4/tcp_input.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c92c4da..7ccf80f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5340,11 +5340,6 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		goto discard;
 	}
 
-	/* ts_recent update must be made after we are sure that the packet
-	 * is in window.
-	 */
-	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
-
 	/* step 3: check security and precedence [ignored] */
 
 	/* step 4: Check for a SYN
@@ -5579,6 +5574,11 @@ step5:
 	if (th->ack && tcp_ack(sk, skb, FLAG_SLOWPATH) < 0)
 		goto discard;
 
+	/* ts_recent update must be made after we are sure that the packet
+	 * is in window.
+	 */
+	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	tcp_rcv_rtt_measure_ts(sk, skb);
 
 	/* Process urgent data. */
@@ -6106,6 +6106,11 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
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
1.7.10.4


