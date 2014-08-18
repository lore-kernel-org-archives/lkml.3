Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaHRJek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:34:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42676 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaHRJeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 049/137] appletalk: Fix socket referencing in skb
Date: Mon, 18 Aug 2014 10:31:50 +0100
Message-Id: <1408354398-10226-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Utkin <andrey.krieger.utkin@gmail.com>

commit 36beddc272c111689f3042bf3d10a64d8a805f93 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/appletalk/ddp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 7d424ac6e760..43e875c84429 100644
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

