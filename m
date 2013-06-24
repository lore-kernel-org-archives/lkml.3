Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3FXPug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:50:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab3FXPud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:50:33 -0400
Date: Mon, 24 Jun 2013 17:44:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Imre Deak <imre.deak@intel.com>,
        Julian Anastasov <ja@ssi.bg>, Lukas Czerner <lczerner@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, Samuel Ortiz <samuel@sortiz.org>,
        Simon Horman <horms@verge.net.au>, Tejun Heo <tj@kernel.org>,
        Wensong Zhang <wensong@linux-vs.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] wait: introduce wait_event_common(wq, condition,
	state, timeout)
Message-ID: <20130624154418.GA29750@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624154356.GA29728@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. 4c663cfc "fix false timeouts when using wait_event_timeout()"
   is not enough, wait(wq, true, 0) still returns zero.

   __wait_event_timeout() was already fixed but we need the same
   logic in wait_event_timeout() if the fast-path check succeeds.

2. wait_event_timeout/__wait_event_timeout interface do not match
   wait_event(), you can't use __wait_event_timeout() instead of
   wait_event_timeout() if you do not need the fast-path check.

   Same for wait_event_interruptible/__wait_event_interruptible,
   so this patch cleanups rtlx.c, ip_vs_sync.c, and af_irda.c:

	-	__wait_event_interruptible(wq, cond, ret);
	+	ret = __wait_event_interruptible(wq, cond);

3. wait_event_* macros duplicate the same code.

This patch adds a single helper wait_event_common() which hopefully
does everything right. Compiler optimizes out the "dead" code when
we do not need signal_pending/schedule_timeout.

"size vmlinux" reports:

		   text	   data	    bss	    dec	    hex	filename
	-	4978601	2935080	10104832	18018513	112f0d1	vmlinux
	+	4977769	2930984	10104832	18013585	112dd91	vmlinux

but I think this depends on gcc/config.

In particular, wait_even_timeout(true, non_const_timeout) should
generate more code in the non-void context because the patch adds
the additional code to fix the 1st problem.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: Wensong Zhang <wensong@linux-vs.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/kernel/rtlx.c         |   17 ++--
 include/linux/wait.h            |  181 +++++++++++++++------------------------
 net/irda/af_irda.c              |    5 +-
 net/netfilter/ipvs/ip_vs_sync.c |    5 +-
 4 files changed, 81 insertions(+), 127 deletions(-)

diff --git a/arch/mips/kernel/rtlx.c b/arch/mips/kernel/rtlx.c
index 6fa198d..5f11ff6 100644
--- a/arch/mips/kernel/rtlx.c
+++ b/arch/mips/kernel/rtlx.c
@@ -172,8 +172,8 @@ int rtlx_open(int index, int can_sleep)
 	if (rtlx == NULL) {
 		if( (p = vpe_get_shared(tclimit)) == NULL) {
 		    if (can_sleep) {
-			__wait_event_interruptible(channel_wqs[index].lx_queue,
-				(p = vpe_get_shared(tclimit)), ret);
+			ret = __wait_event_interruptible(channel_wqs[index].lx_queue,
+				(p = vpe_get_shared(tclimit)));
 			if (ret)
 				goto out_fail;
 		    } else {
@@ -263,11 +263,11 @@ unsigned int rtlx_read_poll(int index, int can_sleep)
 	/* data available to read? */
 	if (chan->lx_read == chan->lx_write) {
 		if (can_sleep) {
-			int ret = 0;
+			int ret;
 
-			__wait_event_interruptible(channel_wqs[index].lx_queue,
+			ret = __wait_event_interruptible(channel_wqs[index].lx_queue,
 				(chan->lx_read != chan->lx_write) ||
-				sp_stopping, ret);
+				sp_stopping);
 			if (ret)
 				return ret;
 
@@ -441,14 +441,13 @@ static ssize_t file_write(struct file *file, const char __user * buffer,
 
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
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 1133695..6b78045 100644
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
+#define __wait_event(wq, condition)					\
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
+#define wait_event(wq, condition)					\
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
diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index 0578d4f..0f67690 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -2563,9 +2563,8 @@ bed:
 				  jiffies + msecs_to_jiffies(val));
 
 			/* Wait for IR-LMP to call us back */
-			__wait_event_interruptible(self->query_wait,
-			      (self->cachedaddr != 0 || self->errno == -ETIME),
-						   err);
+			err = __wait_event_interruptible(self->query_wait,
+			      (self->cachedaddr != 0 || self->errno == -ETIME));
 
 			/* If watchdog is still activated, kill it! */
 			del_timer(&(self->watchdog));
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index f6046d9..ce4239e 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1624,12 +1624,9 @@ static int sync_thread_master(void *data)
 			continue;
 		}
 		while (ip_vs_send_sync_msg(tinfo->sock, sb->mesg) < 0) {
-			int ret = 0;
-
 			__wait_event_interruptible(*sk_sleep(sk),
 						   sock_writeable(sk) ||
-						   kthread_should_stop(),
-						   ret);
+						   kthread_should_stop());
 			if (unlikely(kthread_should_stop()))
 				goto done;
 		}
-- 
1.5.5.1

