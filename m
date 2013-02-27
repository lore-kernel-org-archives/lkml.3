Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462Ab3B0AJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:09:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760341Ab3B0AJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tommi Rantala <tt.rantala@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 71/86] net: fix infinite loop in __skb_recv_datagram()
Date: Tue, 26 Feb 2013 16:08:19 -0800
Message-Id: <20130226235920.306125735@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/datagram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -187,7 +187,7 @@ struct sk_buff *__skb_recv_datagram(stru
 		skb_queue_walk(queue, skb) {
 			*peeked = skb->peeked;
 			if (flags & MSG_PEEK) {
-				if (*off >= skb->len) {
+				if (*off >= skb->len && skb->len) {
 					*off -= skb->len;
 					continue;
 				}


