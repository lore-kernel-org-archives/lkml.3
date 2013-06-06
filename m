Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab3FFUI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:08:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab3FFUIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:08:24 -0400
Date: Thu, 6 Jun 2013 22:03:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>, Imre Deak <imre.deak@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Czerner <lczerner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] wait: introduce wait_event_common(wq, condition,
	state, timeout)
Message-ID: <20130606200316.GB23628@redhat.com>
References: <20130606200257.GA23628@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606200257.GA23628@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. wait_event_timeout(wq, true, 0) returns zero, I think this is
   wrong and should be fixed.

   __wait_event_timeout() was already changed by 4c663cfc but we
   need the same logic in wait_event_timeout() if the fast-path
   check succeeds.

2. wait_event_timeout/__wait_event_timeout interface do not match
   wait_event(), you can't use __wait_event_timeout() instead of
   wait_event_timeout() if you do not need the fast-path check.

3. wait_event_* macros duplicate the same code.

This patch adds a single helper wait_event_common() which hopefully
does everything right. Compiler optimizes out the "dead" code when
we do not need signal_pending/schedule_timeout.

With this patch "size vmlinux" reports that .text/data shrinks but
I think this depends on gcc/config.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
---
 include/linux/wait.h |  181 +++++++++++++++++++------------------------------
 1 files changed, 70 insertions(+), 111 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 1133695..392c54d 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -173,18 +173,52 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 #define wake_up_interruptible_sync_poll(x, m)				\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
-#define __wait_event(wq, condition) 					\
-do {									\
+#define __wait_no_timeout(tout)	\
+	(__builtin_constant_p(tout) && (tout) == MAX_SCHEDULE_TIMEOUT)
+
+/* uglified signal_pending_state() optimized for constant state */
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
-- 
1.5.5.1


