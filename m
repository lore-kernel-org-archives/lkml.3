Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab3JGQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:25:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab3JGQZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:25:25 -0400
Date: Mon, 7 Oct 2013 18:18:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] sched/wait: Introduce prepare_to_wait_event()
Message-ID: <20131007161824.GA29757@redhat.com>
References: <20131007161758.GA29749@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007161758.GA29749@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new helper, prepare_to_wait_event() which should only be used
by ___wait_event().

prepare_to_wait_event() returns -ERESTARTSYS if signal_pending_state()
is true, otherwise it does prepare_to_wait/exclusive.  This allows to
uninline the signal-pending checks in wait_event*() macros.

Also, it can initialize wait->private/func. We do not care if they were
already initialized, the values are the same. This also shaves a couple
of insns from the inlined code.

This obviously makes prepare_*() path a little bit slower,  but we are
likely going to sleep anyway, so I think it makes sense to shrink .text,

	- 5126092	2959248	10117120	18202460	115bf5c	vmlinux
	+ 5124618	2955152	10117120	18196890	115a99a	vmlinux

on my build.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/wait.h |   24 ++++++++++++++----------
 kernel/wait.c        |   24 ++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index a2726c7..ff9e20f 100644
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
+		long __int = prepare_to_wait_event(&wq, &__wait, state);\
 									\
 		if (condition)						\
 			break;						\
 									\
-		if (___wait_signal_pending(state)) {			\
-			__ret = -ERESTARTSYS;				\
+		if (___wait_is_interruptible(state) && __int) {		\
+			__ret = __int;					\
 			if (exclusive) {				\
 				abort_exclusive_wait(&wq, &__wait,	\
 						     state, NULL);	\
@@ -791,6 +794,7 @@ extern long interruptible_sleep_on_timeout(wait_queue_head_t *q, signed long tim
  */
 void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state);
+long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
 void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait, unsigned int mode, void *key);
 int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
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
-- 
1.5.5.1


