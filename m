Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaKPWAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:00:53 -0500
Received: from 1wt.eu ([62.212.114.60]:47917 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbaKPWAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:48 -0500
Message-Id: <20141116215329.349693646@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:45 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 17/48] appletalk: Fix socket referencing in skb
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Utkin <andrey.krieger.utkin@gmail.com>

[ Upstream commit 36beddc272c111689f3042bf3d10a64d8a805f93 ]

Setting just skb->sk without taking its reference and setting a
destructor is invalid. However, in the places where this was done, skb
is used in a way not requiring skb->sk setting. So dropping the setting
of skb->sk.
Thanks to Eric Dumazet <eric.dumazet@gmail.com> for correct solution.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79441
Reported-by: Ed Martin <edman007@edman007.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/appletalk/ddp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 5eae360..d44ac8d 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1469,8 +1469,6 @@ static int atalk_rcv(struct sk_buff *skb, struct net_device *dev,
 		goto drop;
 
 	/* Queue packet (standard) */
-	skb->sk = sock;
-
 	if (sock_queue_rcv_skb(sock, skb) < 0)
 		goto drop;
 
@@ -1616,7 +1614,6 @@ static int atalk_sendmsg(struct kiocb *iocb, struct socket *sock, struct msghdr
 	if (!skb)
 		return err;
 
-	skb->sk = sk;
 	skb_reserve(skb, ddp_dl->header_length);
 	skb_reserve(skb, dev->hard_header_len);
 	skb->dev = dev;
-- 
1.7.12.2.21.g234cd45.dirty



