Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbaIKPot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:44:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbaIKPoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:44:07 -0400
From: Aaron Tomlin <atomlin@redhat.com>
To: peterz@infradead.org
Cc: mingo@redhat.com, mingo@kernel.com, dzickus@redhat.com, bmr@redhat.com,
        jcastillo@redhat.com, atomlin@redhat.com, oleg@redhat.com,
        pzijlstr@redhat.com, riel@redhat.com, prarit@redhat.com,
        jgh@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        x86@kernel.org, rostedt@goodmis.org, hannes@cmpxchg.org,
        aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org,
        akpm@google.com, linuxppc-dev@lists.ozlabs.org, minchan@kernel.org
Subject: [PATCH v3 1/3] init/main.c: Give init_task a canary
Date: Thu, 11 Sep 2014 16:41:26 +0100
Message-Id: <1410450088-18236-2-git-send-email-atomlin@redhat.com>
In-Reply-To: <1410450088-18236-1-git-send-email-atomlin@redhat.com>
References: <1410255749-2956-1-git-send-email-atomlin@redhat.com>
 <1410450088-18236-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tasks get their end of stack set to STACK_END_MAGIC with the
aim to catch stack overruns. Currently this feature does not
apply to init_task. This patch removes this restriction.

Note that a similar patch was posted by Prarit Bhargava [1]
some time ago but was never merged.

[1]: http://marc.info/?l=linux-kernel&m=127144305403241&w=2

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 arch/powerpc/mm/fault.c    |  3 +--
 arch/x86/mm/fault.c        |  3 +--
 include/linux/sched.h      |  2 ++
 init/main.c                |  1 +
 kernel/fork.c              | 12 +++++++++---
 kernel/trace/trace_stack.c |  4 +---
 6 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 51ab9e7..35d0760c 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -30,7 +30,6 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 #include <linux/perf_event.h>
-#include <linux/magic.h>
 #include <linux/ratelimit.h>
 #include <linux/context_tracking.h>
 
@@ -538,7 +537,7 @@ void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
 		regs->nip);
 
 	stackend = end_of_stack(current);
-	if (current != &init_task && *stackend != STACK_END_MAGIC)
+	if (*stackend != STACK_END_MAGIC)
 		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
 
 	die("Kernel access of bad area", regs, sig);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a241946..bc23a70 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -3,7 +3,6 @@
  *  Copyright (C) 2001, 2002 Andi Kleen, SuSE Labs.
  *  Copyright (C) 2008-2009, Red Hat Inc., Ingo Molnar
  */
-#include <linux/magic.h>		/* STACK_END_MAGIC		*/
 #include <linux/sched.h>		/* test_thread_flag(), ...	*/
 #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
 #include <linux/module.h>		/* search_exception_table	*/
@@ -710,7 +709,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	show_fault_oops(regs, error_code, address);
 
 	stackend = end_of_stack(tsk);
-	if (tsk != &init_task && *stackend != STACK_END_MAGIC)
+	if (*stackend != STACK_END_MAGIC)
 		printk(KERN_EMERG "Thread overran stack, or stack corrupted\n");
 
 	tsk->thread.cr2		= address;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..7ef34b7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -57,6 +57,7 @@ struct sched_param {
 #include <linux/llist.h>
 #include <linux/uidgid.h>
 #include <linux/gfp.h>
+#include <linux/magic.h>
 
 #include <asm/processor.h>
 
@@ -2636,6 +2637,7 @@ static inline unsigned long stack_not_used(struct task_struct *p)
 	return (unsigned long)n - (unsigned long)end_of_stack(p);
 }
 #endif
+extern void set_task_stack_end_magic(struct task_struct *tsk);
 
 /* set thread flags in other task's structures
  * - see asm/thread_info.h for TIF_xxxx flags available
diff --git a/init/main.c b/init/main.c
index bb1aed9..5fc3fc7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -508,6 +508,7 @@ asmlinkage __visible void __init start_kernel(void)
 	 * lockdep hash:
 	 */
 	lockdep_init();
+	set_task_stack_end_magic(&init_task);
 	smp_setup_processor_id();
 	debug_objects_early_init();
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 0cf9cdb..adf9583 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -294,11 +294,18 @@ int __weak arch_dup_task_struct(struct task_struct *dst,
 	return 0;
 }
 
+void set_task_stack_end_magic(struct task_struct *tsk)
+{
+	unsigned long *stackend;
+
+	stackend = end_of_stack(tsk);
+	*stackend = STACK_END_MAGIC;	/* for overflow detection */
+}
+
 static struct task_struct *dup_task_struct(struct task_struct *orig)
 {
 	struct task_struct *tsk;
 	struct thread_info *ti;
-	unsigned long *stackend;
 	int node = tsk_fork_get_node(orig);
 	int err;
 
@@ -328,8 +335,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
 	clear_tsk_need_resched(tsk);
-	stackend = end_of_stack(tsk);
-	*stackend = STACK_END_MAGIC;	/* for overflow detection */
+	set_task_stack_end_magic(tsk);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 	tsk->stack_canary = get_random_int();
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 8a4e5cb..1636e41 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -13,7 +13,6 @@
 #include <linux/sysctl.h>
 #include <linux/init.h>
 #include <linux/fs.h>
-#include <linux/magic.h>
 
 #include <asm/setup.h>
 
@@ -171,8 +170,7 @@ check_stack(unsigned long ip, unsigned long *stack)
 			i++;
 	}
 
-	if ((current != &init_task &&
-		*(end_of_stack(current)) != STACK_END_MAGIC)) {
+	if (*end_of_stack(current) != STACK_END_MAGIC) {
 		print_max_stack();
 		BUG();
 	}
-- 
1.9.3

