Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaC3XI7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:08:59 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:16461 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaC3XI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:08:57 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: mingo@kernel.org, tglx@linutronix.de
Cc: peterz@infradead.org, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] futex: update comments for ordering guarantees
Date: Sun, 30 Mar 2014 16:08:47 -0700
Message-Id: <1396220928-4426-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396220928-4426-1-git-send-email-davidlohr@hp.com>
References: <1396220928-4426-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 11d4616bd07f (futex: revert back to the explicit waiter counting code)
was a late fix that changed the way we account for waiters on a futex. However,
it made the general documentation we have regarding this topic slightly stale.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/futex.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 08ec814..395e285 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -119,7 +119,7 @@
  * sys_futex(WAIT, futex, val);
  *   futex_wait(futex, val);
  *
- *   waiters++;
+ *   waiters++; (a)
  *   mb(); (A) <-- paired with -.
  *                              |
  *   lock(hash_bucket(futex));  |
@@ -134,15 +134,14 @@
  *     queue();
  *     unlock(hash_bucket(futex));
  *     schedule();                         if (waiters)
- *                                           lock(hash_bucket(futex));
- *                                           wake_waiters(futex);
+ *   else                                    lock(hash_bucket(futex));
+ *     waiters--; (b)                        wake_waiters(futex);
  *                                           unlock(hash_bucket(futex));
  *
- * Where (A) orders the waiters increment and the futex value read -- this
- * is guaranteed by the head counter in the hb spinlock; and where (B)
- * orders the write to futex and the waiters read -- this is done by the
- * barriers in get_futex_key_refs(), through either ihold or atomic_inc,
- * depending on the futex type.
+ * Where (A) orders the waiters increment and the futex value read and
+ * where (B) orders the write to futex and the waiters read -- this is
+ * done by the barriers in get_futex_key_refs(), through either ihold
+ * or atomic_inc, depending on the futex type.
  *
  * This yields the following case (where X:=waiters, Y:=futex):
  *
@@ -155,6 +154,10 @@
  * Which guarantees that x==0 && y==0 is impossible; which translates back into
  * the guarantee that we cannot both miss the futex variable change and the
  * enqueue.
+ *
+ * Note that a new waiter is accounted for in (a) even when it is possible that
+ * the wait call can return error, in which case we backtrack from it in (b).
+ * Refer to the comment in queue_lock().
  */
 
 int __read_mostly futex_cmpxchg_enabled;
-- 
1.8.1.4

