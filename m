Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab3D2VnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:43:03 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:57537 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913Ab3D2Vmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:42:39 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] unix/stream: fix peeking with an offset larger than data in queue
Date: Mon, 29 Apr 2013 17:42:14 -0400
Message-Id: <1367271734-14379-3-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367271734-14379-1-git-send-email-bpoirier@suse.de>
References: <kll5si$544$1@ger.gmane.org>
 <1367271734-14379-1-git-send-email-bpoirier@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, peeking on a unix stream socket with an offset larger than len of
the data in the sk receive queue returns immediately with bogus data.

This patch fixes this so that the behavior is the same as peeking with no
offset on an empty queue: the caller blocks.

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---
 net/unix/af_unix.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 2db702d..1a02af0 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1859,10 +1859,10 @@ out:
 }
 
 /*
- *	Sleep until data has arrive. But check for races..
+ *	Sleep until more data has arrived. But check for races..
  */
-
-static long unix_stream_data_wait(struct sock *sk, long timeo)
+static long unix_stream_data_wait(struct sock *sk, long timeo,
+				  struct sk_buff *last)
 {
 	DEFINE_WAIT(wait);
 
@@ -1871,7 +1871,7 @@ static long unix_stream_data_wait(struct sock *sk, long timeo)
 	for (;;) {
 		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 
-		if (!skb_queue_empty(&sk->sk_receive_queue) ||
+		if (skb_peek_tail(&sk->sk_receive_queue) != last ||
 		    sk->sk_err ||
 		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
 		    signal_pending(current) ||
@@ -1890,8 +1890,6 @@ static long unix_stream_data_wait(struct sock *sk, long timeo)
 	return timeo;
 }
 
-
-
 static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 			       struct msghdr *msg, size_t size,
 			       int flags)
@@ -1936,14 +1934,12 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 		goto out;
 	}
 
-	skip = sk_peek_offset(sk, flags);
-
 	do {
 		int chunk;
-		struct sk_buff *skb;
+		struct sk_buff *skb, *last;
 
 		unix_state_lock(sk);
-		skb = skb_peek(&sk->sk_receive_queue);
+		last = skb = skb_peek(&sk->sk_receive_queue);
 again:
 		if (skb == NULL) {
 			unix_sk(sk)->recursion_level = 0;
@@ -1966,7 +1962,7 @@ again:
 				break;
 			mutex_unlock(&u->readlock);
 
-			timeo = unix_stream_data_wait(sk, timeo);
+			timeo = unix_stream_data_wait(sk, timeo, last);
 
 			if (signal_pending(current)
 			    ||  mutex_lock_interruptible(&u->readlock)) {
@@ -1980,10 +1976,13 @@ again:
 			break;
 		}
 
-		if (skip >= skb->len) {
+		skip = sk_peek_offset(sk, flags);
+		while (skip >= skb->len) {
 			skip -= skb->len;
+			last = skb;
 			skb = skb_peek_next(skb, &sk->sk_receive_queue);
-			goto again;
+			if (!skb)
+				goto again;
 		}
 
 		unix_state_unlock(sk);
-- 
1.7.10.4

