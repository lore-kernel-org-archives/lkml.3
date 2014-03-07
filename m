Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaCGBCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:02:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53409 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaCGBCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:02:02 -0500
Date: Thu, 6 Mar 2014 17:01:27 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-2223f6f6eeaad6ea0a3acd3f4bc1ae45e8117ddc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        brgerst@gmail.com, peterz@infradead.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, peterz@infradead.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20140206144322.086050042@goodmis.org>
References: <20110806012354.684598995@goodmis.org>
	<20140206144322.086050042@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/threadinfo] x86: Clean up dumpstack_64.c code
Git-Commit-ID: 2223f6f6eeaad6ea0a3acd3f4bc1ae45e8117ddc
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

Commit-ID:  2223f6f6eeaad6ea0a3acd3f4bc1ae45e8117ddc
Gitweb:     http://git.kernel.org/tip/2223f6f6eeaad6ea0a3acd3f4bc1ae45e8117ddc
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 6 Feb 2014 09:41:32 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 6 Mar 2014 16:56:55 -0800

x86: Clean up dumpstack_64.c code

The dump_trace() function in dumpstack_64.c is hard to follow.
The test for exception stack is processed differently than the
test for irq stack, and the normal stack is outside completely.

By restructuring this code to have all the stacks determined by
a single function that returns an enum of the following:

 STACK_IS_NORMAL
 STACK_IS_EXCEPTION
 STACK_IS_IRQ
 STACK_IS_UNKNOWN

and has the logic of each within a switch statement.
This should make the code much easier to read and understand.

Link: http://lkml.kernel.org/r/20110806012354.684598995@goodmis.org

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140206144322.086050042@goodmis.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/dumpstack_64.c | 117 +++++++++++++++++++++++++++++------------
 1 file changed, 83 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index addb207..346b1df 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -104,6 +104,45 @@ in_irq_stack(unsigned long *stack, unsigned long *irq_stack,
 	return (stack >= irq_stack && stack < irq_stack_end);
 }
 
+static const unsigned long irq_stack_size =
+	(IRQ_STACK_SIZE - 64) / sizeof(unsigned long);
+
+enum stack_type {
+	STACK_IS_UNKNOWN,
+	STACK_IS_NORMAL,
+	STACK_IS_EXCEPTION,
+	STACK_IS_IRQ,
+};
+
+static enum stack_type
+analyze_stack(int cpu, struct task_struct *task,
+	      unsigned long *stack, unsigned long **stack_end, char **id)
+{
+	unsigned long *irq_stack;
+	unsigned long addr;
+	unsigned used = 0;
+
+	addr = ((unsigned long)stack & (~(THREAD_SIZE - 1)));
+	if ((unsigned long)task_stack_page(task) == addr)
+		return STACK_IS_NORMAL;
+
+	*stack_end = in_exception_stack(cpu, (unsigned long)stack,
+					 &used, id);
+	if (*stack_end)
+		return STACK_IS_EXCEPTION;
+
+	*stack_end = (unsigned long *)per_cpu(irq_stack_ptr, cpu);
+	if (!*stack_end)
+		return STACK_IS_UNKNOWN;
+
+	irq_stack = *stack_end - irq_stack_size;
+
+	if (in_irq_stack(stack, irq_stack, *stack_end))
+		return STACK_IS_IRQ;
+
+	return STACK_IS_UNKNOWN;
+}
+
 /*
  * x86-64 can have up to three kernel stacks:
  * process stack
@@ -116,12 +155,11 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		const struct stacktrace_ops *ops, void *data)
 {
 	const unsigned cpu = get_cpu();
-	unsigned long *irq_stack_end =
-		(unsigned long *)per_cpu(irq_stack_ptr, cpu);
-	unsigned used = 0;
 	struct thread_info *tinfo;
-	int graph = 0;
+	unsigned long *irq_stack;
 	unsigned long dummy;
+	int graph = 0;
+	int done = 0;
 
 	if (!task)
 		task = current;
@@ -143,49 +181,60 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	 * exceptions
 	 */
 	tinfo = task_thread_info(task);
-	for (;;) {
+	while (!done) {
+		unsigned long *stack_end;
+		enum stack_type stype;
 		char *id;
-		unsigned long *estack_end;
-		estack_end = in_exception_stack(cpu, (unsigned long)stack,
-						&used, &id);
 
-		if (estack_end) {
+		stype = analyze_stack(cpu, task, stack, &stack_end, &id);
+
+		/* Default finish unless specified to continue */
+		done = 1;
+
+		switch (stype) {
+
+		/* Break out early if we are on the thread stack */
+		case STACK_IS_NORMAL:
+			break;
+
+		case STACK_IS_EXCEPTION:
+
 			if (ops->stack(data, id) < 0)
 				break;
 
 			bp = ops->walk_stack(tinfo, stack, bp, ops,
-					     data, estack_end, &graph);
+					     data, stack_end, &graph);
 			ops->stack(data, "<EOE>");
 			/*
 			 * We link to the next stack via the
 			 * second-to-last pointer (index -2 to end) in the
 			 * exception stack:
 			 */
-			stack = (unsigned long *) estack_end[-2];
-			continue;
-		}
-		if (irq_stack_end) {
-			unsigned long *irq_stack;
-			irq_stack = irq_stack_end -
-				(IRQ_STACK_SIZE - 64) / sizeof(*irq_stack);
-
-			if (in_irq_stack(stack, irq_stack, irq_stack_end)) {
-				if (ops->stack(data, "IRQ") < 0)
-					break;
-				bp = ops->walk_stack(tinfo, stack, bp,
-					ops, data, irq_stack_end, &graph);
-				/*
-				 * We link to the next stack (which would be
-				 * the process stack normally) the last
-				 * pointer (index -1 to end) in the IRQ stack:
-				 */
-				stack = (unsigned long *) (irq_stack_end[-1]);
-				irq_stack_end = NULL;
-				ops->stack(data, "EOI");
-				continue;
-			}
+			stack = (unsigned long *) stack_end[-2];
+			done = 0;
+			break;
+
+		case STACK_IS_IRQ:
+
+			if (ops->stack(data, "IRQ") < 0)
+				break;
+			bp = ops->walk_stack(tinfo, stack, bp,
+				     ops, data, stack_end, &graph);
+			/*
+			 * We link to the next stack (which would be
+			 * the process stack normally) the last
+			 * pointer (index -1 to end) in the IRQ stack:
+			 */
+			stack = (unsigned long *) (stack_end[-1]);
+			irq_stack = stack_end - irq_stack_size;
+			ops->stack(data, "EOI");
+			done = 0;
+			break;
+
+		case STACK_IS_UNKNOWN:
+			ops->stack(data, "UNK");
+			break;
 		}
-		break;
 	}
 
 	/*
