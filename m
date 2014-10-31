Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbaJaLVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:21:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758909AbaJaLVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:21:44 -0400
Message-Id: <20141031111549.551132563@infradead.org>
User-Agent: quilt/0.61-1
Date: Fri, 31 Oct 2014 12:10:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: peter@hurleysoftware.com, oleg@redhat.com, rjw@rjwysocki.net,
        torvalds@linux-foundation.org, tglx@linutronix.de, eparis@redhat.com,
        umgwanakikbuti@gmail.com, marcel@holtmann.org, ebiederm@xmission.com,
        davem@davemloft.net, fengguang.wu@intel.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/7] wait: Reimplement wait_event_freezable()
References: <20141031111037.936236584@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-wait-freezable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide better implementations of wait_event_freezable() APIs.

The problem is with freezer_do_not_count(), it hides the thread from
the freezer, even though this thread might not actually freeze/sleep
at all.

Cc: oleg@redhat.com
Cc: Rafael Wysocki <rjw@rjwysocki.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/freezer.h |   38 --------------------------------
 include/linux/wait.h    |   56 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 38 deletions(-)

--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -265,35 +265,6 @@ static inline int freezable_schedule_hrt
 	__retval;							\
 })
 
-#define wait_event_freezable(wq, condition)				\
-({									\
-	int __retval;							\
-	freezer_do_not_count();						\
-	__retval = wait_event_interruptible(wq, (condition));		\
-	freezer_count();						\
-	__retval;							\
-})
-
-#define wait_event_freezable_timeout(wq, condition, timeout)		\
-({									\
-	long __retval = timeout;					\
-	freezer_do_not_count();						\
-	__retval = wait_event_interruptible_timeout(wq,	(condition),	\
-				__retval);				\
-	freezer_count();						\
-	__retval;							\
-})
-
-#define wait_event_freezable_exclusive(wq, condition)			\
-({									\
-	int __retval;							\
-	freezer_do_not_count();						\
-	__retval = wait_event_interruptible_exclusive(wq, condition);	\
-	freezer_count();						\
-	__retval;							\
-})
-
-
 #else /* !CONFIG_FREEZER */
 static inline bool frozen(struct task_struct *p) { return false; }
 static inline bool freezing(struct task_struct *p) { return false; }
@@ -331,15 +302,6 @@ static inline void set_freezable(void) {
 #define freezable_schedule_hrtimeout_range(expires, delta, mode)	\
 	schedule_hrtimeout_range(expires, delta, mode)
 
-#define wait_event_freezable(wq, condition)				\
-		wait_event_interruptible(wq, condition)
-
-#define wait_event_freezable_timeout(wq, condition, timeout)		\
-		wait_event_interruptible_timeout(wq, condition, timeout)
-
-#define wait_event_freezable_exclusive(wq, condition)			\
-		wait_event_interruptible_exclusive(wq, condition)
-
 #define wait_event_freezekillable(wq, condition)		\
 		wait_event_killable(wq, condition)
 
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -267,6 +267,30 @@ do {									\
 	__wait_event(wq, condition);					\
 } while (0)
 
+#define __wait_event_freezable(wq, condition)				\
+	(void)___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,	\
+			    schedule(); try_to_freeze())
+
+/**
+ * wait_event - sleep (or freeze) until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE -- so as not to contribute
+ * to system load) until the @condition evaluates to true. The
+ * @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define wait_event_freezable(wq, condition)				\
+do {									\
+	might_sleep();							\
+	if (condition)							\
+		break;							\
+	__wait_event_freezable(wq, condition);				\
+} while (0)
+
 #define __wait_event_timeout(wq, condition, timeout)			\
 	___wait_event(wq, ___wait_cond_timeout(condition),		\
 		      TASK_UNINTERRUPTIBLE, 0, timeout,			\
@@ -300,6 +324,24 @@ do {									\
 	__ret;								\
 })
 
+#define __wait_event_freezable_timeout(wq, condition, timeout)		\
+	___wait_event(wq, ___wait_cond_timeout(condition),		\
+		      TASK_INTERRUPTIBLE, 0, timeout,			\
+		      __ret = schedule_timeout(__ret); try_to_freeze())
+
+/*
+ * like wait_event_timeout() -- except it uses TASK_INTERRUPTIBLE to avoid
+ * increasing load and is freezable.
+ */
+#define wait_event_freezable_timeout(wq, condition, timeout)		\
+({									\
+	long __ret = timeout;						\
+	might_sleep();							\
+	if (!___wait_cond_timeout(condition))				\
+		__ret = __wait_event_freezable_timeout(wq, condition, timeout);	\
+	__ret;								\
+})
+
 #define __wait_event_cmd(wq, condition, cmd1, cmd2)			\
 	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
 			    cmd1; schedule(); cmd2)
@@ -479,6 +521,20 @@ do {									\
 	__ret;								\
 })
 
+
+#define __wait_event_freezable_exclusive(wq, condition)			\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 1, 0,		\
+			schedule(); try_to_freeze())
+
+#define wait_event_freezable_exclusive(wq, condition)			\
+({									\
+	int __ret = 0;							\
+	might_sleep();							\
+	if (!(condition))						\
+		__ret = __wait_event_freezable_exclusive(wq, condition);\
+	__ret;								\
+})
+
 
 #define __wait_event_interruptible_locked(wq, condition, exclusive, irq) \
 ({									\


