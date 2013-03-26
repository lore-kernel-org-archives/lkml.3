Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab3CZRm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:42:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3CZRg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:26 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9VNr2J4BuNkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=pBGalg-FbGAA:10 a=1XWaLZrsAAAA:8 a=PTBWqnBOAAAA:8 a=J1Y8HTJGAAAA:8 a=ayC55rCoAAAA:8 a=RvlEQHu-AAAA:8 a=3hRvB8WrXdXxB_3RvqwA:9 a=E6k37eg1NvgA:10 a=UTB_XpHje0EA:10 a=2va5FzKkd9YA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173611.835729997@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Christian Becker <c.becker@traviangames.com>, Willy Tarreau <w@1wt.eu>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 75/86] tcp: fix splice() and tcp collapsing interaction
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0075-tcp-fix-splice-and-tcp-collapsing-interaction.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit fdd384558afc89793bf35db6b5263e80ee92093d ]

Under unusual circumstances, TCP collapse can split a big GRO TCP packet
while its being used in a splice(socket->pipe) operation.

skb_splice_bits() releases the socket lock before calling
splice_to_pipe().

[ 1081.353685] WARNING: at net/ipv4/tcp.c:1330 tcp_cleanup_rbuf+0x4d/0xfc()
[ 1081.371956] Hardware name: System x3690 X5 -[7148Z68]-
[ 1081.391820] cleanup rbuf bug: copied AD3BCF1 seq AD370AF rcvnxt AD3CF13

To fix this problem, we must eat skbs in tcp_recv_skb().

Remove the inline keyword from tcp_recv_skb() definition since
it has three call sites.

Reported-by: Christian Becker <c.becker@traviangames.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8720b83..a07e91c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1454,12 +1454,12 @@ static void tcp_service_net_dma(struct sock *sk, bool wait)
 }
 #endif
 
-static inline struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
+static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
 {
 	struct sk_buff *skb;
 	u32 offset;
 
-	skb_queue_walk(&sk->sk_receive_queue, skb) {
+	while ((skb = skb_peek(&sk->sk_receive_queue)) != NULL) {
 		offset = seq - TCP_SKB_CB(skb)->seq;
 		if (tcp_hdr(skb)->syn)
 			offset--;
@@ -1467,6 +1467,11 @@ static inline struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
 			*off = offset;
 			return skb;
 		}
+		/* This looks weird, but this can happen if TCP collapsing
+		 * splitted a fat GRO packet, while we released socket lock
+		 * in skb_splice_bits()
+		 */
+		sk_eat_skb(sk, skb, false);
 	}
 	return NULL;
 }
@@ -1546,8 +1551,10 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 	tcp_rcv_space_adjust(sk);
 
 	/* Clean up data we have read: This will do ACK frames. */
-	if (copied > 0)
+	if (copied > 0) {
+		tcp_recv_skb(sk, seq, &offset);
 		tcp_cleanup_rbuf(sk, copied);
+	}
 	return copied;
 }
 EXPORT_SYMBOL(tcp_read_sock);
-- 
1.7.10.4


