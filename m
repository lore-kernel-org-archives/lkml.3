Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3JARIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:08:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab3JARIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:08:34 -0400
Date: Tue, 1 Oct 2013 19:01:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC] introduce prepare_to_wait_event()
Message-ID: <20131001170137.GA8560@redhat.com>
References: <20130930152242.207382649@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930152242.207382649@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't test is yet, and I did write the changelog.

But let me show the patch for review right now, before we all
forget the details... On top of Peter's "wait: Collapse __wait_event
macros -v4".

This patch moves the signal-pending checks and part of DEFINE_WAIT's
code into the new helper: prepare_to_wait_event().

Yes, sure, prepare_to_wait_event() becomes a little bit slower than
prepare_to_wait/prepare_to_wait_exclusive. But this is the slow path
anyway, we are likely going to sleep. IMO, it is better to shrink
.text, and on my build the difference is

	- 5124686 2955056 10117120        18196862        115a97e vmlinux
	+ 5123212 2955088 10117120        18195420        115a3dc vmlinux

The code with the patch is

	#define ___wait_is_interruptible(state)					\
		(!__builtin_constant_p(state) ||				\
			state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)	\

	#define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
	({									\
		__label__ __out;						\
		wait_queue_t __wait;						\
		long __ret = ret;						\
										\
		INIT_LIST_HEAD(&__wait.task_list);				\
		if (exclusive)							\
			__wait.flags = WQ_FLAG_EXCLUSIVE;			\
		else								\
			__wait.flags = 0;					\
										\
		for (;;) {							\
			long intr = prepare_to_wait_event(&wq, &__wait, state);	\
										\
			if (condition)						\
				break;						\
										\
			if (___wait_is_interruptible(state) && intr) {		\
				__ret = intr;					\
				if (exclusive) {				\
					abort_exclusive_wait(&wq, &__wait, 	\
							     state, NULL); 	\
					goto __out;				\
				}						\
				break;						\
			}							\
										\
			cmd;							\
		}								\
		finish_wait(&wq, &__wait);					\
	__out:	__ret;								\
	})

Compiler should optimize out "long intr" if !interruptible/killable.

What do you think?

Oleg.
---

diff --git a/include/linux/wait.h b/include/linux/wait.h
index bd4bd7b..aa758d3 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -187,27 +187,30 @@ wait_queue_head_t *bit_waitqueue(void *, int);
  	__cond || !__ret;						\
 })
 
-#define ___wait_signal_pending(state)					\
-	((state == TASK_INTERRUPTIBLE && signal_pending(current)) ||	\
-	 (state == TASK_KILLABLE && fatal_signal_pending(current)))
+#define ___wait_is_interruptible(state)					\
+	(!__builtin_constant_p(state) ||				\
+		state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)	\
 
 #define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
 ({									\
 	__label__ __out;						\
-	DEFINE_WAIT(__wait);						\
+	wait_queue_t __wait;						\
 	long __ret = ret;						\
 									\
+	INIT_LIST_HEAD(&__wait.task_list);				\
+	if (exclusive)							\
+		__wait.flags = WQ_FLAG_EXCLUSIVE;			\
+	else								\
+		__wait.flags = 0;					\
+									\
 	for (;;) {							\
-		if (exclusive)						\
-			prepare_to_wait_exclusive(&wq, &__wait, state); \
-		else							\
-			prepare_to_wait(&wq, &__wait, state);		\
+		long intr = prepare_to_wait_event(&wq, &__wait, state);	\
 									\
 		if (condition)						\
 			break;						\
 									\
-		if (___wait_signal_pending(state)) {			\
-			__ret = -ERESTARTSYS;				\
+		if (___wait_is_interruptible(state) && intr) {		\
+			__ret = intr;					\
 			if (exclusive) {				\
 				abort_exclusive_wait(&wq, &__wait, 	\
 						     state, NULL); 	\
@@ -794,6 +797,7 @@ extern long interruptible_sleep_on_timeout(wait_queue_head_t *q,
  */
 void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state);
+long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
 void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
 			unsigned int mode, void *key);
diff --git a/kernel/wait.c b/kernel/wait.c
index d550920..de21c63 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -92,6 +92,30 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
 
+long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
+{
+	unsigned long flags;
+
+	if (signal_pending_state(state, current))
+		return -ERESTARTSYS;
+
+	wait->private = current;
+	wait->func = autoremove_wake_function;
+
+	spin_lock_irqsave(&q->lock, flags);
+	if (list_empty(&wait->task_list)) {
+		if (wait->flags & WQ_FLAG_EXCLUSIVE)
+			__add_wait_queue_tail(q, wait);
+		else
+			__add_wait_queue(q, wait);
+	}
+	set_current_state(state);
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(prepare_to_wait_event);
+
 /**
  * finish_wait - clean up after waiting in a queue
  * @q: waitqueue waited on

