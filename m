Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3CYBPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:15:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33771 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755299Ab3CYBPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:02 -0400
Message-Id: <20130325010525.128216511@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:32 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 008/104] tcp: fix double-counted receiver RTT when leaving  receiver fast path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit aab2b4bf224ef8358d262f95b568b8ad0cecf0a0 ]

We should not update ts_recent and call tcp_rcv_rtt_measure_ts() both
before and after going to step5. That wastes CPU and double-counts the
receiver-side RTT sample.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_input.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5494,6 +5494,9 @@ int tcp_rcv_established(struct sock *sk,
 				if (tcp_checksum_complete_user(sk, skb))
 					goto csum_error;
 
+				if ((int)skb->truesize > sk->sk_forward_alloc)
+					goto step5;
+
 				/* Predicted packet is in window by definition.
 				 * seq == rcv_nxt and rcv_wup <= rcv_nxt.
 				 * Hence, check seq<=rcv_wup reduces to:
@@ -5505,9 +5508,6 @@ int tcp_rcv_established(struct sock *sk,
 
 				tcp_rcv_rtt_measure_ts(sk, skb);
 
-				if ((int)skb->truesize > sk->sk_forward_alloc)
-					goto step5;
-
 				NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPHPHITS);
 
 				/* Bulk data transfer: receiver */


