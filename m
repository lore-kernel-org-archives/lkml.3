Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3CZRgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:36:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31047 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3CZRg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:27 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jIQ_CA-J_SsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=kZ9kL9r8ZGcA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173611.515465127@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 73/86] tcp: dont abort splice() after small transfers
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0073-tcp-don-t-abort-splice-after-small-transfers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit e9feca83d1496afabd0cc174863646e6d7101d85 ]

TCP coalescing added a regression in splice(socket->pipe) performance,
for some workloads because of the way tcp_read_sock() is implemented.

The reason for this is the break when (offset + 1 != skb->len).

As we released the socket lock, this condition is possible if TCP stack
added a fragment to the skb, which can happen with TCP coalescing.

So let's go back to the beginning of the loop when this happens,
to give a chance to splice more frags per system call.

Doing so fixes the issue and makes GRO 10% faster than LRO
on CPU-bound splice() workloads instead of the opposite.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b0b39f6..5fe7a59 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1517,15 +1517,19 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 				copied += used;
 				offset += used;
 			}
-			/*
-			 * If recv_actor drops the lock (e.g. TCP splice
+			/* If recv_actor drops the lock (e.g. TCP splice
 			 * receive) the skb pointer might be invalid when
 			 * getting here: tcp_collapse might have deleted it
 			 * while aggregating skbs from the socket queue.
 			 */
-			skb = tcp_recv_skb(sk, seq-1, &offset);
-			if (!skb || (offset+1 != skb->len))
+			skb = tcp_recv_skb(sk, seq - 1, &offset);
+			if (!skb)
 				break;
+			/* TCP coalescing might have appended data to the skb.
+			 * Try to splice more frags
+			 */
+			if (offset + 1 != skb->len)
+				continue;
 		}
 		if (tcp_hdr(skb)->fin) {
 			sk_eat_skb(sk, skb, false);
-- 
1.7.10.4


