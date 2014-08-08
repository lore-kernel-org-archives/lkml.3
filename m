Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbaHHWWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:22:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40446 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbaHHUqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 249/259] appletalk: Fix socket referencing in skb
Date: Fri,  8 Aug 2014 13:41:12 -0700
Message-Id: <1407530482-4483-250-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/appletalk/ddp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 7d424ac..43e875c 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1489,8 +1489,6 @@ static int atalk_rcv(struct sk_buff *skb, struct net_device *dev,
 		goto drop;
 
 	/* Queue packet (standard) */
-	skb->sk = sock;
-
 	if (sock_queue_rcv_skb(sock, skb) < 0)
 		goto drop;
 
@@ -1644,7 +1642,6 @@ static int atalk_sendmsg(struct kiocb *iocb, struct socket *sock, struct msghdr
 	if (!skb)
 		goto out;
 
-	skb->sk = sk;
 	skb_reserve(skb, ddp_dl->header_length);
 	skb_reserve(skb, dev->hard_header_len);
 	skb->dev = dev;
-- 
1.9.1

