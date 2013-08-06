Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab3HGO64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:58:56 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60313 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260Ab3HGO6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:58:54 -0400
Message-ID: <201308071458.r77EwsSI013104@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 6 Aug 2013 16:10:23 -0400
Subject: [PATCH] tile: avoid recursive backtrace faults
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds support for avoiding recursive backtracer crashes;
we haven't seen this in practice other than when things are seriously
corrupt, but it may help avoid losing the root cause of a crash.

Also, don't abort kernel backtracers for invalid userspace PC's.
If we do, we lose the ability to backtrace through a userspace
call to a bad address above PAGE_OFFSET, even though that it can
be perfectly reasonable to continue the backtrace in such a case.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/processor.h |  2 ++
 arch/tile/kernel/stack.c          | 30 ++++++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index cda2724..fed1c04 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -110,6 +110,8 @@ struct thread_struct {
 	unsigned long long interrupt_mask;
 	/* User interrupt-control 0 state */
 	unsigned long intctrl_0;
+	/* Is this task currently doing a backtrace? */
+	bool in_backtrace;
 #if CHIP_HAS_PROC_STATUS_SPR()
 	/* Any other miscellaneous processor state bits */
 	unsigned long proc_status;
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index af8dfc9..c972689 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -103,8 +103,7 @@ static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
 		if (kbt->verbose)
 			pr_err("  <%s while in kernel mode>\n", fault);
 	} else if (EX1_PL(p->ex1) == USER_PL &&
-	    p->pc < PAGE_OFFSET &&
-	    p->sp < PAGE_OFFSET) {
+		   p->sp < PAGE_OFFSET && p->sp != 0) {
 		if (kbt->verbose)
 			pr_err("  <%s while in user mode>\n", fault);
 	} else if (kbt->verbose) {
@@ -352,6 +351,26 @@ static void describe_addr(struct KBacktraceIterator *kbt,
 }
 
 /*
+ * Avoid possible crash recursion during backtrace.  If it happens, it
+ * makes it easy to lose the actual root cause of the failure, so we
+ * put a simple guard on all the backtrace loops.
+ */
+static bool start_backtrace(void)
+{
+	if (current->thread.in_backtrace) {
+		pr_err("Backtrace requested while in backtrace!\n");
+		return false;
+	}
+	current->thread.in_backtrace = true;
+	return true;
+}
+
+static void end_backtrace(void)
+{
+	current->thread.in_backtrace = false;
+}
+
+/*
  * This method wraps the backtracer's more generic support.
  * It is only invoked from the architecture-specific code; show_stack()
  * and dump_stack() (in entry.S) are architecture-independent entry points.
@@ -361,6 +380,8 @@ void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
 	int i;
 	int have_mmap_sem = 0;
 
+	if (!start_backtrace())
+		return;
 	if (headers) {
 		/*
 		 * Add a blank line since if we are called from panic(),
@@ -402,6 +423,7 @@ void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
 		pr_err("Stack dump complete\n");
 	if (have_mmap_sem)
 		up_read(&kbt->task->mm->mmap_sem);
+	end_backtrace();
 }
 EXPORT_SYMBOL(tile_show_stack);
 
@@ -463,6 +485,8 @@ void save_stack_trace_tsk(struct task_struct *task, struct stack_trace *trace)
 	int skip = trace->skip;
 	int i = 0;
 
+	if (!start_backtrace())
+		goto done;
 	if (task == NULL || task == current)
 		KBacktraceIterator_init_current(&kbt);
 	else
@@ -476,6 +500,8 @@ void save_stack_trace_tsk(struct task_struct *task, struct stack_trace *trace)
 			break;
 		trace->entries[i++] = kbt.it.pc;
 	}
+	end_backtrace();
+done:
 	trace->nr_entries = i;
 }
 EXPORT_SYMBOL(save_stack_trace_tsk);
-- 
1.8.3.1

