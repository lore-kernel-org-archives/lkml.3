Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab3D2Vpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:45:52 -0400
Received: from mail-gg0-f201.google.com ([209.85.161.201]:59428 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3D2Vpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:45:50 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, Colin Cross <ccross@android.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 03/10] freezer: add new freezable helpers using freezer_do_not_count()
Date: Mon, 29 Apr 2013 14:45:39 -0700
Message-Id: <1367271946-7239-4-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367271946-7239-1-git-send-email-ccross@android.com>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freezing tasks will wake up almost every userspace task from
where it is blocking and force it to run until it hits a
call to try_to_sleep(), generally on the exit path from the syscall
it is blocking in.  On resume each task will run again, usually
restarting the syscall and running until it hits the same
blocking call as it was originally blocked in.

To allow tasks to avoid running on every suspend/resume cycle,
this patch adds additional freezable wrappers around blocking calls
that call freezer_do_not_count().  Combined with the previous patch,
these tasks will not run during suspend or resume unless they wake
up for another reason, in which case they will run until they hit
the try_to_freeze() in freezer_count(), and then continue processing
the wakeup after tasks are thawed.  This patch also converts the
existing wait_event_freezable* wrappers to use freezer_do_not_count().

Additional patches will convert the most common locations that
userspace blocks in to use freezable helpers.

Signed-off-by: Colin Cross <ccross@android.com>
---
 include/linux/freezer.h | 72 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 58 insertions(+), 14 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index e70df40..b239f45 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -152,6 +152,26 @@ static inline bool freezer_should_skip(struct task_struct *p)
 	freezer_count();						\
 })
 
+/* Like schedule_timeout(), but should not block the freezer. */
+#define freezable_schedule_timeout(timeout)				\
+({									\
+	long __retval;							\
+	freezer_do_not_count();						\
+	__retval = schedule_timeout(timeout);				\
+	freezer_count();						\
+	__retval;							\
+})
+
+/* Like schedule_timeout_interruptible(), but should not block the freezer. */
+#define freezable_schedule_timeout_interruptible(timeout)		\
+({									\
+	long __retval;							\
+	freezer_do_not_count();						\
+	__retval = schedule_timeout_interruptible(timeout);		\
+	freezer_count();						\
+	__retval;							\
+})
+
 /* Like schedule_timeout_killable(), but should not block the freezer. */
 #define freezable_schedule_timeout_killable(timeout)			\
 ({									\
@@ -162,6 +182,17 @@ static inline bool freezer_should_skip(struct task_struct *p)
 	__retval;							\
 })
 
+/* Like schedule_hrtimeout_range(), but should not block the freezer. */
+#define freezable_schedule_hrtimeout_range(expires, delta, mode)	\
+({									\
+	int __retval;							\
+	freezer_do_not_count();						\
+	__retval = schedule_hrtimeout_range(expires, delta, mode);	\
+	freezer_count();						\
+	__retval;							\
+})
+
+
 /*
  * Freezer-friendly wrappers around wait_event_interruptible(),
  * wait_event_killable() and wait_event_interruptible_timeout(), originally
@@ -180,30 +211,32 @@ static inline bool freezer_should_skip(struct task_struct *p)
 #define wait_event_freezable(wq, condition)				\
 ({									\
 	int __retval;							\
-	for (;;) {							\
-		__retval = wait_event_interruptible(wq, 		\
-				(condition) || freezing(current));	\
-		if (__retval || (condition))				\
-			break;						\
-		try_to_freeze();					\
-	}								\
+	freezer_do_not_count();						\
+	__retval = wait_event_interruptible(wq, (condition));		\
+	freezer_count();						\
 	__retval;							\
 })
 
 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 ({									\
 	long __retval = timeout;					\
-	for (;;) {							\
-		__retval = wait_event_interruptible_timeout(wq,		\
-				(condition) || freezing(current),	\
+	freezer_do_not_count();						\
+	__retval = wait_event_interruptible_timeout(wq,	(condition),	\
 				__retval); 				\
-		if (__retval <= 0 || (condition))			\
-			break;						\
-		try_to_freeze();					\
-	}								\
+	freezer_count();						\
 	__retval;							\
 })
 
+#define wait_event_freezable_exclusive(wq, condition)		\
+({									\
+	int __retval;							\
+	freezer_do_not_count();						\
+	__retval = wait_event_interruptible_exclusive(wq, condition);	\
+	freezer_count();						\
+	__retval;							\
+})
+
+
 #else /* !CONFIG_FREEZER */
 static inline bool frozen(struct task_struct *p) { return false; }
 static inline bool freezing(struct task_struct *p) { return false; }
@@ -225,15 +258,26 @@ static inline void set_freezable(void) {}
 
 #define freezable_schedule()  schedule()
 
+#define freezable_schedule_timeout(timeout)  schedule_timeout(timeout)
+
+#define freezable_schedule_timeout_interruptible(timeout)		\
+	schedule_timeout_interruptible(timeout)
+
 #define freezable_schedule_timeout_killable(timeout)			\
 	schedule_timeout_killable(timeout)
 
+#define freezable_schedule_hrtimeout_range(expires, delta, mode)	\
+	schedule_hrtimeout_range(expires, delta, mode)
+
 #define wait_event_freezable(wq, condition)				\
 		wait_event_interruptible(wq, condition)
 
 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 		wait_event_interruptible_timeout(wq, condition, timeout)
 
+#define wait_event_freezable_exclusive(wq, condition)			\
+		wait_event_interruptible_exclusive(wq, condition)
+
 #define wait_event_freezekillable(wq, condition)		\
 		wait_event_killable(wq, condition)
 
-- 
1.8.2.1

