Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab3FETLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:11:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757282Ab3FETL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:11:27 -0400
Date: Wed, 5 Jun 2013 21:07:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Imre Deak <imre.deak@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Czerner <lczerner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] wait: fix false timeouts when using
	wait_event_timeout()
Message-ID: <20130605190723.GA4957@redhat.com>
References: <20130604192818.GA31316@redhat.com> <1370381717.8432.14.camel@ideak-mobl> <1370382051.8432.16.camel@ideak-mobl> <20130605163702.GA26135@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605163702.GA26135@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05, Oleg Nesterov wrote:
>
> I think that wait_eveint_timeout(wq, COND, 0) should return !!(COND).
> But it doesn't, for example wait_event_timeout(wq, true, 0) == 0, this
> doesn'tlook right to me.
>
> And, this is off-topic, but wait_eveint_timeout/__wait_eveint_timeout
> do not match wait_event/__wait_event. IOW, you can't use
> __wait_eveint_timeout() if you do not need the fast-path check.
>
> So. How about
>
> 	#define __wait_event_timeout(wq, condition, timeout)			\
> 	({									\
> 		DEFINE_WAIT(__wait);						\
> 		long __ret = 0, __to = timeout;					\
> 										\
> 		for (;;) {							\
> 			prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
> 			if (condition) {					\
> 				__ret = __to ?: 1;				\
> 				break;						\
> 			}							\
> 			if (!__to)						\
> 				break;						\
> 			__to = schedule_timeout(__to);				\
> 		}								\
> 		finish_wait(&wq, &__wait);					\
> 		__ret;								\
> 	})
>
> 	#define wait_event_timeout(wq, condition, timeout)			\
> 	({									\
> 		long __ret;							\
> 		if (condition)							\
> 			__ret = (timeout) ?: 1;					\
> 		else								\
> 			__ret = __wait_event_timeout(wq, condition, timeout);	\
> 		__ret;								\
> 	})
>
> ?
>
> Othwerwise we should document the fact that the caller should alvays verify
> timeout != 0 if it checks the result of wait_event_timeout().

And in fact, perhaps we can implement wait_event_common() and avoid the
code duplications?

	#define __wait_no_timeout(timeout)	\
		(__builtin_constant_p(timeout) && (timeout) == MAX_SCHEDULE_TIMEOUT)

	/* uglified signal_pending_state() */
	#define __wait_signal_pending(state)					\
		((state == TASK_INTERRUPTIBLE) ? signal_pending(current) :	\
		 (state == TASK_KILLABLE) ? fatal_signal_pending(current) :	\
		  0)

	#define __wait_event_common(wq, condition, state, tout)			\
	({									\
		DEFINE_WAIT(__wait);						\
		long __ret = 0, __tout = tout;					\
										\
		for (;;) {							\
			prepare_to_wait(&wq, &__wait, state);			\
			if (condition) {					\
				__ret = __wait_no_timeout(tout) ?: __tout ?: 1;	\
				break;						\
			}							\
										\
			if (__wait_signal_pending(state)) {			\
				__ret = -ERESTARTSYS;				\
				break;						\
			}							\
										\
			if (__wait_no_timeout(tout))				\
				schedule();					\
			else if (__tout)					\
				__tout = schedule_timeout(__tout);		\
			else							\
				break;						\
		}								\
		finish_wait(&wq, &__wait);					\
		__ret;								\
	})

	#define wait_event_common(wq, condition, state, tout)			\
	({									\
		long __ret;							\
		if (condition)							\
			__ret = __wait_no_timeout(tout) ?: (tout) ?: 1;		\
		else								\
			__ret = __wait_event_common(wq, condition, state, tout);\
		__ret;								\
	})

Then, for example, wait_event() becomes

	#define wait_event(wq, condition) 					\
		wait_event_common(wq, condition,				\
				TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)	\

Hmm. I compiled the kernel with the patch below,

		$ size vmlinux
		   text	   data	    bss	    dec	    hex	filename
	-	4978601	2935080	10104832	18018513	112f0d1	vmlinux
	+	4977769	2930984	10104832	18013585	112dd91	vmlinux

looks good...

Oleg.

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 1133695..359fffc 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -173,18 +173,52 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 #define wake_up_interruptible_sync_poll(x, m)				\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
-#define __wait_event(wq, condition) 					\
-do {									\
+#define __wait_no_timeout(timeout)	\
+	(__builtin_constant_p(timeout) && (timeout) == MAX_SCHEDULE_TIMEOUT)
+
+/* uglified signal_pending_state() */
+#define __wait_signal_pending(state)					\
+	((state == TASK_INTERRUPTIBLE) ? signal_pending(current) :	\
+	 (state == TASK_KILLABLE) ? fatal_signal_pending(current) :	\
+	  0)
+
+#define __wait_event_common(wq, condition, state, tout)			\
+({									\
 	DEFINE_WAIT(__wait);						\
+	long __ret = 0, __tout = tout;					\
 									\
 	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (condition)						\
+		prepare_to_wait(&wq, &__wait, state);			\
+		if (condition) {					\
+			__ret = __wait_no_timeout(tout) ?: __tout ?: 1;	\
+			break;						\
+		}							\
+									\
+		if (__wait_signal_pending(state)) {			\
+			__ret = -ERESTARTSYS;				\
+			break;						\
+		}							\
+									\
+		if (__wait_no_timeout(tout))				\
+			schedule();					\
+		else if (__tout)					\
+			__tout = schedule_timeout(__tout);		\
+		else							\
 			break;						\
-		schedule();						\
 	}								\
 	finish_wait(&wq, &__wait);					\
-} while (0)
+	__ret;								\
+})
+
+#define wait_event_common(wq, condition, state, tout)			\
+({									\
+	long __ret;							\
+	if (condition)							\
+		__ret = __wait_no_timeout(tout) ?: (tout) ?: 1;		\
+	else								\
+		__ret = __wait_event_common(wq, condition, state, tout);\
+	__ret;								\
+})
 
 /**
  * wait_event - sleep until a condition gets true
@@ -198,29 +232,13 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  */
-#define wait_event(wq, condition) 					\
-do {									\
-	if (condition)	 						\
-		break;							\
-	__wait_event(wq, condition);					\
-} while (0)
+#define __wait_event(wq, condition) 					\
+	__wait_event_common(wq, condition,				\
+			TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)	\
 
