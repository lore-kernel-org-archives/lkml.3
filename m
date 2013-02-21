Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab3BUDRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 22:17:19 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55898 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3BUDRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 22:17:18 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH v5] lockdep: check that no locks held at freeze time
Date: Wed, 20 Feb 2013 19:17:07 -0800
Message-Id: <1361416627-17976-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <20130220152446.a65ff84f.akpm@linux-foundation.org>
References: <20130220152446.a65ff84f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't try_to_freeze if locks are held.

Changes since v1:
* LKML: <20130215111635.GA26955@gmail.com> Ingo Molnar
  * Added a msg string that gets passed in.
* LKML: <20130215154449.GD30829@redhat.com> Oleg Nesterov
  * Check PF_NOFREEZE in try_to_freeze().
Changes since v2:
* LKML: <20130216170605.GC4910@redhat.com> Oleg Nesterovw
  * Avoid unnecessary PF_NOFREEZE check when !CONFIG_LOCKDEP.
* Mandeep Singh Baines
  * Generalize an exit specific printk.
Changes since v3:
* LKML: <20130220223013.GA15760@redhat.com> Oleg Nesterovw
  * Remove stale vfork comment from commit message.
Changes since v4:
* LKML: <20130220152446.a65ff84f.akpm@linux-foundation.org> Andrew Morton
  * Remove tsk param since tsk is always current.
  * Remove msg param, dump_stack() should tell us all we need to know.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/debug_locks.h |  4 ++--
 include/linux/freezer.h     |  3 +++
 kernel/exit.c               |  2 +-
 kernel/lockdep.c            | 16 +++++++---------
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 3bd46f7..a975de1 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -51,7 +51,7 @@ struct task_struct;
 extern void debug_show_all_locks(void);
 extern void debug_show_held_locks(struct task_struct *task);
 extern void debug_check_no_locks_freed(const void *from, unsigned long len);
-extern void debug_check_no_locks_held(struct task_struct *task);
+extern void debug_check_no_locks_held(void);
 #else
 static inline void debug_show_all_locks(void)
 {
@@ -67,7 +67,7 @@ debug_check_no_locks_freed(const void *from, unsigned long len)
 }
 
 static inline void
-debug_check_no_locks_held(struct task_struct *task)
+debug_check_no_locks_held(void)
 {
 }
 #endif
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index e4238ce..c5bd118 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -3,6 +3,7 @@
 #ifndef FREEZER_H_INCLUDED
 #define FREEZER_H_INCLUDED
 
+#include <linux/debug_locks.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
@@ -43,6 +44,8 @@ extern void thaw_kernel_threads(void);
 
 static inline bool try_to_freeze(void)
 {
+	if (!(current->flags & PF_NOFREEZE))
+		debug_check_no_locks_held();
 	might_sleep();
 	if (likely(!freezing(current)))
 		return false;
diff --git a/kernel/exit.c b/kernel/exit.c
index b4df219..aff5bdb 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -833,7 +833,7 @@ void do_exit(long code)
 	/*
 	 * Make sure we are holding no locks:
 	 */
-	debug_check_no_locks_held(tsk);
+	debug_check_no_locks_held();
 	/*
 	 * We can do this unlocked here. The futex code uses this flag
 	 * just to verify whether the pi state cleanup has been done
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 7981e5b..8e28f56 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4083,7 +4083,7 @@ void debug_check_no_locks_freed(const void *mem_from, unsigned long mem_len)
 }
 EXPORT_SYMBOL_GPL(debug_check_no_locks_freed);
 
-static void print_held_locks_bug(struct task_struct *curr)
+static void print_held_locks_bug(void)
 {
 	if (!debug_locks_off())
 		return;
@@ -4092,21 +4092,19 @@ static void print_held_locks_bug(struct task_struct *curr)
 
 	printk("\n");
 	printk("=====================================\n");
-	printk("[ BUG: lock held at task exit time! ]\n");
+	printk("[ BUG: %s/%d still has locks held! ]\n",
+	       current->comm, task_pid_nr(current));
 	print_kernel_ident();
 	printk("-------------------------------------\n");
-	printk("%s/%d is exiting with locks still held!\n",
-		curr->comm, task_pid_nr(curr));
-	lockdep_print_held_locks(curr);
-
+	lockdep_print_held_locks(current);
 	printk("\nstack backtrace:\n");
 	dump_stack();
 }
 
-void debug_check_no_locks_held(struct task_struct *task)
+void debug_check_no_locks_held(void)
 {
-	if (unlikely(task->lockdep_depth > 0))
-		print_held_locks_bug(task);
+	if (unlikely(current->lockdep_depth > 0))
+		print_held_locks_bug();
 }
 
 void debug_show_all_locks(void)
-- 
1.7.12.4

