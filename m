Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3DZSgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 14:36:10 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:51798 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab3DZSfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 14:35:44 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/3] unix/dgram: fix peeking with an offset larger than data in queue
Date: Fri, 26 Apr 2013 14:35:11 -0400
Message-Id: <1367001312-6719-2-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367001312-6719-1-git-send-email-bpoirier@suse.de>
References: <1366915736.8964.171.camel@edumazet-glaptop>
 <1367001312-6719-1-git-send-email-bpoirier@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, peeking on a unix datagram socket with an offset larger than len of
the data in the sk receive queue returns immediately with bogus data. That's
because *off is not reset between each skb_queue_walk().

This patch fixes this so that the behavior is the same as peeking with no
offset on an empty queue: the caller blocks.

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---

v2: address review feedback

 net/core/datagram.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 99c4f52..1985c9a 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -78,9 +78,10 @@ static int receiver_wake_function(wait_queue_t *wait, unsigned int mode, int syn
 	return autoremove_wake_function(wait, mode, sync, key);
 }
 /*
- * Wait for a packet..
+ * Wait for the last received packet to be different from skb
  */
-static int wait_for_packet(struct sock *sk, int *err, long *timeo_p)
+static int wait_for_more_packets(struct sock *sk, int *err, long *timeo_p,
+				 const struct sk_buff *skb)
 {
 	int error;
 	DEFINE_WAIT_FUNC(wait, receiver_wake_function);
@@ -92,7 +93,7 @@ static int wait_for_packet(struct sock *sk, int *err, long *timeo_p)
 	if (error)
 		goto out_err;
 
-	if (!skb_queue_empty(&sk->sk_receive_queue))
+	if (sk->sk_receive_queue.prev != skb)
 		goto out;
 
 	/* Socket shut down? */
@@ -131,9 +132,9 @@ out_noerr:
  *	__skb_recv_datagram - Receive a datagram skbuff
  *	@sk: socket
  *	@flags: MSG_ flags
- *	@off: an offset in bytes to peek skb from. Returns an offset
- *	      within an skb where data actually starts
  *	@peeked: returns non-zero if this packet has been seen before
+ *	@_off: an offset in bytes to peek skb from. Returns an offset
+ *	       within an skb where data actually starts
  *	@err: error code returned
  *
  *	Get a datagram skbuff, understands the peeking, nonblocking wakeups
@@ -159,9 +160,9 @@ out_noerr:
  *	the standard around please.
  */
 struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
-				    int *peeked, int *off, int *err)
+				    int *peeked, int *_off, int *err)
 {
-	struct sk_buff *skb;
+	struct sk_buff *skb, *last;
 	long timeo;
 	/*
 	 * Caller is allowed not to check sk->sk_err before skb_recv_datagram()
@@ -182,14 +183,17 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
 		 */
 		unsigned long cpu_flags;
 		struct sk_buff_head *queue = &sk->sk_receive_queue;
+		int off = *_off;
 
+		last = (struct sk_buff *)queue;
 		spin_lock_irqsave(&queue->lock, cpu_flags);
 		skb_queue_walk(queue, skb) {
+			last = skb;
 			*peeked = skb->peeked;
 			if (flags & MSG_PEEK) {
-				if (*off >= skb->len && (skb->len || *off ||
-							 skb->peeked)) {
-					*off -= skb->len;
+				if (off >= skb->len && (skb->len || off ||
+							skb->peeked)) {
+					off -= skb->len;
 					continue;
 				}
 				skb->peeked = 1;
@@ -198,6 +202,7 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
 				__skb_unlink(skb, queue);
 
 			spin_unlock_irqrestore(&queue->lock, cpu_flags);
+			*_off = off;
 			return skb;
 		}
 		spin_unlock_irqrestore(&queue->lock, cpu_flags);
@@ -207,7 +212,7 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
 		if (!timeo)
 			goto no_packet;
 
-	} while (!wait_for_packet(sk, err, &timeo));
+	} while (!wait_for_more_packets(sk, err, &timeo, last));
 
 	return NULL;
 
-- 
1.7.10.4

