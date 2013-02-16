Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab3BPJxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 04:53:54 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:53233 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3BPJxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 04:53:46 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/5] lockdep: check that no locks held at freeze time
Date: Sat, 16 Feb 2013 01:53:23 -0800
Message-Id: <1361008406-2307-2-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1361008406-2307-1-git-send-email-msb@chromium.org>
References: <1361008406-2307-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't try_to_freeze if locks are held. Verified that
I get no lockdep warnings after applying this patch and
"vfork: don't freezer_count() for in-kernel users of CLONE_VFORK".

Changes since v1:
* LKML: <20130215111635.GA26955@gmail.com> Ingo Molnar
  * Added a msg string that gets passed in.
* LKML: <20130215154449.GD30829@redhat.com> Oleg Nesterov
  * Check PF_NOFREEZE in try_to_freeze().

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Ingo Molnar <mingo@redhat.com>
---
 include/linux/debug_locks.h |  5 +++--
 include/linux/freezer.h     |  4 ++++
 kernel/exit.c               |  2 +-
 kernel/lockdep.c            | 12 ++++++------
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 3bd46f7..e6c3c85 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -51,7 +51,8 @@ struct task_struct;
 extern void debug_show_all_locks(void);
 extern void debug_show_held_locks(struct task_struct *task);
 extern void debug_check_no_locks_freed(const void *from, unsigned long len);
-extern void debug_check_no_locks_held(struct task_struct *task);
+extern void debug_check_no_locks_held(struct task_struct *task,
+				      const char *msg);
 #else
 static inline void debug_show_all_locks(void)
 {
@@ -67,7 +68,7 @@ debug_check_no_locks_freed(const void *from, unsigned long len)
 }
 
 static inline void
-debug_check_no_locks_held(struct task_struct *task)
+debug_check_no_locks_held(struct task_struct *task, const char *msg)
 {
 }
 #endif
diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index e4238ce..e6f8256 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -3,6 +3,7 @@
 #ifndef FREEZER_H_INCLUDED
 #define FREEZER_H_INCLUDED
 
+#include <linux/debug_locks.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
@@ -43,6 +44,9 @@ extern void thaw_kernel_threads(void);
 
 static inline bool try_to_freeze(void)
 {
+	if (current->flags & PF_NOFREEZE)
+		return false;
+	debug_check_no_locks_held(current, "lock held while trying to freeze");
 	might_sleep();
 	if (likely(!freezing(current)))
 		return false;
diff --git a/kernel/exit.c b/kernel/exit.c
index b4df219..88a706c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -833,7 +833,7 @@ void do_exit(long code)
 	/*
 	 * Make sure we are holding no locks:
 	 */
-	debug_check_no_locks_held(tsk);
+	debug_check_no_locks_held(tsk, "lock held at task exit time");
 	/*
 	 * We can do this unlocked here. The futex code uses this flag
 	 * just to verify whether the pi state cleanup has been done
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 7981e5b..2d4cfbf 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -4083,7 +4083,7 @@ void debug_check_no_locks_freed(const void *mem_from, unsigned long mem_len)
 }
 EXPORT_SYMBOL_GPL(debug_check_no_locks_freed);
 
-static void print_held_locks_bug(struct task_struct *curr)
+static void print_held_locks_bug(struct task_struct *curr, const char *msg)
 {
 	if (!debug_locks_off())
 		return;
@@ -4091,10 +4091,10 @@ static void print_held_locks_bug(struct task_struct *curr)
 		return;
 
 	printk("\n");
-	printk("=====================================\n");
-	printk("[ BUG: lock held at task exit time! ]\n");
+	printk("=======================================\n");
+	printk("[ BUG: %s! ]\n", msg);
 	print_kernel_ident();
-	printk("-------------------------------------\n");
+	printk("---------------------------------------\n");
 	printk("%s/%d is exiting with locks still held!\n",
 		curr->comm, task_pid_nr(curr));
 	lockdep_print_held_locks(curr);
@@ -4103,10 +4103,10 @@ static void print_held_locks_bug(struct task_struct *curr)
 	dump_stack();
 }
 
-void debug_check_no_locks_held(struct task_struct *task)
+void debug_check_no_locks_held(struct task_struct *task, const char *msg)
 {
 	if (unlikely(task->lockdep_depth > 0))
-		print_held_locks_bug(task);
+		print_held_locks_bug(task, msg);
 }
 
 void debug_show_all_locks(void)
-- 
1.7.12.4

