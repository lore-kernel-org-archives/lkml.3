Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaKDQJC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:09:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59384 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaKDQI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:08:56 -0500
Date: Tue, 4 Nov 2014 08:08:15 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-d86fz1jmso9wjxa8jfpinp8o@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        hpa@zytor.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, pavel@ucw.cz, len.brown@intel.com
Reply-To: pavel@ucw.cz, len.brown@intel.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org, rjw@rjwysocki.net, hpa@zytor.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Reimplement wait_event_freezable()
Git-Commit-ID: 36df04bc5273a046f53b5e359febc1225f85aa7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36df04bc5273a046f53b5e359febc1225f85aa7b
Gitweb:     http://git.kernel.org/tip/36df04bc5273a046f53b5e359febc1225f85aa7b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 29 Oct 2014 12:21:57 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:45 +0100

sched/wait: Reimplement wait_event_freezable()

Provide better implementations of wait_event_freezable() APIs.

The problem is with freezer_do_not_count(), it hides the thread from
the freezer, even though this thread might not actually freeze/sleep
at all.

Cc: oleg@redhat.com
Cc: Rafael Wysocki <rjw@rjwysocki.net>

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: linux-pm@vger.kernel.org
Link: http://lkml.kernel.org/n/tip-d86fz1jmso9wjxa8jfpinp8o@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/freezer.h | 38 ---------------------------------
 include/linux/wait.h    | 57 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 38 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 7fd81b8..e203665 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -265,35 +265,6 @@ static inline int freezable_schedule_hrtimeout_range(ktime_t *expires,
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
@@ -331,15 +302,6 @@ static inline void set_freezable(void) {}
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
 
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 0421775..2232ed1 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -267,6 +267,31 @@ do {									\
 	__wait_event(wq, condition);					\
 } while (0)
 
+#define __wait_event_freezable(wq, condition)				\
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,		\
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
+({									\
+	int __ret = 0;							\
+	might_sleep();							\
+	if (!(condition))						\
+		__ret = __wait_event_freezable(wq, condition);		\
+	__ret;								\
+})
+
 #define __wait_event_timeout(wq, condition, timeout)			\
 	___wait_event(wq, ___wait_cond_timeout(condition),		\
 		      TASK_UNINTERRUPTIBLE, 0, timeout,			\
@@ -300,6 +325,24 @@ do {									\
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
@@ -480,6 +523,20 @@ do {									\
 })
 
 
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
+
 #define __wait_event_interruptible_locked(wq, condition, exclusive, irq) \
 ({									\
 	int __ret = 0;							\
