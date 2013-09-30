Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab3I3PeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:34:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44562 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab3I3Pce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:32:34 -0400
Message-Id: <20130930152625.131613711@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 30 Sep 2013 17:22:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6/6] sched, wait: Make the __wait_event*() interface more friendly
References: <20130930152242.207382649@infradead.org>
Content-Disposition: inline; filename=peterz-wait-___wait_event-ret.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change all __wait_event*() implementations to match the corresponding
wait_event*() signature for convenience.

In particular this does away with the weird 'ret' logic. Since there
are __wait_event*() users this requires we update them too.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/mips/kernel/rtlx.c         |   19 +++---
 include/linux/tty.h             |   10 +--
 include/linux/wait.h            |  113 +++++++++++++++++++---------------------
 net/irda/af_irda.c              |    5 -
 net/netfilter/ipvs/ip_vs_sync.c |    7 --
 5 files changed, 73 insertions(+), 81 deletions(-)

--- a/arch/mips/kernel/rtlx.c
+++ b/arch/mips/kernel/rtlx.c
@@ -172,8 +172,9 @@ int rtlx_open(int index, int can_sleep)
 	if (rtlx == NULL) {
 		if( (p = vpe_get_shared(tclimit)) == NULL) {
 		    if (can_sleep) {
-			__wait_event_interruptible(channel_wqs[index].lx_queue,
-				(p = vpe_get_shared(tclimit)), ret);
+			ret = __wait_event_interruptible(
+					channel_wqs[index].lx_queue,
+					(p = vpe_get_shared(tclimit)));
 			if (ret)
 				goto out_fail;
 		    } else {
@@ -263,11 +264,10 @@ unsigned int rtlx_read_poll(int index, i
 	/* data available to read? */
 	if (chan->lx_read == chan->lx_write) {
 		if (can_sleep) {
-			int ret = 0;
-
-			__wait_event_interruptible(channel_wqs[index].lx_queue,
+			int ret = __wait_event_interruptible(
+				channel_wqs[index].lx_queue,
 				(chan->lx_read != chan->lx_write) ||
-				sp_stopping, ret);
+				sp_stopping);
 			if (ret)
 				return ret;
 
@@ -440,14 +440,13 @@ static ssize_t file_write(struct file *f
 
 	/* any space left... */
 	if (!rtlx_write_poll(minor)) {
-		int ret = 0;
+		int ret;
 
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 
-		__wait_event_interruptible(channel_wqs[minor].rt_queue,
-					   rtlx_write_poll(minor),
-					   ret);
+		ret = __wait_event_interruptible(channel_wqs[minor].rt_queue,
+					   rtlx_write_poll(minor));
 		if (ret)
 			return ret;
 	}
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -672,14 +672,14 @@ static inline void tty_wait_until_sent_f
 #define wait_event_interruptible_tty(tty, wq, condition)		\
 ({									\
 	int __ret = 0;							\
-	if (!(condition)) {						\
-		__wait_event_interruptible_tty(tty, wq, condition, __ret);	\
-	}								\
+	if (!(condition))						\
+		__ret = __wait_event_interruptible_tty(tty, wq,		\
+						       condition);	\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_tty(tty, wq, condition, ret)		\
-	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, ret,	\
+#define __wait_event_interruptible_tty(tty, wq, condition)		\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
 			tty_unlock(tty);				\
 			schedule();					\
 			tty_lock(tty))
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -179,24 +179,23 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define wake_up_interruptible_sync_poll(x, m)				\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
-#define ___wait_cond_timeout(condition, ret)				\
+#define ___wait_cond_timeout(condition)					\
 ({									\
  	bool __cond = (condition);					\
- 	if (__cond && !ret)						\
- 		ret = 1;						\
- 	__cond || !ret;							\
+ 	if (__cond && !__ret)						\
+ 		__ret = 1;						\
+ 	__cond || !__ret;						\
 })
 
 #define ___wait_signal_pending(state)					\
 	((state == TASK_INTERRUPTIBLE && signal_pending(current)) ||	\
 	 (state == TASK_KILLABLE && fatal_signal_pending(current)))
 
-#define ___wait_nop_ret		int ret __always_unused
-
 #define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
-do {									\
+({									\
 	__label__ __out;						\
 	DEFINE_WAIT(__wait);						\
+	long __ret = ret;						\
 									\
 	for (;;) {							\
 		if (exclusive)						\
@@ -208,7 +207,7 @@ do {									\
 			break;						\
 									\
 		if (___wait_signal_pending(state)) {			\
-			ret = -ERESTARTSYS;				\
+			__ret = -ERESTARTSYS;				\
 			if (exclusive) {				\
 				abort_exclusive_wait(&wq, &__wait, 	\
 						     state, NULL); 	\
@@ -220,12 +219,12 @@ do {									\
 		cmd;							\
 	}								\
 	finish_wait(&wq, &__wait);					\
-__out:	;								\
-} while (0)
+__out:	__ret;								\
+})
 
 #define __wait_event(wq, condition) 					\
-	___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0,		\
-		      ___wait_nop_ret, schedule())
+	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
+			    schedule())
 
 /**
  * wait_event - sleep until a condition gets true
@@ -246,10 +245,10 @@ do {									\
 	__wait_event(wq, condition);					\
 } while (0)
 
-#define __wait_event_timeout(wq, condition, ret)			\
-	___wait_event(wq, ___wait_cond_timeout(condition, ret), 	\
-		      TASK_UNINTERRUPTIBLE, 0, ret,			\
-		      ret = schedule_timeout(ret))
+#define __wait_event_timeout(wq, condition, timeout)			\
+	___wait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_UNINTERRUPTIBLE, 0, timeout,			\
+		      __ret = schedule_timeout(__ret))
 
 /**
  * wait_event_timeout - sleep until a condition gets true or a timeout elapses
@@ -272,12 +271,12 @@ do {									\
 ({									\
 	long __ret = timeout;						\
 	if (!(condition)) 						\
-		__wait_event_timeout(wq, condition, __ret);		\
+		__ret = __wait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
 })
 
-#define __wait_event_interruptible(wq, condition, ret)			\
-	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, ret,	\
+#define __wait_event_interruptible(wq, condition)			\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
 		      schedule())
 
 /**
@@ -299,14 +298,14 @@ do {									\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__wait_event_interruptible(wq, condition, __ret);	\
+		__ret = __wait_event_interruptible(wq, condition);	\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_timeout(wq, condition, ret)		\
-	___wait_event(wq, ___wait_cond_timeout(condition, ret),		\
-		      TASK_INTERRUPTIBLE, 0, ret,			\
-		      ret = schedule_timeout(ret))
+#define __wait_event_interruptible_timeout(wq, condition, timeout)	\
+	___wait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_INTERRUPTIBLE, 0, timeout,			\
+		      __ret = schedule_timeout(__ret))
 
 /**
  * wait_event_interruptible_timeout - sleep until a condition gets true or a timeout elapses
@@ -330,7 +329,8 @@ do {									\
 ({									\
 	long __ret = timeout;						\
 	if (!(condition))						\
-		__wait_event_interruptible_timeout(wq, condition, __ret); \
+		__ret = __wait_event_interruptible_timeout(wq, 		\
+						condition, timeout);	\
 	__ret;								\
 })
 
@@ -347,7 +347,7 @@ do {									\
 				       current->timer_slack_ns,		\
 				       HRTIMER_MODE_REL);		\
 									\
-	___wait_event(wq, condition, state, 0, __ret,			\
+	__ret = ___wait_event(wq, condition, state, 0, 0,		\
 		if (!__t.task) {					\
 			__ret = -ETIME;					\
 			break;						\
@@ -409,15 +409,15 @@ do {									\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_exclusive(wq, condition, ret)	\
-	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 1, ret,	\
+#define __wait_event_interruptible_exclusive(wq, condition)		\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 1, 0,		\
 		      schedule())
 
 #define wait_event_interruptible_exclusive(wq, condition)		\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__wait_event_interruptible_exclusive(wq, condition, __ret);\
+		__ret = __wait_event_interruptible_exclusive(wq, condition);\
 	__ret;								\
 })
 
@@ -570,8 +570,8 @@ do {									\
 
 
 
-#define __wait_event_killable(wq, condition, ret)			\
-	___wait_event(wq, condition, TASK_KILLABLE, 0, ret, schedule())
+#define __wait_event_killable(wq, condition)				\
+	___wait_event(wq, condition, TASK_KILLABLE, 0, 0, schedule())
 
 /**
  * wait_event_killable - sleep until a condition gets true
@@ -592,18 +592,17 @@ do {									\
 ({									\
 	int __ret = 0;							\
 	if (!(condition))						\
-		__wait_event_killable(wq, condition, __ret);		\
+		__ret = __wait_event_killable(wq, condition);		\
 	__ret;								\
 })
 
 
 #define __wait_event_lock_irq(wq, condition, lock, cmd)			\
-	___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0,		\
-		      ___wait_nop_ret,					\
-		      spin_unlock_irq(&lock);				\
-		      cmd;						\
-		      schedule();					\
-		      spin_lock_irq(&lock))
+	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
+			    spin_unlock_irq(&lock);			\
+			    cmd;					\
+			    schedule();					\
+			    spin_lock_irq(&lock))
 
 /**
  * wait_event_lock_irq_cmd - sleep until a condition gets true. The
@@ -663,11 +662,11 @@ do {									\
 } while (0)
 
 
-#define __wait_event_interruptible_lock_irq(wq, condition, lock, ret, cmd) \
-	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, ret,	   \
-		      spin_unlock_irq(&lock);				   \
-		      cmd;						   \
-		      schedule();					   \
+#define __wait_event_interruptible_lock_irq(wq, condition, lock, cmd)	\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,	   	\
+		      spin_unlock_irq(&lock);				\
+		      cmd;						\
+		      schedule();					\
 		      spin_lock_irq(&lock))
 
 /**
@@ -698,10 +697,9 @@ do {									\
 #define wait_event_interruptible_lock_irq_cmd(wq, condition, lock, cmd)	\
 ({									\
 	int __ret = 0;							\
-									\
 	if (!(condition))						\
-		__wait_event_interruptible_lock_irq(wq, condition,	\
-						    lock, __ret, cmd);	\
+		__ret = __wait_event_interruptible_lock_irq(wq, 	\
+						condition, lock, cmd);	\
 	__ret;								\
 })
 
@@ -730,18 +728,18 @@ do {									\
 #define wait_event_interruptible_lock_irq(wq, condition, lock)		\
 ({									\
 	int __ret = 0;							\
-									\
 	if (!(condition))						\
-		__wait_event_interruptible_lock_irq(wq, condition,	\
-						    lock, __ret, );	\
+		__ret = __wait_event_interruptible_lock_irq(wq,		\
+						condition, lock,)	\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_lock_irq_timeout(wq, condition, lock, ret) \
-	___wait_event(wq, ___wait_cond_timeout(condition, ret),		      \
-		      TASK_INTERRUPTIBLE, 0, ret,	      		      \
-		      spin_unlock_irq(&lock);				      \
-		      ret = schedule_timeout(ret);			      \
+#define __wait_event_interruptible_lock_irq_timeout(wq, condition, 	\
+						    lock, timeout) 	\
+	___wait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_INTERRUPTIBLE, 0, ret,	      		\
+		      spin_unlock_irq(&lock);				\
+		      __ret = schedule_timeout(__ret);			\
 		      spin_lock_irq(&lock));
 
 /**
@@ -771,11 +769,10 @@ do {									\
 #define wait_event_interruptible_lock_irq_timeout(wq, condition, lock,	\
 						  timeout)		\
 ({									\
-	int __ret = timeout;						\
-									\
+	long __ret = timeout;						\
 	if (!(condition))						\
-		__wait_event_interruptible_lock_irq_timeout(		\
-					wq, condition, lock, __ret);	\
+		__ret = __wait_event_interruptible_lock_irq_timeout(	\
+					wq, condition, lock, timeout);	\
 	__ret;								\
 })
 
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -2563,9 +2563,8 @@ static int irda_getsockopt(struct socket
 				  jiffies + msecs_to_jiffies(val));
 
 			/* Wait for IR-LMP to call us back */
-			__wait_event_interruptible(self->query_wait,
-			      (self->cachedaddr != 0 || self->errno == -ETIME),
-						   err);
+			err = __wait_event_interruptible(self->query_wait,
+			      (self->cachedaddr != 0 || self->errno == -ETIME));
 
 			/* If watchdog is still activated, kill it! */
 			del_timer(&(self->watchdog));
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1637,12 +1637,9 @@ static int sync_thread_master(void *data
 			continue;
 		}
 		while (ip_vs_send_sync_msg(tinfo->sock, sb->mesg) < 0) {
-			int ret = 0;
-
-			__wait_event_interruptible(*sk_sleep(sk),
+			int ret = __wait_event_interruptible(*sk_sleep(sk),
 						   sock_writeable(sk) ||
-						   kthread_should_stop(),
-						   ret);
+						   kthread_should_stop());
 			if (unlikely(kthread_should_stop()))
 				goto done;
 		}


