Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaC3XJB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:09:01 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:10926 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaC3XI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:08:57 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: mingo@kernel.org, tglx@linutronix.de
Cc: peterz@infradead.org, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] futex: add plist_del + atomic_dec helper
Date: Sun, 30 Mar 2014 16:08:48 -0700
Message-Id: <1396220928-4426-3-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396220928-4426-1-git-send-email-davidlohr@hp.com>
References: <1396220928-4426-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When removing a waiter from the plist, we always decrement the
hb waiters to reflect such logic. Add an unqueue_waiter() helper,
thus preventing any future changes that might not do so.

For the enqueuing, this isn't worth it since we will increment the
hb waiters before doing the plist_add().

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/futex.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 395e285..b9ef521 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -291,6 +291,13 @@ static inline int hb_waiters_pending(struct futex_hash_bucket *hb)
 #endif
 }
 
+static inline void unqueue_waiter(struct futex_q *q,
+				  struct futex_hash_bucket *hb)
+{
+	plist_del(&q->list, &hb->chain);
+	hb_waiters_dec(hb);
+}
+
 /*
  * We hash on the keys returned from get_futex_key (see below).
  */
@@ -972,8 +979,7 @@ static void __unqueue_futex(struct futex_q *q)
 		return;
 
 	hb = container_of(q->lock_ptr, struct futex_hash_bucket, lock);
-	plist_del(&q->list, &hb->chain);
-	hb_waiters_dec(hb);
+	unqueue_waiter(q, hb);
 }
 
 /*
@@ -1276,8 +1282,7 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
 	 * requeue.
 	 */
 	if (likely(&hb1->chain != &hb2->chain)) {
-		plist_del(&q->list, &hb1->chain);
-		hb_waiters_dec(hb1);
+		unqueue_waiter(q, hb1);
 		plist_add(&q->list, &hb2->chain);
 		hb_waiters_inc(hb2);
 		q->lock_ptr = &hb2->lock;
@@ -2375,8 +2380,7 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 		 * We were woken prior to requeue by a timeout or a signal.
 		 * Unqueue the futex_q and determine which it was.
 		 */
-		plist_del(&q->list, &hb->chain);
-		hb_waiters_dec(hb);
+		unqueue_waiter(q, hb);
 
 		/* Handle spurious wakeups gracefully */
 		ret = -EWOULDBLOCK;
-- 
1.8.1.4

