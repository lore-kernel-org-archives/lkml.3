Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3CRVJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:09:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab3CRVIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:08:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 40/48] tcp: fix double-counted receiver RTT when leaving receiver fast path
Date: Mon, 18 Mar 2013 14:08:48 -0700
Message-Id: <20130318210813.079854106@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit aab2b4bf224ef8358d262f95b568b8ad0cecf0a0 ]

We should not update ts_recent and call tcp_rcv_rtt_measure_ts() both
before and after going to step5. That wastes CPU and double-counts the
receiver-side RTT sample.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5519,6 +5519,9 @@ int tcp_rcv_established(struct sock *sk,
 				if (tcp_checksum_complete_user(sk, skb))
 					goto csum_error;
 
+				if ((int)skb->truesize > sk->sk_forward_alloc)
+					goto step5;
+
 				/* Predicted packet is in window by definition.
 				 * seq == rcv_nxt and rcv_wup <= rcv_nxt.
 				 * Hence, check seq<=rcv_wup reduces to:
@@ -5530,9 +5533,6 @@ int tcp_rcv_established(struct sock *sk,
 
 				tcp_rcv_rtt_measure_ts(sk, skb);
 
-				if ((int)skb->truesize > sk->sk_forward_alloc)
-					goto step5;
-
 				NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPHPHITS);
 
 				/* Bulk data transfer: receiver */


