Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaBEUFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:05:15 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48058 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaBEUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 055/213] netlink: fix races after skb queueing
Date: Wed, 5 Feb 2014 15:00:10 -0500
Message-ID: <1391630568-49251-56-git-send-email-paul.gortmaker@windriver.com>
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

commit 4a7e7c2ad540e54c75489a70137bf0ec15d3a127 upstream.

As soon as an skb is queued into socket receive_queue, another thread
can consume it, so we are not allowed to reference skb anymore, or risk
use after free.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/netlink/af_netlink.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index ba9f6129ff32..1c889685d575 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -830,12 +830,19 @@ int netlink_attachskb(struct sock *sk, struct sk_buff *skb,
 	return 0;
 }
 
-int netlink_sendskb(struct sock *sk, struct sk_buff *skb)
+static int __netlink_sendskb(struct sock *sk, struct sk_buff *skb)
 {
 	int len = skb->len;
 
 	skb_queue_tail(&sk->sk_receive_queue, skb);
 	sk->sk_data_ready(sk, len);
+	return len;
+}
+
+int netlink_sendskb(struct sock *sk, struct sk_buff *skb)
+{
+	int len = __netlink_sendskb(sk, skb);
+
 	sock_put(sk);
 	return len;
 }
@@ -960,8 +967,7 @@ static inline int netlink_broadcast_deliver(struct sock *sk,
 	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
 	    !test_bit(0, &nlk->state)) {
 		skb_set_owner_r(skb, sk);
-		skb_queue_tail(&sk->sk_receive_queue, skb);
-		sk->sk_data_ready(sk, skb->len);
+		__netlink_sendskb(sk, skb);
 		return atomic_read(&sk->sk_rmem_alloc) > (sk->sk_rcvbuf >> 1);
 	}
 	return -1;
@@ -1685,10 +1691,8 @@ static int netlink_dump(struct sock *sk)
 
 		if (sk_filter(sk, skb))
 			kfree_skb(skb);
-		else {
-			skb_queue_tail(&sk->sk_receive_queue, skb);
-			sk->sk_data_ready(sk, skb->len);
-		}
+		else
+			__netlink_sendskb(sk, skb);
 		return 0;
 	}
 
@@ -1700,10 +1704,8 @@ static int netlink_dump(struct sock *sk)
 
 	if (sk_filter(sk, skb))
 		kfree_skb(skb);
-	else {
-		skb_queue_tail(&sk->sk_receive_queue, skb);
-		sk->sk_data_ready(sk, skb->len);
-	}
+	else
+		__netlink_sendskb(sk, skb);
 
 	if (cb->done)
 		cb->done(cb);
-- 
1.8.5.2

