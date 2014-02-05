Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbaBEVEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:04:34 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48044 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbaBEUFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:01 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 053/213] net: fix a race in sock_queue_err_skb()
Date: Wed, 5 Feb 2014 15:00:08 -0500
Message-ID: <1391630568-49251-54-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 110c43304db6f06490961529536c362d9ac5732f upstream.

As soon as an skb is queued into socket error queue, another thread
can consume it, so we are not allowed to reference skb anymore, or risk
use after free.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[PG: net/core/skbuff.c  -->  include/net/sock.h on 2.6.34 baseline]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/net/sock.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b365fc2597c3..133e350c6fa3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1428,6 +1428,8 @@ extern int sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
 
 static inline int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 {
+	int len = skb->len;
+
 	/* Cast skb->rcvbuf to unsigned... It's pointless, but reduces
 	   number of warnings when compiling with -W --ANK
 	 */
@@ -1437,7 +1439,7 @@ static inline int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 	skb_set_owner_r(skb, sk);
 	skb_queue_tail(&sk->sk_error_queue, skb);
 	if (!sock_flag(sk, SOCK_DEAD))
-		sk->sk_data_ready(sk, skb->len);
+		sk->sk_data_ready(sk, len);
 	return 0;
 }
 
-- 
1.8.5.2

