Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaBFOou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:44:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:45892 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753904AbaBFOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:43:24 -0500
Message-Id: <20140206144322.086050042@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Feb 2014 09:41:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brian Gerst <brgerst@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/5] x86: Clean up dumpstack_64.c code
References: <20140206144127.181568017@goodmis.org>
Content-Disposition: inline; filename=0005-x86-Clean-up-dumpstack_64.c-code.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

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
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
-- 
1.8.4.3


