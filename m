Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbbAOVEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:04:24 -0500
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:35331 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754225AbbAOVCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:02:34 -0500
To: akpm@linux-foundation.org, famz@redhat.com
Cc: normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        davidel@xmailserver.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <8f58ff508718ee67f75aadd67dda70d9feaa82ca.1421337657.git.jbaron@akamai.com>
In-Reply-To: <cover.1421337657.git.jbaron@akamai.com>
References: <cover.1421337657.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [RFC PATCH 2/5] epoll: remove ep_call_nested() from ep_poll_safewake()
Date: Thu, 15 Jan 2015 21:02:33 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ep_poll_safewake() function is used to wakeup potentially nested epoll
file descriptors. The function uses ep_call_nested() to prevent entering
the same wake up queue more than once, and to prevent excessively deep wakeup
paths (deeper than EP_MAX_NESTS). However, this is not necessary since we already
preventing these conditions during EPOLL_CTL_ADD. This saves extra function
calls, and avoids taking a global lock during the ep_call_nested() calls.

I have, however, left ep_call_nested() for the CONFIG_DEBUG_LOCK_ALLOC case,
since ep_call_nested() keeps track of the nesting level, and this is required
by the call to spin_lock_irqsave_nested(). It would be nice to remove the
ep_call_nested() calls for the CONFIG_DEBUG_LOCK_ALLOC case as well, however
its not clear how to simply pass the nesting level through multiple wake_up()
levels. In any case, I don't think CONFIG_DEBUG_LOCK_ALLOC is generally used
for production, so this should provide a decent speedup for the cases that
we care about.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c | 47 ++++++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index e7b0c9e..2864d67 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -265,9 +265,6 @@ static DEFINE_MUTEX(epmutex);
 /* Used to check for epoll file descriptor inclusion loops */
 static struct nested_calls poll_loop_ncalls;
 
-/* Used for safe wake up implementation */
-static struct nested_calls poll_safewake_ncalls;
-
 /* Slab cache used to allocate "struct epitem" */
 static struct kmem_cache *epi_cache __read_mostly;
 
@@ -466,40 +463,21 @@ out_unlock:
  * this special case of epoll.
  */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
-				     unsigned long events, int subclass)
+
+static struct nested_calls poll_safewake_ncalls;
+
+static int ep_poll_wakeup_proc(void *priv, void *cookie, int call_nests)
 {
 	unsigned long flags;
+	wait_queue_head_t *wqueue = (wait_queue_head_t *)cookie;
 
-	spin_lock_irqsave_nested(&wqueue->lock, flags, subclass);
-	wake_up_locked_poll(wqueue, events);
+	spin_lock_irqsave_nested(&wqueue->lock, flags, call_nests + 1);
+	wake_up_locked_poll(wqueue, POLLIN);
 	spin_unlock_irqrestore(&wqueue->lock, flags);
-}
-#else
-static inline void ep_wake_up_nested(wait_queue_head_t *wqueue,
-				     unsigned long events, int subclass)
-{
-	wake_up_poll(wqueue, events);
-}
-#endif
 
-static int ep_poll_wakeup_proc(void *priv, void *cookie, int call_nests)
-{
-	ep_wake_up_nested((wait_queue_head_t *) cookie, POLLIN,
-			  1 + call_nests);
 	return 0;
 }
 
-/*
- * Perform a safe wake up of the poll wait list. The problem is that
- * with the new callback'd wake up system, it is possible that the
- * poll callback is reentered from inside the call to wake_up() done
- * on the poll wait queue head. The rule is that we cannot reenter the
- * wake up code from the same task more than EP_MAX_NESTS times,
- * and we cannot reenter the same wait queue head at all. This will
- * enable to have a hierarchy of epoll file descriptor of no more than
- * EP_MAX_NESTS deep.
- */
 static void ep_poll_safewake(wait_queue_head_t *wq)
 {
 	int this_cpu = get_cpu();
@@ -510,6 +488,15 @@ static void ep_poll_safewake(wait_queue_head_t *wq)
 	put_cpu();
 }
 
+#else
+
+static void ep_poll_safewake(wait_queue_head_t *wq)
+{
+	wake_up_poll(wq, POLLIN);
+}
+
+#endif
+
 static void ep_remove_wait_queue(struct eppoll_entry *pwq)
 {
 	wait_queue_head_t *whead;
@@ -2098,8 +2085,10 @@ static int __init eventpoll_init(void)
 	 */
 	ep_nested_calls_init(&poll_loop_ncalls);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/* Initialize the structure used to perform safe poll wait head wake ups */
 	ep_nested_calls_init(&poll_safewake_ncalls);
+#endif
 
 	/*
 	 * We can have many thousands of epitems, so prevent this from
-- 
1.8.2.rc2

