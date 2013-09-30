Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab3I3PdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:33:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44567 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3I3Pcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:32:36 -0400
Message-Id: <20130930152624.963956385@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 30 Sep 2013 17:22:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/6] sched, wait: Collapse __wait_event macros
References: <20130930152242.207382649@infradead.org>
Content-Disposition: inline; filename=peterz-wait-deduplicate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's far too much duplication in the __wait_event macros; fix this.

With the previous patches changing the various __wait_event*()
implementations to be more uniform; we can now collapse the lot
without also changing generated code.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/tty.h  |   21 +----
 include/linux/wait.h |  192 +++++++++++++++------------------------------------
 2 files changed, 63 insertions(+), 150 deletions(-)

--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -679,23 +679,10 @@ static inline void tty_wait_until_sent_f
 })
 
 #define __wait_event_interruptible_tty(tty, wq, condition, ret)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
-		tty_unlock(tty);					\
-		schedule();						\
-		tty_lock(tty);						\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, ret,	\
+			tty_unlock(tty);				\
+			schedule();					\
+			tty_lock(tty))
 
 #ifdef CONFIG_PROC_FS
 extern void proc_tty_register_driver(struct tty_driver *);
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -187,19 +187,46 @@ wait_queue_head_t *bit_waitqueue(void *,
  	__cond || !ret;							\
 })
 
-#define __wait_event(wq, condition) 					\
+#define ___wait_signal_pending(state)					\
+	((state == TASK_INTERRUPTIBLE && signal_pending(current)) ||	\
+	 (state == TASK_KILLABLE && fatal_signal_pending(current)))
+
+#define ___wait_nop_ret		int ret __always_unused
+
+#define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
 do {									\
+	__label__ __out;						\
 	DEFINE_WAIT(__wait);						\
 									\
 	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (exclusive)						\
+			prepare_to_wait_exclusive(&wq, &__wait, state); \
+		else							\
+			prepare_to_wait(&wq, &__wait, state);		\
+									\
 		if (condition)						\
 			break;						\
-		schedule();						\
+									\
+		if (___wait_signal_pending(state)) {			\
+			ret = -ERESTARTSYS;				\
+			if (exclusive) {				\
+				abort_exclusive_wait(&wq, &__wait, 	\
+						     state, NULL); 	\
+				goto __out;				\
+			}						\
+			break;						\
+		}							\
+									\
+		cmd;							\
 	}								\
 	finish_wait(&wq, &__wait);					\
+__out:	;								\
 } while (0)
 
+#define __wait_event(wq, condition) 					\
+	___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0,		\
+		      ___wait_nop_ret, schedule())
+
 /**
  * wait_event - sleep until a condition gets true
  * @wq: the waitqueue to wait on
@@ -220,17 +247,9 @@ do {									\
 } while (0)
 
 #define __wait_event_timeout(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (___wait_cond_timeout(condition, ret))		\
-			break;						\
-		ret = schedule_timeout(ret);				\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, ___wait_cond_timeout(condition, ret), 	\
+		      TASK_UNINTERRUPTIBLE, 0, ret,			\
+		      ret = schedule_timeout(ret))
 
 /**
  * wait_event_timeout - sleep until a condition gets true or a timeout elapses
@@ -258,21 +277,8 @@ do {									\
 })
 
 #define __wait_event_interruptible(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
-		schedule();						\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, ret,	\
+		      schedule())
 
 /**
  * wait_event_interruptible - sleep until a condition gets true
@@ -298,21 +304,9 @@ do {									\
 })
 
 #define __wait_event_interruptible_timeout(wq, condition, ret)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (___wait_cond_timeout(condition, ret))		\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
-		ret = schedule_timeout(ret);				\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, ___wait_cond_timeout(condition, ret),		\
+		      TASK_INTERRUPTIBLE, 0, ret,			\
+		      ret = schedule_timeout(ret))
 
 /**
  * wait_event_interruptible_timeout - sleep until a condition gets true or a timeout elapses
@@ -427,26 +421,8 @@ do {									\
 })
 
 #define __wait_event_interruptible_exclusive(wq, condition, ret)	\
-do {									\
-	__label__ __out;						\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait_exclusive(&wq, &__wait,			\
-					TASK_INTERRUPTIBLE);		\
-		if (condition)						\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			abort_exclusive_wait(&wq, &__wait, 		\
-				TASK_INTERRUPTIBLE, NULL);		\
-			goto __out;					\
-		}							\
-		schedule();						\
-	}								\
-	finish_wait(&wq, &__wait);					\
-__out:	;								\
-} while (0)
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 1, ret,	\
+		      schedule())
 
 #define wait_event_interruptible_exclusive(wq, condition)		\
 ({									\
@@ -606,22 +582,7 @@ __out:	;								\
 
 
 #define __wait_event_killable(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_KILLABLE);		\
-		if (condition)						\
-			break;						\
-		if (!fatal_signal_pending(current)) {			\
-			schedule();					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, condition, TASK_KILLABLE, 0, ret, schedule())
 
 /**
  * wait_event_killable - sleep until a condition gets true
@@ -648,20 +609,12 @@ do {									\
 
 
 #define __wait_event_lock_irq(wq, condition, lock, cmd)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		spin_unlock_irq(&lock);					\
-		cmd;							\
-		schedule();						\
-		spin_lock_irq(&lock);					\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0,		\
+		      ___wait_nop_ret,					\
+		      spin_unlock_irq(&lock);				\
+		      cmd;						\
+		      schedule();					\
+		      spin_lock_irq(&lock))
 
 /**
  * wait_event_lock_irq_cmd - sleep until a condition gets true. The
@@ -721,26 +674,12 @@ do {									\
 } while (0)
 
 
-#define __wait_event_interruptible_lock_irq(wq, condition,		\
-					    lock, ret, cmd)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
-		spin_unlock_irq(&lock);					\
-		cmd;							\
-		schedule();						\
-		spin_lock_irq(&lock);					\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define __wait_event_interruptible_lock_irq(wq, condition, lock, ret, cmd) \
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, ret,	   \
+		      spin_unlock_irq(&lock);				   \
+		      cmd;						   \
+		      schedule();					   \
+		      spin_lock_irq(&lock))
 
 /**
  * wait_event_interruptible_lock_irq_cmd - sleep until a condition gets true.
@@ -809,25 +748,12 @@ do {									\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_lock_irq_timeout(wq, condition,	\
-						    lock, ret)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (___wait_cond_timeout(condition, ret))		\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
-		spin_unlock_irq(&lock);					\
-		ret = schedule_timeout(ret);				\
-		spin_lock_irq(&lock);					\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define __wait_event_interruptible_lock_irq_timeout(wq, condition, lock, ret) \
+	___wait_event(wq, ___wait_cond_timeout(condition, ret),		      \
+		      TASK_INTERRUPTIBLE, 0, ret,	      		      \
+		      spin_unlock_irq(&lock);				      \
+		      ret = schedule_timeout(ret);			      \
+		      spin_lock_irq(&lock));
 
 /**
  * wait_event_interruptible_lock_irq_timeout - sleep until a condition gets true or a timeout elapses.