-#define __wait_event_timeout(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		ret = schedule_timeout(ret);				\
-		if (!ret)						\
-			break;						\
-	}								\
-	if (!ret && (condition))					\
-		ret = 1;						\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define wait_event(wq, condition) 					\
+	wait_event_common(wq, condition,				\
+			TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)	\
 
 /**
  * wait_event_timeout - sleep until a condition gets true or a timeout elapses
@@ -239,31 +257,13 @@ do {									\
  * jiffies (at least 1) if the @condition evaluated to %true before
  * the @timeout elapsed.
  */
-#define wait_event_timeout(wq, condition, timeout)			\
-({									\
-	long __ret = timeout;						\
-	if (!(condition)) 						\
-		__wait_event_timeout(wq, condition, __ret);		\
-	__ret;								\
-})
+#define __wait_event_timeout(wq, condition, timeout)			\
+	__wait_event_common(wq, condition,				\
+			TASK_UNINTERRUPTIBLE, timeout)
 
-#define __wait_event_interruptible(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (!signal_pending(current)) {				\
-			schedule();					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define wait_event_timeout(wq, condition, timeout)			\
+	wait_event_common(wq, condition,				\
+			TASK_UNINTERRUPTIBLE, timeout)
 
 /**
  * wait_event_interruptible - sleep until a condition gets true
@@ -280,35 +280,13 @@ do {									\
  * The function will return -ERESTARTSYS if it was interrupted by a
  * signal and 0 if @condition evaluated to true.
  */
-#define wait_event_interruptible(wq, condition)				\
-({									\
-	int __ret = 0;							\
-	if (!(condition))						\
-		__wait_event_interruptible(wq, condition, __ret);	\
-	__ret;								\
-})
+#define __wait_event_interruptible(wq, condition)			\
+	__wait_event_common(wq, condition,				\
+			TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)
 
-#define __wait_event_interruptible_timeout(wq, condition, ret)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (!signal_pending(current)) {				\
-			ret = schedule_timeout(ret);			\
-			if (!ret)					\
-				break;					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
-	}								\
-	if (!ret && (condition))					\
-		ret = 1;						\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define wait_event_interruptible(wq, condition)				\
+	wait_event_common(wq, condition,				\
+			TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)
 
 /**
  * wait_event_interruptible_timeout - sleep until a condition gets true or a timeout elapses
@@ -328,13 +306,13 @@ do {									\
  * a signal, or the remaining jiffies (at least 1) if the @condition
  * evaluated to %true before the @timeout elapsed.
  */
+#define __wait_event_interruptible_timeout(wq, condition, timeout)	\
+	__wait_event_common(wq, condition,				\
+			TASK_INTERRUPTIBLE, timeout)
+
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
-({									\
-	long __ret = timeout;						\
-	if (!(condition))						\
-		__wait_event_interruptible_timeout(wq, condition, __ret); \
-	__ret;								\
-})
+	wait_event_common(wq, condition,				\
+			TASK_INTERRUPTIBLE, timeout)
 
 #define __wait_event_hrtimeout(wq, condition, timeout, state)		\
 ({									\
@@ -601,24 +579,6 @@ do {									\
 
 
 
-#define __wait_event_killable(wq, condition, ret)			\
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
-
 /**
  * wait_event_killable - sleep until a condition gets true
  * @wq: the waitqueue to wait on
@@ -634,14 +594,13 @@ do {									\
  * The function will return -ERESTARTSYS if it was interrupted by a
  * signal and 0 if @condition evaluated to true.
  */
-#define wait_event_killable(wq, condition)				\
-({									\
-	int __ret = 0;							\
-	if (!(condition))						\
-		__wait_event_killable(wq, condition, __ret);		\
-	__ret;								\
-})
+#define __wait_event_killable(wq, condition)				\
+	__wait_event_common(wq, condition,				\
+			TASK_KILLABLE, MAX_SCHEDULE_TIMEOUT)
 
+#define wait_event_killable(wq, condition)				\
+	wait_event_common(wq, condition,				\
+			TASK_KILLABLE, MAX_SCHEDULE_TIMEOUT)
 
 #define __wait_event_lock_irq(wq, condition, lock, cmd)			\
 do {									\

