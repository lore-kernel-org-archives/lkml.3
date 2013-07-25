Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab3GYAmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 20:42:22 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:34770 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3GYAmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:42:19 -0400
From: Colin Cross <ccross@android.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Michael Leun <lkml20130126@newton.leun.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>, Colin Cross <ccross@android.com>
Subject: [PATCH] power: set PF_SUSPEND_TASK flag on tasks that call freeze_processes
Date: Wed, 24 Jul 2013 17:41:33 -0700
Message-Id: <1374712893-14487-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling freeze_processes sets a global flag that will cause any
process that calls try_to_freeze to enter the refrigerator.  It
skips sending a signal to the current task, but if the current
task ever hits try_to_freeze all threads will be frozen and the
system will deadlock.

Set a new flag, PF_SUSPEND_TASK, on the task that calls
freeze_processes.  The flag notifies the freezer that the thread
is involved in suspend and should not be frozen.  Also add a
WARN_ON in thaw_processes if the caller does not have the
PF_SUSPEND_TASK flag set to catch if a different task calls
thaw_processes than the one that called freeze_processes, leaving
a task with PF_SUSPEND_TASK permanently set on it.

Threads that spawn off a task with PF_SUSPEND_TASK set (which
swsusp does) will also have PF_SUSPEND_TASK set, preventing them
from freezing while they are helping with suspend, but they need
to be dead by the time suspend is triggered, otherwise they may
run when userspace is expected to be frozen.  Add a WARN_ON in
thaw_processes if more than one thread has the PF_SUSPEND_TASK
flag set.

Reported-by: Michael Leun <lkml20130126@newton.leun.net>
Tested-by: Michael Leun <lkml20130126@newton.leun.net>
Signed-off-by: Colin Cross <ccross@android.com>
---

Resending not as an attachment for review.

If the extra process flag is considered too precious for this
(there are only 2 left after this patch) I could get the
same functionality by having freeze_processes() reject calls
from a PF_KTHREAD|PF_NOFREEZE thread, and use PF_KTHREAD to
determine if PF_NOFREEZE should be cleared in thaw_processes().

 include/linux/sched.h  |  1 +
 kernel/freezer.c       |  2 +-
 kernel/power/process.c | 11 +++++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 50d04b9..d722490 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1628,6 +1628,7 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezable */
+#define PF_SUSPEND_TASK 0x80000000      /* this thread called freeze_processes and should not be frozen */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 8b2afc1..b462fa1 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -33,7 +33,7 @@ static DEFINE_SPINLOCK(freezer_lock);
  */
 bool freezing_slow_path(struct task_struct *p)
 {
-	if (p->flags & PF_NOFREEZE)
+	if (p->flags & (PF_NOFREEZE | PF_SUSPEND_TASK))
 		return false;
 
 	if (pm_nosig_freezing || cgroup_freezing(p))
diff --git a/kernel/power/process.c b/kernel/power/process.c
index fc0df84..06ec886 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -109,6 +109,8 @@ static int try_to_freeze_tasks(bool user_only)
 
 /**
  * freeze_processes - Signal user space processes to enter the refrigerator.
+ * The current thread will not be frozen.  The same process that calls
+ * freeze_processes must later call thaw_processes.
  *
  * On success, returns 0.  On failure, -errno and system is fully thawed.
  */
@@ -120,6 +122,9 @@ int freeze_processes(void)
 	if (error)
 		return error;
 
+	/* Make sure this task doesn't get frozen */
+	current->flags |= PF_SUSPEND_TASK;
+
 	if (!pm_freezing)
 		atomic_inc(&system_freezing_cnt);
 
@@ -168,6 +173,7 @@ int freeze_kernel_threads(void)
 void thaw_processes(void)
 {
 	struct task_struct *g, *p;
+	struct task_struct *curr = current;
 
 	if (pm_freezing)
 		atomic_dec(&system_freezing_cnt);
@@ -182,10 +188,15 @@ void thaw_processes(void)
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, p) {
+		/* No other threads should have PF_SUSPEND_TASK set */
+		WARN_ON((p != curr) && (p->flags & PF_SUSPEND_TASK));
 		__thaw_task(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 
+	WARN_ON(!(curr->flags & PF_SUSPEND_TASK));
+	curr->flags &= ~PF_SUSPEND_TASK;
+
 	usermodehelper_enable();
 
 	schedule();
-- 
1.8.3

