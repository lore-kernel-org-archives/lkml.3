Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab3CZRxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:53:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3CZRgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:17 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ip6ZtYGOA1oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1W66BcAPgHoA:10 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=tmtSDGaQAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jkObVMfX7fAA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173606.023255758@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tommi Rantala <tt.rantala@gmail.com>, Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 38/86] net: fix infinite loop in __skb_recv_datagram()
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0038-net-fix-infinite-loop-in-__skb_recv_datagram.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 77c1090f94d1b0b5186fb13a1b71b47b1343f87f ]

Tommi was fuzzing with trinity and reported the following problem :

commit 3f518bf745 (datagram: Add offset argument to __skb_recv_datagram)
missed that a raw socket receive queue can contain skbs with no payload.

We can loop in __skb_recv_datagram() with MSG_PEEK mode, because
wait_for_packet() is not prepared to skip these skbs.

[   83.541011] INFO: rcu_sched detected stalls on CPUs/tasks: {}
(detected by 0, t=26002 jiffies, g=27673, c=27672, q=75)
[   83.541011] INFO: Stall ended before state dump start
[  108.067010] BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child31:2847]
...
[  108.067010] Call Trace:
[  108.067010]  [<ffffffff818cc103>] __skb_recv_datagram+0x1a3/0x3b0
[  108.067010]  [<ffffffff818cc33d>] skb_recv_datagram+0x2d/0x30
[  108.067010]  [<ffffffff819ed43d>] rawv6_recvmsg+0xad/0x240
[  108.067010]  [<ffffffff818c4b04>] sock_common_recvmsg+0x34/0x50
[  108.067010]  [<ffffffff818bc8ec>] sock_recvmsg+0xbc/0xf0
[  108.067010]  [<ffffffff818bf31e>] sys_recvfrom+0xde/0x150
[  108.067010]  [<ffffffff81ca4329>] system_call_fastpath+0x16/0x1b

Reported-by: Tommi Rantala <tt.rantala@gmail.com>
Tested-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/datagram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 0337e2b..368f9c3 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -187,7 +187,7 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
 		skb_queue_walk(queue, skb) {
 			*peeked = skb->peeked;
 			if (flags & MSG_PEEK) {
-				if (*off >= skb->len) {
+				if (*off >= skb->len && skb->len) {
 					*off -= skb->len;
 					continue;
 				}
-- 
1.7.10.4


