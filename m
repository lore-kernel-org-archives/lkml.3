Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaCGBBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:01:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53398 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaCGBBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:01:50 -0500
Date: Thu, 6 Mar 2014 17:01:05 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-0788aa6a23cb9d693fc5040ec774b979f1e906cd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        brgerst@gmail.com, peterz@infradead.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com, rric@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, peterz@infradead.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com, rric@kernel.org
In-Reply-To: <20140206144321.608754481@goodmis.org>
References: <20110806012353.891757693@goodmis.org>
	<20140206144321.608754481@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/threadinfo] x86:
  Prepare removal of previous_esp from i386 thread_info structure
Git-Commit-ID: 0788aa6a23cb9d693fc5040ec774b979f1e906cd
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

Commit-ID:  0788aa6a23cb9d693fc5040ec774b979f1e906cd
Gitweb:     http://git.kernel.org/tip/0788aa6a23cb9d693fc5040ec774b979f1e906cd
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 6 Feb 2014 09:41:30 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 6 Mar 2014 16:56:54 -0800

x86: Prepare removal of previous_esp from i386 thread_info structure

The i386 thread_info contains a previous_esp field that is used
to daisy chain the different stacks for dump_stack()
(ie. irq, softirq, thread stacks).

The goal is to eventual make i386 handling of thread_info the same
as x86_64, which means that the thread_info will not be in the stack
but as a per_cpu variable. We will no longer depend on thread_info
being able to daisy chain different stacks as it will only exist
in one location (the thread stack).

By moving previous_esp to the end of thread_info and referencing
it as an offset instead of using a thread_info field, this becomes
a stepping stone to moving the thread_info.

The offset to get to the previous stack is rather ugly in this
patch, but this is only temporary and the prev_esp will be changed
in the next commit. This commit is more for sanity checks of the
change.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Robert Richter <rric@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20110806012353.891757693@goodmis.org
Link: http://lkml.kernel.org/r/20140206144321.608754481@goodmis.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/thread_info.h |  5 +++--
 arch/x86/kernel/dumpstack_32.c     | 11 ++++++++++-
 arch/x86/kernel/irq_32.c           | 15 +++++++++++----
 arch/x86/kernel/ptrace.c           |  8 ++++----
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 1cb3501..ca2de1b 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -32,13 +32,14 @@ struct thread_info {
 	mm_segment_t		addr_limit;
 	struct restart_block    restart_block;
 	void __user		*sysenter_return;
+	unsigned int		sig_on_uaccess_error:1;
+	unsigned int		uaccess_err:1;	/* uaccess failed */
 #ifdef CONFIG_X86_32
 	unsigned long           previous_esp;   /* ESP of the previous stack in
 						   case of nested (IRQ) stacks
+						   (Moved to end, to be removed soon)
 						*/
 #endif
-	unsigned int		sig_on_uaccess_error:1;
-	unsigned int		uaccess_err:1;	/* uaccess failed */
 };
 
 #define INIT_THREAD_INFO(tsk)			\
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index f2a1770..187d6a7 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -22,6 +22,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		const struct stacktrace_ops *ops, void *data)
 {
 	int graph = 0;
+	u32 *prev_esp;
 
 	if (!task)
 		task = current;
@@ -44,9 +45,17 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			((unsigned long)stack & (~(THREAD_SIZE - 1)));
 		bp = ops->walk_stack(context, stack, bp, ops, data, NULL, &graph);
 
-		stack = (unsigned long *)context->previous_esp;
+		/* Stop if not on irq stack */
+		if (task_stack_page(task) == context)
+			break;
+
+		/* The previous esp is just above the context */
+		prev_esp = (u32 *) ((char *)context + sizeof(struct thread_info) -
+				    sizeof(long));
+		stack = (unsigned long *)*prev_esp;
 		if (!stack)
 			break;
+
 		if (ops->stack(data, "IRQ") < 0)
 			break;
 		touch_nmi_watchdog();
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index d7fcbed..f135cc2 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -81,7 +81,7 @@ static inline int
 execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 {
 	union irq_ctx *curctx, *irqctx;
-	u32 *isp, arg1, arg2;
+	u32 *isp, *prev_esp, arg1, arg2;
 
 	curctx = (union irq_ctx *) current_thread_info();
 	irqctx = __this_cpu_read(hardirq_ctx);
@@ -98,7 +98,10 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 	/* build the stack frame on the IRQ stack */
 	isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
 	irqctx->tinfo.task = curctx->tinfo.task;
-	irqctx->tinfo.previous_esp = current_stack_pointer;
+	/* Save the next esp after thread_info */
+	prev_esp = (u32 *) ((char *)irqctx + sizeof(struct thread_info) -
+			    sizeof(long));
+	*prev_esp = current_stack_pointer;
 
 	if (unlikely(overflow))
 		call_on_stack(print_stack_overflow, isp);
@@ -149,16 +152,20 @@ void do_softirq_own_stack(void)
 {
 	struct thread_info *curctx;
 	union irq_ctx *irqctx;
-	u32 *isp;
+	u32 *isp, *prev_esp;
 
 	curctx = current_thread_info();
 	irqctx = __this_cpu_read(softirq_ctx);
 	irqctx->tinfo.task = curctx->task;
-	irqctx->tinfo.previous_esp = current_stack_pointer;
 
 	/* build the stack frame on the softirq stack */
 	isp = (u32 *) ((char *)irqctx + sizeof(*irqctx));
 
+	/* Push the previous esp onto the stack */
+	prev_esp = (u32 *) ((char *)irqctx + sizeof(struct thread_info) -
+			    sizeof(long));
+	*prev_esp = current_stack_pointer;
+
 	call_on_stack(__do_softirq, isp);
 }
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 7461f50..f352a7c 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -184,14 +184,14 @@ unsigned long kernel_stack_pointer(struct pt_regs *regs)
 {
 	unsigned long context = (unsigned long)regs & ~(THREAD_SIZE - 1);
 	unsigned long sp = (unsigned long)&regs->sp;
-	struct thread_info *tinfo;
+	u32 *prev_esp;
 
 	if (context == (sp & ~(THREAD_SIZE - 1)))
 		return sp;
 
-	tinfo = (struct thread_info *)context;
-	if (tinfo->previous_esp)
-		return tinfo->previous_esp;
+	prev_esp = (u32 *)(context + sizeof(struct thread_info) - sizeof(long));
+	if (prev_esp)
+		return (unsigned long)prev_esp;
 
 	return (unsigned long)regs;
 }
