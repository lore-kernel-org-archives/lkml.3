Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbaGZTDW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:03:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaGZTDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:03:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ed Martin <edman007@edman007.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 30/56] appletalk: Fix socket referencing in skb
Date: Sat, 26 Jul 2014 12:02:23 -0700
Message-Id: <20140726190201.008525121@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190200.061512159@linuxfoundation.org>
References: <20140726190200.061512159@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/appletalk/ddp.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1489,8 +1489,6 @@ static int atalk_rcv(struct sk_buff *skb
 		goto drop;
 
 	/* Queue packet (standard) */
-	skb->sk = sock;
-
 	if (sock_queue_rcv_skb(sock, skb) < 0)
 		goto drop;
 
@@ -1644,7 +1642,6 @@ static int atalk_sendmsg(struct kiocb *i
 	if (!skb)
 		goto out;
 
-	skb->sk = sk;
 	skb_reserve(skb, ddp_dl->header_length);
 	skb_reserve(skb, dev->hard_header_len);
 	skb->dev = dev;


