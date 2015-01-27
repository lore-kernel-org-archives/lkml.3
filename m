Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbbA0Xwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:52:51 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58684 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbA0Xwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:52:45 -0500
From: Slava Pestov <sp@datera.io>
X-Google-Original-From: Slava Pestov <sp@daterainc.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, kmo@daterainc.com,
        Slava Pestov <sp@daterainc.com>
Subject: [PATCH] taint on lockdep warning with new TAINT_LOCKDEP
Date: Tue, 27 Jan 2015 15:52:25 -0800
Message-Id: <1422402745-8791-1-git-send-email-sp@daterainc.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter and Ingo,

Something like this seems like it would be a useful addition. I've heard
a few people mention that lockdep taints the kernel and even seen it come
up in mailing list posts, but this does not appear to be the case.

This patch adds a new taint flag. I'm using a similar patch on 3.14 here
at Datera, but I haven't verified the below version. It seemed to apply
without problems and compile. I hope I didn't miss anything obvious.

Slava

Change-Id: I482ad5470c7e24fc9fcdc17d9ea9f72d263f5261
---
 include/linux/kernel.h   |  1 +
 kernel/locking/lockdep.c | 31 +++++++++++++++++++++++++++++++
 kernel/panic.c           |  2 ++
 3 files changed, 34 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 5449d2f..c46e24e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -471,6 +471,7 @@ extern enum system_states {
 #define TAINT_OOT_MODULE		12
 #define TAINT_UNSIGNED_MODULE		13
 #define TAINT_SOFTLOCKUP		14
+#define TAINT_LOCKDEP			15
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 88d0d44..4916a32 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -382,6 +382,8 @@ static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
 
 static void print_lockdep_off(const char *bug_msg)
 {
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk(KERN_DEBUG "%s\n", bug_msg);
 	printk(KERN_DEBUG "turning off the locking correctness validator.\n");
 #ifdef CONFIG_LOCK_STAT
@@ -739,6 +741,9 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
  	 */
 	if (!static_obj(lock->key)) {
 		debug_locks_off();
+
+		add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 		printk("INFO: trying to register non-static key.\n");
 		printk("the code is fine but needs lockdep annotation.\n");
 		printk("turning off the locking correctness validator.\n");
@@ -1190,6 +1195,8 @@ static noinline int print_circular_bug(struct lock_list *this,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	if (!save_trace(&this->trace))
 		return 0;
 
@@ -1492,6 +1499,8 @@ print_bad_irq_dependency(struct task_struct *curr,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("======================================================\n");
 	printk("[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
@@ -1722,6 +1731,8 @@ print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=============================================\n");
 	printk("[ INFO: possible recursive locking detected ]\n");
@@ -2226,6 +2237,8 @@ print_usage_bug(struct task_struct *curr, struct held_lock *this,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=================================\n");
 	printk("[ INFO: inconsistent lock state ]\n");
@@ -2291,6 +2304,8 @@ print_irq_inversion_bug(struct task_struct *curr,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=========================================================\n");
 	printk("[ INFO: possible irq lock inversion dependency detected ]\n");
@@ -3014,6 +3029,8 @@ print_lock_nested_lock_not_held(struct task_struct *curr,
 	if (debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("==================================\n");
 	printk("[ BUG: Nested lock was not taken ]\n");
@@ -3219,6 +3236,8 @@ print_unlock_imbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
 	if (debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=====================================\n");
 	printk("[ BUG: bad unlock balance detected! ]\n");
@@ -3664,6 +3683,8 @@ print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
 	if (debug_locks_silent)
 		return 0;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=================================\n");
 	printk("[ BUG: bad contention detected! ]\n");
@@ -4040,6 +4061,8 @@ print_freed_lock_bug(struct task_struct *curr, const void *mem_from,
 	if (debug_locks_silent)
 		return;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=========================\n");
 	printk("[ BUG: held lock freed! ]\n");
@@ -4098,6 +4121,8 @@ static void print_held_locks_bug(void)
 	if (debug_locks_silent)
 		return;
 
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	printk("\n");
 	printk("=====================================\n");
 	printk("[ BUG: %s/%d still has locks held! ]\n",
@@ -4197,6 +4222,9 @@ asmlinkage __visible void lockdep_sys_exit(void)
 	if (unlikely(curr->lockdep_depth)) {
 		if (!debug_locks_off())
 			return;
+
+		add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 		printk("\n");
 		printk("================================================\n");
 		printk("[ BUG: lock held when returning to user space! ]\n");
@@ -4216,6 +4244,9 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	if (!debug_locks_off())
 		return;
 #endif /* #ifdef CONFIG_PROVE_RCU_REPEATEDLY */
+
+	add_taint(TAINT_LOCKDEP, LOCKDEP_NOW_UNRELIABLE);
+
 	/* Note: the following can be executed concurrently, so be careful. */
 	printk("\n");
 	printk("===============================\n");
diff --git a/kernel/panic.c b/kernel/panic.c
index 4d8d6f9..7bd42ba 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -226,6 +226,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_OOT_MODULE,		'O', ' ' },
 	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
 	{ TAINT_SOFTLOCKUP,		'L', ' ' },
+	{ TAINT_LOCKDEP,		'K', ' ' },
 };
 
 /**
@@ -246,6 +247,7 @@ static const struct tnt tnts[] = {
  *  'O' - Out-of-tree module has been loaded.
  *  'E' - Unsigned module has been loaded.
  *  'L' - A soft lockup has previously occurred.
+ *  'K' - Lockdep warning was generated.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
-- 
2.1.3

