Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3CZRg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:36:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3CZRgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:14 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Zk38eq-o2OgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Pe9ExezKr4UA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173607.818227027@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Neal Cardwell <ncardwell@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 49/86] tcp: fix double-counted receiver RTT when leaving receiver fast path
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0049-tcp-fix-double-counted-receiver-RTT-when-leaving-rec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit aab2b4bf224ef8358d262f95b568b8ad0cecf0a0 ]

We should not update ts_recent and call tcp_rcv_rtt_measure_ts() both
before and after going to step5. That wastes CPU and double-counts the
receiver-side RTT sample.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp_input.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8d02e34..41073d2 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5525,6 +5525,9 @@ int tcp_rcv_established(struct sock *sk, struct sk_buff *skb,
 				if (tcp_checksum_complete_user(sk, skb))
 					goto csum_error;
 
+				if ((int)skb->truesize > sk->sk_forward_alloc)
+					goto step5;
+
 				/* Predicted packet is in window by definition.
 				 * seq == rcv_nxt and rcv_wup <= rcv_nxt.
 				 * Hence, check seq<=rcv_wup reduces to:
@@ -5536,9 +5539,6 @@ int tcp_rcv_established(struct sock *sk, struct sk_buff *skb,
 
 				tcp_rcv_rtt_measure_ts(sk, skb);
 
-				if ((int)skb->truesize > sk->sk_forward_alloc)
-					goto step5;
-
 				NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPHPHITS);
 
 				/* Bulk data transfer: receiver */
-- 
1.7.10.4


