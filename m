Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3FXPuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:50:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab3FXPuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:50:39 -0400
Date: Mon, 24 Jun 2013 17:44:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Imre Deak <imre.deak@intel.com>,
        Julian Anastasov <ja@ssi.bg>, Lukas Czerner <lczerner@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, Samuel Ortiz <samuel@sortiz.org>,
        Simon Horman <horms@verge.net.au>, Tejun Heo <tj@kernel.org>,
        Wensong Zhang <wensong@linux-vs.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] wait: introduce prepare_to_wait_event()
Message-ID: <20130624154422.GA29753@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624154356.GA29728@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new helper, prepare_to_wait_event() which should only be used by
wait_event_common/etc.

prepare_to_wait_event() returns -ERESTARTSYS if signal_pending_state() is
true, otherwise it calls prepare_to_wait().  This allows to uninline the
signal-pending checks in wait_event_*.

Also, it can initialize wait->private/func.  We do not care they were
already initialized, the values are the same.  This also shaves a couple
of insns from the inlined code.

Unlike the previous change, this patch "reliably" shrinks the size of
generated code for every wait_event*() call,

	-	4977769 2930984 10104832        18013585        112dd91 vmlinux
	+	4976847	2930984	10104832	18012663	112d9f7	vmlinux

on my build.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Lukas Czerner <lczerner@redhat.com>
---
 include/linux/wait.h |   22 +++++++++++-----------
 kernel/wait.c        |   13 +++++++++++++
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6b78045..6e0fe54 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -176,28 +176,27 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 #define __wait_no_timeout(tout)	\
 	(__builtin_constant_p(tout) && (tout) == MAX_SCHEDULE_TIMEOUT)
 
-/* uglified signal_pending_state() optimized for constant state */
-#define __wait_signal_pending(state)					\
-	((state == TASK_INTERRUPTIBLE) ? signal_pending(current) :	\
-	 (state == TASK_KILLABLE) ? fatal_signal_pending(current) :	\
-	  0)
+#define __wait_interruptible(state)					\
+	(!__builtin_constant_p(state) ||				\
+		state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)
 
 #define __wait_event_common(wq, condition, state, tout)			\
 ({									\
-	DEFINE_WAIT(__wait);						\
-	long __ret = 0, __tout = tout;					\
+	long __ret, __tout = tout;					\
+	wait_queue_t __wait;						\
+									\
+	INIT_LIST_HEAD(&__wait.task_list);				\
+	__wait.flags = 0;						\
 									\
 	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, state);			\
+		__ret = prepare_to_wait_event(&wq, &__wait, state);	\
 		if (condition) {					\
 			__ret = __wait_no_timeout(tout) ?: __tout ?: 1;	\
 			break;						\
 		}							\
 									\
-		if (__wait_signal_pending(state)) {			\
-			__ret = -ERESTARTSYS;				\
+		if (__wait_interruptible(state) && __ret)		\
 			break;						\
-		}							\
 									\
 		if (__wait_no_timeout(tout))				\
 			schedule();					\
@@ -781,6 +780,7 @@ extern long interruptible_sleep_on_timeout(wait_queue_head_t *q,
  * Waitqueues which are removed from the waitqueue_head at wakeup time
  */
 void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);
+int prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
 void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
diff --git a/kernel/wait.c b/kernel/wait.c
index 6698e0c..3b8619a 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -78,6 +78,19 @@ prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
 }
 EXPORT_SYMBOL(prepare_to_wait);
 
+int prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
+{
+	if (signal_pending_state(state, current))
+		return -ERESTARTSYS;
+
+	wait->private = current;
+	wait->func = autoremove_wake_function;
+	prepare_to_wait(q, wait, state);
+
+	return 0;
+}
+EXPORT_SYMBOL(prepare_to_wait_event);
+
 void
 prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
-- 
1.5.5.1

