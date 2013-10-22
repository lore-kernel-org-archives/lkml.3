Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab3JVEL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 00:11:58 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53032 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3JVEL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 00:11:57 -0400
Date: Tue, 22 Oct 2013 12:11:24 +0800
From: ZHAO Gang <gamerh2o@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: remove function sk_reset_txq()
Message-ID: <20131022041124.GA14122@will>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What sk_reset_txq() does is just calls function sk_tx_queue_reset(),
and sk_reset_txq() is used only in sock.h, by dst_negative_advice().
Let dst_negative_advice() calls sk_tx_queue_reset() directly so we
can remove unneeded sk_reset_txq().

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 include/net/sock.h | 4 +---
 net/core/sock.c    | 6 ------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 1d37a80..db66682 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1752,8 +1752,6 @@ sk_dst_get(struct sock *sk)
 	return dst;
 }
 
-extern void sk_reset_txq(struct sock *sk);
-
 static inline void dst_negative_advice(struct sock *sk)
 {
 	struct dst_entry *ndst, *dst = __sk_dst_get(sk);
@@ -1763,7 +1761,7 @@ static inline void dst_negative_advice(struct sock *sk)
 
 		if (ndst != dst) {
 			rcu_assign_pointer(sk->sk_dst_cache, ndst);
-			sk_reset_txq(sk);
+			sk_tx_queue_clear(sk);
 		}
 	}
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index 5b6beba..3f1545f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -475,12 +475,6 @@ discard_and_relse:
 }
 EXPORT_SYMBOL(sk_receive_skb);
 
-void sk_reset_txq(struct sock *sk)
-{
-	sk_tx_queue_clear(sk);
-}
-EXPORT_SYMBOL(sk_reset_txq);
-
 struct dst_entry *__sk_dst_check(struct sock *sk, u32 cookie)
 {
 	struct dst_entry *dst = __sk_dst_get(sk);
-- 
1.8.3.1

